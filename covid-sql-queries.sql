-- SQL Queries for COVID-19 Analysis

-- SECTION 1: GLOBAL SUMMARIES
-- 1.1 Global Summary of Cases, Deaths, and Vaccinations
SELECT 
    SUM(CAST(d.total_cases AS FLOAT)) AS total_cases,
    SUM(CAST(d.total_deaths AS FLOAT)) AS total_deaths,
    SUM(CAST(v.total_vaccinations AS FLOAT)) AS total_vaccinations
FROM 
    dbo.CovidDeaths d
LEFT JOIN 
    dbo.CovidVaccinations v
ON 
    d.location = v.location AND d.date = v.date;

-- 1.2 Total Cases, Deaths, and Vaccination Rates by Continent
SELECT 
    d.continent,
    SUM(CAST(d.total_cases AS FLOAT)) AS total_cases,
    SUM(CAST(d.total_deaths AS FLOAT)) AS total_deaths,
    AVG(CAST(v.people_vaccinated_per_hundred AS FLOAT)) AS avg_vaccinated_per_hundred
FROM 
    dbo.CovidDeaths d
LEFT JOIN 
    dbo.CovidVaccinations v
ON 
    d.location = v.location
GROUP BY 
    d.continent;

-- 1.3 Global Summary of New Cases and Deaths
SELECT 
    SUM(CAST(new_cases AS FLOAT)) AS total_new_cases,
    SUM(CAST(new_deaths AS FLOAT)) AS total_new_deaths
FROM 
    dbo.CovidDeaths;

-- 1.4 Global Average Life Expectancy
SELECT 
    AVG(life_expectancy) AS avg_life_expectancy
FROM 
    dbo.CovidVaccinations;

-- 1.5 Deaths Per Million by Continent
SELECT 
    continent,
    AVG(total_deaths_per_million) AS avg_deaths_per_million
FROM 
    dbo.CovidDeaths
GROUP BY 
    continent;

-- SECTION 2: COUNTRY RANKINGS
-- 2.1 Top 10 Countries by Total Deaths
SELECT TOP 10
    location AS country,
    SUM(CAST(total_deaths AS FLOAT)) AS total_deaths
FROM 
    dbo.CovidDeaths
GROUP BY 
    location
ORDER BY 
    total_deaths DESC;

-- 2.2 Top 10 Countries by Total Cases
SELECT TOP 10
    location AS country,
    SUM(CAST(total_cases AS FLOAT)) AS total_cases
FROM 
    dbo.CovidDeaths
GROUP BY 
    location
ORDER BY 
    total_cases DESC;

-- 2.3 Top 10 Countries by Vaccination Rates
SELECT TOP 10
    location AS country,
    MAX(CAST(people_vaccinated_per_hundred AS FLOAT)) AS max_vaccination_rate
FROM 
    dbo.CovidVaccinations
GROUP BY 
    location
ORDER BY 
    max_vaccination_rate DESC;

-- 2.4 Top 10 Countries with the Highest Deaths Per Million
SELECT TOP 10
    location,
    MAX(CAST(total_deaths_per_million AS FLOAT)) AS max_deaths_per_million
FROM 
    dbo.CovidDeaths
GROUP BY 
    location
ORDER BY 
    max_deaths_per_million DESC;

-- 2.5 Top 10 Countries with Lowest Death Rates
SELECT TOP 10
    location AS country,
    (SUM(CAST(total_deaths AS FLOAT)) * 100.0 / NULLIF(SUM(CAST(total_cases AS FLOAT)), 0)) AS death_rate_percentage
FROM 
    dbo.CovidDeaths
GROUP BY 
    location
ORDER BY 
    death_rate_percentage ASC;

-- SECTION 3: TIME-BASED TRENDS
-- 3.1 Daily New Cases and Deaths Globally
SELECT 
    date,
    SUM(CAST(new_cases AS FLOAT)) AS daily_new_cases,
    SUM(CAST(new_deaths AS FLOAT)) AS daily_new_deaths
FROM 
    dbo.CovidDeaths
GROUP BY 
    date
ORDER BY 
    date ASC;

-- 3.2 Weekly Vaccination Trends
SELECT 
    DATEPART(WEEK, date) AS week,
    SUM(CAST(new_vaccinations AS FLOAT)) AS weekly_vaccinations
FROM 
    dbo.CovidVaccinations
GROUP BY 
    DATEPART(WEEK, date)
ORDER BY 
    week ASC;

-- 3.3 Deaths Per Month by Continent
SELECT 
    continent,
    DATEPART(MONTH, date) AS month,
    SUM(CAST(total_deaths AS FLOAT)) AS monthly_deaths
FROM 
    dbo.CovidDeaths
GROUP BY 
    continent, DATEPART(MONTH, date)
ORDER BY 
    month ASC;

-- SECTION 4: REGIONAL SUMMARIES
-- 4.1 New Cases Per Million by Continent
SELECT 
    continent,
    AVG(new_cases_per_million) AS avg_new_cases_per_million
FROM 
    dbo.CovidDeaths
GROUP BY 
    continent;

