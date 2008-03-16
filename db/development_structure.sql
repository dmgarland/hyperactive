CREATE TABLE `authors` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `categories` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL default '',
  `description` text NOT NULL,
  `active` tinyint(1) NOT NULL default '0',
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

CREATE TABLE `categories_events` (
  `category_id` int(11) NOT NULL default '0',
  `event_id` int(11) NOT NULL default '0',
  KEY `category_id` (`category_id`),
  KEY `event_id` (`event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `content` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) NOT NULL default '',
  `date` datetime default NULL,
  `body` text,
  `place` varchar(255) NOT NULL default '',
  `published` tinyint(1) NOT NULL default '1',
  `hidden` tinyint(1) NOT NULL default '0',
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  `summary` text NOT NULL,
  `source` text,
  `published_by` varchar(255) NOT NULL default '',
  `promoted` tinyint(1) NOT NULL default '0',
  `end_date` datetime default NULL,
  `event_group_id` int(11) default NULL,
  `contact_email` varchar(255) default NULL,
  `contact_phone` varchar(255) default NULL,
  `user_id` int(11) default NULL,
  `type` varchar(255) NOT NULL,
  `file` varchar(255) default NULL,
  `content_id` int(11) default NULL,
  `processing_status` int(11) default NULL,
  `file_size` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_event_event_group` (`event_group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=136 DEFAULT CHARSET=latin1;

CREATE TABLE `event_groups` (
  `id` int(11) NOT NULL auto_increment,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `file_uploads` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) NOT NULL default '',
  `file` varchar(255) NOT NULL default '',
  `content_id` int(11) default NULL,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_file_upload_event` (`content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `globalize_countries` (
  `id` int(11) NOT NULL auto_increment,
  `code` varchar(2) default NULL,
  `english_name` varchar(255) default NULL,
  `date_format` varchar(255) default NULL,
  `currency_format` varchar(255) default NULL,
  `currency_code` varchar(3) default NULL,
  `thousands_sep` varchar(2) default NULL,
  `decimal_sep` varchar(2) default NULL,
  `currency_decimal_sep` varchar(2) default NULL,
  `number_grouping_scheme` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_globalize_countries_on_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=240 DEFAULT CHARSET=utf8;

CREATE TABLE `globalize_languages` (
  `id` int(11) NOT NULL auto_increment,
  `iso_639_1` varchar(2) default NULL,
  `iso_639_2` varchar(3) default NULL,
  `iso_639_3` varchar(3) default NULL,
  `rfc_3066` varchar(255) default NULL,
  `english_name` varchar(255) default NULL,
  `english_name_locale` varchar(255) default NULL,
  `english_name_modifier` varchar(255) default NULL,
  `native_name` varchar(255) default NULL,
  `native_name_locale` varchar(255) default NULL,
  `native_name_modifier` varchar(255) default NULL,
  `macro_language` tinyint(1) default NULL,
  `direction` varchar(255) default NULL,
  `pluralization` varchar(255) default NULL,
  `scope` varchar(1) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_globalize_languages_on_iso_639_1` (`iso_639_1`),
  KEY `index_globalize_languages_on_iso_639_2` (`iso_639_2`),
  KEY `index_globalize_languages_on_iso_639_3` (`iso_639_3`),
  KEY `index_globalize_languages_on_rfc_3066` (`rfc_3066`)
) ENGINE=InnoDB AUTO_INCREMENT=7597 DEFAULT CHARSET=utf8;

CREATE TABLE `globalize_translations` (
  `id` int(11) NOT NULL auto_increment,
  `type` varchar(255) default NULL,
  `tr_key` varchar(255) default NULL,
  `table_name` varchar(255) default NULL,
  `item_id` int(11) default NULL,
  `facet` varchar(255) default NULL,
  `built_in` tinyint(1) default '1',
  `language_id` int(11) default NULL,
  `pluralization_index` int(11) default NULL,
  `text` text,
  `namespace` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_globalize_translations_on_tr_key_and_language_id` (`tr_key`,`language_id`),
  KEY `globalize_translations_table_name_and_item_and_language` (`table_name`,`item_id`,`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7040 DEFAULT CHARSET=utf8;

CREATE TABLE `groups` (
  `id` int(11) NOT NULL auto_increment,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `title` varchar(200) NOT NULL default '',
  `parent_id` int(10) default NULL,
  PRIMARY KEY  (`id`),
  KEY `groups_parent_id_index` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `groups_roles` (
  `group_id` int(10) NOT NULL default '0',
  `role_id` int(10) NOT NULL default '0',
  `created_at` datetime default NULL,
  UNIQUE KEY `groups_roles_all_index` (`group_id`,`role_id`),
  KEY `role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `groups_users` (
  `group_id` int(10) NOT NULL default '0',
  `user_id` int(10) NOT NULL default '0',
  `created_at` datetime default NULL,
  UNIQUE KEY `groups_users_all_index` (`group_id`,`user_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `links` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) NOT NULL default '',
  `url` varchar(255) NOT NULL default '',
  `description` text,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  `post_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `fk2_link_event` (`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `pages` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) NOT NULL default '',
  `body` text NOT NULL,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `photos` (
  `id` int(11) NOT NULL auto_increment,
  `file` varchar(255) NOT NULL default '',
  `title` varchar(255) NOT NULL default '',
  `content_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `fk2_photo_event` (`content_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

CREATE TABLE `place_taggings` (
  `id` int(11) NOT NULL auto_increment,
  `place_tag_id` int(11) NOT NULL,
  `place_taggable_id` int(11) NOT NULL,
  `place_taggable_type` varchar(255) NOT NULL,
  `hide_tag` tinyint(1) NOT NULL default '0',
  `event_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `place_taggable_index` (`place_tag_id`,`place_taggable_id`,`place_taggable_type`)
) ENGINE=InnoDB AUTO_INCREMENT=231 DEFAULT CHARSET=latin1;

CREATE TABLE `place_tags` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_place_tags_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=latin1;

CREATE TABLE `plugin_schema_info` (
  `plugin_name` varchar(255) default NULL,
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `roles` (
  `id` int(11) NOT NULL auto_increment,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `title` varchar(100) NOT NULL default '',
  `parent_id` int(10) default NULL,
  PRIMARY KEY  (`id`),
  KEY `roles_parent_id_index` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

CREATE TABLE `roles_static_permissions` (
  `role_id` int(10) NOT NULL default '0',
  `static_permission_id` int(10) NOT NULL default '0',
  `created_at` datetime default NULL,
  UNIQUE KEY `roles_static_permissions_all_index` (`static_permission_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `roles_users` (
  `user_id` int(10) NOT NULL default '0',
  `role_id` int(10) NOT NULL default '0',
  `created_at` datetime default NULL,
  UNIQUE KEY `roles_users_all_index` (`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `session_id` varchar(255) default NULL,
  `data` text,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `static_permissions` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(200) NOT NULL default '',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `static_permissions_title_index` (`title`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;

CREATE TABLE `taggings` (
  `id` int(11) NOT NULL auto_increment,
  `tag_id` int(11) NOT NULL,
  `taggable_id` int(11) NOT NULL,
  `taggable_type` varchar(255) NOT NULL,
  `hide_tag` tinyint(1) NOT NULL default '0',
  `event_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_taggings_on_tag_id_and_taggable_id_and_taggable_type` (`tag_id`,`taggable_id`,`taggable_type`)
) ENGINE=InnoDB AUTO_INCREMENT=125 DEFAULT CHARSET=latin1;

CREATE TABLE `tags` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_tags_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=latin1;

CREATE TABLE `user_registrations` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(10) NOT NULL default '0',
  `token` text NOT NULL,
  `created_at` datetime default NULL,
  `expires_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `user_registrations_user_id_index` (`user_id`),
  KEY `user_registrations_expires_at_index` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `last_logged_in_at` datetime default NULL,
  `login_failure_count` int(10) NOT NULL default '0',
  `login` varchar(100) NOT NULL default '',
  `email` varchar(200) NOT NULL default '',
  `password` varchar(100) NOT NULL default '',
  `password_hash_type` varchar(20) NOT NULL default '',
  `password_salt` varchar(10) NOT NULL default '1234512345',
  `state` int(10) NOT NULL default '1',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `users_login_index` (`login`),
  KEY `users_password_index` (`password`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

CREATE TABLE `videos` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) NOT NULL default '',
  `file` varchar(255) NOT NULL default '',
  `content_id` int(11) default NULL,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  `body` varchar(255) default NULL,
  `processing_status` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_event_video` (`content_id`)
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=latin1;

INSERT INTO schema_info (version) VALUES (34)