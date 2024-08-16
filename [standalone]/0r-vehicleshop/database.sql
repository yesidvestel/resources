CREATE TABLE
    IF NOT EXISTS `0r_rented_vehicles` (
        id INT (11) NOT NULL AUTO_INCREMENT,
        owner VARCHAR(64) NOT NULL,
        plate VARCHAR(32),
        model VARCHAR(32),
        vehicle_price INT (11),
        daily_fee INT (11),
        rented_day INT (11),
        rental_fee INT (11),
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
        updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP(),
        KEY id (id)
    ) ENGINE = InnoDB AUTO_INCREMENT = 1;