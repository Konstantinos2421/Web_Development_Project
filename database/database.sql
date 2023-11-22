-- SQLBook: Code
DROP DATABASE IF EXISTS natural_disasters_volunteering_platform;
CREATE DATABASE natural_disasters_volunteering_platform DEFAULT CHARSET utf16 COLLATE utf16_unicode_ci;
 USE natural_disasters_volunteering_platform;

DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`(
    `username` VARCHAR(30) NOT NULL,
    `password` VARCHAR(30) NOT NULL,
    `first_name` VARCHAR(30) NOT NULL,
    `last_name` VARCHAR(30) NOT NULL,
    `phone_num` INT NOT NULL,

    PRIMARY KEY (`username`) 
)Engine = InnoDB;

DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin`(
    `admin_username` VARCHAR(30) NOT NULL,
    `base_location` POINT NOT NULL,
   

    PRIMARY KEY (`admin_username`),
    FOREIGN KEY (`admin_username`) REFERENCES `user` (`username`) ON DELETE CASCADE ON UPDATE CASCADE  
)Engine = InnoDB;

DROP TABLE IF EXISTS `rescuer`;
CREATE TABLE `rescuer`(
    `rescuer_username` VARCHAR(30) NOT NULL,
    `vehicle` VARCHAR(20) UNIQUE NOT NULL,
    `vehicle_location` POINT NOT NULL,
    `base` VARCHAR(30) NOT NULL,

    PRIMARY KEY (`rescuer_username`),
    FOREIGN KEY (`rescuer_username`) REFERENCES `user` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`base`) REFERENCES `admin` (`admin_username`) ON DELETE CASCADE ON UPDATE CASCADE  
)Engine = InnoDB;

DROP TABLE IF EXISTS `citizen`;
CREATE TABLE `citizen`(
    `citizen_username` VARCHAR(30) NOT NULL,
    `citizen_location` POINT NOT NULL,

    PRIMARY KEY (`citizen_username`),
    FOREIGN KEY (`citizen_username`) REFERENCES `user` (`username`) ON DELETE CASCADE ON UPDATE CASCADE  
)Engine = InnoDB;

DROP TABLE IF EXISTS `has_category`;
CREATE TABLE `has_category`(
    `base` VARCHAR(30) NOT NULL,
    `category` VARCHAR(30) UNIQUE NOT NULL,
    
    PRIMARY KEY (`base`,`category`),
    FOREIGN KEY (`base`) REFERENCES `admin` (`admin_username`) ON DELETE CASCADE ON UPDATE CASCADE  
)Engine = InnoDB;

DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`(
    `category_name` VARCHAR(30) NOT NULL,
    `product_id` INT UNIQUE NOT NULL,
    
    PRIMARY KEY (`category_name`),
    FOREIGN KEY (`category_name`) REFERENCES `has_category` (`category`) ON DELETE CASCADE ON UPDATE CASCADE  
)Engine = InnoDB;

DROP TABLE IF EXISTS `product`;
CREATE TABLE `product`(
    `id` INT AUTO_INCREMENT NOT NULL,
    `product_name` VARCHAR(40) NOT NULL,
    `product_descr` VARCHAR(150) NOT NULL,
    
    
    PRIMARY KEY (`id`),
    FOREIGN KEY (`id`) REFERENCES `category` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE  
)Engine = InnoDB;

DROP TABLE IF EXISTS `announcement`;
CREATE TABLE `announcement`(
    `announcement_id` INT AUTO_INCREMENT NOT NULL,
    `product_id` INT NOT NULL,
    `base` VARCHAR(30) NOT NULL,

    PRIMARY KEY (`announcement_id`,`product_id`),
    FOREIGN KEY (`base`) REFERENCES `admin` (`admin_username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
)Engine = InnoDB;

DROP TABLE IF EXISTS `cargo`;
CREATE TABLE `cargo`(
    `vehicle_name` VARCHAR(20) NOT NULL,
    `product_id` INT NOT NULL,
    `quantity` INT NOT NULL,
    
    PRIMARY KEY (`vehicle_name`,`product_id`),
    FOREIGN KEY (`vehicle_name`) REFERENCES `rescuer` (`vehicle`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
  
)Engine = InnoDB;


DROP TABLE IF EXISTS `request`;
CREATE TABLE `request`(
    `request_user` VARCHAR(30) NOT NULL,
    `request_id` INT NOT NULL,
    `product_id` INT NOT NULL,
    `persons_num` INT NOT NULL,
    
    PRIMARY KEY (`request_id`),
    FOREIGN KEY (`request_user`) REFERENCES `citizen` (`citizen_username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
 
)Engine = InnoDB;


DROP TABLE IF EXISTS `offer`;
CREATE TABLE `offer`(
    `offer_user` VARCHAR(30) NOT NULL,
    `offer_id` INT NOT NULL,
    `product_id` INT NOT NULL,
    `quantity` INT NOT NULL,
    
    PRIMARY KEY (`offer_id`),
    FOREIGN KEY (`offer_user`) REFERENCES `citizen` (`citizen_username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
  
)Engine = InnoDB;



DROP TABLE IF EXISTS `task`;
CREATE TABLE `task`(
    `task_id` INT AUTO_INCREMENT NOT NULL,
    `rescuer_took_over` VARCHAR(30),
    `accepted` ENUM('yes','no') DEFAULT 'no' NOT NULL,
    `completed` ENUM('yes','no') DEFAULT 'no' NOT NULL,
    `reg_date` DATETIME NOT NULL,
    `accept_date` DATETIME,
    `complete_date` DATETIME,
    
    PRIMARY KEY (`task_id`),
    FOREIGN KEY (`rescuer_took_over`) REFERENCES `rescuer` (`rescuer_username`) ON DELETE CASCADE ON UPDATE CASCADE  
)Engine = InnoDB;

DROP TABLE IF EXISTS `request`;
CREATE TABLE `request`(
    `request_user` VARCHAR(30) NOT NULL,
    `request_id` INT NOT NULL,
    `product_id` INT NOT NULL,
    `persons_num` INT NOT NULL,
    
    PRIMARY KEY (`request_id`),
    FOREIGN KEY (`request_user`) REFERENCES `citizen` (`citizen_username`) ON DELETE CASCADE ON UPDATE CASCADE  
)Engine = InnoDB;


DROP TABLE IF EXISTS `base_inventory`;
CREATE TABLE `base_inventory`(
    `product_id` INT NOT NULL,
    `quantity` INT NOT NULL,
    `base` VARCHAR(30) NOT NULL,
    
    PRIMARY KEY (`product_id`),
    FOREIGN KEY (`base`) REFERENCES `admin` (`admin_username`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
   
)Engine = InnoDB;


