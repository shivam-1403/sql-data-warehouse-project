📦 Data Warehouse & Analytics Project (MySQL)

Welcome to the Data Warehouse & Analytics Project 🚀
This project demonstrates how to design and build a modern data warehouse using a layered architecture and perform analytical reporting using SQL. It showcases practical skills in data engineering, data modeling, ETL development, and analytics.

📌 Project Goals

Build a modern data warehouse using MySQL
Implement Bronze → Silver → Gold layered architecture
Perform ETL (Extract, Transform, Load) using SQL
Create fact and dimension tables
Generate analytical insights using SQL queries
This project is intended for learning and portfolio purposes.

🏗️ Architecture (Medallion Architecture)

The project follows the Medallion Architecture:

🥉 Bronze Layer
Stores raw data ingested from source CSV files without transformation.

🥈 Silver Layer
Cleanses, standardizes, and normalizes data.

🥇 Gold Layer
Contains analytics-ready tables and views modeled using Star Schema.

CSV Files → Bronze Tables → Silver Tables → Gold Views → Analytics Queries

🗃️ Data Sources

CRM System (Customers, Products, Sales)
ERP System (Customers, Locations, Categories)

All data is provided as CSV files.

⚙️ Tech Stack

MySQL 8+
MySQL Workbench
Git & GitHub
Draw.io (Architecture & Data Modeling)

🧱 Warehouse Layers

Bronze Layer
Raw tables
Loaded directly from CSV

Silver Layer
Cleaned columns
Standardized values
Removed duplicates
Converted datatypes

Gold Layer
Dimension tables
Fact tables
Star schema modeling

⭐ Data Model (Star Schema)
Dimensions

dim_customers
dim_products

Fact Table
fact_sales

🔁 ETL Flow

Load CSV files → Bronze tables
Transform Bronze → Silver
Build analytical views in Gold

All ETL logic is implemented using SQL scripts and stored procedures.

📊 Analytics Use Cases

Customer Analysis
Product Performance
Sales Trends
Revenue Metrics
Example Questions Answered
Top selling products
Sales by country
Monthly revenue trend
Customer purchase behavior

## 📂 Repository Structure
```
data-warehouse-project/
│
├── datasets/                           # Raw datasets used for the project (ERP and CRM data)
│
├── docs/                               # Project documentation and architecture details
│   ├── etl.drawio                      # Draw.io file shows all different techniquies and methods of ETL
│   ├── data_architecture.drawio        # Draw.io file shows the project's architecture
│   ├── data_catalog.md                 # Catalog of datasets, including field descriptions and metadata
│   ├── data_flow.drawio                # Draw.io file for the data flow diagram
│   ├── data_models.drawio              # Draw.io file for data models (star schema)
│   ├── naming-conventions.md           # Consistent naming guidelines for tables, columns, and files
│
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── bronze/                         # Scripts for extracting and loading raw data
│   ├── silver/                         # Scripts for cleaning and transforming data
│   ├── gold/                           # Scripts for creating analytical models
│
├── tests/                              # Test scripts and quality files
│
├── README.md                           # Project overview and instructions
├── LICENSE                             # License information for the repository
├── .gitignore                          # Files and directories to be ignored by Git
└── requirements.txt                    # Dependencies and requirements for the project
```
---

▶ How To Run Project

Create database in MySQL
Run Bronze table scripts
Load CSV data
Run Silver transformation scripts
Run Gold view scripts
Execute analytics queries

📈 Skills Demonstrated

SQL Development
Data Warehousing Concepts
ETL Design
Data Cleaning
Window Functions
Star Schema Modeling
Analytics Queries

🔮 Future Improvements

Add indexing strategy
Add incremental loading
Add Python-based analytics
Add dashboard (Power BI / Tableau)

👤 Author

Shivam
Computer Science Engineering Student
Aspiring Data Engineer / Data Analyst

📜 License

MIT License
