SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';


-- -----------------------------------------------------
-- Schema game
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `game` DEFAULT CHARACTER SET utf8 ;
USE `game` ;

-- -----------------------------------------------------
-- Table `game`.`PLAYERS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `game`.`PLAYERS` (
  `PID` INT(5) NOT NULL AUTO_INCREMENT,
  `login` VARCHAR(30) NOT NULL,
  `password` VARCHAR(30) NOT NULL,
  `e-mail` VARCHAR(50) NOT NULL,
  `rating` INT(5) NOT NULL,
  PRIMARY KEY (`PID`),
  UNIQUE INDEX `login_UNIQUE` (`login` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `game`.`FACTIONS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `game`.`FACTIONS` (
  `FID` INT(1) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`FID`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `game`.`CARDS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `game`.`CARDS` (
  `CID` INT(5) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(150) NOT NULL,
  `cX` INT(3) NOT NULL,
  `HP` INT(3) NOT NULL,
  `DP` INT(3) NOT NULL,
  `AP` INT(2) NOT NULL,
  `FID` INT(1) NOT NULL,
  PRIMARY KEY (`CID`, `FID`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC),
  INDEX `cards_belong_to_factions_idx` (`FID` ASC),
  CONSTRAINT `cards_belong_to_factions`
    FOREIGN KEY (`FID`)
    REFERENCES `game`.`FACTIONS` (`FID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `game`.`PLAYERS_HAVE_CARDS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `game`.`PLAYERS_HAVE_CARDS` (
  `PID` INT(5) NOT NULL,
  `CID` INT(5) NOT NULL,
  `num` INT(1) NOT NULL,
  INDEX `fk_players_have_cards_cards1_idx` (`CID` ASC),
  INDEX `fk_players_have_cards_players1_idx` (`PID` ASC),
  CONSTRAINT `fk_players_have_cards_players1`
    FOREIGN KEY (`PID`)
    REFERENCES `game`.`PLAYERS` (`PID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_players_have_cards_cards1`
    FOREIGN KEY (`CID`)
    REFERENCES `game`.`CARDS` (`CID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `game`.`DECKS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `game`.`DECKS` (
  `DID` INT(5) NOT NULL AUTO_INCREMENT,
  `FID` INT(1) NOT NULL,
  PRIMARY KEY (`DID`, `FID`),
  INDEX `deck_belongs_to_faction_idx` (`FID` ASC),
  CONSTRAINT `deck_belongs_to_faction`
    FOREIGN KEY (`FID`)
    REFERENCES `game`.`FACTIONS` (`FID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `game`.`PLAYERS_HAVE_DECKS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `game`.`PLAYERS_HAVE_DECKS` (
  `PID` INT(5) NOT NULL,
  `DID` INT(5) NOT NULL,
  `name` VARCHAR(30) NULL,
  INDEX `fk_players_have_decks_decks1_idx` (`DID` ASC),
  INDEX `fk_players_have_decks_players1_idx` (`PID` ASC),
  PRIMARY KEY (`PID`, `DID`),
  CONSTRAINT `fk_players_have_decks_players1`
    FOREIGN KEY (`PID`)
    REFERENCES `game`.`PLAYERS` (`PID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_players_have_decks_decks1`
    FOREIGN KEY (`DID`)
    REFERENCES `game`.`DECKS` (`DID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `game`.`DECKS_HAVE_CARDS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `game`.`DECKS_HAVE_CARDS` (
  `DID` INT(5) NOT NULL,
  `CID` INT(5) NOT NULL,
  `num` INT(1) NOT NULL,
  INDEX `fk_decks_have_cards_cards1_idx` (`CID` ASC),
  INDEX `fk_decks_have_cards_decks1_idx` (`DID` ASC),
  CONSTRAINT `fk_decks_have_cards_decks1`
    FOREIGN KEY (`DID`)
    REFERENCES `game`.`DECKS` (`DID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_decks_have_cards_cards1`
    FOREIGN KEY (`CID`)
    REFERENCES `game`.`CARDS` (`CID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `game`.`BASES`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `game`.`BASES` (
  `BID` INT(1) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(300) NOT NULL,
  `FID` INT(1) NOT NULL,
  PRIMARY KEY (`BID`, `FID`),
  INDEX `fk_bases_factions1_idx` (`FID` ASC),
  CONSTRAINT `fk_bases_factions1`
    FOREIGN KEY (`FID`)
    REFERENCES `game`.`FACTIONS` (`FID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;




-- -----------------------------------------------------
-- Inserting initial information into the database
-- -----------------------------------------------------
INSERT INTO FACTIONS VALUES (1, 'Warriors'),
                            (2, 'Scientists'),
                            (3, 'Artists');

INSERT INTO BASES VALUES (1, 'The Castle', 'Base of Warriors', 1),
                         (2, 'The Lab', 'Base of Scientists', 2),
                         (3, 'The Cathedral', 'Base of Artists', 3);

INSERT INTO CARDS VALUES (1, 'Admiral Nelson', '', 0, 2, 1, 1, 1),
                         (2, 'Alexander the Great', '', 1, 2, 1, 1, 1),
                         (3, 'Attila the Hun', '', 2, 2, 1, 1, 1),
                         (4, 'Bruce Lee', '', 3, 2, 1, 1, 1),
                         (5, 'Julius Caesar', '', 4, 3, 2, 2, 1),
                         (6, 'Tsar Cannon', '', 5, 3, 2, 2, 1),
                         (7, "Shaquille O''Neal", '', 6, 3, 2, 2, 1),
                         (8, 'Napoleon Bonaparte', '', 7, 3, 2, 2, 1),
                         (9, 'Muhammad Ali', '', 8, 4, 3, 3, 1),
                         (10, 'Mao Zedong', '', 9, 4, 3, 3, 1),
                         (11, 'John Cena', '', 10, 4, 3, 3, 1),
                         (12, 'Jeanne d\'\'Arc', '', 11, 4, 3, 3, 1),
                         (13, 'Gennady Golovkin', '', 12, 5, 4, 4, 1),
                         (14, 'Dalai Lama', '', 13, 5, 4, 4, 1),
                         (15, 'Card #15', '', 14, 5, 4, 4, 1),
                         (16, 'Card #16', '', 15, 5, 4, 4, 1),
                         (17, 'Card #17', '', 16, 6, 5, 5, 1),
                         (18, 'Card #18', '', 17, 6, 5, 5, 1),
                         (19, 'Card #19', '', 18, 6, 5, 5, 1),
                         (20, 'Card #20', '', 19, 6, 5, 5, 1),
                         (21, 'Neil deGrasse Tyson', '', 20, 2, 1, 1, 2),
                         (22, 'Alan Turing', '', 21, 2, 1, 1, 2),
                         (23, 'Nikola Tesla', '', 22, 2, 1, 1, 2),
                         (24, 'Robert Oppenheimer', '', 23, 2, 1, 1, 2),
                         (25, 'Georg Simon Ohm', '', 24, 3, 2, 2, 2),
                         (26, 'Alfred Nobel', '', 25, 3, 2, 2, 2),
                         (27, 'Sir Isaac Newton', '', 26, 3, 2, 2, 2),
                         (28, 'Karl Marx', '', 27, 3, 2, 2, 2),
                         (29, 'Werner Heisenberg', '', 28, 4, 3, 3, 2),
                         (30, 'Alexander Fleming', '', 29, 4, 3, 3, 2),
                         (31, 'Michael Faraday', '', 30, 4, 3, 3, 2),
                         (32, 'Albert Einstein', '', 31, 4, 3, 3, 2),
                         (33, 'Charles Darwin', '', 32, 5, 4, 4, 2),
                         (34, 'Marie Curie', '', 33, 5, 4, 4, 2),
                         (35, 'George Boole', '', 34, 5, 4, 4, 2),
                         (36, 'Archimedes', '', 35, 5, 4, 4, 2),
                         (37, 'Card #37', '', 36, 6, 5, 5, 2),
                         (38, 'Card #38', '', 37, 6, 5, 5, 2),
                         (39, 'Card #39', '', 38, 6, 5, 5, 2),
                         (40, 'Card #40', '', 39, 6, 5, 5, 2),
                         (41, 'Emma Watson', '', 40, 2, 1, 1, 3),
                         (42, 'Andy Warhol', '', 41, 2, 1, 1, 3),
                         (43, 'Vincent van Gogh', '', 42, 2, 1, 1, 3),
                         (44, 'Quentin Tarantino', '', 43, 2, 1, 1, 3),
                         (45, 'Stan Lee', '', 44, 3, 2, 2, 3),
                         (46, 'William Shakespeare', '', 45, 3, 2, 2, 3),
                         (47, 'Mozart', '', 46, 3, 2, 2, 3),
                         (48, 'Metallica', '', 47, 3, 2, 2, 3),
                         (49, 'George Martin', '', 48, 4, 3, 3, 3),
                         (50, 'Kazimir Malevich', '', 49, 4, 3, 3, 3),
                         (51, 'Brothers Grimm', '', 50, 4, 3, 3, 3),
                         (52, 'Salvador Dali', '', 51, 5, 4, 4, 3),
                         (53, 'The Beatles', '', 52, 5, 4, 4, 3),
                         (54, 'Michael Bay', '', 53, 5, 4, 4, 3),
                         (55, 'Hans Andersen', '', 54, 5, 4, 4, 3),
                         (56, 'Alan Moore', '', 55, 5, 4, 4, 3),
                         (57, 'AC/DC', '', 56, 6, 5, 5, 3),
                         (58, 'Card #58', '', 57, 6, 5, 5, 3),
                         (59, 'Card #59', '', 58, 6, 5, 5, 3),
                         (60, 'Card #60', '', 59, 6, 5, 5, 3);

INSERT INTO DECKS VALUES (1, 1),
                         (2, 2),
                         (3, 3);

INSERT INTO DECKS_HAVE_CARDS VALUES (1, 1, 2),
                                    (1, 2, 2),
                                    (1, 3, 2),
                                    (1, 4, 2),
                                    (1, 5, 2),
                                    (1, 6, 2),
                                    (1, 7, 2),
                                    (1, 8, 2),
                                    (1, 9, 2),
                                    (1, 10, 2),
                                    (1, 11, 2),
                                    (1, 12, 2),
                                    (1, 13, 2),
                                    (1, 14, 2),
                                    (1, 15, 2),
                                    (2, 21, 2),
                                    (2, 22, 2),
                                    (2, 23, 2),
                                    (2, 24, 2),
                                    (2, 25, 2),
                                    (2, 26, 2),
                                    (2, 27, 2),
                                    (2, 28, 2),
                                    (2, 29, 2),
                                    (2, 30, 2),
                                    (2, 31, 2),
                                    (2, 32, 2),
                                    (2, 33, 2),
                                    (2, 34, 2),
                                    (2, 35, 2),
                                    (3, 41, 2),
                                    (3, 42, 2),
                                    (3, 43, 2),
                                    (3, 44, 2),
                                    (3, 45, 2),
                                    (3, 46, 2),
                                    (3, 47, 2),
                                    (3, 48, 2),
                                    (3, 49, 2),
                                    (3, 50, 2),
                                    (3, 51, 2),
                                    (3, 52, 2),
                                    (3, 53, 2),
                                    (3, 54, 2),
                                    (3, 55, 2);