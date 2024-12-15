# COVID-19 SQL Queries

A comprehensive collection of SQL queries for analyzing COVID-19 data. This repository provides structured queries for global summaries, country-level trends, vaccination analysis, and advanced correlations.

Global Summaries

    Description: Total global cases, deaths, and vaccinations.
    Code: Query 1

    SELECT 
        SUM(CAST(d.total_cases AS FLOAT)) AS total_cases,
        SUM(CAST(d.total_deaths AS FLOAT)) AS total_deaths,
        SUM(CAST(v.total_vaccinations AS FLOAT)) AS total_vaccinations
    FROM dbo.CovidDeaths d
    LEFT JOIN dbo.CovidVaccinations v
    ON d.location = v.location AND d.date = v.date;

Country-Level Rankings

    Top Countries by Total Deaths: Query 3
    Top Countries by Total Cases: Query 4
    Top Countries by Vaccination Rates: Query 7
    Top Countries with the Highest Booster Rates: Query 10
    Top Countries with the Highest Death Rate: Query 11

Time-Based Trends

    Daily Trends of New Cases and Deaths by Continent: Query 5
    Global Daily Vaccination Trends: Query 6
    Global Daily Deaths Trends: Query 15
    Vaccination Trends by Week: Query 23
    Deaths Per Month by Continent: Query 24

Regional Summaries

    Total Cases, Deaths, and Vaccination Rates by Continent: Query 2
    Deaths Per Million by Continent: Query 12
    Weekly Hospital Admissions by Continent: Query 18
    Testing Rate Per Thousand by Continent: Query 23

Hospital and ICU Metrics

    Countries with Most ICU Patients: Query 17
    Hospital Beds Per Thousand by Continent: Query 16
    Countries with Highest Weekly ICU Admissions: Query 16
    Hospital Patients Per Million by Continent: Query 15
    Daily ICU Admissions Trends: Query 30

Advanced Analyses

    Correlation Between GDP and Case Fatality Rate: Query 19
    Impact of Median Age on Death Rates: Query 20
    Relationship Between Life Expectancy and Vaccination Rates: Query 9
    Impact of Handwashing Facilities on Cases: Query 25
## Usage
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/covid-sql-queries.git

   Open the SQL script (covid_analysis_queries.sql) in your favorite database client.
Run the queries against your COVID-19 dataset.

Requirements

    SQL Server or any compatible SQL database.
    COVID-19 dataset with tables:
        dbo.CovidDeaths
        dbo.CovidVaccinations



Contribution

Feel free to contribute new queries or suggest improvements! Fork the repository and submit a pull request.
License

This repository is licensed under the MIT License.

