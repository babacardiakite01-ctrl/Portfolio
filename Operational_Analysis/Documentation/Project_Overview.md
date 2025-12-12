# Operational Analysis Dashboard – Project Overview

## 🔍 Introduction
The **Operational Analysis Dashboard** is an end-to-end Business Intelligence (BI) project designed to simulate real-world manufacturing analytics.  
This project demonstrates how SQL Server and Power BI can be used together to build a complete analytical solution that answers critical operational questions.

The dataset represents a fictional manufacturing company with four major operational domains:

- **Production**
- **Quality**
- **Logistics**
- **Human Resources (HR)**

Each dataset was structured using a **star-schema model**, enabling fast analytical queries and flexible reporting.

---

## 🎯 Project Objectives
This project was built to showcase the full BI lifecycle:

### **1. Data Engineering**
- Design a relational star schema
- Create dimension and fact tables
- Generate realistic operational data
- Implement stored procedures and validation queries

### **2. Data Analysis Using SQL**
- Aggregations and performance metrics
- Window functions (RANK, rolling totals, trends)
- CTE-based transformations
- Data quality checks and exception handling

### **3. Data Visualization in Power BI**
- KPI dashboards
- Trends and rolling averages
- Machine performance analysis
- Quality defect monitoring
- Logistics and HR insights

---

## 🧱 Data Model Summary

The project uses a clean, normalized **star schema**:

### **Dimensions:**
- `Dim_Date`
- `Dim_Region`
- `Dim_Product`
- `Dim_Machine`
- `Dim_Employee`

### **Fact Tables:**
- `Fact_Production`
- `Fact_Quality`
- `Fact_Logistics`
- `Fact_HR`

The star schema supports cross-functional analysis such as:
- Output by machine and region  
- Defect rate by product category  
- Logistics cost per region  
- Overtime impact on productivity  

A visual version of the data model is stored in:  
`Documentation/Data_Model.png`

---

## 📊 Key Business Questions Answered

### **Production**
- Which machines produce the most output?
- What are the top-performing regions?
- How does downtime affect productivity?
- What is the rolling 30-day production trend?

### **Quality**
- Which defect types are most common?
- What is the scrap cost trend?
- Which products have the highest defect rate?

### **Logistics**
- What is the on-time delivery percentage?
- What is the cost per shipment by region?

### **HR**
- How many hours were worked per week?
- What is the overtime burden?
- Are there patterns in absenteeism?

---

## 🧠 Technical Skills Demonstrated

### **SQL Server**
- Table creation, constraints, indexing
- Data loading & transformation
- Stored procedures for ETL logic
- Analytical functions and CTEs
- Error handling and validation

### **Power BI**
- Relationship modeling
- KPI creation
- Drill-through pages
- Trend analysis and DAX measures
- Dashboard design & storytelling

---

## 🚀 Project Outcome
The **Operational Analysis Dashboard** represents a complete BI workflow:

1. **Engineering the data model**
2. **Transforming and validating data using SQL**
3. **Building analytical queries**
4. **Visualizing insights in Power BI**

This project demonstrates real-world BI Analyst skills and prepares for interview scenarios involving operational data.

---
