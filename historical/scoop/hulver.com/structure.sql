-- MySQL dump 10.11
--
-- Host: localhost    Database: scoop
-- ------------------------------------------------------
-- Server version	5.0.32-Debian_7etch8-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ops`
--

DROP TABLE IF EXISTS `ops`;
CREATE TABLE `ops` (
  `op` varchar(50) NOT NULL default '',
  `template` varchar(30) NOT NULL default '',
  `func` varchar(50) default NULL,
  `is_box` int(1) default '0',
  `enabled` int(1) default '1',
  `perm` varchar(50) default '',
  `aliases` varchar(255) NOT NULL default '',
  `urltemplates` text NOT NULL,
  `description` text,
  PRIMARY KEY  (`op`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-10-03 12:29:20
-- MySQL dump 10.11
--
-- Host: localhost    Database: scoop
-- ------------------------------------------------------
-- Server version	5.0.32-Debian_7etch8-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
CREATE TABLE `accounts` (
  `trans_id` int(11) NOT NULL auto_increment,
  `desc_id` int(11) default NULL,
  `amt_in` decimal(10,2) default NULL,
  `amt_out` decimal(10,2) default NULL,
  `trans_date` date default NULL,
  `uid` int(11) default NULL,
  `user_email` varchar(255) default NULL,
  PRIMARY KEY  (`trans_id`)
) ENGINE=MyISAM AUTO_INCREMENT=284 DEFAULT CHARSET=utf8;

--
-- Table structure for table `accounts_desc`
--

DROP TABLE IF EXISTS `accounts_desc`;
CREATE TABLE `accounts_desc` (
  `desc_id` int(11) NOT NULL auto_increment,
  `description` varchar(200) default NULL,
  PRIMARY KEY  (`desc_id`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

--
-- Table structure for table `ad_info`
--

DROP TABLE IF EXISTS `ad_info`;
CREATE TABLE `ad_info` (
  `ad_id` int(11) NOT NULL auto_increment,
  `ad_tmpl` varchar(30) default NULL,
  `ad_file` varchar(255) default NULL,
  `ad_url` varchar(255) default NULL,
  `ad_text1` text,
  `ad_text2` text,
  `views_left` int(11) default '0',
  `first_day` date default NULL,
  `perpetual` int(1) default '0',
  `last_seen` datetime default NULL,
  `sponsor` int(11) default NULL,
  `active` int(1) default '0',
  `example` int(1) default '0',
  `ad_title` varchar(255) default NULL,
  `submitted_on` datetime default NULL,
  `view_count` int(11) default '0',
  `click_throughs` int(11) default '0',
  `judged` int(1) default '0',
  `reason` text,
  `paid` int(1) default NULL,
  `purchase_size` int(11) default '0',
  `purchase_price` decimal(7,2) default '0.00',
  `judger` int(11) default NULL,
  `approved` int(1) default NULL,
  `impression_cache` int(11) default '0',
  `pos` int(5) NOT NULL default '1',
  `ad_sid` varchar(20) default NULL,
  PRIMARY KEY  (`ad_id`),
  KEY `seen_active` (`active`,`last_seen`,`ad_tmpl`),
  KEY `pos_idx` (`pos`)
) ENGINE=MyISAM AUTO_INCREMENT=742 DEFAULT CHARSET=utf8;

--
-- Table structure for table `ad_log`
--

DROP TABLE IF EXISTS `ad_log`;
CREATE TABLE `ad_log` (
  `req_num` bigint(20) NOT NULL auto_increment,
  `req_time` int(11) NOT NULL default '0',
  `requestor` int(11) NOT NULL default '0',
  `request_ip` varchar(16) NOT NULL default '',
  `ad_id` int(11) NOT NULL default '0',
  `req_type` varchar(20) NOT NULL default '',
  PRIMARY KEY  (`req_num`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `ad_payments`
--

DROP TABLE IF EXISTS `ad_payments`;
CREATE TABLE `ad_payments` (
  `ad_id` int(11) NOT NULL default '0',
  `order_id` varchar(50) NOT NULL default '',
  `cost` decimal(7,2) NOT NULL default '0.00',
  `pay_type` varchar(10) NOT NULL default '',
  `auth_date` date NOT NULL default '0000-00-00',
  `final_date` date default NULL,
  `paid` int(1) default NULL,
  PRIMARY KEY  (`ad_id`,`order_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `ad_types`
