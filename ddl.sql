-- --------------------------------------------------------
-- Brazil Secondary Energy Market Database
-- --------------------------------------------------------
-- This is an example database schema for educational purposes only.
-- It simulates the secondary energy market in Brazil but does not
-- represent any real-world system or contain actual data.
-- The schema is designed to demonstrate database design principles
-- and provide a realistic scenario for learning about energy markets.
-- --------------------------------------------------------

-- Create the database
CREATE DATABASE IF NOT EXISTS energy_market;
USE energy_market;

-- --------------------------------------------------------
-- Table structure for companies
-- This table stores information about various entities in the energy market,
-- including generators, distributors, traders, and consumers.
-- --------------------------------------------------------
CREATE TABLE companies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    cnpj VARCHAR(14) UNIQUE NOT NULL COMMENT 'Brazilian corporate tax ID',
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(2),
    postal_code VARCHAR(8),
    contact_person VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    company_type ENUM('Generator', 'Distributor', 'Trader', 'Consumer') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE
) COMMENT 'Stores information about companies in the energy market';

-- --------------------------------------------------------
-- Table structure for energy_sources
-- This table contains different types of energy sources used in power generation.
-- --------------------------------------------------------
CREATE TABLE energy_sources (
    id INT AUTO_INCREMENT PRIMARY KEY,
    source_name VARCHAR(50) NOT NULL,
    source_type ENUM('Hydro', 'Solar', 'Wind', 'Biomass', 'Thermal', 'Nuclear') NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE
) COMMENT 'Contains various types of energy sources';

-- --------------------------------------------------------
-- Table structure for power_plants
-- This table represents power generation facilities.
-- --------------------------------------------------------
CREATE TABLE power_plants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    plant_name VARCHAR(100) NOT NULL,
    company_id INT,
    energy_source_id INT,
    capacity_mw DECIMAL(10, 2) NOT NULL COMMENT 'Capacity in megawatts',
    location VARCHAR(255),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    operational_start_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (company_id) REFERENCES companies(id),
    FOREIGN KEY (energy_source_id) REFERENCES energy_sources(id)
) COMMENT 'Stores information about power generation facilities';

-- --------------------------------------------------------
-- Table structure for energy_contracts
-- This table stores details of energy contracts between companies.
-- --------------------------------------------------------
CREATE TABLE energy_contracts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    seller_id INT,
    buyer_id INT,
    contract_number VARCHAR(50) UNIQUE NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    energy_amount_mwh DECIMAL(10, 2) NOT NULL COMMENT 'Contracted energy in megawatt-hours',
    price_per_mwh DECIMAL(10, 2) NOT NULL,
    contract_type ENUM('Bilateral', 'Auction', 'Regulated') NOT NULL,
    status ENUM('Draft', 'Active', 'Completed', 'Cancelled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (seller_id) REFERENCES companies(id),
    FOREIGN KEY (buyer_id) REFERENCES companies(id)
) COMMENT 'Stores energy contract details between companies';

-- --------------------------------------------------------
-- Table structure for energy_transactions
-- This table records individual transactions related to energy contracts.
-- --------------------------------------------------------
CREATE TABLE energy_transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    contract_id INT,
    transaction_date DATE NOT NULL,
    energy_amount_mwh DECIMAL(10, 2) NOT NULL COMMENT 'Transacted energy in megawatt-hours',
    price_per_mwh DECIMAL(10, 2) NOT NULL,
    total_amount DECIMAL(12, 2) GENERATED ALWAYS AS (energy_amount_mwh * price_per_mwh) STORED,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (contract_id) REFERENCES energy_contracts(id)
) COMMENT 'Records individual energy transactions';

-- --------------------------------------------------------
-- Table structure for market_prices
-- This table keeps track of energy prices in different regions and for different sources.
-- --------------------------------------------------------
CREATE TABLE market_prices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    price_date DATE NOT NULL,
    energy_source_id INT,
    region ENUM('North', 'Northeast', 'South', 'Southeast', 'Midwest') NOT NULL,
    price_per_mwh DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (energy_source_id) REFERENCES energy_sources(id)
) COMMENT 'Tracks energy prices by region and source';

-- --------------------------------------------------------
-- Table structure for regulatory_reports
-- This table stores regulatory compliance reports submitted by companies.
-- --------------------------------------------------------
CREATE TABLE regulatory_reports (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT,
    report_type ENUM('Monthly', 'Quarterly', 'Annual') NOT NULL,
    report_date DATE NOT NULL,
    total_energy_traded_mwh DECIMAL(12, 2) NOT NULL,
    average_price_per_mwh DECIMAL(10, 2) NOT NULL,
    compliance_status ENUM('Compliant', 'Non-compliant', 'Under Review') NOT NULL,
    comments TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (company_id) REFERENCES companies(id)
) COMMENT 'Stores regulatory compliance reports';

