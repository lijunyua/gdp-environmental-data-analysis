DROP VIEW IF EXISTS Q3CountryYear CASCADE;
DROP VIEW IF EXISTS Q3Info CASCADE;
DROP VIEW IF EXISTS Q3MaxForestArea CASCADE;
DROP VIEW IF EXISTS Q3MaxDepletion CASCADE;
DROP VIEW IF EXISTS Q3MaxWaterAccess CASCADE;
DROP VIEW IF EXISTS Q3MaxElecAccess CASCADE;
DROP VIEW IF EXISTS Q3MaxEnergyUse CASCADE;
DROP VIEW IF EXISTS Q3MaxElecRenew CASCADE;
DROP VIEW IF EXISTS Q3MaxElecUnrenew CASCADE;
DROP VIEW IF EXISTS Q3ForestAreaEmission CASCADE;
DROP VIEW IF EXISTS Q3MaxDepletionEmission CASCADE;
DROP VIEW IF EXISTS Q3MaxWaterAccessEmission CASCADE;
DROP VIEW IF EXISTS Q3ElecAccessEmission CASCADE;
DROP VIEW IF EXISTS Q3EnergyUseEmission CASCADE;
DROP VIEW IF EXISTS Q3ElecRenewEmission CASCADE;
DROP VIEW IF EXISTS Q3ElecUnrenewEmission CASCADE;


CREATE VIEW Q3CountryYear AS
SELECT country, year
FROM resources
NATURAL INNER JOIN energy
NATURAL INNER JOIN emission;

CREATE VIEW Q3Info AS
SELECT DISTINCT *
FROM Q3CountryYear
NATURAL INNER JOIN resources
NATURAL INNER JOIN energy
NATURAL INNER JOIN emission;

CREATE VIEW Q3MaxForestArea AS
SELECT year, continent, MAX(forestarea) AS maxforestarea
FROM Q3Info
GROUP BY year, continent
Order by continent, year;

CREATE VIEW Q3MaxDepletion AS
SELECT year, continent, MAX(mineraldepletion) AS maxdepletion
FROM Q3Info
GROUP BY year, continent
Order by continent, year;

CREATE VIEW Q3MaxWaterAccess AS
SELECT year, continent, MAX(accesstocleanwater) AS maxwateraccess
FROM Q3Info
GROUP BY year, continent
Order by continent, year;

CREATE VIEW Q3MaxElecAccess AS
SELECT year, continent, MAX(accesstoelectricity) AS maxelecaccess
FROM Q3Info
GROUP BY year, continent
Order by continent, year;

CREATE VIEW Q3MaxEnergyUse AS
SELECT year, continent, MAX(energyuse) AS maxenergyuse
FROM Q3Info
GROUP BY year, continent
Order by continent, year;

CREATE VIEW Q3MaxElecRenew AS
SELECT year, continent, MAX(electricityrenewable) AS maxelecrenew
FROM Q3Info
GROUP BY year, continent
Order by continent, year;

CREATE VIEW Q3MaxElecUnrenew AS
SELECT year, continent, MAX(electricityunrenewable) AS maxelecunrenew
FROM Q3Info
GROUP BY year, continent
Order by continent, year;


CREATE VIEW Q3ForestAreaEmission AS
SELECT DISTINCT year, continent, MAX(maxforestarea) AS maxforestarea, SUM(amount) AS emission
FROM Q3MaxForestArea
NATURAL INNER JOIN
	(SELECT year, continent, forestarea AS maxforestarea, amount FROM Q3info) AS Temp
GROUP BY year, continent, maxforestarea
ORDER BY continent, year;
-- ORDER BY continent, maxforestarea;

--- AS forest area increases emission tend to decrease

CREATE VIEW Q3MaxDepletionEmission AS
SELECT DISTINCT year, continent, MAX(maxdepletion) AS maxdepletion, SUM(amount) AS emission
FROM Q3MaxDepletion
NATURAL INNER JOIN
	(SELECT year, continent, mineraldepletion AS maxdepletion, amount FROM Q3info) AS Temp
GROUP BY year, continent, maxdepletion
ORDER BY continent, year;
-- ORDER BY continent, maxdepletion

-- Mineral depletion has no clear correlation with emission

CREATE VIEW Q3MaxWaterAccessEmission AS
SELECT DISTINCT year, continent, MAX(maxwateraccess) AS maxwateraccess, SUM(amount) AS emission
FROM Q3MaxWaterAccess
NATURAL INNER JOIN
	(SELECT year, continent, accesstocleanwater AS maxwateraccess, amount FROM Q3info) AS Temp
GROUP BY year, continent, maxwateraccess
ORDER BY continent, year;
-- ORDER BY continent, maxwateraccess

-- Water access has no clear correlation with emission


CREATE VIEW Q3ElecAccessEmission AS
SELECT DISTINCT year, continent, MAX(maxelecaccess) AS maxelecaccess, SUM(amount) AS emission
FROM Q3MaxElecAccess
NATURAL INNER JOIN
	(SELECT year, continent, accesstoelectricity AS maxelecaccess, amount FROM Q3info) AS Temp
GROUP BY year, continent, maxelecaccess
ORDER BY continent, year;

-- Cannot conclude since electricity access percentage is
-- too close to 100 percent

CREATE VIEW Q3EnergyUseEmission AS
SELECT DISTINCT year, continent, MAX(maxenergyuse) AS maxenergyuse, SUM(amount) AS emission
FROM Q3MaxEnergyUse
NATURAL INNER JOIN
	(SELECT year, continent, energyuse AS maxenergyuse, amount FROM Q3info) AS Temp
GROUP BY year, continent, maxenergyuse
ORDER BY continent, year;

-- Emission increases when energy use is increased, but with fluctuations
-- So the conclusion above is not guaranteed

CREATE VIEW Q3ElecRenewEmission AS
SELECT DISTINCT year, continent, MAX(maxelecrenew) AS maxelecrenew, SUM(amount) AS emission
FROM Q3MaxElecRenew
NATURAL INNER JOIN
	(SELECT year, continent, electricityrenewable AS maxelecrenew, amount FROM Q3info) AS Temp
GROUP BY year, continent, maxelecrenew
ORDER BY continent, year;

-- Emission generally decreases when renewable energy is more used but with exceptions

CREATE VIEW Q3ElecUnrenewEmission AS
SELECT DISTINCT year, continent, MAX(maxelecunrenew) AS maxelecunrenew, SUM(amount) AS emission
FROM Q3MaxElecUnrenew
NATURAL INNER JOIN
	(SELECT year, continent, electricityunrenewable AS maxelecunrenew, amount FROM Q3info) AS Temp
GROUP BY year, continent, maxelecunrenew
ORDER BY continent, year;

-- Emission trend is not clear when unrenewable energy is more used









