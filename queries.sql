DROP VIEW IF EXISTS Q1CountryYear CASCADE;
DROP VIEW IF EXISTS Q1Info CASCADE;
DROP VIEW IF EXISTS Q1Maxgdp CASCADE;
DROP VIEW IF EXISTS Q1Maxgrowth CASCADE;
DROP VIEW IF EXISTS Q1Maxincome CASCADE;
DROP VIEW IF EXISTS Q1gdpemission CASCADE;
DROP VIEW IF EXISTS Q1growthemission CASCADE;
DROP VIEW IF EXISTS Q1incomeemission CASCADE;
DROP VIEW IF EXISTS Q1EmissionTemp CASCADE;

CREATE VIEW Q1CountryYear AS
SELECT country, year
FROM economics
NATURAL INNER JOIN emission
NATURAL INNER JOIN temperature;

CREATE VIEW Q1Info AS
SELECT DISTINCT *
FROM Q1CountryYear
NATURAL INNER JOIN economics
NATURAL INNER JOIN emission
NATURAL INNER JOIN temperature;

CREATE VIEW Q1Maxgdp AS
SELECT year, continent, MAX(gdppercapita) AS maxgdp
FROM Q1Info
GROUP BY year, continent
Order by continent, year;

CREATE VIEW Q1Maxgrowth AS
SELECT year, continent, MAX(gdpgrowthpercapita) AS maxgrowth
FROM Q1Info
GROUP BY year, continent
Order by continent, year;

CREATE VIEW Q1Maxincome AS
SELECT year, continent, MAX(incomepercapita) AS maxincome
FROM Q1Info
GROUP BY year, continent
Order by continent, year;

CREATE VIEW Q1GDPEmission AS
SELECT DISTINCT year, continent, MAX(maxgdp) AS maxgdp, SUM(amount) AS emission
FROM Q1Maxgdp
NATURAL INNER JOIN
	(SELECT year, continent, gdppercapita AS maxgdp, amount FROM Q1info) AS Temp
GROUP BY year, continent, maxgdp
ORDER BY continent, year;
--- ORDER BY continent, maxgdp;

--------Time is a better indicator about emission than gdp/ no clear sign

CREATE VIEW Q1GrowthEmission AS
SELECT DISTINCT year, continent, MAX(maxgrowth) AS maxgrowth, SUM(amount) AS emission
FROM Q1Maxgrowth
NATURAL INNER JOIN
	(SELECT year, continent, gdpGrowthPerCapita AS maxgrowth, amount FROM Q1info) AS Temp
GROUP BY year, continent, maxgrowth
ORDER BY continent, year;
--- ORDER BY continent, maxgrowth;

-------Some significant gdp growth can imply emission drop

CREATE VIEW Q1IncomeEmission AS
SELECT DISTINCT year, continent, MAX(maxincome) AS maxincome, SUM(amount) AS emission
FROM Q1Maxincome
NATURAL INNER JOIN
	(SELECT year, continent, incomepercapita AS maxincome, amount FROM Q1info) AS Temp
GROUP BY year, continent, maxincome
ORDER BY continent, maxincome;
--- ORDER BY continent, maxincome;

------ Time is a better indicator about emission than income/ no clear sign

CREATE VIEW Q1EmissionTemp AS
SELECT country, year, SUM(amount) AS emission, MAX(value) AS temperature
FROM Q1info
GROUP BY country, year
ORDER BY country, year;
--- ORDER BY country, emission;

------- Significant number of countries have temperature increase over the years
------- Emission cannot affect temperature over the duration of a year