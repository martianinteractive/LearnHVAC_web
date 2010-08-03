CREATE TABLE `class_notification_emails` (
  `id` int(11) NOT NULL auto_increment,
  `class_id` int(11) default NULL,
  `recipients` varchar(255) collate utf8_unicode_ci default NULL,
  `subject` varchar(255) collate utf8_unicode_ci default NULL,
  `body` text collate utf8_unicode_ci,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_class_notification_emails_on_class_id` (`class_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `client_versions` (
  `id` int(11) NOT NULL auto_increment,
  `version` varchar(255) collate utf8_unicode_ci default NULL,
  `url` varchar(255) collate utf8_unicode_ci default NULL,
  `release_date` date default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `description` text collate utf8_unicode_ci,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `colleges` (
  `id` int(11) NOT NULL auto_increment,
  `value` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_colleges_on_value` (`value`)
) ENGINE=InnoDB AUTO_INCREMENT=1073688967 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `group_scenarios` (
  `id` int(11) NOT NULL auto_increment,
  `group_id` int(11) default NULL,
  `scenario_id` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `groups` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `code` varchar(255) collate utf8_unicode_ci default NULL,
  `creator_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_groups_on_instructor_id` (`creator_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `institutions` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `description` text collate utf8_unicode_ci,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `category_code` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_institutions_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `master_scenarios` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `description` text collate utf8_unicode_ci,
  `user_id` int(11) default NULL,
  `desktop_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_master_scenarios_on_user_id` (`user_id`),
  KEY `index_master_scenarios_on_desktop_id` (`desktop_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `memberships` (
  `id` int(11) NOT NULL auto_increment,
  `member_id` int(11) default NULL,
  `group_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_memberships_on_student_id` (`member_id`),
  KEY `index_memberships_on_group_id` (`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `regions` (
  `id` int(11) NOT NULL auto_increment,
  `value` varchar(255) collate utf8_unicode_ci default NULL,
  `country` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_regions_on_country` (`country`)
) ENGINE=InnoDB AUTO_INCREMENT=1000199270 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `scenarios` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `short_description` varchar(255) collate utf8_unicode_ci default NULL,
  `description` text collate utf8_unicode_ci,
  `goal` varchar(255) collate utf8_unicode_ci default NULL,
  `longterm_start_date` date default '2010-01-01',
  `longterm_stop_date` date default '2010-07-31',
  `realtime_start_datetime` datetime default '2010-01-15 00:00:00',
  `level` int(11) default '1',
  `public` tinyint(1) default '0',
  `inputs_visible` tinyint(1) default '1',
  `inputs_enabled` tinyint(1) default '1',
  `faults_visible` tinyint(1) default '1',
  `faults_enabled` tinyint(1) default '1',
  `valve_info_enabled` tinyint(1) default '1',
  `allow_longterm_date_change` tinyint(1) default '0',
  `allow_realtime_datetime_change` tinyint(1) default '0',
  `student_debug_access` tinyint(1) default '0',
  `desktop_id` int(11) default NULL,
  `master_scenario_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_scenarios_on_desktop_id` (`desktop_id`),
  KEY `index_scenarios_on_master_scenario_id` (`master_scenario_id`),
  KEY `index_scenarios_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) collate utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `session_id` varchar(255) collate utf8_unicode_ci NOT NULL,
  `data` text collate utf8_unicode_ci,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `taggings` (
  `id` int(11) NOT NULL auto_increment,
  `tag_id` int(11) default NULL,
  `taggable_id` int(11) default NULL,
  `taggable_type` varchar(255) collate utf8_unicode_ci default NULL,
  `tagger_id` int(11) default NULL,
  `tagger_type` varchar(255) collate utf8_unicode_ci default NULL,
  `context` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_taggings_on_tag_id` (`tag_id`),
  KEY `index_taggings_on_taggable_id_and_taggable_type_and_context` (`taggable_id`,`taggable_type`,`context`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `tags` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `first_name` varchar(255) collate utf8_unicode_ci default NULL,
  `last_name` varchar(255) collate utf8_unicode_ci default NULL,
  `institution_id` int(11) default NULL,
  `active` tinyint(1) default '1',
  `student_id` int(11) default NULL,
  `login` varchar(255) collate utf8_unicode_ci default NULL,
  `email` varchar(255) collate utf8_unicode_ci default NULL,
  `crypted_password` varchar(255) collate utf8_unicode_ci default NULL,
  `password_salt` varchar(255) collate utf8_unicode_ci default NULL,
  `persistence_token` varchar(255) collate utf8_unicode_ci default NULL,
  `last_request_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `role_code` int(11) default '0',
  `perishable_token` varchar(255) collate utf8_unicode_ci NOT NULL default '',
  `enabled` tinyint(1) default '1',
  `city` varchar(255) collate utf8_unicode_ci default NULL,
  `state` varchar(255) collate utf8_unicode_ci default NULL,
  `country` varchar(255) collate utf8_unicode_ci default 'United States',
  `phone` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_users_on_perishable_token` (`perishable_token`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `variables` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `display_name` varchar(255) collate utf8_unicode_ci default NULL,
  `description` text collate utf8_unicode_ci,
  `unit_si` varchar(255) collate utf8_unicode_ci default NULL,
  `unit_ip` varchar(255) collate utf8_unicode_ci default NULL,
  `si_to_ip` varchar(255) collate utf8_unicode_ci default NULL,
  `left_label` varchar(255) collate utf8_unicode_ci default NULL,
  `right_label` varchar(255) collate utf8_unicode_ci default NULL,
  `subsection` varchar(255) collate utf8_unicode_ci default NULL,
  `zone_position` varchar(255) collate utf8_unicode_ci default NULL,
  `fault_widget_type` varchar(255) collate utf8_unicode_ci default NULL,
  `notes` text collate utf8_unicode_ci,
  `component_code` varchar(255) collate utf8_unicode_ci default NULL,
  `io_type` varchar(255) collate utf8_unicode_ci default NULL,
  `view_type` varchar(255) collate utf8_unicode_ci default 'public',
  `index` int(11) default NULL,
  `lock_version` int(11) default '0',
  `node_sequence` int(11) default '0',
  `low_value` float default '0',
  `high_value` float default '0',
  `initial_value` float default '0',
  `is_fault` tinyint(1) default '0',
  `is_percentage` tinyint(1) default '0',
  `disabled` tinyint(1) default '0',
  `fault_is_active` tinyint(1) default '0',
  `type` varchar(255) collate utf8_unicode_ci default NULL,
  `scenario_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_variables_on_scenario_id` (`scenario_id`),
  KEY `index_variables_on_type` (`type`),
  KEY `index_variables_on_component_code` (`component_code`),
  KEY `index_variables_on_name` (`name`),
  KEY `index_variables_on_low_value` (`low_value`),
  KEY `index_variables_on_high_value` (`high_value`),
  KEY `index_variables_on_initial_value` (`initial_value`),
  KEY `index_variables_on_io_type` (`io_type`)
) ENGINE=InnoDB AUTO_INCREMENT=486 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO schema_migrations (version) VALUES ('20100302150214');

INSERT INTO schema_migrations (version) VALUES ('20100302205816');

INSERT INTO schema_migrations (version) VALUES ('20100303160903');

INSERT INTO schema_migrations (version) VALUES ('20100308222159');

INSERT INTO schema_migrations (version) VALUES ('20100318165744');

INSERT INTO schema_migrations (version) VALUES ('20100323143919');

INSERT INTO schema_migrations (version) VALUES ('20100323144050');

INSERT INTO schema_migrations (version) VALUES ('20100325212707');

INSERT INTO schema_migrations (version) VALUES ('20100327161124');

INSERT INTO schema_migrations (version) VALUES ('20100329224224');

INSERT INTO schema_migrations (version) VALUES ('20100331204627');

INSERT INTO schema_migrations (version) VALUES ('20100405162227');

INSERT INTO schema_migrations (version) VALUES ('20100405195414');

INSERT INTO schema_migrations (version) VALUES ('20100413203436');

INSERT INTO schema_migrations (version) VALUES ('20100419224135');

INSERT INTO schema_migrations (version) VALUES ('20100420225816');

INSERT INTO schema_migrations (version) VALUES ('20100610213228');

INSERT INTO schema_migrations (version) VALUES ('20100727171930');

INSERT INTO schema_migrations (version) VALUES ('20100728161530');

INSERT INTO schema_migrations (version) VALUES ('20100728172853');

INSERT INTO schema_migrations (version) VALUES ('20100728202513');

INSERT INTO schema_migrations (version) VALUES ('20100730165247');

INSERT INTO schema_migrations (version) VALUES ('20100802151348');

INSERT INTO schema_migrations (version) VALUES ('20100802205920');