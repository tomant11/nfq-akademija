SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

DROP SCHEMA IF EXISTS `library` ;
CREATE SCHEMA IF NOT EXISTS `library` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `library` ;

-- -----------------------------------------------------
-- Table `library`.`Authors`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `library`.`Authors` ;

CREATE  TABLE IF NOT EXISTS `library`.`Authors` (
  `authorId` INT(11) NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`authorId`) )
ENGINE = MyISAM
AUTO_INCREMENT = 8;


-- -----------------------------------------------------
-- Table `library`.`Genres`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `library`.`Genres` ;

CREATE  TABLE IF NOT EXISTS `library`.`Genres` (
  `genreId` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NULL ,
  PRIMARY KEY (`genreId`) )
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `library`.`Books`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `library`.`Books` ;

CREATE  TABLE IF NOT EXISTS `library`.`Books` (
  `bookId` INT(11) NOT NULL AUTO_INCREMENT ,
  `title` VARCHAR(255) NOT NULL ,
  `year` YEAR NULL DEFAULT NULL ,
  `genreId` INT NULL ,
  PRIMARY KEY (`bookId`) )
ENGINE = MyISAM
AUTO_INCREMENT = 9;


-- -----------------------------------------------------
-- Table `library`.`BookAuthor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `library`.`BookAuthor` ;

CREATE  TABLE IF NOT EXISTS `library`.`BookAuthor` (
  `bookId` INT NOT NULL ,
  `authorId` INT NOT NULL ,
  PRIMARY KEY (`bookId`) ,
  INDEX `bookId_idx` (`bookId` ASC) ,
  INDEX `authorId_idx` (`authorId` ASC) )
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `library`.`Locations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `library`.`Locations` ;

CREATE  TABLE IF NOT EXISTS `library`.`Locations` (
  `locationId` INT NOT NULL AUTO_INCREMENT ,
  `code` VARCHAR(45) NULL ,
  PRIMARY KEY (`locationId`) )
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `library`.`Copies`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `library`.`Copies` ;

CREATE  TABLE IF NOT EXISTS `library`.`Copies` (
  `copyId` INT NOT NULL AUTO_INCREMENT ,
  `bookId` INT NOT NULL ,
  `locationId` INT NOT NULL ,
  PRIMARY KEY (`copyId`) ,
  INDEX `bookId_idx` (`bookId` ASC) ,
  INDEX `locationId_idx` (`locationId` ASC) )
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Placeholder table for view `library`.`view_empty_locations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library`.`view_empty_locations` (`locationId` INT, `code` INT);

-- -----------------------------------------------------
-- View `library`.`view_empty_locations`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `library`.`view_empty_locations` ;
DROP TABLE IF EXISTS `library`.`view_empty_locations`;
USE `library`;
CREATE  OR REPLACE VIEW `library`.`view_empty_locations` AS
SELECT l.* 
FROM Locations l
LEFT JOIN Copies c ON (c.locationId = l.locationId)
WHERE c.locationId IS NULL;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `library`.`Authors`
-- -----------------------------------------------------
START TRANSACTION;
USE `library`;
INSERT INTO `library`.`Authors` (`authorId`, `name`) VALUES (1, 'Chris Smith');
INSERT INTO `library`.`Authors` (`authorId`, `name`) VALUES (2, 'Steven Levithan');
INSERT INTO `library`.`Authors` (`authorId`, `name`) VALUES (3, 'Jan Goyvaerts');
INSERT INTO `library`.`Authors` (`authorId`, `name`) VALUES (4, 'Ryan Benedetti');
INSERT INTO `library`.`Authors` (`authorId`, `name`) VALUES (5, 'Al Anderson');
INSERT INTO `library`.`Authors` (`authorId`, `name`) VALUES (6, 'Clay Breshears');
INSERT INTO `library`.`Authors` (`authorId`, `name`) VALUES (7, 'Kevlin Henney');

COMMIT;

-- -----------------------------------------------------
-- Data for table `library`.`Books`
-- -----------------------------------------------------
START TRANSACTION;
USE `library`;
INSERT INTO `library`.`Books` (`bookId`, `title`, `year`, `genreId`) VALUES (1, '', NULL, NULL);

COMMIT;

-- -----------------------------------------------------
-- Data for table `library`.`Locations`
-- -----------------------------------------------------
START TRANSACTION;
USE `library`;
INSERT INTO `library`.`Locations` (`locationId`, `code`) VALUES (1, 'L1');
INSERT INTO `library`.`Locations` (`locationId`, `code`) VALUES (2, 'L2');
INSERT INTO `library`.`Locations` (`locationId`, `code`) VALUES (3, 'L3');
INSERT INTO `library`.`Locations` (`locationId`, `code`) VALUES (4, 'L4');

COMMIT;