-- 4.2 Testing Rate Per Thousand by Continent
SELECT 
    continent,
    AVG(CAST(total_tests_per_thousand AS FLOAT)) AS avg_tests_per_thousand
FROM 
    dbo.CovidVaccinations
WHERE 
    ISNUMERIC(total_tests_per_thousand) = 1
GROUP BY 
    continent;

-- SECTION 5: HOSPITAL AND ICU METRICS
-- 5.1 Countries with Most ICU Patients
SELECT TOP 10
    location AS country,
    MAX(CAST(icu_patients AS FLOAT)) AS max_icu_patients
FROM 
    dbo.CovidDeaths
GROUP BY 
    location
ORDER BY 
    max_icu_patients DESC;

-- 5.2 Weekly Hospital Admissions by Continent
SELECT 
    continent,
    AVG(CAST(weekly_hosp_admissions AS FLOAT)) AS avg_weekly_hospital_admissions
FROM 
    dbo.CovidDeaths
WHERE 
    ISNUMERIC(weekly_hosp_admissions) = 1
GROUP BY 
    continent;

-- 5.3 Daily ICU Admissions Trend
SELECT 
    date,
    SUM(CAST(weekly_icu_admissions AS FLOAT)) AS daily_icu_admissions
FROM 
    dbo.CovidDeaths
WHERE 
    ISNUMERIC(weekly_icu_admissions) = 1
GROUP BY 
    date
ORDER BY 
    date ASC;

-- SECTION 6: VACCINATION ANALYSIS
-- 6.1 Vaccination Progress Over Time by Continent
SELECT 
    continent,
    date,
    SUM(CAST(new_vaccinations AS FLOAT)) AS daily_new_vaccinations
FROM 
    dbo.CovidVaccinations
GROUP BY 
    continent, date
ORDER BY 
    date ASC;

-- 6.2 Vaccination Rates by GDP per Capita
SELECT 
    CAST(gdp_per_capita AS FLOAT) AS gdp_per_capita,
    AVG(CAST(people_vaccinated_per_hundred AS FLOAT)) AS avg_vaccination_rate
FROM 
    dbo.CovidVaccinations
WHERE 
    ISNUMERIC(gdp_per_capita) = 1 AND ISNUMERIC(people_vaccinated_per_hundred) = 1
GROUP BY 
    CAST(gdp_per_capita AS FLOAT)
ORDER BY 
    gdp_per_capita DESC;

-- 6.3 Top 5 Continents by Vaccination Rates
SELECT TOP 5
    continent,
    AVG(CAST(people_vaccinated_per_hundred AS FLOAT)) AS avg_vaccination_rate
FROM 
    dbo.CovidVaccinations
GROUP BY 
    continent
ORDER BY 
    avg_vaccination_rate DESC;

-- 6.4 Countries with Lowest Vaccination Rates
SELECT TOP 10
    location AS country,
    MIN(CAST(people_vaccinated_per_hundred AS FLOAT)) AS lowest_vaccination_rate
FROM 
    dbo.CovidVaccinations
GROUP BY 
    location
ORDER BY 
    lowest_vaccination_rate ASC;

-- SECTION 7: ADVANCED CORRELATIONS
-- 7.1 Correlation Between GDP and Case Fatality Rate
SELECT 
    AVG(CAST(gdp_per_capita AS FLOAT)) AS avg_gdp_per_capita,
    (SUM(CAST(total_deaths AS FLOAT)) * 100.0 / NULLIF(SUM(CAST(total_cases AS FLOAT)), 0)) AS case_fatality_rate
FROM 
    dbo.CovidDeaths d
LEFT JOIN 
    dbo.CovidVaccinations v
ON 
    d.location = v.location
GROUP BY 
    v.gdp_per_capita;

-- 7.2 Impact of Median Age on Death Rate
SELECT 
    AVG(CAST(v.median_age AS FLOAT)) AS avg_median_age,
    AVG(CAST(d.total_deaths AS FLOAT) / NULLIF(CAST(d.total_cases AS FLOAT), 0)) AS avg_death_rate
FROM 
    dbo.CovidDeaths d
LEFT JOIN 
    dbo.CovidVaccinations v
ON 
    d.location = v.location
WHERE 
    d.total_cases IS NOT NULL
GROUP BY 
    v.median_age;

-- SECTION 8: EXCESS MORTALITY
-- 8.1 Countries with the Highest Excess Mortality
SELECT TOP 10
    location AS country,
    AVG(CAST(excess_mortality AS FLOAT)) AS avg_excess_mortality
FROM 
    dbo.CovidVaccinations
WHERE 
    excess_mortality IS NOT NULL
GROUP BY 
    location
ORDER BY 
    avg_excess_mortality DESC;

-- 8.2 Excess Mortality by Continent
SELECT 
    continent,
    AVG(CAST(excess_mortality AS FLOAT)) AS avg_excess_mortality
FROM 
    dbo.CovidVaccinations
WHERE 
    excess_mortality IS NOT NULL
    AND ISNUMERIC(excess_mortality) = 1
GROUP BY 
    continent;
