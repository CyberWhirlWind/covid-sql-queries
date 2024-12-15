-- SQL Queries for COVID-19 Analysis

-- 1. Global Summary of Cases, Deaths, and Vaccinations
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


-- 2. Total Cases, Deaths, and Vaccination Rates by Continent
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


-- 3. Top 10 Countries by Total Deaths
SELECT TOP 10
    location AS country,
    SUM(CAST(total_deaths AS FLOAT)) AS total_deaths
FROM 
    dbo.CovidDeaths
GROUP BY 
    location
ORDER BY 
    total_deaths DESC;


-- 4. Top 10 Countries by Total Cases
SELECT TOP 10
    location AS country,
    SUM(CAST(total_cases AS FLOAT)) AS total_cases
FROM 
    dbo.CovidDeaths
GROUP BY 
    location
ORDER BY 
    total_cases DESC;

-- 5. Daily New Cases and Deaths Trend by Continent
SELECT 
    continent,
    date,
    SUM(new_cases) AS daily_new_cases,
    SUM(new_deaths) AS daily_new_deaths
FROM 
    dbo.CovidDeaths
GROUP BY 
    continent, date
ORDER BY 
    date ASC;

-- 6. Global Vaccination Trends Over Time
SELECT 
    date,
    SUM(TRY_CAST(new_vaccinations AS FLOAT)) AS daily_vaccinations
FROM 
    dbo.CovidVaccinations
GROUP BY 
    date
ORDER BY 
    date ASC;


-- 7. Top 10 Countries by Vaccination Rates
SELECT TOP 10
    location AS country,
    MAX(CAST(people_vaccinated_per_hundred AS FLOAT)) AS max_vaccination_rate
FROM 
    dbo.CovidVaccinations
GROUP BY 
    location
ORDER BY 
    max_vaccination_rate DESC;


-- 8. Vaccination Rates by GDP per Capita
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


-- 9. Vaccination Rates by Continent
SELECT 
    TRY_CAST(gdp_per_capita AS FLOAT) AS gdp_per_capita,
    AVG(TRY_CAST(people_vaccinated_per_hundred AS FLOAT)) AS avg_vaccination_rate
FROM 
    dbo.CovidVaccinations
GROUP BY 
    TRY_CAST(gdp_per_capita AS FLOAT)
ORDER BY 
    gdp_per_capita DESC;


-- 10. Top 5 Countries with the Highest Booster Rates
SELECT TOP 5
    location AS country,
    MAX(CAST(total_boosters_per_hundred AS FLOAT)) AS max_booster_rate
FROM 
    dbo.CovidVaccinations
GROUP BY 
    location
ORDER BY 
    max_booster_rate DESC;

-- 11. Countries with the Highest Death Rate
SELECT TOP 10
    location AS country,
    (SUM(CAST(total_deaths AS FLOAT)) * 100.0 / SUM(CAST(total_cases AS FLOAT))) AS death_rate_percentage
FROM 
    dbo.CovidDeaths
WHERE 
    total_cases IS NOT NULL AND TRY_CAST(total_cases AS FLOAT) > 0
GROUP BY 
    location
ORDER BY 
    death_rate_percentage DESC;


-- 12. Deaths Per Million by Continent
SELECT 
    continent,
    AVG(total_deaths_per_million) AS avg_deaths_per_million
FROM 
    dbo.CovidDeaths
GROUP BY 
    continent;

-- 13. Case Fatality Rate by GDP
SELECT 
    v.gdp_per_capita,
    (SUM(CAST(d.total_deaths AS FLOAT)) * 100.0 / SUM(NULLIF(CAST(d.total_cases AS FLOAT), 0))) AS case_fatality_rate
FROM 
    dbo.CovidDeaths d
LEFT JOIN 
    dbo.CovidVaccinations v
ON 
    d.location = v.location
WHERE 
    d.total_cases IS NOT NULL AND TRY_CAST(d.total_cases AS FLOAT) > 0
GROUP BY  
    v.gdp_per_capita
ORDER BY 
    case_fatality_rate DESC;


-- 14. Countries with Most New Cases
SELECT TOP 10
    location AS country,
    MAX(CAST(new_cases AS FLOAT)) AS max_new_cases
FROM 
    dbo.CovidDeaths
GROUP BY 
    location
ORDER BY 
    max_new_cases DESC;


