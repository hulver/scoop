DELETE FROM vars WHERE name = "ads_in_everything_sec";
DELETE FROM vars WHERE name = "use_diaries";
INSERT IGNORE INTO vars VALUES ("story_nav_bar_sections","Diary","This contains a comma separated of sections. Stories from sections in this list will not be displayed in the story navigation bar \(the next and previous story\) that appears at the bottom of each story if disable_story_navbar is not set. If a story is in a section that appears in this list, then it only displays next and previous stories from within that section","text","Stories");
INSERT IGNORE INTO vars VALUES ("search_special_sections","Diary","Special sections on the search page have their own entry in the drop down list of things to search","text","Search");
