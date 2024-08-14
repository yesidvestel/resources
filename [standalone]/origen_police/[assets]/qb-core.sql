ALTER TABLE `players`
ADD IF NOT EXISTS `image` VARCHAR(250) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
ADD IF NOT EXISTS `dangerous` TINYINT(4) NULL DEFAULT '0',
ADD IF NOT EXISTS `wanted` TINYINT(4) UNSIGNED NULL DEFAULT '0';

ALTER TABLE `player_vehicles`
ADD IF NOT EXISTS `wanted` INT(1) NULL DEFAULT '0',
ADD IF NOT EXISTS `billPrice` INT(6) NULL DEFAULT '0',
ADD IF NOT EXISTS `description` LONGTEXT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci';

CREATE TABLE IF NOT EXISTS `origen_police_penalc` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`title` VARCHAR(255) NOT NULL DEFAULT 'Error' COLLATE 'utf8mb4_general_ci',
	`description` VARCHAR(255) NOT NULL DEFAULT 'Error' COLLATE 'utf8mb4_general_ci',
	`price` INT(11) NOT NULL DEFAULT '0',
	`month` INT(11) NOT NULL DEFAULT '0',
	`cap` INT(1) NOT NULL DEFAULT '0',
	`job` VARCHAR(50) NULL DEFAULT 'police' COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

CREATE TABLE IF NOT EXISTS `origen_police_federal` (
	`citizenid` VARCHAR(50) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
	`time` INT(11) NULL DEFAULT NULL,
	`initial` INT(11) NULL DEFAULT NULL,
	`name` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`date` TIMESTAMP NULL DEFAULT current_timestamp(),
	`danger` VARCHAR(50) NULL DEFAULT 'NP' COLLATE 'utf8mb4_general_ci',
	`joinedfrom` VARCHAR(50) NULL DEFAULT 'Mission Row' COLLATE 'utf8mb4_general_ci',
	`image` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci'
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

CREATE TABLE IF NOT EXISTS `origen_police_notes` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`citizenid` VARCHAR(60) NOT NULL COLLATE 'utf8mb4_general_ci',
	`title` VARCHAR(255) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`description` TEXT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`author` VARCHAR(255) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`date` TIMESTAMP NULL DEFAULT current_timestamp(),
	`fixed` INT(1) NULL DEFAULT '0',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

CREATE TABLE IF NOT EXISTS `origen_police_clocks` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`citizenid` VARCHAR(60) NOT NULL COLLATE 'utf8mb4_general_ci',
	`name` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`clockin` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`clockout` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`minutes` INT(11) NOT NULL DEFAULT '0',
	`job` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

CREATE TABLE IF NOT EXISTS `origen_police_reports` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`title` VARCHAR(255) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`description` TEXT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`author` VARCHAR(255) NOT NULL DEFAULT '' COLLATE 'latin1_swedish_ci',
	`cops` TEXT NULL DEFAULT '[]' COLLATE 'utf8mb4_general_ci',
	`implicated` TEXT NULL DEFAULT '[]' COLLATE 'utf8mb4_general_ci',
	`date` TIMESTAMP NULL DEFAULT current_timestamp(),
	`evidences` TEXT NULL DEFAULT '[]' COLLATE 'utf8mb4_general_ci',
	`tags` TEXT NULL DEFAULT '["Caso Abierto"]' COLLATE 'utf8mb4_general_ci',
	`location` VARCHAR(255) NOT NULL DEFAULT 'Sin ubicacion asignada' COLLATE 'latin1_swedish_ci',
	`victims` MEDIUMTEXT NULL DEFAULT '[]' COLLATE 'utf8mb4_general_ci',
	`vehicles` MEDIUMTEXT NULL DEFAULT '[]' COLLATE 'utf8mb4_general_ci',
	`job` VARCHAR(50) NULL DEFAULT 'police' COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

CREATE TABLE IF NOT EXISTS `origen_police_bills` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`citizenid` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`title` VARCHAR(255) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`concepts` TEXT NULL DEFAULT '[]' COLLATE 'utf8mb4_general_ci',
	`price` INT(11) NULL DEFAULT '0',
	`job` VARCHAR(50) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`author` VARCHAR(255) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`payed` INT(1) NULL DEFAULT '0',
	`date` TIMESTAMP NULL DEFAULT current_timestamp(),
	`months` INT(11) NULL DEFAULT '0',
	`reportid` INT(11) NULL DEFAULT '0',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

CREATE TABLE IF NOT EXISTS `origen_police_shapes` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`type` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
	`title` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`data` TEXT NOT NULL COLLATE 'utf8_general_ci',
	`radius` FLOAT NULL DEFAULT NULL,
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8_general_ci' ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `origen_metadata` (
  `id` varchar(255) NOT NULL DEFAULT '',
  `data` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE IF NOT EXISTS `origen_police_ankle` (
  `citizenid` varchar(50) NOT NULL,
  `policeOwner` varchar(50) NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp(),
  `lastShock` timestamp NULL,
  PRIMARY KEY (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE IF NOT EXISTS `origen_police_alerts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL,
  `job` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;