-- 15. Global Daily Deaths Trend
SELECT 
    date,
    SUM(new_deaths) AS daily_new_deaths
FROM 
    dbo.CovidDeaths
GROUP BY 
    date
ORDER BY 
    date ASC;

-- 16. Hospital Beds Per Thousand by Continent
SELECT 
    continent,
    AVG(hospital_beds_per_thousand) AS avg_hospital_beds
FROM 
    dbo.CovidVaccinations
GROUP BY 
    continent;

-- 17. Countries with Most ICU Patients
SELECT TOP 10
    location AS country,
    MAX(CAST(icu_patients AS FLOAT)) AS max_icu_patients
FROM 
    dbo.CovidDeaths
GROUP BY 
    location
ORDER BY 
    max_icu_patients DESC;


-- 18. Weekly Hospital Admissions by Continent
SELECT 
    continent,
    AVG(CAST(weekly_hosp_admissions AS FLOAT)) AS avg_weekly_hospital_admissions
FROM 
    dbo.CovidDeaths
WHERE 
    ISNUMERIC(weekly_hosp_admissions) = 1
GROUP BY 
    continent;


-- 19. Countries with the Highest Excess Mortality
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


-- 20. Excess Mortality by Continent
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


-- 21. Top 10 Countries by Total Tests
SELECT TOP 10
    location AS country,
    MAX(CAST(total_tests AS FLOAT)) AS max_tests
FROM 
    dbo.CovidVaccinations
GROUP BY 
    location
ORDER BY 
    max_tests DESC;

-- 22. Positive Test Rate by Country
SELECT TOP 10
    location,
    AVG(CAST(positive_rate AS FLOAT)) AS avg_positive_rate
FROM 
    dbo.CovidVaccinations
GROUP BY 
    location
ORDER BY 
    avg_positive_rate DESC;

-- 23. Testing Rate Per Thousand by Continent
SELECT 
    continent,
    AVG(CAST(total_tests_per_thousand AS FLOAT)) AS avg_tests_per_thousand
FROM 
    dbo.CovidVaccinations
WHERE 
    ISNUMERIC(total_tests_per_thousand) = 1
GROUP BY 
    continent;


-- 24. Relationship Between Median Age and Death Rate
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
    d.total_cases IS NOT NULL AND CAST(d.total_cases AS FLOAT) > 0
GROUP BY 
    v.median_age;


-- 25. Impact of Handwashing Facilities on Cases
SELECT 
    v.location,
    AVG(v.handwashing_facilities) AS avg_handwashing_facilities,
    SUM(d.total_cases) AS total_cases
FROM 
    dbo.CovidVaccinations v
INNER JOIN 
    dbo.CovidDeaths d
ON 
    v.location = d.location
WHERE 
    v.handwashing_facilities IS NOT NULL
GROUP BY 
    v.location;

-- 26. Global Average Life Expectancy
SELECT 
    AVG(life_expectancy) AS avg_life_expectancy
FROM 
    dbo.CovidVaccinations;

-- 27. New Cases Per Million by Continent
SELECT 
    continent,
    AVG(new_cases_per_million) AS avg_new_cases_per_million
FROM 
    dbo.CovidDeaths
GROUP BY 
    continent;

-- 28. Countries with the Lowest Death Rates
SELECT TOP 10
    location AS country,
    (SUM(CAST(total_deaths AS FLOAT)) * 100.0 / NULLIF(SUM(CAST(total_cases AS FLOAT)), 0)) AS death_rate_percentage
FROM 
    dbo.CovidDeaths
GROUP BY 
    location
ORDER BY 
    death_rate_percentage ASC;


-- 29. Top 10 Countries with Highest Deaths Per Million
SELECT TOP 10
    location,
    MAX(CAST(total_deaths_per_million AS FLOAT)) AS max_deaths_per_million
FROM 
    dbo.CovidDeaths
GROUP BY 
    location
ORDER BY 
    max_deaths_per_million DESC;

-- 30. Daily ICU Admissions Trend
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


















	-- SQL Queries for COVID-19 Advanced Analysis

-- 1. Top 10 Countries by New Deaths
SELECT TOP 10
    location AS country,
    MAX(CAST(new_deaths AS FLOAT)) AS max_new_deaths
FROM 
    dbo.CovidDeaths
GROUP BY 
    location
ORDER BY 
    max_new_deaths DESC;

