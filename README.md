# 🔍💼 Business Intelligence Bootcamp: Energy Market Edition

Welcome to the most electrifying Business Intelligence (BI) course on GitHub! We're using Brazil's secondary energy market as our case study to power up your skills in Python, pandas, Jupyter Notebook, and SQL. Get ready to energize your data analysis career!

## ⚡ Our High-Voltage Curriculum

Dive into a world where data flows like electricity, transforming raw information into powerful insights. We're not just learning about energy - we're supercharging your BI skills!

## 🛠️ Our Analytical Toolkit

- `data-generator.py`: Your power source for creating rich, realistic datasets
- `ddl.sql`: The blueprint for our database, ready for your SQL expertise
- Jupyter Notebooks: Where we'll conduct our electrifying analyses (coming soon!)

## 🚀 Course Highlights

- Master Python: Your swiss army knife for data manipulation
- Become a pandas pro: Handle data with the agility of a power grid operator
- SQL sorcery: Query your way through complex data relationships
- Jupyter Notebook mastery: Create stunning, interactive reports
- Real-world BI application: Using energy market data to drive decisions


## DB Mermaid:

```mermaid
erDiagram
    countries {
        bigint id PK
        varchar name
        char code
        char currency_code
        timestamp created_at
        timestamp updated_at
        timestamp deleted_at
        boolean is_deleted
    }
    
    destinations {
        bigint id PK
        bigint country_id FK
        varchar name
        text description
        varchar timezone
        timestamp created_at
        timestamp updated_at
        timestamp deleted_at
        boolean is_deleted
    }
    
    languages {
        bigint id PK
        varchar name
        char code
        timestamp created_at
        timestamp updated_at
        timestamp deleted_at
        boolean is_deleted
    }
    
    destination_languages {
        bigint destination_id PK, FK
        bigint language_id PK, FK
        boolean is_primary
        timestamp created_at
        timestamp updated_at
        timestamp deleted_at
        boolean is_deleted
    }

    local_cuisines {
        bigint id PK
        bigint destination_id FK
        varchar dish_name
        text description
        boolean is_vegetarian
        boolean is_vegan
        decimal average_price
        timestamp created_at
        timestamp updated_at
        timestamp deleted_at
        boolean is_deleted
    }

    point_types {
        bigint id PK
        varchar name
        varchar icon
        timestamp created_at
        timestamp updated_at
        timestamp deleted_at
        boolean is_deleted
    }

    points_of_interest {
        bigint id PK
        bigint destination_id FK
        bigint point_type_id FK
        varchar name
        text address
        decimal latitude
        decimal longitude
        text contact_info
        timestamp created_at
        timestamp updated_at
        timestamp deleted_at
        boolean is_deleted
    }

    countries ||--o{ destinations : has
    destinations ||--o{ local_cuisines : has
    destinations ||--o{ points_of_interest : has
    point_types ||--o{ points_of_interest : categorizes
    destinations ||--o{ destination_languages : has
    languages ||--o{ destination_languages : used_in
```

```mermaid
erDiagram
    attraction_categories {
        bigint id PK
        varchar name
        varchar icon
        timestamp created_at
        timestamp updated_at
        timestamp deleted_at
        boolean is_deleted
    }

    attractions {
        bigint id PK
        bigint destination_id FK
        bigint category_id FK
        varchar name
        text description
        text address
        decimal latitude
        decimal longitude
        int average_duration
        decimal entrance_fee
        timestamp created_at
        timestamp updated_at
        timestamp deleted_at
        boolean is_deleted
    }

    restaurants {
        bigint id PK
        bigint destination_id FK
        varchar name
        varchar cuisine_type
        enum price_range
        text address
        decimal latitude
        decimal longitude
        text contact_info
        boolean reservation_required
        timestamp created_at
        timestamp updated_at
        timestamp deleted_at
        boolean is_deleted
    }

    events {
        bigint id PK
        bigint destination_id FK
        varchar name
        text description
        date start_date
        date end_date
        text location
        decimal ticket_price
        timestamp created_at
        timestamp updated_at
        timestamp deleted_at
        boolean is_deleted
    }

    destinations ||--o{ attractions : has
    attraction_categories ||--o{ attractions : categorizes
    destinations ||--o{ restaurants : has
    destinations ||--o{ events : hosts
```

```mermaid
erDiagram
    trip_plans {
        bigint id PK
        varchar name
        date start_date
        date end_date
        decimal budget
        text notes
        timestamp created_at
        timestamp updated_at
        timestamp deleted_at
        boolean is_deleted
    }

    trip_destinations {
        bigint trip_id PK, FK
        bigint destination_id PK, FK
        date arrival_date
        date departure_date
        bigint accommodation_id FK
        text notes
        timestamp created_at
        timestamp updated_at
        timestamp deleted_at
        boolean is_deleted
    }

    trip_activities {
        bigint id PK
        bigint trip_id FK
        date activity_date
        time start_time
        time end_time
        enum activity_type
        bigint reference_id
        text notes
        timestamp created_at
        timestamp updated_at
        timestamp deleted_at
        boolean is_deleted
    }

    travel_documents {
        bigint id PK
        bigint trip_id FK
        varchar document_type
        varchar document_number
        date expiry_date
        text notes
        timestamp created_at
        timestamp updated_at
        timestamp deleted_at
        boolean is_deleted
    }

    packing_lists {
        bigint id PK
        bigint trip_id FK
        varchar item_name
        varchar category
        int quantity
        boolean is_packed
        timestamp created_at
        timestamp updated_at
        timestamp deleted_at
        boolean is_deleted
    }

    trip_plans ||--o{ trip_destinations : includes
    trip_plans ||--o{ trip_activities : contains
    trip_plans ||--o{ travel_documents : requires
    trip_plans ||--o{ packing_lists : has
    destinations ||--o{ trip_destinations : part_of
    points_of_interest ||--o{ trip_destinations : accommodates
```


## 🔌 How to Connect to Our BI Grid

1. Clone this high-energy repo:



git clone https://github.com/your-username/bi-bootcamp-energy-market.git

2. Install your analytical power tools:



pip install pymysql faker pandas jupyter

3. Set up your MySQL database (your personal data powerhouse)
4. Configure `DATABASE_CONFIG` in `data-generator.py`
5. Generate your dataset:



python data-generator.py

6. Fire up Jupyter Notebook and start your analysis!

## 🧠 Learning Objectives

We're amping up your skills in:
- Data manipulation with Python and pandas
- Database querying and management with SQL
- Data visualization and reporting with Jupyter Notebooks
- Business intelligence concepts and applications
- Critical thinking and problem-solving in a business context

## 🚧 Disclaimer: Real Tools, Simulated Data

While we use real BI tools, our energy market data is simulated. Perfect for learning without real-world consequences!

## 🤝 Your BI Power Team

- @DataDynamo1 - Master of Metrics
- @InsightIlluminator2 - Visualization Virtuoso

## 📜 Open-Source License

This project is open-source under the MIT License. Use it to power up your learning and career!

---

Remember: In BI, we turn data into decisions. Let's light up the path to data-driven insights together! 💡📊