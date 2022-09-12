drop schema if exists ProjectSchema cascade;  
create schema ProjectSchema;  
set search_path to ProjectSchema;  

-- Limit years of all table from 2006 to 2015 to avoid null values in data
create domain Year as smallint  
        not null
        check (value >= 2006 and value <= 2015);  

-- Limit month to valid numbers
create domain Month as smallint  
        not null
        check (value >= 1 and value <= 12);  

-- Set emission categories to the 4 we are interested in
create domain EmissionCategory as text  
        not null  
        check (value in('Agriculture', 'Electricity', 'Transportation', 'Waste'));  
  
-- Set food categories to the 2 most common ones
create domain FoodCategory as text  
        not null  
        check (value in('Wheat', 'Rice'));  

-- The Economic situation of each country every year
-- Including gdp per capita, gdp growth per capita and income per capita
create table Economics(  
        country text not null,  
        continent text not null,  
        year Year,  
        gdpPerCapita integer not null,  
        gdpGrowthPerCapita numeric(4, 1) not null,  
        incomePerCapita real not null,  
        primary key (country, year));  

-- The Emission amounts of each country every year
-- Category limited to the 4 above
-- unit of amount not important since we're looking for trends
create table Emission(  
        country text,  
        continent text not null,  
        year Year,  
        category EmissionCategory,  
        amount real not null,  
        primary key (country, year, category),  
        constraint validCountryYear  
            foreign key (country, year) references Economics  
        );  

-- The food production amounts of each country every year
-- Category limited to the 2 above
-- unit of amount not important since we're looking for trends
create table FoodProduction(  
        country text not null,  
        continent text not null,  
        year Year,  
        category FoodCategory,  
        amount integer not null,  
        primary key (country, year, category),  
        constraint validCountryYear  
            foreign key (country, year) references Economics  
        );  

-- Energy consumption and the component sectors of each country
-- every year 
-- Including percentage of people that have access to electricity, 
-- amount of energy use (unit not important for the same reason)
-- Percentages of renewable and unrenewable electricity production
-- sources (not including some other methods)
create table Energy(  
        country text not null,  
        continent text not null,  
        year Year,  
        accessToElectricity numeric(4, 1) not null,  
        energyUse real not null,  
        electricityRenewable numeric(4, 1) not null,  
        electricityUnrenewable numeric(4, 1) not null,  
        primary key (country, year),  
        constraint validCountryYear  
            foreign key (country, year) references Economics  
        );  

-- Various kinds of resource use or depletion data for each country
-- every year 
-- Including total area of forests, amount of mineral depleted, 
-- and percentage of people who have access to clean water
create table Resources(  
        country text not null,  
        continent text not null,  
        year Year,  
        forestArea real not null,  
        mineralDepletion real not null,  
        accessToCleanWater numeric(4, 1) not null,  
        primary key (country, year),  
        constraint validCountryYear  
            foreign key (country, year) references Economics  
        );  

-- Temperature data of each country every year
-- Note: only one temperature data recorded for each country
-- every year due to database size, value is the temperature
-- in celcius
create table Temperature(  
        country text not null,  
        continent text not null,  
        year Year,  
        value real not null,  
        primary key (country, year),  
        constraint validCountryYear  
            foreign key (country, year) references Economics  
        );  