CREATE TABLE dbo.Dim_Region (
    Region_ID       INT IDENTITY(1,1) PRIMARY KEY,
    Region_Name     VARCHAR(100) NOT NULL,
    Country         VARCHAR(100) NOT NULL,
    State_Province  VARCHAR(100) NOT NULL,
    City            VARCHAR(100) NOT NULL,
    Plant_Code      VARCHAR(20) NOT NULL UNIQUE
);



CREATE TABLE dbo.Dim_Product (
    Product_ID      INT IDENTITY(1,1) PRIMARY KEY,
    Product_Name    VARCHAR(200) NOT NULL,
    Category        VARCHAR(100) NOT NULL,      -- Bags, Film, Liners, Rolls, Printed Film
    Material_Type   VARCHAR(100) NOT NULL,      -- LDPE, LLDPE, HDPE, Recycled, Blend
    Thickness_um    INT NULL,                   -- Microns (optional for bags/film)
    Color           VARCHAR(50) NOT NULL,       -- Clear, Blue, Black, Custom
    Packaging_Type  VARCHAR(100) NOT NULL       -- Roll, Box, Pallet, Bundle
);




CREATE TABLE dbo.Dim_Machine (
    Machine_ID        INT IDENTITY(1,1) PRIMARY KEY,
    Machine_Name      VARCHAR(200) NOT NULL,       -- Human-friendly machine name
    Machine_Type      VARCHAR(100) NOT NULL,       -- Cutter, Printer, Extruder, Bag Maker, etc.
    Production_Line   VARCHAR(100) NOT NULL,       -- Line A, Line B, Line C, etc.
    Plant_Code        VARCHAR(20)  NOT NULL,       -- Matches codes from Dim_Region
    Machine_Code      VARCHAR(50)  NOT NULL UNIQUE,-- Unique machine identifier
    Capacity_Units_Hr INT NOT NULL                 -- Realistic hourly capacity
);






-- Dim_Employee Table Structure


CREATE TABLE dbo.Dim_Employee (
    Employee_ID     INT IDENTITY(1,1) PRIMARY KEY,
    Employee_Name   VARCHAR(200) NOT NULL,
    Job_Title       VARCHAR(150) NOT NULL,
    Department      VARCHAR(100) NOT NULL,
    Shift_Type      VARCHAR(50) NOT NULL,         -- Day, Night, Rotating
    Hire_Date       DATE NOT NULL,
    Region_ID       INT NOT NULL,                 -- FK referencing Dim_Region
    CONSTRAINT FK_DimEmployee_Region 
        FOREIGN KEY (Region_ID) REFERENCES dbo.Dim_Region(Region_ID)
);




-- Dim_Date Table Structure


CREATE TABLE dbo.Dim_Date (
    Date_ID        INT IDENTITY(1,1) PRIMARY KEY,
    Calendar_Date  DATE NOT NULL,
    [Year]         INT NOT NULL,
    [Quarter]      INT NOT NULL,
    [Month]        INT NOT NULL,
    Month_Name     VARCHAR(20) NOT NULL,
    [Day]          INT NOT NULL,
    Day_Of_Week    INT NOT NULL,       -- 1 = Monday … 7 = Sunday
    Day_Name       VARCHAR(20) NOT NULL,
    Is_Weekend     BIT NOT NULL
);






-- FACT TABLES TO FOLLOW IN SUBSEQUENT SCRIPTS.

CREATE TABLE dbo.Fact_Production (
    Production_ID        INT IDENTITY(1,1) PRIMARY KEY,
    Calendar_Date        DATE NOT NULL,
    Machine_ID           INT NOT NULL,
    Employee_ID          INT NOT NULL,
    Product_ID           INT NOT NULL,
    Region_ID            INT NOT NULL,
    Shift_Type           VARCHAR(50) NOT NULL,
    
    Planned_Output_Units INT NOT NULL,
    Actual_Output_Units  INT NOT NULL,
    Downtime_Minutes     INT NOT NULL,
    Planned_Minutes      INT NOT NULL,
    OEE_Percent          DECIMAL(5,2) NOT NULL,

    CONSTRAINT FK_FactProd_Date 
        FOREIGN KEY (Calendar_Date) REFERENCES dbo.Dim_Date(Calendar_Date),

    CONSTRAINT FK_FactProd_Machine
        FOREIGN KEY (Machine_ID) REFERENCES dbo.Dim_Machine(Machine_ID),

    CONSTRAINT FK_FactProd_Employee
        FOREIGN KEY (Employee_ID) REFERENCES dbo.Dim_Employee(Employee_ID),

    CONSTRAINT FK_FactProd_Product
        FOREIGN KEY (Product_ID) REFERENCES dbo.Dim_Product(Product_ID),

    CONSTRAINT FK_FactProd_Region
        FOREIGN KEY (Region_ID) REFERENCES dbo.Dim_Region(Region_ID)
);





-- Create the Fact_Quality Table


CREATE TABLE dbo.Fact_Quality (
    Quality_ID           INT IDENTITY(1,1) PRIMARY KEY,
    Date_ID              INT NOT NULL,
    Region_ID            INT NOT NULL,
    Product_ID           INT NOT NULL,

    Output_Units_Checked INT NOT NULL,
    Defect_Count         INT NOT NULL,
    Scrap_Weight_KG      DECIMAL(10,2) NOT NULL,
    Rework_Cost          DECIMAL(12,2) NOT NULL,
    Defect_Type          VARCHAR(100) NOT NULL,

    FOREIGN KEY (Date_ID) REFERENCES dbo.Dim_Date(Date_ID),
    FOREIGN KEY (Region_ID) REFERENCES dbo.Dim_Region(Region_ID),
    FOREIGN KEY (Product_ID) REFERENCES dbo.Dim_Product(Product_ID)
);





-- Create the Fact_Logistics Table

CREATE TABLE dbo.Fact_Logistics (
    Order_ID            INT IDENTITY(1,1) PRIMARY KEY,
    Date_ID             INT NOT NULL,
    Region_ID           INT NOT NULL,
    Product_ID          INT NOT NULL,

    Shipment_Weight_KG  DECIMAL(10,2) NOT NULL,
    Delivery_Cost       DECIMAL(12,2) NOT NULL,
    Delivered_OnTime    BIT NOT NULL,

    FOREIGN KEY (Date_ID)   REFERENCES dbo.Dim_Date(Date_ID),
    FOREIGN KEY (Region_ID) REFERENCES dbo.Dim_Region(Region_ID),
    FOREIGN KEY (Product_ID) REFERENCES dbo.Dim_Product(Product_ID)
);




-- Create the Fact_HR Table

CREATE TABLE dbo.Fact_HR (
    HR_ID           INT IDENTITY(1,1) PRIMARY KEY,
    Employee_ID     INT NOT NULL,
    Week_Start_Date DATE NOT NULL,
    Region_ID       INT NOT NULL,
    Department      VARCHAR(100) NOT NULL,
    Hours_Worked    INT NOT NULL,
    Overtime_Hours  INT NOT NULL,
    Absence_Flag    BIT NOT NULL,

    FOREIGN KEY (Employee_ID) REFERENCES dbo.Dim_Employee(Employee_ID),
    FOREIGN KEY (Region_ID)   REFERENCES dbo.Dim_Region(Region_ID)
);



GO
