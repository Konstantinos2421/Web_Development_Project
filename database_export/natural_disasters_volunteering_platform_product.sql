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
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_name` varchar(40) COLLATE utf16_unicode_ci NOT NULL,
  `product_descr` text COLLATE utf16_unicode_ci NOT NULL,
  `category` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `category` (`category`),
  CONSTRAINT `product_ibfk_1` FOREIGN KEY (`category`) REFERENCES `category` (`category_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf16 COLLATE=utf16_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,'Water','volume: 1.5l\npack size: 6\n',6),(2,'Orange juice','volume: 250ml\npack size: 12\n',6),(3,'Sardines','brand: Trata\nweight: 200g\n',5),(4,'Chocolate','weight: 100g\ntype: milk chocolate\nbrand: ION\n',5),(5,'Canned corn','weight: 500g\n',5),(6,'Bread','weight: 1kg\ntype: white\n',5),(7,'Men Sneakers','size: 44\n',7),(8,'Test Val','Details: 600ml\n',14),(9,'Spaghetti','grams: 500\n',5),(10,'Croissant','calories: 200\n',5),(11,'Disposable gloves','',16),(12,'Gauze','',16),(13,'Antiseptic','',16),(14,'First Aid Kit','',16),(15,'Painkillers','volume: 200mg\n',16),(16,'Blanket','size: 50\" x 60\"\n',7),(17,'Menstrual Pads','size: 3\n',21),(18,'Tampon','size: regular\n',21),(19,'Baby wipes','volume: 500gr\nstock : 500\nscent: aloe\n',21),(20,'Toothbrush','',21),(21,'Toothpaste','',21),(22,'Vitamin C','',16),(23,'Multivitamines','',16),(24,'Paracetamol','dosage: 500mg\n',16),(25,'Ibuprofen','stock : 10\ndosage: 200mg\n',16),(26,'Cleaning rag','',22),(27,'Detergent','',22),(28,'Disinfectant','',22),(29,'Mop','',22),(30,'Plastic bucket','',22),(31,'Scrub brush','',22),(32,'Dust mask','',22),(33,'Broom','',22),(34,'Hammer','',23),(35,'Skillsaw','',23),(36,'Prybar','',23),(37,'Shovel','',23),(38,'Duct tape','',23),(39,'Underwear','',7),(40,'Socks','',7),(41,'Warm Jacket','',7),(42,'Raincoat','',7),(43,'Gloves','',7),(44,'Pants','',7),(45,'Boots','',7),(46,'Dishes','',24),(47,'Pots','',24),(48,'Paring knives','',24),(49,'Pan','',24),(50,'Glass','',24),(51,'Coca Cola','Volume: 500ml\n',6),(52,'spray','volume: 75ml\n',26),(53,'Outdoor spiral','duration: 7 hours\n',26),(54,'Baby bottle','volume: 250ml\n',25),(55,'Pacifier','material: silicone\n',25),(56,'Condensed milk','weight: 400gr\n',5),(57,'Cereal bar','weight: 23,5gr\n',5),(58,'Pocket Knife','Number of different tools: 3\nTool: Knife\nTool: Screwdriver\nTool: Spoon\n',23),(59,'Water Disinfection Tablets','Basic Ingredients: Iodine\nSuggested for: Everyone expept pregnant women\n',16),(60,'Radio','Power: Batteries\nFrequencies Range: 3 kHz - 3000 GHz\n',27),(61,'Kitchen appliances','',14),(62,'Winter hat','',28),(63,'Winter gloves','',28),(64,'Scarf','',28),(65,'Thermos','',28),(66,'Tea','volume: 500ml\n',6),(67,'Dog Food ','volume: 500g\n',29),(68,'Cat Food','volume: 500g\n',29),(69,'Canned','',5),(70,'Chlorine','volume: 500ml\n',22),(71,'Medical gloves','volume: 20pieces\n',22),(72,'T-Shirt','size: XL\n',7),(73,'Cooling Fan','',34),(74,'Cool Scarf','',34),(75,'Whistle','',23),(76,'Sleeping Bag','',28),(77,'Thermometer','',16),(78,'Rice','',5),(79,'Towels','',22),(80,'Wet Wipes','',22),(81,'Fire Extinguisher','',23),(82,'Fruits','',5),(83,'Sport Shoes','Νο 46: \n',19),(84,'Bandages','Adhesive: 2 meters\n',35),(85,'Betadine','Povidone iodine 10%: 240 ml\n',35),(86,'cotton wool','100% Hydrofile: 70gr\n',35),(87,'Crackers','Quantity per package: 10\nPackages: 2\n',5),(88,'Sanitary Pads','piece: 10 pieces\n',21),(89,'Sanitary wipes','pank: 10 packs\n',21),(90,'Electrolytes','packet of pills: 20 pills\n',16),(91,'Pain killers','packet of pills: 20 pills\n',16),(92,'Flashlight','pieces: 1\n',23),(93,'Juice','volume: 500ml\n',6),(94,'Toilet Paper','rolls: 1 roll\n',21),(95,'Sterilized Saline','volume: 100ml\n',16),(96,'Biscuits','packet: 1 packet\n',5),(97,'Antihistamines','pills: 10 pills\n',16),(98,'Instant Pancake Mix','',5),(99,'Lacta','weight: 105g\n',5),(100,'Canned Tuna','',5),(101,'Batteries','6 pack: \n',23),(102,'Can Opener','1: \n',23),(103,'Chips','weight: 45g\n',5),(104,'Dry Cranberries','weight: 100\n',5),(105,'Dry Apricots','weight: 100\n',5),(106,'Dry Figs','weight: 100\n',5),(107,'Tampons','',16);
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
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
