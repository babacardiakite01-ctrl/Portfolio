
INSERT INTO dbo.Dim_Region (Region_Name, Country, State_Province, City, Plant_Code)
VALUES
    ('Montreal Plant',        'Canada', 'Quebec',             'Montreal',      'QC-M01'),
    ('Laval Plant',           'Canada', 'Quebec',             'Laval',         'QC-L02'),
    ('Toronto Plant',         'Canada', 'Ontario',            'Toronto',       'ON-T03'),
    ('Mississauga Plant',     'Canada', 'Ontario',            'Mississauga',   'ON-M04'),
    ('Vancouver Plant',       'Canada', 'British Columbia',   'Vancouver',     'BC-V05'),
    ('Chicago Plant',         'USA',    'Illinois',           'Chicago',       'US-CH06'),
    ('Dallas Plant',          'USA',    'Texas',              'Dallas',        'US-DX07'),
    ('Atlanta Plant',         'USA',    'Georgia',            'Atlanta',       'US-AT08'),
    ('Mexico City Plant',     'Mexico', 'CDMX',               'Mexico City',   'MX-MC09'),
    ('Guadalajara Plant',     'Mexico', 'Jalisco',            'Guadalajara',   'MX-GD10');




INSERT INTO dbo.Dim_Product 
(Product_Name, Category, Material_Type, Thickness_um, Color, Packaging_Type)
VALUES
-- Poly Bags
('Poly Bag - Small 6x9',              'Bags',     'LDPE',    40,  'Clear', 'Box'),
('Poly Bag - Medium 8x12',            'Bags',     'LDPE',    45,  'Clear', 'Box'),
('Poly Bag - Large 12x18',            'Bags',     'LDPE',    50,  'Clear', 'Box'),
('Poly Bag - Extra Large 18x24',      'Bags',     'LDPE',    55,  'Clear', 'Box'),

-- Colored Bags
('Poly Bag - Blue 12x18',             'Bags',     'LDPE',    50,  'Blue',  'Box'),
('Poly Bag - Black 12x18',            'Bags',     'LDPE',    50,  'Black', 'Box'),

-- Printed Bags
('Printed Bag - Logo A 10x15',        'Printed',  'LLDPE',   50,  'Clear', 'Box'),
('Printed Bag - Logo B 14x20',        'Printed',  'LLDPE',   60,  'Clear', 'Box'),
('Printed Bag - Warning Label 12x18', 'Printed',  'LDPE',    55,  'Clear', 'Box'),

-- Industrial Liners
('Industrial Liner - Standard 20x22', 'Liners',   'HDPE',    20,  'Clear', 'Bundle'),
('Industrial Liner - Heavy 30x36',    'Liners',   'HDPE',    30,  'Black', 'Bundle'),
('Industrial Liner - Extra Heavy 42x48','Liners', 'HDPE',    45,  'Black', 'Bundle'),

-- Recycling Bags
('Recycling Bag - Blue 30x36',        'Bags',     'Recycled', 25, 'Blue',  'Roll'),
('Recycling Bag - Clear 30x36',       'Bags',     'Recycled', 25, 'Clear', 'Roll'),

-- Stretch Film Rolls
('Stretch Film 12µ - Hand Roll',      'Film',     'LLDPE',   12,  'Clear', 'Roll'),
('Stretch Film 15µ - Hand Roll',      'Film',     'LLDPE',   15,  'Clear', 'Roll'),
('Stretch Film 17µ - Hand Roll',      'Film',     'LLDPE',   17,  'Clear', 'Roll'),
('Stretch Film 20µ - Machine Roll',   'Film',     'LLDPE',   20,  'Clear', 'Roll'),
('Stretch Film 23µ - Machine Roll',   'Film',     'LLDPE',   23,  'Clear', 'Roll'),
('Stretch Film 30µ - Heavy Duty',     'Film',     'LLDPE',   30,  'Clear', 'Roll'),

-- Shrink Film
('Shrink Film 12µ - Transparent',     'Film',     'LDPE',    12,  'Clear', 'Pallet'),
('Shrink Film 15µ - Transparent',     'Film',     'LDPE',    15,  'Clear', 'Pallet'),
('Shrink Film 20µ - Transparent',     'Film',     'LDPE',    20,  'Clear', 'Pallet'),