-- 2. New Deaths Per Million by Continent
SELECT 
    continent,
    AVG(CAST(new_deaths_per_million AS FLOAT)) AS avg_new_deaths_per_million
FROM 
    dbo.CovidDeaths
GROUP BY 
    continent;

-- 3. Top 10 Countries with the Highest Death Rate Per Million
SELECT TOP 10
    location AS country,
    MAX(CAST(total_deaths_per_million AS FLOAT)) AS highest_death_rate_per_million
FROM 
    dbo.CovidDeaths
GROUP BY 
    location
ORDER BY 
    highest_death_rate_per_million DESC;

-- 4. Daily New Cases vs. New Deaths Globally
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

-- 5. Top 10 Countries with Lowest Case Fatality Rates
SELECT TOP 10
    location AS country,
    (SUM(CAST(total_deaths AS FLOAT)) * 100.0 / NULLIF(SUM(CAST(total_cases AS FLOAT)), 0)) AS case_fatality_rate
FROM 
    dbo.CovidDeaths
WHERE 
    total_cases > 0
GROUP BY 
    location
ORDER BY 
    case_fatality_rate ASC;

-- 6. Vaccination Progress Over Time by Continent
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

-- 7. Countries with the Highest Booster Rates
SELECT 
    location AS country,
    MAX(CAST(total_boosters_per_hundred AS FLOAT)) AS highest_booster_rate
FROM 
    dbo.CovidVaccinations
GROUP BY 
    location
ORDER BY 
    highest_booster_rate DESC;

-- 8. Vaccination Rates by Population Size
-- SQL Queries for COVID-19 Advanced Analysis

-- 1. Top 10 Countries by New Deaths
SELECT TOP 10
    location AS country,
    MAX(CAST(new_deaths AS FLOAT)) AS max_new_deaths
FROM 
    dbo.CovidDeaths
GROUP BY 
    location
ORDER BY 
    max_new_deaths DESC;

-- 2. New Deaths Per Million by Continent
SELECT 
    continent,
    AVG(CAST(new_deaths_per_million AS FLOAT)) AS avg_new_deaths_per_million
FROM 
    dbo.CovidDeaths
GROUP BY 
    continent;

-- 3. Top 10 Countries with the Highest Death Rate Per Million
SELECT TOP 10
    location AS country,
    MAX(CAST(total_deaths_per_million AS FLOAT)) AS highest_death_rate_per_million
FROM 
    dbo.CovidDeaths
GROUP BY 
    location
ORDER BY 
    highest_death_rate_per_million DESC;

-- 4. Daily New Cases vs. New Deaths Globally
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

-- 5. Top 10 Countries with Lowest Case Fatality Rates
SELECT TOP 10
    location AS country,
    (SUM(CAST(total_deaths AS FLOAT)) * 100.0 / NULLIF(SUM(CAST(total_cases AS FLOAT)), 0)) AS case_fatality_rate
FROM 
    dbo.CovidDeaths
WHERE 
    total_cases > 0
GROUP BY 
    location
ORDER BY 
    case_fatality_rate ASC;

-- 6. Vaccination Progress Over Time by Continent
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

-- 7. Countries with the Highest Booster Rates
SELECT 
    location AS country,
    MAX(CAST(total_boosters_per_hundred AS FLOAT)) AS highest_booster_rate
FROM 
    dbo.CovidVaccinations
GROUP BY 
    location
ORDER BY 
    highest_booster_rate DESC;

-- 8. Vaccination Rates by Population Size
SELECT 
    v.location AS country,
    MAX(CAST(d.population AS FLOAT)) AS population,
    AVG(CAST(v.people_vaccinated_per_hundred AS FLOAT)) AS avg_vaccinated_per_hundred
FROM 
    dbo.CovidVaccinations v
LEFT JOIN 
    dbo.CovidDeaths d
ON 
    v.location = d.location
GROUP BY 
    v.location
ORDER BY 
    avg_vaccinated_per_hundred DESC;


-- 9. Relationship Between Life Expectancy and Vaccination Rates
SELECT 
    AVG(CAST(life_expectancy AS FLOAT)) AS avg_life_expectancy,
    AVG(CAST(people_vaccinated_per_hundred AS FLOAT)) AS avg_vaccinated_rate
FROM 
    dbo.CovidVaccinations
WHERE 
    life_expectancy IS NOT NULL;

