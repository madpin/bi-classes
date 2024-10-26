# bi-classes


## DB Mermaid:

```mermaid
erDiagram
    companies ||--o{ power_plants : owns
    companies ||--o{ energy_contracts : sells
    companies ||--o{ energy_contracts : buys
    companies ||--o{ regulatory_reports : submits
    companies ||--o{ energy_consumption : records
    companies ||--o{ substations : operates
    companies ||--o{ energy_storage : operates
    companies ||--o{ auction_participants : participates

    energy_sources ||--o{ power_plants : powers
    energy_sources ||--o{ market_prices : influences

    power_plants ||--o{ transmission_lines : starts_from
    power_plants ||--o{ transmission_lines : ends_at

    energy_contracts ||--o{ energy_transactions : generates

    auctions ||--o{ auction_participants : includes

    companies {
        int id PK
        string company_name
        string cnpj
        string address
        string city
        string state
        string postal_code
        string contact_person
        string email
        string phone
        enum company_type
        timestamp created_at
        timestamp updated_at
        boolean is_deleted
    }

    energy_sources {
        int id PK
        string source_name
        enum source_type
        text description
        timestamp created_at
        timestamp updated_at
        boolean is_deleted
    }

    power_plants {
        int id PK
        string plant_name
        int company_id FK
        int energy_source_id FK
        decimal capacity_mw
        string location
        decimal latitude
        decimal longitude
        date operational_start_date
        timestamp created_at
        timestamp updated_at
        boolean is_deleted
    }

    energy_contracts {
        int id PK
        int seller_id FK
        int buyer_id FK
        string contract_number
        date start_date
        date end_date
        decimal energy_amount_mwh
        decimal price_per_mwh
        enum contract_type
        enum status
        timestamp created_at
        timestamp updated_at
        boolean is_deleted
    }

    energy_transactions {
        int id PK
        int contract_id FK
        date transaction_date
        decimal energy_amount_mwh
        decimal price_per_mwh
        decimal total_amount
        timestamp created_at
        timestamp updated_at
        boolean is_deleted
    }

    transmission_lines {
        int id PK
        string line_name
        int start_point_id FK
        int end_point_id FK
        decimal capacity_mw
        int voltage_kv
        decimal length_km
        date operational_start_date
        timestamp created_at
        timestamp updated_at
        boolean is_deleted
    }

    market_prices {
        int id PK
        date price_date
        int energy_source_id FK
        enum region
        decimal price_per_mwh
        timestamp created_at
        timestamp updated_at
        boolean is_deleted
    }

    regulatory_reports {
        int id PK
        int company_id FK
        enum report_type
        date report_date
        decimal total_energy_traded_mwh
        decimal average_price_per_mwh
        enum compliance_status
        text comments
        timestamp created_at
        timestamp updated_at
        boolean is_deleted
    }

    substations {
        int id PK
        string substation_name
        int company_id FK
        decimal capacity_mva
        int voltage_level_kv
        decimal latitude
        decimal longitude
        date operational_start_date
        timestamp created_at
        timestamp updated_at
        boolean is_deleted
    }

    energy_consumption {
        int id PK
        int company_id FK
        date consumption_date
        decimal energy_consumed_mwh
        decimal peak_demand_mw
        timestamp created_at
        timestamp updated_at
        boolean is_deleted
    }

    auctions {
        int id PK
        string auction_name
        date auction_date
        enum auction_type
        decimal total_energy_mwh
        decimal average_price_per_mwh
        timestamp created_at
        timestamp updated_at
        boolean is_deleted
    }

    auction_participants {
        int id PK
        int auction_id FK
        int company_id FK
        decimal energy_offered_mwh
        decimal bid_price_per_mwh
        boolean is_winner
        timestamp created_at
        timestamp updated_at
        boolean is_deleted
    }

    weather_data {
        int id PK
        string station_id
        date measurement_date
        decimal temperature_celsius
        decimal wind_speed_ms
        decimal solar_radiation_wm2
        decimal precipitation_mm
        timestamp created_at
        timestamp updated_at
        boolean is_deleted
    }

    energy_storage {
        int id PK
        string facility_name
        int company_id FK
        enum storage_type
        decimal capacity_mwh
        decimal max_charge_rate_mw
        decimal max_discharge_rate_mw
        date operational_start_date
        timestamp created_at
        timestamp updated_at
        boolean is_deleted
    }
```