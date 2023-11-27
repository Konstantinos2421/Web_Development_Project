-- SQLBook: Code
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

DROP PROCEDURE IF EXISTS addAnnouncement;
DELIMITER $$
CREATE PROCEDURE addAnnouncement(adm VARCHAR(30), prod INT, ann_state enum('NEW', 'LAST'))
BEGIN

DECLARE max_id INT;
DECLARE announcement_exists INT;

SELECT IFNULL(`announcement_id`,0)
INTO max_id
FROM `announcement`
WHERE `base`=adm
ORDER BY `announcement_id` DESC
LIMIT 1;

SELECT COUNT(*)
INTO announcement_exists
FROM announcement
WHERE `announcement`.`base`=adm;

IF announcement_exists=0 THEN
	INSERT INTO announcement VALUES(1, prod, adm);
ELSE
	IF ann_state='LAST' THEN
		INSERT INTO `announcement` VALUES (max_id, prod, adm);
	ELSEIF ann_state='NEW' THEN
		INSERT INTO `announcement` VALUES (max_id+1, prod, adm);
	END IF;
END IF;

END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS rescuerAcceptTask;
DELIMITER $$
CREATE PROCEDURE rescuerAcceptTask(resc VARCHAR(30), task INT)
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

END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS rescuerLoadCargoFromBase;
DELIMITER $$
CREATE PROCEDURE rescuerLoadCargoFromBase(resc VARCHAR(30), prod INT, quant INT)
BEGIN

DECLARE base_quantity INT;
DECLARE products_in_base INT;
DECLARE vehicle VARCHAR(20);

SELECT `quantity`
INTO base_quantity
FROM `base_inventory`
WHERE `product_id`=prod;

IF quant>base_quantity THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Not enough products in base inventory';
ELSE
    UPDATE `base_inventory`
    SET `quantity`=`quantity`-quant
    WHERE `product_id`=prod;
END IF;

SELECT `rescuer`.`vehicle`
INTO vehicle
FROM `rescuer`
WHERE `rescuer`.`rescuer_username`=resc;

SELECT COUNT(*)
INTO products_in_base
FROM `cargo`
WHERE `product_id`=prod AND `cargo`.`vehicle_name`=vehicle;

IF products_in_base=0 THEN
    INSERT INTO `cargo` VALUES (vehicle, prod, quant);
ELSE
    UPDATE `cargo`
    SET `quantity`=`quantity`+quant
    WHERE `product_id`=prod AND `cargo`.`vehicle_name`=vehicle;
END IF;

END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS rescuerUnloadCargoToBase;
DELIMITER $$
CREATE PROCEDURE rescuerUnloadCargoToBase(resc VARCHAR(30))
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
        WHERE `product_id`=prod;

        IF products_in_base=0 THEN
            INSERT INTO `base_inventory` VALUES (prod, quant, base);
        ELSE
            UPDATE `base_inventory`
            SET `quantity`=`quantity`+quant
            WHERE `product_id`=prod;
        END IF;

        DELETE FROM `cargo`
        WHERE `cargo`.`vehicle_name`=vehicle AND `cargo`.`product_id`=prod;

        SET cnt = cnt + 1;
    END WHILE;
END IF;

END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS rescuerLoadCargoFromCitizen;
DELIMITER $$
CREATE PROCEDURE rescuerLoadCargoFromCitizen(resc VARCHAR(30), task_id INT)
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

END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS rescuerUnloadCargoToCitizen;
DELIMITER $$
CREATE PROCEDURE rescuerUnloadCargoToCitizen(resc VARCHAR(30), quant INT, task_id INT) -- quant is the quantity of the product that the rescuer wants to unload
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

END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS rescuerCancelTask;
DELIMITER $$
CREATE PROCEDURE rescuerCancelTask(resc VARCHAR(30), task_id INT)
BEGIN

UPDATE `task`
SET `rescuer_took_over`=NULL, `accepted`='NO', `accept_date`=NULL
WHERE `task`.`task_id`=task_id;

END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS citizenCancelOffer;
DELIMITER $$
CREATE PROCEDURE citizenCancelOffer(cit VARCHAR(30), task_id INT)
BEGIN

DELETE FROM `offer`
WHERE `offer`.`offer_id`=task_id;

DELETE FROM `task`
WHERE `task`.`task_id`=task_id;

END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS displayBaseInventory;
DELIMITER $$
CREATE PROCEDURE displayBaseInventory(adm VARCHAR(30), cat INT)
BEGIN

CREATE TEMPORARY TABLE `temp1` AS
SELECT `product`.`id` AS `product_id`, `product`.`product_name` AS `product_name`, IFNULL(`base_inventory`.`quantity`, 0) AS `base_quantity`
FROM `product`
	LEFT JOIN `base_inventory` ON `product`.`id`=`base_inventory`.`product_id` AND `base_inventory`.`base`=adm
WHERE `product`.`category`=cat
ORDER BY `product`.`id` ASC;

CREATE TEMPORARY TABLE `temp2` AS
SELECT `product`.`id` AS `product_id`, `product`.`product_name` AS `product_name`, IFNULL(SUM(`cargo`.`quantity`),0) AS `rescuers_quantity`
FROM `product`
	LEFT JOIN `cargo` ON `cargo`.`product_id`=`product`.`id`
    LEFT JOIN `rescuer` ON `rescuer`.`vehicle`=`cargo`.`vehicle_name` AND `rescuer`.`base`=adm
WHERE `product`.`category`=cat
GROUP BY `product`.`id`
ORDER BY `product`.`id` ASC;

SELECT `temp1`.`product_id`, `temp1`.`product_name`, `temp1`.`base_quantity` + `temp2`.`rescuers_quantity`
FROM `temp1`
	JOIN `temp2` ON `temp1`.`product_id`=`temp2`.`product_id`
ORDER BY `temp1`.`product_id` ASC;

DROP TABLE `temp1`, `temp2`;


END $$
DELIMITER ;