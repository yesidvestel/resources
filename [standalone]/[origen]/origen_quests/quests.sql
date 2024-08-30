CREATE TABLE IF NOT EXISTS `origen_quests_locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `active` int(11) NOT NULL DEFAULT 1,
  `type` varchar(50) NOT NULL DEFAULT '',
  `model` varchar(50) DEFAULT NULL,
  `coords` longtext NOT NULL DEFAULT '{"x": 0.0, "y": 0.0, "z": 0.0, "w": 0.0}',
  `anim1` varchar(50) DEFAULT NULL,
  `anim2` varchar(50) DEFAULT NULL,
  `anim3` varchar(50) DEFAULT NULL,
  `missions` longtext NOT NULL DEFAULT '[]',
  `marker_draw_distance` longtext NOT NULL DEFAULT '30',
  `marker_type` longtext NOT NULL DEFAULT '20',
  `marker_color` longtext NOT NULL DEFAULT '{"r": 0, "g": 0, "b": 0}',
  PRIMARY KEY (`id`) USING BTREE,
  CONSTRAINT `coords` CHECK (json_valid(`coords`)),
  CONSTRAINT `missions` CHECK (json_valid(`missions`)),
  CONSTRAINT `marker_draw_distance` CHECK (json_valid(`marker_draw_distance`)),
  CONSTRAINT `marker_type` CHECK (json_valid(`marker_type`)),
  CONSTRAINT `marker_color` CHECK (json_valid(`marker_color`))
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;


CREATE TABLE IF NOT EXISTS `origen_quests_missions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `description` text NOT NULL DEFAULT '',
  `events` longtext NOT NULL DEFAULT '[]',
  `rest` longtext NOT NULL DEFAULT '[]',
  `used` longtext NOT NULL DEFAULT '[]',
  PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;