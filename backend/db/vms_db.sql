-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 07, 2022 at 03:35 AM
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

-- --------------------------------------------------------

--
-- Table structure for table `companies`
--

CREATE TABLE `companies` (
  `id` int(15) NOT NULL,
  `uuid` varchar(50) NOT NULL,
  `company_id` varchar(20) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `bearer_token` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `companies`
--

INSERT INTO `companies` (`id`, `uuid`, `company_id`, `name`, `bearer_token`) VALUES
(1, '98b1e0bb9cd411ecb82354ee75bcf4ce', '2354726', 'VMS', 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI5MjM5Y2Q4MC05NjViLTQ3YjUtODE3Ni1mOTI3YWViYTk4NmIiLCJqdGkiOiIyMDcxNTU0MmFmY2I2ZDE4YjVhOTc5NTkyMzU0ZmVjOTFmMDk2ZTExNGMzOTFlOThkNDIxNjNiYzcyZGUwMTE4NGI4MTNhNWJlOTc4OGU5MCIsImlhdCI6MTYwNzc2OTc1NywibmJmIjoxNjA3NzY5NzU3LCJleHAiOjE2MzkzMDU3NTcsInN1YiI6IiIsInNjb3BlcyI6WyJncHMiXX0.QgRsUWYMVHDD80SokvdD0KptYKmCI5GHOW-fbxxp3kLdvINiZTq0gHrhd1FuRABIlkaMJoBdr2tDq0JnuAXgIMQVaFPW1pN5DyYuwuxcyJWcSSs7XUViLOY4HjJiDPa3mynk-SB4JlSDllGLTUfhKDnAjAzfuMSuERyRxMqUvg6MRHZZlteMBBRU-FpAMEVg4KYofv4fxz_VMb3Fw-GD9hFaa4z-1ax5fAoYbAMvoI0KOHgU_EiD_2bsxpHxQjIhHnzPpJ54zVr_9rBsabn_zEtVqzGznfO6cxhmEoizDv3lqUMLop7fuuFexyOHrlq68KoNjG5-jdfyAgqKXJ5RKtxBOPW5BavQAo7CwjiwHSDQhnB1H96iwLoo9h5hs8-xfWCz6B0Mb7lk8Qg3T2yL6abA-6cFaJl1YRlyVnGlf8HabEz7QJOcSyw6vi6Aqo9xzuHmNWkuCdgQdeUqniaN_Z6QfCgiTkhZUfTIsPNGK-DV3PCqTq3tnOJhY1DSFmehesocYPx4KX9C0Ls6e8z6pIwW6FPn4p3tYXLkD4SKnHOJKZK_rsrKU20DYHy7Wsdl9FitJ5htdDGxJyHe_1Ftyb0HlCQUKdRHq4pBy6Xxp4qm5AYq4sh1YxGcdVlvIr3cHrBZhjZE4J79MH3lPOcF5NX9Bnpq3Mw7KBB4bQ-8vH4');

--
-- Triggers `companies`
--
DELIMITER $$
CREATE TRIGGER `companies_id_generator_trg` BEFORE INSERT ON `companies` FOR EACH ROW SET new.uuid = replace(uuid(), '-', ''),  NEW.company_id =  (SELECT company_id_generator_func())
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `id` int(11) NOT NULL,
  `uuid` varchar(120) DEFAULT NULL,
  `name` varchar(225) NOT NULL,
  `description` text DEFAULT NULL,
  `is_selected` int(11) NOT NULL,
  `created_by` varchar(225) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `departments`
--
DELIMITER $$
CREATE TRIGGER `departments_uuid_generate_trig` BEFORE INSERT ON `departments` FOR EACH ROW SET new.uuid = replace(uuid(), '-', '')
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
-- Indexes for table `companies`
--
ALTER TABLE `companies`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
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
  MODIFY `id` int(15) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `companies`
--
ALTER TABLE `companies`
  MODIFY `id` int(15) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

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
