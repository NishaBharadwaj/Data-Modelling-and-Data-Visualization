--Queries for Tableau Project


--1

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where continent is not null
order by 1,2

--2

select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
where continent is null
and location not in('World', 'European Union', 'International')
group by location
order by TotalDeathCount desc

--3

select Location,Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths$
Group by Location, Population 
order by PercentPopulationInfected desc

--4

select Location, Population, date, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths$
Group by Location, Population, date
order by PercentPopulationInfected desc
