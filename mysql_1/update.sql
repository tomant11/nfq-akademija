ALTER TABLE `library`.`Authors` CHANGE COLUMN `name` `name` VARCHAR(255) NOT NULL;
ALTER TABLE `library`.`Books` CHARACTER SET = utf8 , COLLATE = utf8_general_ci , ENGINE = MyISAM , DROP COLUMN `authorId` , CHANGE COLUMN `title` `title` VARCHAR(255) NOT NULL  , ADD COLUMN `genreId` INT(11) NULL DEFAULT NULL  AFTER `year`;
 

CREATE  TABLE IF NOT EXISTS `library`.`Genres` (
  `genreId` INT(11) NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NULL DEFAULT NULL ,
  PRIMARY KEY (`genreId`) )
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


CREATE  TABLE IF NOT EXISTS `library`.`BookAuthor` (
  `bookId` INT(11) NOT NULL ,
  `authorId` INT(11) NOT NULL ,
  PRIMARY KEY (`bookId`) ,
  INDEX `bookId_idx` (`bookId` ASC) ,
  INDEX `authorId_idx` (`authorId` ASC) )
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `library`.`Locations` (
  `locationId` INT(11) NOT NULL AUTO_INCREMENT ,
  `code` VARCHAR(45) NULL DEFAULT NULL ,
  PRIMARY KEY (`locationId`) )
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `library`.`Copies` (
  `copyId` INT(11) NOT NULL AUTO_INCREMENT ,
  `bookId` INT(11) NOT NULL ,
  `locationId` INT(11) NOT NULL ,
  PRIMARY KEY (`copyId`) ,
  INDEX `bookId_idx` (`bookId` ASC) ,
  INDEX `locationId_idx` (`locationId` ASC) )
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;
