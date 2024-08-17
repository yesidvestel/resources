CREATE TABLE IF NOT EXISTS `gym_memberships` (
  `owner` varchar(70) DEFAULT NULL,
  `name` varchar(80) DEFAULT NULL,
  `time` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;