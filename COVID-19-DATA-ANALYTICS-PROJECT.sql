-- Raw Data Query
SELECT * 
FROM PortfolioProject..CovidDeaths;

-- Global Percentage of Deaths
SELECT location, date, total_cases, total_deaths, 
       (total_deaths/total_cases)*100 AS Percentage_of_Deaths
FROM PortfolioProject..CovidDeaths;

-- Percentage of Deaths in India
SELECT location, date, total_cases, total_deaths, 
       ROUND((total_deaths/total_cases)*100, 2) AS Percentage_of_Deaths
FROM PortfolioProject..CovidDeaths
WHERE location = 'India';

-- Highest Death Rate in the United States
-- Shows the likelihood of dying if infected
SELECT TOP 1 location, date, total_cases, total_deaths, 
       ROUND((total_deaths/total_cases)*100, 2) AS Percentage_of_Deaths
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%states%'
ORDER BY Percentage_of_Deaths DESC;

-- Total Cases vs Population
-- Shows what percentage of population got COVID
SELECT location, date, total_cases, total_deaths, population, 
       ROUND((total_cases/population)*100, 3) AS Percentage_of_PopulationAffected
FROM PortfolioProject..CovidDeaths;

-- Max Percentage of Population Affected by COVID in India
SELECT TOP 1 location, date, total_cases, total_deaths, population, 
       ROUND((total_cases/population)*100, 3) AS Percentage_of_PopulationAffected
FROM PortfolioProject..CovidDeaths
WHERE location = 'India'
ORDER BY Percentage_of_PopulationAffected DESC;

-- Country with Highest Infection Rate Compared to Population
SELECT TOP 1 location, date, total_cases, total_deaths, population, 
       ROUND((total_cases/population)*100, 3) AS Percentage_of_PopulationAffected
FROM PortfolioProject..CovidDeaths
ORDER BY Percentage_of_PopulationAffected DESC;

-- Country with the Most Deaths Due to COVID
SELECT location, MAX(CAST(total_deaths AS INT)) AS Total_Death_Count
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY Total_Death_Count DESC;

-- Country with Highest Death Count per Population
SELECT TOP 1 location, date, total_cases, total_deaths, population, 
       ROUND((total_deaths/population)*100, 3) AS Percentage_of_PopulationDied
FROM PortfolioProject..CovidDeaths
ORDER BY Percentage_of_PopulationDied DESC;

-- Continents with Highest Death Count
SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- Global Numbers
SELECT 
    SUM(new_cases) AS total_cases, 
    SUM(CAST(new_deaths AS INT)) AS total_deaths, 
    SUM(CAST(new_deaths AS INT)) / SUM(new_cases) * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;

-- Total Population vs Vaccinations
-- Shows % of population that received at least one COVID vaccine
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3;

-- Using CTE to Calculate % of Population Vaccinated
WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) AS (
    SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
           SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
    FROM PortfolioProject..CovidDeaths dea
    JOIN PortfolioProject..CovidVaccinations vac
        ON dea.location = vac.location AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
)
SELECT *, ROUND((RollingPeopleVaccinated / Population) * 100, 2)
FROM PopvsVac;

-- Using Temp Table to Calculate % of Population Vaccinated
DROP TABLE IF EXISTS #PercentPopulationVaccinated;

CREATE TABLE #PercentPopulationVaccinated (
    Continent NVARCHAR(255),
    Location NVARCHAR(255),
    Date DATETIME,
    Population NUMERIC,
    New_vaccinations NUMERIC,
    RollingPeopleVaccinated NUMERIC
);

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location AND dea.date = vac.date;

SELECT *, (RollingPeopleVaccinated / Population) * 100
FROM #PercentPopulationVaccinated;

-- Creating View to Store Data for Visualization
CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;
