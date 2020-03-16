package Scoop;
use strict;

my $DEBUG = 0;

sub store_message {
	my $S = shift;
	my $sid = shift || '';
	my $cid = shift || '';
	my $new_cid = shift || '';
	my $uid = shift || '';
	my $type = shift || '';
	my $retval;
	return unless $uid > 0;

	warn "store_message: $sid, $cid, $new_cid, $uid, $type\n" if $DEBUG;

	my ($rv, $sth) = $S->db_insert({
		INTO	=> 'message_list',
		COLS	=> 'sid, cid, new_cid, uid, msg_type',
		VALUES	=> '?, ?, ?, ?, ?',
		PARAMS	=> [$sid, $cid, $new_cid, $uid, $type]});	
	$sth->finish;
	if ($rv) {
                $sth = $S->{DBH}->prepare('SELECT LAST_INSERT_ID()');
                $sth->execute();
                $retval = $sth->fetchrow();
		$sth->finish;
	}
	return $retval;
}

sub store_comment_reply {
	my $S = shift;
	my $sid = shift;
	my $replied_cid = shift;
	my $new_cid = shift;
	my $uid = shift || $S->{UID};
	return unless $uid > 0;

	warn "store_comment_reply: $sid, $replied_cid, $new_cid, $uid\n" if $DEBUG;

	return $S->store_message($sid,$replied_cid,$new_cid,$uid,1);
}

sub check_comment_reply {
	my $S = shift;
	my $posted_sid = shift;
	my $posted_cid = shift;

	warn "check_comment_reply: $posted_sid, $posted_cid\n" if $DEBUG;

	my ($rv, $sth) = $S->db_select({
		WHAT	=> 'pid',
		FROM	=> 'comments',
		WHERE	=> 'sid = ? AND cid = ?',
		PARAMS	=> [$posted_sid, $posted_cid]});
	if ($rv) {
		my $pid = $sth->fetchrow();
		$sth->finish;
		if ($pid != 0) {
			($rv, $sth) = $S->db_select({
				WHAT	=> 'cid, uid',
				FROM	=> 'comments',
				WHERE	=> 'sid = ? AND cid = ?',
				PARAMS	=> [$posted_sid, $pid]});
			if ($rv) {
				my ($parent_cid, $parent_uid) = $sth->fetchrow();
				$sth->finish;
				$S->store_comment_reply($posted_sid,$parent_cid,$posted_cid,$parent_uid);
			}
                } else {
                        my $aid = $S->_get_story_aid($posted_sid);
                        warn "Storing direct reply to $posted_sid using author $aid\n" if $DEBUG;
                        $S->store_comment_reply($posted_sid,$pid,$posted_cid,$aid);
		}
	}
}

sub get_comment_replys {
	my $S = shift;
	my $uid = shift || $S->{UID};
	my $sid = shift || '';
	return unless $uid > 0;
	my $retval;
	warn "get_comment_replys: $uid, $sid\n" if $DEBUG;

	my $where = 'm.uid = ? AND c.sid=m.sid AND c.cid = m.new_cid';
	if ($sid) {
		my $qsid = $S->{DBH}->quote($sid);
		$where .= qq| AND m.sid = $qsid|;
	}
	my ($rv, $sth) = $S->db_select({
		DEBUG		=> $DEBUG,
		WHAT		=> 'm.msg_id, m.sid, m.new_cid, c.subject',
		FROM		=> 'message_list m, comments c',
		WHERE		=> $where,
		ORDER_BY	=> 'm.sid, c.date',
		PARAMS		=> [$uid]});
	if ($rv) {
		$retval = $sth->fetchall_arrayref({});
		$sth->finish;
	}
	return $retval;
}

sub remove_messages {
	my $S = shift;
	my $sid = shift;
	my $cids = shift;
	my $uid = shift || $S->{UID};
	return unless $uid > 0;
	return unless @{$cids} > 0;

	warn "remove_messages: $sid, $uid, @{$cids}\n" if $DEBUG;

	my $where = 'sid = ? and uid = ? and new_cid in (';
	$where .= join(', ', map { $S->{DBH}->quote($_) } @{$cids}) . ')';

	my ($rv, $sth) = $S->db_delete({
		DEBUG	=> $DEBUG,
		FROM	=> 'message_list',
		WHERE	=> $where,
		PARAMS	=> [$sid,$uid]});

}

1;
