CREATE DATABASE  IF NOT EXISTS `shop` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `shop`;
-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: shop
-- ------------------------------------------------------
-- Server version	8.0.41

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
-- Table structure for table `artículos`
--

DROP TABLE IF EXISTS `artículos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `artículos` (
  `A_ID` int NOT NULL AUTO_INCREMENT,
  `A_Name` varchar(20) DEFAULT NULL,
  `A_Descr` varchar(200) DEFAULT NULL,
  `A_Cost` decimal(10,2) DEFAULT NULL,
  `A_Stock` int DEFAULT NULL,
  PRIMARY KEY (`A_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artículos`
--

LOCK TABLES `artículos` WRITE;
/*!40000 ALTER TABLE `artículos` DISABLE KEYS */;
INSERT INTO `artículos` VALUES (1,'Rotulador rojo','Herramienta de dibujo roja',1.30,999),(2,'Rotulador verde','Herramienta de dibujo verde',1.30,956),(3,'Rotulador azul','Herramienta de dibujo azul',1.30,987),(4,'Lápiz','Herramienta de escritura',1.10,988),(5,'Bolígrafo negro','Herramienta de escritura negra',1.25,999),(6,'Bolígrafo azul','Herramienta de escritura azul',1.25,999),(7,'Papel cuadriculado','Herramienta de escritura',5.80,100),(8,'Agenda','Libreta para almacenar tareas',7.00,10),(9,'Regla','Herramienta de medición',3.10,50),(10,'Compás','Herramienta de dibujo',5.40,10);
/*!40000 ALTER TABLE `artículos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `Cl_ID` int NOT NULL AUTO_INCREMENT,
  `Cl_Name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`Cl_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'Samuel'),(2,'Samuel'),(3,'Isabel'),(4,'Helena'),(5,'Samuel'),(6,'Isabel'),(7,'Pedro'),(8,'Isabel'),(9,'Helena'),(10,'Samuel'),(11,'Helena'),(12,'Isabel'),(13,'Ricardo'),(14,'Pablo'),(15,'Charo');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidoartículos`
--

DROP TABLE IF EXISTS `pedidoartículos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidoartículos` (
  `Cl_ID` int NOT NULL,
  `Ped_ID` int NOT NULL,
  `A_ID` int NOT NULL,
  `Quant` int DEFAULT NULL,
  `Tot_Cost` decimal(10,0) DEFAULT NULL,
  PRIMARY KEY (`Cl_ID`,`Ped_ID`,`A_ID`),
  KEY `FK_Pedido` (`Ped_ID`),
  KEY `FK_Articulo` (`A_ID`),
  CONSTRAINT `FK_Articulo` FOREIGN KEY (`A_ID`) REFERENCES `artículos` (`A_ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `FK_Cliente` FOREIGN KEY (`Cl_ID`) REFERENCES `clientes` (`Cl_ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `FK_Pedido` FOREIGN KEY (`Ped_ID`) REFERENCES `pedidos` (`Ped_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidoartículos`
--

LOCK TABLES `pedidoartículos` WRITE;
/*!40000 ALTER TABLE `pedidoartículos` DISABLE KEYS */;
INSERT INTO `pedidoartículos` VALUES (1,1,3,12,16),(1,2,2,43,56),(3,3,4,11,12);
/*!40000 ALTER TABLE `pedidoartículos` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `pedidoartículos_BEFORE_INSERT` BEFORE INSERT ON `pedidoartículos` FOR EACH ROW BEGIN
    DECLARE current_stock INT;
	DECLARE item_cost DECIMAL(10,2);
    SELECT A_Stock INTO current_stock
    FROM Artículos
    WHERE A_ID = NEW.A_ID;

    IF NEW.Quant > current_stock THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No hay suficiente stock disponible para uno o más artículos.';
    ELSE
        SELECT A_Cost INTO item_cost
        FROM Artículos
        WHERE A_ID = NEW.A_ID;
		SET NEW.Tot_Cost = NEW.Quant * item_cost;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `artículos_AFTER_INSERT` AFTER INSERT ON `pedidoartículos` FOR EACH ROW BEGIN
    UPDATE Artículos
    SET A_Stock = A_Stock - NEW.Quant
    WHERE A_ID = NEW.A_ID;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `pedidos`
--

DROP TABLE IF EXISTS `pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos` (
  `Ped_ID` int NOT NULL AUTO_INCREMENT,
  `Ped_Date` date NOT NULL DEFAULT (curdate()),
  PRIMARY KEY (`Ped_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos`
--

LOCK TABLES `pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
INSERT INTO `pedidos` VALUES (1,'0003-04-25'),(2,'0001-04-25'),(3,'0002-04-25'),(4,'0002-04-25'),(5,'2028-03-25'),(6,'2029-03-25'),(7,'2028-03-25');
/*!40000 ALTER TABLE `pedidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'shop'
--

--
-- Dumping routines for database 'shop'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-04 14:57:19
