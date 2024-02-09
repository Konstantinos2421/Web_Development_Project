-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: localhost    Database: natural_disasters_volunteering_platform
-- ------------------------------------------------------
-- Server version	8.0.35

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping routines for database 'natural_disasters_volunteering_platform'
--
/*!50003 DROP PROCEDURE IF EXISTS `addAnnouncement` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `addAnnouncement`(base VARCHAR(30), prod INT, ann_state enum('NEW', 'LAST'))
BEGIN

DECLARE max_id INT;
DECLARE announcement_exists INT;

SELECT IFNULL(`announcement_id`,0)
INTO max_id
FROM `announcement`
WHERE `announcement`.`base`=base
ORDER BY `announcement_id` DESC
LIMIT 1;

SELECT COUNT(*)
INTO announcement_exists
FROM announcement
WHERE `announcement`.`base`=base;

IF announcement_exists=0 THEN
	INSERT INTO announcement VALUES(1, prod, base);
ELSE
	IF ann_state='LAST' THEN
		INSERT INTO `announcement` VALUES (max_id, prod, base);
	ELSEIF ann_state='NEW' THEN
		INSERT INTO `announcement` VALUES (max_id+1, prod, base);
	END IF;
END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `citizenCancelOffer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `citizenCancelOffer`(cit VARCHAR(30), task_id INT)
BEGIN

DELETE FROM `offer`
WHERE `offer`.`offer_id`=task_id;

DELETE FROM `task`
WHERE `task`.`task_id`=task_id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `citizenCancelRequest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `citizenCancelRequest`(cit VARCHAR(30), task_id INT)
BEGIN

DELETE FROM `request`
WHERE `request`.`request_id`=task_id;

DELETE FROM `task`
WHERE `task`.`task_id`=task_id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `displayBaseInventory` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `displayBaseInventory`(base VARCHAR(30), cat INT)
BEGIN

CREATE TEMPORARY TABLE `temp1` AS
SELECT `product`.`id` AS `product_id`, `product`.`product_name` AS `product_name`, IFNULL(`base_inventory`.`quantity`, 0) AS `base_quantity`
FROM `has_product`
	JOIN `product` ON `has_product`.`product`=`product`.`id` AND `has_product`.`base`=base
	LEFT JOIN `base_inventory` ON `product`.`id`=`base_inventory`.`product_id` AND `base_inventory`.`base`=base
WHERE `product`.`category`=cat
ORDER BY `product`.`id` ASC;

CREATE TEMPORARY TABLE `temp2` AS
SELECT `product`.`id` AS `product_id`, `product`.`product_name` AS `product_name`, IFNULL(SUM(`cargo`.`quantity`),0) AS `rescuers_quantity`
FROM `has_product`
	JOIN `product` ON `has_product`.`product`=`product`.`id` AND `has_product`.`base`=base
	LEFT JOIN `cargo` ON `cargo`.`product_id`=`product`.`id`
    LEFT JOIN `rescuer` ON `rescuer`.`vehicle`=`cargo`.`vehicle_name` AND `rescuer`.`base`=base
WHERE `product`.`category`=cat
GROUP BY `product`.`id`
ORDER BY `product`.`id` ASC;

SELECT `temp1`.`product_id` AS product_id, `temp1`.`product_name` AS product_name, `temp1`.`base_quantity` AS base_quantity,  `temp2`.`rescuers_quantity` AS rescuers_quantity, (`temp1`.`base_quantity` + `temp2`.`rescuers_quantity`) AS total_quantity
FROM `temp1`
	JOIN `temp2` ON `temp1`.`product_id`=`temp2`.`product_id`
ORDER BY `temp1`.`product_id` ASC;

DROP TABLE `temp1`, `temp2`;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `newCategory` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `newCategory`(cat VARCHAR(30), base VARCHAR(30), cat_id INT)
BEGIN
    DECLARE element_count INT;
    DECLARE id INT;

    SELECT COUNT(*)
    INTO element_count
    FROM `category`
    WHERE `category_name`=cat;

    IF element_count = 0 THEN
		IF cat_id = 0 THEN
			INSERT INTO `category` VALUES
			(NULL, cat);
		ELSE 
			INSERT INTO `category` VALUES
			(cat_id, cat);
		END IF;

        SELECT `category_id`
        INTO id
        FROM `category`
        WHERE `category_name`=cat;

        INSERT INTO `has_category` VALUES
        (base, id);
    ELSE
        SELECT `category_id`
        INTO id
        FROM `category`
        WHERE `category_name`=cat;

        SELECT COUNT(*)
        INTO element_count
        FROM `has_category`
        WHERE `has_category`.`base`=base AND `has_category`.`category`=id;

        IF element_count = 0 THEN
            INSERT INTO `has_category` VALUES
            (base, id);
        ELSE
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Category already exists';
        END IF;
    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `newOffer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `newOffer`(citizen VARCHAR(30), product INT, quant INT)
BEGIN
	DECLARE new_id INT;
	
	INSERT INTO `task` VALUES
    (NULL, NULL, 'NO', 'NO', current_timestamp(), NULL, NULL);
    
    SELECT LAST_INSERT_ID() INTO new_id;
    
    INSERT INTO `offer` VALUES
    (new_id, citizen, product, quant);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `newProduct` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `newProduct`(prod VARCHAR(30), base VARCHAR(30), prod_id INT, descr TEXT, cat INT)
BEGIN
    DECLARE element_count INT;
    DECLARE id INT;

    SELECT COUNT(*)
    INTO element_count
    FROM `product`
    WHERE `product_name`=prod;

    IF element_count = 0 THEN
		IF prod_id = 0 THEN
			INSERT INTO `product` VALUES
			(NULL, prod, descr, cat);
		ELSE 
			INSERT INTO `product` VALUES
			(prod_id, prod, descr, cat);
		END IF;

        SELECT `product`.`id`
        INTO id
        FROM `product`
        WHERE `product_name`=prod;

        INSERT INTO `has_product` VALUES
        (base, id);
    ELSE
        SELECT `product`.`id`
        INTO id
        FROM `product`
        WHERE `product_name`=prod;

        SELECT COUNT(*)
        INTO element_count
        FROM `has_product`
        WHERE `has_product`.`base`=base AND `has_product`.`product`=id;

        IF element_count = 0 THEN
            INSERT INTO `has_product` VALUES
            (base, id);
        ELSE
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Product already exists';
        END IF;
    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `newRequest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `newRequest`(citizen VARCHAR(30), product INT, persons INT)
BEGIN
	DECLARE new_id INT;
	
	INSERT INTO `task` VALUES
    (NULL, NULL, 'NO', 'NO', current_timestamp(), NULL, NULL);
    
    SELECT LAST_INSERT_ID() INTO new_id;
    
    INSERT INTO `request` VALUES
    (new_id, citizen, product, persons);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `newRescuer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `newRescuer`(usr VARCHAR(30), pswd VARCHAR(30), fname VARCHAR(30), lname VARCHAR(30), tel BIGINT, vehc VARCHAR(20), adm VARCHAR(30))
BEGIN
    DECLARE base VARCHAR(30);
    DECLARE base_loc POINT;

    SELECT `admin`.`base`
    INTO base
    FROM `admin`
    WHERE `admin_username`=adm;

    SELECT `base_location`
    INTO base_loc
    FROM `base`
    WHERE `base_name`=base;

    INSERT INTO `user` VALUES
    (usr, pswd, fname, lname, tel);

    INSERT INTO `rescuer` VALUES
    (usr, vehc, base_loc, base);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `rescuerAcceptTask` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `rescuerAcceptTask`(resc VARCHAR(30), task INT)
BEGIN

DECLARE resc_tasks INT;

SELECT COUNT(*)
INTO resc_tasks
FROM `rescuer`
JOIN `task` ON `rescuer`.`rescuer_username`=`task`.`rescuer_took_over`
WHERE `rescuer`.`rescuer_username`=resc AND `accepted`='YES' AND `completed`='NO';

IF resc_tasks=4 THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Rescuer has already 4 tasks';
ELSE
    UPDATE `task`
    SET `rescuer_took_over`=resc, `accepted`='YES', `accept_date`=NOW()
    WHERE `task_id`=task;
END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `rescuerCancelTask` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `rescuerCancelTask`(resc VARCHAR(30), task_id INT)
BEGIN

UPDATE `task`
SET `rescuer_took_over`=NULL, `accepted`='NO', `accept_date`=NULL
WHERE `task`.`task_id`=task_id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `rescuerLoadCargoFromBase` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `rescuerLoadCargoFromBase`(resc VARCHAR(30), prod INT, quant INT)
BEGIN

DECLARE base_quantity INT;
DECLARE product_exists INT;
DECLARE vehicle VARCHAR(20);
DECLARE base VARCHAR(30);
DECLARE new_quantity INT;

SELECT `rescuer`.`base`
INTO base
FROM `rescuer` 
WHERE `rescuer_username`=resc;

SELECT `quantity`
INTO base_quantity
FROM `base_inventory`
WHERE `base_inventory`.`product_id`=prod AND `base_inventory`.`base`=base;

IF quant>base_quantity THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Not enough products in base inventory';
ELSE
	SELECT `quantity`-quant
    INTO new_quantity
    FROM `base_inventory`
    WHERE `base_inventory`.`product_id`=prod AND `base_inventory`.`base`=base;
    
    IF new_quantity > 0 THEN 
		UPDATE `base_inventory`
		SET `quantity`=new_quantity
		WHERE `product_id`=prod AND `base_inventory`.`base`=base;
	ELSE
		DELETE FROM `base_inventory` WHERE `base_inventory`.`product_id`=prod AND `base_inventory`.`base`=base;
	END IF;
END IF;

SELECT `rescuer`.`vehicle`
INTO vehicle
FROM `rescuer`
WHERE `rescuer`.`rescuer_username`=resc;

SELECT COUNT(*)
INTO product_exists
FROM `cargo`
WHERE `product_id`=prod AND `cargo`.`vehicle_name`=vehicle;

IF product_exists=0 THEN
    INSERT INTO `cargo` VALUES (vehicle, prod, quant);
ELSE
    UPDATE `cargo`
    SET `quantity`=`quantity`+quant
    WHERE `product_id`=prod AND `cargo`.`vehicle_name`=vehicle;
END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `rescuerLoadCargoFromCitizen` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `rescuerLoadCargoFromCitizen`(resc VARCHAR(30), task_id INT)
BEGIN

DECLARE product_exists_in_vehicle INT;
DECLARE prod INT;
DECLARE quant INT;
DECLARE vehicle VARCHAR(20);

SELECT `rescuer`.`vehicle`
INTO vehicle
FROM `rescuer`
WHERE `rescuer`.`rescuer_username`=resc;

SELECT `offer`.`product_id`, `offer`.`quantity`
INTO prod , quant
FROM `offer`
WHERE `offer`.`offer_id`=task_id;

SELECT COUNT(*)
INTO product_exists_in_vehicle
FROM `cargo`
WHERE `cargo`.`vehicle_name`=vehicle AND `cargo`.`product_id`=prod;


IF product_exists_in_vehicle=0 THEN
    INSERT INTO `cargo` VALUES (vehicle, prod, quant);
ELSE
    UPDATE `cargo`
    SET `quantity`=`quantity`+quant
    WHERE `cargo`.`vehicle_name`=vehicle AND `cargo`.`product_id`=prod;
END IF;

UPDATE `task`
SET `completed`='YES', `complete_date`=NOW()
WHERE `task`.`task_id`=task_id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `rescuerUnloadCargoToBase` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `rescuerUnloadCargoToBase`(resc VARCHAR(30))
BEGIN

DECLARE products_in_vehicle INT;
DECLARE vehicle VARCHAR(20);
DECLARE base VARCHAR(30);
DECLARE cnt INT DEFAULT 1;

DECLARE prod INT;
DECLARE quant INT;
DECLARE products_in_base INT;

SELECT `rescuer`.`vehicle`
INTO vehicle
FROM `rescuer`
WHERE `rescuer`.`rescuer_username`=resc; 

SELECT COUNT(*)
INTO products_in_vehicle
FROM `cargo`
WHERE `cargo`.`vehicle_name`=vehicle;

SELECT `rescuer`.`base`
INTO base
FROM `rescuer`
WHERE `rescuer`.`rescuer_username`=resc;

IF products_in_vehicle=0 THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No products in vehicle';
ELSE
    WHILE cnt <= products_in_vehicle DO
        SELECT `product_id`, `quantity`
        INTO prod, quant
        FROM `cargo`
        WHERE `cargo`.`vehicle_name`=vehicle
        LIMIT 1;

        SELECT COUNT(*)
        INTO products_in_base
        FROM `base_inventory`
        WHERE `base_inventory`.`product_id`=prod AND `base_inventory`.`base`=base;

        IF products_in_base=0 THEN
            INSERT INTO `base_inventory` VALUES (prod, quant, base);
        ELSE
            UPDATE `base_inventory`
            SET `quantity`=`quantity`+quant
            WHERE `base_inventory`.`product_id`=prod AND `base_inventory`.`base`=base;
        END IF;

        DELETE FROM `cargo`
        WHERE `cargo`.`vehicle_name`=vehicle AND `cargo`.`product_id`=prod;

        SET cnt = cnt + 1;
    END WHILE;
END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `rescuerUnloadCargoToCitizen` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `rescuerUnloadCargoToCitizen`(resc VARCHAR(30), quant INT, task_id INT)
BEGIN

DECLARE vehicle VARCHAR(20);
DECLARE prod INT;
DECLARE products_in_vehicle INT;

SELECT `rescuer`.`vehicle`
INTO vehicle
FROM `rescuer`
WHERE `rescuer`.`rescuer_username`=resc;

SELECT `request`.`product_id`
INTO prod
FROM `request`
WHERE `request`.`request_id`=task_id;

UPDATE `cargo`
SET `quantity`=`quantity`-quant
WHERE `cargo`.`vehicle_name`=vehicle AND `cargo`.`product_id`=prod;

SELECT COUNT(*)
INTO products_in_vehicle
FROM `cargo`
WHERE `cargo`.`vehicle_name`=vehicle AND `cargo`.`product_id`=prod;

IF products_in_vehicle=0 THEN
    DELETE FROM `cargo`
    WHERE `cargo`.`vehicle_name`=vehicle AND `cargo`.`product_id`=prod;
END IF;

UPDATE `task`
SET `completed`='YES', `complete_date`=NOW()
WHERE `task`.`task_id`=task_id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
