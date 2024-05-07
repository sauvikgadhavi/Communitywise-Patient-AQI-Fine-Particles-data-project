USE FinalProject;

SELECT * FROM dbo.AQI
SELECT * FROM dbo.Fine_Particles
SELECT * FROM dbo.Health_Statistics
SELECT * FROM dbo.Pharmacy_Data


SELECT FORMAT(ReadingDate, 'yyyy-MM') AS AQImonth_year
FROM dbo.AQI;


ALTER TABLE dbo.AQI
ADD AQImonth_year AS (FORMAT(ReadingDate, 'yyyy-MM'));

SELECT FORMAT(ReadingDate, 'yyyy-MM') AS FPmonth_year
FROM dbo.Fine_Particles;


ALTER TABLE dbo.Fine_Particles
ADD FPmonth_year AS (FORMAT(ReadingDate, 'yyyy-MM'));

ALTER TABLE dbo.AQI
DROP COLUMN month_year;

ALTER TABLE dbo.Fine_Particles
DROP COLUMN month_year;

ALTER TABLE dbo.Health_Statistics
ADD HSmonth_year AS (CONCAT(Year, '-', RIGHT('0' + CAST(Month AS VARCHAR(2)), 2)));

ALTER TABLE dbo.Pharmacy_Data
ADD PDmonth_year AS (CONCAT(Year, '-', RIGHT('0' + CAST(Month AS VARCHAR(2)), 2)));

EXEC sp_rename 'dbo.Pharmacy_Data.[Patient_Count]', 'Medicine_Count', 'COLUMN';


SELECT YEAR(ReadingDate) AS Year,
       MONTH(ReadingDate) AS Month,
       AVG(Value) AS Average_AQI
FROM dbo.AQI
GROUP BY YEAR(ReadingDate), MONTH(ReadingDate)
ORDER BY YEAR(ReadingDate), MONTH(ReadingDate);

SELECT 
    YEAR(ReadingDate) AS Year,
    MONTH(ReadingDate) AS Month,
    AVG(Value) AS Average_FineParticles,
    Units
FROM 
    dbo.Fine_Particles
GROUP BY 
    YEAR(ReadingDate), MONTH(ReadingDate), Units
ORDER BY 
    YEAR(ReadingDate), MONTH(ReadingDate);





SELECT
    a.year_month AS AQImonth_year,
    'AQI' AS Parameter,
    a.AQI AS Value,
    hs.Patient_count AS Health_Statistics_Patient_count,
	hs.Community AS CommunityName,
	hs.Category AS Category
FROM
    (SELECT 
        FORMAT(ReadingDate, 'yyyy-MM') AS year_month,
        AVG(Value) AS AQI
    FROM 
        FinalProject.dbo.AQI
	GROUP BY 
        FORMAT(ReadingDate, 'yyyy-MM')) AS a
LEFT JOIN 
    FinalProject.dbo.Health_Statistics AS hs ON a.year_month = hs.HSmonth_year
	ORDER BY Communityname, AQImonth_year;



SELECT
    a.year_month AS AQImonth_year,
    'AQI' AS Parameter,
    a.AQI AS Value,
    hs.Patient_count AS Health_Statistics_Patient_count,
    hs.Community AS CommunityName,
    hs.Category AS Category,
    pd.Shop AS ShopName,
    pd.Product_Category AS Product_Category,
    pd.Medicine_Count AS Medicine_Count
FROM
    (SELECT 
        FORMAT(ReadingDate, 'yyyy-MM') AS year_month,
        AVG(Value) AS AQI
    FROM 
        dbo.AQI
    GROUP BY 
        FORMAT(ReadingDate, 'yyyy-MM')) AS a
LEFT JOIN 
    dbo.Health_Statistics AS hs ON a.year_month = hs.HSmonth_year
LEFT JOIN 
    dbo.Pharmacy_Data AS pd ON a.year_month = pd.PDmonth_year
ORDER BY 
    CommunityName, AQImonth_year;


SELECT
    f.year_month AS FPmonth_year,
    'FineParticle' AS Parameter,
    f.FineParticle AS Value,
    hs.Patient_count AS Health_Statistics_Patient_count,
    hs.Community AS CommunityName,
    hs.Category AS Category,
    pd.Shop AS ShopName,
    pd.Product_Category AS Product_Category,
    pd.Medicine_Count AS Medicine_Count
FROM
    (SELECT 
        FORMAT(ReadingDate, 'yyyy-MM') AS year_month,
        AVG(Value) AS FineParticle
    FROM 
        dbo.Fine_Particles
    GROUP BY 
        FORMAT(ReadingDate, 'yyyy-MM')) AS f
LEFT JOIN 
    dbo.Health_Statistics AS hs ON f.year_month = hs.HSmonth_year
LEFT JOIN 
    dbo.Pharmacy_Data AS pd ON f.year_month = pd.PDmonth_year
ORDER BY 
    CommunityName, FPmonth_year, Category,ShopName, Product_Category;




