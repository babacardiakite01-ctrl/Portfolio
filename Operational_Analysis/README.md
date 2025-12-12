# Operational Analysis Dashboard Project

##  Overview
This project simulates an end-to-end operational analytics environment using SQL Server and Power BI.  
It demonstrates the skills required for a Business Intelligence (BI) Analyst or Data Analyst role, including:

- Data modeling (star schema)
- SQL data engineering (ETL steps)
- Analytical SQL queries
- KPI creation
- Building interactive dashboards
- Communicating insights to business stakeholders

The dataset represents a manufacturing-style operation, including production, quality, logistics, and HR data.

---

## 🗂 Project Structure

Operational_Analysis/
│
├── SQL/
│ ├── 01_Create_Tables.sql
│ ├── 02_Load_Dimensions.sql
│ ├── 03_Load_Facts.sql
│ ├── 04_Validation_Queries.sql
│ ├── 05_Analytical_Queries.sql
│
├── PowerBI/
│ ├── Operational_Analysis_Dashboard.pbix
│
├── Documentation/
│ ├── Project_Overview.md
│ ├── Data_Model.png
│ ├── Business_Questions.md
│ ├── SQL_Queries.md
│
└── README.md


---

##  Data Model
The project uses a star schema optimized for analytical reporting.

**Dimensions:**
- Date
- Region
- Product
- Machine
- Employee

**Fact Tables:**
- Production
- Quality
- Logistics
- HR

A diagram of the data model is located in:

Documentation/Data_Model.png


---

##  Key Analytical Skills Demonstrated

### ✔ SQL Engineering
- Creating tables, keys, and constraints  
- Loading data into a warehouse schema  
- Building stored procedures for ETL  
- Writing validation queries  

### ✔ Analytical SQL
- Window functions  
- Ranking  
- Rolling metrics (7-day / 30-day)  
- Aggregations  
- CTE-driven transformations  

### ✔ Power BI
- Data modeling  
- Relationships  
- Dashboard design  
- KPI cards  
- Trend analysis visualizations  

---

##  Dashboard Overview
The Power BI dashboard includes:

### **1. Executive Summary**
- Total Output  
- Quality Defect Rate  
- On-Time Delivery %  
- Overtime & Absenteeism  

### **2. Production Analysis**
- Output by machine and region  
- Downtime vs productivity  
- Rolling 30-day trend  

### **3. Quality**
- Defect types  
- Scrap weight  
- Pareto analysis  

### **4. Logistics**
- Delivery performance  
- Transportation cost  

### **5. HR**
- Hours worked  
- Overtime  
- Absence patterns  

---

##  Objective
This project demonstrates the full lifecycle of BI work:

1. **Data Engineering**  
2. **Data Analysis**  
3. **Visualization & Insight Communication**

It is designed to showcase job-ready technical and business analytics skills.

---

## 📬 Contact
If you’d like to discuss the project or BI analytics, feel free to connect.
