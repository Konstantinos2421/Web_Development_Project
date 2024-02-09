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
-- Table structure for table `rescuer`
--

DROP TABLE IF EXISTS `rescuer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rescuer` (
  `rescuer_username` varchar(30) COLLATE utf16_unicode_ci NOT NULL,
  `vehicle` varchar(20) COLLATE utf16_unicode_ci NOT NULL,
  `vehicle_location` point NOT NULL,
  `base` varchar(30) COLLATE utf16_unicode_ci NOT NULL,
  PRIMARY KEY (`rescuer_username`),
  UNIQUE KEY `vehicle` (`vehicle`),
  KEY `base` (`base`),
  CONSTRAINT `rescuer_ibfk_1` FOREIGN KEY (`rescuer_username`) REFERENCES `user` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `rescuer_ibfk_2` FOREIGN KEY (`base`) REFERENCES `base` (`base_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf16 COLLATE=utf16_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rescuer`
--

LOCK TABLES `rescuer` WRITE;
/*!40000 ALTER TABLE `rescuer` DISABLE KEYS */;
INSERT INTO `rescuer` VALUES ('antonis_sarafis','PLE8456',_binary '\0\0\0\0\0\0\0Ç\‚«òªC@B>\ËŸ¨∫5@','PATRA_BASE1'),('foivos_rigopoulos','KTL8963',_binary '\0\0\0\0\0\0\0‰ÉûÕ™C@\Ëj+ˆóΩ5@','PATRA_BASE1'),('natassa_politi','AXY8965',_binary '\0\0\0\0\0\0\0ıèüxÚC@í&TDæ5@','PATRA_BASE1'),('niki_petratou','RTK7541',_binary '\0\0\0\0\0\0\0bX9¥ C@\ \√B≠iæ5@','PATRA_BASE1'),('sotiris_pavlopoulos','GTD8563',_binary '\0\0\0\0\0\0\0W[±ø\ÏC@HPº5@','PATRA_BASE1');
/*!40000 ALTER TABLE `rescuer` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