-- Pallet Wrap Rolls
('Pallet Wrap - Standard 18in',       'Rolls',    'LLDPE',   20,  'Clear', 'Box'),
('Pallet Wrap - Heavy Duty 18in',     'Rolls',    'LLDPE',   25,  'Clear', 'Box'),

-- Food Grade Bags
('Food Bag - 10x15',                  'Bags',     'LDPE',    40,  'Clear', 'Box'),
('Food Bag - 12x20',                  'Bags',     'LDPE',    45,  'Clear', 'Box'),
('Food Bag - 14x24',                  'Bags',     'LDPE',    55,  'Clear', 'Box'),

-- Construction Bags
('Construction Bag - Heavy Duty 40x48', 'Bags',  'HDPE',    75,  'Black', 'Bundle'),
('Construction Bag - Extra Heavy 42x52','Bags',  'HDPE',    90,  'Black', 'Bundle'),

-- Printed Film
('Printed Film - Logo A 20µ',         'Printed Film', 'LLDPE', 20, 'Clear', 'Roll'),
('Printed Film - Logo B 23µ',         'Printed Film', 'LLDPE', 23, 'Clear', 'Roll'),
('Printed Film - Warning Labels 20µ', 'Printed Film', 'LDPE', 20, 'Clear', 'Roll');



INSERT INTO dbo.Dim_Machine 
(Machine_Name, Machine_Type, Production_Line, Plant_Code, Machine_Code, Capacity_Units_Hr)
VALUES
-- Montreal Plant (QC-M01)
('Extruder A1',            'Extruder',          'Line A', 'QC-M01', 'QC-M01-EXT-A1', 450),
('Flexo Printer A2',       'Flexo Printer',     'Line A', 'QC-M01', 'QC-M01-FLX-A2', 380),
('Bag Maker A3',           'Bag Maker',         'Line A', 'QC-M01', 'QC-M01-BAG-A3', 520),
('Slitter A4',             'Slitter',           'Line A', 'QC-M01', 'QC-M01-SLT-A4', 600),

-- Laval Plant (QC-L02)
('Extruder B1',            'Extruder',          'Line B', 'QC-L02', 'QC-L02-EXT-B1', 470),
('Rewinder B2',            'Rewinder',          'Line B', 'QC-L02', 'QC-L02-RWD-B2', 550),
('Bag Maker B3',           'Bag Maker',         'Line B', 'QC-L02', 'QC-L02-BAG-B3', 510),
('Shrink Tunnel B4',       'Shrink Tunnel',     'Line B', 'QC-L02', 'QC-L02-SHR-B4', 320),

-- Toronto Plant (ON-T03)
('Extruder C1',            'Extruder',          'Line C', 'ON-T03', 'ON-T03-EXT-C1', 480),
('Flexo Printer C2',       'Flexo Printer',     'Line C', 'ON-T03', 'ON-T03-FLX-C2', 400),
('Slitter C3',             'Slitter',           'Line C', 'ON-T03', 'ON-T03-SLT-C3', 620),
('Bag Maker C4',           'Bag Maker',         'Line C', 'ON-T03', 'ON-T03-BAG-C4', 525),

-- Dallas Plant (US-DX07)
('Extruder D1',            'Extruder',          'Line D', 'US-DX07', 'US-DX07-EXT-D1', 500),
('Winder D2',              'Stretch Film Winder','Line D','US-DX07','US-DX07-WND-D2', 700),
('Flexo Printer D3',       'Flexo Printer',     'Line D', 'US-DX07', 'US-DX07-FLX-D3', 410),
('Bag Maker D4',           'Bag Maker',         'Line D', 'US-DX07', 'US-DX07-BAG-D4', 540),

-- Mexico City Plant (MX-MC09)
('Extruder E1',            'Extruder',          'Line E', 'MX-MC09', 'MX-MC09-EXT-E1', 495),
('Slitter E2',             'Slitter',           'Line E', 'MX-MC09', 'MX-MC09-SLT-E2', 610),
('Bag Maker E3',           'Bag Maker',         'Line E', 'MX-MC09', 'MX-MC09-BAG-E3', 515),
('Rewinder E4',            'Rewinder',          'Line E', 'MX-MC09', 'MX-MC09-RWD-E4', 560),

