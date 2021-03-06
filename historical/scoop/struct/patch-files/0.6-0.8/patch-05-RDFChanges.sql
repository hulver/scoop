INSERT INTO vars VALUES ('allow_rdf_fetch', '1', 'If on, then fetches can be done from the admin interface, otherwise they can''t. Turn this on unless you have a problem with adding or refetching feeds, in which case Apache probably needs to be recompiled. This var is a hack to prevent admins from messing up the server when recompiling isn''t an option.', 'bool', 'RDF');

INSERT INTO templates (template_id, opcode) VALUES ('submitrdf_template', 'submitrdf');

UPDATE perm_groups SET group_perms = CONCAT(group_perms,',submit_rdf') WHERE perm_group_id = 'Users' OR perm_group_id = 'Editors';

UPDATE blocks SET block = CONCAT(block, ',\nsubmitrdf') WHERE bid = 'opcodes';

ALTER TABLE rdf_channels ADD COLUMN submitted INT(1);
ALTER TABLE rdf_channels ADD COLUMN submittor VARCHAR(50);

UPDATE box SET content = 'return unless $S->{UI}->{VARS}->{use_rdf_feeds};\n\nmy $to_display = {};\nif (@ARGS || $S->{CGI}->param(\'rdf\')) {\n	my $rdf_arg = $S->{CGI}->param(\'rdf\');\n	@ARGS = split(/,/, $rdf_arg) if $rdf_arg;\n	foreach (@ARGS) {\n		$to_display->{$_} = 1;\n	}\n}\n\nmy $content;\nmy $channels = $S->rdf_channels();\nmy $user_feeds = $S->rdf_get_prefs() unless @ARGS;\n\nif ($S->have_perm(\'submit_rdf\')) {\n	$content = qq|<A CLASS="light" HREF="%%rootdir%%/?op=submitrdf">Submit Feed</A><BR><BR>\\n|;\n}	\n\nforeach my $c (@{$channels}) {\n	if (@ARGS) {\n		next unless $to_display->{ $c->{rid} };\n	} else {\n		next unless $user_feeds->{ $c->{rid} };\n	}\n	next unless $c->{title};\n	unless ($S->have_perm(\'rdf_admin\')) {\n		next if $c->{submitted} || !$c->{enabled};\n	}\n\n	if ($S->{UI}->{VARS}->{rdf_use_images} && $c->{image_url}) {\n		$content .= qq~<A HREF="$c->{image_link}"><IMG SRC="$c->{image_url}" ALT="$c->{image_title}" BORDER="1"></a><br>\\n~;\n	} else {\n		$content .= qq~<B><A CLASS="light" HREF="$c->{link}">$c->{title}</a></b><BR>\\n~;\n	}\n\n	my $items = $S->rdf_items($c->{rid});\n	foreach my $i (@{$items}) {\n		$content .= qq~%%dot%% <A CLASS="light" HREF="$i->{link}">$i->{title}</a><BR>\\n~;\n	}\n\n	if ($S->{UI}->{VARS}->{rdf_use_forms} && $c->{form_link}) {\n		$content .= qq~<FORM ACTION="$c->{form_link}" METHOD="GET">$c->{form_title}: <INPUT TYPE="TEXT" NAME="$c->{form_name}"></form><br>\\n~;\n	}\n\n	$content .= "<BR>\\n";\n}\n\nreturn $content;\n' WHERE boxid = 'rdf_feeds';

INSERT INTO special (pageid, title, description, content) VALUES ('rdf_preview', 'External Feeds Preview', 'Used to preview external feeds\'s boxes.', 'Below is a preview of what the selected feed will look like once it\'s been added. The headlines within it are the current ones.<p>\n<table align="center" width="40%" border="0">\n<tr><td>\n%%BOX,rdf_feeds%%\n</td></tr>\n</table>');

