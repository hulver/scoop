
=head1 Amazon.pm

Function in this file deal with the display of Amazon adverts.
Maybe searches and Web Services as well.

=head1 AUTHOR

Matthew Collins B<hulver@janes.demon.co.uk>

=head1 Functions

What follows is a bit of pod in front of the core functions, if they
are not documented here in pod, then they probably are with normal
hash-style comments, and they aren't essential to using the api.
=cut

package Scoop;

use strict;
use Net::Amazon;
use Net::Amazon::Request::ASIN;
use Net::Amazon::Attribute::ReviewSet;
use Net::Amazon::Attribute::Review;
#use Data::Dumper;
#use Log::Log4perl qw(:easy);
#use Geo::IP;

my $SCOOP_DEBUG = 0;

=over 4

=item *
amazon_country($allow_all)

Returns the users choice of country. If $allow_all is True, then a value
of "All" might be returned if the user has selected it in their preferences.
Otherwise the best matching users country is returned. For users who have
select "All" when $allow_all is False and whose detected country is not
a country we support, the var amazon_default_country will be returned.

=cut

sub amazon_country {
	my $S = shift;
	my $allow_all = shift || 0;

	my $SCOOP_DEBUG = 0;
	
	warn "amazon_country: allow_all : $allow_all" if $SCOOP_DEBUG;

	my $show = $S->{prefs}->{amazon_default} || 'Default';
	warn "amazon_country: show : $show" if $SCOOP_DEBUG;

	$show = 'All' if ($show eq 'Both');

	if (($show eq 'Default') || ($show eq 'All' && !$allow_all)) {
#		my $gi = Geo::IP->new(GEOIP_STANDARD);
#		$show = $gi->country_code_by_addr($S->{REMOTE_IP});
		$show = 'UK' if ($show eq 'GB');
		if (not ($show =~ /(UK|US|CA|DE|FR)/)) {
			$show = 'All' if ($allow_all);
			$show = ($S->{UI}->{VARS}->{amazon_default_country} || 'US') unless ($allow_all);
		};
	}

	return $show;	
}

=item *
get_amazon_mode ($catalog, $country)

Returns a correct mode string depending on the Catalog identifier passed.
Mode strings vary by country, so that must be passed to.
Some modes are not available in specific countrys, so mode for those
will return a blank.

=cut

