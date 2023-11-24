-- SQLBook: Code
DROP DATABASE IF EXISTS natural_disasters_volunteering_platform;

CREATE DATABASE
    natural_disasters_volunteering_platform DEFAULT CHARSET utf16 COLLATE utf16_unicode_ci;

USE natural_disasters_volunteering_platform;

DROP TABLE IF EXISTS `user`;
CREATE TABLE`user`(
    `username` VARCHAR(30) NOT NULL,
    `password` VARCHAR(30) NOT NULL,
    `first_name` VARCHAR(30) NOT NULL,
    `last_name` VARCHAR(30) NOT NULL,
    `phone_num` INT NOT NULL,

    PRIMARY KEY (`username`) 
)Engine = InnoDB;

DROP TABLE IF EXISTS `admin`;
CREATE TABLE`admin`(
    `admin_username` VARCHAR(30) NOT NULL,
    `base_location` POINT NOT NULL,

    PRIMARY KEY (`admin_username`),
    FOREIGN KEY (`admin_username`) REFERENCES `user` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) Engine = InnoDB;

DROP TABLE IF EXISTS `rescuer`;
CREATE TABLE`rescuer`(
    `rescuer_username` VARCHAR(30) NOT NULL,
    `vehicle` VARCHAR(20) UNIQUE NOT NULL,
    `vehicle_location` POINT NOT NULL,
    `base` VARCHAR(30) NOT NULL,

    PRIMARY KEY (`rescuer_username`),
    FOREIGN KEY (`rescuer_username`) REFERENCES `user` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`base`) REFERENCES `admin` (`admin_username`) ON DELETE CASCADE ON UPDATE CASCADE
) Engine = InnoDB;

DROP TABLE IF EXISTS `citizen`;
CREATE TABLE`citizen`(
    `citizen_username` VARCHAR(30) NOT NULL,
    `citizen_location` POINT NOT NULL,

    PRIMARY KEY (`citizen_username`),
    FOREIGN KEY (`citizen_username`) REFERENCES `user` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) Engine = InnoDB;

DROP TABLE IF EXISTS `category`;
CREATE TABLE`category`(
    `category_id` INT AUTO_INCREMENT NOT NULL,
    `category_name` VARCHAR(30) NOT NULL,
        
    PRIMARY KEY (`category_id`)
) Engine = InnoDB;

