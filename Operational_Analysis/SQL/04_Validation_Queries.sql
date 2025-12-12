/*========================================================
  DATA VALIDATION QUERIES — OPERATIONAL ANALYSIS PROJECT
  Ensures data integrity before analytics
========================================================*/

----------------------------------------------------------
-- 1. Row counts for each table
----------------------------------------------------------
SELECT 
    (SELECT COUNT(*) FROM Dim_Region) AS Region_Count,
    (SELECT COUNT(*) FROM Dim_Product) AS Product_Count,
    (SELECT COUNT(*) FROM Dim_Machine) AS Machine_Count,
    (SELECT COUNT(*) FROM Dim_Employee) AS Employee_Count,
    (SELECT COUNT(*) FROM Dim_Date) AS Date_Count,
    (SELECT COUNT(*) FROM Fact_Production) AS Fact_Production_Count,
    (SELECT COUNT(*) FROM Fact_Quality) AS Fact_Quality_Count,
    (SELECT COUNT(*) FROM Fact_Logistics) AS Fact_Logistics_Count,
    (SELECT COUNT(*) FROM Fact_HR) AS Fact_HR_Count;


----------------------------------------------------------
-- 2. Check for NULL foreign keys in each fact table
----------------------------------------------------------
SELECT * FROM Fact_Production
WHERE Machine_ID IS NULL OR Employee_ID IS NULL OR Product_ID IS NULL OR Region_ID IS NULL;

SELECT * FROM Fact_Quality
WHERE Product_ID IS NULL OR Region_ID IS NULL OR Date_ID IS NULL;

SELECT * FROM Fact_Logistics
WHERE Product_ID IS NULL OR Region_ID IS NULL OR Date_ID IS NULL;

SELECT * FROM Fact_HR
WHERE Employee_ID IS NULL OR Region_ID IS NULL;


----------------------------------------------------------
-- 3. Validate date key existence in date dimension
----------------------------------------------------------
SELECT fp.*
FROM Fact_Production fp
LEFT JOIN Dim_Date d ON fp.Date_ID = d.Date_ID
WHERE d.Date_ID IS NULL;


----------------------------------------------------------
-- 4. Ensure Actual Output never exceeds Planned Output
----------------------------------------------------------
SELECT *
FROM Fact_Production
WHERE Actual_Output_Units > Planned_Output_Units;


----------------------------------------------------------
-- 5. Identify negative or unrealistic numeric values
----------------------------------------------------------
SELECT *
FROM Fact_Production
WHERE Planned_Output_Units < 0
   OR Actual_Output_Units < 0
   OR Downtime_Minutes < 0;


----------------------------------------------------------
-- 6. Validate OEE% calculation range
----------------------------------------------------------
SELECT *
FROM Fact_Production
WHERE OEE_Percent < 0 OR OEE_Percent > 100;


----------------------------------------------------------
-- 7. Check for defect counts exceeding inspected units
----------------------------------------------------------
SELECT *
FROM Fact_Quality
WHERE Defect_Count > Output_Units_Checked;


----------------------------------------------------------
-- 8. Validate on-time delivery values (must be 0 or 1)
----------------------------------------------------------
SELECT DISTINCT Delivered_OnTime
FROM Fact_Logistics;


----------------------------------------------------------
-- 9. Check for employees not assigned to regions
----------------------------------------------------------
SELECT e.*
FROM Dim_Employee e
LEFT JOIN Dim_Region r ON e.Region_ID = r.Region_ID
WHERE r.Region_ID IS NULL;


----------------------------------------------------------
-- 10. Ensure HR weekly records do not have impossible hours
----------------------------------------------------------
SELECT *
FROM Fact_HR
WHERE Hours_Worked > 60 OR Overtime_Hours > 20;
