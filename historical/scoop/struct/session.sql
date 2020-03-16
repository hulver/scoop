--

DROP TABLE IF EXISTS `sessions`;
CREATE TABLE `sessions` (
  `session_id` varchar(32) NOT NULL default '',
  `item` varchar(255) NOT NULL default '',
  `value` text,
  `serialized` int(1) default '0',
  `last_update` datetime default NULL,
  PRIMARY KEY  (`session_id`,`item`)
) TYPE=MyISAM;

--
