package Scoop;
use strict;

my $DEBUG = 0;

sub pm_inbox {
	my $S = shift;

	return unless $S->have_perm('private_messages');

	my $content;

	$S->{UI}->{BLOCKS}->{subtitle} = 'Private Inbox';

	if($S->{CGI}->param('delete_msg'))
	{
	    my $msg_id = $S->{DBH}->quote($S->{CGI}->param('delete_msg'));
		$S->db_update({
			WHAT=>'private_message',
			SET=>'inbox_delete = "1"',
	        WHERE=>"message_id = $msg_id AND to_uid=".$S->{UID}
		});
	    $S->db_delete({
	        FROM=>'private_message',
	        WHERE=>"inbox_delete = '1' AND sent_delete = '1'"
	    });

	    $content .= "<font color='green'>Message Deleted...</font><p>";
	}

	my $date_format = $S->date_format('pm.sent_date', 'short');

	my ($rv, $sth) = $S->db_select({
	    WHAT=>"$date_format as fd, pm.*, pm_from.nickname",
	    FROM=>'private_message as pm, users AS pm_from',
	    WHERE=>"pm.from_uid=pm_from.uid AND inbox_delete = '0' AND pm.to_uid=".$S->{UID},
	    ORDER_BY=>"pm.msg_read, pm.sent_date"
	});

	$content = "<table width='100%'><tr><td><b>From:</b></td><td><b>Title:</b></td><td><b>Sent:</b></td><td> </td></tr>";

	my $msgs;

	while(my $msg = $sth->fetchrow_hashref())
	{
	    my $read="msg_unread";
	    if($$msg{msg_read})
	    {
	        $read="msg_read";
	    }

	    $msgs .= qq(<tr id='$read'><td>$$msg{nickname}</td><td><a href="%%rootdir%%/pm_message/?message_id=$$msg{message_id}">$$msg{subject}</a></td><td>$$msg{fd}</td><td width="20"><a href="%%rootdir%%/pm_inbox/?delete_msg=$$msg{message_id}"><img src='%%imagedir%%/delete.gif' border=0 alt="Delete Message"></a></td></tr>);
	}

	if($msgs)
	{
	    $content .= $msgs."</table>";
	} else {
	    $content .= "<tr><td colspan='4'><b>No Messages</b></td></tr></table>";
	}

	my $actions = qq(<a href="%%rootdir%%/pm_inbox/">Your Inbox</a> %%dot%% <a href="%%rootdir%%/pm_sent/">Your Sent Messages</a>);
	my $block = $S->{UI}->{BLOCKS}->{nav_system};

	$block =~ s/%%title%%/Your Inbox/g;
	$block =~ s/%%icon%%/inbox/g;
	$block =~ s/%%content%%/$content/g;
	$block =~ s/%%actions%%/$actions/g;

	return $block;
}

sub pm_sent {
	my $S = shift;

	return unless $S->have_perm('private_messages');

	my $content;

	$S->{UI}->{BLOCKS}->{subtitle} = 'Private Messages Sent';

	if($S->{CGI}->param('delete_msg'))
	{
	    my $msg_id = $S->{DBH}->quote($S->{CGI}->param('delete_msg'));
		$S->db_update({
			WHAT=>'private_message',
			SET=>'sent_delete = "1"',
	        WHERE=>"message_id = $msg_id AND from_uid=".$S->{UID}
		});
	    $S->db_delete({
	        FROM=>'private_message',
	        WHERE=>"inbox_delete = '1' AND sent_delete = '1'"
	    });

	    $content .= "<font color='green'>Message Deleted...</font><p>";
	}

	my $date_format = $S->date_format('pm.sent_date', 'short');

	my ($rv, $sth) = $S->db_select({
	    WHAT=>"$date_format as fd, pm.*, pm_to.nickname",
	    FROM=>'private_message as pm, users AS pm_to',
	    WHERE=>"pm.to_uid=pm_to.uid AND sent_delete = '0' AND pm.from_uid=".$S->{UID},
	    ORDER_BY=>"pm.sent_date"
	});

	$content = "<table width='100%'><tr><td><b>To:</b></td><td><b>Title:</b></td><td><b>Sent:</b></td><td> </td></tr>";

	my $msgs;

	while(my $msg = $sth->fetchrow_hashref())
	{
	    $msgs .= qq(<tr id='msg_read'><td>$$msg{nickname}</td><td><a href="%%rootdir%%/pm_message/?message_id=$$msg{message_id}">$$msg{subject}</a></td><td>$$msg{fd}</td><td width="20"><a href="%%rootdir%%/pm_sent/?delete_msg=$$msg{message_id}"><img src='%%imagedir%%/delete.gif' border=0 alt="Delete Message"></a></td></tr>);
	}

	if($msgs)
	{
	    $content .= $msgs."</table>";
	} else {
	    $content .= "<tr><td colspan='4'><b>No Messages</b></td></tr></table>";
	}

	my $actions = qq(<a href="%%rootdir%%/pm_inbox/">Your Inbox</a> %%dot%% <a href="%%rootdir%%/pm_sent/">Your Sent Messages</a>);
	
	my $block = $S->{UI}->{BLOCKS}->{nav_system};

	$block =~ s/%%title%%/Your Sent Messages/g;
	$block =~ s/%%icon%%/inbox/g;
	$block =~ s/%%content%%/$content/g;
	$block =~ s/%%actions%%/$actions/g;

	return $block;
}

