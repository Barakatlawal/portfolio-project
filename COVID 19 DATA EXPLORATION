select *
from [portfolio project]..CovidDeaths$
where continent is not null
order by 3, 4

--select *
--from [portfolio project]..Covidvaccination$
--order by 3, 4

-- select data to be used
select location, date, total_cases, new_cases, total_deaths, population
from [portfolio project]..CovidDeaths$
order by 1,2

--total cases vs total deaths

--shows likelihood of dying if you contract covid in Nigeria 

Select location, date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100 as DeathPercentage

From [portfolio project]..CovidDeaths$
where location like 'Nigeria'
Order by 1,2

--looking at total cases vs population

select location, date, total_cases, Population, (cast(total_cases as float)/cast(population as float))*100 as DeathPercentage

From [portfolio project]..CovidDeaths$
where location like 'Nigeria'
Order by 1,2

--looking at countries with highest infection rate compared to population

select location,Population,  max(total_cases) as HighestInfectionCount,  max((cast(total_cases as float)/cast(population as float)))*100 as PercentPopulationInfection
From [portfolio project]..CovidDeaths$

group by location, Population
Order by PercentPopulationInfection	 desc

--showing the countries with highest death count per population

select location, max(cast(total_deaths as int)) as TotalDeathCount
From [portfolio project]..CovidDeaths$
where continent is not null
group by location
Order by TotalDeathCount desc

--breaking it down by continent

select continent, max(cast(total_deaths as int)) as TotalDeathCount
From [portfolio project]..CovidDeaths$
where continent is not null
group by continent
Order by TotalDeathCount desc


-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From [portfolio project]..CovidDeaths$

--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

--looking at total population vs vaccinations
select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint )) over (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
from [portfolio project]..CovidDeaths$ dea
join [portfolio project]..Covidvaccination$ vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
order by 2,3

--USE CTE
with PopsVac(continent, location, date, population, New_Vaccinations, Rollingpeoplevaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint )) over (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
from [portfolio project]..CovidDeaths$ dea
join [portfolio project]..Covidvaccination$ vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--order by 2,3
)
select *, (Rollingpeoplevaccinated/population) *100
from PopsVac

--temp table

create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rollingpeoplevaccinated numeric
)
insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint )) over (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
from [portfolio project]..CovidDeaths$ dea
join [portfolio project]..Covidvaccination$ vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *, (Rollingpeoplevaccinated/population) *100
from #PercentPopulationVaccinated


--creating view for later visualization

create view PercentagePopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint )) over (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
from [portfolio project]..CovidDeaths$ dea
join [portfolio project]..Covidvaccination$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