DROP TABLE IF EXISTS `has_category`;
CREATE TABLE`has_category`(
    `base` VARCHAR(30) NOT NULL,
    `category` INT UNIQUE NOT NULL,

    PRIMARY KEY (`base`, `category`),
    FOREIGN KEY (`base`) REFERENCES `admin` (`admin_username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`category`) REFERENCES `category` (`category_id`) ON DELETE CASCADE ON UPDATE CASCADE
) Engine = InnoDB;

DROP TABLE IF EXISTS `product`;
CREATE TABLE`product`(
    `id` INT AUTO_INCREMENT NOT NULL,
    `product_name` VARCHAR(40) NOT NULL,
    `product_descr` VARCHAR(150) NOT NULL,
    `category` INT NOT NULL,

    PRIMARY KEY (`id`),
    FOREIGN KEY (`category`) REFERENCES `category` (`category_id`) ON DELETE CASCADE ON UPDATE CASCADE
) Engine = InnoDB;

DROP TABLE IF EXISTS `announcement`;
CREATE TABLE`announcement`(
    `announcement_id` INT NOT NULL,
    `product_id` INT NOT NULL,
    `base` VARCHAR(30) NOT NULL,

    PRIMARY KEY (`announcement_id`,`product_id`),
    FOREIGN KEY (`base`) REFERENCES `admin` (`admin_username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) Engine = InnoDB;

DROP TABLE IF EXISTS `cargo`;
CREATE TABLE`cargo`(
    `vehicle_name` VARCHAR(20) NOT NULL,
    `product_id` INT NOT NULL,
    `quantity` INT NOT NULL,

    PRIMARY KEY (`vehicle_name`, `product_id`),
    FOREIGN KEY (`vehicle_name`) REFERENCES `rescuer` (`vehicle`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) Engine = InnoDB;

DROP TABLE IF EXISTS `request`;
CREATE TABLE`request`(
    `request_user` VARCHAR(30) NOT NULL,
    `request_id` INT NOT NULL,
    `product_id` INT NOT NULL,
    `persons_num` INT NOT NULL,

    PRIMARY KEY (`request_id`),
    FOREIGN KEY (`request_user`) REFERENCES `citizen` (`citizen_username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) Engine = InnoDB;

DROP TABLE IF EXISTS `offer`;
CREATE TABLE`offer`(
    `offer_user` VARCHAR(30) NOT NULL,
    `offer_id` INT NOT NULL,
    `product_id` INT NOT NULL,
    `quantity` INT NOT NULL,

    PRIMARY KEY (`offer_id`),
    FOREIGN KEY (`offer_user`) REFERENCES `citizen` (`citizen_username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) Engine = InnoDB;

DROP TABLE IF EXISTS `task`;
CREATE TABLE`task`(
    `task_id` INT AUTO_INCREMENT NOT NULL,
    `rescuer_took_over` VARCHAR(30),
    `accepted` ENUM('YES', 'NO') DEFAULT 'NO' NOT NULL,
    `completed` ENUM('YES', 'NO') DEFAULT 'NO' NOT NULL,
    `reg_date` DATETIME NOT NULL,
    `accept_date` DATETIME,
    `complete_date` DATETIME,

    PRIMARY KEY (`task_id`),
    FOREIGN KEY (`rescuer_took_over`) REFERENCES `rescuer` (`rescuer_username`) ON DELETE CASCADE ON UPDATE CASCADE
) Engine = InnoDB;

DROP TABLE IF EXISTS `request`;
CREATE TABLE`request`(
    `request_user` VARCHAR(30) NOT NULL,
    `request_id` INT NOT NULL,
    `product_id` INT NOT NULL,
    `persons_num` INT NOT NULL,

    PRIMARY KEY (`request_id`),
    FOREIGN KEY (`request_user`) REFERENCES `citizen` (`citizen_username`) ON DELETE CASCADE ON UPDATE CASCADE
) Engine = InnoDB;

DROP TABLE IF EXISTS `base_inventory`;
CREATE TABLE`base_inventory`(
    `product_id` INT NOT NULL,
    `quantity` INT NOT NULL,
    `base` VARCHAR(30) NOT NULL,

    PRIMARY KEY (`product_id`),
    FOREIGN KEY (`base`) REFERENCES `admin` (`admin_username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) Engine = InnoDB;


DROP PROCEDURE IF EXISTS displayBaseInventory;
DELIMITER $$
CREATE PROCEDURE displayBaseInventory(adm VARCHAR(30), category INT)
BEGIN

SELECT `cargo`.`product_id`, SUM(`cargo`.`quantity`)
FROM `rescuer`
    JOIN `cargo` ON `rescuer`.`vehicle`=`cargo`.`vehicle_name`
    JOIN `product` ON `cargo`.`product_id`=`product`.`id`
WHERE `rescuer`.`base`=adm AND `product`.`category`=category
GROUP BY `product_id`
ORDER BY `product_id` ASC;

END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS maxAnnouncementId;
DELIMITER $$
CREATE PROCEDURE maxAnnouncementId(adm VARCHAR(30), OUT max INT)
BEGIN

SELECT `announcement_id`
INTO max
FROM `announcement`
    JOIN `base` ON `announcement`.`base`=`base`.`admin_username`
WHERE `base`=adm
ORDER BY `announcement_id` DESC
LIMIT 1;

END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS maxTasks;
DELIMITER $$
CREATE PROCEDURE maxTasks(resc VARCHAR(30), OUT tasks INT)
BEGIN

SELECT COUNT(*)
INTO tasks
FROM `rescuer`
JOIN `task` ON `rescuer`.`rescuer_username`=`task`.`rescuer_took_over`
WHERE `rescuer`.`rescuer_username`=resc AND `accepted`='YES' AND `completed`='NO';

END $$
DELIMITER ;
-- SQLBook: Code