-- Guadalajara Plant (MX-GD10)
('Extruder F1',            'Extruder',          'Line F', 'MX-GD10', 'MX-GD10-EXT-F1', 490),
('Shrink Tunnel F2',       'Shrink Tunnel',     'Line F', 'MX-GD10', 'MX-GD10-SHR-F2', 340),
('Bag Maker F3',           'Bag Maker',         'Line F', 'MX-GD10', 'MX-GD10-BAG-F3', 530),
('Slitter F4',             'Slitter',           'Line F', 'MX-GD10', 'MX-GD10-SLT-F4', 605);




INSERT INTO dbo.Dim_Employee 
(Employee_Name, Job_Title, Department, Shift_Type, Hire_Date, Region_ID)
VALUES
-- Montreal Plant (Region_ID = 1)
('Alice Tremblay',         'Machine Operator',      'Production', 'Day',       '2018-03-12', 1),
('Marc Dubois',            'Machine Operator',      'Production', 'Night',     '2019-07-22', 1),
('Sofia Nguyen',           'Quality Technician',    'Quality',    'Day',       '2020-02-10', 1),
('Daniel Johnson',         'Maintenance Tech',      'Maintenance','Day',       '2017-11-03', 1),
('Fatima Bamba',           'Logistics Coordinator', 'Logistics',  'Day',       '2021-01-15', 1),
('Olivier Gagnon',         'Production Supervisor', 'Production', 'Day',       '2016-06-19', 1),

-- Laval Plant (Region_ID = 2)
('Carlos Martinez',        'Machine Operator',      'Production', 'Rotating',  '2019-09-28', 2),
('Emma Wilson',            'HR Specialist',         'HR',         'Day',       '2022-04-07', 2),
('Jacob Martin',           'Machine Operator',      'Production', 'Night',     '2020-12-14', 2),
('Moussa Diallo',          'Machine Operator',      'Production', 'Day',       '2018-08-03', 2),
('Laura Chen',             'Quality Technician',    'Quality',    'Day',       '2021-10-11', 2),
('Pierre Lafleur',         'Maintenance Tech',      'Maintenance','Night',     '2017-09-17', 2),

-- Toronto Plant (Region_ID = 3)
('Aisha Mohamed',          'Machine Operator',      'Production', 'Day',       '2019-02-05', 3),
('Henry Thompson',         'Machine Operator',      'Production', 'Night',     '2018-06-18', 3),
('Sarah White',            'Quality Technician',    'Quality',    'Rotating',  '2020-09-25', 3),
('Mohammed Abbas',         'Maintenance Tech',      'Maintenance','Day',       '2016-12-01', 3),
('Patricia Gomez',         'Logistics Coordinator', 'Logistics',  'Day',       '2021-03-14', 3),
('Jonathan Brown',         'Production Manager',    'Production', 'Day',       '2015-05-20', 3),

-- Mississauga Plant (Region_ID = 4)
('Samuel Kim',             'Machine Operator',      'Production', 'Night',     '2019-04-27', 4),
('Linda Park',             'Machine Operator',      'Production', 'Day',       '2020-07-13', 4),
('Ernest Howard',          'Quality Technician',    'Quality',    'Day',       '2021-11-08', 4),
('Victor Hernandez',       'Maintenance Tech',      'Maintenance','Rotating',  '2018-10-22', 4),
('Jennifer Scott',         'Logistics Coordinator', 'Logistics',  'Day',       '2017-02-14', 4),
('George Murray',          'Machine Operator',      'Production', 'Night',     '2023-03-04', 4),

-- Vancouver Plant (Region_ID = 5)
('Bianca Rose',            'Machine Operator',      'Production', 'Day',       '2022-06-10', 5),
('Chris Evans',            'Machine Operator',      'Production', 'Night',     '2018-09-01', 5),
('Tanya Richards',         'Quality Technician',    'Quality',    'Rotating',  '2020-01-05', 5),
('Eric Wang',              'Maintenance Tech',      'Maintenance','Day',       '2016-08-14', 5),
('Kenji Ito',              'Machine Operator',      'Production', 'Night',     '2023-04-12', 5),
('Louise Martin',          'HR Specialist',         'HR',         'Day',       '2021-12-09', 5),

