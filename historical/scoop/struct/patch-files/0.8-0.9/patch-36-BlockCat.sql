ALTER TABLE blocks DROP seclev;
ALTER TABLE blocks ADD description TEXT;
ALTER TABLE blocks ADD category VARCHAR(128) DEFAULT "general" NOT NULL;
ALTER TABLE blocks ADD theme VARCHAR(32) DEFAULT "default" NOT NULL;
ALTER TABLE blocks ADD language VARCHAR(10) DEFAULT "en" NOT NULL;

UPDATE blocks SET aid="1";
UPDATE blocks SET theme="default";
UPDATE blocks SET language="en";

INSERT INTO vars (name, value, type, category, description) VALUES ("default_theme", "default", "text", "Themes", "Sets the name of the default theme, used as a base for all new themes");
INSERT INTO vars (name, value, type, category, description) VALUES ("use_themes", "0", "bool", "Themes", "Should we use themes at all");

UPDATE blocks SET category="advertising" WHERE bid="advertising_account_disclaimer" OR bid="ad_confirm_text" OR bid="ad_step1_rules" OR bid="ad_test_template" OR bid="basic2_banner_ad_template" OR bid="basic_banner_ad_template" OR bid="buy_ad_impression_message" OR bid="confirm_purchase_impressions" OR bid="no_submit_ad_perm" OR bid="text_ad_template" OR bid="new_advertiser_html" OR bid="renew_ad_message" OR bid="renew_choose_ad" OR bid="renew_ad_no_permission" OR bid="renew_confirm_message" OR bid="confirm_ad_renew" OR bid="paypal_finished" OR bid="paypal_canceled";
UPDATE blocks SET category="boxes" WHERE bid="blank_box" OR bid="box" OR bid="empty_box" OR bid="poll_box" OR bid="rss_box" OR bid="titled_box";
UPDATE blocks SET category="block_programs" WHERE bid="admin_alert" OR bid="allowed_html" OR bid="all_html" OR bid="autorelated" OR bid="op_aliases" OR bid="op_templates" OR bid="perms";
UPDATE blocks SET category="content" WHERE bid="comment" OR bid="moderation_comment" OR bid="poll_block" OR bid="story_body" OR bid="story_info" OR bid="story_summary";
UPDATE blocks SET category="display" WHERE bid="box_title_bg" OR bid="comment_head_bg" OR bid="dept_font" OR bid="pendingstory_bg" OR bid="sectiononlystory_bg" OR bid="smallfont" OR bid="smallfont_end" OR bid="spell_err" OR bid="spell_err_end" OR bid="story_mod_bg" OR bid="story_nav_bg" OR bid="submittedstory_bg" OR bid="title_bgcolor" OR bid="undisplayedstory_bg" OR bid="editqueuestory_bg";
UPDATE blocks SET category="email" WHERE bid="digest_headerfooter" OR bid="digest_storyformat";
UPDATE blocks SET category="forumzilla" WHERE bid="fz_ad_url" OR bid="fz_navigation_url";
UPDATE blocks SET category="templates" WHERE bid="blank_template" OR bid="buyimpressions_template" OR bid="cron_template" OR bid="default_template" OR bid="error_template" OR bid="fzdisplay_template" OR bid="index_template" OR bid="preview_text_ad_template" OR bid="rss_template" OR bid="story_template" OR bid="submitrdf_template" OR bid="submit_template" OR bid="renewad_template" OR bid="dynamic_template";
UPDATE blocks SET category="site_html" WHERE bid="attach_poll_message" OR bid="commentdisclaimer" OR bid="diary_submission_message" OR bid="dot" OR bid="footer" OR bid="header" OR bid="hotlist_link" OR bid="hotlist_remove_link" OR bid="login_box" OR bid="moderate_head" OR bid="new_comment_marker" OR bid="new_user_html" OR bid="next_page_link" OR bid="no_body_txt" OR bid="poll_guidelines" OR bid="prev_page_link" OR bid="readmore_txt" OR bid="scoop_intro" OR bid="section_links" OR bid="story_separator" OR bid="submission_guidelines" OR bid="submission_message" OR bid="submit_rdf_message" OR bid="subscribe" OR bid="vote_console" OR bid="author_edit_console" OR bid="author_edit_instructions" OR bid="edit_instructions" OR bid="dynamic_expand_link" OR bid="dynamic_collapse_link" OR bid="dynamic_loading_link" OR bid="dynamic_collapse_bottom_link";
UPDATE blocks SET category="advertising,email" WHERE bid="ad_approval_mail" OR bid="ad_disapproval_mail" OR bid="mail_ad_almost_done_msg" OR bid="mail_ad_done_msg" OR bid="ad_renewal_mail";

