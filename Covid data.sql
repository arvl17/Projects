-- Selecting data

Select continent, date, total_cases, new_cases, total_deaths, population
from PortfolioProjects..CovidDeaths
Order by 1,2

-- Total cases vs Total deaths

Select continent, date, total_cases, total_deaths, (total_deaths/NULLIF(total_cases,0)) as DeathToll
from PortfolioProjects..CovidDeaths
Order by 1,2

--Total cases vs Total deaths in Percentage

Select continent, date, total_cases, total_deaths, (total_deaths/NULLIF(total_cases,0))*100 as DeathTollPercentage
from PortfolioProjects..CovidDeaths
where location like '%India%' and continent is not null
Order by 1,2

-- Total cases in 1 country vs population in Percentage

Select continent, population, total_cases, (total_cases/population)*100 as PopPercentage
from PortfolioProjects..CovidDeaths
where location like '%India%'
and continent is not null
Order by 1,2

-- Continents with Highest COVID cases 

Select continent, population, MAX(total_cases) as HighestCases, MAX((total_cases/population))*100 as PopPercentage
from PortfolioProjects..CovidDeaths
where continent is not null
Group by continent, population
Order by PopPercentage desc

-- Continents with Highest Death counts

Select continent, MAX(total_deaths) as HighestDeath
from PortfolioProjects..CovidDeaths
where continent is not null
Group by continent
Order by HighestDeath desc

-- Global cases

Select date, SUM(new_cases) as GlobalCases, SUM(new_deaths) as GlobalDeaths,(SUM(new_deaths) / NULLIF(SUM(new_cases), 0))*100 as DeathPercentage
from PortfolioProjects..CovidDeaths
where continent is not null
Group by date, (new_deaths/NULLIF(new_cases,0))*100
order by 1

SELECT SUM(new_cases) AS GlobalCases, SUM(new_deaths) AS GlobalDeaths, (SUM(new_deaths) / NULLIF(SUM(new_cases), 0)) * 100 AS DeathPercentage
FROM PortfolioProjects..CovidDeaths
WHERE continent IS NOT NULL;

--Vaccination Records

Select d.date, d.location, d.continent, d.population, v.new_vaccinations,
SUM(CAST(v.new_vaccinations as bigint)) OVER (Partition by d.location order by d.location, d.date) as TotalVaccinations
from PortfolioProjects..CovidDeaths d
Join PortfolioProjects..CovidVaccinations v
on d.location = v.location
and d.date = v.date
where d.continent is not null
order by 1,2

-- Using CTE

With popvsvac (date, location, continent, population, new_vaccinations, TotalVaccincations)
as 
(
Select d.date, d.location, d.continent, d.population, v.new_vaccinations,
SUM(CAST(v.new_vaccinations as bigint)) OVER (Partition by d.location order by d.location, d.date) as TotalVaccinations
from PortfolioProjects..CovidDeaths d
Join PortfolioProjects..CovidVaccinations v
on d.location = v.location
and d.date = v.date
where d.continent is not null
)
Select *, (TotalVaccincations/population)*100 from popvsvac



--Temp Table

DROP TABLE IF EXISTS #PercentageofVaccinatedPopulation;

CREATE TABLE #PercentageofVaccinatedPopulation
(
    Continent NVARCHAR(255),
    Location NVARCHAR(255),
    Date DATETIME,
    Population NUMERIC,
    New_vaccinations NUMERIC,
    TotalVaccinations NUMERIC
);

INSERT INTO #PercentageofVaccinatedPopulation
Select d.continent, d.location, CAST(d.date AS DATETIME) AS Date, d.population,  
COALESCE(v.new_vaccinations, 0) AS New_vaccinations, -- Replace NULL with 0
SUM(CAST(COALESCE(v.new_vaccinations, 0) AS BIGINT)) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS TotalVaccinations
from PortfolioProjects..CovidDeaths d
join PortfolioProjects..CovidVaccinations v
on d.location = v.location and CAST(d.date AS DATETIME) = CAST(v.date AS DATETIME)
where d.continent is not null;

Select *, (TotalVaccinations / Population) * 100 AS VaccinatedPopulation
from #PercentageofVaccinatedPopulation;




-- Creating View

Use PortfolioProjects
go 

Create View PercentageofVaccinatedPopulation as
Select d.date, d.location, d.continent, d.population, v.new_vaccinations,
SUM(CAST(v.new_vaccinations as bigint)) OVER (Partition by d.location order by d.location, d.date) as TotalVaccinations
from PortfolioProjects..CovidDeaths d
Join PortfolioProjects..CovidVaccinations v
on d.location = v.location
and d.date = v.date
where d.continent is not null