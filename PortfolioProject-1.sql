Select * 
From PortfolioProject..CovidDeaths$
order by 3,4

--Select * 
--From PortfolioProject..CovidVaccinations$
--order by 3,4

--Select the data that will be used

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths$
order by 1,2

--TotalCases VS TotalDeaths
--likehood of dying if your country encountered COVID

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases) *100 as DeathPercentage
From PortfolioProject..CovidDeaths$
where location like '%india'
order by 1,2

--Shows the percentange of population who were infected from COVID

Select Location, date, population, total_cases, (total_cases/population) *100 as InfectedPercentagePopulation
From PortfolioProject..CovidDeaths$
where location like '%india'
order by 1,2

-- showing the countries with highest infection percentage
Select Location,population, MAX(total_cases) as HighestInfected , MAX((total_cases/population)) *100 as InfectedPercentagePopulation
From PortfolioProject..CovidDeaths$
group by location, population
order by 1,2

--shows the countries with highest death count
Select Location, MAX(total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths$
group by location
order by 1,2

Select Location, MAX(CAST (total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
where continent is not null
group by location
order by TotalDeathCount desc

--By continent with highest death count
Select continent, MAX(CAST (total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
where continent is not null
group by continent
order by TotalDeathCount desc

--Global Numbers
Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int)) / SUM(NEW_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
where continent is not null
Group By date
order by 1,2

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int)) / SUM(NEW_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
where continent is not null
--Group By date
order by 1,2

Select *
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date

--Looking at the total population vs vaccinations

--TEMP table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)



Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
SUM(cast(new_vaccinations as int)) OVER (Partition by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
order by 2,3

Select*, (RollingPeopleVaccinated/Population) * 100
From #PercentPopulationVaccinated

--Creating view to store data for later visulaization

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
SUM(cast(new_vaccinations as int)) OVER (Partition by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

