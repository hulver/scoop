package Scoop;
use strict;
use LWP::UserAgent;

my $DEBUG = 0;

sub trackback_handler {
	my $S = shift;
	my $target = $S->cgi->param('target');
	my $ping = { };
	my $vars = $S->cgi->Vars();
	my $errorcount = 0;
	my @error;
 
	foreach my $k (keys %{$vars}) {
		warn "$k: $vars->{$k}\n" if ($DEBUG);
	}
	$vars->{id} = $target;
	unless ($vars->{url}) {
		push @error, "No url passed";
	}
	unless ($vars->{blog_name}) {
		push @error, "No blog_name passed\n";
	}
	unless ($vars->{title}) {
		push @error, "No title passed\n";
	}
	unless ($vars->{excerpt}) {
		push @error, "No excerpt passed";
	}
	my $result = qq{<?xml version="1.0" encoding="iso-8859-1"?>
<response>
<error>};
	if (@error) {
		$result .= qq{1</error>
<message>};
		foreach my $msg (@error) {
			$result .= $msg . "\n";
			warn "$msg" if $DEBUG;
		}
		$result .= "</message>\n";
	} else {
		$result .= "0</error>\n";
		$S->handle_pings($vars);
	}
	$result .= "</response>";

	return $result;
} 

sub handle_pings {
	my $S = shift;
	my $data = shift;
	
	# Make it possible to do more than one thing with a ping
	# Default behavior is to post as a comment
	my $type = $S->cgi->param('type') || 'comment';
	
	$S->log_trackback($data);
	#$S->post_trackback_comment($data) if ($type eq 'comment');
}

sub log_trackback {
	my $S = shift;
	my $data = shift;
	# log a trackback into a trackback table
	$S->db_insert({ INTO => 'trackback',
		COLS => 'sid, url, blog_name, title, excerpt, time',
		VALUES => '?, ?, ?, ?, ?, NOW()',
		PARAMS => [$data->{id}, $data->{url}, $data->{blog_name}, $data->{title}, $data->{excerpt}]
		});
}
 
sub post_trackback_comment {
	my $S = shift;
	my $data = shift;
		
	# post_comment() takes in cgi params, so set those up
	my $sid = $data->{id};
	# Trackback munges this for some reason. unmunge.
	$sid =~ s/_/\//g;	
	$S->{PARAMS}->{uid} = $S->{UI}->{VARS}->{trackback_user} || -1;
	
	# Fake the uid for post_comment
	#if ($S->{PARAMS}->{uid} != -1) { 
		$S->{UID} = $S->{PARAMS}->{uid};
	#};
	my $user_data = $S->user_data($S->{UID});
	
	# Check for trackback perm
	return unless ($S->have_perm('trackback', $user_data->{perm_group}));
	
	my $old_uid = $S->{UID};
	my $old_gid = $S->{GID};
	my $old_perms = $S->{PERMS};
	$S->{PARAMS}->{sid} = $sid;
	$S->{GID} = $user_data->{perm_group};
	$S->{PERMS} = $S->group_perms( $S->{GID} );
	
	# This is a default "link" element. To make your own, you can use
	# the other elements of $data
	$data->{link} = ($data->{blog_name}) ? 
	qq|<a href="$data->{url}">Read more at $data->{blog_name}</a>| :
	qq|<a href="$data->{url}">Read more at $data->{url}</a>|;
	
	$data->{title} ||= $data->{url};
	
	my $comment = $S->{UI}->{BLOCKS}->{trackback_comment_template} || qq{<p>%%excerpt%%</p><p>%%link%%</p>};
	my $title   = $S->{UI}->{BLOCKS}->{trackback_title_template} || qq{Trackback: %%title%%};
	
	# Noteworthy keys: url, blog_name, excerpt, title 
	# "title" == "url" if no title received
	foreach my $key (keys %{$data}) {
		$comment =~ s/%%$key%%/$data->{$key}/g;
		$title =~ s/%%$key%%/$data->{$key}/g;
	}
	
	$S->{PARAMS}->{comment} = $comment;
	$S->{PARAMS}->{subject} = $title;
	
	$S->{PARAMS}->{posttype} = 'html';
	
	# I guess that's everything. Now call post_comment() which
	# should process all of it.
	$S->post_comment();
	
	$S->{UID} = $old_uid;
	$S->{GID} = $old_gid;
	$S->{PERMS} = $old_perms;
	return;
}

sub discover_tb {
	my $S = shift;
	my $url = shift;
	my $ua = LWP::UserAgent->new;
	my $us_string = $S->{UI}->{VARS}->{site_url};
	warn "discover_tb: $url" if $DEBUG;
	$ua->agent('Scoop TrackBack/1.0 (' . $us_string . ')');  
	$ua->parse_head(0);   ## So we don't need HTML::HeadParser

        my $proxy = $S->{UI}->{VARS}->{rdf_http_proxy};
        $ua->proxy(http => $proxy) if $proxy;

        my $timeout = $S->{UI}->{VARS}->{rdf_fetch_timeout} || '60';
        $ua->timeout($timeout);

	$ua->max_size(1024 * 100);  ## 100k max response size

	## 1. Send a GET request to retrieve the page contents.
	my $req = HTTP::Request->new(GET => $url);
	my $res = $ua->request($req);
	return unless $res->is_success;

	## 2. Scan te page contents for embedded RDF.
	my $c = $res->content;
	(my $url_no_anchor = $url) =~ s/#.*$//;
	my $item;
	while ($c =~ m!(<rdf:RDF.*?</rdf:RDF>)!sg) {
		my $rdf = $1;
		my($perm_url) = $rdf =~ m!dc:identifier="([^"]+)"!;  
		next unless lc($perm_url) eq lc($url) || lc($perm_url) eq lc($url_no_anchor);
		## 3. Extract the trackback:ping value from the RDF.
		## We look for 'trackback:ping', but fall back to 'about'
		if ($rdf =~ m!trackback:ping="([^"]+)"!) {
			return $1;
		} elsif ($rdf =~ m!about="([^"]+)"!) {
			return $1;
		}
	}
}

sub send_ping {
	my $S = shift;
	my $ping_url = shift;
	my $args = shift;
	my $ua = LWP::UserAgent->new;
	my $us_string = $S->{UI}->{VARS}->{site_url};
	warn "send_ping: $ping_url" if $DEBUG;
	$ua->agent('Scoop TrackBackPing/1.0 (' . $us_string . ')');  
	$ua->parse_head(0);   ## So we don't need HTML::HeadParser
        my $proxy = $S->{UI}->{VARS}->{rdf_http_proxy};
        $ua->proxy(http => $proxy) if $proxy;

        my $timeout = $S->{UI}->{VARS}->{rdf_fetch_timeout} || '60';
        $ua->timeout($timeout);

	my @qs = map $_ . '=' . $S->urlify($args->{$_} || ''),
	         qw( title url excerpt blog_name );
	my $req;
	if ($ping_url =~ /\?/) {
	    $req = HTTP::Request->new(GET => $ping_url . '&' . join('&', @qs));
	} else {
	    $req = HTTP::Request->new(POST => $ping_url);
	    $req->content_type('application/x-www-form-urlencoded');
	    $req->content(join('&', @qs));
	}
	my $res = $ua->request($req);
	return unless $res->is_success;
}

1;
