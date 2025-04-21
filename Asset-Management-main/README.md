

# 🏢 Real Estate Asset Management EDA 📊

Welcome to the **Real Estate Asset Management** exploratory data analysis project!  
This project explores a commercial real estate dataset to provide actionable insights into property performance, manager effectiveness, and regional trends using Python, SQL, and Tableau.

### 🔗 Interactive Dashboard  
📊 **View Visual Insights in Tableau:**  

[![Tableau Dashboard Preview](https://public.tableau.com/thumb/views/Book1_17441155230970/Dashboard1)](https://public.tableau.com/views/Book1_17441155230970/Dashboard1?:language=en-US&:display_count=n&:origin=viz_share_link)



---

## 📂 Dataset Overview

The dataset is sourced from an Excel workbook with four main sheets:

- **`Asset_Managers`**: Manager names, region, and experience (in years)
- **`Properties`**: Property details including occupancy, sqft, manager ID, etc.
- **`Gross_Values`**: Gross property values by property ID
- **`Property_Details`**: Supplementary metadata about each property

---

## 🔍 Key Questions Explored

1. ✅ Who manages the most properties?
2. 📈 Which property type has the highest average occupancy?
3. 💰 Which region has the highest average gross value?
4. 🧠 Does experience influence property performance?
5. 🚩 Are there unrealistic values in occupancy data?
6. 🏢 What’s the average vacant square footage per property type?

---

## 📊 Tools & Technologies Used

- **Python (Pandas, Matplotlib)** for cleaning, analysis, and visualization
- **SQL** for business logic-based queries
- **Tableau Public** for interactive visual analytics
- **Jupyter Notebook** as a development environment

---

## 📁 Project Files

| File | Description |
|------|-------------|
| `Asset_Management_Dataset.xlsx` | Main dataset with all related sheets |
| `RealEstate_EDA_Solutions.ipynb` | Python notebook with EDA |
| `business_questions.sql` | SQL scripts to answer key business queries |
| `README.md` | Project overview and documentation |

---

## 🧠 Insights Summary

- 📌 **Retail properties** generally have the highest occupancy percentage.
- 🚨 Some properties reported occupancy **>100%** — indicating possible data issues.
- 🏆 **Experienced managers** are often associated with higher-performing properties.
- 🌍 The **East region** had the most high-value properties.
- 📉 Industrial properties had the most **vacant space** on average.

---

## 🧾 Business Logic (SQL)

All core business questions were also translated into SQL for enterprise reporting environments.  
The file [`business_questions.sql`](business_questions.sql) includes queries like:

- Top 5 managers by property count
- Average occupancy by property type
- Regional gross value ranking
- Flagging properties with occupancy > 100%
- And more!

---

## 🚀 Next Steps

- ✅ Clean up outlier values (e.g. occupancy > 100%)
- 🔍 Add time dimension for trend analysis
- 📉 Create predictive models for underperforming assets
- 📊 Integrate financial KPIs like rent collected and ROI

---

## 🤝 Let's Connect

Have questions or want to collaborate?  
Reach out via [Tableau Public](https://public.tableau.com/app/profile/syeeda.fatima1036/viz/Book1_17441155230970/Dashboard1) 
or fork this project on GitHub and let’s explore real estate data together!


