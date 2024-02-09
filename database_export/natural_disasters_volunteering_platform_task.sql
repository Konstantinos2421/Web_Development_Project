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
-- Table structure for table `task`
--

DROP TABLE IF EXISTS `task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task` (
  `task_id` int NOT NULL AUTO_INCREMENT,
  `rescuer_took_over` varchar(30) COLLATE utf16_unicode_ci DEFAULT NULL,
  `accepted` enum('YES','NO') COLLATE utf16_unicode_ci NOT NULL DEFAULT 'NO',
  `completed` enum('YES','NO') COLLATE utf16_unicode_ci NOT NULL DEFAULT 'NO',
  `reg_date` datetime NOT NULL,
  `accept_date` datetime DEFAULT NULL,
  `complete_date` datetime DEFAULT NULL,
  PRIMARY KEY (`task_id`),
  KEY `rescuer_took_over` (`rescuer_took_over`),
  CONSTRAINT `task_ibfk_1` FOREIGN KEY (`rescuer_took_over`) REFERENCES `rescuer` (`rescuer_username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf16 COLLATE=utf16_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task`
--

LOCK TABLES `task` WRITE;
/*!40000 ALTER TABLE `task` DISABLE KEYS */;
INSERT INTO `task` VALUES (1,'natassa_politi','YES','YES','2024-02-03 16:41:23','2024-02-09 13:13:25','2024-02-09 13:13:36'),(2,NULL,'NO','NO','2024-02-03 16:41:23',NULL,NULL),(3,NULL,'NO','NO','2024-02-03 16:41:23',NULL,NULL),(4,'foivos_rigopoulos','YES','NO','2024-02-03 16:41:23','2024-02-03 16:41:23',NULL),(5,NULL,'NO','NO','2024-02-03 16:41:23',NULL,NULL),(6,NULL,'NO','NO','2024-02-03 16:41:23',NULL,NULL),(7,NULL,'NO','NO','2024-02-03 16:41:23',NULL,NULL),(8,NULL,'NO','NO','2024-02-03 16:41:23',NULL,NULL),(9,'niki_petratou','YES','NO','2024-02-03 16:41:23','2024-02-03 16:41:23',NULL),(10,'natassa_politi','YES','YES','2024-02-03 16:41:23','2024-02-09 13:30:38','2024-02-09 13:31:09'),(11,NULL,'NO','NO','2024-02-03 16:41:23',NULL,NULL),(12,NULL,'NO','NO','2024-02-03 16:41:23',NULL,NULL),(13,'natassa_politi','YES','NO','2024-02-03 16:41:23','2024-02-03 16:41:23',NULL),(14,NULL,'NO','NO','2024-02-03 16:41:23',NULL,NULL),(15,NULL,'NO','NO','2024-02-03 16:41:23',NULL,NULL);
/*!40000 ALTER TABLE `task` ENABLE KEYS */;
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