-- 10. Top 5 Continents by Vaccination Rates
SELECT TOP 5
    continent,
    AVG(CAST(people_vaccinated_per_hundred AS FLOAT)) AS avg_vaccination_rate
FROM 
    dbo.CovidVaccinations
GROUP BY 
    continent
ORDER BY 
    avg_vaccination_rate DESC;

-- 11. Top 10 Countries by Total Tests
SELECT TOP 10
    location AS country,
    SUM(CAST(total_tests AS FLOAT)) AS total_tests
FROM 
    dbo.CovidVaccinations
GROUP BY 
    location
ORDER BY 
    total_tests DESC;

-- 12. Positive Test Rates by Continent
SELECT 
    continent,
    AVG(CAST(positive_rate AS FLOAT)) AS avg_positive_rate
FROM 
    dbo.CovidVaccinations
GROUP BY 
    continent;

-- 13. Countries with Highest Positive Test Rates
SELECT TOP 10
    location AS country,
    MAX(CAST(positive_rate AS FLOAT)) AS highest_positive_rate
FROM 
    dbo.CovidVaccinations
GROUP BY 
    location
ORDER BY 
    highest_positive_rate DESC;

-- 14. Top 10 Countries by ICU Admissions
SELECT TOP 10
    location AS country,
    MAX(CAST(icu_patients AS FLOAT)) AS max_icu_patients
FROM 
    dbo.CovidDeaths
GROUP BY 
    location
ORDER BY 
    max_icu_patients DESC;

-- 15. Hospital Patients Per Million by Continent
SELECT 
    continent,
    AVG(CAST(hosp_patients_per_million AS FLOAT)) AS avg_hospital_patients_per_million
FROM 
    dbo.CovidDeaths
GROUP BY 
    continent;

-- 16. Countries with Highest Weekly ICU Admissions
SELECT TOP 10
    location AS country,
    MAX(CAST(weekly_icu_admissions AS FLOAT)) AS max_weekly_icu_admissions
FROM 
    dbo.CovidDeaths
GROUP BY 
    location
ORDER BY 
    max_weekly_icu_admissions DESC;

-- 17. Deaths Per Million Over Time by Continent
SELECT 
    continent,
    date,
    AVG(CAST(total_deaths_per_million AS FLOAT)) AS avg_deaths_per_million
FROM 
    dbo.CovidDeaths
GROUP BY 
    continent, date
ORDER BY 
    date ASC;

-- 18. Excess Mortality by Country
SELECT 
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

-- 19. Correlation Between GDP and Case Fatality Rate
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

-- 20. Impact of Median Age on Death Rate
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

-- 21. Global Summary of New Cases and Deaths
SELECT 
    SUM(CAST(new_cases AS FLOAT)) AS total_new_cases,
    SUM(CAST(new_deaths AS FLOAT)) AS total_new_deaths
FROM 
    dbo.CovidDeaths;

-- 22. Top 10 Countries by Life Expectancy
SELECT TOP 10
    location AS country,
    MAX(CAST(life_expectancy AS FLOAT)) AS max_life_expectancy
FROM 
    dbo.CovidVaccinations
GROUP BY 
    location
ORDER BY 
    max_life_expectancy DESC;

-- 23. Vaccination Trends by Week
SELECT 
    DATEPART(WEEK, date) AS week,
    SUM(CAST(new_vaccinations AS FLOAT)) AS weekly_vaccinations
FROM 
    dbo.CovidVaccinations
GROUP BY 
    DATEPART(WEEK, date)
ORDER BY 
    week ASC;

-- 24. Deaths Per Month by Continent
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

-- 25. Top 10 Countries with the Highest Population
SELECT TOP 10
    location AS country,
    MAX(CAST(population AS FLOAT)) AS population
FROM 
    dbo.CovidDeaths
GROUP BY 
    location
ORDER BY 
    population DESC;

-- 26. Countries with Lowest Vaccination Rates
SELECT TOP 10
    location AS country,
    MIN(CAST(people_vaccinated_per_hundred AS FLOAT)) AS lowest_vaccination_rate
FROM 
    dbo.CovidVaccinations
GROUP BY 
    location
ORDER BY 
    lowest_vaccination_rate ASC;


-- 9. Relationship Between Life Expectancy and Vaccination Rates
SELECT 
    AVG(CAST(life_expectancy AS FLOAT)) AS avg_life_expectancy,
    AVG(CAST(people_vaccinated_per_hundred AS FLOAT)) AS avg_vaccinated_rate
