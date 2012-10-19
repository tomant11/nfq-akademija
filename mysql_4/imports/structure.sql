SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `catalog` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `catalog` ;

-- -----------------------------------------------------
-- Table `catalog`.`group`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `catalog`.`group` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `title` VARCHAR(255) NULL ,
  `created_at` VARCHAR(255) NULL ,
  `updated_at` VARCHAR(255) NULL ,
  PRIMARY KEY (`id`) )
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `catalog`.`manufacturer`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `catalog`.`manufacturer` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `title` VARCHAR(255) NULL ,
  `slug` VARCHAR(255) NULL ,
  `created_at` VARCHAR(255) NULL ,
  `updated_at` VARCHAR(255) NULL ,
  PRIMARY KEY (`id`) )
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `catalog`.`product`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `catalog`.`product` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `group_id` INT NULL ,
  `manufacturer_id` INT NULL ,
  `title` VARCHAR(255) NULL ,
  `description` TEXT NULL ,
  `price` DECIMAL(10,2) NULL ,
  `stock` INT NULL ,
  `image` VARCHAR(255) NULL ,
  `created_at` VARCHAR(255) NULL ,
  `updated_at` VARCHAR(255) NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `group_id_idx` (`group_id` ASC) ,
  INDEX `manufacturer_id_idx` (`manufacturer_id` ASC) )
ENGINE = MyISAM;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
