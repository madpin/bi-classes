#!/usr/bin/env python3
"""
Brazil Secondary Energy Market Data Generator
------------------------------------------
This script populates a MySQL database with realistic sample data for the Brazilian
secondary energy market. It's designed for educational and testing purposes.

Features:
- Generates realistic Brazilian company data
- Creates relationships between different market entities
- Includes soft delete functionality
- Uses realistic date ranges and values
- Follows Brazilian energy market structure

Usage:
1. Update the DATABASE_CONFIG with your MySQL credentials
2. Ensure you have the required packages installed:
   pip install pymysql faker

Author: Thiago MadPin
Date: 2024-10-25
Version: 1.0
"""

import pymysql
import random
import string
from datetime import datetime, timedelta
from typing import List, Dict, Any, Optional
from faker import Faker
import sys

# Configuration Constants
DATABASE_CONFIG = {
    "host": "localhost",
    "user": "your_username",
    "password": "your_password",
    "database": "energy_market",
    "charset": "utf8mb4",
}

# Data Generation Configuration
RECORD_COUNTS = {
    "companies": 150,
    "power_plants": 120,
    "energy_contracts": 200,
    "energy_transactions": 500,
    "market_prices": 300,
    "regulatory_reports": 200,
    "transmission_lines": 100,
    "substations": 150,
    "energy_consumption": 400,
    "auctions": 50,
    "auction_participants": 300,
    "weather_data": 500,
    "energy_storage": 80,
}

# Business Constants
COMPANY_TYPES = ["Generator", "Distributor", "Trader", "Consumer"]
ENERGY_SOURCES = [
    ("Hydroelectric Power", "Hydro"),
    ("Solar Power", "Solar"),
    ("Wind Power", "Wind"),
    ("Biomass Energy", "Biomass"),
    ("Thermal Power", "Thermal"),
    ("Nuclear Power", "Nuclear"),
]
REGIONS = ["North", "Northeast", "South", "Southeast", "Midwest"]
CONTRACT_TYPES = ["Bilateral", "Auction", "Regulated"]
CONTRACT_STATUS = ["Draft", "Active", "Completed", "Cancelled"]
STORAGE_TYPES = ["Battery", "Pumped Hydro", "Compressed Air", "Flywheel"]


