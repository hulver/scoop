
=head1 IndexSearch.pm

New search functions.

=head1 AUTHOR

Matthew Collins B<hulver@janes.demon.co.uk>

=head1 Functions

What follows is a bit of pod in front of the core functions, if they
are not documented here in pod, then they probably are with normal
hash-style comments, and they aren't essential to using the api.
=cut

package Scoop;

use strict;
use vars qw($Have_lingua);
my $DEBUG = 0;

BEGIN {
        $Have_lingua = 1;
        eval { require Lingua::Stem };
        $Have_lingua = 0 if $@ =~ /^Can't locate Lingua\/Stem\.pm in \@INC/i;
}

=item * index_search_enabled()

Returns true if spell checking is available, enabled, and useable by the
current user. This checks both for the spell checking module, and to see
if the admin has enabled it.

=cut

sub index_search_enabled {
        my $S = shift;

        return 0 unless $Have_lingua;
        return 0 unless $S->{UI}->{VARS}->{index_search_enabled};
        return 1;
}

=item *
index_text($sid, $text, $cid)

Indexes a story or comment, and stores it in the database. If the
story or comment already exists, it is deleted first.

=cut

sub index_text {
	my $S = shift;
	my $sid = shift;
	my $cid = shift || 0;
	my $text;
	
	return unless $S->index_search_enabled();

	warn "index_text : $sid, $cid" if $DEBUG;

	$S->delete_index($sid, $cid) if $S->is_indexed($sid, $cid);

	#split up text into words
	#remove stop words
	#run through stem
	
	if ($cid) {
		my ($rv, $sth) = $S->db_select({
			WHAT => 'subject, comment',
			FROM => 'comments',
			WHERE => "sid = '$sid' and cid = '$cid'"});
		my ($subject, $body) = $sth->fetchrow_array();
		$text .= $subject . ' ' . $body;
	} else {
		my ($rv, $sth) = $S->db_select({
			WHAT => 'title, introtext, bodytext',
			FROM => 'stories',
			WHERE => "sid = '$sid'"});
		my ($title, $intro, $body) = $sth->fetchrow_array();
		$text = $title . ' ' . $intro . ' ' . $body;
	}

	#get wordlist here
	$S->db_lock_tables({ search_words => 'WRITE' });
	my %bighash = $S->search_words($text);

	my $insert;
	my $q_sidid = $S->search_sidid($sid);
	my $q_cid = $S->{DBH}->quote($cid);
	my $q_wid;
	my $wordcount = 0;
	foreach my $key (keys %bighash) {
		if ($bighash{$key} == 0) {
			my $q_word = $S->{DBH}->quote($key);
			my ($rv, $sth) = $S->db_insert({
				DEBUG => 0,
				VALUES => "0, $q_word",
				INTO => 'search_words'});
			if ($rv) {
		                $sth = $S->{DBH}->prepare('SELECT LAST_INSERT_ID()');
                		$rv = $sth->execute();
				$bighash{$key}= $sth->fetchrow();
				$sth->finish();
			}
		}
		$q_wid = $S->{DBH}->quote($bighash{$key});
		$insert .= ', ' if ($insert);
		$insert .= '( 0,' . $q_sidid . ', ' . $q_cid . ', ' . $q_wid . ')';
		$wordcount++;
	};
	$S->db_unlock_tables;
	if ($wordcount) {
		chop $insert;
		$insert = substr($insert,1,length($insert)-1);
		$S->db_lock_tables({ search_table => 'WRITE'});
		my ($rv, $sth) = $S->db_insert({
					DEBUG => 0,
					VALUES => $insert,
					INTO => 'search_table'});
		$S->db_unlock_tables;
	}

}

=item *
delete_index($sid, $cid)

Delete an indexed item from the index.

=cut

sub delete_index {
	my $S = shift;
	my $sid = shift;
	my $cid = shift || 0;
	
	return unless $S->index_search_enabled();
	
	my $sid_id = $S->search_sidid($sid);
	$sid_id = $S->{DBH}->quote($sid_id);
	$cid = $S->{DBH}->quote($cid);

	my ($rv, $sth) = $S->db_delete({
				FROM => 'search_table',
				WHERE => "sid_id = $sid_id AND cid = $cid"
				});
	$sth->finish();
}

