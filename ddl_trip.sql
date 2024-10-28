-- """
-- I'm preparing a class for a friend, and she loves to travel.
-- I want to create a database, that simulates real life scenarios and example, to give her examples that are similar to the one's found in the real world.

-- For that, c an you create a ddl for mysql db.
-- It should include created_at, updated_at, deleted_at and is_deleted in every table.

-- It should represent a trip plan.

-- It should have:
-- - Destinations
--   - local cusine
--   - language
-- - Points of interest (airports, hotel, someone's house)
-- - Attractions (museum, parks, places to see)
-- - Restaurants
-- - Events
-- - Destination weather (with monthly average information)
-- - Trip plan
-- - Emergency services
-- - Transportation options

-- You should add comments to the DDL file and to the columns where relevant.
-- You can name the tables as you want, but in the final system, I want to have the information listed above.,
-- """

-- Trip Planning System Database
-- Created by: Your Mentor
-- Last updated: 2024

-- Enable strict mode and UTF-8
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- -----------------------------------------------------
-- Table `countries`
-- Base table for geographical reference
-- -----------------------------------------------------
CREATE TABLE `countries` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `code` CHAR(2) NOT NULL COMMENT 'ISO 2-letter country code',
    `currency_code` CHAR(3) NOT NULL COMMENT 'ISO currency code',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_countries_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `destinations`
-- Main destination information
-- -----------------------------------------------------
CREATE TABLE `destinations` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `country_id` BIGINT UNSIGNED NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `description` TEXT,
    `timezone` VARCHAR(50) NOT NULL COMMENT 'TZ database name',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`),
    KEY `idx_destinations_country` (`country_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `local_cuisines`
-- Information about local food and culinary traditions
-- -----------------------------------------------------
CREATE TABLE `local_cuisines` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `destination_id` BIGINT UNSIGNED NOT NULL,
    `dish_name` VARCHAR(100) NOT NULL,
    `description` TEXT,
    `is_vegetarian` BOOLEAN DEFAULT FALSE,
    `is_vegan` BOOLEAN DEFAULT FALSE,
    `average_price` DECIMAL(10,2) COMMENT 'Price in local currency',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`destination_id`) REFERENCES `destinations` (`id`),
    KEY `idx_cuisines_destination` (`destination_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `languages`
-- Languages spoken at destinations
-- -----------------------------------------------------
CREATE TABLE `languages` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `code` CHAR(2) NOT NULL COMMENT 'ISO 639-1 language code',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_languages_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `destination_languages`
-- Junction table for destinations and languages
-- -----------------------------------------------------
CREATE TABLE `destination_languages` (
    `destination_id` BIGINT UNSIGNED NOT NULL,
    `language_id` BIGINT UNSIGNED NOT NULL,
    `is_primary` BOOLEAN DEFAULT FALSE COMMENT 'Indicates if this is the main language',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`destination_id`, `language_id`),
    FOREIGN KEY (`destination_id`) REFERENCES `destinations` (`id`),
    FOREIGN KEY (`language_id`) REFERENCES `languages` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `point_types`
-- Types of points of interest (airport, hotel, house, etc.)
-- -----------------------------------------------------
CREATE TABLE `point_types` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `icon` VARCHAR(100) COMMENT 'Icon file path or class',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `points_of_interest`
-- Specific locations like airports, hotels, houses
-- -----------------------------------------------------
CREATE TABLE `points_of_interest` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `destination_id` BIGINT UNSIGNED NOT NULL,
    `point_type_id` BIGINT UNSIGNED NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `address` TEXT,
    `latitude` DECIMAL(10,8),
    `longitude` DECIMAL(11,8),
    `contact_info` TEXT,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`destination_id`) REFERENCES `destinations` (`id`),
    FOREIGN KEY (`point_type_id`) REFERENCES `point_types` (`id`),
    KEY `idx_poi_destination` (`destination_id`),
    KEY `idx_poi_type` (`point_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `attraction_categories`
-- Categories for attractions (museum, park, etc.)
-- -----------------------------------------------------
CREATE TABLE `attraction_categories` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `icon` VARCHAR(100) COMMENT 'Icon file path or class',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `attractions`
-- Tourist attractions and places to visit
-- -----------------------------------------------------
CREATE TABLE `attractions` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `destination_id` BIGINT UNSIGNED NOT NULL,
    `category_id` BIGINT UNSIGNED NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `description` TEXT,
    `address` TEXT,
    `latitude` DECIMAL(10,8),
    `longitude` DECIMAL(11,8),
    `average_duration` INT COMMENT 'Duration in minutes',
    `entrance_fee` DECIMAL(10,2) COMMENT 'Fee in local currency',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`destination_id`) REFERENCES `destinations` (`id`),
    FOREIGN KEY (`category_id`) REFERENCES `attraction_categories` (`id`),
    KEY `idx_attractions_destination` (`destination_id`),
    KEY `idx_attractions_category` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `restaurants`