--

DROP TABLE IF EXISTS `ad_types`;
CREATE TABLE `ad_types` (
  `type_template` varchar(30) NOT NULL default '',
  `type_name` varchar(50) NOT NULL default '',
  `short_desc` varchar(255) NOT NULL default '',
  `submit_instructions` text,
  `max_file_size` int(11) default NULL,
  `max_text1_chars` int(5) default NULL,
  `max_text2_chars` int(5) default NULL,
  `max_title_chars` int(5) default NULL,
  `cpm` decimal(7,2) default NULL,
  `active` int(1) NOT NULL default '0',
  `min_purchase_size` int(7) default NULL,
  `max_purchase_size` int(7) default '100000',
  `pos` int(5) NOT NULL default '1',
  `allow_discussion` int(1) default '0',
  PRIMARY KEY  (`type_template`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `admin_tools`
--

DROP TABLE IF EXISTS `admin_tools`;
CREATE TABLE `admin_tools` (
  `tool` varchar(20) NOT NULL default '',
  `pos` int(2) NOT NULL default '0',
  `dispname` varchar(60) NOT NULL default '',
  `menuname` varchar(60) NOT NULL default '',
  `perm` varchar(50) NOT NULL default '',
  `func` varchar(50) NOT NULL default '',
  `is_box` int(1) default '0',
  PRIMARY KEY  (`tool`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `advertisers`
--

DROP TABLE IF EXISTS `advertisers`;
CREATE TABLE `advertisers` (
  `advertisor_id` int(11) NOT NULL default '0',
  `contact_name` varchar(255) NOT NULL default '',
  `contact_phone` varchar(20) default NULL,
  `company_name` varchar(255) NOT NULL default '',
  `snail_mail` varchar(255) default NULL,
  PRIMARY KEY  (`advertisor_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `amazon_check`
--

DROP TABLE IF EXISTS `amazon_check`;
CREATE TABLE `amazon_check` (
  `sid` varchar(20) NOT NULL default '',
  `need_update` int(1) NOT NULL default '1',
  PRIMARY KEY  (`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `amazon_local`
--

DROP TABLE IF EXISTS `amazon_local`;
CREATE TABLE `amazon_local` (
  `local_id` int(11) NOT NULL auto_increment,
  `prod_id` int(11) default NULL,
  `asin` varchar(40) default NULL,
  `site_id` int(11) default NULL,
  `details_url` varchar(255) default NULL,
  `img_url_small` varchar(255) default NULL,
  `img_url_medium` varchar(255) default NULL,
  `img_url_large` varchar(255) default NULL,
  `list_price` varchar(30) default NULL,
  `our_price` varchar(30) default NULL,
  `used_price` varchar(30) default NULL,
  `price_date` datetime default NULL,
  `need_update` int(1) default '0',
  PRIMARY KEY  (`local_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `amazon_prod`
--

DROP TABLE IF EXISTS `amazon_prod`;
CREATE TABLE `amazon_prod` (
  `prod_id` int(11) NOT NULL auto_increment,
  `product_name` varchar(255) default NULL,
  `author` varchar(255) default NULL,
  `manufac` varchar(255) default NULL,
  `catalog` varchar(90) default NULL,
  `sid` varchar(20) default NULL,
  PRIMARY KEY  (`prod_id`),
  KEY `prod_sid` (`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `amazon_review`
--

DROP TABLE IF EXISTS `amazon_review`;
CREATE TABLE `amazon_review` (
  `local_id` int(11) default NULL,
  `rating` varchar(10) default NULL,
  `summary` text,
  `comment` text,
  KEY `local_id_ind` (`local_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `amazon_sites`
--

DROP TABLE IF EXISTS `amazon_sites`;
CREATE TABLE `amazon_sites` (
  `site_id` int(11) NOT NULL auto_increment,
  `site_description` varchar(255) default NULL,
  `site_url` varchar(255) NOT NULL default '',
  `associate_id` varchar(25) default NULL,
  `country_code` varchar(2) default NULL,
  `automatic_update` char(1) default '0',
  PRIMARY KEY  (`site_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `amazon_story`
--

DROP TABLE IF EXISTS `amazon_story`;
CREATE TABLE `amazon_story` (
  `sid` varchar(20) NOT NULL default '',
  `prod_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`sid`,`prod_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `blocks`
--

DROP TABLE IF EXISTS `blocks`;
CREATE TABLE `blocks` (
  `bid` varchar(30) NOT NULL default '',
  `block` text,
  `aid` varchar(20) default NULL,
  `description` text,
  `category` varchar(128) NOT NULL default 'general',
  `theme` varchar(32) NOT NULL default 'default',
  `language` varchar(10) NOT NULL default 'en',
  PRIMARY KEY  (`bid`,`theme`,`language`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `box`
--

DROP TABLE IF EXISTS `box`;
CREATE TABLE `box` (
  `boxid` varchar(50) NOT NULL default '',
  `title` varchar(50) NOT NULL default '',
  `content` text NOT NULL,
  `description` text,
  `template` varchar(39) NOT NULL default '',
  `user_choose` int(1) default '0',
  PRIMARY KEY  (`boxid`),
  KEY `user_choose_idx` (`user_choose`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `cache_time`
--

DROP TABLE IF EXISTS `cache_time`;
CREATE TABLE `cache_time` (
  `resource` varchar(50) NOT NULL default '',
  `last_update` int(11) NOT NULL default '0',
  PRIMARY KEY  (`resource`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `calendar_link`
--

DROP TABLE IF EXISTS `calendar_link`;
CREATE TABLE `calendar_link` (
  `eid` int(11) NOT NULL default '0',
  `cal_id` int(11) NOT NULL default '0',
  `is_primary_calendar` tinyint(1) NOT NULL default '0',
  `displaystatus` tinyint(1) default '0',
  PRIMARY KEY  (`eid`,`cal_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `calendars`
--

DROP TABLE IF EXISTS `calendars`;
CREATE TABLE `calendars` (
  `cal_id` int(11) NOT NULL auto_increment,
  `title` varchar(100) default NULL,
  `owner` int(11) default '0',
  `description` text,
  `public_view` varchar(10) default 'public',
  `public_submit` varchar(10) default 'private',
  PRIMARY KEY  (`cal_id`),
  KEY `owner_idx` (`owner`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Table structure for table `commentcodes`
--

DROP TABLE IF EXISTS `commentcodes`;
CREATE TABLE `commentcodes` (
  `code` int(1) NOT NULL default '0',
  `name` varchar(32) default NULL,
  PRIMARY KEY  (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `commentratings`
--

DROP TABLE IF EXISTS `commentratings`;
CREATE TABLE `commentratings` (
  `uid` int(1) NOT NULL default '0',
  `rating` int(11) NOT NULL default '0',
  `cid` int(15) NOT NULL default '0',
  `sid` varchar(30) NOT NULL default '',
  `rating_time` datetime default '0000-00-00 00:00:00',
  `rater_ip` varchar(16) NOT NULL default '',
  PRIMARY KEY  (`sid`,`cid`,`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
CREATE TABLE `comments` (
  `sid` varchar(30) NOT NULL default '',
  `cid` int(15) NOT NULL default '0',
  `pid` int(15) NOT NULL default '0',
  `date` datetime default NULL,
  `rank` int(1) default NULL,
  `subject` varchar(50) NOT NULL default '',
  `comment` text NOT NULL,
  `pending` int(1) default '0',
  `uid` int(1) NOT NULL default '-1',
  `points` decimal(4,2) default NULL,
  `lastmod` int(1) default '-1',
  `sig_status` int(1) default '1',
  `sig` varchar(255) default NULL,
  `commentip` varchar(16) default NULL,
  `to_archive` tinyint(1) default '0',
  `commentip_hash` varchar(50) default NULL,
  `pre_rating` decimal(4,2) default NULL,
  PRIMARY KEY  (`sid`,`cid`),
  KEY `stuff` (`uid`,`pid`),
  KEY `cdate` (`date`),
  KEY `archive_idx` (`to_archive`),
  KEY `c_ip` (`commentip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `cron`
--

DROP TABLE IF EXISTS `cron`;
CREATE TABLE `cron` (
  `name` varchar(20) NOT NULL default '',
  `func` varchar(20) default NULL,
  `run_every` int(11) default NULL,
  `last_run` datetime default '0000-00-00 00:00:00',
  `enabled` int(1) default '1',
  `is_box` int(1) default '0',
  PRIMARY KEY  (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `displaycodes`
--

DROP TABLE IF EXISTS `displaycodes`;
CREATE TABLE `displaycodes` (
  `code` int(1) NOT NULL default '0',
  `name` varchar(32) default NULL,
  PRIMARY KEY  (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `editcategorycodes`
--

DROP TABLE IF EXISTS `editcategorycodes`;
CREATE TABLE `editcategorycodes` (
  `code` int(1) NOT NULL default '0',
  `name` varchar(32) default NULL,
  `orderby` int(1) NOT NULL default '0',
  PRIMARY KEY  (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `event_properties`
--

DROP TABLE IF EXISTS `event_properties`;
CREATE TABLE `event_properties` (
  `eid` int(11) NOT NULL default '0',
  `property` varchar(32) NOT NULL default '',
  `value` text,
  PRIMARY KEY  (`eid`,`property`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `event_property_items`
--

DROP TABLE IF EXISTS `event_property_items`;
CREATE TABLE `event_property_items` (
  `property` varchar(32) NOT NULL default '',
  `title` varchar(50) default NULL,
  `description` text,
  `field` text,
  `template` text,
  `calendar_template` text,
  `display_order` int(5) default NULL,
  `requires` varchar(32) default NULL,
  `is_date` tinyint(1) default NULL,
  `is_time` tinyint(1) default NULL,
  `html` tinyint(1) default NULL,
  `regex` text,
  `enabled` tinyint(1) default NULL,
  `required` tinyint(1) default NULL,
  PRIMARY KEY  (`property`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `event_rsvp`
--

DROP TABLE IF EXISTS `event_rsvp`;
CREATE TABLE `event_rsvp` (
  `uid` int(11) NOT NULL default '0',
  `eid` int(11) NOT NULL default '0',
  `attend` tinyint(1) default NULL,
  `volunteer` varchar(30) default NULL,
  PRIMARY KEY  (`uid`,`eid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `event_story`
--

DROP TABLE IF EXISTS `event_story`;
CREATE TABLE `event_story` (
  `eid` int(11) NOT NULL default '0',
  `sid` varchar(20) NOT NULL default '',
  PRIMARY KEY  (`eid`,`sid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `event_watch`
--

DROP TABLE IF EXISTS `event_watch`;
CREATE TABLE `event_watch` (
  `uid` int(11) NOT NULL default '0',
  `eid` int(11) NOT NULL default '0',
  `last_viewed` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `subscribed` tinyint(1) default '0',
  PRIMARY KEY  (`uid`,`eid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
CREATE TABLE `events` (
  `eid` int(11) NOT NULL auto_increment,
  `owner` int(11) NOT NULL default '0',
  `date_start` date NOT NULL default '0000-00-00',
  `date_end` date default NULL,
  `last_update` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `public_view` varchar(10) default NULL,
  `public_submit` varchar(10) default NULL,
  `is_parent` tinyint(1) default '0',
  `parent` int(11) default '0',
  `volunteers` tinyint(1) default '0',
  PRIMARY KEY  (`eid`),
  KEY `owner_idx` (`owner`),
  KEY `parent_idx` (`parent`)
) ENGINE=MyISAM AUTO_INCREMENT=43 DEFAULT CHARSET=latin1;

--
-- Table structure for table `hooks`
--

DROP TABLE IF EXISTS `hooks`;
CREATE TABLE `hooks` (
  `hook` varchar(50) NOT NULL default '',
  `func` varchar(50) NOT NULL default '',
  `is_box` int(1) default '0',
  `enabled` int(1) default '1',
  PRIMARY KEY  (`hook`,`func`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `identify`
--

DROP TABLE IF EXISTS `identify`;
CREATE TABLE `identify` (
  `inkey` varchar(200) NOT NULL default '',
  `uid` int(11) default NULL,
  PRIMARY KEY  (`inkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `log_info`
--

DROP TABLE IF EXISTS `log_info`;
CREATE TABLE `log_info` (
  `log_id` int(11) NOT NULL auto_increment,
  `log_type` varchar(30) NOT NULL default '',
  `log_item` varchar(30) NOT NULL default '',
  `description` varchar(255) default '',
  `extended` tinyint(1) NOT NULL default '0',
  `uid` int(11) NOT NULL default '0',
  `ip_address` varchar(30) default '',
  `log_date` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `log_info_extended`
--

DROP TABLE IF EXISTS `log_info_extended`;
CREATE TABLE `log_info_extended` (
  `log_id` int(11) NOT NULL default '0',
  `extended_description` text,
  PRIMARY KEY  (`log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `macros`
--

DROP TABLE IF EXISTS `macros`;
CREATE TABLE `macros` (
  `name` varchar(32) NOT NULL default '',
  `value` text,
  `description` text,
  `category` varchar(128) NOT NULL default '',
  `parameter` text,
  PRIMARY KEY  (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `message_list`
--

DROP TABLE IF EXISTS `message_list`;
CREATE TABLE `message_list` (
  `msg_id` int(15) NOT NULL auto_increment,
  `sid` varchar(30) default NULL,
  `cid` int(15) default NULL,
  `new_cid` int(15) default NULL,
  `uid` int(11) default NULL,
  `msg_type` int(11) default NULL,
  `msg_time` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`msg_id`),
  KEY `msg_sid` (`sid`,`cid`,`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `ops`
--

DROP TABLE IF EXISTS `ops`;
CREATE TABLE `ops` (
  `op` varchar(50) NOT NULL default '',
  `template` varchar(30) NOT NULL default '',
  `func` varchar(50) default NULL,
  `is_box` int(1) default '0',
  `enabled` int(1) default '1',
  `perm` varchar(50) default '',
  `aliases` varchar(255) NOT NULL default '',
  `urltemplates` text NOT NULL,
  `description` text,
  PRIMARY KEY  (`op`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `patches`
--

DROP TABLE IF EXISTS `patches`;
CREATE TABLE `patches` (
  `scoop_ver` varchar(20) NOT NULL default '',
  `patch_num` int(2) NOT NULL default '0',
  `patch_name` varchar(30) default NULL,
  `patch_type` varchar(10) NOT NULL default '',
  PRIMARY KEY  (`scoop_ver`,`patch_num`,`patch_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `perm_groups`
--

DROP TABLE IF EXISTS `perm_groups`;
CREATE TABLE `perm_groups` (
  `perm_group_id` varchar(50) NOT NULL default '',
  `group_perms` text,
  `default_user_group` int(1) default '0',
  `group_description` text,
  PRIMARY KEY  (`perm_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `pollanswers`
--

DROP TABLE IF EXISTS `pollanswers`;
CREATE TABLE `pollanswers` (
  `qid` varchar(20) NOT NULL default '',
  `aid` int(11) NOT NULL default '0',
  `answer` varchar(255) default NULL,
  `votes` int(11) default NULL,
  PRIMARY KEY  (`qid`,`aid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `pollquestions`
--

DROP TABLE IF EXISTS `pollquestions`;
CREATE TABLE `pollquestions` (
  `qid` varchar(20) NOT NULL default '',
  `question` varchar(255) NOT NULL default '',
  `voters` int(11) default NULL,
  `post_date` datetime default NULL,
  `archived` int(1) default '0',
  `is_multiple_choice` int(1) default '0',
  PRIMARY KEY  (`qid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `pollvoters`
--

DROP TABLE IF EXISTS `pollvoters`;
CREATE TABLE `pollvoters` (
  `qid` varchar(20) NOT NULL default '',
  `id` varchar(35) NOT NULL default '',
  `time` datetime default NULL,
  `uid` int(11) NOT NULL default '-1',
  `user_ip` varchar(15) NOT NULL default '',
  KEY `qid` (`qid`,`id`,`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `post_throttle`
--

DROP TABLE IF EXISTS `post_throttle`;
CREATE TABLE `post_throttle` (
  `uid` int(11) NOT NULL default '0',
  `created_time` datetime NOT NULL default '0000-00-00 00:00:00',
  `post_lock` int(1) NOT NULL default '0',
  `lock_timeout` int(11) NOT NULL default '0',
  PRIMARY KEY  (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `pref_items`
--

DROP TABLE IF EXISTS `pref_items`;
CREATE TABLE `pref_items` (
  `prefname` varchar(32) NOT NULL default '',
  `title` varchar(50) NOT NULL default '',
  `description` text,
  `visible` int(1) default '0',
  `html` int(1) default '0',
  `perm_view` varchar(32) default NULL,
  `perm_edit` varchar(32) default NULL,
  `var` varchar(32) default NULL,
  `req_tu` int(1) default '0',
  `default_value` text,
  `length` int(5) default NULL,
  `regex` text,
  `page` varchar(50) default NULL,
  `field` text,
  `display_order` int(5) default NULL,
  `template` varchar(30) default NULL,
  `display_fmt` text,
  `enabled` int(1) default '1',
  `signup` varchar(9) default NULL,
  PRIMARY KEY  (`prefname`),
  KEY `page_idx` (`page`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `private_message`
--

DROP TABLE IF EXISTS `private_message`;
CREATE TABLE `private_message` (
  `message_id` int(11) NOT NULL auto_increment,
  `from_uid` int(11) default '0',
  `to_uid` int(11) default '0',
  `sent_date` datetime default '0000-00-00 00:00:00',
  `subject` varchar(150) default NULL,
  `message` text,
  `msg_read` int(11) default '0',
  `inbox_delete` int(11) default '0',
  `sent_delete` int(11) default '0',
  PRIMARY KEY  (`message_id`),
  KEY `msg_idx` (`to_uid`)
) ENGINE=MyISAM AUTO_INCREMENT=10551 DEFAULT CHARSET=latin1;

--
-- Table structure for table `rdf_channels`
--

DROP TABLE IF EXISTS `rdf_channels`;
CREATE TABLE `rdf_channels` (
  `rid` smallint(6) NOT NULL auto_increment,
  `rdf_link` varchar(200) NOT NULL default '',
  `link` varchar(200) default NULL,
  `title` varchar(60) default NULL,
  `description` text,
  `image_title` varchar(40) default NULL,
  `image_url` varchar(200) default NULL,
  `image_link` varchar(200) default NULL,
  `form_title` varchar(40) default NULL,
  `form_description` tinytext,
  `form_name` varchar(20) default NULL,
  `form_link` varchar(200) default NULL,
  `enabled` int(1) default '1',
  `submitted` int(1) default NULL,
  `submittor` varchar(50) default NULL,
  PRIMARY KEY  (`rid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `rdf_items`
--

DROP TABLE IF EXISTS `rdf_items`;
CREATE TABLE `rdf_items` (
  `rid` smallint(6) NOT NULL default '0',
  `idx` tinyint(4) NOT NULL default '0',
  `title` varchar(100) default NULL,
  `link` varchar(200) default NULL,
  `description` tinytext,
  PRIMARY KEY  (`rid`,`idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `search_table`
--

DROP TABLE IF EXISTS `search_table`;
CREATE TABLE `search_table` (
  `id` int(15) NOT NULL auto_increment,
  `sid_id` int(15) NOT NULL default '0',
  `cid` int(15) NOT NULL default '0',
  `word_id` int(15) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `sid_ind` (`sid_id`,`cid`),
  KEY `word_ind` (`word_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `search_words`
--

DROP TABLE IF EXISTS `search_words`;
CREATE TABLE `search_words` (
  `word_id` int(15) NOT NULL auto_increment,
  `word` varchar(10) default NULL,
  PRIMARY KEY  (`word_id`),
  KEY `word_ind` (`word`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `section_perms`
--

DROP TABLE IF EXISTS `section_perms`;
CREATE TABLE `section_perms` (
  `group_id` varchar(50) NOT NULL default '',
  `section` varchar(30) NOT NULL default '',
  `sect_perms` text,
  `default_sect_perm` int(1) default '0',
  PRIMARY KEY  (`group_id`,`section`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `sections`
--

DROP TABLE IF EXISTS `sections`;
CREATE TABLE `sections` (
  `section` varchar(30) NOT NULL default '',
  `title` varchar(64) NOT NULL default '',
  `description` text,
  `icon` varchar(255) default NULL,
  PRIMARY KEY  (`section`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
CREATE TABLE `sessions` (
  `session_id` varchar(32) NOT NULL default '',
  `item` varchar(255) NOT NULL default '',
  `value` text,
  `serialized` int(1) default '0',
  `last_update` datetime default NULL,
  PRIMARY KEY  (`session_id`,`item`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `sid_xref`
--

DROP TABLE IF EXISTS `sid_xref`;
CREATE TABLE `sid_xref` (
  `sid_id` int(15) NOT NULL auto_increment,
  `sid` varchar(20) default NULL,
  PRIMARY KEY  (`sid_id`),
  KEY `sid_ind` (`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `special`
--

DROP TABLE IF EXISTS `special`;
CREATE TABLE `special` (
  `pageid` varchar(50) NOT NULL default '',
  `title` varchar(255) NOT NULL default '',
  `description` text,
  `content` text,
  PRIMARY KEY  (`pageid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `statuscodes`
--

DROP TABLE IF EXISTS `statuscodes`;
CREATE TABLE `statuscodes` (
  `code` int(1) NOT NULL default '0',
  `name` varchar(32) default NULL,
  PRIMARY KEY  (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `stories`
--

DROP TABLE IF EXISTS `stories`;
CREATE TABLE `stories` (
  `sid` varchar(20) NOT NULL default '',
  `tid` varchar(20) NOT NULL default '',
  `aid` int(11) NOT NULL default '0',
  `title` varchar(100) default NULL,
  `dept` varchar(100) default NULL,
  `time` datetime NOT NULL default '0000-00-00 00:00:00',
  `introtext` text,
  `bodytext` text,
  `writestatus` int(1) NOT NULL default '0',
  `hits` int(1) NOT NULL default '0',
  `section` varchar(30) NOT NULL default '',
  `displaystatus` int(1) NOT NULL default '0',
  `commentstatus` int(1) default NULL,
  `totalvotes` int(11) NOT NULL default '0',
  `score` int(11) NOT NULL default '0',
  `rating` int(11) NOT NULL default '0',
  `attached_poll` varchar(20) default NULL,
  `sent_email` int(1) NOT NULL default '0',
  `edit_category` tinyint(1) NOT NULL default '0',
  `to_archive` tinyint(1) default '0',
  PRIMARY KEY  (`sid`),
  KEY `section_idx` (`section`,`displaystatus`),
  KEY `displaystatus_idx` (`displaystatus`),
  KEY `archive_idx` (`to_archive`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `story_tags`
--

DROP TABLE IF EXISTS `story_tags`;
CREATE TABLE `story_tags` (
  `sid` varchar(20) NOT NULL default '',
  `tag` varchar(255) NOT NULL default '',
  `tag_order` int(11) NOT NULL default '0',
  PRIMARY KEY  (`sid`,`tag`),
  KEY `sid_idx` (`sid`),
  KEY `tag_idx` (`tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `storymoderate`
--

DROP TABLE IF EXISTS `storymoderate`;
CREATE TABLE `storymoderate` (
  `sid` varchar(20) NOT NULL default '',
  `uid` int(11) NOT NULL default '0',
  `time` datetime default NULL,
  `vote` int(11) NOT NULL default '0',
  `section_only` enum('N','Y','X') NOT NULL default 'X',
  PRIMARY KEY  (`sid`,`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `storyvote`
--

DROP TABLE IF EXISTS `storyvote`;
CREATE TABLE `storyvote` (
  `sid` varchar(20) NOT NULL default '',
  `uid` int(11) NOT NULL default '0',
  `time` datetime default NULL,
  `vote` int(11) NOT NULL default '0',
  PRIMARY KEY  (`sid`,`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `subscription_info`
--

DROP TABLE IF EXISTS `subscription_info`;
CREATE TABLE `subscription_info` (
  `uid` int(11) NOT NULL default '0',
  `expires` int(11) NOT NULL default '0',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `last_updated` datetime NOT NULL default '0000-00-00 00:00:00',
  `updated_by` varchar(50) default '',
  `active` int(1) NOT NULL default '0',
  `type` varchar(50) NOT NULL default '',
  PRIMARY KEY  (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `subscription_payments`
--

DROP TABLE IF EXISTS `subscription_payments`;
CREATE TABLE `subscription_payments` (
  `uid` int(11) NOT NULL default '0',
  `order_id` varchar(50) NOT NULL default '',
  `cost` decimal(7,2) NOT NULL default '0.00',
  `pay_type` varchar(10) NOT NULL default '',
  `auth_date` date NOT NULL default '0000-00-00',
  `final_date` date default NULL,
  `paid` int(1) default NULL,
  `type` varchar(50) NOT NULL default '',
  `conversion` double default NULL,
  PRIMARY KEY  (`uid`,`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `subscription_types`
--

DROP TABLE IF EXISTS `subscription_types`;
CREATE TABLE `subscription_types` (
  `type` varchar(50) NOT NULL default '',
  `perm_group_id` varchar(50) NOT NULL default '',
  `cost` decimal(7,2) NOT NULL default '0.00',
  `max_time` int(11) NOT NULL default '0',
  `renewable` int(1) NOT NULL default '1',
  `description` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `subsections`
--

DROP TABLE IF EXISTS `subsections`;
CREATE TABLE `subsections` (
  `section` varchar(32) NOT NULL default '',
  `child` varchar(32) NOT NULL default '',
  `inheritable` tinyint(1) NOT NULL default '0',
  `invisible` tinyint(1) NOT NULL default '0',
  `time` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`section`,`child`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `to_trackback`
--

DROP TABLE IF EXISTS `to_trackback`;
CREATE TABLE `to_trackback` (
  `sid` varchar(20) NOT NULL default '',
  `urls` text,
  `updated` int(11) default '0',
  PRIMARY KEY  (`sid`),
  KEY `update_key` (`updated`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `topics`
--

DROP TABLE IF EXISTS `topics`;
CREATE TABLE `topics` (
  `tid` varchar(20) NOT NULL default '',
  `image` varchar(30) default NULL,
  `alttext` varchar(40) default NULL,
  `width` int(11) default NULL,
  `height` int(11) default NULL,
  PRIMARY KEY  (`tid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `trackback`
--

DROP TABLE IF EXISTS `trackback`;
CREATE TABLE `trackback` (
  `track_id` bigint(20) NOT NULL auto_increment,
  `time` datetime NOT NULL default '0000-00-00 00:00:00',
  `sid` varchar(20) NOT NULL default '',
  `url` varchar(200) NOT NULL default '',
  `blog_name` varchar(200) NOT NULL default '',
  `title` varchar(200) NOT NULL default '',
  `excerpt` text NOT NULL,
  PRIMARY KEY  (`track_id`),
  KEY `prev_ind` (`sid`,`url`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `userprefs`
--

DROP TABLE IF EXISTS `userprefs`;
CREATE TABLE `userprefs` (
  `uid` int(11) NOT NULL default '0',
  `prefname` varchar(200) NOT NULL default '',
  `prefvalue` text,
  PRIMARY KEY  (`uid`,`prefname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `uid` int(11) NOT NULL auto_increment,
  `nickname` varchar(50) default NULL,
  `realemail` varchar(50) default NULL,
  `origemail` varchar(50) default NULL,
  `passwd` varchar(12) default NULL,
  `trustlev` int(1) default '1',
  `perm_group` varchar(50) default NULL,
  `mojo` varchar(5) default NULL,
  `creation_ip` varchar(16) NOT NULL default '',
  `creation_time` datetime NOT NULL default '0000-00-00 00:00:00',
  `newpasswd` varchar(12) default NULL,
  `pass_sent_at` datetime default NULL,
  `is_new_account` tinyint(1) default NULL,
  `creation_passwd` varchar(50) default NULL,
  PRIMARY KEY  (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `vars`
--

DROP TABLE IF EXISTS `vars`;
CREATE TABLE `vars` (
  `name` varchar(32) NOT NULL default '',
  `value` text,
  `description` text,
  `type` varchar(5) NOT NULL default 'text',
  `category` varchar(128) NOT NULL default '',
  PRIMARY KEY  (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `viewed_stories`
--

DROP TABLE IF EXISTS `viewed_stories`;
CREATE TABLE `viewed_stories` (
  `uid` int(11) NOT NULL default '0',
  `sid` varchar(20) NOT NULL default '',
  `lastseen` int(11) NOT NULL default '0',
  `highest_idx` int(11) NOT NULL default '0',
  `hotlisted` tinyint(4) NOT NULL default '0',
  `hide` tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (`uid`,`sid`),
  KEY `hotlist_idx` (`uid`,`hotlisted`),
  KEY `hidden_idx` (`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `whos_online`
--

DROP TABLE IF EXISTS `whos_online`;
CREATE TABLE `whos_online` (
  `ip` varchar(16) NOT NULL default '',
  `uid` int(11) NOT NULL default '0',
  `last_visit` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`ip`,`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-10-03 12:29:36
