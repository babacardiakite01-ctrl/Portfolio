
CREATE OR ALTER PROCEDURE dbo.GenerateDailyProductionData
    @Date_ID INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Fact_Production (
        Date_ID,
        Machine_ID,
        Employee_ID,
        Product_ID,
        Region_ID,
        Shift_Type,
        Planned_Output_Units,
        Actual_Output_Units,
        Downtime_Minutes,
        Planned_Minutes,
        OEE_Percent
    )
    SELECT
        @Date_ID AS Date_ID,
        M.Machine_ID,

        -- Employee from same Region
        (SELECT TOP 1 Employee_ID 
         FROM dbo.Dim_Employee E
         WHERE E.Region_ID = R.Region_ID
         ORDER BY NEWID()) AS Employee_ID,

        -- Random Product
        (SELECT TOP 1 Product_ID
         FROM dbo.Dim_Product 
         ORDER BY NEWID()) AS Product_ID,

        R.Region_ID,

        -- Shift
        CASE ABS(CHECKSUM(NEWID())) % 3
            WHEN 0 THEN 'Day'
            WHEN 1 THEN 'Night'
            ELSE 'Rotating'
        END AS Shift_Type,

        -- Planned Output
        M.Capacity_Units_Hr * 8 AS Planned_Output_Units,

        -- Actual Output
        (M.Capacity_Units_Hr * 8)
            - (ABS(CHECKSUM(NEWID())) % 200) AS Actual_Output_Units,

        -- Downtime
        ABS(CHECKSUM(NEWID())) % 61 AS Downtime_Minutes,

        -- Planned minutes
        480 AS Planned_Minutes,

        -- OEE
        CAST(
            (( (M.Capacity_Units_Hr * 8)
                - (ABS(CHECKSUM(NEWID())) % 200) ) * 1.0
            / (M.Capacity_Units_Hr * 8)) * 100
        AS DECIMAL(5,2)) AS OEE_Percent

    FROM dbo.Dim_Machine M
    JOIN dbo.Dim_Region R
        ON R.Plant_Code = M.Plant_Code;
END;
GO


CREATE OR ALTER PROCEDURE dbo.GenerateDailyQualityData
    @Date_ID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Region_ID INT;

    DECLARE region_cursor CURSOR FOR
    SELECT Region_ID FROM dbo.Dim_Region;

    OPEN region_cursor;
    FETCH NEXT FROM region_cursor INTO @Region_ID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO dbo.Fact_Quality (
            Date_ID,
            Region_ID,
            Product_ID,
            Output_Units_Checked,
            Defect_Count,
            Scrap_Weight_KG,
            Rework_Cost,
            Defect_Type
        )
        SELECT
            @Date_ID AS Date_ID,
            @Region_ID AS Region_ID,

            -- Random Product
            (SELECT TOP 1 Product_ID FROM dbo.Dim_Product ORDER BY NEWID()) AS Product_ID,

            -- Units checked: 500 to 5,000
            500 + (ABS(CHECKSUM(NEWID())) % 4501) AS Output_Units_Checked,

            -- Defects: 0 to 5% of inspected units
            (ABS(CHECKSUM(NEWID())) % 251) AS Defect_Count, -- max ~250 defects

            -- Scrap weight based on defect count (0.01–0.05 kg per defect)
            CAST((ABS(CHECKSUM(NEWID())) % 5 + 1) * 0.01 
                    * (ABS(CHECKSUM(NEWID())) % 251) AS DECIMAL(10,2)) AS Scrap_Weight_KG,

            -- Rework cost based on severity
            CAST( (ABS(CHECKSUM(NEWID())) % 50 + 1) 
                    * (ABS(CHECKSUM(NEWID())) % 251) AS DECIMAL(12,2)) AS Rework_Cost,

            -- Random defect type
            (SELECT TOP 1 Defect_Type
             FROM (
                VALUES ('Tear'),
                       ('Seal Failure'),
                       ('Print Misalignment'),
                       ('Ink Smear'),
                       ('Thickness Variation'),
                       ('Contamination'),
                       ('Gel Spots'),
                       ('Color Variation'),
                       ('Wrinkles'),
                       ('Edge Damage')
             ) AS D(Defect_Type)
             ORDER BY NEWID())
        ;
        
        FETCH NEXT FROM region_cursor INTO @Region_ID;
    END

    CLOSE region_cursor;
    DEALLOCATE region_cursor;