-- Dining establishments
-- -----------------------------------------------------
CREATE TABLE `restaurants` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `destination_id` BIGINT UNSIGNED NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `cuisine_type` VARCHAR(50),
    `price_range` ENUM('$', '$$', '$$$', '$$$$') COMMENT '$ = Budget, $$$$ = Luxury',
    `address` TEXT,
    `latitude` DECIMAL(10,8),
    `longitude` DECIMAL(11,8),
    `contact_info` TEXT,
    `reservation_required` BOOLEAN DEFAULT FALSE,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`destination_id`) REFERENCES `destinations` (`id`),
    KEY `idx_restaurants_destination` (`destination_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `events`
-- Local events and activities
-- -----------------------------------------------------
CREATE TABLE `events` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `destination_id` BIGINT UNSIGNED NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `description` TEXT,
    `start_date` DATE,
    `end_date` DATE,
    `location` TEXT,
    `ticket_price` DECIMAL(10,2) COMMENT 'Price in local currency',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`destination_id`) REFERENCES `destinations` (`id`),
    KEY `idx_events_destination` (`destination_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `weather_data`
-- Monthly average weather information
-- -----------------------------------------------------
CREATE TABLE `weather_data` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `destination_id` BIGINT UNSIGNED NOT NULL,
    `month` TINYINT NOT NULL COMMENT '1-12 representing months',
    `avg_temp_celsius` DECIMAL(4,2),
    `avg_rainfall_mm` DECIMAL(6,2),
    `avg_humidity` TINYINT,
    `avg_daylight_hours` DECIMAL(4,2),
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`destination_id`) REFERENCES `destinations` (`id`),
    UNIQUE KEY `idx_weather_destination_month` (`destination_id`, `month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `emergency_services`
-- Local emergency contact information
-- -----------------------------------------------------
CREATE TABLE `emergency_services` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `destination_id` BIGINT UNSIGNED NOT NULL,
    `service_type` VARCHAR(50) COMMENT 'Police, Hospital, Embassy, etc.',
    `name` VARCHAR(100) NOT NULL,
    `phone_number` VARCHAR(20),
    `address` TEXT,
    `notes` TEXT,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`destination_id`) REFERENCES `destinations` (`id`),
    KEY `idx_emergency_destination` (`destination_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `transportation_types`
-- Types of transportation (bus, train, taxi, etc.)
-- -----------------------------------------------------
CREATE TABLE `transportation_types` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `icon` VARCHAR(100) COMMENT 'Icon file path or class',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `transportation_options`
-- Available transportation methods
-- -----------------------------------------------------
CREATE TABLE `transportation_options` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `destination_id` BIGINT UNSIGNED NOT NULL,
    `transport_type_id` BIGINT UNSIGNED NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `description` TEXT,
    `avg_cost` DECIMAL(10,2) COMMENT 'Cost in local currency',
    `website` VARCHAR(255),
    `booking_info` TEXT,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`destination_id`) REFERENCES `destinations` (`id`),
    FOREIGN KEY (`transport_type_id`) REFERENCES `transportation_types` (`id`),
    KEY `idx_transport_destination` (`destination_id`),
    KEY `idx_transport_type` (`transport_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `trip_plans`
-- Main trip planning table
-- -----------------------------------------------------
CREATE TABLE `trip_plans` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `start_date` DATE NOT NULL,
    `end_date` DATE NOT NULL,
    `budget` DECIMAL(10,2),
    `notes` TEXT,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `trip_destinations`
-- Junction table for trip plans and destinations
-- -----------------------------------------------------
CREATE TABLE `trip_destinations` (
    `trip_id` BIGINT UNSIGNED NOT NULL,
    `destination_id` BIGINT UNSIGNED NOT NULL,
    `arrival_date` DATE,
    `departure_date` DATE,
    `accommodation_id` BIGINT UNSIGNED COMMENT 'Reference to points_of_interest for hotels',
    `notes` TEXT,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`trip_id`, `destination_id`),
    FOREIGN KEY (`trip_id`) REFERENCES `trip_plans` (`id`),
    FOREIGN KEY (`destination_id`) REFERENCES `destinations` (`id`),
    FOREIGN KEY (`accommodation_id`) REFERENCES `points_of_interest` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `trip_activities`
-- Detailed itinerary items for each trip
-- -----------------------------------------------------
CREATE TABLE `trip_activities` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `trip_id` BIGINT UNSIGNED NOT NULL,
    `activity_date` DATE NOT NULL,
    `start_time` TIME,
    `end_time` TIME,
    `activity_type` ENUM('ATTRACTION', 'RESTAURANT', 'EVENT', 'TRANSPORT', 'FREE_TIME') NOT NULL,
    `reference_id` BIGINT UNSIGNED COMMENT 'ID reference to respective activity table',
    `notes` TEXT,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`trip_id`) REFERENCES `trip_plans` (`id`),
    KEY `idx_activities_trip` (`trip_id`),
    KEY `idx_activities_date` (`activity_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `travel_documents`
-- Required documents for the trip
-- -----------------------------------------------------
CREATE TABLE `travel_documents` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `trip_id` BIGINT UNSIGNED NOT NULL,
    `document_type` VARCHAR(50) NOT NULL COMMENT 'Passport, Visa, Insurance, etc.',
    `document_number` VARCHAR(100),
    `expiry_date` DATE,
    `notes` TEXT,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`trip_id`) REFERENCES `trip_plans` (`id`),
    KEY `idx_documents_trip` (`trip_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `packing_lists`
-- Items to pack for the trip
-- -----------------------------------------------------
CREATE TABLE `packing_lists` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `trip_id` BIGINT UNSIGNED NOT NULL,
    `item_name` VARCHAR(100) NOT NULL,
    `category` VARCHAR(50) COMMENT 'Clothes, Electronics, Documents, etc.',
    `quantity` INT DEFAULT 1,
    `is_packed` BOOLEAN DEFAULT FALSE,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`trip_id`) REFERENCES `trip_plans` (`id`),
    KEY `idx_packing_trip` (`trip_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Example of a 3-level join query
-- This query will show all attractions in a trip plan
-- with their destination and country information
-- -----------------------------------------------------
/*
SELECT 
    tp.name as trip_name,
    c.name as country,
    d.name as destination,
    a.name as attraction_name,
    ac.name as attraction_category,
    ta.activity_date,
    ta.start_time
FROM trip_plans tp
JOIN trip_activities ta ON tp.id = ta.trip_id
JOIN attractions a ON ta.reference_id = a.id
JOIN destinations d ON a.destination_id = d.id
JOIN countries c ON d.country_id = c.id
JOIN attraction_categories ac ON a.category_id = ac.id
WHERE ta.activity_type = 'ATTRACTION'
AND tp.is_deleted = FALSE
ORDER BY ta.activity_date, ta.start_time;
*/

-- -----------------------------------------------------
-- Example of another 3-level join query
-- This query will show all restaurants visited in a trip
-- with their local cuisine information and destination details
-- -----------------------------------------------------
/*
SELECT 
    tp.name as trip_name,
    c.name as country,
    d.name as destination,
    r.name as restaurant_name,
    r.cuisine_type,
    lc.dish_name as local_specialty,
    ta.activity_date,
    ta.start_time
FROM trip_plans tp
JOIN trip_activities ta ON tp.id = ta.trip_id
JOIN restaurants r ON ta.reference_id = r.id
JOIN destinations d ON r.destination_id = d.id
JOIN countries c ON d.country_id = c.id
LEFT JOIN local_cuisines lc ON d.id = lc.destination_id
WHERE ta.activity_type = 'RESTAURANT'
AND tp.is_deleted = FALSE
ORDER BY ta.activity_date, ta.start_time;
*/

SET FOREIGN_KEY_CHECKS = 1;