-- Chicago Plant (Region_ID = 6)
('Michael Carter',         'Machine Operator',      'Production', 'Day',       '2019-05-20', 6),
('Shawn Bennett',          'Machine Operator',      'Production', 'Night',     '2018-02-22', 6),
('Angela Cooper',          'Quality Technician',    'Quality',    'Day',       '2021-09-14', 6),
('Robert King',            'Maintenance Tech',      'Maintenance','Night',     '2017-07-29', 6),
('Emily Turner',           'Logistics Coordinator', 'Logistics',  'Day',       '2022-03-11', 6),
('Brandon Lee',            'Machine Operator',      'Production', 'Rotating',  '2020-11-30', 6),

-- Dallas Plant (Region_ID = 7)
('David Robinson',         'Machine Operator',      'Production', 'Day',       '2018-04-18', 7),
('Kevin Patel',            'Machine Operator',      'Production', 'Night',     '2020-06-09', 7),
('Sophia Ramirez',         'Quality Technician',    'Quality',    'Day',       '2021-08-27', 7),
('Nathan Brooks',          'Maintenance Tech',      'Maintenance','Rotating',  '2016-03-15', 7),
('Laura Stevens',          'Logistics Coordinator', 'Logistics',  'Day',       '2022-10-01', 7),
('Daniel Perez',           'Machine Operator',      'Production', 'Day',       '2023-01-19', 7),

-- Atlanta Plant (Region_ID = 8)
('Anthony Reed',           'Machine Operator',      'Production', 'Night',     '2019-07-07', 8),
('William Scott',          'Machine Operator',      'Production', 'Day',       '2020-11-17', 8),
('Nina Hart',              'Quality Technician',    'Quality',    'Day',       '2021-04-29', 8),
('Jerome Gray',            'Maintenance Tech',      'Maintenance','Day',       '2017-10-23', 8),
('Alexis Coleman',         'Machine Operator',      'Production', 'Rotating',  '2023-05-02', 8),
('Maria Sanchez',          'HR Specialist',         'HR',         'Day',       '2018-12-03', 8),

-- Mexico City Plant (Region_ID = 9)
('Jose Martinez',          'Machine Operator',      'Production', 'Day',       '2019-09-09', 9),
('Luis Ramirez',           'Machine Operator',      'Production', 'Night',     '2020-02-24', 9),
('Ana Torres',             'Quality Technician',    'Quality',    'Day',       '2021-06-30', 9),
('Pablo Morales',          'Maintenance Tech',      'Maintenance','Night',     '2017-08-21', 9),
('Sergio Alvarez',         'Machine Operator',      'Production', 'Day',       '2022-07-15', 9),
('Gabriela Cruz',          'Logistics Coordinator', 'Logistics',  'Day',       '2023-02-18', 9),

-- Guadalajara Plant (Region_ID = 10)
('Juan Lopez',             'Machine Operator',      'Production', 'Day',       '2018-05-14', 10),
('Ricardo Sanchez',        'Machine Operator',      'Production', 'Night',     '2020-10-01', 10),
('Carla Mendoza',          'Quality Technician',    'Quality',    'Day',       '2021-12-21', 10),
('Diego Fernandez',        'Maintenance Tech',      'Maintenance','Rotating',  '2016-09-07', 10),
('Elena Vargas',           'Machine Operator',      'Production', 'Day',       '2023-04-25', 10),
('Roberto Castillo',       'Logistics Coordinator', 'Logistics',  'Day',       '2019-01-30', 10);



DECLARE @StartDate DATE = '2020-01-01';
DECLARE @EndDate   DATE = '2022-12-31';

;WITH Dates AS (
    SELECT @StartDate AS Calendar_Date
    UNION ALL
    SELECT DATEADD(DAY, 1, Calendar_Date)
    FROM Dates
    WHERE Calendar_Date < @EndDate
)
INSERT INTO dbo.Dim_Date (
    Calendar_Date,
    [Year],
    [Quarter],
    [Month],
    Month_Name,
    [Day],
    Day_Of_Week,
    Day_Name,
    Is_Weekend
)
SELECT
    Calendar_Date,
    YEAR(Calendar_Date),
    DATEPART(QUARTER, Calendar_Date),
    MONTH(Calendar_Date),
    DATENAME(MONTH, Calendar_Date),
    DAY(Calendar_Date),
    DATEPART(WEEKDAY, Calendar_Date),
    DATENAME(WEEKDAY, Calendar_Date),
    CASE WHEN DATENAME(WEEKDAY, Calendar_Date) IN ('Saturday', 'Sunday')
         THEN 1 ELSE 0 END
FROM Dates
OPTION (MAXRECURSION 2000);