ALTER TABLE blocks DROP PRIMARY KEY, ADD PRIMARY KEY(bid,category,theme,language);

UPDATE blocks SET description="The email address of administrators - used to email alerts when Scoop detects a problem." WHERE bid="admin_alert";
UPDATE blocks SET description="A warning and reminder of the terms of use of an advertising account." WHERE bid="advertising_account_disclaimer";
UPDATE blocks SET description="The text of the email sent when an ad is approved." WHERE bid="ad_approval_mail";
UPDATE blocks SET description="Text shown on ad preview page, just before purchase." WHERE bid="ad_confirm_text";
UPDATE blocks SET description="The text of the email sent when an ad is disapproved." WHERE bid="ad_disapproval_mail";
UPDATE blocks SET description="The text of the email sent when an ad is renewed." WHERE bid="ad_renewal_mail";
UPDATE blocks SET description="Rules for submitting ads.  Insert your site's rules in the list." WHERE bid="ad_step1_rules";
UPDATE blocks SET description="A page template with just the ad on it" WHERE bid="ad_test_template";
UPDATE blocks SET description="The HTML tags Scoop will allow users to use in stories and comments. Lists the tag name, followed by an optional comma-separated list of elements allowed inside that tag. If the tag must be closed, end the list with '-close'." WHERE bid="allowed_html";
UPDATE blocks SET description="All HTML tags" WHERE bid="all_html";
UPDATE blocks SET description="The message displayed just above the poll form, below the story submission form, telling the user about the poll." WHERE bid="attach_poll_message";
UPDATE blocks SET description="The editing console for the story author, when the story is in the edit queue." WHERE bid="author_edit_console";
UPDATE blocks SET description="Instructions to the author when story is in editing mode." WHERE bid="author_edit_instructions";
UPDATE blocks SET description="The \"What's related\" box lists all the links used in the story, but the autorelated box adds a link to that list if a word (listed here) shows up in the story, whether it is a link or not. List the word you want it to detect, a comma, and the URL, with no spaces and one per line." WHERE bid="autorelated";
UPDATE blocks SET description="A template for a basic graphical banner ad." WHERE bid="basic2_banner_ad_template";
UPDATE blocks SET description="A template for a basic graphical banner ad." WHERE bid="basic_banner_ad_template";
UPDATE blocks SET description="A box template - no title bar or border." WHERE bid="blank_box";
UPDATE blocks SET description="A page template - no header, footer, or content. This must be a complete HTML page." WHERE bid="blank_template";
UPDATE blocks SET description="A box template - the default one with the blue title bar. The special vars |title| and |content| are supplied by the box code" WHERE bid="box";
UPDATE blocks SET description="The background colour of the title bar used in a box template. A hexadecimal colour value: #rrggbb (r = red, g = green, b = blue)" WHERE bid="box_title_bg";
UPDATE blocks SET description="A page template to hold the box buyimpressions_box." WHERE bid="buyimpressions_template";
UPDATE blocks SET description="directions on buying ad impressions separately from ads." WHERE bid="buy_ad_impression_message";
UPDATE blocks SET description="The structure of comments attached to a story. This should be mostly self-contained and have the replies at the end.  See http://guide.kuro5hin.org for details on the special vars." WHERE bid="comment";
UPDATE blocks SET description="Anything you want to display above the comment posting form." WHERE bid="commentdisclaimer";
UPDATE blocks SET description="The background colour of the comment title bar. A hexadecimal colour value: #rrggbb (r = red, g = green, b = blue)" WHERE bid="comment_head_bg";
UPDATE blocks SET description="Text of the confirm message just before ad renewal." WHERE bid="confirm_ad_renew";
UPDATE blocks SET description="Text of the confirm message just before purchase." WHERE bid="confirm_purchase_impressions";
UPDATE blocks SET description="A page template. No header or footer, only |CONTENT| and title. This must be a complete HTML page. This is used for when cron is run, and is parsed (to an extent) by run_cron.pl, so you'd best just leave this be." WHERE bid="cron_template";
UPDATE blocks SET description="A page template. This is the default template, used for most pages on the site.  Be EXTREMELY careful when changing this template! If you mess it up, you may not be able to do anything - the admin pages may use this template!  See http://guide.kuro5hin.org for details on the special vars." WHERE bid="default_template";
UPDATE blocks SET description="A complete opening font tag. Used if use_dept is enabled." WHERE bid="dept_font";
UPDATE blocks SET description="The message displayed underneath a user's diary entry when they have just posted it. Basically free-form HTML." WHERE bid="diary_submission_message";
UPDATE blocks SET description="The text of the header and footer of emails sent with the story digest system. The strings __FREQUENCY__ and __USERID__ are replaced with the appropriate values when the email is sent. \n is a newline character, though a normal newline also works." WHERE bid="digest_headerfooter";
UPDATE blocks SET description="The format of the stories listed in the digest email.  See http://guide.kuro5hin.org for details on the string substitution" WHERE bid="digest_storyformat";
UPDATE blocks SET description="Any bit of HTML code that produces a dot or bullet or something for lists in the boxes along the side." WHERE bid="dot";
UPDATE blocks SET description="Text or image of the link to collapse a comment, placed at the bottom of the comment." WHERE bid="dynamic_collapse_bottom_link";
UPDATE blocks SET description="Text or image of the link to collapse a comment" WHERE bid="dynamic_collapse_link";
UPDATE blocks SET description="Text or image of the link to expand a comment" WHERE bid="dynamic_expand_link";
UPDATE blocks SET description="Text or image of the comment loading message" WHERE bid="dynamic_loading_link";
UPDATE blocks SET description="Page template for dynamic comment display mode" WHERE bid="dynamic_template";
UPDATE blocks SET description="Background colour of a story in the edit queue" WHERE bid="editqueuestory_bg";
UPDATE blocks SET description="Instructions to the author regarding story editing" WHERE bid="edit_instructions";
UPDATE blocks SET description="A box template that contains no framing, no formatting, just the content via the special var |content|" WHERE bid="empty_box";
UPDATE blocks SET description="A layout for error messages when scoop really chokes." WHERE bid="error_template";
UPDATE blocks SET description="Whatever HTML you wish to have displayed at the bottom of every page generated." WHERE bid="footer";
UPDATE blocks SET description="Forumzilla stuff." WHERE bid="fzdisplay_template";
UPDATE blocks SET description="Forumzilla stuff." WHERE bid="fz_ad_url";
UPDATE blocks SET description="Forumzilla stuff." WHERE bid="fz_navigation_url";
UPDATE blocks SET description="Whatever HTML you wish to have displayed at the top of every page generated." WHERE bid="header";
UPDATE blocks SET description="The text of the link provided beside each story title that allows people to add stories to their hotlist." WHERE bid="hotlist_link";
UPDATE blocks SET description="The text of the link provided beside each story title that allows people to remove stories from their hotlist." WHERE bid="hotlist_remove_link";
UPDATE blocks SET description="A page template. This is typically the template used for the front page and section pages, but rarely anything else." WHERE bid="index_template";
UPDATE blocks SET description="Not a box template. This is the content put into the user box if a visitor is not logged in.  This should contain a form with two text inputs, one named \"uname\" and one named \"pass\" for the visitor to input their username and password, respectively, and two submit buttons, one named \"login\" with a value of \"login\" and one named \"mailpass\" with a value of \"Mail Password\"." WHERE bid="login_box";
UPDATE blocks SET description="The text of the email sent by the system when impressions are almost gone from a given ad." WHERE bid="mail_ad_almost_done_msg";
UPDATE blocks SET description="The text of the email sent by the system when impressions are gone from a given ad." WHERE bid="mail_ad_done_msg";
UPDATE blocks SET description="This is the text put at the top of the moderation box after a visitor has voted on a story." WHERE bid="moderate_head";
UPDATE blocks SET description="This is just like the block comment, only it is used for 'editorial' instead of 'topical' comments.  This uses all the same special and normal vars as the block comment." WHERE bid="moderation_comment";
UPDATE blocks SET description="A form used for collecting contact information from new advertisers." WHERE bid="new_advertiser_html";
UPDATE blocks SET description="This is inserted by the code with the comment title if a visitor has not yet read that title." WHERE bid="new_comment_marker";
UPDATE blocks SET description="The HTML form and explanation text used on the page a new user visits to create an account." WHERE bid="new_user_html";
UPDATE blocks SET description="This is the text of the link to the next page of stories. It is placed after the last story on a page." WHERE bid="next_page_link";
UPDATE blocks SET description="This is the text of the link used instead of readmore_txt if there is nothing in the body of the story." WHERE bid="no_body_txt";
UPDATE blocks SET description="Error message telling a user they don't have the permissions required to submit ads to the site." WHERE bid="no_submit_ad_perm";
UPDATE blocks SET description="This is a list of aliases to various op codes: alias=real, one per line." WHERE bid="op_aliases";
UPDATE blocks SET description="This block sets the rules used for the new URL style. Unless you add an op, or want to tweak the rules, you won't need to change this.  For details on the format, see http://guide.kuro5hin.org." WHERE bid="op_templates";
UPDATE blocks SET description="Text displayed if somebody cancelled their order of ads" WHERE bid="paypal_canceled";
UPDATE blocks SEt description="Text displayed after somebody finished paying for their ad through paypal" WHERE bid="paypal_finished";
UPDATE blocks SET description="The background colour of a story that is still in moderation. Used only in the story list. A hexadecimal colour value: #rrggbb (r = red, g = green, b = blue)" WHERE bid="pendingstory_bg";
UPDATE blocks SET description="A list of all the perms used on the system." WHERE bid="perms";
UPDATE blocks SET description="Used by Scoop to format and display a poll." WHERE bid="poll_block";
UPDATE blocks SET description="A box template. This one is used for the poll." WHERE bid="poll_box";
UPDATE blocks SET description="Not used" WHERE bid="poll_guidelines";
UPDATE blocks SET description="The text ad template used when previewing a new ad." WHERE bid="preview_text_ad_template";
UPDATE blocks SET description="This is the text of the link to the previous page of stories. It is placed at the top and bottom of the page when a visitor is on a page other than the first, or only the bottom when on the first page." WHERE bid="prev_page_link";
UPDATE blocks SET description="The text of the link at the bottom of the story summary if the story has body text that is not displayed. If the story does not have body text, the block no_body_text is used instead." WHERE bid="readmore_txt";
UPDATE blocks SET description="Page template to hold the renewad box" WHERE bid="renewad_template";
UPDATE blocks SET description="Text displayed to get people to renew ads" WHERE bid="renew_ad_message";
UPDATE blocks SET description="Message displayed if somebody tries to renew a different user\'s ad" WHERE bid="renew_ad_no_permission";
UPDATE blocks SET description="Message displayed to tell the person that they need to choose an ad to renew before they can renew anything" WHERE bid="renew_choose_ad";
UPDATE blocks SET description="Message displayed just before ad renewal purchase, getting the user to double-check that everything is correct" WHERE bid="renew_confirm_message";
UPDATE blocks SET description="Template for the ForumZilla boxes. Probably shouldn't change this, since doing so will probably break ForumZilla support." WHERE bid="rss_box";
UPDATE blocks SET description="Page template used for ForumZilla. Shouldn't change this either." WHERE bid="rss_template";
UPDATE blocks SET description="The 'introduction to scoop' box shown in the left column of the front page of a fresh install. You probably want to note the addresses of the links and remove it from the page before your site goes live." WHERE bid="scoop_intro";
UPDATE blocks SET description="The background colour of a story that is displayed only in the section. Used only in the story list. A hexadecimal colour value: #rrggbb (r = red, g = green, b = blue)" WHERE bid="sectiononlystory_bg";
UPDATE blocks SET description="The links to the different sections. Usually only displayed in the block header." WHERE bid="section_links";
UPDATE blocks SET description="A complete opening font tag for text that must be smaller than normal." WHERE bid="smallfont";
UPDATE blocks SET description="A closing font tag to match block smallfont." WHERE bid="smallfont_end";
UPDATE blocks SET description="A complete opening font tag for marking spelling errors.  Only used if spell checking is active." WHERE bid="spell_err";
UPDATE blocks SET description="A closing font tag matching spell_err" WHERE bid="spell_err_end";
UPDATE blocks SET description="How the body text of a story is displayed. This should be a reasonably self-contained piece of HTML. There is only one special var used: |bodytext| is replaced by the text of the story body." WHERE bid="story_body";
UPDATE blocks SET description="The bar placed at the top and bottom of the comments. It contains the story name, number and type of comments, and the 'post a comment' link." WHERE bid="story_info";
UPDATE blocks SET description="The background colour of a story in moderation that the user has not yet voted on.  A hexadecimal colour value: #rrggbb (r = red, g = green, b = blue)" WHERE bid="story_mod_bg";
UPDATE blocks SET description="The background colour of the story navigation bar. A hexadecimal colour value: #rrggbb (r = red, g = green, b = blue)" WHERE bid="story_nav_bg";
UPDATE blocks SET description="Placed between the story summary and the story body to separate them visually." WHERE bid="story_separator";
UPDATE blocks SET description="The layout of the story header and introtext. This should be a reasonably self-contained bit of HTML.  See http://guide.kuro5hin.org for details on the special vars." WHERE bid="story_summary";
UPDATE blocks SET description="A page template. This one is used to display the full story and its comments." WHERE bid="story_template";
UPDATE blocks SET description="Warnings and instructions displayed on the story submission page, just above the form. This is basically free-form HTML." WHERE bid="submission_guidelines";
UPDATE blocks SET description="The message displayed at the bottom of the story when it has just been posted to the moderation queue, thanking the user for submitting a story." WHERE bid="submission_message";
UPDATE blocks SET description="A page template. This one is used when users submit RDF feeds. No special vars, just the submit_rdf box." WHERE bid="submitrdf_template";
UPDATE blocks SET description="The background colour of a story in the moderation queue. Used only in the story list. A hexadecimal colour value: #rrggbb (r = red, g = green, b = blue)" WHERE bid="submittedstory_bg";
UPDATE blocks SET description="The message displayed explaining how to submit an rdf feed." WHERE bid="submit_rdf_message";
UPDATE blocks SET description="A page template. This one is used when a user is composing a story." WHERE bid="submit_template";
UPDATE blocks SET description="Text of a \"please subscribe\" message." WHERE bid="subscribe";
UPDATE blocks SET description="The template used for text ads." WHERE bid="text_ad_template";
UPDATE blocks SET description="A box template. This one has both |title| and |content| but is otherwise plain." WHERE bid="titled_box";
UPDATE blocks SET description="The background colour used for titles. A hexadecimal colour value: #rrggbb (r = red, g = green, b = blue)" WHERE bid="title_bgcolor";
UPDATE blocks SET description="The background colour used for stories that have been hidden. Used only in the story list. A hexadecimal colour value: #rrggbb (r = red, g = green, b = blue)" WHERE bid="undisplayedstory_bg";
UPDATE blocks SET description="The story moderation form, displayed below the story for stories in the moderation queue. There is only one special var: |vote_form| is replaced with the actual form used to register votes." WHERE bid="vote_console";

