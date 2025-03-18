SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = '+01:00';

DROP DATABASE IF EXISTS orp_main;
CREATE DATABASE orp_main;
USE orp_main;

CREATE TABLE `accounts` (
  `id` int(22) NOT NULL,
  `username` varchar(250) NOT NULL,
  `password` varchar(250) NOT NULL,
  `serial` varchar(32) NOT NULL,
  `email` varchar(50) NOT NULL,
  `ip` varchar(22) NOT NULL,
  `admin` int(11) NOT NULL DEFAULT 0,
  `adminnick` varchar(50) NOT NULL DEFAULT 'Nevtelen admin',
  `verified` int(11) NOT NULL DEFAULT 1,
  `registerDate` varchar(255) NOT NULL DEFAULT '0000.00.00',
  `oldMethod` varchar(500) NOT NULL,
  `passwordForceChange` enum('Y','N','','') NOT NULL DEFAULT 'N',
  `emailForceChange` enum('Y','N','','') NOT NULL DEFAULT 'N',
  `suspended` enum('Y','N') NOT NULL DEFAULT 'N',
  `lastSerialChange` int(11) NOT NULL,
  `lastSerialChangeStatus` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE `actionbaritems` (
  `itemdbid` int(11) NOT NULL,
  `item` int(11) NOT NULL,
  `owner` int(11) NOT NULL,
  `category` varchar(11) NOT NULL,
  `actionslot` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE `adminserials` (
  `id` int(11) NOT NULL,
  `serial` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `atms` (
  `id` int(255) NOT NULL,
  `posX` float NOT NULL,
  `posY` float NOT NULL,
  `posZ` float NOT NULL,
  `rot` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `bank_accounts` (
  `id` int(255) NOT NULL,
  `owner` int(255) NOT NULL,
  `bankNumber` varchar(22) NOT NULL DEFAULT '',
  `money` int(255) NOT NULL DEFAULT 0,
  `transactions` varchar(5000) NOT NULL DEFAULT '[ [ ] ]',
  `transfers` varchar(5000) NOT NULL DEFAULT '[ [ ] ]',
  `isMain` int(1) NOT NULL,
  `pin` int(4) NOT NULL DEFAULT 1234
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `bans` (
  `id` int(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `user_id` int(11) NOT NULL,
  `serial` varchar(255) NOT NULL,
  `admin` varchar(255) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `ban_date` varchar(500) NOT NULL,
  `end_date` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `bans2` (
  `banId` int(11) NOT NULL,
  `playerSerial` varchar(512) NOT NULL DEFAULT '0',
  `playerName` varchar(48) NOT NULL,
  `playerAccountId` int(11) NOT NULL,
  `banReason` text NOT NULL,
  `adminName` varchar(48) NOT NULL,
  `banTimestamp` bigint(22) NOT NULL,
  `expireTimestamp` bigint(22) NOT NULL,
  `isActive` enum('Y','N') NOT NULL DEFAULT 'Y'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `bins` (
  `id` int(11) NOT NULL,
  `pos` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE `blockedserials` (
  `id` int(11) NOT NULL,
  `serial` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `bugreports` (
  `id` int(11) NOT NULL,
  `playerDatas` varchar(500) NOT NULL DEFAULT '[[]]',
  `bugDatas` varchar(1000) NOT NULL DEFAULT '[[]]',
  `reportDate` varchar(255) NOT NULL DEFAULT '0000.00.00 00:00:00',
  `state` varchar(100) NOT NULL DEFAULT 'wait_dev'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `characters` (
  `id` int(22) NOT NULL,
  `charname` varchar(50) NOT NULL,
  `account` int(22) NOT NULL,
  `money` int(50) NOT NULL DEFAULT 3500,
  `pp` int(11) NOT NULL DEFAULT 0,
  `health` int(5) NOT NULL DEFAULT 100,
  `armor` int(5) NOT NULL DEFAULT 100,
  `hunger` int(5) NOT NULL DEFAULT 100,
  `thirst` int(5) NOT NULL DEFAULT 100,
  `alcoholLevel` int(11) NOT NULL DEFAULT 0,
  `drowsiness` int(5) NOT NULL DEFAULT 100,
  `height` int(5) NOT NULL,
  `weight` int(5) NOT NULL,
  `age` int(5) NOT NULL,
  `gender` int(5) NOT NULL,
  `skin` int(5) NOT NULL,
  `walk` int(5) NOT NULL DEFAULT 0,
  `fight` int(5) NOT NULL DEFAULT 4,
  `timespent` varchar(255) NOT NULL DEFAULT '[[ 0, 0 ]]',
  `posx` double NOT NULL DEFAULT 1682.9976806641,
  `posy` double NOT NULL DEFAULT -2329.0939941406,
  `posz` double NOT NULL DEFAULT 13.546875,
  `rot` double NOT NULL DEFAULT 0,
  `interior` int(11) NOT NULL DEFAULT 0,
  `dimension` int(11) NOT NULL DEFAULT 0,
  `adminJailDatas` varchar(1000) NOT NULL DEFAULT '[ [ false, "nan", 0, "nan" ] ]',
  `favouriteFreetimeActiviti` int(11) NOT NULL DEFAULT 1,
  `borncity` varchar(255) NOT NULL DEFAULT 'Los_Santos',
  `avatar` int(11) NOT NULL DEFAULT 1,
  `job` int(10) NOT NULL DEFAULT 0,
  `vehicleSlot` int(255) NOT NULL DEFAULT 3,
  `interiorSlot` int(255) NOT NULL DEFAULT 5,
  `casinoCoin` int(255) NOT NULL DEFAULT 0,
  `bones` varchar(255) NOT NULL DEFAULT '[ { "l_arm": 0, "head": 0, "r_leg": 0, "r_arm": 0, "l_leg": 0, "body": 0 } ]',
  `radioStation` int(255) NOT NULL DEFAULT 0,
  `adutyTime` int(255) NOT NULL DEFAULT 0,
  `adminOnlineTime` int(255) NOT NULL DEFAULT 0,
  `adminDatas` varchar(500) NOT NULL DEFAULT '[[0, 0, 0, 0, 0, 0, 0, 0]]',
  `pdJailDatas` varchar(500) NOT NULL DEFAULT '[ [ [ ], 0, false ] ]',
  `banKickJailCounts` varchar(255) NOT NULL DEFAULT '[[0, 0, 0]]',
  `minToPayDay` int(3) NOT NULL DEFAULT 60,
  `kresz` int(1) NOT NULL DEFAULT 0,
  `basic` int(1) NOT NULL DEFAULT 0,
  `weaponStats` varchar(500) NOT NULL DEFAULT '[[]]',
  `drugDealerXP` varchar(255) NOT NULL DEFAULT '[[0, 0]]',
  `styles` varchar(255) NOT NULL DEFAULT '[[1, 1]]',
  `talkAnimation` int(2) NOT NULL DEFAULT 1,
  `buytime` text NOT NULL DEFAULT '[ { "plastic": { "time": 0 }, "tree": { "time": 0 }, "iron": { "time": 0 } } ]',
  `fishingEvent` int(255) NOT NULL DEFAULT 0,
  `complementarys` varchar(5000) NOT NULL DEFAULT '[[]]',
  `complementaryslot` int(255) NOT NULL DEFAULT 2,
  `isPaintHead` int(11) NOT NULL DEFAULT 0,
  `mainFaction` int(11) NOT NULL DEFAULT 0,
  `sickLevel` int(11) NOT NULL DEFAULT 0,
  `dailyFreeBoxDatas` varchar(255) NOT NULL DEFAULT '[[0, 0]]',
  `specialBoxData` varchar(255) NOT NULL DEFAULT '0',
  `petCount` int(255) NOT NULL DEFAULT 1,
  `charDescp` varchar(806) NOT NULL,
  `craneJobXP` varchar(255) NOT NULL DEFAULT '[[0, 0]]'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE `craftingtabels` (
  `id` int(11) NOT NULL,
  `pos` varchar(255) NOT NULL,
  `items` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `elevators` (
  `id` int(255) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `tpx` float NOT NULL,
  `tpy` float NOT NULL,
  `tpz` float NOT NULL,
  `dimensionwithin` int(255) NOT NULL,
  `interiorwithin` int(255) NOT NULL,
  `dimension` int(255) NOT NULL,
  `interior` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `factions` (
  `id` int(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `type` int(255) NOT NULL,
  `money` int(255) NOT NULL DEFAULT 0,
  `ranks` varchar(3000) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT 'false',
  `vehicles` varchar(255) NOT NULL DEFAULT 'false',
  `members` varchar(7000) NOT NULL COMMENT 'CharId,rand,leader,név,utolsobejelentkezes,jelenlegonline,szolgido,dutyskin	',
  `dutys` varchar(3000) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '[ [ ] ]',
  `allowedDutyItems` varchar(255) NOT NULL,
  `allowedDutySkins` varchar(255) NOT NULL,
  `editDate` text NOT NULL,
  `dutyPos` varchar(500) NOT NULL DEFAULT '[ [ ] ]',
  `description` varchar(220) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT 'Alapertelmezett leiras'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE `fuelstations` (
  `id` int(255) NOT NULL,
  `pedDatas` varchar(255) NOT NULL,
  `fuelPumps` varchar(5000) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `gates` (
  `id` int(255) NOT NULL,
  `modelID` int(4) NOT NULL,
  `closePos` varchar(400) NOT NULL,
  `openPos` varchar(400) NOT NULL,
  `interior` int(10) NOT NULL DEFAULT 0,
  `dimension` int(10) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `interiors` (
  `id` int(11) NOT NULL,
  `x` float DEFAULT NULL,
  `y` float DEFAULT NULL,
  `z` float DEFAULT NULL,
  `interiorx` float DEFAULT NULL,
  `interiory` float DEFAULT NULL,
  `interiorz` float DEFAULT NULL,
  `name` varchar(200) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `cost` int(11) DEFAULT 0,
  `type` int(11) DEFAULT NULL,
  `interior` int(11) DEFAULT NULL,
  `interiorwithin` int(11) DEFAULT NULL,
  `dimensionwithin` int(11) DEFAULT NULL,
  `owner` int(11) DEFAULT 0,
  `custom` int(11) DEFAULT 0,
  `locked` int(11) DEFAULT 0,
  `interiorID` int(255) NOT NULL,
  `renewalTime` int(255) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE `interior_datas` (
  `interiorId` int(255) NOT NULL,
  `paidCash` int(255) NOT NULL,
  `interiorData` mediumtext NOT NULL,
  `dynamicData` varchar(5000) NOT NULL,
  `unlockedPP` varchar(5000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `interior_objects` (
  `id` int(11) NOT NULL,
  `interiordbid` int(11) DEFAULT 0,
  `x` float DEFAULT NULL,
  `y` float DEFAULT NULL,
  `z` float DEFAULT NULL,
  `rx` int(11) DEFAULT NULL,
  `ry` int(11) DEFAULT NULL,
  `rz` int(11) DEFAULT NULL,
  `interior` int(11) DEFAULT NULL,
  `dimension` int(11) DEFAULT NULL,
  `texture` varchar(200) DEFAULT NULL,
  `texID` int(11) DEFAULT NULL,
  `model` int(11) DEFAULT NULL,
  `type` varchar(200) DEFAULT NULL,
  `isdefault` varchar(200) DEFAULT NULL,
  `defaultdoor` varchar(200) DEFAULT NULL,
  `folder1` varchar(200) DEFAULT NULL,
  `folder2` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE `items` (
  `id` int(11) NOT NULL,
  `owner` int(11) NOT NULL,
  `itemid` int(11) NOT NULL,
  `value` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `slot` int(11) NOT NULL,
  `amount` int(11) NOT NULL DEFAULT 0,
  `count` int(255) NOT NULL,
  `type` text NOT NULL,
  `dutyitem` int(1) NOT NULL,
  `itemState` int(1) NOT NULL,
  `name` text NOT NULL,
  `weaponserial` varchar(255) NOT NULL,
  `pp` int(11) DEFAULT 0,
  `warn` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE `logpp` (
  `id` int(255) NOT NULL,
  `date` date NOT NULL,
  `tel` varchar(255) NOT NULL,
  `text` varchar(255) NOT NULL,
  `provider` varchar(255) NOT NULL,
  `sms_id` int(255) NOT NULL,
  `tarifa` int(255) NOT NULL,
  `newpp` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `lottery` (
  `id` int(11) NOT NULL,
  `num1` int(2) NOT NULL,
  `num2` int(2) NOT NULL,
  `num3` int(2) NOT NULL,
  `num4` int(2) NOT NULL,
  `num5` int(2) NOT NULL,
  `winnercode` int(10) NOT NULL,
  `created` timestamp(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `mdcaccounts` (
  `id` int(11) NOT NULL,
  `user` varchar(255) NOT NULL,
  `pass` varchar(255) NOT NULL,
  `faction` varchar(2) NOT NULL,
  `type` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `mdclogs` (
  `id` int(11) NOT NULL,
  `reason` varchar(500) NOT NULL,
  `other` varchar(500) NOT NULL,
  `owner` varchar(500) NOT NULL,
  `time` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `mdcpenalties` (
  `id` int(255) NOT NULL,
  `title` varchar(50) NOT NULL,
  `description` varchar(255) NOT NULL,
  `price` int(10) NOT NULL,
  `faction` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `mdcwantedcars` (
  `id` int(255) NOT NULL,
  `numberPlate` varchar(255) NOT NULL,
  `modelName` varchar(255) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `color` varchar(255) NOT NULL,
  `date` varchar(255) NOT NULL,
  `lastUpdateUser` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `mdcwantedpersons` (
  `id` int(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `date` varchar(255) NOT NULL,
  `lastUpdateUser` varchar(255) NOT NULL,
  `skin` int(255) NOT NULL,
  `isMostDanger` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `pendingpps` (
  `id` int(255) NOT NULL,
  `charid` int(11) NOT NULL,
  `pp` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `pets` (
  `id` int(255) NOT NULL,
  `owner` int(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `type` int(255) NOT NULL,
  `health` int(255) NOT NULL DEFAULT 100,
  `hunger` int(255) NOT NULL DEFAULT 100,
  `thirsty` int(255) NOT NULL DEFAULT 100,
  `bestFood` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `phonemessages` (
  `id` int(255) NOT NULL,
  `senderPhone` int(255) NOT NULL,
  `recievedPhone` int(255) NOT NULL,
  `messageData` varchar(5000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `plants` (
  `id` int(11) NOT NULL,
  `container` int(11) NOT NULL,
  `plotid` int(11) NOT NULL,
  `grow` float NOT NULL,
  `type` int(11) NOT NULL,
  `state` int(11) NOT NULL DEFAULT 100,
  `dirtType` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `plants_containers` (
  `id` int(11) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `dimensionwithin` int(11) NOT NULL,
  `interiorwithin` int(11) NOT NULL,
  `rotx` float NOT NULL,
  `roty` float NOT NULL,
  `rotz` float NOT NULL,
  `model` int(11) NOT NULL,
  `owner` int(11) NOT NULL,
  `ownerType` int(11) NOT NULL,
  `locked` int(11) NOT NULL,
  `renttime` int(11) NOT NULL,
  `gateisopen` int(11) NOT NULL,
  `fan1` int(11) NOT NULL,
  `fan2` int(11) NOT NULL,
  `fan3` int(11) NOT NULL,
  `fan4` int(11) NOT NULL,
  `fan5` int(11) NOT NULL,
  `fan6` int(11) NOT NULL,
  `fan7` int(11) NOT NULL,
  `waterlevel` int(11) NOT NULL,
  `permissions` varchar(1000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `plants_orders` (
  `id` int(11) NOT NULL,
  `owner` int(255) NOT NULL,
  `orderer` varchar(255) NOT NULL,
  `neededItem` int(20) NOT NULL,
  `itemCount` int(20) NOT NULL,
  `price` int(255) NOT NULL,
  `remainingTime` int(255) NOT NULL,
  `allTime` int(255) NOT NULL,
  `isActive` int(2) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `pots` (
  `id` int(255) NOT NULL,
  `pos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`pos`)),
  `plant` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`plant`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `printers` (
  `id` int(255) NOT NULL,
  `pos` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `roulettes` (
  `id` int(255) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `rz` int(11) NOT NULL,
  `interior` int(11) NOT NULL,
  `dimension` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `serial_change` (
  `username` text NOT NULL,
  `serial` text NOT NULL,
  `newSerial` text NOT NULL,
  `reason` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `shops` (
  `id` int(255) NOT NULL,
  `pos` varchar(255) NOT NULL,
  `items` varchar(255) NOT NULL,
  `name` text NOT NULL,
  `skin` int(2) NOT NULL,
  `private` int(11) NOT NULL DEFAULT 0,
  `cost` int(11) NOT NULL DEFAULT 0,
  `money` int(11) NOT NULL DEFAULT 0,
  `owner` int(11) NOT NULL DEFAULT 0,
  `orders` varchar(500) NOT NULL DEFAULT '[[]]',
  `deliveryArea` varchar(500) NOT NULL DEFAULT '[[]]'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE `szefek` (
  `id` int(255) NOT NULL,
  `pos` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE `teslachargers` (
  `id` int(255) NOT NULL,
  `pos` varchar(500) NOT NULL COMMENT '	[[x, y, z, rotX, rotY, rotZ, dim, int]]',
  `hasBlip` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `trafficboards` (
  `id` int(255) NOT NULL,
  `pos` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `usedcarshops` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `members` text NOT NULL,
  `bank` int(11) NOT NULL DEFAULT 0,
  `markers` text NOT NULL,
  `position` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `vehicles` (
  `id` int(11) NOT NULL,
  `owner` int(11) NOT NULL,
  `model` int(5) NOT NULL,
  `health` int(5) NOT NULL DEFAULT 1000,
  `position` varchar(100) NOT NULL,
  `rotation` varchar(100) NOT NULL DEFAULT '[ [ 0, 0, 0 ] ]',
  `dim` int(11) DEFAULT 0,
  `interior` int(11) NOT NULL DEFAULT 0,
  `color` varchar(255) NOT NULL,
  `lightColor` varchar(255) NOT NULL DEFAULT '[[255, 255, 255]]',
  `plateText` varchar(8) NOT NULL,
  `isFactionVehicle` int(1) DEFAULT 0,
  `isProtected` int(1) NOT NULL DEFAULT 0,
  `engineTunings` varchar(500) NOT NULL DEFAULT '[[ ]]',
  `fuel` int(4) NOT NULL DEFAULT 100,
  `fuelType` varchar(10) NOT NULL,
  `traveledDistance` int(255) NOT NULL DEFAULT 0,
  `paintjobID` int(3) NOT NULL DEFAULT 0,
  `opticTunings` varchar(255) NOT NULL DEFAULT '[[]]',
  `neon` int(2) NOT NULL DEFAULT 0,
  `airride` int(1) NOT NULL DEFAULT 0,
  `isBooked` tinyint(1) NOT NULL,
  `variant` varchar(255) NOT NULL DEFAULT '[[0, 0]]',
  `customPaintjob` varchar(5000) NOT NULL DEFAULT '[[]]',
  `horn` int(255) NOT NULL DEFAULT 0,
  `supercharger` tinyint(1) NOT NULL DEFAULT 0,
  `carshop` varchar(2500) NOT NULL DEFAULT '[false]',
  `handbrake` int(1) NOT NULL DEFAULT 0,
  `oilChange` int(255) NOT NULL DEFAULT 15000,
  `battery` int(11) NOT NULL DEFAULT 100,
  `wheelType` enum('S','W') NOT NULL DEFAULT 'S'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE `vendingmachines` (
  `dbId` int(255) NOT NULL,
  `objID` int(255) NOT NULL,
  `position` varchar(255) NOT NULL,
  `dimension` int(255) NOT NULL,
  `interior` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `verifedplayers` (
  `id` int(11) NOT NULL,
  `serial` varchar(255) NOT NULL,
  `playerName` varchar(255) NOT NULL,
  `discordName` varchar(255) NOT NULL,
  `adminName` varchar(255) NOT NULL,
  `date` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `worlditems` (
  `id` int(11) NOT NULL,
  `position` varchar(255) NOT NULL DEFAULT '[[]]' COMMENT 'X,Y,Z,RX,RY,RZ,INT,DIM	',
  `owner` int(11) NOT NULL DEFAULT 0,
  `ownerName` varchar(255) NOT NULL DEFAULT 'None',
  `objectId` int(11) NOT NULL DEFAULT 1343,
  `itemId` int(11) NOT NULL DEFAULT 1,
  `itemValue` varchar(255) NOT NULL DEFAULT '1',
  `itemCount` int(11) NOT NULL DEFAULT 1,
  `itemState` int(1) NOT NULL DEFAULT 100
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`);
ALTER TABLE `accounts` ADD FULLTEXT KEY `s` (`serial`);

ALTER TABLE `adminserials`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `atms`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `bank_accounts`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `bans`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `bans2`
  ADD PRIMARY KEY (`banId`);

ALTER TABLE `bins`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `blockedserials`
  ADD PRIMARY KEY (`id`);


ALTER TABLE `bugreports`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `characters`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `craftingtabels`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `elevators`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `factions`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `fuelstations`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `gates`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `interiors`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `interior_objects`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `items`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `logpp`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `lottery`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `mdcaccounts`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `mdclogs`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `mdcpenalties`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `mdcwantedcars`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `mdcwantedpersons`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `pendingpps`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `pets`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `phonemessages`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `plants`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `plants_containers`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `plants_orders`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `pots`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `printers`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `roulettes`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `shops`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `szefek`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `teslachargers`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `trafficboards`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `usedcarshops`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `vendingmachines`
  ADD PRIMARY KEY (`dbId`);

ALTER TABLE `verifedplayers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `serial` (`serial`);

ALTER TABLE `worlditems`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `accounts`
  MODIFY `id` int(22) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6282;

ALTER TABLE `adminserials`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

ALTER TABLE `atms`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=224;

ALTER TABLE `bank_accounts`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1385;

ALTER TABLE `bans`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=194;

ALTER TABLE `bans2`
  MODIFY `banId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=135;

ALTER TABLE `bins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=391;

ALTER TABLE `blockedserials`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

ALTER TABLE `bugreports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

ALTER TABLE `characters`
  MODIFY `id` int(22) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4671;

ALTER TABLE `craftingtabels`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

ALTER TABLE `elevators`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=130;

ALTER TABLE `factions`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;

ALTER TABLE `fuelstations`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

ALTER TABLE `gates`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=409;

ALTER TABLE `interiors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1283;

ALTER TABLE `interior_objects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=533337;

ALTER TABLE `logpp`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=76;

ALTER TABLE `lottery`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `mdcaccounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=89;

ALTER TABLE `mdclogs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8471;

ALTER TABLE `mdcpenalties`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

ALTER TABLE `mdcwantedcars`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=70;

ALTER TABLE `mdcwantedpersons`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

ALTER TABLE `pendingpps`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

ALTER TABLE `pets`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

ALTER TABLE `phonemessages`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1676;

ALTER TABLE `plants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8402;

ALTER TABLE `plants_containers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

ALTER TABLE `plants_orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

ALTER TABLE `pots`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11965;

ALTER TABLE `printers`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

ALTER TABLE `roulettes`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55392;

ALTER TABLE `shops`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=252;

ALTER TABLE `szefek`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=217;

ALTER TABLE `teslachargers`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

ALTER TABLE `trafficboards`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=994;

ALTER TABLE `usedcarshops`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

ALTER TABLE `vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6797;

ALTER TABLE `vendingmachines`
  MODIFY `dbId` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=96;

ALTER TABLE `verifedplayers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=345;

ALTER TABLE `worlditems`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;