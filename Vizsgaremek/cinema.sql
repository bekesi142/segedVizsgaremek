-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Gép: 127.0.0.1
-- Létrehozás ideje: 2025. Jan 31. 11:48
-- Kiszolgáló verziója: 10.4.32-MariaDB
-- PHP verzió: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Adatbázis: `cinema`
--

DELIMITER $$
--
-- Eljárások
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `elhelyezFoglalasok` ()   BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE f_id INT;
    DECLARE f_osszeg INT;
    DECLARE szekek_count INT;
    DECLARE ter_id INT;
    DECLARE sor_id INT;
    DECLARE oszlop_id INT;
    DECLARE cur CURSOR FOR SELECT foglalas_id, osszeg FROM foglalas;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO f_id, f_osszeg;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Számoljuk ki hány szék kell
        SET szekek_count = f_osszeg / 2000;

        -- Véletlenszerű helyek a széksorokhoz
        SET ter_id = FLOOR(1 + (RAND() * 3));  -- 3 termet feltételezünk (1, 2, 3)
        SET sor_id = FLOOR(1 + (RAND() * 10)); -- 10 sor feltételezve
        SET oszlop_id = FLOOR(1 + (RAND() * 20)); -- 20 oszlop feltételezve

        -- A székeket elhelyezzük
        WHILE szekek_count > 0 DO
            INSERT INTO foglalasszek (foglalas_id, szek_id, terem, sor, oszlop)
            VALUES (f_id, (SELECT MAX(szek_id) + 1 FROM foglalasszek), ter_id, sor_id, oszlop_id);

            -- Frissítjük a székeket (például más oszlopba)
            SET oszlop_id = oszlop_id + 1;
            SET szekek_count = szekek_count - 1;

            -- Ha elérjük az oszlop határt, mehetünk a következő sorba
            IF oszlop_id > 20 THEN
                SET oszlop_id = 1;
                SET sor_id = sor_id + 1;
                IF sor_id > 10 THEN
                    SET sor_id = 1;
                    SET ter_id = (ter_id % 3) + 1;  -- Másik terem
                END IF;
            END IF;
        END WHILE;
    END LOOP;

    CLOSE cur;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `comment`
--