class EnergyMarketDataGenerator:
    """Main class for generating energy market data."""

    def __init__(self):
        """Initialize the generator with database connection and Faker instance."""
        self.fake = Faker("pt_BR")
        self.conn = self._create_connection()
        self.cursor = self.conn.cursor()
        self.company_ids = []
        self.energy_source_ids = []
        self.power_plant_ids = []

    def _create_connection(self) -> pymysql.Connection:
        """Create and return a database connection."""
        try:
            return pymysql.connect(**DATABASE_CONFIG)
        except pymysql.Error as e:
            print(f"Error connecting to database: {e}")
            sys.exit(1)

    def generate_cnpj(self) -> str:
        """Generate a random CNPJ number."""
        return "".join(random.choices(string.digits, k=14))

    def random_date(self, start_year: int = 2010) -> str:
        """Generate a random date from start_year to now."""
        start = datetime(start_year, 1, 1)
        end = datetime.now()
        return self.fake.date_between(start_date=start, end_date=end)

    def insert_companies(self) -> None:
        """Insert company records into the database."""
        print("Generating companies...")

        for _ in range(RECORD_COUNTS["companies"]):
            query = """
            INSERT INTO companies (
                company_name, cnpj, address, city, state, postal_code,
                contact_person, email, phone, company_type
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """
            values = (
                self.fake.company(),
                self.generate_cnpj(),
                self.fake.street_address(),
                self.fake.city(),
                self.fake.state_abbr(),
                "".join(random.choices(string.digits, k=8)),
                self.fake.name(),
                self.fake.email(),
                self.fake.phone_number(),
                random.choice(COMPANY_TYPES),
            )

            try:
                self.cursor.execute(query, values)
                self.company_ids.append(self.cursor.lastrowid)
            except pymysql.Error as e:
                print(f"Error inserting company: {e}")

        self.conn.commit()

    def insert_energy_sources(self) -> None:
        """Insert energy source records."""
        print("Generating energy sources...")

        for source_name, source_type in ENERGY_SOURCES:
            query = """
            INSERT INTO energy_sources (source_name, source_type, description)
            VALUES (%s, %s, %s)
            """
            values = (
                source_name,
                source_type,
                f"Description for {source_name} generation in Brazil",
            )

            try:
                self.cursor.execute(query, values)
                self.energy_source_ids.append(self.cursor.lastrowid)
            except pymysql.Error as e:
                print(f"Error inserting energy source: {e}")

        self.conn.commit()

    def insert_power_plants(self) -> None:
        """Insert power plant records."""
        print("Generating power plants...")

        generator_companies = [id for id in self.company_ids]

        for _ in range(RECORD_COUNTS["power_plants"]):
            query = """
            INSERT INTO power_plants (
                plant_name, company_id, energy_source_id, capacity_mw,
                location, latitude, longitude, operational_start_date
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            """
            values = (
                f"Plant {self.fake.company()}",
                random.choice(generator_companies),
                random.choice(self.energy_source_ids),
                random.uniform(50, 1000),  # Capacity between 50MW and 1000MW
                self.fake.city(),
                random.uniform(-33.75, 5.27),  # Brazil latitude range
                random.uniform(-73.99, -34.79),  # Brazil longitude range
                self.random_date(),
            )

            try:
                self.cursor.execute(query, values)
                self.power_plant_ids.append(self.cursor.lastrowid)
            except pymysql.Error as e:
                print(f"Error inserting power plant: {e}")

        self.conn.commit()

    def insert_energy_contracts(self) -> None:
        """Insert energy contract records."""
        print("Generating energy contracts...")

        for _ in range(RECORD_COUNTS["energy_contracts"]):
            start_date = self.random_date()
            end_date = start_date + timedelta(days=random.randint(30, 365 * 3))

            query = """
            INSERT INTO energy_contracts (
                seller_id, buyer_id, contract_number, start_date, end_date,
                energy_amount_mwh, price_per_mwh, contract_type, status
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
            """
            values = (
                random.choice(self.company_ids),
                random.choice(self.company_ids),
                f"CONT-{self.fake.unique.random_number(digits=8)}",
                start_date,
                end_date,
                random.uniform(1000, 50000),  # Energy amount between 1000-50000 MWh
                random.uniform(100, 500),  # Price between R$100-500 per MWh
                random.choice(CONTRACT_TYPES),
                random.choice(CONTRACT_STATUS),
            )

            try:
                self.cursor.execute(query, values)
            except pymysql.Error as e:
                print(f"Error inserting energy contract: {e}")

        self.conn.commit()

    def insert_market_prices(self) -> None:
        """Insert market price records."""
        print("Generating market prices...")

        for _ in range(RECORD_COUNTS["market_prices"]):
            query = """
            INSERT INTO market_prices (
                price_date, energy_source_id, region, price_per_mwh
            ) VALUES (%s, %s, %s, %s)
            """
            values = (
                self.random_date(),
                random.choice(self.energy_source_ids),
                random.choice(REGIONS),
                random.uniform(100, 500),  # Price between R$100-500 per MWh
            )

            try:
                self.cursor.execute(query, values)
            except pymysql.Error as e:
                print(f"Error inserting market price: {e}")

        self.conn.commit()

    def insert_substations(self) -> None:
        """Insert substation records."""
        print("Generating substations...")

        for _ in range(RECORD_COUNTS["substations"]):
            query = """
            INSERT INTO substations (
                substation_name, company_id, capacity_mva, voltage_level_kv,
                latitude, longitude, operational_start_date
            ) VALUES (%s, %s, %s, %s, %s, %s, %s)
            """
            values = (
                f"Substation {self.fake.unique.random_number(digits=5)}",
                random.choice(self.company_ids),
                random.uniform(100, 1000),  # Capacity between 100-1000 MVA
                random.choice([138, 230, 500, 750]),  # Common voltage levels in Brazil
                random.uniform(-33.75, 5.27),
                random.uniform(-73.99, -34.79),
                self.random_date(),
            )

            try:
                self.cursor.execute(query, values)
            except pymysql.Error as e:
                print(f"Error inserting substation: {e}")

        self.conn.commit()

    def insert_energy_storage(self) -> None:
        """Insert energy storage facility records."""
        print("Generating energy storage facilities...")

        for _ in range(RECORD_COUNTS["energy_storage"]):
            query = """
            INSERT INTO energy_storage (
                facility_name, company_id, storage_type, capacity_mwh,
                max_charge_rate_mw, max_discharge_rate_mw, operational_start_date
            ) VALUES (%s, %s, %s, %s, %s, %s, %s)
            """
            capacity = random.uniform(10, 100)
            values = (
                f"Storage {self.fake.unique.random_number(digits=5)}",
                random.choice(self.company_ids),
                random.choice(STORAGE_TYPES),
                capacity,
                capacity * 0.2,  # Charge rate typically 20% of capacity
                capacity * 0.2,  # Discharge rate typically 20% of capacity
                self.random_date(),
            )

            try:
                self.cursor.execute(query, values)
            except pymysql.Error as e:
                print(f"Error inserting energy storage: {e}")

        self.conn.commit()

    def apply_soft_deletes(self) -> None:
        """Apply soft deletes to random records in each table."""
        print("Applying soft deletes...")

        for table, count in RECORD_COUNTS.items():
            records_to_delete = int(count * 0.05)  # 5% of records
            for _ in range(records_to_delete):
                query = f"UPDATE {table} SET is_deleted = TRUE WHERE id = %s"
                random_id = random.randint(1, count)

                try:
                    self.cursor.execute(query, (random_id,))
                except pymysql.Error as e:
                    print(f"Error applying soft delete to {table}: {e}")

        self.conn.commit()

    def generate_all_data(self) -> None:
        """Generate all data in the correct order."""
        try:
            # First level - No dependencies
            self.insert_companies()
            self.insert_energy_sources()

            # Second level - Basic dependencies
            self.insert_power_plants()
            self.insert_energy_contracts()
            self.insert_market_prices()
            self.insert_substations()
            self.insert_energy_storage()

            # Apply soft deletes
            self.apply_soft_deletes()

            print("Data generation completed successfully!")

        except Exception as e:
            print(f"Error during data generation: {e}")
            self.conn.rollback()
        finally:
            self.cursor.close()
            self.conn.close()


def main():
    """Main execution function."""
    try:
        generator = EnergyMarketDataGenerator()
        generator.generate_all_data()
    except Exception as e:
        print(f"Fatal error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
