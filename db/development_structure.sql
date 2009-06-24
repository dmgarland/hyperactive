CREATE TABLE `action_alerts` (
  `id` int(11) NOT NULL auto_increment,
  `summary` text NOT NULL,
  `on_front_page` tinyint(1) NOT NULL default '0',
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `acts_as_xapian_jobs` (
  `id` int(11) NOT NULL auto_increment,
  `model` varchar(255) NOT NULL,
  `model_id` int(11) NOT NULL,
  `action` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_acts_as_xapian_jobs_on_model_and_model_id` (`model`,`model_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

CREATE TABLE `admin_filters` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) default NULL,
  `summary` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `categories` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL default '',
  `description` text NOT NULL,
  `active` tinyint(1) NOT NULL default '0',
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `categories_events` (
  `category_id` int(11) NOT NULL default '0',
  `event_id` int(11) NOT NULL default '0',
  KEY `category_id` (`category_id`),
  KEY `event_id` (`event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `collective_associations` (
  `id` int(11) NOT NULL auto_increment,
  `collective_associatable_id` int(11) default NULL,
  `collective_associatable_type` varchar(255) default NULL,
  `collective_id` int(11) default NULL,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `collective_memberships` (
  `id` int(11) NOT NULL auto_increment,
  `collective_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

CREATE TABLE `collectives` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `summary` text,
  `image` varchar(255) default NULL,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  `moderation_status` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

CREATE TABLE `comments` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) NOT NULL,
  `body` text NOT NULL,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  `published_by` varchar(255) NOT NULL default '',
  `moderation_status` varchar(50) default NULL,
  `content_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_comments_content` (`content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `content` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) NOT NULL default '',
  `date` datetime default NULL,
  `body` text,
  `place` varchar(255) NOT NULL default '',
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  `summary` text NOT NULL,
  `source` text,
  `published_by` varchar(255) NOT NULL default '',
  `end_date` datetime default NULL,
  `event_group_id` int(11) default NULL,
  `contact_email` varchar(255) default NULL,
  `contact_phone` varchar(255) default NULL,
  `user_id` int(11) default NULL,
  `type` varchar(255) NOT NULL,
  `file` varchar(255) default NULL,
  `content_id` int(11) default NULL,
  `processing_status` int(11) default NULL,
  `media_size` int(11) default NULL,
  `moderation_status` varchar(255) default NULL,
  `allows_comments` tinyint(1) default '1',
  `stick_at_top` tinyint(1) default NULL,
  `collective_id` int(11) default NULL,
  `auto_moderation_checked` tinyint(1) default '0',
  `admin_note` text NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_event_event_group` (`event_group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=utf8;

CREATE TABLE `content_filter_expressions` (
  `id` int(11) NOT NULL auto_increment,
  `regexp` varchar(255) default NULL,
  `summary` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `content_filter_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `content_filters` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) default NULL,
  `summary` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `event_groups` (
  `id` int(11) NOT NULL auto_increment,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE `external_feeds` (
  `id` int(11) NOT NULL auto_increment,
  `url` varchar(255) default NULL,
  `title` varchar(255) default NULL,
  `summary` varchar(255) default NULL,
  `collective_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `file_uploads` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) NOT NULL default '',
  `file` varchar(255) NOT NULL default '',
  `content_id` int(11) default NULL,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_file_upload_event` (`content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `groups` (
  `id` int(11) NOT NULL auto_increment,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `title` varchar(200) NOT NULL default '',
  `parent_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `groups_parent_id_index` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `groups_roles` (
  `group_id` int(11) NOT NULL default '0',
  `role_id` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  UNIQUE KEY `groups_roles_all_index` (`group_id`,`role_id`),
  KEY `role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `groups_users` (
  `group_id` int(11) NOT NULL default '0',
  `user_id` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  UNIQUE KEY `groups_users_all_index` (`group_id`,`user_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `open_street_map_infos` (
  `id` int(11) NOT NULL auto_increment,
  `lat` float default NULL,
  `lng` float default NULL,
  `zoom` int(11) default NULL,
  `content_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE `pages` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) NOT NULL default '',
  `body` text NOT NULL,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  `show_on_front` tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `photos` (
  `id` int(11) NOT NULL auto_increment,
  `file` varchar(255) NOT NULL default '',
  `title` varchar(255) NOT NULL default '',
  `content_id` int(11) default NULL,
  `created_on` datetime default NULL,
  `position` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `fk2_photo_event` (`content_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE `place_taggings` (
  `id` int(11) NOT NULL auto_increment,
  `place_tag_id` int(11) NOT NULL,
  `place_taggable_id` int(11) NOT NULL,
  `place_taggable_type` varchar(255) NOT NULL,
  `hide_tag` tinyint(1) NOT NULL default '0',
  `event_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `place_taggable_index` (`place_tag_id`,`place_taggable_id`,`place_taggable_type`)
) ENGINE=InnoDB AUTO_INCREMENT=131 DEFAULT CHARSET=utf8;

CREATE TABLE `place_tags` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_place_tags_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;

CREATE TABLE `quotes` (
  `id` int(11) NOT NULL auto_increment,
  `body` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

CREATE TABLE `roles` (
  `id` int(11) NOT NULL auto_increment,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `title` varchar(100) NOT NULL default '',
  `parent_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `roles_parent_id_index` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

CREATE TABLE `roles_static_permissions` (
  `role_id` int(11) NOT NULL default '0',
  `static_permission_id` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  UNIQUE KEY `roles_static_permissions_all_index` (`static_permission_id`,`role_id`),
  KEY `role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `roles_users` (
  `user_id` int(11) NOT NULL default '0',
  `role_id` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  UNIQUE KEY `roles_users_all_index` (`user_id`,`role_id`),
  KEY `role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `session_id` varchar(255) NOT NULL,
  `data` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;

CREATE TABLE `settings` (
  `id` int(11) NOT NULL auto_increment,
  `key` varchar(255) default NULL,
  `string_value` varchar(255) default NULL,
  `integer_value` int(11) default NULL,
  `boolean_value` tinyint(1) default NULL,
  `type` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;

CREATE TABLE `slugs` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `sluggable_type` varchar(255) default NULL,
  `sluggable_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_slugs_on_name_and_sluggable_type` (`name`,`sluggable_type`),
  KEY `index_slugs_on_sluggable_id` (`sluggable_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

CREATE TABLE `snippets` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) default NULL,
  `body` text,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  `key` varchar(255) default NULL,
  `url` varchar(255) default NULL,
  `image` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE `static_permissions` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(200) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `static_permissions_title_index` (`title`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

CREATE TABLE `taggings` (
  `id` int(11) NOT NULL auto_increment,
  `tag_id` int(11) NOT NULL,
  `taggable_id` int(11) NOT NULL,
  `taggable_type` varchar(255) NOT NULL,
  `hide_tag` tinyint(1) NOT NULL default '0',
  `event_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_taggings_on_tag_id_and_taggable_id_and_taggable_type` (`tag_id`,`taggable_id`,`taggable_type`)
) ENGINE=InnoDB AUTO_INCREMENT=131 DEFAULT CHARSET=utf8;

CREATE TABLE `tags` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_tags_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;

CREATE TABLE `user_registrations` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL default '0',
  `token` text NOT NULL,
  `created_at` datetime NOT NULL,
  `expires_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `user_registrations_user_id_index` (`user_id`),
  KEY `user_registrations_expires_at_index` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `last_logged_in_at` datetime NOT NULL,
  `login_failure_count` int(11) NOT NULL default '0',
  `login` varchar(100) NOT NULL default '',
  `email` varchar(200) NOT NULL default '',
  `password` varchar(100) NOT NULL default '',
  `password_hash_type` varchar(20) NOT NULL default '',
  `password_salt` varchar(10) NOT NULL default '1234512345',
  `state` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `users_login_index` (`login`),
  KEY `users_password_index` (`password`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE `versions` (
  `id` int(11) NOT NULL auto_increment,
  `versionable_id` int(11) default NULL,
  `versionable_type` varchar(255) default NULL,
  `number` int(11) default NULL,
  `yaml` text,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_versions_on_versionable_id_and_versionable_type` (`versionable_id`,`versionable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO schema_migrations (version) VALUES ('1');

INSERT INTO schema_migrations (version) VALUES ('10');

INSERT INTO schema_migrations (version) VALUES ('2');

INSERT INTO schema_migrations (version) VALUES ('20081015204841');

INSERT INTO schema_migrations (version) VALUES ('20081026102415');

INSERT INTO schema_migrations (version) VALUES ('20081129195437');

INSERT INTO schema_migrations (version) VALUES ('20081129202116');

INSERT INTO schema_migrations (version) VALUES ('20081129224432');

INSERT INTO schema_migrations (version) VALUES ('20081204215330');

INSERT INTO schema_migrations (version) VALUES ('20081217124551');

INSERT INTO schema_migrations (version) VALUES ('20081217173129');

INSERT INTO schema_migrations (version) VALUES ('20081218171856');

INSERT INTO schema_migrations (version) VALUES ('20081218222734');

INSERT INTO schema_migrations (version) VALUES ('20081219232920');

INSERT INTO schema_migrations (version) VALUES ('20081220004942');

INSERT INTO schema_migrations (version) VALUES ('20081225160137');

INSERT INTO schema_migrations (version) VALUES ('20081225162851');

INSERT INTO schema_migrations (version) VALUES ('20081226182333');

INSERT INTO schema_migrations (version) VALUES ('20090208191400');

INSERT INTO schema_migrations (version) VALUES ('20090208214144');

INSERT INTO schema_migrations (version) VALUES ('20090414203152');

INSERT INTO schema_migrations (version) VALUES ('20090414222335');

INSERT INTO schema_migrations (version) VALUES ('20090415125547');

INSERT INTO schema_migrations (version) VALUES ('20090415155748');

INSERT INTO schema_migrations (version) VALUES ('20090415165733');

INSERT INTO schema_migrations (version) VALUES ('20090415171824');

INSERT INTO schema_migrations (version) VALUES ('20090523073847');

INSERT INTO schema_migrations (version) VALUES ('20090523084920');

INSERT INTO schema_migrations (version) VALUES ('20090624214849');

INSERT INTO schema_migrations (version) VALUES ('3');

INSERT INTO schema_migrations (version) VALUES ('4');

INSERT INTO schema_migrations (version) VALUES ('5');