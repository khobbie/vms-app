-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 03, 2022 at 08:52 PM
-- Server version: 10.4.22-MariaDB
-- PHP Version: 8.1.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `vms_db`
--

DELIMITER $$
--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `company_id_generator_func` () RETURNS INT(11) BEGIN

 declare company_id int;
 declare checker_d int;
 declare count_d int;
 

   SET checker_d = 'true';
   SET count_d = 0;

   company_id_loop:LOOP
     
	 select floor(1000000 + RAND() * 9999999) INTO company_id ; 
	 
	 SELECT count(c.id) INTO count_d 
	 FROM companies c 
	 WHERE c.company_id = company_id;
	 
	 IF count_d > 0 THEN
        ITERATE company_id_loop;
	 ELSE
	 	LEAVE company_id_loop;
	 END IF;
	 
   end loop company_id_loop;

   RETURN company_id;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `branches`
--

CREATE TABLE `branches` (
  `id` int(15) NOT NULL,
  `uuid` varchar(50) DEFAULT NULL,
  `company_id` varchar(50) NOT NULL,
  `name` varchar(225) NOT NULL,
  `description` text DEFAULT NULL,
  `location` varchar(225) DEFAULT NULL,
  `created_by` varchar(30) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `branches`
--

INSERT INTO `branches` (`id`, `uuid`, `company_id`, `name`, `description`, `location`, `created_by`, `created_at`, `updated_at`) VALUES
(1, 'yhke-383jks-djueo-eujd', '00000', 'Accra, Ghana Branch', 'Collection of money point', '235 Laterbikorshie Ponpon Links, Oblogo Road', 'kwabena', NULL, '2022-03-09 15:28:36');

--
-- Triggers `branches`
--
DELIMITER $$
CREATE TRIGGER `branches_uuid_generate_trig` BEFORE INSERT ON `branches` FOR EACH ROW SET new.uuid = replace(uuid(), '-', '')
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `uuid` varchar(120) DEFAULT NULL,
  `company_id` varchar(30) NOT NULL,
  `name` varchar(225) NOT NULL,
  `description` text DEFAULT NULL,
  `is_selected` varchar(5) NOT NULL DEFAULT 'YES',
  `created_by` varchar(225) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `uuid`, `company_id`, `name`, `description`, `is_selected`, `created_by`, `created_at`, `updated_at`) VALUES
(1, '972aefd99fbe11ecb82354ee75bcf4ce', '00000', 'Customer Complaince', 'My money is missing from bank account', 'YES', 'Joy', '2022-03-09 15:33:22', '2022-03-09 15:31:33');

--
-- Triggers `categories`
--
DELIMITER $$
CREATE TRIGGER `departments_uuid_generate_trig` BEFORE INSERT ON `categories` FOR EACH ROW SET new.uuid = replace(uuid(), '-', '')
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `companies`
--