sub get_amazon_mode {
	my $S = shift;
	my $catalog = shift;
	my $country = shift;
	my $retval;

	$retval = 'books' if ($catalog eq 'Book');
	$retval = 'music' if ($catalog eq 'Music');
	$retval = 'dvd' if ($catalog eq 'DVD');
	$retval = 'vhs' if ($catalog eq 'Video');
	$retval = 'electronics' if ($catalog eq 'Electronics');
	$retval = 'kitchen' if ($catalog eq 'Kitchen');
	$retval = 'software' if ($catalog eq 'Software');
	$retval = 'videogames' if ($catalog eq 'Video Games');
	$retval = 'magazines' if ($catalog eq 'Magazine');
	$retval = 'toys' if ($catalog eq 'Toy');
	$retval = 'baby' if ($catalog eq 'Baby Product');
	$retval = 'tools' if ($catalog eq 'Home Improvement');
#	$retval = 'photo' if ($catalog eq ''); # Electronics
#	$retval = 'garden' if ($catalog eq ''); # Same as Kitchen
#	$retval = 'classical' if ($catalog eq ''); #no way to tell from catalog!
#	$retval = 'pc-hardware' if ($catalog eq ''); # Electronics

	if (lc($country) eq 'uk') {
		$retval = 'books-uk' if ($retval eq 'books');
		$retval = 'dvd-uk' if ($retval eq 'dvd');
		$retval = 'vhs-uk' if ($retval eq 'vhs');
		$retval = 'electronics-uk' if ($retval eq 'electronics');
		$retval = 'kitchen-uk' if ($retval eq 'kitchen');
		$retval = 'software-uk' if ($retval eq 'software');
		$retval = 'video-games-uk' if ($retval eq 'videogames');
		$retval = 'tools-uk' if ($retval eq 'tools');
		$retval = '' if (
			$retval eq 'toys' ||
			$retval eq 'magazines' ||
			$retval eq 'photo' ||
			$retval eq 'garden' ||
			$retval eq 'baby' ||
			$retval eq 'pc-hardware');
	} elsif (lc($country) eq 'ca') {
		$retval = 'music-ca' if ($retval eq 'music');
		$retval = 'clasical-ca' if ($retval eq 'clasical');
		$retval = 'dvd-ca' if ($retval eq 'dvd');
		$retval = 'vhs-ca' if ($retval eq 'vhs');
		$retval = 'software-ca' if ($retval eq 'software');
		$retval = 'video-games-ca' if ($retval eq 'videogames');
		$retval = '' if (
			$retval eq 'toys' ||
			$retval eq 'magazines' ||
			$retval eq 'photo' ||
			$retval eq 'garden' ||
			$retval eq 'electronics' ||
			$retval eq 'kitchen' ||
			$retval eq 'baby' ||
			$retval eq 'pc-hardware' ||
			$retval eq 'tools');
	} elsif (lc($country) eq 'de') {
		$retval = 'pop-music-de' if ($retval eq 'music');
		$retval = 'books-de-intl-us' if ($retval eq 'books');
		$retval = 'clasical-de' if ($retval eq 'clasical');
		$retval = 'dvd-de' if ($retval eq 'dvd');
		$retval = 'vhs-de' if ($retval eq 'vhs');
		$retval = 'ce-de' if ($retval eq 'electronics');
		$retval = 'kitchen-de' if ($retval eq 'kitchen');
		$retval = 'software-de' if ($retval eq 'software');
		$retval = 'video-games-de' if ($retval eq 'videogames');
		$retval = 'tools-uk' if ($retval eq 'tools');
		$retval = 'magazines-de' if ($retval eq 'magazines');
		$retval = '' if (
			$retval eq 'toys' ||
			$retval eq 'tools' ||
			$retval eq 'photo' ||
			$retval eq 'garden' ||
			$retval eq 'baby');
	} elsif (lc($country) eq 'fr') {
		$retval = 'books-fr-intl-us' if ($retval eq 'books');
		$retval = 'music-fr' if ($retval eq 'music');
		$retval = 'clasical-fr' if ($retval eq 'clasical');
		$retval = 'dvd-fr' if ($retval eq 'dvd');
		$retval = 'vhs-fr' if ($retval eq 'vhs');
		$retval = 'electronics-uk' if ($retval eq 'electronics');
		$retval = 'sw-vg-fr' if ($retval eq 'software');
		$retval = 'video-games-fr' if ($retval eq 'videogames');
		$retval = '' if (
			$retval eq 'toys' ||
			$retval eq 'tools' ||
			$retval eq 'magazines' ||
			$retval eq 'kitchen' ||
			$retval eq 'photo' ||
			$retval eq 'garden' ||
			$retval eq 'baby');
	} else {
		$retval = '' unless (lc($country) eq 'us');
	}
	return $retval;
}