=item *
search_words($text)

Returns a hash with word ID's of all words in the text

=cut

sub search_words {
	my $S = shift;
	my $text = shift;
	
	return unless $S->index_search_enabled();

        # set up parser can callbacks (anonymous subs works just fine here)
        my $parser = Scoop::HTML::Parser->new();
        $parser->callbacks(
                # sets up a place to hold the result. first arg is parser
                begin => sub {
                        $_[0]->{result} = "";
                },
                # put tag back on, unmodified
                start => sub {
                },
                # same with end tags
                end => sub {
                },
                # same with comments
                comment => sub {
                },
                # finally, call spellcheck_string on text
                text => sub {
                        $_[0]->{result} .= $_[1];
                }
        );

        # do the parsing
        $parser->parse($text);

	open(INFILE, "<",  \$parser->{result});

	my %bighash;

	my $stop_list = $S->{UI}->{VARS}->{search_stoplist} . ',';
	while (<INFILE>)
	{
	        while (m/([\w\']+)/gi)
	        {
			my $test = $1;
			$test =~ tr/a-zA-Z0-9_ //cd;
			$test = substr($test,0,10) if length($test) > 10;
			if ($test) {
				$test = lc($test);
				$bighash{$test} = 0 unless ($stop_list =~ /$test,/im);
			}
	        }
	}
	close(INFILE);


	my $where;
	my %retval;
	foreach my $key (keys %bighash) {
		$where .= ', ' if ($where);
		$key = $S->stem($key);
		$retval{$key} = 0;
		$where .= $S->{DBH}->quote($key);
	}
	my ($rv, $sth) = $S->db_select({
			DEBUG => 0,
			WHAT => 'word_id, word',
			FROM => 'search_words',
			WHERE => "word in ($where)"});
	while (my ($wordref, $word) = $sth->fetchrow_array()) {
		$retval{$word} = $wordref;
	}
	return %retval;

}

=item *
search_sidid($sid)

Returns a sidid for a sid. Creates it if nessesary

=cut

sub search_sidid {
	my $S = shift;
	my $sid = shift;

	my $qsid = $S->{DBH}->quote($sid);
	my $retval;

	$S->db_lock_tables ({ sid_xref => 'WRITE' });
	my ($rv, $sth) = $S->db_select({
				WHAT => 'sid_id',
				FROM => 'sid_xref',
				WHERE => "sid = $qsid"});
	if ($rv == 1) {
		$retval = $sth->fetchrow();
		$sth->finish();
	} else {
		($rv, $sth) = $S->db_insert({
				VALUES => "0, $qsid",
				INTO => 'sid_xref'});
		if ($rv) {
		        $sth = $S->{DBH}->prepare('SELECT LAST_INSERT_ID()');
                	$rv = $sth->execute();
			$retval = $sth->fetchrow();
			$sth->finish();
		}
	};
	$S->db_unlock_tables;
	return $retval;
}

=item *
is_indexed($sid, $cid)

Check if an item is in the index.

=cut

sub is_indexed {
	my $S = shift;
	my $sid = shift;
	my $cid = shift || 0;
	
	$sid = $S->{DBH}->quote($sid);
	$cid = $S->{DBH}->quote($cid);

	my $retval = 0;

	my ($rv, $sth) = $S->db_select({
			WHAT => 'count(search_table.sid_id)',
			FROM => 'search_table INNER JOIN sid_xref on sid_xref.sid_id = search_table.sid_id',
			WHERE => "search_table.cid = $cid and sid_xref.sid = $sid",
			LIMIT => 1});
	$retval = 1 if ($rv >= 1);

	return $retval;
}

=item *
stem($word)

Return the "stem" (IE, no plurals etc) of a word.

=cut

sub stem {
	my $S = shift;
	my $word = shift;

	my $stemref = Lingua::Stem::stem( $word );
	return $stemref->[0];
}

return 1;