INSERT INTO box (boxid, title, content, description, template) VALUES ('submit_rdf', 'Submit Feed', 'return "User submitted feeds are disabled. Why not just mail the admin?"\n	unless $S->{UI}->{VARS}->{user_submitted_rdfs};\nreturn "Sorry, you don\'t have permission to submit a feed."\n	unless $S->have_perm(\'submit_rdf\');\nmy $action = $S->{CGI}->param(\'action\') || \'showform\';\nif ($action eq \'showform\') {\n	return &disp_form();\n} elsif ($action eq \'save\') {\n	my $url = $S->{CGI}->param(\'url\');\n	return &disp_form(\'Please fill in the URL field\') unless $url;\n	# check to see if this RDF already exists\n	my $is_dup = 0;\n	my $channels = $S->rdf_channels;\n	foreach my $c (@{$channels}) {\n		$is_dup = 1 if $c->{rdf_link} eq $url;\n	}\n	return &disp_form(\'That RDF already exists, or has been submitted already.\') if $is_dup;\n\n	my $do_fetch = $S->{UI}->{VARS}->{allow_rdf_fetch} ? 1 : 0;\n	my ($id, $res) = $S->rdf_add_channel($url, $do_fetch, $S->{NICK});\n	unless ($res) {\n		$S->rdf_remove_channel($id);\n		return &disp_form(\'Error fetching RDF file\');\n	}\n	my $fetched_msg = qq|\n%%norm_font%%You\'re RDF has been fetched. An admin will check it out as soon as possible%%norm_font_end%%|;\n	return $fetched_msg;\n}\n\nsub disp_form {\n	my $form = qq|\n%%norm_font%% %%submit_rdf_message%% %%norm_font_end%%\n<p>\n<form action="%%rootdir%%/?" method="GET">\n<input type="hidden" name="op" value="submitrdf">\n<input type="hidden" name="action" value="save">\n<table border=0 cellspacing=0 cellpadding=0>|;\n	$form .= qq|\n	<tr>\n		<td><FONT color="#FF0000">%%norm_font%%$_[0]%%norm_font_end%%</FONT></td>\n	</tr>| if $_[0];\n	$form .= qq|\n	<tr>\n		<td>%%norm_font%%URL of RDF file:%%norm_font_end%% <input type="text" name="url" size="50"></td>\n	</tr>\n	<tr>\n		<td><input type="submit" value="Submit"></td>\n	</tr>\n</table>\n</form>\n|;\n	return $form;\n}\n', 'Box to do submitrdf op and such.', 'titled_box');

INSERT INTO blocks (bid, block) VALUES ('submit_rdf_message', 'Know of any good sites that syndicate their headlines, but aren\'t carried by this site yet? Well, most likely this is because the admins don\'t know about the site yet, or that they syndicate headlines with RDF. All it takes is for you to find a URL for the site where their RDF file is, and copy it to the form below. Once submitted, and admin will review it, and will either approve it or delete it.');

INSERT INTO blocks (bid, block) VALUES ('submitrdf_template', '<HTML>\n<HEAD>\n<TITLE>%%sitename%% || %%subtitle%%</title>\n</head>\n<BODY bgcolor="#FFFFFF" text="#000000" link="#006699" vlink="#003366">\n\n%%header%%\n\n<!-- Main layout table -->\n<TABLE BORDER=0 WIDTH="99%" ALIGN="center" CELLPADDING=0 CELLSPACING=10>\n	<!-- Main page block -->\n	<TR>\n		\n		<!-- Center content section -->\n		<TD VALIGN="top" width="75%">\n			%%BOX,submit_rdf%%\n		</td>\n		<!-- X center content section -->\n		\n		<!-- Right boxes column -->\n		<TD VALIGN="top" WIDTH="25%">\n\n			%%BOX,main_menu%%\n			%%BOX,hotlist_box%%\n			%%BOX,user_box%%\n			%%BOX,admin_tools%%\n		\n		</td>\n		<!-- X Right boxes column -->\n	</tr>\n	<!-- X main page block -->\n</table>\n<!-- X Main layout table -->\n<P>\n%%footer%%\n<P>\n<CENTER>%%BOX,menu_footer%%</center>\n</body>\n</html>\n');

INSERT INTO blocks (bid, block) VALUES ('titled_box', '<TABLE BORDER=0 CELLPADDING=0 CELLSPACING=2 WIDTH="100%">\n	<TR>\n		<TD BGCOLOR="%%title_bgcolor%%">%%title_font%%<B>%%title%%</B>%%title_font_end%%</TD>\n	</TR>\n	<TR>\n		<TD>\n			%%content%%\n		</TD>\n	</TR>\n</TABLE>\n');