# ProjectPortfolio
📌 Project Title
COVID-19 Data Exploration Using SQL

📖 Description
This project involves exploring COVID-19 global data using SQL queries on Microsoft SQL Server. The dataset includes COVID-19 cases, deaths, and vaccination statistics. The goal is to derive insights such as infection rates, death percentages, population impact, and vaccination rollouts across countries and continents.

📁 Dataset Source
Our World in Data - COVID-19 Dataset

Tables used: CovidDeaths, CovidVaccinations

🔧 Tools & Technologies
SQL Server Management Studio (SSMS)

Microsoft SQL Server

Windows OS (or any local setup)

Data imported from .csv files

🧠 Key Concepts Used
SELECT statements

JOINS

CTE (Common Table Expressions)

Temp Tables

Views

Aggregations

Window Functions

Data Type Conversions

Filtering using WHERE, LIKE, ORDER BY

📊 Insights & Queries Covered
🔹 Data Exploration
Raw data preview

Filtering by specific country (e.g., India, United States)

🔹 Case Fatality Rate
Percentage of deaths globally and country-wise

Country with highest fatality rate

🔹 Population Impact
Infection % of total population

Deaths % of total population

Highest population impact (infection and death)

🔹 Vaccination Analysis
% of population vaccinated

Rolling total vaccinations using Window functions

Data storage using Temp Tables and Views for visualization

📌 Noteworthy SQL Features
Use of ROUND() for formatting

Handling NULLs and data conversions (CAST, CONVERT)

PARTITION BY in Window Functions

TOP 1 for max/min values

CREATE VIEW for persistent query results
