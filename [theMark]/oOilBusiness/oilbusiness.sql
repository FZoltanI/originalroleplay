-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Gép: 127.0.0.1
-- Létrehozás ideje: 2021. Ápr 20. 21:16
-- Kiszolgáló verziója: 10.4.16-MariaDB
-- PHP verzió: 7.4.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Adatbázis: `teszt`
--

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `oilbusiness`
--

CREATE TABLE `oilbusiness` (
  `dbId` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `ownerId` int(11) NOT NULL DEFAULT 0,
  `position` varchar(255) NOT NULL,
  `oilPump` int(11) NOT NULL DEFAULT 1,
  `oilProgress` int(11) NOT NULL DEFAULT 0,
  `errorMachine` int(11) NOT NULL DEFAULT 0,
  `wrongMachineId` int(11) NOT NULL DEFAULT 0,
  `rentOilStation` int(11) NOT NULL DEFAULT 0,
  `locked` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- A tábla adatainak kiíratása `oilbusiness`
--

INSERT INTO `oilbusiness` (`dbId`, `name`, `ownerId`, `position`, `oilPump`, `oilProgress`, `errorMachine`, `wrongMachineId`, `rentOilStation`, `locked`) VALUES
(1, 'Teszt', 0, '[[1666.3715820313,-2313.0803222656,13.544849395752]]', 1, 0, 0, 0, 0, 0),
(2, 'Dexter_Power', 1, '[[1675.2846679688,-2312.6479492188,13.542673110962]]', 4, 60, 0, 0, 1618324111, 0);

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `oilbusiness`
--
ALTER TABLE `oilbusiness`
  ADD PRIMARY KEY (`dbId`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `oilbusiness`
--
ALTER TABLE `oilbusiness`
  MODIFY `dbId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