-- --------------------------------------------------------
-- Table structure for transmission_lines
-- This table represents power transmission lines connecting different points in the grid.
-- --------------------------------------------------------
CREATE TABLE transmission_lines (
    id INT AUTO_INCREMENT PRIMARY KEY,
    line_name VARCHAR(100) NOT NULL,
    start_point_id INT,
    end_point_id INT,
    capacity_mw DECIMAL(10, 2) NOT NULL COMMENT 'Capacity in megawatts',
    voltage_kv INT NOT NULL COMMENT 'Voltage in kilovolts',
    length_km DECIMAL(10, 2) NOT NULL COMMENT 'Length in kilometers',
    operational_start_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (start_point_id) REFERENCES power_plants(id),
    FOREIGN KEY (end_point_id) REFERENCES power_plants(id)
) COMMENT 'Represents power transmission lines';

-- --------------------------------------------------------
-- Table structure for substations
-- This table stores information about electrical substations.
-- --------------------------------------------------------
CREATE TABLE substations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    substation_name VARCHAR(100) NOT NULL,
    company_id INT,
    capacity_mva DECIMAL(10, 2) NOT NULL COMMENT 'Capacity in megavolt-amperes',
    voltage_level_kv INT NOT NULL COMMENT 'Voltage level in kilovolts',
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    operational_start_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (company_id) REFERENCES companies(id)
) COMMENT 'Stores information about electrical substations';

-- --------------------------------------------------------
-- Table structure for energy_consumption
-- This table records energy consumption data for companies (typically consumers).
-- --------------------------------------------------------
CREATE TABLE energy_consumption (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT,
    consumption_date DATE NOT NULL,
    energy_consumed_mwh DECIMAL(10, 2) NOT NULL COMMENT 'Energy consumed in megawatt-hours',
    peak_demand_mw DECIMAL(10, 2) NOT NULL COMMENT 'Peak demand in megawatts',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (company_id) REFERENCES companies(id)
) COMMENT 'Records energy consumption data';

-- --------------------------------------------------------
-- Table structure for auctions
-- This table represents energy auctions held in the market.
-- --------------------------------------------------------
CREATE TABLE auctions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    auction_name VARCHAR(100) NOT NULL,
    auction_date DATE NOT NULL,
    auction_type ENUM('New Energy', 'Existing Energy', 'Alternative Sources', 'Reserve Energy') NOT NULL,
    total_energy_mwh DECIMAL(12, 2) NOT NULL COMMENT 'Total energy auctioned in megawatt-hours',
    average_price_per_mwh DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE
) COMMENT 'Represents energy auctions in the market';

-- --------------------------------------------------------
-- Table structure for auction_participants
-- This table records companies participating in energy auctions.
-- --------------------------------------------------------
CREATE TABLE auction_participants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    auction_id INT,
    company_id INT,
    energy_offered_mwh DECIMAL(10, 2) NOT NULL COMMENT 'Energy offered in megawatt-hours',
    bid_price_per_mwh DECIMAL(10, 2) NOT NULL,
    is_winner BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (auction_id) REFERENCES auctions(id),
    FOREIGN KEY (company_id) REFERENCES companies(id)
) COMMENT 'Records companies participating in energy auctions';

-- --------------------------------------------------------
-- Table structure for weather_data
-- This table stores weather data relevant for renewable energy forecasting.
-- --------------------------------------------------------
CREATE TABLE weather_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    station_id VARCHAR(50) NOT NULL,
    measurement_date DATE NOT NULL,
    temperature_celsius DECIMAL(5, 2),
    wind_speed_ms DECIMAL(5, 2) COMMENT 'Wind speed in meters per second',
    solar_radiation_wm2 DECIMAL(7, 2) COMMENT 'Solar radiation in watts per square meter',
    precipitation_mm DECIMAL(6, 2) COMMENT 'Precipitation in millimeters',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE
) COMMENT 'Stores weather data for renewable energy forecasting';

-- --------------------------------------------------------
-- Table structure for energy_storage
-- This table represents energy storage facilities.
-- --------------------------------------------------------
CREATE TABLE energy_storage (
    id INT AUTO_INCREMENT PRIMARY KEY,
    facility_name VARCHAR(100) NOT NULL,
    company_id INT,
    storage_type ENUM('Battery', 'Pumped Hydro', 'Compressed Air', 'Flywheel') NOT NULL,
    capacity_mwh DECIMAL(10, 2) NOT NULL COMMENT 'Storage capacity in megawatt-hours',
    max_charge_rate_mw DECIMAL(10, 2) NOT NULL COMMENT 'Maximum charge rate in megawatts',
    max_discharge_rate_mw DECIMAL(10, 2) NOT NULL COMMENT 'Maximum discharge rate in megawatts',
    operational_start_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (company_id) REFERENCES companies(id)
) COMMENT 'Represents energy storage facilities';
