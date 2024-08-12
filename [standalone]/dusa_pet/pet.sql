CREATE TABLE IF NOT EXISTS `dusa_pets` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`owner` varchar(60) DEFAULT NULL,
	`modelname` varchar(250) DEFAULT NULL,
	`health` tinyint(4) NOT NULL DEFAULT 100,
	`illnesses` varchar(60) NOT NULL DEFAULT 'none',
	`name` varchar(255) DEFAULT 'Pet',
	`clothes` varchar(255) DEFAULT NULL,
	`type` varchar(10) DEFAULT NULL,
PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=221 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;