/*=========================================================
 ANALYTICAL SQL QUERIES — OPERATIONAL ANALYSIS PROJECT
 Business-focused insights across Production, Quality,
 Logistics, and HR
=========================================================*/

----------------------------------------------------------
-- 1️⃣ Total Production Output by Machine
----------------------------------------------------------
WITH MachineOutput AS (
    SELECT
        M.Machine_Name,
        F.Machine_ID,
        SUM(F.Actual_Output_Units) AS Total_Output
    FROM Fact_Production AS F
    INNER JOIN Dim_Machine AS M
        ON F.Machine_ID = M.Machine_ID
    GROUP BY
        M.Machine_Name,
        F.Machine_ID
)
SELECT *
FROM MachineOutput
ORDER BY Total_Output DESC;


----------------------------------------------------------
-- 2️⃣ Rolling 30-Day Production Trend
----------------------------------------------------------
WITH DailyOutput AS (
    SELECT
        F.Date_ID,
        D.Calendar_Date,
        SUM(F.Actual_Output_Units) AS Daily_Total
    FROM Fact_Production AS F
    INNER JOIN Dim_Date AS D
        ON F.Date_ID = D.Date_ID
    GROUP BY
        F.Date_ID,
        D.Calendar_Date
)
SELECT
    Calendar_Date,
    Daily_Total,
    SUM(Daily_Total) OVER (
        ORDER BY Calendar_Date
        ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
    ) AS Rolling_30_Day_Total
FROM DailyOutput
ORDER BY Calendar_Date;


----------------------------------------------------------
-- 3️⃣ Defect Rate by Product Category
----------------------------------------------------------
WITH QualityAgg AS (
    SELECT
        P.Category,
        SUM(Q.Defect_Count) AS Total_Defects,
        SUM(Q.Output_Units_Checked) AS Total_Checked
    FROM Fact_Quality AS Q
    INNER JOIN Dim_Product AS P
        ON Q.Product_ID = P.Product_ID
    GROUP BY
        P.Category
)
SELECT
    Category,
    Total_Checked,
    Total_Defects,
    (Total_Defects * 100.0 / NULLIF(Total_Checked, 0)) AS Defect_Rate_Percent
FROM QualityAgg
ORDER BY Defect_Rate_Percent DESC;


----------------------------------------------------------
-- 4️⃣ On-Time Delivery % by Region
----------------------------------------------------------
WITH DeliveryAgg AS (
    SELECT
        R.Region_Name,
        COUNT(*) AS Total_Shipments,
        SUM(CASE WHEN L.Delivered_OnTime = 1 THEN 1 ELSE 0 END) AS OnTime_Shipments
    FROM Fact_Logistics AS L
    INNER JOIN Dim_Region AS R
        ON L.Region_ID = R.Region_ID
    GROUP BY
        R.Region_Name
)
SELECT
    Region_Name,
    Total_Shipments,
    OnTime_Shipments,
    (OnTime_Shipments * 100.0 / Total_Shipments) AS OnTime_Percent
FROM DeliveryAgg
ORDER BY OnTime_Percent DESC;


----------------------------------------------------------
-- 5️⃣ Overtime Hours by Employee
----------------------------------------------------------
WITH OvertimeAgg AS (
    SELECT
        E.Employee_Name,
        E.Department,
        SUM(H.Overtime_Hours) AS Total_Overtime_Hours
    FROM Fact_HR H
    INNER JOIN Dim_Employee E
        ON H.Employee_ID = E.Employee_ID
    GROUP BY
        E.Employee_Name,
        E.Department
)
SELECT *
FROM OvertimeAgg
ORDER BY Total_Overtime_Hours DESC;


----------------------------------------------------------
-- 6️⃣ Does Overtime Impact Production?
----------------------------------------------------------
WITH HR_Summary AS (
    SELECT
        Employee_ID,
        SUM(Hours_Worked) AS Total_Hours,
        SUM(Overtime_Hours) AS Total_Overtime
    FROM Fact_HR
    GROUP BY Employee_ID
),
Production_Summary AS (
    SELECT
        Employee_ID,
        SUM(Actual_Output_Units) AS Total_Output
    FROM Fact_Production
    GROUP BY Employee_ID
)
SELECT
    E.Employee_Name,
    HR.Total_Hours,
    HR.Total_Overtime,
    P.Total_Output,
    (P.Total_Output * 1.0 / NULLIF(HR.Total_Overtime, 0)) AS Output_Per_Overtime_Hour
FROM HR_Summary HR
JOIN Production_Summary P
    ON HR.Employee_ID = P.Employee_ID
JOIN Dim_Employee E
    ON HR.Employee_ID = E.Employee_ID
ORDER BY Output_Per_Overtime_Hour DESC;


----------------------------------------------------------
-- 7️⃣ Machine Downtime Impact on Output
----------------------------------------------------------
WITH MachineProd AS (
    SELECT
        F.Machine_ID,
        M.Machine_Name,
        SUM(F.Planned_Output_Units) AS Planned_Output,
        SUM(F.Actual_Output_Units) AS Total_Output,
        SUM(F.Downtime_Minutes) AS Total_Downtime_Min,
        SUM(F.Planned_Minutes) AS Total_Planned_Min
    FROM Fact_Production F
    INNER JOIN Dim_Machine M
        ON F.Machine_ID = M.Machine_ID
    GROUP BY
        F.Machine_ID,
        M.Machine_Name
),
EfficiencyCalc AS (
    SELECT
        *,
        (Total_Downtime_Min * 100.0 / NULLIF(Total_Planned_Min, 0)) AS Downtime_Percentage,
        ((Planned_Output - Total_Output) * 100.0 / NULLIF(Planned_Output, 0)) AS Output_Loss_Percentage
    FROM MachineProd
)
SELECT *
FROM EfficiencyCalc
ORDER BY Output_Loss_Percentage DESC;


----------------------------------------------------------
-- 8️⃣ Executive KPI Summary (Cross-Domain)
----------------------------------------------------------
WITH Prod AS (
    SELECT SUM(Actual_Output_Units) AS Total_Output
    FROM Fact_Production
),
Qual AS (
    SELECT
        SUM(Defect_Count) AS Total_Defects,
        SUM(Output_Units_Checked) AS Checked
    FROM Fact_Quality
),
Logi AS (
    SELECT
        COUNT(*) AS Total_Shipments,
        SUM(CASE WHEN Delivered_OnTime = 1 THEN 1 ELSE 0 END) AS OnTime
    FROM Fact_Logistics
),
HR AS (
    SELECT
        SUM(CASE WHEN Absence_Flag = 1 THEN 1 ELSE 0 END) AS Absences,
        COUNT(*) AS Records
    FROM Fact_HR
)
SELECT
    (SELECT Total_Output FROM Prod) AS Total_Production_Output,
    (SELECT Total_Defects * 100.0 / NULLIF(Checked, 0) FROM Qual) AS Defect_Rate_Percent,
    (SELECT OnTime * 100.0 / NULLIF(Total_Shipments, 0) FROM Logi) AS OnTime_Delivery_Percent,
    (SELECT Absences * 100.0 / NULLIF(Records, 0) FROM HR) AS Absenteeism_Rate_Percent;