SELECT
    a.year_month AS AQImonth_year,
    'AQI' AS Parameter,
    a.AQI AS Value,
    hs.Patient_count AS Health_Statistics_Patient_count,
    hs.Community AS CommunityName,
    hs.Category AS Category,
    pd.Shop AS ShopName,
    pd.Product_Category AS Product_Category,
	AVG(pd.Medicine_Count) AS Medicine_Count
FROM
    (SELECT 
        FORMAT(ReadingDate, 'yyyy-MM') AS year_month,
        AVG(Value) AS AQI
    FROM 
        dbo.AQI
    GROUP BY 
        FORMAT(ReadingDate, 'yyyy-MM')) AS a
LEFT JOIN 
    dbo.Health_Statistics AS hs ON a.year_month = hs.HSmonth_year
LEFT JOIN 
    dbo.Pharmacy_Data AS pd ON a.year_month = pd.PDmonth_year
WHERE
    hs.Community IS NOT NULL
GROUP BY
    a.year_month,
    a.AQI,
    hs.Patient_count,
    hs.Community,
    hs.Category,
    pd.Shop,
    pd.Product_Category
ORDER BY 
    CommunityName, AQImonth_year;







SELECT
    f.year_month AS FPmonth_year,
    'FineParticle' AS Parameter,
    f.FineParticle AS Value,
    hs.Patient_count AS Health_Statistics_Patient_count,
    hs.Community AS CommunityName,
    hs.Category AS Category,
    pd.Shop AS ShopName,
    pd.Product_Category AS Product_Category,
    AVG(pd.Medicine_Count) AS Medicine_Count
FROM
    (SELECT 
        FORMAT(ReadingDate, 'yyyy-MM') AS year_month,
        AVG(Value) AS FineParticle
    FROM 
        dbo.Fine_Particles
    GROUP BY 
        FORMAT(ReadingDate, 'yyyy-MM')) AS f
LEFT JOIN 
    dbo.Health_Statistics AS hs ON f.year_month = hs.HSmonth_year
LEFT JOIN 
    dbo.Pharmacy_Data AS pd ON f.year_month = pd.PDmonth_year
WHERE
    hs.Community IS NOT NULL
GROUP BY
    f.year_month,
    f.FineParticle,
    hs.Patient_count,
    hs.Community,
    hs.Category,
    pd.Shop,
    pd.Product_Category
ORDER BY 
    CommunityName, FPmonth_year, Category, ShopName, Product_Category;







SELECT
    a.year_month AS AQImonth_year,
    'AQI' AS Parameter,
    a.AQI AS Value,
    hs.Patient_count AS Health_Statistics_Patient_count,
    hs.Community AS CommunityName,
    hs.Category AS Category,
    pd.Shop AS ShopName,
    pd.Product_Category AS Product_Category,
    AVG(pd.Medicine_Count) AS Medicine_Count
INTO
    AQIHealthAnalysis
FROM
    (SELECT 
        FORMAT(ReadingDate, 'yyyy-MM') AS year_month,
        AVG(Value) AS AQI
    FROM 
        dbo.AQI
    GROUP BY 
        FORMAT(ReadingDate, 'yyyy-MM')) AS a
LEFT JOIN 
    dbo.Health_Statistics AS hs ON a.year_month = hs.HSmonth_year
LEFT JOIN 
    dbo.Pharmacy_Data AS pd ON a.year_month = pd.PDmonth_year
WHERE
    hs.Community IS NOT NULL
GROUP BY
    a.year_month,
    a.AQI,
    hs.Patient_count,
    hs.Community,
    hs.Category,
    pd.Shop,
    pd.Product_Category
ORDER BY 
    CommunityName, AQImonth_year;



SELECT * FROM AQIHealthAnalysis





SELECT
    f.year_month AS FPmonth_year,
    'FineParticle' AS Parameter,
    f.FineParticle AS Value,
    hs.Patient_count AS Health_Statistics_Patient_count,
    hs.Community AS CommunityName,
    hs.Category AS Category,
    pd.Shop AS ShopName,
    pd.Product_Category AS Product_Category,
    AVG(pd.Medicine_Count) AS Medicine_Count
INTO Fine_ParticlesAnalysis
FROM
    (SELECT 
        FORMAT(ReadingDate, 'yyyy-MM') AS year_month,
        AVG(Value) AS FineParticle
    FROM 
        dbo.Fine_Particles
    GROUP BY 
        FORMAT(ReadingDate, 'yyyy-MM')) AS f
LEFT JOIN 
    dbo.Health_Statistics AS hs ON f.year_month = hs.HSmonth_year
LEFT JOIN 
    dbo.Pharmacy_Data AS pd ON f.year_month = pd.PDmonth_year
WHERE
    hs.Community IS NOT NULL
GROUP BY
    f.year_month,
    f.FineParticle,
    hs.Patient_count,
    hs.Community,
    hs.Category,
    pd.Shop,
    pd.Product_Category;



SELECT * FROM Fine_ParticlesAnalysis;