INSERT INTO blocks VALUES ('block_category_list','<tr>\r\n<td>%%norm_font%%<a href=\"%%rootdir%%/admin/blocks/%%item_url%%\">%%item%%</a>%%norm_font_end%%</td>\r\n<td>%%norm_font%%<a href=\"%%rootdir%%/admin/blocks/%%item_url%%\">%%item%%</a>%%norm_font_end%%</td>\r\n<td>%%norm_font%%<a href=\"%%rootdir%%/admin/blocks/%%item_url%%\">%%item%%</a>%%norm_font_end%%</td>\r\n</tr>\r\n',NULL,'One line of the block category list.  Usually one table row.','admin_pages','default','en');
INSERT INTO blocks VALUES ('edit_block','<form name=\"editblocks\" action=\"%%rootdir%%/admin/blocks/\" method=\"post\">\r\n<input type=\"hidden\" name=\"cat\" value=\"%%category%%\" />\r\n\r\n<table border=\"0\" cellpadding=\"2\" cellspacing=\"0\" width=\"100%\">\r\n<tr><td bgcolor=\"%%title_bgcolor%%\">%%title_font%%Blocks: %%category%%%%title_font_end%%</td></tr>\r\n<tr><td>%%norm_font%%%%update_msg%%%%norm_font_end%%</td></tr>\r\n<tr><td> </td></tr>\r\n<tr><td>%%norm_font%%Choose a category to edit:%%norm_font_end%%</td></tr>\r\n<tr><td>\r\n	<table border=\"0\" cellpadding=\"0\" cellspacing=\"2\" width=\"100%\">%%catlist%%</table>\r\n</td></tr>\r\n<tr><td>%%norm_font%%<input type=\"submit\" name=\"save\" value=\"Save\"> <input type=\"submit\" name=\"edit\" value=\"Get\" />%%norm_font_end%%</td></tr>\r\n<tr><td>%%norm_font%%%%html_check%%%%norm_font_end%%</td></tr>\r\n<tr><td>\r\n	<table border=0 cellpadding=1 cellspacing=0 width=\"100%\">%%form_body%%</table>\r\n</td></tr>\r\n<tr><td>%%norm_font%%<input type=\"submit\" name=\"save\" value=\"Save\"> <input type=\"submit\" name=\"edit\" value=\"Get\" />%%norm_font_end%%</td></tr>\r\n</table>\r\n</form>\r\n',NULL,'The main edit block page.  the special var \"form_body\" is either the single-block edit form, or the category table, depending on which view you\'re using.','admin_pages','default','en');
INSERT INTO blocks VALUES ('edit_cat_blocks','<!-- category line begin -->\r\n<tr>\r\n	<td>\r\n		%%norm_font%%%%name%%<br />\r\n		%%description%%%%norm_font_end%%\r\n	</td>\r\n	<td>%%norm_font%%%%value%%%%norm_font_end%%</td>\r\n</tr>\r\n<!--category line end -->\r\n',NULL,'One line of the table all blocks in one category are placed in.  Special vars name, description, and value are a link, plain text, and a textarea, respectively, that are substituted in.','admin_pages','default','en');
INSERT INTO blocks VALUES ('edit_cat_vars','<tr>\r\n	<td>%%norm_font%%%%name%%%%norm_font_end%%</td>\r\n	<td>%%norm_font%%%%value%%%%norm_font_end%%</td>\r\n	<td>%%norm_font%%%%description%%%%norm_font_end%%</td>\r\n</tr>\r\n',NULL,'One line of the table all vars in one category are placed in.  Special vars name, value, and description are a link, the appropriate input element for the var type, and text, respectively','admin_pages','default','en');
INSERT INTO blocks VALUES ('edit_one_block','<tr><td>%%norm_font%%Or edit a block directly:%%norm_font_end%%</td></tr>\r\n<tr><td><table cellspacing=\"2\" cellpadding=\"0\" width=\"100%\">\r\n	<tr>\r\n		<td colspan=\"2\">%%norm_font%%<b>Delete:</b><input type=\"checkbox\" name=\"delete\" value=\"1\">%%norm_font_end%%</td>\r\n	</tr>\r\n	<tr>\r\n		<td>%%norm_font%%<b>Select Block:</b>%%norm_font_end%%</td>\r\n		<td>%%blockselect%%</td>\r\n	</tr>\r\n	<tr>\r\n		<td>%%norm_font%%<b>Select Categories:</b>%%norm_font_end%%</td>\r\n		<td>%%catselect%%</td>\r\n	</tr>\r\n	<tr>\r\n		<td>%%norm_font%%<b>Name:</b>%%norm_font_end%%</td>\r\n		<td><input type=\"text\" size=\"60\" name=\"name\" value=\"%%bid%%\"></td>\r\n	</tr>\r\n	<tr>\r\n		<td>%%norm_font%%<b>Theme:</b>%%norm_font_end%%</td>\r\n		<td><input type=\"text\" size=\"60\" name=\"theme\" value=\"%%theme%%\"></td>\r\n	</tr>\r\n	<tr>\r\n		<td>%%norm_font%%<b>New Category:</b>%%norm_font_end%%</td>\r\n		<td><input type=\"text\" size=\"60\" name=\"category\" value=\"\"><br>\r\n			%%norm_font%%<i>(seperate multiple categories with commas)</i>%%norm_font_end%%\r\n		</td>\r\n	</tr>\r\n	<tr>\r\n		<td colspan=\"2\">\r\n			%%norm_font%%<b>Value:</b>%%norm_font_end%%<br>\r\n			<textarea cols=\"60\" rows=\"20\" name=\"value\" wrap=\"soft\">%%value%%</textarea>\r\n		</td>\r\n	</tr>\r\n	<tr>\r\n		<td colspan=\"2\">\r\n			%%norm_font%%<b>Description:</b>%%norm_font_end%%<br>\r\n			<textarea cols=\"60\" rows=\"5\" name=\"description\"\r\n			wrap=\"soft\">%%description%%</textarea>\r\n		</td>\r\n	</tr>\r\n</table></td></tr>\r\n',NULL,'The form to edit all aspects of a single block','admin_pages','default','en');
INSERT INTO blocks VALUES ('edit_one_var','<tr><td>%%norm_font%%Or edit a variable directly:%%norm_font_end%%</td></tr>\r\n<tr><td><table cellspacing=\"2\" cellpadding=\"0\" width=\"100%\">\r\n	<tr>\r\n		<td colspan=\"2\">%%norm_font%%<b>Delete:</b><input type=\"checkbox\" name=\"delete\" value=\"1\" />%%norm_font_end%%</td>\r\n	</tr>\r\n	<tr>\r\n		<td>%%norm_font%%<b>Type:</b>%%norm_font_end%%</td>\r\n		<td>%%typeselect%%</td>\r\n	</tr>\r\n	<tr>\r\n		<td>%%norm_font%%<b>Select Variable:</b>%%norm_font_end%%</td>\r\n		<td>%%varselect%%</td>\r\n	<tr>\r\n		<td>%%norm_font%%<b>Select Categories:</b>%%norm_font_end%%</td>\r\n		<td>%%catselect%%</td>\r\n	</tr>\r\n	<tr>\r\n		<td>%%norm_font%%<b>Name:</b>%%norm_font_end%%</td>\r\n		<td><input type=\"text\" size=\"60\" name=\"name\" value=\"%%name%%\" /></td>\r\n	</tr>\r\n	<tr>\r\n		<td>%%norm_font%%<b>New Category:</b>%%norm_font_end%%</td>\r\n		<td><input type=\"text\" size=\"60\" name=\"category\" value=\"\"><br />\r\n			%%norm_font%%<i>(seperate multiple categories with commas)</i>%%norm_font_end%%\r\n		</td>\r\n	</tr>\r\n	<tr>\r\n		<td colspan=\"2\">\r\n			%%norm_font%%<b>Value:</b>%%norm_font_end%%<br />\r\n			<textarea cols=\"60\" rows=\"2\" name=\"value\" wrap=\"soft\">%%value%%</textarea>\r\n		</td>\r\n	</tr>\r\n	<tr>\r\n		<td colspan=\"2\">\r\n			%%norm_font%%<b>Description:</b>%%norm_font_end%%<br />\r\n			<textarea cols=\"60\" rows=\"3\" name=\"description\" wrap=\"soft\">%%description%%</textarea>\r\n		</td>\r\n	</tr>\r\n</table></td></tr>\r\n',NULL,'','admin_pages','default','en');
INSERT INTO blocks VALUES ('edit_var','<form name=\"editvars\" action=\"%%rootdir%%/admin/vars/\" method=\"post\">\r\n<input type=\"hidden\" name=\"cat\" value=\"%%category%%\" />\r\n\r\n<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\r\n<tr><td bgcolor=\"%%title_bgcolor%%\">%%title_font%%Site Controls: %%category%%%%title_font_end%%</td></tr>\r\n<tr><td>%%norm_font%%%%update_msg%%%%norm_font_end%%</td></tr>\r\n<tr><td> </td></tr>\r\n<tr><td>%%norm_font%%Choose a category to edit:%%norm_font_end%%</td></tr>\r\n<tr><td>\r\n	<table border=\"0\" cellpadding=\"0\" cellspacing=\"2\" width=\"100%\">%%catlist%%</table>\r\n</td></tr>\r\n<tr><td>%%norm_font%%<input type=\"submit\" name=\"save\" value=\"Save\" /> <input type=\"submit\" name=\"edit\" value=\"Get\" />%%norm_font_end%%</td></tr>\r\n<tr><td><table border=\"0\" cellpadding=\"2\" cellspacing=\"0\" width=\"100%\">%%form_body%%</table></td></tr>\r\n<tr><td>%%norm_font%%<input type=\"submit\" name=\"save\" value=\"Save\" /> <input type=\"submit\" name=\"edit\" value=\"Get\" />%%norm_font_end%%</td></tr>\r\n</table>\r\n</form>\r\n',NULL,'The main edit var page.  The special var \"form_body\" is either the single-var edit form, or the category table, depending on which view you\'re using.','admin_pages','default','en');
INSERT INTO blocks VALUES ('var_category_list','<tr>\r\n	<td>%%norm_font%%<a href=\"%%rootdir%%/admin/vars/%%item_url%%\">%%item%%</a>%%norm_font_end%%</td>\r\n	<td>%%norm_font%%<a href=\"%%rootdir%%/admin/vars/%%item_url%%\">%%item%%</a>%%norm_font_end%%</td>\r\n	<td>%%norm_font%%<a href=\"%%rootdir%%/admin/vars/%%item_url%%\">%%item%%</a>%%norm_font_end%%</td>\r\n</tr>\r\n',NULL,'One line of the var category list.  Usually one table row.','admin_pages','default','en');