FROM 
    dbo.CovidVaccinations
WHERE 
    life_expectancy IS NOT NULL;

-- 10. Top 5 Continents by Vaccination Rates
SELECT TOP 5
    continent,
    AVG(CAST(people_vaccinated_per_hundred AS FLOAT)) AS avg_vaccination_rate
FROM 
    dbo.CovidVaccinations
GROUP BY 
    continent
ORDER BY 
    avg_vaccination_rate DESC;

-- 11. Top 10 Countries by Total Tests
SELECT TOP 10
    location AS country,
    SUM(CAST(total_tests AS FLOAT)) AS total_tests
FROM 
    dbo.CovidVaccinations
GROUP BY 
    location
ORDER BY 
    total_tests DESC;

-- 12. Positive Test Rates by Continent
SELECT 
    continent,
    AVG(CAST(positive_rate AS FLOAT)) AS avg_positive_rate
FROM 
    dbo.CovidVaccinations
GROUP BY 
    continent;

-- 13. Countries with Highest Positive Test Rates
SELECT TOP 10
    location AS country,
    MAX(CAST(positive_rate AS FLOAT)) AS highest_positive_rate
FROM 
    dbo.CovidVaccinations
GROUP BY 
    location
ORDER BY 
    highest_positive_rate DESC;

-- 14. Top 10 Countries by ICU Admissions
SELECT TOP 10
    location AS country,
    MAX(CAST(icu_patients AS FLOAT)) AS max_icu_patients
FROM 
    dbo.CovidDeaths
GROUP BY 
    location
ORDER BY 
    max_icu_patients DESC;

-- 15. Hospital Patients Per Million by Continent
SELECT 
    continent,
    AVG(CAST(hosp_patients_per_million AS FLOAT)) AS avg_hospital_patients_per_million
FROM 
    dbo.CovidDeaths
GROUP BY 
    continent;

-- 16. Countries with Highest Weekly ICU Admissions
SELECT TOP 10
    location AS country,
    MAX(CAST(weekly_icu_admissions AS FLOAT)) AS max_weekly_icu_admissions
FROM 
    dbo.CovidDeaths
GROUP BY 
    location
ORDER BY 
    max_weekly_icu_admissions DESC;

-- 17. Deaths Per Million Over Time by Continent
SELECT 
    continent,
    date,
    AVG(CAST(total_deaths_per_million AS FLOAT)) AS avg_deaths_per_million
FROM 
    dbo.CovidDeaths
GROUP BY 
    continent, date
ORDER BY 
    date ASC;

-- 18. Excess Mortality by Country
SELECT 
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

-- 19. Correlation Between GDP and Case Fatality Rate
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

-- 20. Impact of Median Age on Death Rate
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

-- 21. Global Summary of New Cases and Deaths
SELECT 
    SUM(CAST(new_cases AS FLOAT)) AS total_new_cases,
    SUM(CAST(new_deaths AS FLOAT)) AS total_new_deaths
FROM 
    dbo.CovidDeaths;

-- 22. Top 10 Countries by Life Expectancy
SELECT TOP 10
    location AS country,
    MAX(CAST(life_expectancy AS FLOAT)) AS max_life_expectancy
FROM 
    dbo.CovidVaccinations
GROUP BY 
    location
ORDER BY 
    max_life_expectancy DESC;

-- 23. Vaccination Trends by Week
SELECT 
    DATEPART(WEEK, date) AS week,
    SUM(CAST(new_vaccinations AS FLOAT)) AS weekly_vaccinations
FROM 
    dbo.CovidVaccinations
GROUP BY 
    DATEPART(WEEK, date)
ORDER BY 
    week ASC;

-- 24. Deaths Per Month by Continent
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

-- 25. Top 10 Countries with the Highest Population
SELECT TOP 10
    location AS country,
    MAX(CAST(population AS FLOAT)) AS population
FROM 
    dbo.CovidDeaths
GROUP BY 
    location
ORDER BY 
    population DESC;

-- 26. Countries with Lowest Vaccination Rates
SELECT TOP 10
    location AS country,
    MIN(CAST(people_vaccinated_per_hundred AS FLOAT)) AS lowest_vaccination_rate
FROM 
    dbo.CovidVaccinations
GROUP BY 
    location
ORDER BY 
    lowest_vaccination_rate ASC;
