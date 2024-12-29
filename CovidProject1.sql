show databases;
create database covid;
use covid;

select * from coviddeaths where continent is not null order by 3,4 ;

select Location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths where continent is not null 
order by 1,2;

                 -- death_percentage in Africa country --
select Location , date , total_cases, total_deaths , round((total_deaths/total_cases)* 100, 2) as Death_percentage 
From CovidDeaths where continent is not null  and location like '%Africa%'
order by 1,2;

                 -- totalcases vs Population in Africa country --
select Location , date , Population , total_cases , round((total_cases/population)* 100, 2) as totalcases_percentage 
From CovidDeaths where continent is not null  and location like '%Africa%'
order by 1,2;

                 -- distinct country with highest cases --
select distinct Location , Population, MAX(total_cases) as HighestInfectionCount,  round(Max((total_cases/Population))*100 , 2) as HighestInfection_percentage
from coviddeaths where continent is not null 
group by 1 , 2 order by Location , HighestInfection_percentage desc ;

                 -- deathcount vs continent --
select distinct continent , MAX(Total_deaths) as TotalDeathCount
From CovidDeaths where continent is not null
Group by  continent
order by TotalDeathCount desc;


                 -- Case & View -- 
select distinct location , total_cases from coviddeaths where total_cases > 4000000 and continent is not null;
create view CaseF as select distinct location , total_cases from coviddeaths where total_cases > 4000000 and continent is not null ;
select * from CaseF;

                   -- Row Number --
select * from (select location , total_cases , row_number() over ( partition by location order by  total_cases desc ) as RN from coviddeaths) 
as subquery where RN >= 1 ; 

                    -- Case When --
select location , population , total_cases, case when total_cases > 4000000 then 'Atmost High'
when total_cases > 2000000 then 'Very High'
else 'High'
end as  Category from coviddeaths order by total_cases desc;


                         -- Joins --
select d1.continent , d1.location , d1.date , d1.population , v1.new_vaccinations from coviddeaths as d1 join covidvaccinations as v1 
on d1.location = v1.location and d1.date = v1.date where d1.continent is not null order by 1, 2 , 3;


						 -- Running Cases  & CTE --
select location , new_cases ,  sum(new_cases) over ( order by new_cases desc) as running_newcases from coviddeaths ;

select d1.continent , d1.location , d1.date , d1.population , v1.new_vaccinations ,
sum(new_cases) over ( order by new_cases ) as running_newcases from coviddeaths as d1 join covidvaccinations as v1 
on d1.location = v1.location and d1.date = v1.date where d1.continent is not null order by 2 , 3;

with pop as ( select d1.continent , d1.location , d1.date , d1.population , v1.new_vaccinations ,
sum(new_cases) over ( order by new_cases ) as running_newcases  from coviddeaths as d1 join covidvaccinations as v1 
on d1.location = v1.location and d1.date = v1.date where d1.continent is not null order by 2 , 3)
select continent , location , date , population , new_vaccinations ,running_newcases , round((running_newcases/population)*100 , 2 ) as running_percentage from  pop where running_newcases > 40000

 




