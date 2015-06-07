-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Client :  127.0.0.1
-- Généré le :  Dim 07 Juin 2015 à 20:28
-- Version du serveur :  5.6.17
-- Version de PHP :  5.5.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de données :  `dogeexplorer_dev`
--

-- --------------------------------------------------------

--
-- Structure de la table `artefacts`
--

CREATE TABLE IF NOT EXISTS `artefacts` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ref` varchar(255) NOT NULL,
  `planetID` int(11) NOT NULL,
  `rarity` int(11) NOT NULL,
  `facebookID` bigint(20) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ref` (`ref`),
  UNIQUE KEY `FacebookID` (`facebookID`),
  KEY `planetID` (`planetID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=56 ;

--
-- Contenu de la table `artefacts`
--

INSERT INTO `artefacts` (`ID`, `ref`, `planetID`, `rarity`, `facebookID`) VALUES
(38, 'Smartphone', 16, 1, 965436526822282),
(39, 'Boot', 16, 1, 1697360473825549),
(40, 'Pot', 16, 1, 1114090838608010),
(41, 'Dragon-Ball', 15, 1, 1018587388159080),
(42, 'Blaster', 18, 1, 1419846531672062),
(43, 'Saber', 18, 1, 1008605342490512),
(44, 'Helmet', 18, 1, 629502290483631),
(45, 'Cup', 17, 1, 1619119738302355),
(46, 'Potion', 17, 1, 1440535986251958),
(47, 'Hat', 17, 1, 1597297313857163),
(48, 'Armor', 15, 1, 1604447719812726),
(49, 'Kinto-un', 15, 1, 1579505662314572),
(50, 'Sting', 14, 1, 827350023985146),
(51, 'Precious', 14, 1, 751634398282728),
(52, 'Hair', 14, 1, 1077843055562367),
(53, 'Beer', 13, 1, 1446334055683188),
(54, 'Donut', 13, 1, 906211629440719),
(55, 'Skate', 13, 1, 701943576599156);

-- --------------------------------------------------------

--
-- Structure de la table `builded_buildings`
--

CREATE TABLE IF NOT EXISTS `builded_buildings` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `buildingID` int(11) NOT NULL,
  `playerFbID` bigint(11) NOT NULL,
  `buildingEnd` datetime NOT NULL,
  `col` int(11) NOT NULL,
  `row` int(11) NOT NULL,
  `isBuilded` tinyint(1) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `playerID` (`playerFbID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=14 ;

--
-- Contenu de la table `builded_buildings`
--

INSERT INTO `builded_buildings` (`ID`, `buildingID`, `playerFbID`, `buildingEnd`, `col`, `row`, `isBuilded`) VALUES
(1, 261, 818989511510138, '2015-06-07 18:38:00', 29, 35, 1),
(2, 257, 818989511510138, '2015-06-07 19:28:47', 36, 32, 1),
(3, 263, 818989511510138, '2015-06-07 19:28:21', 33, 34, 1),
(4, 257, 818989511510138, '2015-06-07 19:32:28', 30, 36, 1),
(5, 261, 818989511510138, '2015-06-07 19:31:57', 35, 35, 1),
(6, 263, 818989511510138, '2015-06-07 19:32:03', 36, 32, 1),
(7, 269, 818989511510138, '2015-06-07 19:32:59', 33, 37, 1),
(8, 257, 818989511510138, '2015-06-07 19:36:53', 36, 34, 1),
(9, 269, 818989511510138, '2015-06-07 19:37:40', 38, 31, 1),
(10, 258, 818989511510138, '2015-06-07 19:38:00', 40, 27, 1),
(13, 257, 818989511510138, '2015-06-07 20:27:11', 32, 36, 0);

-- --------------------------------------------------------

--
-- Structure de la table `builded_rockets`
--

CREATE TABLE IF NOT EXISTS `builded_rockets` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `playerFbID` bigint(11) NOT NULL,
  `rocketID` int(11) NOT NULL,
  `buildingEnd` datetime NOT NULL,
  `travelEnd` datetime NOT NULL,
  `isBuilded` tinyint(1) NOT NULL,
  `isOver` tinyint(1) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `playerID` (`playerFbID`,`rocketID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=28 ;

--
-- Contenu de la table `builded_rockets`
--

INSERT INTO `builded_rockets` (`ID`, `playerFbID`, `rocketID`, `buildingEnd`, `travelEnd`, `isBuilded`, `isOver`) VALUES
(2, 1, 19, '2015-05-31 15:57:33', '1899-11-30 00:00:00', 0, 0),
(3, 1, 20, '2015-05-31 17:14:48', '2015-05-31 17:49:41', 0, 0),
(5, 1, 21, '2015-06-02 19:47:05', '2015-06-02 20:18:09', 1, 0),
(6, 1, 21, '2015-06-02 20:33:41', '2015-06-02 21:00:09', 1, 0),
(7, 1, 21, '2015-06-02 20:52:03', '2015-06-02 21:02:14', 1, 1),
(8, 818989511510138, 19, '2015-06-07 14:35:48', '0000-00-00 00:00:00', 0, 0),
(9, 818989511510138, 19, '2015-06-07 15:30:45', '0000-00-00 00:00:00', 1, 0),
(10, 818989511510138, 19, '2015-06-07 15:47:32', '0000-00-00 00:00:00', 1, 0),
(11, 818989511510138, 19, '2015-06-07 15:50:16', '0000-00-00 00:00:00', 1, 0),
(12, 818989511510138, 19, '2015-06-07 15:51:57', '0000-00-00 00:00:00', 1, 0),
(13, 818989511510138, 19, '2015-06-07 15:58:06', '0000-00-00 00:00:00', 1, 0),
(14, 818989511510138, 19, '2015-06-07 15:59:11', '0000-00-00 00:00:00', 1, 0),
(17, 818989511510138, 19, '2015-06-07 16:42:40', '0000-00-00 00:00:00', 1, 0),
(18, 818989511510138, 19, '2015-06-07 16:43:03', '0000-00-00 00:00:00', 0, 0),
(19, 818989511510138, 19, '2015-06-07 16:46:50', '2015-06-07 16:47:02', 1, 0),
(21, 818989511510138, 19, '2015-06-07 17:06:04', '2015-06-07 17:06:08', 1, 1),
(22, 818989511510138, 19, '2015-06-07 17:10:08', '2015-06-07 17:10:12', 1, 1),
(23, 818989511510138, 19, '2015-06-07 17:12:13', '2015-06-07 17:13:12', 1, 0),
(24, 818989511510138, 19, '2015-06-07 17:18:23', '2015-06-07 17:19:20', 1, 1),
(25, 818989511510138, 19, '2015-06-07 17:21:46', '2015-06-07 17:22:45', 1, 1),
(26, 818989511510138, 19, '2015-06-07 17:26:38', '2015-06-07 17:27:37', 1, 1),
(27, 818989511510138, 19, '2015-06-07 19:33:40', '0000-00-00 00:00:00', 1, 0);

-- --------------------------------------------------------

--
-- Structure de la table `buildings`
--

CREATE TABLE IF NOT EXISTS `buildings` (
  `ID` int(11) NOT NULL,
  `ref` varchar(255) NOT NULL,
  `hardCost` int(11) NOT NULL,
  `softCost` int(11) NOT NULL,
  `dogeCost` int(11) NOT NULL,
  `buildingTime` int(11) NOT NULL,
  `ressource_cost_1` int(11) NOT NULL,
  `ressource_cost_2` int(11) NOT NULL,
  `ressource_cost_3` int(11) NOT NULL,
  `ressource_cost_4` int(11) NOT NULL,
  `ressource_cost_5` int(11) NOT NULL,
  `ressource_cost_6` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ref` (`ref`),
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `buildings`
--

INSERT INTO `buildings` (`ID`, `ref`, `hardCost`, `softCost`, `dogeCost`, `buildingTime`, `ressource_cost_1`, `ressource_cost_2`, `ressource_cost_3`, `ressource_cost_4`, `ressource_cost_5`, `ressource_cost_6`) VALUES
(257, 'CasinoLv1', 3, 1000, 0, 3600, 0, 0, 0, 0, 0, 0),
(258, 'EgliseLv1', 3, 1000, 0, 30, 0, 0, 0, 0, 0, 0),
(259, 'HangarBleuLv1', 3, 1000, 0, 30, 0, 0, 0, 0, 0, 0),
(260, 'HangarCyanLv1', 3, 1000, 0, 30, 0, 0, 0, 0, 0, 0),
(261, 'HangarJauneLv1', 3, 1000, 0, 30, 0, 0, 0, 0, 0, 0),
(262, 'HangarRougeLv1', 3, 1000, 0, 30, 0, 0, 0, 0, 0, 0),
(263, 'HangarVertLv1', 3, 1000, 0, 30, 0, 0, 0, 0, 0, 0),
(264, 'HangarVioletLv1', 3, 1000, 0, 30, 0, 0, 0, 0, 0, 0),
(265, 'LaboLv1', 3, 1000, 0, 30, 0, 0, 0, 0, 0, 0),
(266, 'NicheLv1', 3, 1000, 0, 30, 0, 0, 0, 0, 0, 0),
(267, 'PasdetirLv1', 3, 1000, 0, 5, 0, 0, 0, 0, 0, 0),
(268, 'EntrepotLv1', 3, 1000, 0, 30, 0, 0, 0, 0, 0, 0),
(269, 'MuseeLv1', 3, 1000, 0, 30, 0, 0, 0, 0, 0, 0),
(513, 'CasinoLv2', 3, 1000, 0, 60, 0, 0, 0, 0, 0, 0),
(514, 'EgliseLv2', 3, 1000, 0, 60, 0, 0, 0, 0, 0, 0),
(515, 'HangarBleuLv2', 3, 1000, 0, 60, 0, 0, 0, 0, 0, 0),
(516, 'HangarCyanLv2', 3, 1000, 0, 60, 0, 0, 0, 0, 0, 0),
(517, 'HangarJauneLv2', 3, 1000, 0, 60, 0, 0, 0, 0, 0, 0),
(518, 'HangarRougeLv2', 3, 1000, 0, 60, 0, 0, 0, 0, 0, 0),
(519, 'HangarVertLv2', 3, 1000, 0, 60, 0, 0, 0, 0, 0, 0),
(520, 'HangarVioletLv2', 3, 1000, 0, 60, 0, 0, 0, 0, 0, 0),
(521, 'LaboLv2', 3, 1000, 0, 60, 0, 0, 0, 0, 0, 0),
(522, 'NicheLv2', 3, 1000, 0, 60, 0, 0, 0, 0, 0, 0),
(523, 'PasdetirLv2', 3, 1000, 0, 60, 0, 0, 0, 0, 0, 0),
(524, 'EntrepotLv2', 3, 1000, 0, 60, 0, 0, 0, 0, 0, 0),
(525, 'MuseeLv2', 3, 1000, 0, 60, 0, 0, 0, 0, 0, 0),
(769, 'CasinoLv3', 3, 1000, 0, 90, 0, 0, 0, 0, 0, 0),
(770, 'EgliseLv3', 3, 1000, 0, 90, 0, 0, 0, 0, 0, 0),
(771, 'HangarBleuLv3', 3, 1000, 0, 90, 0, 0, 0, 0, 0, 0),
(772, 'HangarCyanLv3', 3, 1000, 0, 90, 0, 0, 0, 0, 0, 0),
(773, 'HangarJauneLv3', 3, 1000, 0, 90, 0, 0, 0, 0, 0, 0),
(774, 'HangarRougeLv3', 3, 1000, 0, 90, 0, 0, 0, 0, 0, 0),
(775, 'HangarVertLv3', 3, 1000, 0, 90, 0, 0, 0, 0, 0, 0),
(776, 'HangarVioletLv3', 3, 1000, 0, 90, 0, 0, 0, 0, 0, 0),
(777, 'LaboLv3', 3, 1000, 0, 90, 0, 0, 0, 0, 0, 0),
(778, 'NicheLv3', 3, 1000, 0, 90, 0, 0, 0, 0, 0, 0),
(779, 'PasdetirLv3', 3, 1000, 0, 90, 0, 0, 0, 0, 0, 0),
(780, 'EntrepotLv3', 3, 1000, 0, 90, 0, 0, 0, 0, 0, 0),
(781, 'MuseeLv3', 3, 1000, 0, 90, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `collected_artefacts`
--

CREATE TABLE IF NOT EXISTS `collected_artefacts` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `artefactID` int(11) NOT NULL,
  `playerFbID` bigint(11) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `artefactID` (`artefactID`,`playerFbID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=22 ;

--
-- Contenu de la table `collected_artefacts`
--

INSERT INTO `collected_artefacts` (`ID`, `artefactID`, `playerFbID`) VALUES
(4, 53, 1),
(7, 53, 818989511510138),
(10, 53, 818989511510138),
(13, 53, 818989511510138),
(16, 53, 818989511510138),
(19, 53, 818989511510138),
(5, 54, 818989511510138),
(8, 54, 818989511510138),
(11, 54, 818989511510138),
(14, 54, 818989511510138),
(17, 54, 818989511510138),
(20, 54, 818989511510138),
(6, 55, 818989511510138),
(9, 55, 818989511510138),
(12, 55, 818989511510138),
(15, 55, 818989511510138),
(18, 55, 818989511510138),
(21, 55, 818989511510138);

-- --------------------------------------------------------

--
-- Structure de la table `explored_planets`
--

CREATE TABLE IF NOT EXISTS `explored_planets` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `planetID` int(11) NOT NULL,
  `playerID` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `planetID` (`planetID`,`playerID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `means`
--

CREATE TABLE IF NOT EXISTS `means` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ref` varchar(255) NOT NULL,
  `ref_nb` int(11) NOT NULL,
  `softBuyValue` int(11) NOT NULL,
  `softSellValue` int(11) NOT NULL,
  `hardBuyValue` float NOT NULL,
  `discount` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ref` (`ref`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=28 ;

--
-- Contenu de la table `means`
--

INSERT INTO `means` (`ID`, `ref`, `ref_nb`, `softBuyValue`, `softSellValue`, `hardBuyValue`, `discount`) VALUES
(19, 'poudre0', 1, 10, 5, 0, 0),
(20, 'poudre1', 2, 25, 10, 0, 0),
(21, 'poudre2', 3, 50, 25, 0, 0),
(22, 'poudre3', 4, 100, 40, 0, 0),
(23, 'poudre4', 5, 300, 200, 0, 0),
(24, 'poudre5', 6, 1000, 700, 0, 0),
(25, 'fric', 7, 0, 0, 0.1, 0),
(26, 'hardMoney', 8, 0, 0, 0, 0),
(27, 'doges', 9, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `planets`
--

CREATE TABLE IF NOT EXISTS `planets` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ref` varchar(255) NOT NULL,
  `meansRewardMax` int(11) NOT NULL,
  `meansRewardMin` int(11) NOT NULL,
  `ressource_ratio_1` float NOT NULL,
  `ressource_ratio_2` float NOT NULL,
  `ressource_ratio_3` float NOT NULL,
  `ressource_ratio_4` float NOT NULL,
  `ressource_ratio_5` float NOT NULL,
  `ressource_ratio_6` float NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ref` (`ref`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=19 ;

--
-- Contenu de la table `planets`
--

INSERT INTO `planets` (`ID`, `ref`, `meansRewardMax`, `meansRewardMin`, `ressource_ratio_1`, `ressource_ratio_2`, `ressource_ratio_3`, `ressource_ratio_4`, `ressource_ratio_5`, `ressource_ratio_6`) VALUES
(13, 'SprungField', 1000, 500, 0.5, 0.25, 0.25, 0, 0, 0),
(14, 'Mordor', 1000, 500, 0.5, 0.25, 0.25, 0, 0, 0),
(15, 'Namok', 1000, 500, 0.5, 0.25, 0.25, 0, 0, 0),
(16, 'Terre', 1000, 500, 0.5, 0.25, 0.25, 0, 0, 0),
(17, 'Wunderland', 1000, 500, 0.5, 0.25, 0.25, 0, 0, 0),
(18, 'StarWat', 1000, 500, 0.5, 0.25, 0.25, 0, 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `players`
--

CREATE TABLE IF NOT EXISTS `players` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `facebookID` bigint(20) NOT NULL,
  `login` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `level` int(11) NOT NULL,
  `gameTime` time NOT NULL,
  `artefactsSeed` int(11) NOT NULL,
  `map` text NOT NULL,
  `hardCurrency` int(11) NOT NULL,
  `softCurrency` int(11) NOT NULL,
  `ressource_1` int(11) DEFAULT NULL,
  `ressource_2` int(11) DEFAULT NULL,
  `ressource_3` int(11) NOT NULL,
  `ressource_4` int(11) NOT NULL,
  `ressource_5` int(11) NOT NULL,
  `ressource_6` int(11) NOT NULL,
  `meansQttMax` int(11) NOT NULL,
  `population` int(11) NOT NULL,
  `populationMax` int(11) NOT NULL,
  `faithPercent` float NOT NULL,
  `lastTimeUpdated` timestamp NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `facebookID` (`facebookID`),
  KEY `login` (`login`),
  KEY `facebookID_2` (`facebookID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Contenu de la table `players`
--

INSERT INTO `players` (`ID`, `facebookID`, `login`, `email`, `level`, `gameTime`, `artefactsSeed`, `map`, `hardCurrency`, `softCurrency`, `ressource_1`, `ressource_2`, `ressource_3`, `ressource_4`, `ressource_5`, `ressource_6`, `meansQttMax`, `population`, `populationMax`, `faithPercent`, `lastTimeUpdated`) VALUES
(1, 818989511510138, 'Pif Le-Coquelicot', '', 42, '00:00:00', 0, '', 4, 36880, 14415, 999099, 999999, 999999, 999999, 999599, 999999, 90, 100, 0, '2015-06-07 18:26:26');

-- --------------------------------------------------------

--
-- Structure de la table `quests`
--

CREATE TABLE IF NOT EXISTS `quests` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `buildingID` int(11) NOT NULL,
  `nbOfBuildings` int(11) NOT NULL,
  `rocketsConstructedNb` int(11) NOT NULL,
  `rocketsLaunchedNb` int(11) NOT NULL,
  `fric` int(11) NOT NULL,
  `ressource_1` int(11) NOT NULL,
  `ressource_2` int(11) NOT NULL,
  `ressource_3` int(11) NOT NULL,
  `ressource_4` int(11) NOT NULL,
  `ressource_5` int(11) NOT NULL,
  `ressource_6` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

--
-- Contenu de la table `quests`
--

INSERT INTO `quests` (`ID`, `buildingID`, `nbOfBuildings`, `rocketsConstructedNb`, `rocketsLaunchedNb`, `fric`, `ressource_1`, `ressource_2`, `ressource_3`, `ressource_4`, `ressource_5`, `ressource_6`) VALUES
(1, 266, 1, 0, 0, 100, 10, 0, 0, 0, 0, 0),
(4, 261, 1, 0, 0, 100, 10, 0, 0, 0, 0, 0),
(5, 0, 0, 1, 0, 100, 10, 0, 0, 0, 0, 0),
(6, 0, 0, 0, 1, 100, 10, 0, 0, 0, 0, 0),
(7, 257, 1, 0, 0, 100, 10, 0, 0, 0, 0, 0),
(8, 269, 1, 0, 0, 100, 10, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `quests_finished`
--

CREATE TABLE IF NOT EXISTS `quests_finished` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `playerFbID` bigint(20) NOT NULL,
  `questID` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `playerFbID` (`playerFbID`,`questID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Contenu de la table `quests_finished`
--

INSERT INTO `quests_finished` (`ID`, `playerFbID`, `questID`) VALUES
(1, 818989511510138, 4),
(4, 818989511510138, 5),
(2, 818989511510138, 7),
(3, 818989511510138, 8);

-- --------------------------------------------------------

--
-- Structure de la table `rockets`
--

CREATE TABLE IF NOT EXISTS `rockets` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ref` varchar(100) NOT NULL,
  `destinationID` int(11) NOT NULL,
  `hardCost` int(11) NOT NULL,
  `softCost` int(11) NOT NULL,
  `dogeCost` int(11) NOT NULL,
  `clickTimeReward` float NOT NULL,
  `travelDuration` int(11) NOT NULL,
  `constructionDuration` int(11) NOT NULL,
  `ressource_cost_1` int(11) NOT NULL,
  `ressource_cost_2` int(11) NOT NULL,
  `ressource_cost_3` int(11) NOT NULL,
  `ressource_cost_4` int(11) NOT NULL,
  `ressource_cost_5` int(11) NOT NULL,
  `ressource_cost_6` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `destinationID` (`destinationID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=37 ;

--
-- Contenu de la table `rockets`
--

INSERT INTO `rockets` (`ID`, `ref`, `destinationID`, `hardCost`, `softCost`, `dogeCost`, `clickTimeReward`, `travelDuration`, `constructionDuration`, `ressource_cost_1`, `ressource_cost_2`, `ressource_cost_3`, `ressource_cost_4`, `ressource_cost_5`, `ressource_cost_6`) VALUES
(19, 'JauneLv1', 13, 0, 1000, 10, 0.1, 60, 10, 25, 0, 0, 0, 0, 0),
(20, 'JauneLv2', 13, 0, 1000, 10, 0, 600, 120, 25, 0, 0, 0, 0, 0),
(21, 'JauneLv3', 13, 0, 1000, 10, 0, 600, 60, 25, 0, 0, 0, 0, 0),
(22, 'VertLv1', 14, 0, 1000, 10, 0, 600, 60, 25, 0, 0, 0, 0, 0),
(23, 'VertLv2', 14, 0, 1000, 10, 0, 600, 60, 25, 0, 0, 0, 0, 0),
(24, 'VertLv3', 14, 0, 1000, 10, 0, 600, 60, 25, 0, 0, 0, 0, 0),
(25, 'CyanLv1', 15, 0, 1000, 10, 0, 600, 60, 25, 0, 0, 0, 0, 0),
(26, 'CyanLv2', 15, 0, 1000, 10, 0, 600, 60, 25, 0, 0, 0, 0, 0),
(27, 'CyanLv3', 15, 0, 1000, 10, 0, 600, 60, 25, 0, 0, 0, 0, 0),
(28, 'BleuLv1', 16, 0, 1000, 10, 0, 600, 60, 25, 0, 0, 0, 0, 0),
(29, 'BleuLv2', 16, 0, 1000, 10, 0, 600, 60, 25, 0, 0, 0, 0, 0),
(30, 'BleuLv3', 16, 0, 1000, 10, 0, 600, 60, 25, 0, 0, 0, 0, 0),
(31, 'VioletLv1', 17, 0, 1000, 10, 0, 600, 60, 25, 0, 0, 0, 0, 0),
(32, 'VioletLv2', 17, 0, 1000, 10, 0, 600, 60, 25, 0, 0, 0, 0, 0),
(33, 'VioletLv3', 17, 0, 1000, 10, 0, 600, 60, 25, 0, 0, 0, 0, 0),
(34, 'OrangeLv1', 18, 0, 1000, 10, 0, 600, 60, 25, 0, 0, 0, 0, 0),
(35, 'OrangeLv2', 18, 0, 1000, 10, 0, 600, 60, 25, 0, 0, 0, 0, 0),
(36, 'OrangeLv3', 18, 0, 1000, 10, 0, 600, 60, 25, 0, 0, 0, 0, 0);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
