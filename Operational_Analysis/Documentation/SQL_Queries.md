We start with a clean, professional SQL query:

# Analytical SQL Queries

This document contains the SQL logic used to answer the primary business questions in the Operational Analysis Dashboard.  
Each query is written for SQL Server and aligned with BI best practices.

---

## 1️⃣ Query 1 — Total Production Output by Machine

**Business Question:**  
Which machines produce the most output? This helps identify operational performance and production bottlenecks.

**SQL Code:**

```sql
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
SELECT
    Machine_ID,
    Machine_Name,
    Total_Output
FROM MachineOutput
ORDER BY Total_Output DESC;



---

## 2️⃣ Query 2 — Rolling 30-Day Production Trend

**Business Question:**  
How is production trending over time?  
A rolling 30-day metric smooths out daily noise and reveals true operational momentum.

**SQL Code:**

--sql
-- What this query does:

-- Calculates total output per day

-- Uses SUM() OVER() to compute a rolling 30-day production total

-- Handles days even if some machines did not produce

-- Creates a smoothed trend for analytics

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




---

-- ## 3️⃣ Query 3 — Defect Rate (%) by Product Category

-- **Business Question:**  
-- Which product categories have the highest defect rates?  
-- This helps identify quality issues and potential root causes.

-- **Formula:**  
-- Defect Rate (%) = (Total Defects / Total Units Checked) * 100

-- **SQL Code:**

-- sql
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
    CASE 
        WHEN Total_Checked = 0 THEN 0
        ELSE (Total_Defects * 100.0 / Total_Checked)
    END AS Defect_Rate_Percent
FROM QualityAgg
ORDER BY Defect_Rate_Percent DESC;



---

-- ## 4️⃣ Query 4 — On-Time Delivery % by Region

-- **Business Question:**  
-- How well is each region performing on timely deliveries?  
-- On-time delivery is a key logistics KPI that impacts customer satisfaction and operational reliability.

-- **Formula:**  
-- On-Time Delivery % = (Delivered_OnTime_Count / Total_Shipments) * 100

-- **SQL Code:**

--sql

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





---

-- ## 5️⃣ Query 5 — Total Overtime Hours by Employee

-- **Business Question:**  
-- Which employees have the highest overtime hours?  
-- Overtime is a key indicator of staffing levels, burnout risk, and labor cost.

-- **SQL Code:**

-- sql


WITH OvertimeAgg AS (
    SELECT
        E.Employee_Name,
        E.Department,
        SUM(H.Overtime_Hours) AS Total_Overtime_Hours
    FROM Fact_HR AS H
    INNER JOIN Dim_Employee AS E
        ON H.Employee_ID = E.Employee_ID
    GROUP BY
        E.Employee_Name,
        E.Department
)
SELECT
    Employee_Name,
    Department,
    Total_Overtime_Hours
FROM OvertimeAgg
ORDER BY Total_Overtime_Hours DESC;




---

-- ## 6️⃣ Query 6 — Does Overtime Impact Production Output?

-- **Business Question:**  
-- Is there a relationship between overtime hours worked and production output?  
-- This analysis helps determine whether overtime increases productivity or signals inefficiencies.

-- **SQL Code:**



WITH HR_Summary AS (
    SELECT
        H.Employee_ID,
        SUM(H.Hours_Worked) AS Total_Hours,
        SUM(H.Overtime_Hours) AS Total_Overtime
    FROM Fact_HR AS H
    GROUP BY H.Employee_ID
),
Production_Summary AS (
    SELECT
        F.Employee_ID,
        SUM(F.Actual_Output_Units) AS Total_Output
    FROM Fact_Production AS F
    GROUP BY F.Employee_ID
)
SELECT
    E.Employee_Name,
    HR.Total_Hours,
    HR.Total_Overtime,
    P.Total_Output,
    CASE 
        WHEN HR.Total_Overtime = 0 THEN NULL
        ELSE (P.Total_Output * 1.0 / HR.Total_Overtime)
    END AS Output_Per_Overtime_Hour
FROM HR_Summary AS HR
INNER JOIN Production_Summary AS P
    ON HR.Employee_ID = P.Employee_ID
INNER JOIN Dim_Employee AS E
    ON HR.Employee_ID = E.Employee_ID
ORDER BY Output_Per_Overtime_Hour DESC;



---

-- ## 7️⃣ Query 7 — Machine Downtime Impact on Output

-- **Business Question:**  
-- How does machine downtime impact production output?  
-- This helps determine which machines cause the greatest production losses and where improvements are needed.

-- **SQL Code:**

-- sql
WITH MachineProd AS (
    SELECT
        F.Machine_ID,
        M.Machine_Name,
        SUM(F.Actual_Output_Units) AS Total_Output,
        SUM(F.Planned_Output_Units) AS Planned_Output,
        SUM(F.Downtime_Minutes) AS Total_Downtime_Min,   -- ← fixed here
        SUM(F.Planned_Minutes) AS Total_Planned_Min
    FROM Fact_Production AS F
    INNER JOIN Dim_Machine AS M
        ON F.Machine_ID = M.Machine_ID
    GROUP BY
        F.Machine_ID,
        M.Machine_Name
),
EfficiencyCalc AS (
    SELECT
        Machine_ID,
        Machine_Name,
        Planned_Output,
        Total_Output,
        Total_Downtime_Min,
        Total_Planned_Min,
        CASE 
            WHEN Total_Planned_Min = 0 THEN NULL
            ELSE (Total_Downtime_Min * 1.0 / Total_Planned_Min) * 100
        END AS Downtime_Percentage,
        CASE 
            WHEN Planned_Output = 0 THEN NULL
            ELSE ((Planned_Output - Total_Output) * 1.0 / Planned_Output) * 100
        END AS Output_Loss_Percentage
    FROM MachineProd
)
SELECT
    Machine_ID,
    Machine_Name,
    Total_Output,
    Planned_Output,
    Total_Downtime_Min,
    Total_Planned_Min,
    Downtime_Percentage,
    Output_Loss_Percentage
FROM EfficiencyCalc
ORDER BY Output_Loss_Percentage DESC;


---

-- ## 8️⃣ Query 8 — Executive KPI Summary (Cross-Domain KPIs)

-- **Business Question:**  
-- What is the overall operational performance across production, quality, logistics, and HR?  
-- Executives want a single view of performance indicators to track plant health.

-- **SQL Code:**

sql
/* 1. Total Production Output */
WITH Prod AS (
    SELECT SUM(Actual_Output_Units) AS Total_Output
    FROM Fact_Production
),

/* 2. Quality Defect Rate */
Qual AS (
    SELECT
        SUM(Defect_Count) AS Total_Defects,
        SUM(Output_Units_Checked) AS Total_Checked
    FROM Fact_Quality
),

/* 3. On-Time Delivery Rate */
Logi AS (
    SELECT
        COUNT(*) AS Total_Shipments,
        SUM(CASE WHEN Delivered_OnTime = 1 THEN 1 ELSE 0 END) AS OnTime_Shipments
    FROM Fact_Logistics
),

/* 4. Absenteeism Rate */
HR AS (
    SELECT
        SUM(CASE WHEN Absence_Flag = 1 THEN 1 ELSE 0 END) AS Total_Absences,
        COUNT(*) AS Total_HR_Records
    FROM Fact_HR
)

SELECT
    /* Production KPI */
    (SELECT Total_Output FROM Prod) AS Total_Production_Output,

    /* Quality KPI */
    CASE 
        WHEN (SELECT Total_Checked FROM Qual) = 0 THEN NULL
        ELSE ((SELECT Total_Defects FROM Qual) * 100.0 /
              (SELECT Total_Checked FROM Qual))
    END AS Defect_Rate_Percent,

    /* Logistics KPI */
    CASE 
        WHEN (SELECT Total_Shipments FROM Logi) = 0 THEN NULL
        ELSE ((SELECT OnTime_Shipments FROM Logi) * 100.0 /
              (SELECT Total_Shipments FROM Logi))
    END AS OnTime_Delivery_Percent,

    /* HR KPI */
    CASE 
        WHEN (SELECT Total_HR_Records FROM HR) = 0 THEN NULL
        ELSE ((SELECT Total_Absences FROM HR) * 100.0 /
              (SELECT Total_HR_Records FROM HR))
    END AS Absenteeism_Rate_Percent;
