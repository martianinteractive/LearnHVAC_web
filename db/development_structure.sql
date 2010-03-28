CREATE TABLE `colleges` (
  `id` int(11) NOT NULL auto_increment,
  `value` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_colleges_on_value` (`value`)
) ENGINE=InnoDB AUTO_INCREMENT=1073688967 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `groups` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `code` varchar(255) collate utf8_unicode_ci default NULL,
  `instructor_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_groups_on_instructor_id` (`instructor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `institutions` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `description` text collate utf8_unicode_ci,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_institutions_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `memberships` (
  `id` int(11) NOT NULL auto_increment,
  `student_id` int(11) default NULL,
  `group_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_memberships_on_student_id` (`student_id`),
  KEY `index_memberships_on_group_id` (`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) collate utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
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
  PRIMARY KEY  (`id`),
  KEY `index_users_on_perishable_token` (`perishable_token`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO schema_migrations (version) VALUES ('20100302150214');

INSERT INTO schema_migrations (version) VALUES ('20100302205816');

INSERT INTO schema_migrations (version) VALUES ('20100303160903');

INSERT INTO schema_migrations (version) VALUES ('20100308222159');

INSERT INTO schema_migrations (version) VALUES ('20100318165744');

INSERT INTO schema_migrations (version) VALUES ('20100323143919');

INSERT INTO schema_migrations (version) VALUES ('20100323144050');

INSERT INTO schema_migrations (version) VALUES ('20100325212707');

INSERT INTO schema_migrations (version) VALUES ('20100327161124');