CREATE TABLE `comment` (
  `CommentId` int(11) NOT NULL,
  `CommentTartalma` varchar(255) DEFAULT NULL,
  `FelhasznaloId` int(11) DEFAULT NULL,
  `FilmId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `comment`
--

INSERT INTO `comment` (`CommentId`, `CommentTartalma`, `FelhasznaloId`, `FilmId`) VALUES
(1, 'Nagyon szeretem ezt a filmet, igazi klasszikus!', 1, 1),
(2, 'Az effektek elképesztőek, mindig lenyűgöz!', 2, 2),
(3, 'Az időutazás koncepciója nagyon izgalmas!', 3, 3),
(4, 'Ez a film teljesen megváltoztatta a sci-fi műfajt.', 4, 4),
(5, 'Heath Ledger zseniális volt Joker szerepében!', 5, 5),
(6, 'A Gyűrűk Ura világa egyszerűen lenyűgöző.', 6, 6),
(7, 'A dinók annyira élethűek voltak, elképesztő!', 7, 7),
(8, 'Pandora világa csodálatos, minden részlete gyönyörű.', 8, 8),
(9, 'A Titanic mindig könnyeket csal a szemembe.', 9, 9),
(10, 'Russell Crowe alakítása zseniális, igazi harcos!', 10, 10),
(11, 'A Star Wars minden idők legjobb űroperája!', 1, 1),
(12, 'Leonardo DiCaprio egyik legjobb alakítása volt.', 2, 9),
(13, 'A Mátrix filozófiai mondanivalója nagyon mély.', 3, 4),
(14, 'Christopher Nolan filmjei mindig elgondolkodtatnak.', 4, 2),
(15, 'Egy film, amit minden filmrajongónak látnia kell!', 5, 3),
(16, 'A látványvilág és a történet is remekül működik.', 6, 6),
(17, 'A dínók mindig is lenyűgöztek, imádom ezt a filmet!', 7, 7),
(18, 'Ezt a filmet már vagy tízszer láttam, és még mindig imádom.', 8, 5),
(19, 'A harci jelenetek és a történetvezetés mesteri.', 9, 10),
(20, 'Nem lehet elfelejteni ezt a filmet, örök klasszikus.', 10, 1);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `etellista`
--

CREATE TABLE `etellista` (
  `EtelID` int(11) NOT NULL,
  `EtelNeve` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `etellista`
--

INSERT INTO `etellista` (`EtelID`, `EtelNeve`) VALUES
(1, 'Popcorn'),
(2, 'Nachos sajttal'),
(3, 'Hot dog'),
(4, 'Tortilla chips és guacamole'),
(5, 'Mogyoró'),
(6, 'Candy mix'),
(7, 'Fagyi'),
(8, 'Pizzás falatok'),
(9, 'Friss gyümölcsök'),
(10, 'Mini szendvicsek'),
(11, 'Burgonyaszirom'),
(12, 'Mozis zacskós chips'),
(13, 'Karamellás alma'),
(14, 'Tökös piték vagy muffinkák'),
(15, 'Iced tea'),
(16, 'Üdítők'),
(17, 'Kávé és sütemények'),
(18, 'Jégkrémes édességek'),
(19, 'Puffasztott rizs snackek');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `felhasznalo`
--

CREATE TABLE `felhasznalo` (
  `felhasznaloId` int(11) NOT NULL,
  `SzerepKorID` int(11) DEFAULT NULL,
  `Nev` varchar(255) DEFAULT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `Jelszo` varchar(255) DEFAULT NULL,
  `Szint` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `felhasznalo`
--

INSERT INTO `felhasznalo` (`felhasznaloId`, `SzerepKorID`, `Nev`, `Email`, `Jelszo`, `Szint`) VALUES
(1, 1, 'Kovács Péter', 'kovacspeter@email.com', 'jelszo123', NULL),
(2, 1, 'Szabó Anna', 'szaboanna@email.com', 'jelszo234', NULL),
(3, 2, 'Nagy Gábor', 'nagygabor@email.com', 'jelszo345', NULL),
(4, 2, 'Tóth Eszter', 'totheszter@email.com', 'jelszo456', NULL),
(5, 2, 'Varga László', 'vargalaszlo@email.com', 'jelszo567', NULL),
(6, 2, 'Horváth Zsófia', 'horvathzsofia@email.com', 'jelszo678', NULL),
(7, 2, 'Kiss Tamás', 'kisstamas@email.com', 'jelszo789', NULL),
(8, 2, 'József Krisztina', 'jozsefkrisztina@email.com', 'jelszo890', NULL),
(9, 2, 'Farkas Péter', 'farkaspetar@email.com', 'jelszo901', NULL),
(10, 2, 'Benedek Lili', 'benedeklili@email.com', 'jelszo012', NULL);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `film`
--

CREATE TABLE `film` (
  `FilmId` int(11) NOT NULL,
  `Cim` varchar(255) DEFAULT NULL,
  `Hossz` int(11) DEFAULT NULL,
  `KiadasEve` int(11) DEFAULT NULL,
  `Kulcsszavak` text DEFAULT NULL,
  `RendezoID` int(11) DEFAULT NULL,
  `Bemutatas` text DEFAULT NULL,
  `ElozetesUrl` varchar(255) DEFAULT NULL,
  `PoszterKep` blob DEFAULT NULL,
  `HatterKep` blob DEFAULT NULL,
  `ImdbErtekeles` int(11) DEFAULT NULL,
  `FoMondat` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `film`
--

INSERT INTO `film` (`FilmId`, `Cim`, `Hossz`, `KiadasEve`, `Kulcsszavak`, `RendezoID`, `Bemutatas`, `ElozetesUrl`, `PoszterKep`, `HatterKep`, `ImdbErtekeles`, `FoMondat`) VALUES
(1, 'Star Wars: A New Hope', 121, 1977, 'űrhajó, fénykard, Jedi, Sötét oldal', NULL, 'Egy fiatal farmer felfedezi, hogy a galaxist meg kell mentenie a Birodalomtól.', 'https://youtu.be/1g3_CFmnU7k', 0x73775f706f737465722e6a7067, 0x73775f6261636b67726f756e642e6a7067, 9, 'Az Erő legyen veled!'),
(2, 'Inception', 148, 2010, 'álom, tudatalatti, heist, idő', NULL, 'Egy csapat profi tolvaj az emberek álmaiba tör be titkokért.', 'https://youtu.be/YoHD9XEInc0', 0x696e63657074696f6e5f706f737465722e6a7067, 0x696e63657074696f6e5f62672e6a7067, 9, 'Az álomban is lehet csapdába esni.'),
(3, 'Interstellar', 169, 2014, 'fekete lyuk, űrutazás, idődilatáció', NULL, 'Egy űrhajós csapat a túlélhető bolygó keresésére indul a galaxisban.', 'https://youtu.be/zSWdZVtXT7E', 0x696e7465727374656c6c61725f706f737465722e6a7067, 0x696e7465727374656c6c61725f62672e6a7067, 9, 'A szeretet is egy dimenzió.'),
(4, 'The Matrix', 136, 1999, 'mesterséges intelligencia, virtuális valóság, hacker', NULL, 'Egy férfi felfedezi, hogy a valóság, amelyben él, nem valódi.', 'https://youtu.be/vKQi3bBA1y8', 0x6d61747269785f706f737465722e6a7067, 0x6d61747269785f62672e6a7067, 9, 'A piros vagy a kék kapszula?'),
(5, 'The Dark Knight', 152, 2008, 'Gotham, Joker, bűnüldözés, igazság', NULL, 'Batmannek szembe kell néznie legveszélyesebb ellenségével, a Jokerral.', 'https://youtu.be/EXeTwQWrcwY', 0x6461726b5f6b6e696768745f706f737465722e6a7067, 0x6461726b5f6b6e696768745f62672e6a7067, 9, 'Miért vagy ilyen komoly?'),
(6, 'The Lord of the Rings: The Fellowship of the Ring', 178, 2001, 'gyűrű, varázslat, kaland, Sauron', NULL, 'Egy fiatal hobbit elindul, hogy elpusztítsa a világot fenyegető Gyűrűt.', 'https://youtu.be/V75dMMIW2B4', 0x6c6f74725f706f737465722e6a7067, 0x6c6f74725f62672e6a7067, 9, 'Egy gyűrű mind fölött!'),
(7, 'Jurassic Park', 127, 1993, 'dinoszauruszok, sziget, tudományos kísérlet', NULL, 'Egy csapat ember meglátogat egy klónozott dinoszauruszokkal teli szigetet.', 'https://youtu.be/QWBKEmWWL38', 0x6a757261737369635f706f737465722e6a7067, 0x6a757261737369635f62672e6a7067, 8, 'Az élet utat tör magának!'),
(8, 'Avatar', 162, 2009, 'Pandora, idegenek, környezetvédelem', NULL, 'Egy ember beépül egy idegen faj közé, hogy elpusztítsa vagy megmentse őket.', 'https://youtu.be/5PSNL1qE6VY', 0x6176617461725f706f737465722e6a7067, 0x6176617461725f62672e6a7067, 8, 'Láss a szemeddel, ne az elméddel!'),
(9, 'Titanic', 195, 1997, 'hajó, szerelem, katasztrófa, történelem', NULL, 'Egy szerelmi történet egy tragikus hajótörés árnyékában.', 'https://youtu.be/kVrqfYjkTdQ', 0x746974616e69635f706f737465722e6a7067, 0x746974616e69635f62672e6a7067, 8, 'A szívem örökké dobog érted!'),
(10, 'Gladiator', 155, 2000, 'Róma, harcos, Colosseum, bosszú', NULL, 'Egy árulás miatt bukott római tábornok gladiátorrá válik, hogy bosszút álljon.', 'https://youtu.be/owK1qxDselE', 0x676c61646961746f725f706f737465722e6a7067, 0x676c61646961746f725f62672e6a7067, 9, 'Emlékezni fognak a nevedre!');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `filmgenre`
--

CREATE TABLE `filmgenre` (
  `FilmID` int(11) DEFAULT NULL,
  `GenreID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `filmgenre`
--

INSERT INTO `filmgenre` (`FilmID`, `GenreID`) VALUES
(1, 3),
(2, 3),
(3, 3),
(4, 3),
(5, 1),
(6, 2),
(7, 1),
(8, 3),
(9, 2),
(10, 1);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `filmszinesz`
--

CREATE TABLE `filmszinesz` (
  `FilmID` int(11) DEFAULT NULL,
  `SzineszID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `filmszinesz`
--

INSERT INTO `filmszinesz` (`FilmID`, `SzineszID`) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(3, 5),
(3, 6),
(4, 7),
(4, 8),
(5, 9),
(5, 10);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `foglalas`
--

CREATE TABLE `foglalas` (
  `FoglalasId` int(11) NOT NULL,
  `FelhasznaloId` int(11) DEFAULT NULL,
  `VetitesId` int(11) DEFAULT NULL,
  `Osszeg` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `foglalas`
--

INSERT INTO `foglalas` (`FoglalasId`, `FelhasznaloId`, `VetitesId`, `Osszeg`) VALUES
(1, 1, 1, 2000),
(2, 2, 2, 4000),
(3, 3, 3, 6000),
(4, 4, 4, 8000),
(5, 5, 5, 10000),
(6, 6, 6, 12000),
(7, 7, 7, 14000),
(8, 8, 8, 16000),
(9, 9, 9, 18000),
(10, 10, 10, 20000),
(11, 1, 11, 22000),
(12, 2, 12, 24000),
(13, 3, 13, 26000),
(14, 4, 14, 28000),
(15, 5, 15, 30000),
(16, 6, 16, 2000),
(17, 7, 17, 4000),
(18, 8, 18, 6000),
(19, 9, 19, 8000),
(20, 10, 20, 10000),
(21, 1, 21, 12000),
(22, 2, 22, 14000),
(23, 3, 23, 16000),
(24, 4, 24, 18000),
(25, 5, 25, 20000),
(26, 6, 26, 22000),
(27, 7, 27, 24000),
(28, 8, 28, 26000),
(29, 9, 29, 28000),
(30, 10, 30, 30000);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `foglalasszek`
--

CREATE TABLE `foglalasszek` (
  `FoglalasId` int(11) DEFAULT NULL,
  `SzekId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `foglalasszek`
--

INSERT INTO `foglalasszek` (`FoglalasId`, `SzekId`) VALUES
(1, 101),
(1, 102),
(2, 103),
(2, 104),
(3, 105),
(3, 106),
(4, 107),
(4, 108),
(5, 109),
(5, 110),
(6, 111),
(6, 112),
(7, 113),
(7, 114),
(8, 115),
(8, 116),
(9, 117),
(9, 118),
(10, 119),
(10, 120),
(11, 121),
(11, 122),
(12, 123),
(12, 124),
(13, 125),
(13, 126),
(14, 127),
(14, 128),
(15, 129),
(15, 130),
(16, 131),
(16, 132),
(17, 133),
(17, 134),
(18, 135),
(18, 136),
(19, 137),
(19, 138),
(20, 139),
(20, 140);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `genre`
--

CREATE TABLE `genre` (
  `GenreID` int(11) NOT NULL,
  `MufajNev` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `genre`
--

INSERT INTO `genre` (`GenreID`, `MufajNev`) VALUES
(1, 'Akció'),
(2, 'Kaland'),
(3, 'Sci-Fi'),
(4, 'Dráma'),
(5, 'Vígjáték'),
(6, 'Horror'),
(7, 'Romantikus'),
(8, 'Thriller'),
(9, 'Bűnügyi'),
(10, 'Dokumentumfilm');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `rendeltetel`
--

CREATE TABLE `rendeltetel` (
  `RendeltEtelId` int(11) NOT NULL,
  `FoglalasId` int(11) DEFAULT NULL,
  `EtelID` int(11) DEFAULT NULL,
  `Ar` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `rendeltetel`
--

INSERT INTO `rendeltetel` (`RendeltEtelId`, `FoglalasId`, `EtelID`, `Ar`) VALUES
(1, 1, 1, 3000.00),
(2, 2, 2, 4500.00),
(3, 3, 3, 6000.00),
(4, 4, 4, 7500.00),
(5, 5, 5, 3000.00),
(6, 6, 6, 6000.00),
(7, 7, 7, 1500.00),
(8, 8, 8, 6000.00),
(9, 9, 9, 7500.00),
(10, 10, 10, 3000.00),
(11, 11, 11, 6000.00),
(12, 12, 12, 7500.00),
(13, 13, 13, 3000.00),
(14, 14, 14, 4500.00),
(15, 15, 15, 4500.00);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `rendezo`
--

CREATE TABLE `rendezo` (
  `RendezoID` int(11) NOT NULL,
  `RendezoNeve` varchar(255) DEFAULT NULL,
  `RendezoSzul` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `rendezo`
--

INSERT INTO `rendezo` (`RendezoID`, `RendezoNeve`, `RendezoSzul`) VALUES
(1, 'Christopher Nolan', '1970-07-30'),
(2, 'Quentin Tarantino', '1963-03-27'),
(3, 'Steven Spielberg', '1946-12-18'),
(4, 'Martin Scorsese', '1942-11-17'),
(5, 'James Cameron', '1954-08-16');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `szavazas`
--

CREATE TABLE `szavazas` (
  `SzavazasId` int(11) NOT NULL,
  `Cim` varchar(255) DEFAULT NULL,
  `LetrehozasDatum` datetime DEFAULT NULL,
  `LejaratDatum` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `szavazas`
--

INSERT INTO `szavazas` (`SzavazasId`, `Cim`, `LetrehozasDatum`, `LejaratDatum`) VALUES
(1, '2023. hét 1. szavazása', '2023-01-02 00:00:00', '2023-01-08 00:00:00'),
(2, '2023. hét 2. szavazása', '2023-01-09 00:00:00', '2023-01-15 00:00:00'),
(3, '2023. hét 3. szavazása', '2023-01-16 00:00:00', '2023-01-22 00:00:00'),
(4, '2023. hét 4. szavazása', '2023-01-23 00:00:00', '2023-01-29 00:00:00'),
(5, '2023. hét 5. szavazása', '2023-01-30 00:00:00', '2023-02-05 00:00:00'),
(6, '2023. hét 6. szavazása', '2023-02-06 00:00:00', '2023-02-12 00:00:00'),
(7, '2023. hét 7. szavazása', '2023-02-13 00:00:00', '2023-02-19 00:00:00'),
(8, '2023. hét 8. szavazása', '2023-02-20 00:00:00', '2023-02-26 00:00:00'),
(9, '2023. hét 9. szavazása', '2023-02-27 00:00:00', '2023-03-05 00:00:00'),
(10, '2023. hét 10. szavazása', '2023-03-06 00:00:00', '2023-03-12 00:00:00'),
(11, '2023. hét 11. szavazása', '2023-03-13 00:00:00', '2023-03-19 00:00:00'),
(12, '2023. hét 12. szavazása', '2023-03-20 00:00:00', '2023-03-26 00:00:00'),
(13, '2023. hét 13. szavazása', '2023-03-27 00:00:00', '2023-04-02 00:00:00'),
(14, '2023. hét 14. szavazása', '2023-04-03 00:00:00', '2023-04-09 00:00:00'),
(15, '2023. hét 15. szavazása', '2023-04-10 00:00:00', '2023-04-16 00:00:00'),
(16, '2024. hét 1. szavazása', '2024-01-01 00:00:00', '2024-01-07 00:00:00'),
(17, '2024. hét 2. szavazása', '2024-01-08 00:00:00', '2024-01-14 00:00:00'),
(18, '2024. hét 3. szavazása', '2024-01-15 00:00:00', '2024-01-21 00:00:00'),
(19, '2024. hét 4. szavazása', '2024-01-22 00:00:00', '2024-01-28 00:00:00'),
(20, '2024. hét 5. szavazása', '2024-01-29 00:00:00', '2024-02-04 00:00:00');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `szavazastemakor`
--

CREATE TABLE `szavazastemakor` (
  `SzavazasId` int(11) DEFAULT NULL,
  `TemakorId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `szavazastemakor`
--

INSERT INTO `szavazastemakor` (`SzavazasId`, `TemakorId`) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(3, 5),
(3, 6),
(4, 7),
(4, 8),
(5, 9),
(5, 10),
(6, 11),
(6, 12),
(7, 13),
(7, 14),
(8, 1),
(8, 2),
(9, 3),
(9, 4),
(10, 5),
(10, 6),
(11, 7),
(11, 8),
(12, 9),
(12, 10),
(13, 11),
(13, 12),
(14, 13),
(14, 14),
(15, 1),
(15, 2),
(16, 3),
(16, 4),
(17, 5),
(17, 6),
(18, 7),
(18, 8),
(19, 9),
(19, 10),
(20, 11),
(20, 12);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `szavazat`
--

CREATE TABLE `szavazat` (
  `SzavazatId` int(11) NOT NULL,
  `SzavazasId` int(11) DEFAULT NULL,
  `FelhasznaloId` int(11) DEFAULT NULL,
  `ValasztottOpcio` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `szavazat`
--

INSERT INTO `szavazat` (`SzavazatId`, `SzavazasId`, `FelhasznaloId`, `ValasztottOpcio`) VALUES
(1, 1, 1, 2),
(2, 1, 2, 3),
(3, 1, 3, 1),
(4, 1, 4, 4),
(5, 1, 5, 5),
(6, 2, 6, 1),
(7, 2, 7, 2),
(8, 2, 8, 3),
(9, 2, 9, 4),
(10, 2, 10, 5),
(11, 3, 1, 3),
(12, 3, 2, 4),
(13, 3, 3, 2),
(14, 3, 4, 5),
(15, 3, 5, 1),
(16, 4, 6, 2),
(17, 4, 7, 3),
(18, 4, 8, 4),
(19, 4, 9, 5),
(20, 4, 10, 1),
(21, 5, 1, 4),
(22, 5, 2, 5),
(23, 5, 3, 1),
(24, 5, 4, 2),
(25, 5, 5, 3),
(26, 6, 6, 3),
(27, 6, 7, 4),
(28, 6, 8, 5),
(29, 6, 9, 1),
(30, 6, 10, 2),
(31, 7, 1, 5),
(32, 7, 2, 1),
(33, 7, 3, 2),
(34, 7, 4, 3),
(35, 7, 5, 4),
(36, 8, 6, 4),
(37, 8, 7, 5),
(38, 8, 8, 1),
(39, 8, 9, 2),
(40, 8, 10, 3),
(41, 9, 1, 2),
(42, 9, 2, 3),
(43, 9, 3, 4),
(44, 9, 4, 5),
(45, 9, 5, 1),
(46, 10, 6, 1),
(47, 10, 7, 2),
(48, 10, 8, 3),
(49, 10, 9, 4),
(50, 10, 10, 5);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `szek`
--

CREATE TABLE `szek` (
  `SzekId` int(11) NOT NULL,
  `Oszlop` int(11) DEFAULT NULL,
  `Sor` int(11) DEFAULT NULL,
  `TeremId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `szek`
--

INSERT INTO `szek` (`SzekId`, `Oszlop`, `Sor`, `TeremId`) VALUES
(1, 1, 1, 1),
(2, 2, 1, 1),
(3, 3, 1, 1),
(4, 4, 1, 1),
(5, 5, 1, 1),
(6, 6, 1, 1),
(7, 7, 1, 1),
(8, 8, 1, 1),
(9, 9, 1, 1),
(10, 10, 1, 1),
(11, 1, 2, 1),
(12, 2, 2, 1),
(13, 3, 2, 1),
(14, 4, 2, 1),
(15, 5, 2, 1),
(16, 6, 2, 1),
(17, 7, 2, 1),
(18, 8, 2, 1),
(19, 9, 2, 1),
(20, 10, 2, 1),
(21, 1, 3, 1),
(22, 2, 3, 1),
(23, 3, 3, 1),
(24, 4, 3, 1),
(25, 5, 3, 1),
(26, 6, 3, 1),
(27, 7, 3, 1),
(28, 8, 3, 1),
(29, 9, 3, 1),
(30, 10, 3, 1),
(31, 1, 4, 1),
(32, 2, 4, 1),
(33, 3, 4, 1),
(34, 4, 4, 1),
(35, 5, 4, 1),
(36, 6, 4, 1),
(37, 7, 4, 1),
(38, 8, 4, 1),
(39, 9, 4, 1),
(40, 10, 4, 1),
(41, 1, 5, 1),
(42, 2, 5, 1),
(43, 3, 5, 1),
(44, 4, 5, 1),
(45, 5, 5, 1),
(46, 6, 5, 1),
(47, 7, 5, 1),
(48, 8, 5, 1),
(49, 9, 5, 1),
(50, 10, 5, 1),
(51, 1, 6, 1),
(52, 2, 6, 1),
(53, 3, 6, 1),
(54, 4, 6, 1),
(55, 5, 6, 1),
(56, 6, 6, 1),
(57, 7, 6, 1),
(58, 8, 6, 1),
(59, 9, 6, 1),
(60, 10, 6, 1),
(61, 1, 7, 1),
(62, 2, 7, 1),
(63, 3, 7, 1),
(64, 4, 7, 1),
(65, 5, 7, 1),
(66, 6, 7, 1),
(67, 7, 7, 1),
(68, 8, 7, 1),
(69, 9, 7, 1),
(70, 10, 7, 1),
(71, 1, 8, 1),
(72, 2, 8, 1),
(73, 3, 8, 1),
(74, 4, 8, 1),
(75, 5, 8, 1),
(76, 6, 8, 1),
(77, 7, 8, 1),
(78, 8, 8, 1),
(79, 9, 8, 1),
(80, 10, 8, 1),
(81, 1, 9, 1),
(82, 2, 9, 1),
(83, 3, 9, 1),
(84, 4, 9, 1),
(85, 5, 9, 1),
(86, 6, 9, 1),
(87, 7, 9, 1),
(88, 8, 9, 1),
(89, 9, 9, 1),
(90, 10, 9, 1),
(91, 1, 10, 1),
(92, 2, 10, 1),
(93, 3, 10, 1),
(94, 4, 10, 1),
(95, 5, 10, 1),
(96, 6, 10, 1),
(97, 7, 10, 1),
(98, 8, 10, 1),
(99, 9, 10, 1),
(100, 10, 10, 1),
(101, 1, 1, 2),
(102, 2, 1, 2),
(103, 3, 1, 2),
(104, 4, 1, 2),
(105, 5, 1, 2),
(106, 6, 1, 2),
(107, 7, 1, 2),
(108, 8, 1, 2),
(109, 9, 1, 2),
(110, 10, 1, 2),
(111, 1, 2, 2),
(112, 2, 2, 2),
(113, 3, 2, 2),
(114, 4, 2, 2),
(115, 5, 2, 2),
(116, 6, 2, 2),
(117, 7, 2, 2),
(118, 8, 2, 2),
(119, 9, 2, 2),
(120, 10, 2, 2),
(121, 1, 3, 2),
(122, 2, 3, 2),
(123, 3, 3, 2),
(124, 4, 3, 2),
(125, 5, 3, 2),
(126, 6, 3, 2),
(127, 7, 3, 2),
(128, 8, 3, 2),
(129, 9, 3, 2),
(130, 10, 3, 2),
(131, 1, 4, 2),
(132, 2, 4, 2),
(133, 3, 4, 2),
(134, 4, 4, 2),
(135, 5, 4, 2),
(136, 6, 4, 2),
(137, 7, 4, 2),
(138, 8, 4, 2),
(139, 9, 4, 2),
(140, 10, 4, 2),
(141, 1, 5, 2),
(142, 2, 5, 2),
(143, 3, 5, 2),
(144, 4, 5, 2),
(145, 5, 5, 2),
(146, 6, 5, 2),
(147, 7, 5, 2),
(148, 8, 5, 2),
(149, 9, 5, 2),
(150, 10, 5, 2),
(151, 1, 6, 2),
(152, 2, 6, 2),
(153, 3, 6, 2),
(154, 4, 6, 2),
(155, 5, 6, 2),
(156, 6, 6, 2),
(157, 7, 6, 2),
(158, 8, 6, 2),
(159, 9, 6, 2),
(160, 10, 6, 2),
(161, 1, 7, 2),
(162, 2, 7, 2),
(163, 3, 7, 2),
(164, 4, 7, 2),
(165, 5, 7, 2),
(166, 6, 7, 2),
(167, 7, 7, 2),
(168, 8, 7, 2),
(169, 9, 7, 2),
(170, 10, 7, 2),
(171, 1, 8, 2),
(172, 2, 8, 2),
(173, 3, 8, 2),
(174, 4, 8, 2),
(175, 5, 8, 2),
(176, 6, 8, 2),
(177, 7, 8, 2),
(178, 8, 8, 2),
(179, 9, 8, 2),
(180, 10, 8, 2),
(181, 1, 9, 2),
(182, 2, 9, 2),
(183, 3, 9, 2),
(184, 4, 9, 2),
(185, 5, 9, 2),
(186, 6, 9, 2),
(187, 7, 9, 2),
(188, 8, 9, 2),
(189, 9, 9, 2),
(190, 10, 9, 2),
(191, 1, 10, 2),
(192, 2, 10, 2),
(193, 3, 10, 2),
(194, 4, 10, 2),
(195, 5, 10, 2),
(196, 6, 10, 2),
(197, 7, 10, 2),
(198, 8, 10, 2),
(199, 9, 10, 2),
(200, 10, 10, 2),
(201, 1, 1, 3),
(202, 2, 1, 3),
(203, 3, 1, 3),
(204, 4, 1, 3),
(205, 5, 1, 3),
(206, 6, 1, 3),
(207, 7, 1, 3),
(208, 8, 1, 3),
(209, 9, 1, 3),
(210, 10, 1, 3),
(211, 1, 2, 3),
(212, 2, 2, 3),
(213, 3, 2, 3),
(214, 4, 2, 3),
(215, 5, 2, 3),
(216, 6, 2, 3),
(217, 7, 2, 3),
(218, 8, 2, 3),
(219, 9, 2, 3),
(220, 10, 2, 3),
(221, 1, 3, 3),
(222, 2, 3, 3),
(223, 3, 3, 3),
(224, 4, 3, 3),
(225, 5, 3, 3),
(226, 6, 3, 3),
(227, 7, 3, 3),
(228, 8, 3, 3),
(229, 9, 3, 3),
(230, 10, 3, 3),
(231, 1, 4, 3),
(232, 2, 4, 3),
(233, 3, 4, 3),
(234, 4, 4, 3),
(235, 5, 4, 3),
(236, 6, 4, 3),
(237, 7, 4, 3),
(238, 8, 4, 3),
(239, 9, 4, 3),
(240, 10, 4, 3),
(241, 1, 5, 3),
(242, 2, 5, 3),
(243, 3, 5, 3),
(244, 4, 5, 3),
(245, 5, 5, 3),
(246, 6, 5, 3),
(247, 7, 5, 3),
(248, 8, 5, 3),
(249, 9, 5, 3),
(250, 10, 5, 3),
(251, 1, 6, 3),
(252, 2, 6, 3),
(253, 3, 6, 3),
(254, 4, 6, 3),
(255, 5, 6, 3),
(256, 6, 6, 3),
(257, 7, 6, 3),
(258, 8, 6, 3),
(259, 9, 6, 3),
(260, 10, 6, 3),
(261, 1, 7, 3),
(262, 2, 7, 3),
(263, 3, 7, 3),
(264, 4, 7, 3),
(265, 5, 7, 3),
(266, 6, 7, 3),
(267, 7, 7, 3),
(268, 8, 7, 3),
(269, 9, 7, 3),
(270, 10, 7, 3),
(271, 1, 8, 3),
(272, 2, 8, 3),
(273, 3, 8, 3),
(274, 4, 8, 3),
(275, 5, 8, 3),
(276, 6, 8, 3),
(277, 7, 8, 3),
(278, 8, 8, 3),
(279, 9, 8, 3),
(280, 10, 8, 3),
(281, 1, 9, 3),
(282, 2, 9, 3),
(283, 3, 9, 3),
(284, 4, 9, 3),
(285, 5, 9, 3),
(286, 6, 9, 3),
(287, 7, 9, 3),
(288, 8, 9, 3),
(289, 9, 9, 3),
(290, 10, 9, 3),
(291, 1, 10, 3),
(292, 2, 10, 3),
(293, 3, 10, 3),
(294, 4, 10, 3),
(295, 5, 10, 3),
(296, 6, 10, 3),
(297, 7, 10, 3),
(298, 8, 10, 3),
(299, 9, 10, 3),
(300, 10, 10, 3),
(301, 1, 1, 4),
(302, 2, 1, 4),
(303, 3, 1, 4),
(304, 4, 1, 4),
(305, 5, 1, 4),
(306, 6, 1, 4),
(307, 7, 1, 4),
(308, 8, 1, 4),
(309, 9, 1, 4),
(310, 10, 1, 4),
(311, 1, 2, 4),
(312, 2, 2, 4),
(313, 3, 2, 4),
(314, 4, 2, 4),
(315, 5, 2, 4),
(316, 6, 2, 4),
(317, 7, 2, 4),
(318, 8, 2, 4),
(319, 9, 2, 4),
(320, 10, 2, 4),
(321, 1, 3, 4),
(322, 2, 3, 4),
(323, 3, 3, 4),
(324, 4, 3, 4),
(325, 5, 3, 4),
(326, 6, 3, 4),
(327, 7, 3, 4),
(328, 8, 3, 4),
(329, 9, 3, 4),
(330, 10, 3, 4),
(331, 1, 4, 4),
(332, 2, 4, 4),
(333, 3, 4, 4),
(334, 4, 4, 4),
(335, 5, 4, 4),
(336, 6, 4, 4),
(337, 7, 4, 4),
(338, 8, 4, 4),
(339, 9, 4, 4),
(340, 10, 4, 4),
(341, 1, 5, 4),
(342, 2, 5, 4),
(343, 3, 5, 4),
(344, 4, 5, 4),
(345, 5, 5, 4),
(346, 6, 5, 4),
(347, 7, 5, 4),
(348, 8, 5, 4),
(349, 9, 5, 4),
(350, 10, 5, 4),
(351, 1, 6, 4),
(352, 2, 6, 4),
(353, 3, 6, 4),
(354, 4, 6, 4),
(355, 5, 6, 4),
(356, 6, 6, 4),
(357, 7, 6, 4),
(358, 8, 6, 4),
(359, 9, 6, 4),
(360, 10, 6, 4),
(361, 1, 7, 4),
(362, 2, 7, 4),
(363, 3, 7, 4),
(364, 4, 7, 4),
(365, 5, 7, 4),
(366, 6, 7, 4),
(367, 7, 7, 4),
(368, 8, 7, 4),
(369, 9, 7, 4),
(370, 10, 7, 4),
(371, 1, 8, 4),
(372, 2, 8, 4),
(373, 3, 8, 4),
(374, 4, 8, 4),
(375, 5, 8, 4),
(376, 6, 8, 4),
(377, 7, 8, 4),
(378, 8, 8, 4),
(379, 9, 8, 4),
(380, 10, 8, 4),
(381, 1, 9, 4),
(382, 2, 9, 4),
(383, 3, 9, 4),
(384, 4, 9, 4),
(385, 5, 9, 4),
(386, 6, 9, 4),
(387, 7, 9, 4),
(388, 8, 9, 4),
(389, 9, 9, 4),
(390, 10, 9, 4),
(391, 1, 10, 4),
(392, 2, 10, 4),
(393, 3, 10, 4),
(394, 4, 10, 4),
(395, 5, 10, 4),
(396, 6, 10, 4),
(397, 7, 10, 4),
(398, 8, 10, 4),
(399, 9, 10, 4),
(400, 10, 10, 4),
(401, 1, 1, 5),
(402, 2, 1, 5),
(403, 3, 1, 5),
(404, 4, 1, 5),
(405, 5, 1, 5),
(406, 6, 1, 5),
(407, 7, 1, 5),
(408, 8, 1, 5),
(409, 9, 1, 5),
(410, 10, 1, 5),
(411, 1, 2, 5),
(412, 2, 2, 5),
(413, 3, 2, 5),
(414, 4, 2, 5),
(415, 5, 2, 5),
(416, 6, 2, 5),
(417, 7, 2, 5),
(418, 8, 2, 5),
(419, 9, 2, 5),
(420, 10, 2, 5),
(421, 1, 3, 5),
(422, 2, 3, 5),
(423, 3, 3, 5),
(424, 4, 3, 5),
(425, 5, 3, 5),
(426, 6, 3, 5),
(427, 7, 3, 5),
(428, 8, 3, 5),
(429, 9, 3, 5),
(430, 10, 3, 5),
(431, 1, 4, 5),
(432, 2, 4, 5),
(433, 3, 4, 5),
(434, 4, 4, 5),
(435, 5, 4, 5),
(436, 6, 4, 5),
(437, 7, 4, 5),
(438, 8, 4, 5),
(439, 9, 4, 5),
(440, 10, 4, 5),
(441, 1, 5, 5),
(442, 2, 5, 5),
(443, 3, 5, 5),
(444, 4, 5, 5),
(445, 5, 5, 5),
(446, 6, 5, 5),
(447, 7, 5, 5),
(448, 8, 5, 5),
(449, 9, 5, 5),
(450, 10, 5, 5),
(451, 1, 6, 5),
(452, 2, 6, 5),
(453, 3, 6, 5),
(454, 4, 6, 5),
(455, 5, 6, 5),
(456, 6, 6, 5),
(457, 7, 6, 5),
(458, 8, 6, 5),
(459, 9, 6, 5),
(460, 10, 6, 5),
(461, 1, 7, 5),
(462, 2, 7, 5),
(463, 3, 7, 5),
(464, 4, 7, 5),
(465, 5, 7, 5),
(466, 6, 7, 5),
(467, 7, 7, 5),
(468, 8, 7, 5),
(469, 9, 7, 5),
(470, 10, 7, 5),
(471, 1, 8, 5),
(472, 2, 8, 5),
(473, 3, 8, 5),
(474, 4, 8, 5),
(475, 5, 8, 5),
(476, 6, 8, 5),
(477, 7, 8, 5),
(478, 8, 8, 5),
(479, 9, 8, 5),
(480, 10, 8, 5),
(481, 1, 9, 5),
(482, 2, 9, 5),
(483, 3, 9, 5),
(484, 4, 9, 5),
(485, 5, 9, 5),
(486, 6, 9, 5),
(487, 7, 9, 5),
(488, 8, 9, 5),
(489, 9, 9, 5),
(490, 10, 9, 5),
(491, 1, 10, 5),
(492, 2, 10, 5),
(493, 3, 10, 5),
(494, 4, 10, 5),
(495, 5, 10, 5),
(496, 6, 10, 5),
(497, 7, 10, 5),
(498, 8, 10, 5),
(499, 9, 10, 5),
(500, 10, 10, 5);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `szerepkor`
--

CREATE TABLE `szerepkor` (
  `SzerepKorID` int(11) NOT NULL,
  `SzerepKorNeve` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `szerepkor`
--

INSERT INTO `szerepkor` (`SzerepKorID`, `SzerepKorNeve`) VALUES
(1, 'Admin'),
(2, 'Felhasználó');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `szinesz`
--

CREATE TABLE `szinesz` (
  `SzineszId` int(11) NOT NULL,
  `SzineszNeve` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `szinesz`
--

INSERT INTO `szinesz` (`SzineszId`, `SzineszNeve`) VALUES
(1, 'Mark Hamill'),
(2, 'Harrison Ford'),
(3, 'Leonardo DiCaprio'),
(4, 'Joseph Gordon-Levitt'),
(5, 'Matthew McConaughey'),
(6, 'Anne Hathaway'),
(7, 'Keanu Reeves'),
(8, 'Laurence Fishburne'),
(9, 'Christian Bale'),
(10, 'Heath Ledger');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `temakor`
--

CREATE TABLE `temakor` (
  `TemakorID` int(11) NOT NULL,
  `TemakorNeve` varchar(255) DEFAULT NULL,
  `SzavazatokSzama` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `temakor`
--

INSERT INTO `temakor` (`TemakorID`, `TemakorNeve`, `SzavazatokSzama`) VALUES
(1, '90-es évek filmjei', NULL),
(2, 'Westend filmek', NULL),
(3, 'Klasszikus filmek', NULL),
(4, 'Oscar-díjas filmek', NULL),
(5, 'Sci-fi mesterművek', NULL),
(6, 'Akcióklasszikusok', NULL),
(7, 'Romantikus vígjátékok', NULL),
(8, 'Bűnügyi drámák', NULL),
(9, 'Horror filmek', NULL),
(10, 'Művészfilmek', NULL),
(11, 'Kalandfilmek', NULL),
(12, 'Superhős filmek', NULL),
(13, 'Maffia történetek', NULL),
(14, 'Sport filmek', NULL),
(15, 'Zenei filmek', NULL),
(16, 'Háborús filmek', NULL),
(17, 'Városi legendák', NULL),
(18, 'Családi filmek', NULL),
(19, 'Filmek a szabadidőről', NULL),
(20, 'Fantasy filmek', NULL);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `tematikushet`
--

CREATE TABLE `tematikushet` (
  `TematikusHetId` int(11) NOT NULL,
  `Nev` varchar(255) DEFAULT NULL,
  `KezdetDatum` date DEFAULT NULL,
  `VegeDatum` date DEFAULT NULL,
  `TemakorID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `tematikushet`
--

INSERT INTO `tematikushet` (`TematikusHetId`, `Nev`, `KezdetDatum`, `VegeDatum`, `TemakorID`) VALUES
(1, '90-es évek filmjei', '2024-01-01', '2024-01-07', 1),
(2, 'Westend filmek', '2024-01-08', '2024-01-14', 2),
(3, 'Klasszikus filmek', '2024-01-15', '2024-01-21', 3),
(4, 'Oscar-díjas filmek', '2024-01-22', '2024-01-28', 4),
(5, 'Sci-fi mesterművek', '2024-01-29', '2024-02-04', 5),
(6, 'Akcióklasszikusok', '2024-02-05', '2024-02-11', 6),
(7, 'Romantikus vígjátékok', '2024-02-12', '2024-02-18', 7),
(8, 'Bűnügyi drámák', '2024-02-19', '2024-02-25', 8),
(9, 'Horror filmek', '2024-02-26', '2024-03-03', 9),
(10, 'Művészfilmek', '2024-03-04', '2024-03-10', 10);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `terem`
--

CREATE TABLE `terem` (
  `TeremId` int(11) NOT NULL,
  `TeremNeve` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `terem`
--

INSERT INTO `terem` (`TeremId`, `TeremNeve`) VALUES
(1, '1'),
(2, '2'),
(3, '3'),
(4, '4'),
(5, '5');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `vetites`
--

CREATE TABLE `vetites` (
  `VetitesId` int(11) NOT NULL,
  `FilmId` int(11) DEFAULT NULL,
  `Datum` datetime DEFAULT NULL,
  `Idopont` time DEFAULT NULL,
  `TeremId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `vetites`
--

INSERT INTO `vetites` (`VetitesId`, `FilmId`, `Datum`, `Idopont`, `TeremId`) VALUES
(1, 1, '2024-01-05 00:00:00', '14:00:00', 1),
(2, 2, '2024-01-10 00:00:00', '18:30:00', 3),
(3, 3, '2024-02-15 00:00:00', '20:00:00', 2),
(4, 4, '2024-03-20 00:00:00', '16:45:00', 5),
(5, 5, '2024-04-25 00:00:00', '21:15:00', 4),
(6, 6, '2024-05-30 00:00:00', '19:00:00', 1),
(7, 7, '2024-06-10 00:00:00', '17:30:00', 2),
(8, 8, '2024-07-15 00:00:00', '22:00:00', 3),
(9, 9, '2024-08-05 00:00:00', '15:45:00', 5),
(10, 10, '2024-09-10 00:00:00', '20:30:00', 4),
(11, 1, '2024-10-20 00:00:00', '19:00:00', 1),
(12, 2, '2024-11-25 00:00:00', '18:00:00', 2),
(13, 3, '2024-12-05 00:00:00', '14:30:00', 3),
(14, 4, '2025-01-05 00:00:00', '21:00:00', 5),
(15, 5, '2025-01-10 00:00:00', '17:15:00', 4),
(16, 6, '2025-01-15 00:00:00', '19:45:00', 1),
(17, 7, '2025-01-18 00:00:00', '20:30:00', 2),
(18, 8, '2025-01-20 00:00:00', '22:15:00', 3),
(19, 9, '2025-01-22 00:00:00', '15:30:00', 5),
(20, 10, '2025-01-24 00:00:00', '18:45:00', 4),
(21, 1, '2025-01-25 00:00:00', '20:00:00', 1),
(22, 2, '2025-01-25 00:00:00', '19:30:00', 2),
(23, 3, '2025-01-25 00:00:00', '21:45:00', 3),
(24, 4, '2025-01-25 00:00:00', '16:00:00', 5),
(25, 5, '2025-01-25 00:00:00', '18:00:00', 4),
(26, 6, '2025-01-26 00:00:00', '20:15:00', 1),
(27, 7, '2025-01-27 00:00:00', '17:30:00', 2),
(28, 8, '2025-01-28 00:00:00', '22:00:00', 3),
(29, 9, '2025-01-29 00:00:00', '15:45:00', 5),
(30, 10, '2025-01-30 00:00:00', '20:30:00', 4),
(31, 1, '2025-01-31 00:00:00', '19:00:00', 1),
(32, 2, '2025-02-01 00:00:00', '18:00:00', 2),
(33, 3, '2025-02-02 00:00:00', '14:30:00', 3),
(34, 4, '2025-02-05 00:00:00', '21:00:00', 5),
(35, 5, '2025-02-07 00:00:00', '17:15:00', 4),
(36, 6, '2025-02-10 00:00:00', '19:45:00', 1),
(37, 7, '2025-02-12 00:00:00', '20:30:00', 2),
(38, 8, '2025-02-15 00:00:00', '22:15:00', 3),
(39, 9, '2025-02-18 00:00:00', '15:30:00', 5),
(40, 10, '2025-02-20 00:00:00', '18:45:00', 4),
(41, 1, '2025-02-22 00:00:00', '20:00:00', 1),
(42, 2, '2025-02-24 00:00:00', '19:30:00', 2),
(43, 3, '2025-02-26 00:00:00', '21:45:00', 3),
(44, 4, '2025-02-28 00:00:00', '16:00:00', 5),
(45, 5, '2025-03-01 00:00:00', '18:00:00', 4);

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `comment`
--
ALTER TABLE `comment`
  ADD PRIMARY KEY (`CommentId`),
  ADD KEY `FelhasznaloId` (`FelhasznaloId`),
  ADD KEY `FilmId` (`FilmId`);

--
-- A tábla indexei `etellista`
--
ALTER TABLE `etellista`
  ADD PRIMARY KEY (`EtelID`);

--
-- A tábla indexei `felhasznalo`
--
ALTER TABLE `felhasznalo`
  ADD PRIMARY KEY (`felhasznaloId`),
  ADD UNIQUE KEY `Email` (`Email`),
  ADD KEY `SzerepKorID` (`SzerepKorID`);

--
-- A tábla indexei `film`
--
ALTER TABLE `film`
  ADD PRIMARY KEY (`FilmId`),
  ADD KEY `RendezoID` (`RendezoID`);

--
-- A tábla indexei `filmgenre`
--
ALTER TABLE `filmgenre`
  ADD KEY `FilmID` (`FilmID`),
  ADD KEY `GenreID` (`GenreID`);

--
-- A tábla indexei `filmszinesz`
--
ALTER TABLE `filmszinesz`
  ADD KEY `FilmID` (`FilmID`),
  ADD KEY `SzineszID` (`SzineszID`);

--
-- A tábla indexei `foglalas`
--
ALTER TABLE `foglalas`
  ADD PRIMARY KEY (`FoglalasId`),
  ADD KEY `FelhasznaloId` (`FelhasznaloId`),
  ADD KEY `VetitesId` (`VetitesId`);

--
-- A tábla indexei `foglalasszek`
--
ALTER TABLE `foglalasszek`
  ADD KEY `FoglalasId` (`FoglalasId`),
  ADD KEY `SzekId` (`SzekId`);

--
-- A tábla indexei `genre`
--
ALTER TABLE `genre`
  ADD PRIMARY KEY (`GenreID`);

--
-- A tábla indexei `rendeltetel`
--
ALTER TABLE `rendeltetel`
  ADD PRIMARY KEY (`RendeltEtelId`);

--
-- A tábla indexei `rendezo`
--
ALTER TABLE `rendezo`
  ADD PRIMARY KEY (`RendezoID`);

--
-- A tábla indexei `szavazas`
--
ALTER TABLE `szavazas`
  ADD PRIMARY KEY (`SzavazasId`);

--
-- A tábla indexei `szavazastemakor`
--
ALTER TABLE `szavazastemakor`
  ADD KEY `SzavazasId` (`SzavazasId`),
  ADD KEY `TemakorId` (`TemakorId`);

--
-- A tábla indexei `szavazat`
--
ALTER TABLE `szavazat`
  ADD PRIMARY KEY (`SzavazatId`),
  ADD KEY `SzavazasId` (`SzavazasId`),
  ADD KEY `FelhasznaloId` (`FelhasznaloId`),
  ADD KEY `ValasztottOpcio` (`ValasztottOpcio`);

--
-- A tábla indexei `szek`
--
ALTER TABLE `szek`
  ADD PRIMARY KEY (`SzekId`),
  ADD KEY `TeremId` (`TeremId`);

--
-- A tábla indexei `szerepkor`
--
ALTER TABLE `szerepkor`
  ADD PRIMARY KEY (`SzerepKorID`);

--
-- A tábla indexei `szinesz`
--
ALTER TABLE `szinesz`
  ADD PRIMARY KEY (`SzineszId`);

--
-- A tábla indexei `temakor`
--
ALTER TABLE `temakor`
  ADD PRIMARY KEY (`TemakorID`);

--
-- A tábla indexei `tematikushet`
--
ALTER TABLE `tematikushet`
  ADD PRIMARY KEY (`TematikusHetId`),
  ADD KEY `TemakorID` (`TemakorID`);

--
-- A tábla indexei `terem`
--
ALTER TABLE `terem`
  ADD PRIMARY KEY (`TeremId`);

--
-- A tábla indexei `vetites`
--
ALTER TABLE `vetites`
  ADD PRIMARY KEY (`VetitesId`),
  ADD KEY `FilmId` (`FilmId`),
  ADD KEY `TeremId` (`TeremId`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `comment`
--
ALTER TABLE `comment`
  MODIFY `CommentId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT a táblához `etellista`
--
ALTER TABLE `etellista`
  MODIFY `EtelID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT a táblához `felhasznalo`
--
ALTER TABLE `felhasznalo`
  MODIFY `felhasznaloId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT a táblához `film`
--
ALTER TABLE `film`
  MODIFY `FilmId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT a táblához `foglalas`
--
ALTER TABLE `foglalas`
  MODIFY `FoglalasId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT a táblához `genre`
--
ALTER TABLE `genre`
  MODIFY `GenreID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT a táblához `rendeltetel`
--
ALTER TABLE `rendeltetel`
  MODIFY `RendeltEtelId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT a táblához `rendezo`
--
ALTER TABLE `rendezo`
  MODIFY `RendezoID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT a táblához `szavazas`
--
ALTER TABLE `szavazas`
  MODIFY `SzavazasId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT a táblához `szavazat`
--
ALTER TABLE `szavazat`
  MODIFY `SzavazatId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT a táblához `szek`
--
ALTER TABLE `szek`
  MODIFY `SzekId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=501;

--
-- AUTO_INCREMENT a táblához `szinesz`
--
ALTER TABLE `szinesz`
  MODIFY `SzineszId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT a táblához `temakor`
--
ALTER TABLE `temakor`
  MODIFY `TemakorID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT a táblához `tematikushet`
--
ALTER TABLE `tematikushet`
  MODIFY `TematikusHetId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT a táblához `terem`
--
ALTER TABLE `terem`
  MODIFY `TeremId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT a táblához `vetites`
--
ALTER TABLE `vetites`
  MODIFY `VetitesId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- Megkötések a kiírt táblákhoz
--

--
-- Megkötések a táblához `comment`
--
ALTER TABLE `comment`
  ADD CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`FelhasznaloId`) REFERENCES `felhasznalo` (`felhasznaloId`),
  ADD CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`FilmId`) REFERENCES `film` (`FilmId`);

--
-- Megkötések a táblához `felhasznalo`
--
ALTER TABLE `felhasznalo`
  ADD CONSTRAINT `felhasznalo_ibfk_1` FOREIGN KEY (`SzerepKorID`) REFERENCES `szerepkor` (`SzerepKorID`);

--
-- Megkötések a táblához `film`
--
ALTER TABLE `film`
  ADD CONSTRAINT `film_ibfk_1` FOREIGN KEY (`RendezoID`) REFERENCES `rendezo` (`RendezoID`);

--
-- Megkötések a táblához `filmgenre`
--
ALTER TABLE `filmgenre`
  ADD CONSTRAINT `filmgenre_ibfk_1` FOREIGN KEY (`FilmID`) REFERENCES `film` (`FilmId`),
  ADD CONSTRAINT `filmgenre_ibfk_2` FOREIGN KEY (`GenreID`) REFERENCES `genre` (`GenreID`);

--
-- Megkötések a táblához `filmszinesz`
--
ALTER TABLE `filmszinesz`
  ADD CONSTRAINT `filmszinesz_ibfk_1` FOREIGN KEY (`FilmID`) REFERENCES `film` (`FilmId`),
  ADD CONSTRAINT `filmszinesz_ibfk_2` FOREIGN KEY (`SzineszID`) REFERENCES `szinesz` (`SzineszId`);

--
-- Megkötések a táblához `foglalas`
--
ALTER TABLE `foglalas`
  ADD CONSTRAINT `foglalas_ibfk_1` FOREIGN KEY (`FelhasznaloId`) REFERENCES `felhasznalo` (`felhasznaloId`),
  ADD CONSTRAINT `foglalas_ibfk_2` FOREIGN KEY (`VetitesId`) REFERENCES `vetites` (`VetitesId`);

--
-- Megkötések a táblához `foglalasszek`
--
ALTER TABLE `foglalasszek`
  ADD CONSTRAINT `foglalasszek_ibfk_1` FOREIGN KEY (`FoglalasId`) REFERENCES `foglalas` (`FoglalasId`),
  ADD CONSTRAINT `foglalasszek_ibfk_2` FOREIGN KEY (`SzekId`) REFERENCES `szek` (`SzekId`);

--
-- Megkötések a táblához `szavazastemakor`
--
ALTER TABLE `szavazastemakor`
  ADD CONSTRAINT `szavazastemakor_ibfk_1` FOREIGN KEY (`SzavazasId`) REFERENCES `szavazas` (`SzavazasId`),
  ADD CONSTRAINT `szavazastemakor_ibfk_2` FOREIGN KEY (`TemakorId`) REFERENCES `temakor` (`TemakorID`);

--
-- Megkötések a táblához `szavazat`
--
ALTER TABLE `szavazat`
  ADD CONSTRAINT `szavazat_ibfk_1` FOREIGN KEY (`SzavazasId`) REFERENCES `szavazas` (`SzavazasId`),
  ADD CONSTRAINT `szavazat_ibfk_2` FOREIGN KEY (`FelhasznaloId`) REFERENCES `felhasznalo` (`felhasznaloId`),
  ADD CONSTRAINT `szavazat_ibfk_3` FOREIGN KEY (`ValasztottOpcio`) REFERENCES `temakor` (`TemakorID`);

--
-- Megkötések a táblához `szek`
--
ALTER TABLE `szek`
  ADD CONSTRAINT `szek_ibfk_1` FOREIGN KEY (`TeremId`) REFERENCES `terem` (`TeremId`);

--
-- Megkötések a táblához `tematikushet`
--
ALTER TABLE `tematikushet`
  ADD CONSTRAINT `tematikushet_ibfk_1` FOREIGN KEY (`TemakorID`) REFERENCES `temakor` (`TemakorID`);

--
-- Megkötések a táblához `vetites`
--
ALTER TABLE `vetites`
  ADD CONSTRAINT `vetites_ibfk_1` FOREIGN KEY (`FilmId`) REFERENCES `film` (`FilmId`),
  ADD CONSTRAINT `vetites_ibfk_2` FOREIGN KEY (`TeremId`) REFERENCES `terem` (`TeremId`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