CREATE TABLE `companies` (
  `id` int(15) NOT NULL,
  `uuid` varchar(50) NOT NULL,
  `company_id` varchar(20) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `bearer_token` text NOT NULL,
  `onboarding_id` varchar(20) DEFAULT NULL,
  `country` varchar(170) DEFAULT NULL,
  `dail_code` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `companies`
--

INSERT INTO `companies` (`id`, `uuid`, `company_id`, `name`, `bearer_token`, `onboarding_id`, `country`, `dail_code`) VALUES
(1, '98b1e0bb9cd411ecb82354ee75bcf4ce', '00000', 'Union Systems Global', 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI5MjM5Y2Q4MC05NjViLTQ3YjUtODE3Ni1mOTI3YWViYTk4NmIiLCJqdGkiOiIyMDcxNTU0MmFmY2I2ZDE4YjVhOTc5NTkyMzU0ZmVjOTFmMDk2ZTExNGMzOTFlOThkNDIxNjNiYzcyZGUwMTE4NGI4MTNhNWJlOTc4OGU5MCIsImlhdCI6MTYwNzc2OTc1NywibmJmIjoxNjA3NzY5NzU3LCJleHAiOjE2MzkzMDU3NTcsInN1YiI6IiIsInNjb3BlcyI6WyJncHMiXX0.QgRsUWYMVHDD80SokvdD0KptYKmCI5GHOW-fbxxp3kLdvINiZTq0gHrhd1FuRABIlkaMJoBdr2tDq0JnuAXgIMQVaFPW1pN5DyYuwuxcyJWcSSs7XUViLOY4HjJiDPa3mynk-SB4JlSDllGLTUfhKDnAjAzfuMSuERyRxMqUvg6MRHZZlteMBBRU-FpAMEVg4KYofv4fxz_VMb3Fw-GD9hFaa4z-1ax5fAoYbAMvoI0KOHgU_EiD_2bsxpHxQjIhHnzPpJ54zVr_9rBsabn_zEtVqzGznfO6cxhmEoizDv3lqUMLop7fuuFexyOHrlq68KoNjG5-jdfyAgqKXJ5RKtxBOPW5BavQAo7CwjiwHSDQhnB1H96iwLoo9h5hs8-xfWCz6B0Mb7lk8Qg3T2yL6abA-6cFaJl1YRlyVnGlf8HabEz7QJOcSyw6vi6Aqo9xzuHmNWkuCdgQdeUqniaN_Z6QfCgiTkhZUfTIsPNGK-DV3PCqTq3tnOJhY1DSFmehesocYPx4KX9C0Ls6e8z6pIwW6FPn4p3tYXLkD4SKnHOJKZK_rsrKU20DYHy7Wsdl9FitJ5htdDGxJyHe_1Ftyb0HlCQUKdRHq4pBy6Xxp4qm5AYq4sh1YxGcdVlvIr3cHrBZhjZE4J79MH3lPOcF5NX9Bnpq3Mw7KBB4bQ-8vH4', '11111', 'Ghana', '233');

--
-- Triggers `companies`
--
DELIMITER $$
CREATE TRIGGER `companies_id_generator_trg` BEFORE INSERT ON `companies` FOR EACH ROW SET new.uuid = replace(uuid(), '-', ''),  NEW.company_id =  (SELECT company_id_generator_func())
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `countries`
--

CREATE TABLE `countries` (
  `id` int(11) NOT NULL,
  `uuid` varchar(50) DEFAULT NULL,
  `country_code` varchar(5) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `dail_code` varchar(6) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `countries`
--

INSERT INTO `countries` (`id`, `uuid`, `country_code`, `country`, `dail_code`, `created_at`, `updated_at`) VALUES
(2, 'fa9d466b9fc611ecb82354ee75bcf4ce', 'BRN', 'Brunei', '673', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(3, 'fa9e292c9fc611ecb82354ee75bcf4ce', 'BDI', 'Burundi', '257', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(4, 'fa9eb63f9fc611ecb82354ee75bcf4ce', 'CPV', 'Cape Verde', '238', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(5, 'fa9f5fec9fc611ecb82354ee75bcf4ce', 'GUY', 'Guyana', '592', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(6, 'faa003bd9fc611ecb82354ee75bcf4ce', 'DZA', 'Algeria', '213', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(7, 'faa0bf1d9fc611ecb82354ee75bcf4ce', 'BHS', 'Bahamas', '1242', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(8, 'faa159ec9fc611ecb82354ee75bcf4ce', 'BGD', 'Bangladesh', '880', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(9, 'faa209c29fc611ecb82354ee75bcf4ce', 'BLZ', 'Belize', '501', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(10, 'faa2a4f69fc611ecb82354ee75bcf4ce', 'COK', 'Cook Islands', '682', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(11, 'faa360429fc611ecb82354ee75bcf4ce', 'DJI', 'Djibouti', '253', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(12, 'faa3f0c69fc611ecb82354ee75bcf4ce', 'BTN', 'Bhutan', '975', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(13, 'faa49f479fc611ecb82354ee75bcf4ce', 'ETH', 'Ethiopia', '251', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(14, 'faa55e709fc611ecb82354ee75bcf4ce', 'FLK', 'Falkland Islands', '500', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(15, 'faa64a3d9fc611ecb82354ee75bcf4ce', 'FJI', 'Fiji', '679', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(16, 'faa6dbbf9fc611ecb82354ee75bcf4ce', 'HKG', 'Hong Kong', '852', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(17, 'faa7790b9fc611ecb82354ee75bcf4ce', 'JOR', 'Jordan', '962', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(18, 'faa835ab9fc611ecb82354ee75bcf4ce', 'SWZ', 'Swaziland', '268', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(19, 'faa90b8e9fc611ecb82354ee75bcf4ce', 'CHE', 'Switzerland', '41', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(20, 'faa9aa839fc611ecb82354ee75bcf4ce', 'CUW', 'Curaçao', NULL, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(21, 'faaa81419fc611ecb82354ee75bcf4ce', 'MDA', 'Moldova', '373', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(22, 'faab3d549fc611ecb82354ee75bcf4ce', 'MNG', 'Mongolia', '976', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(23, 'faabf3889fc611ecb82354ee75bcf4ce', 'NPL', 'Nepal', '977', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(24, 'faacab149fc611ecb82354ee75bcf4ce', 'PHL', 'Philippines', '63', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(25, 'faad2b899fc611ecb82354ee75bcf4ce', 'KAZ', 'Kazakhstan', '77', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(26, 'faadda3b9fc611ecb82354ee75bcf4ce', 'KGZ', 'Kyrgyzstan', '996', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(27, 'faae72539fc611ecb82354ee75bcf4ce', 'MAC', 'Macao', '853', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(28, 'faaefc719fc611ecb82354ee75bcf4ce', 'SRB', 'Serbia', '381', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(29, 'faaf7a909fc611ecb82354ee75bcf4ce', 'GGY', 'Guernsey', '44', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(30, 'fab000e79fc611ecb82354ee75bcf4ce', 'PRY', 'Paraguay', '595', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(31, 'fab08dea9fc611ecb82354ee75bcf4ce', 'SHN', 'Saint Helena', '290', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(32, 'fab15a3d9fc611ecb82354ee75bcf4ce', 'STP', 'São Tomé and Príncipe', '239', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(33, 'fab20c2b9fc611ecb82354ee75bcf4ce', 'SLB', 'Solomon Islands', '677', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(34, 'fab2b53c9fc611ecb82354ee75bcf4ce', 'ZAF', 'South Africa', '27', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(35, 'fab349699fc611ecb82354ee75bcf4ce', 'KOR', 'South Korea', '82', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(36, 'fab3f1b39fc611ecb82354ee75bcf4ce', 'TZA', 'Tanzania', '255', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(37, 'fab4a3c99fc611ecb82354ee75bcf4ce', 'TKM', 'Turkmenistan', '993', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(38, 'fab553259fc611ecb82354ee75bcf4ce', 'UKR', 'Ukraine', '380', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(39, 'fab5f5c39fc611ecb82354ee75bcf4ce', 'VUT', 'Vanuatu', '678', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(40, 'fab696ba9fc611ecb82354ee75bcf4ce', 'VNM', 'Vietnam', '84', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(41, 'fab7330b9fc611ecb82354ee75bcf4ce', 'SXM', 'Sint Maarten', '1721', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(42, 'fab7b9d79fc611ecb82354ee75bcf4ce', 'SSD', 'South Sudan', '211', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(43, 'fab846909fc611ecb82354ee75bcf4ce', 'BMU', 'Bermuda', '1441', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(44, 'fab8ea4a9fc611ecb82354ee75bcf4ce', 'CYM', 'Cayman Islands', '1345', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(45, 'fab988c09fc611ecb82354ee75bcf4ce', 'COM', 'Comoros', '269', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(46, 'faba23f79fc611ecb82354ee75bcf4ce', 'NCL', 'New Caledonia', '687', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(47, 'fabacdd79fc611ecb82354ee75bcf4ce', 'SAU', 'Saudi Arabia', '966', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(48, 'fabb68699fc611ecb82354ee75bcf4ce', 'HRV', 'Croatia', '385', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(49, 'fabc03409fc611ecb82354ee75bcf4ce', 'CZE', 'Czech Republic', '420', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(50, 'fabc96cd9fc611ecb82354ee75bcf4ce', 'ZWE', 'Zimbabwe', '263', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(51, 'fabd57149fc611ecb82354ee75bcf4ce', 'COD', 'Congo, Democratic Republic', '243', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(52, 'fabdf5449fc611ecb82354ee75bcf4ce', 'ERI', 'Eritrea', '291', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(53, 'fabe93f09fc611ecb82354ee75bcf4ce', 'GEO', 'Georgia', '995', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(54, 'fabf402f9fc611ecb82354ee75bcf4ce', 'GIB', 'Gibraltar', '350', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(55, 'fabfcb7d9fc611ecb82354ee75bcf4ce', 'MWI', 'Malawi', '265', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(56, 'fac0901e9fc611ecb82354ee75bcf4ce', 'MRT', 'Mauritania', '222', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(57, 'fac131799fc611ecb82354ee75bcf4ce', 'NAM', 'Namibia', '264', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(58, 'fac1b3279fc611ecb82354ee75bcf4ce', 'NZL', 'New Zealand', '64', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(59, 'fac239a29fc611ecb82354ee75bcf4ce', 'PNG', 'Papua New Guinea', '675', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(60, 'fac2c8269fc611ecb82354ee75bcf4ce', 'JEY', 'Jersey', '44', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(61, 'fac3502d9fc611ecb82354ee75bcf4ce', 'AND', 'AD', '376', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(62, 'fac3dc2d9fc611ecb82354ee75bcf4ce', 'CAF', 'Central African Republic', '236', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(63, 'fac474039fc611ecb82354ee75bcf4ce', 'TLS', 'Timor Leste', '670', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(64, 'fac51db59fc611ecb82354ee75bcf4ce', 'GUF', 'French Guiana', '594', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(65, 'fac5baa79fc611ecb82354ee75bcf4ce', 'GRL', 'Greenland', '299', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(66, 'fac65acd9fc611ecb82354ee75bcf4ce', 'CIV', 'Côte d’Ivoire', '225', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(67, 'fac702129fc611ecb82354ee75bcf4ce', 'KEN', 'Kenya', '254', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(68, 'fac79d9f9fc611ecb82354ee75bcf4ce', 'MKD', 'Macedonia', '389', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(69, 'fac833db9fc611ecb82354ee75bcf4ce', 'MOZ', 'Mozambique', '258', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(70, 'fac8c2349fc611ecb82354ee75bcf4ce', 'PAK', 'Pakistan', '92', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(71, 'fac989279fc611ecb82354ee75bcf4ce', 'COG', 'Congo, Republic', '242', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(72, 'faca46849fc611ecb82354ee75bcf4ce', 'SDN', 'Sudan', '249', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(73, 'facae10b9fc611ecb82354ee75bcf4ce', 'TTO', 'Trinidad and Tobago', '1868', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(74, 'facb76539fc611ecb82354ee75bcf4ce', 'TUN', 'Tunisia', '216', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(75, 'facc01229fc611ecb82354ee75bcf4ce', 'TCA', 'Turks and Caicos Islands', '1649', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(76, 'facc98b19fc611ecb82354ee75bcf4ce', 'GBR', 'United Kingdom', '44', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(77, 'facd42a59fc611ecb82354ee75bcf4ce', 'UZB', 'Uzbekistan', '998', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(78, 'face10159fc611ecb82354ee75bcf4ce', 'IMN', 'Isle of Man', '44', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(79, 'facebc6b9fc611ecb82354ee75bcf4ce', 'MNE', 'Montenegro', '382', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(80, 'facf42a89fc611ecb82354ee75bcf4ce', 'AFG', 'Afghanistan', '93', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(81, 'facfd7289fc611ecb82354ee75bcf4ce', 'ALB', 'Albania', '355', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(82, 'fad06ef19fc611ecb82354ee75bcf4ce', 'AGO', 'Angola', '244', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(83, 'fad1075c9fc611ecb82354ee75bcf4ce', 'ARG', 'Argentina', '54', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(84, 'fad19e1a9fc611ecb82354ee75bcf4ce', 'GLP', 'Guadeloupe', '590', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(85, 'fad24fb49fc611ecb82354ee75bcf4ce', 'WLF', 'Wallis and Futuna Islands', '681', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(86, 'fad2fd9f9fc611ecb82354ee75bcf4ce', 'ABW', 'Aruba', '297', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(87, 'fad3a4d09fc611ecb82354ee75bcf4ce', 'AZE', 'Azerbaijan', '994', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(88, 'fad463549fc611ecb82354ee75bcf4ce', 'BRA', 'Brazil', '55', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(89, 'fad5059a9fc611ecb82354ee75bcf4ce', 'MHL', 'Marshall Islands', '692', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(90, 'fad599669fc611ecb82354ee75bcf4ce', 'VGB', 'Virgin Islands (UK)', '1284', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(91, 'fad62eb79fc611ecb82354ee75bcf4ce', 'FRA', 'France', '33', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(92, 'fad6c2669fc611ecb82354ee75bcf4ce', 'GUM', 'Guam', '1671', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(93, 'fad7670e9fc611ecb82354ee75bcf4ce', 'JAM', 'Jamaica', '1876', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(94, 'fad812a89fc611ecb82354ee75bcf4ce', 'MNP', 'Northern Mariana Islands', '1670', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(95, 'fad8a7279fc611ecb82354ee75bcf4ce', 'PLW', 'Palau', '680', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(96, 'fad94a689fc611ecb82354ee75bcf4ce', 'VIR', 'Virgin Islands (US)', '1340', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(97, 'fad9d4269fc611ecb82354ee75bcf4ce', 'AUS', 'Australia', '61', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(98, 'fada60f79fc611ecb82354ee75bcf4ce', 'BHR', 'Bahrain', '973', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(99, 'fadaf4189fc611ecb82354ee75bcf4ce', 'BLR', 'Belarus', '375', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(100, 'fadba5909fc611ecb82354ee75bcf4ce', 'CYP', 'Cyprus', '357', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(101, 'fadc40e39fc611ecb82354ee75bcf4ce', 'KIR', 'Kiribati', '686', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(102, 'fadcd4b49fc611ecb82354ee75bcf4ce', 'MTQ', 'Martinique', '596', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(103, 'fadd6e4a9fc611ecb82354ee75bcf4ce', 'FSM', 'Micronesia', '691', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(104, 'fade36909fc611ecb82354ee75bcf4ce', 'MSR', 'Montserrat', '1664', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(105, 'fadec4709fc611ecb82354ee75bcf4ce', 'POL', 'Poland', '48', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(106, 'fadf5cae9fc611ecb82354ee75bcf4ce', 'PRI', 'Puerto Rico', '1939', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(107, 'fadff4f59fc611ecb82354ee75bcf4ce', 'KNA', 'Saint Kitts and Nevis', '1869', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(108, 'fae0a9b29fc611ecb82354ee75bcf4ce', 'LCA', 'Saint Lucia', '1758', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(109, 'fae16d299fc611ecb82354ee75bcf4ce', 'ESP', 'Spain', '34', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(110, 'fae2199f9fc611ecb82354ee75bcf4ce', 'KSV', 'Kosovo', '383', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(111, 'fae2dd029fc611ecb82354ee75bcf4ce', 'ASM', 'American Samoa', '1684', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(112, 'fae387529fc611ecb82354ee75bcf4ce', 'AIA', 'Anguilla', '1264', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(113, 'fae432ca9fc611ecb82354ee75bcf4ce', 'AUT', 'Austria', '43', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(114, 'fae4c4289fc611ecb82354ee75bcf4ce', 'MAR', 'Morocco', '212', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(115, 'fae5559e9fc611ecb82354ee75bcf4ce', 'KHM', 'Cambodia', '855', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(116, 'fae5e7b19fc611ecb82354ee75bcf4ce', 'ECU', 'Ecuador', '593', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(117, 'fae66dc69fc611ecb82354ee75bcf4ce', 'SPM', 'Saint Pierre and Miquelon', '508', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(118, 'fae702239fc611ecb82354ee75bcf4ce', 'CUB', 'Cuba', '53', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(119, 'fae7c8bd9fc611ecb82354ee75bcf4ce', 'DNK', 'Denmark', '45', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(120, 'fae8a01f9fc611ecb82354ee75bcf4ce', 'DMA', 'Dominica', '1767', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(121, 'fae9389b9fc611ecb82354ee75bcf4ce', 'MYS', 'Malaysia', '60', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(122, 'fae9cd019fc611ecb82354ee75bcf4ce', 'MDV', 'Maldives', '960', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(123, 'faea73de9fc611ecb82354ee75bcf4ce', 'NIC', 'Nicaragua', '505', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(124, 'faeb3d2d9fc611ecb82354ee75bcf4ce', 'VCT', 'St Vincent and Grenadines', '1784', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(125, 'faebd4f49fc611ecb82354ee75bcf4ce', 'SYC', 'Seychelles', '248', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(126, 'faec744e9fc611ecb82354ee75bcf4ce', 'ATG', 'Antigua and Barbuda', '1268', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(127, 'faed03d29fc611ecb82354ee75bcf4ce', 'ARM', 'Armenia', '374', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(128, 'faedaaab9fc611ecb82354ee75bcf4ce', 'BRB', 'Barbados', '1246', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(129, 'faee3eaa9fc611ecb82354ee75bcf4ce', 'BEL', 'Belgium', '32', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(130, 'faeed6b49fc611ecb82354ee75bcf4ce', 'BEN', 'Benin', '229', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(131, 'faef6b139fc611ecb82354ee75bcf4ce', 'BIH', 'Bosnia and Herzegovina', '387', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(132, 'faeffe319fc611ecb82354ee75bcf4ce', 'PRT', 'Portugal', '351', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(133, 'faf095f19fc611ecb82354ee75bcf4ce', 'LKA', 'Sri Lanka', '94', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(134, 'faf11d679fc611ecb82354ee75bcf4ce', 'USA', 'United States', '1', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(135, 'faf1c05d9fc611ecb82354ee75bcf4ce', 'TUR', 'Turkey', '90', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(136, 'faf263e49fc611ecb82354ee75bcf4ce', 'VAT', 'Vatican City', '379', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(137, 'faf2f1539fc611ecb82354ee75bcf4ce', 'BES', 'Bonaire', NULL, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(138, 'faf386b39fc611ecb82354ee75bcf4ce', 'REU', 'Réunion', '262', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(139, 'faf425529fc611ecb82354ee75bcf4ce', 'SMR', 'San Marino', '378', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(140, 'faf4be849fc611ecb82354ee75bcf4ce', 'SGP', 'Singapore', '65', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(141, 'faf565f69fc611ecb82354ee75bcf4ce', 'SVK', 'Slovakia', '421', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(142, 'faf6105b9fc611ecb82354ee75bcf4ce', 'BOL', 'Bolivia', '591', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(143, 'faf6a6269fc611ecb82354ee75bcf4ce', 'BWA', 'Botswana', '267', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(144, 'faf73bd19fc611ecb82354ee75bcf4ce', 'BGR', 'Bulgaria', '359', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(145, 'faf7d66a9fc611ecb82354ee75bcf4ce', 'EGY', 'Egypt', '20', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(146, 'faf863739fc611ecb82354ee75bcf4ce', 'BFA', 'Burkina Faso', '226', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(147, 'faf8ef719fc611ecb82354ee75bcf4ce', 'CMR', 'Cameroon', '237', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(148, 'faf974239fc611ecb82354ee75bcf4ce', 'CAN', 'Canada', '1', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(149, 'fafa149b9fc611ecb82354ee75bcf4ce', 'CHL', 'Chile', '56', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(150, 'fafa9baf9fc611ecb82354ee75bcf4ce', 'CHN', 'China', '86', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(151, 'fafbb1939fc611ecb82354ee75bcf4ce', 'COL', 'Colombia', '57', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(152, 'fafd00529fc611ecb82354ee75bcf4ce', 'CRI', 'Costa Rica', '506', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(153, 'fafe14e19fc611ecb82354ee75bcf4ce', 'DOM', 'Dominican Republic', '1849', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(154, 'faff4bb69fc611ecb82354ee75bcf4ce', 'SLV', 'El Salvador', '503', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(155, 'fafff4f39fc611ecb82354ee75bcf4ce', 'GNQ', 'Equatorial Guinea', '240', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(156, 'fb009c1c9fc611ecb82354ee75bcf4ce', 'EST', 'Estonia', '372', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(157, 'fb0138b39fc611ecb82354ee75bcf4ce', 'FRO', 'Faroe Islands', '298', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(158, 'fb01f61c9fc611ecb82354ee75bcf4ce', 'FIN', 'Finland', '358', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(159, 'fb0296e39fc611ecb82354ee75bcf4ce', 'PYF', 'French Polynesia', '689', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(160, 'fb03528d9fc611ecb82354ee75bcf4ce', 'GAB', 'Gabon', '241', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(161, 'fb04057b9fc611ecb82354ee75bcf4ce', 'GMB', 'Gambia', '220', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(162, 'fb04c0889fc611ecb82354ee75bcf4ce', 'DEU', 'Germany', '49', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(163, 'fb05cf229fc611ecb82354ee75bcf4ce', 'IRL', 'Ireland', '353', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(164, 'fb065cf59fc611ecb82354ee75bcf4ce', 'GHA', 'Ghana', '233', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(165, 'fb0721489fc611ecb82354ee75bcf4ce', 'GRC', 'Greece', '30', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(166, 'fb07bf5b9fc611ecb82354ee75bcf4ce', 'GTM', 'Guatemala', '502', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(167, 'fb085b539fc611ecb82354ee75bcf4ce', 'GIN', 'Guinea', '224', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(168, 'fb08f2689fc611ecb82354ee75bcf4ce', 'GNB', 'Guinea Bissau', '245', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(169, 'fb099b9d9fc611ecb82354ee75bcf4ce', 'HTI', 'Haiti', '509', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(170, 'fb0a27509fc611ecb82354ee75bcf4ce', 'HND', 'Honduras', '504', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(171, 'fb0ab9589fc611ecb82354ee75bcf4ce', 'HUN', 'Hungary', '36', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(172, 'fb0b4edf9fc611ecb82354ee75bcf4ce', 'ISL', 'Iceland', '354', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(173, 'fb0c0f2f9fc611ecb82354ee75bcf4ce', 'IND', 'India', '91', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(174, 'fb0cb2999fc611ecb82354ee75bcf4ce', 'IDN', 'Indonesia', '62', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(175, 'fb0d31259fc611ecb82354ee75bcf4ce', 'IRN', 'Iran', '98', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(176, 'fb0dc8cf9fc611ecb82354ee75bcf4ce', 'IRQ', 'Iraq', '964', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(177, 'fb0e80b59fc611ecb82354ee75bcf4ce', 'ISR', 'Israel', '972', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(178, 'fb0f10499fc611ecb82354ee75bcf4ce', 'ITA', 'Italy', '39', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(179, 'fb0fa9829fc611ecb82354ee75bcf4ce', 'JPN', 'Japan', '81', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(180, 'fb104a259fc611ecb82354ee75bcf4ce', 'KWT', 'Kuwait', '965', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(181, 'fb10f1139fc611ecb82354ee75bcf4ce', 'LAO', 'Laos', '856', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(182, 'fb116eb29fc611ecb82354ee75bcf4ce', 'LVA', 'Latvia', '371', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(183, 'fb1204be9fc611ecb82354ee75bcf4ce', 'LBN', 'Lebanon', '961', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(184, 'fb12a1f89fc611ecb82354ee75bcf4ce', 'LSO', 'Lesotho', '266', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(185, 'fb13864f9fc611ecb82354ee75bcf4ce', 'LBR', 'Liberia', '231', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(186, 'fb1420339fc611ecb82354ee75bcf4ce', 'LBY', 'Libya', '218', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(187, 'fb14ac459fc611ecb82354ee75bcf4ce', 'LIE', 'Liechtenstein', '423', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(188, 'fb1559f89fc611ecb82354ee75bcf4ce', 'LTU', 'Lithuania', '370', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(189, 'fb16108c9fc611ecb82354ee75bcf4ce', 'LUX', 'Luxembourg', '352', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(190, 'fb16a8179fc611ecb82354ee75bcf4ce', 'MDG', 'Madagascar', '261', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(191, 'fb173f1c9fc611ecb82354ee75bcf4ce', 'MLI', 'Mali', '223', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(192, 'fb17d4999fc611ecb82354ee75bcf4ce', 'MLT', 'Malta', '356', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(193, 'fb18761b9fc611ecb82354ee75bcf4ce', 'RUS', 'Russia', '7', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(194, 'fb1914209fc611ecb82354ee75bcf4ce', 'MUS', 'Mauritius', '230', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(195, 'fb19b5bb9fc611ecb82354ee75bcf4ce', 'NLD', 'Netherlands', '31', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(196, 'fb1a5e7c9fc611ecb82354ee75bcf4ce', 'MEX', 'Mexico', '52', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(197, 'fb1af9849fc611ecb82354ee75bcf4ce', 'MCO', 'Monaco', '377', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(198, 'fb1b98e39fc611ecb82354ee75bcf4ce', 'MMR', 'Myanmar', '95', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(199, 'fb1c30f89fc611ecb82354ee75bcf4ce', 'NRU', 'Nauru', '674', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(200, 'fb1cc55f9fc611ecb82354ee75bcf4ce', 'NER', 'Niger', '227', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(201, 'fb1d5fb49fc611ecb82354ee75bcf4ce', 'NGA', 'Nigeria', '234', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(202, 'fb1dfeef9fc611ecb82354ee75bcf4ce', 'PRK', 'North Korea', '850', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(203, 'fb1e956e9fc611ecb82354ee75bcf4ce', 'NOR', 'Norway', '47', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(204, 'fb1f5a659fc611ecb82354ee75bcf4ce', 'OMN', 'Oman', '968', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(205, 'fb2000e09fc611ecb82354ee75bcf4ce', 'PSE', 'Palestine', '970', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(206, 'fb208f5e9fc611ecb82354ee75bcf4ce', 'PAN', 'Panama', '507', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(207, 'fb2124479fc611ecb82354ee75bcf4ce', 'PER', 'Peru', '51', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(208, 'fb21cad39fc611ecb82354ee75bcf4ce', 'QAT', 'Qatar', '974', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(209, 'fb22dc209fc611ecb82354ee75bcf4ce', 'ROU', 'Romania', '40', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(210, 'fb237f169fc611ecb82354ee75bcf4ce', 'RWA', 'Rwanda', '250', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(211, 'fb2435f59fc611ecb82354ee75bcf4ce', 'WSM', 'Samoa', '685', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(212, 'fb24d9b49fc611ecb82354ee75bcf4ce', 'SEN', 'Senegal', '221', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(213, 'fb2594c09fc611ecb82354ee75bcf4ce', 'SLE', 'Sierra Leone', '232', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(214, 'fb263fb19fc611ecb82354ee75bcf4ce', 'SVN', 'Slovenia', '386', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(215, 'fb26d2099fc611ecb82354ee75bcf4ce', 'SOM', 'Somalia', '252', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(216, 'fb27a5fc9fc611ecb82354ee75bcf4ce', 'SUR', 'Suriname', '597', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(217, 'fb2898209fc611ecb82354ee75bcf4ce', 'SWE', 'Sweden', '46', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(218, 'fb29271a9fc611ecb82354ee75bcf4ce', 'SYR', 'Syria', '963', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(219, 'fb29bfd59fc611ecb82354ee75bcf4ce', 'TWN', 'Taiwan', '886', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(220, 'fb2a6a419fc611ecb82354ee75bcf4ce', 'TJK', 'Tajikistan', '992', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(221, 'fb2b0be69fc611ecb82354ee75bcf4ce', 'THA', 'Thailand', '66', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(222, 'fb2baf3e9fc611ecb82354ee75bcf4ce', 'TGO', 'Togo', '228', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(223, 'fb2c58c49fc611ecb82354ee75bcf4ce', 'TON', 'Tonga', '676', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(224, 'fb2d11c29fc611ecb82354ee75bcf4ce', 'TUV', 'Tuvalu', '688', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(225, 'fb2dad829fc611ecb82354ee75bcf4ce', 'UGA', 'Uganda', '256', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(226, 'fb2e538b9fc611ecb82354ee75bcf4ce', 'ARE', 'United Arab Emirates', '971', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(227, 'fb2ef2c49fc611ecb82354ee75bcf4ce', 'URY', 'Uruguay', '598', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(228, 'fb2f9f219fc611ecb82354ee75bcf4ce', 'VEN', 'Venezuela', '58', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(229, 'fb303a109fc611ecb82354ee75bcf4ce', 'YEM', 'Yemen', '967', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(230, 'fb31103c9fc611ecb82354ee75bcf4ce', 'ZMB', 'Zambia', '260', '0000-00-00 00:00:00', '0000-00-00 00:00:00');

--
-- Triggers `countries`
--
DELIMITER $$
CREATE TRIGGER `countries_uuid_generator_trg` BEFORE INSERT ON `countries` FOR EACH ROW SET new.uuid = replace(uuid(), '-', '')
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `id` int(11) NOT NULL,
  `uuid` varchar(100) DEFAULT NULL,
  `company_id` varchar(20) NOT NULL,
  `name` varchar(225) NOT NULL,
  `description` text DEFAULT NULL,
  `location` text DEFAULT NULL,
  `created_by` varchar(225) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `events`
--

INSERT INTO `events` (`id`, `uuid`, `company_id`, `name`, `description`, `location`, `created_by`, `created_at`, `updated_at`) VALUES
(1, '57008b3b9fbe11ecb82354ee75bcf4ce', '00000', 'Office Visitstion', 'Monday to Friday at office', 'Kasoa', '989', NULL, '2022-03-09 15:29:45');

--
-- Triggers `events`
--
DELIMITER $$
CREATE TRIGGER `events_uuid_generator_trg` BEFORE INSERT ON `events` FOR EACH ROW SET new.uuid = replace(uuid(), '-', '')
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `sms_notifications`
--

CREATE TABLE `sms_notifications` (
  `id` int(15) NOT NULL,
  `uuid` varchar(50) DEFAULT NULL,
  `who` varchar(10) DEFAULT 'VISITOR',
  `type` varchar(10) NOT NULL,
  `company_id` varchar(20) NOT NULL,
  `branch_id` varchar(50) NOT NULL,
  `event_id` varchar(50) NOT NULL,
  `country_phone_code` varchar(5) DEFAULT NULL,
  `customer_id` varchar(20) NOT NULL,
  `message` varchar(225) NOT NULL,
  `token` varchar(10) DEFAULT NULL,
  `status` varchar(10) DEFAULT 'SENT',
  `is_verified` varchar(5) DEFAULT 'NO',
  `verified_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `sms_notifications`
--
DELIMITER $$
CREATE TRIGGER `sms_notifications_uuid_generator_trg` BEFORE INSERT ON `sms_notifications` FOR EACH ROW SET new.uuid = replace(uuid(), '-', '')
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `visitor_logs`
--

CREATE TABLE `visitor_logs` (
  `id` int(15) NOT NULL,
  `uuid` varchar(100) DEFAULT NULL,
  `country_phone_code` varchar(5) NOT NULL,
  `customer_id` varchar(20) NOT NULL,
  `fullName` varchar(225) NOT NULL,
  `gender` varchar(10) DEFAULT 'MALE',
  `typeOfVisit` varchar(30) DEFAULT 'INDIVIDUAL',
  `type_description` varchar(225) DEFAULT NULL,
  `company_id` varchar(20) NOT NULL,
  `department_id` varchar(20) DEFAULT NULL,
  `branch_id` varchar(20) NOT NULL,
  `branch_device_location` text DEFAULT NULL,
  `event_id` varchar(50) DEFAULT NULL,
  `is_first_time` varchar(5) NOT NULL DEFAULT 'NO',
  `category_id` varchar(50) NOT NULL,
  `purpose_description` text DEFAULT NULL,
  `time_in` timestamp NULL DEFAULT NULL,
  `time_out` timestamp NULL DEFAULT NULL,
  `is_out` varchar(5) DEFAULT 'NO',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `visitor_logs`
--
DELIMITER $$
CREATE TRIGGER `visitor_logs_uuid_generator_trg` BEFORE INSERT ON `visitor_logs` FOR EACH ROW SET new.uuid = replace(uuid(), '-', '')
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `branches`
--
ALTER TABLE `branches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `companies`
--
ALTER TABLE `companies`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `countries`
--
ALTER TABLE `countries`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sms_notifications`
--
ALTER TABLE `sms_notifications`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `visitor_logs`
--
ALTER TABLE `visitor_logs`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `branches`
--
ALTER TABLE `branches`
  MODIFY `id` int(15) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `companies`
--
ALTER TABLE `companies`
  MODIFY `id` int(15) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `countries`
--
ALTER TABLE `countries`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=231;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `sms_notifications`
--
ALTER TABLE `sms_notifications`
  MODIFY `id` int(15) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `visitor_logs`
--
ALTER TABLE `visitor_logs`
  MODIFY `id` int(15) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