sub find_amazon_links {
	my $S = shift;
	my $sid = shift;
	my $text = shift;

        my @asins;

        while ( $text =~ /(<a *?href="?.*?>)/gis ) {
                my $start = $1;
                $start =~ s/<A *?HREF="?(.*?)"?>/$1/is;
                if ($start =~ /\.amazon\./i) {
                        my $asin;
                        if ($start =~ /\/obidos\/tg\/detail\/-\/(\w{10})/gis) {
                                $asin = $1;
                        } elsif ($start =~ /\/obidos\/ASIN\/(\w{10})/gis) {
                                $asin = $1;
                        } elsif ($start =~ /tg\/sim-explorer\/explore-items\/-\/(\w{10})/gis) {
                                $asin = $1;
                        } elsif ($start =~ /\/dp\/(\w{10})/gis) {
                                $asin = $1;
                        } elsif ($start =~ /\/gp\/product\/(\w{10})/gis) {
                                $asin = $1;
                        } elsif ($start =~ /ASIN%2F(\w{10})/gis) {
                                $asin = $1;
                        } elsif ($start =~ /ASIN\/(\w{10})/gis) {
                                $asin = $1;
                        }
                        if ($asin) {
                                my $site = $start;
                                $site =~ s#http://([^/]*).*/.*#$1#is;
                                warn "find_amazon_links: $sid $site $asin\n" if $SCOOP_DEBUG;
                                my @entry = [$sid, $site, $asin];
                                push @asins, @entry;
                        }
                }
        }

        # read in site_ids hash.
        my %site_ids;
	my ($rv, $sth) = $S->db_select({
				WHAT => 'site_id, site_url',
				FROM => 'amazon_sites'});

	while (my $sites = $sth->fetchrow_hashref()) {
                $site_ids{$sites->{site_url}} = $sites->{site_id};
        }
	$sth->finish();

        my $sid_update;
        my %sids;
        my @updates;

        foreach my $entry (@asins) {
                my $sid = $entry->[0];
                my $site_url = $entry->[1];
                my $site_id = $site_ids{$site_url};
                my $asin = $entry->[2];

                my ($prod_id, $local_id) = $S->product_id($asin, $site_id);
                push (@updates, [$sid, $prod_id]);

                $sids{$sid} ++;
                if ($sids{$sid} <= 1) {
                        $sid_update .= ', ' if ($sid_update);
                        $sid_update .= $S->{DBH}->quote($entry->[0]);
                }
        }

        if ($sid_update) {
		($rv, $sth) = $S->db_delete({
				FROM => 'amazon_story',
				WHERE => "sid in ($sid_update)"});
        }

	undef $sth;
        if (@updates) {
		my %trackbacks;
                foreach my $entry (@updates) {
                        my $sid = $entry->[0];
                        my $prod_id = $entry->[1];
			if ($sth) {
				$sth->execute($sid, $prod_id);
			} else {
				($rv, $sth) = $S->db_insert({
					INTO => 'amazon_story',
					VALUES => '?, ?',
					PARAMS => [$sid, $prod_id]});
			}
			if ($trackbacks{$sid}) {
				push(@{$trackbacks{$sid}},$prod_id);
			} else {
				$trackbacks{$sid} = [$prod_id];
			}
		}
		foreach my $sid (keys %trackbacks) {
			my $temp = $trackbacks{$sid};
			my $stories = $S->getstories(
			 {-type => 'fullstory',
			   -sid => $sid,
			   -perm_override => 1});
			my $story;
			if ($stories) {
			  $story = $stories->[0];
			} else {
			  return 0;
			}
			warn "Processing trackbacks from $sid\n" if $SCOOP_DEBUG;

			my $nick = $S->get_nick_from_uid($story->{aid});

			my $excerpt = $story->{introtext} . '<br>' . $story->{bodytext};

			my $max_intro = $S->{UI}->{VARS}->{rdf_max_intro} || 50;
			if ($max_intro) {
				my @intro = split(' ', $excerpt);
				@intro = splice(@intro, 0, $max_intro);
				$excerpt = join(' ', @intro) . '...';
			}
			$excerpt =~ s/<[p|br]>/\n/g; #preserve line & para breaks
			$excerpt =~ s/<.*?>//g;
			# unfilter < and >, so that we don't turn them into &amp;lt;
			$excerpt =~ s/&lt;/</g;
			$excerpt =~ s/&gt;/>/g;
			# filter &
			$excerpt =~ s/&/&amp;/g;
			# (re-)filter < and >
			$excerpt =~ s/</&lt;/g;
			$excerpt =~ s/>/&gt;/g;
			# Filter out high-bit characters
			$excerpt =~ s/([\200-\377])/"&#".ord($1).";"/eg;
			$excerpt =~ s/\n/<br>\n/g;

			my $url = $S->{UI}->{VARS}->{site_url} . $S->{UI}->{VARS}->{rootdir} . "/story/$sid";
			my $blog_name = $nick . ' from ' . $S->{UI}->{VARS}->{sitename};

			foreach my $prod_id (@{$temp}) {
				my $prod_sid = $S->product_sid($prod_id);
				warn "Got product sid $prod_sid for ID: $prod_id\n" if $SCOOP_DEBUG;
        my ($rv, $sth) = $S->db_select({ WHAT => 'COUNT(track_id)',
                                         FROM => 'trackback',
                                         WHERE => 'url = ?',
                                         PARAMS => [$url]});
        my $count = $sth->fetchrow();
        $sth->finish();
        if ($count == 0) {
  				$S->db_insert({ INTO => 'trackback',
                					DEBUG => $SCOOP_DEBUG,
          				        COLS => 'sid, url, blog_name, title, excerpt, time',
          				        VALUES => '?, ?, ?, ?, ?, NOW()',
    			                PARAMS => [$prod_sid, $url, $blog_name, $story->{title}, $excerpt] });
        }
      }
    }
  }
}

sub product_sid {
	my $S = shift;
	my $prod_id = shift;
	my $retval;

	my ($rv, $sth) = $S->db_select({
		WHAT => 'sid',
		FROM => 'amazon_prod',
		WHERE => 'prod_id = ?',
		PARAMS => [$prod_id]});
	if ($rv) {
		$retval = $sth->fetchrow();
	}
	$sth->finish();
	return $retval;
}

sub product_id {
	my $S = shift;
        my $asin = shift;
        my $site_id = shift;
        my $retval = 0;
        my $local_id = 0;

	my ($rv, $sth) = $S->db_select({
		WHAT => 'prod_id, local_id',
		FROM => 'amazon_local',
		WHERE => 'site_id = ? and asin = ?',
		PARAMS => [$site_id, $asin]});

        ($retval, $local_id) = $sth->fetchrow() if ($rv);

        $retval = $S->add_blank_product unless($retval);
        $local_id = $S->add_local_product ($retval, $asin, $site_id) unless ($local_id);
        return ($retval, $local_id);
}

sub make_amazon_story {
	my $S = shift;
	my $sid = $S->make_new_sid();
	my $q_sid = $S->{DBH}->quote($sid);
	my $aid = $S->{UI}->{VARS}->{amazon_story_uid};
	my $section = $S->{DBH}->quote($S->{UI}->{VARS}->{amazon_story_section});
	my $introtext = "%%BOX,amazon_story_intro,$sid%%";
	my $bodytext = "%%BOX,amazon_story_body,$sid%%";
	$introtext = $S->{DBH}->quote($introtext);
	$bodytext = $S->{DBH}->quote($bodytext);

	my $time = $S->dbh->quote( $S->_current_time() );
	my ($rv, $sth) = $S->db_insert({
		DEBUG => 0,
		INTO => 'stories',
		COLS => 'sid, tid, aid, title, dept, time, introtext, bodytext, section, displaystatus, commentstatus',
		VALUES => qq|$q_sid, "", "$aid", "", "", $time, $introtext, $bodytext, $section, -1, 0|});

	return $sid;
}

sub add_blank_product {
	my $S = shift;
	my $retval;
	my $sid = $S->{DBH}->quote($S->make_amazon_story());
	my ($rv, $sth) = $S->db_insert({
		COLS => 'prod_id, product_name, sid',
		VALUES => "0, 'UNKNOWN', $sid",
		INTO => 'amazon_prod'});
	if ($rv) {
	        $sth = $S->{DBH}->prepare('SELECT LAST_INSERT_ID()');
	        $sth->execute();
        	$retval = $sth->fetchrow();
	}
}

sub add_local_product {
	my $S = shift;
        my $prod_id = shift;
        my $asin = shift;
        my $site_id = shift;
	my $retval;

	my ($rv, $sth) = $S->db_insert({
		COLS => 'local_id, prod_id, asin, site_id, need_update',
		VALUES => '0, ?, ?, ?, 1',
		INTO => 'amazon_local',
		PARAMS => [$prod_id, $asin, $site_id]});

	if ($rv) {
	        $sth = $S->{DBH}->prepare('SELECT LAST_INSERT_ID()');
	        $sth->execute();
        	$retval = $sth->fetchrow();
	}
}

sub amazon_update_cron {
	my $S = shift;
	my ($rv, $sth) = $S->db_select({ WHAT => qq|l.local_id, l.prod_id, l.asin,
                        	s.associate_id, s.country_code,
	                        s.automatic_update|,
			ORDER_BY => 'l.site_id',
			FROM => 'amazon_local l, amazon_sites s',
			WHERE => 'l.site_id = s.site_id and l.need_update = 1',
			DEBUG => 0});

	if ($rv) {
	        my $items = $sth->fetchall_arrayref();
		$S->update_items($items);
	}
	$sth->finish();
	return 1;
}

sub amazon_check_single {
	my $S = shift;
	my $asin = shift;
	my ($rv, $sth) = $S->db_select({ WHAT => qq|l.local_id, l.prod_id, l.asin,
                       	s.associate_id, s.country_code, s.automatic_update|,
			ORDER_BY => 'l.site_id',
			FROM => 'amazon_local l, amazon_sites s',
			WHERE => qq|l.asin = ? and l.site_id = s.site_id
				 and ((UNIX_TIMESTAMP() - UNIX_TIMESTAMP(l.price_date) > 86350) or (l.need_update = 1))|,
			PARAMS => [$asin],
			DEBUG => 0});

	$rv = 0 if ($rv eq '0E0');	
	if ($rv) {
		warn "amazon_check_single: $asin needs updating ($rv)\n" if $SCOOP_DEBUG;
	        my $items = $sth->fetchall_arrayref();
		$S->update_items($items);
	}
        $sth->finish();
}

sub amazon_check_story {
	my $S = shift;
	my $sid = shift;
	my ($rv, $sth) = $S->db_select({ WHAT => qq|l.local_id, l.prod_id, l.asin,
                        	s.associate_id, s.country_code,
	                        s.automatic_update|,
			ORDER_BY => 'l.site_id',
			FROM => 'amazon_local l, amazon_sites s, amazon_story x',
			WHERE => qq|x.sid = ? and l.prod_id = x.prod_id and l.site_id = s.site_id
				 and ((UNIX_TIMESTAMP() - UNIX_TIMESTAMP(l.price_date) > 86350) or (l.need_update = 1))|,
			PARAMS => [$sid],
			DEBUG => 0});

	$rv = 0 if ($rv eq '0E0');	
	if ($rv) {
		warn "amazon_check_story: $sid needs updating ($rv)\n" if $SCOOP_DEBUG;
	        my $items = $sth->fetchall_arrayref();
		$S->update_items($items);
	}
	$sth->finish();
}


sub amazon_update_story {
	my $S = shift;
	my $sid = shift;
	my ($rv, $sth) = $S->db_select({ WHAT => qq|l.local_id, l.prod_id, l.asin,
                        	s.associate_id, s.country_code,
	                        s.automatic_update|,
			ORDER_BY => 'l.site_id',
			FROM => 'amazon_local l, amazon_sites s, amazon_story x',
			WHERE => 'x.sid = ? and l.prod_id = x.prod_id and l.site_id = s.site_id',
			PARAMS => [$sid],
			DEBUG => 0});

	
	if ($rv) {
	        my $items = $sth->fetchall_arrayref();
	        $sth->finish();
      		$S->update_items($items);
	}
}

sub update_items {
  my $S = shift;
  my $items = shift;
  my @asins;
  my $last_country;
  my $tag;

  # examine each story for amazon urls.
  foreach my $item (@{$items}) {
          #print "asin: $item->[2] : site $item->[3] \n";
          if (($last_country ne $item->[4]) || (@asins == 10)) {
                  if (@asins > 0) {
                          my $products = $S->get_asin_list(\@asins, $last_country, $tag);
						  if ($products->is_success()) {
							$S->process_returned_products(\@asins, $products, $items);
						  }
	
                          undef @asins;
						  
                  }
                  $last_country = $item->[4];
				  $tag = $item->[3];
          }
          {
                  # store Asin, AssocID, LocalID, ProductID
                  #my @entry = [$item->[2], $item->[3], $item->[0], $item->[1]];
                  #push (@asins, @entry);
		  		  $tag = $item->[3];
                  push (@asins, $item->[2]);
          }

  }
  if (@asins > 0) {
          my $products = $S->get_asin_list(\@asins, $last_country, $tag);
		  if ($products->is_success()) {
			$S->process_returned_products(\@asins, $products, $items);
		  }
  }
}


sub process_returned_products {
	my $S = shift;
	my $asins = shift;
	my $products = shift;
	my $items = shift;
	my %local_ids;
	my %prod_ids;

	warn "process_returned_products\n" if $SCOOP_DEBUG;

  foreach my $prod (@{$items}) {
          $local_ids{$prod->[2]} = $prod->[0];
          $prod_ids{$prod->[2]} = $prod->[1];
  }
	my ($rv,$sth);
  foreach my $prod ($products->properties) {
    my @items;
    push @items, $prod->DetailPageURL() || '';
    push @items, $prod->SmallImageUrl() || '';
    push @items, $prod->MediumImageUrl() || '';
    push @items, $prod->LargeImageUrl() || '';
    push @items, $prod->ListPrice() || '';
    push @items, $prod->OurPrice() || '';
    push @items, $prod->UsedPrice() || '';
    push @items, $local_ids{$prod->ASIN()};
    
    if ($sth) {
               $sth->execute(@items);
    } else {
    		($rv, $sth) = $S->db_update({
              DEBUG => $SCOOP_DEBUG,
        			WHAT => 'amazon_local',
        			SET => qq|details_url = ?,
        		                img_url_small = ?, img_url_medium = ?, img_url_large = ?,
        		                list_price = ?, our_price = ?, used_price = ?,
        		                price_date = NOW(), need_update = 0|,
        			WHERE => 'local_id = ?',
        			PARAMS => \@items});
    }
  }

	undef $sth;
  foreach my $prod ($products->properties) {
    my @items;
    push @items, $prod->ProductName() || '';
	my $author = "";  # Need to get the author some how.
    push @items, $author || '';
    push @items, $prod->Manufacturer() || '';
    push @items, $prod->Catalog() || '';
    push @items, $prod_ids{$prod->ASIN()};
    if ($sth) {
      $sth->execute(@items);
      $S->update_amazon_sid($prod_ids{$prod->{'Asin'}},$prod);
    } else {
      ($rv, $sth) = $S->db_update({
          DEBUG => $SCOOP_DEBUG,
          WHAT => 'amazon_prod',
          SET => qq|product_name = ?,
            				author = ?, manufac = ?, catalog = ?|,
          WHERE => qq|prod_id = ? AND product_name = 'UNKNOWN'|,
          PARAMS => \@items});
      $S->update_amazon_sid($prod_ids{$prod->ASIN()},$prod);
    }
  }

	undef $sth;
  my ($rv2,$sth2);
  foreach my $prod ($products->properties) {
    my $local_id = $local_ids{$prod->ASIN()};
    if ($sth2) {
      $sth2->execute([$local_id])
    } else {
      ($rv2, $sth2) = $S->db_delete({
          DEBUG => $SCOOP_DEBUG,
          FROM => 'amazon_review',
          WHERE => 'local_id = ?',
          PARAMS => [$local_id]});
    }
    foreach my $rev ($prod->review_set()->reviews()) {
  #my $d = Data::Dumper->new([$rev]);

  #warn "process_returned_products: " . $d->Dump if $SCOOP_DEBUG;
      my @items;
      push @items, $rev->rating() || '';
      push @items, $rev->summary() || '';
      push @items, $rev->content() || '';
      push @items, $local_id;
      if ($sth) {
        $sth->execute(@items);
      } else {
        ($rv, $sth) = $S->db_insert({
            DEBUG => $SCOOP_DEBUG,
            INTO => 'amazon_review',
            COLS => qq|rating, summary, comment, local_id|,
            VALUES => qq|?,?,?,?|,
            PARAMS => \@items});
      }
    }
  }

}

sub update_amazon_sid {
	my $S = shift;
	my $prod_id = $S->{DBH}->quote(shift);
	my $prod = shift;
	my $sid;
	my $displaystatus = '1';
	warn "update_amazon_sid : $prod_id\n" if $SCOOP_DEBUG;

	my ($rv, $sth) = $S->db_select({
				DEBUG => $SCOOP_DEBUG,
				WHAT => 'sid',
				FROM => 'amazon_prod',
				WHERE => qq|prod_id = $prod_id|});
	warn "\$rv is $rv\n" if $SCOOP_DEBUG;
	if (($rv ne '0E0') && ($rv)) {
		$sid = $sth->fetchrow();
	} else {
		return;
	}
	warn "update_amazon_sid : sid = $sid\n" if $SCOOP_DEBUG;
	($rv, $sth) = $S->db_select({
				WHAT => 'displaystatus',
				FROM => 'stories',
				WHERE => qq|sid = "$sid"|});
	if (($rv ne '0E0') && ($rv)) {
		$displaystatus = $sth->fetchrow();
	}
	return unless ($displaystatus eq '-1');
	
	warn "story is hidden : Updating\n" if $SCOOP_DEBUG;
	my $title = $prod->ProductName();
	$title = $S->filter_subject($title);
	warn "title is $title" if $SCOOP_DEBUG;
	($rv, $sth) = $S->db_update({
				WHAT => 'stories',
				SET => 'title = ?, tid = ?, displaystatus = ?',
				WHERE => 'sid = ?',
				PARAMS => [$title, 'Books', '1', $sid]});
}

sub get_asin_list {
  my $S = shift;
  my $asins = shift;
  my $country = lc shift;
  my $tag = shift;
  my $xml;
  my $products;
  
#  Log::Log4perl->easy_init($DEBUG);
  my $ua = Net::Amazon->new(
      token       => $S->{UI}->{VARS}->{'accesskeyid'},
	  secret_key => $S->{UI}->{VARS}->{'secretkeyid'},
	  locale => $country,
  );

  my $req = Net::Amazon::Request::ASIN->new( 
      asin  => $asins,
	  AssociateTag => $tag
  );

    # Response is of type Net::Amazon::Response::ASIN
  my $resp = $ua->request($req);
  
#  my $d = Data::Dumper->new([$resp]);

#  warn "get_asin_list: " . $d->Dump if $SCOOP_DEBUG;

#  my $asin_list = join (',',  map { $_->[0] } @{$asins});
#  my $url;
#  if (lc $country eq 'uk') {
#    $url = "http://webservices.amazon.co.uk/onca/xml?Service=AWSECommerceService";
#  } elsif (lc $country eq 'de') {
#    $url = "http://webservices.amazon.de/onca/xml?Service=AWSECommerceService";
#  } elsif (lc $country eq 'jp') {
#    $url = "http://webservices.amazon.co.jp/onca/xml?Service=AWSECommerceService";
#  } elsif (lc $country eq 'fr') {
#    $url = "http://webservices.amazon.fr/onca/xml?Service=AWSECommerceService";
#  } elsif (lc $country eq 'ca') {
#    $url = "http://webservices.amazon.ca/onca/xml?Service=AWSECommerceService";
#  } elsif ((lc $country eq 'us') || (lc $country eq 'jp')) {
#    $url = "http://webservices.amazon.com/onca/xml?Service=AWSECommerceService";
#  }
#  if ($url) {
#    $xml = $S->fetch_xml($asin_list, $asins->[0][1], $url, lc($country), $style);
#    if ($xml) {
#      $products = $S->parse_xml($xml);
#    }
#  }

  return $resp;
}

return 1;