sub pm_message {
	my $S = shift;

	return unless $S->have_perm('private_messages');

	my $content;

	$S->{UI}->{BLOCKS}->{subtitle} = 'View Message';

	my $date_format = $S->date_format('pm.sent_date', 'short');

	my $mid = $S->{DBH}->quote($S->{CGI}->param('message_id'));

	my $where = "pm.from_uid=pm_from.uid AND pm.to_uid = pm_to.uid AND pm.message_id=$mid";
	$where .= " AND ((pm.to_uid=".$S->{UID}." AND pm.inbox_delete = '0') OR ";
	$where .= " (pm.from_uid=".$S->{UID}." AND pm.sent_delete = '0' ))";

	my ($rv, $sth) = $S->db_select({
	    WHAT=>"$date_format as fd, pm.*, pm_from.nickname as nickname, pm_to.nickname as recp",
	    FROM=>'private_message as pm, users as pm_from, users as pm_to',
	    WHERE=> $where,
	});

	my $item = $sth->fetchrow_hashref();

	return unless $$item{subject};

	if($$item{msg_read} == 0)
	{
	    $S->db_update({
		WHAT => 'private_message',
		SET => 'msg_read = 1',
		WHERE => "message_id=$mid AND to_uid=".$S->{UID}
		});
	}

	$content .= qq(
	<p>
	<b>From:</b> $$item{nickname}<br>
	<b>To:</b> $$item{recp}<br>
	<b>Sent:</b> $$item{fd}<br>
	<b>Subject:</b> $$item{subject}<br>
	<div style="border-top: 1px dashed #999">
	$$item{message}
	</div>
	);

	my $actions;
	my $title;
	
	if ($$item{from_uid} != $S->{UID}) {
	$actions = qq(<a href="%%rootdir%%/pm_send/?to_uid=$$item{from_uid}&orig_id=$$item{message_id}">Reply to this message</a> %%dot%% <a href="%%rootdir%%/pm_inbox/">Back to my inbox</a> %%dot%% <a href="%%rootdir%%/pm_inbox/?delete_msg=$$item{message_id}">Delete this message</a>);
	$title = qq(Your Inbox: $$item{subject});
	} else {
	$actions = qq(<a href="%%rootdir%%/pm_sent/">Back to sent messages</a> %%dot%% <a href="%%rootdir%%/pm_sent/?delete_msg=$$item{message_id}">Delete this message</a>);
	$title = qq(Your Sent Message: $$item{subject});
	}

	my $block = $S->{UI}->{BLOCKS}->{nav_system};

	$block =~ s/%%title%%/$title/g;
	$block =~ s/%%icon%%/inbox/g;
	$block =~ s/%%content%%/$content/g;
	$block =~ s/%%actions%%/$actions/g;

	return $block;
}

sub pm_send {
	my $S = shift;

	return unless $S->have_perm('private_messages');

	my $content;

	$S->{UI}->{BLOCKS}->{subtitle} = 'Send Private Message';

	if($S->{CGI}->param('subject'))
	{
	    my $subject = $S->filter_subject($S->{CGI}->param('subject'));
	    my $message = $S->filter_comment($S->{CGI}->param('message'),'comment','text');
	    my $q_subject=$S->{DBH}->quote($subject);
	    my $q_message=$S->{DBH}->quote($message);
	    my $to=$S->{DBH}->quote($S->{CGI}->param('to_uid'));

	    $S->db_insert({
	        INTO=>'private_message',
	        COLS=>'from_uid, to_uid, sent_date, subject, message, msg_read',
	        VALUES=>"$S->{UID}, $to, now(), $q_subject, $q_message,0",
	        DEBUG=>0
	    });

	    $content .= "<font color='green'>Message Sent...</font><p><a href='%%rootdir%%/pm_inbox'>Return to my inbox</a>";

	} else {
	    my $to_uid = $S->filter_param($S->{CGI}->param('to_uid'));
	    my ($subject, $message, $orig_subject);
	    my $orig_id = $S->filter_param($S->{CGI}->param('orig_id'));
	    if ($orig_id) {
		my $where = "pm.message_id=$orig_id";
		$where .= " AND pm.to_uid=".$S->{UID};
		
		my ($rv, $sth) = $S->db_select({
		    WHAT=>"pm.*",
		    FROM=>'private_message as pm, users as pm_from',
		    WHERE=> $where,
		});

		my $item = $sth->fetchrow_hashref();
		$orig_subject = $$item{subject};
		$subject = $$item{subject};
		$subject =~ s/^re:( *)//gi;
		$subject = $S->filter_subject("Re: " . $subject);
		$message = $$item{message};
	    }
	    my $to_nick = $S->get_nick_from_uid($to_uid);
	    $content = qq(
	        <form method="post" action="%%rootdir%%/pm_send">);
	    if ($message) {
	$content .= qq(
	Replying to <b>$to_nick</b><p>
	<b>Subject:</b> $orig_subject<br>
	<div style="border-top: 1px dashed #999;border-bottom: 1px dashed #999">
	$message
	</div><p>
	);
	    } else {
	    $content .= qq(Sending message to <b>$to_nick</b><p>);
	    }
	    $content .= qq(
	        <B>Subject:</b><br><input type="text" value="$subject" name="subject" size='50'><p>
	        <b>Message:</b><br><textarea name="message" rows="10" cols="50"></textarea><p>
	        <input type='hidden' value='$to_uid' name='to_uid'><input name="post" type="submit" value="Send Message">
	        </form>
	    );

	}
	my $block = $S->{UI}->{BLOCKS}->{nav_system};

	my $actions = qq(<a href="%%rootdir%%/pm_inbox/">Back to My Inbox</a>);

	$block =~ s/%%title%%/Your Inbox: Compose Message/g;
	$block =~ s/%%icon%%/inbox/g;
	$block =~ s/%%content%%/$content/g;
	$block =~ s/%%actions%%/$actions/g;

	return $block;
}

1;