END;
GO


CREATE OR ALTER PROCEDURE dbo.GenerateDailyLogisticsData
    @Date_ID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Region_ID INT;

    DECLARE region_cursor CURSOR FOR
    SELECT Region_ID FROM dbo.Dim_Region;

    OPEN region_cursor;
    FETCH NEXT FROM region_cursor INTO @Region_ID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Number of shipments per region per day (1 to 5)
        DECLARE @ShipCount INT = (ABS(CHECKSUM(NEWID())) % 5) + 1;

        DECLARE @i INT = 1;
        WHILE @i <= @ShipCount
        BEGIN
            INSERT INTO dbo.Fact_Logistics (
                Date_ID,
                Region_ID,
                Product_ID,
                Shipment_Weight_KG,
                Delivery_Cost,
                Delivered_OnTime
            )
            SELECT
                @Date_ID,
                @Region_ID,

                -- Random product
                (SELECT TOP 1 Product_ID FROM dbo.Dim_Product ORDER BY NEWID()),

                -- Shipment weight (50kg to 2000kg)
                (ABS(CHECKSUM(NEWID())) % 1951) + 50,

                -- Delivery cost (based on weight + random freight)
                CAST(((ABS(CHECKSUM(NEWID())) % 1951) + 50) * 0.45
                        + (ABS(CHECKSUM(NEWID())) % 200) AS DECIMAL(12,2)),

                -- On-time delivery (85–95% chance)
                CASE WHEN ABS(CHECKSUM(NEWID())) % 100 < 90 THEN 1 ELSE 0 END;

            SET @i = @i + 1;
        END

        FETCH NEXT FROM region_cursor INTO @Region_ID;
    END

    CLOSE region_cursor;
    DEALLOCATE region_cursor;
END;
GO

CREATE OR ALTER PROCEDURE dbo.GenerateWeeklyHRData
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @WeekDate DATE;
    DECLARE @Employee_ID INT;
    DECLARE @Region_ID INT;
    DECLARE @Department VARCHAR(100);

    -- Get all Mondays from Dim_Date
    DECLARE week_cursor CURSOR FOR
    SELECT Calendar_Date
    FROM dbo.Dim_Date
    WHERE DATENAME(WEEKDAY, Calendar_Date) = 'Monday'
    ORDER BY Calendar_Date;

    OPEN week_cursor;
    FETCH NEXT FROM week_cursor INTO @WeekDate;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Loop all employees
        DECLARE emp_cursor CURSOR FOR
        SELECT Employee_ID, Region_ID, Department
        FROM dbo.Dim_Employee;

        OPEN emp_cursor;
        FETCH NEXT FROM emp_cursor INTO @Employee_ID, @Region_ID, @Department;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            INSERT INTO dbo.Fact_HR (
                Employee_ID,
                Week_Start_Date,
                Region_ID,
                Department,
                Hours_Worked,
                Overtime_Hours,
                Absence_Flag
            )
            SELECT
                @Employee_ID,
                @WeekDate,
                @Region_ID,
                @Department,

                -- Hours Worked
                CASE 
                    WHEN ABS(CHECKSUM(NEWID())) % 100 < 10 THEN 0          -- 10% absence
                    ELSE (35 + (ABS(CHECKSUM(NEWID())) % 6))             -- 35–40 hours
                END,

                -- Overtime 0–12 hrs
                ABS(CHECKSUM(NEWID())) % 13,

                -- Absence flag
                CASE 
                    WHEN ABS(CHECKSUM(NEWID())) % 100 < 10 THEN 1 ELSE 0 
                END;

            FETCH NEXT FROM emp_cursor INTO @Employee_ID, @Region_ID, @Department;
        END

        CLOSE emp_cursor;
        DEALLOCATE emp_cursor;

        FETCH NEXT FROM week_cursor INTO @WeekDate;
    END

    CLOSE week_cursor;
    DEALLOCATE week_cursor;
END;
GO
