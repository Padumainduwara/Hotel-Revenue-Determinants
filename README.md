# 🏨 Strategic Data Science Analysis of Hotel Revenue Determinants

## 📌 Overview
This repository contains a comprehensive data science project aimed at identifying and modeling the key drivers of hotel revenue within the hospitality sector. The analysis leverages advanced statistical methodologies and machine learning (Multiple Linear Regression) to extract actionable business intelligence from raw operational data.

## 🎯 Objectives
* **Data Preprocessing:** Clean, structure, and verify the integrity of the raw hotel dataset.
* **Exploratory Data Analysis (EDA):** Uncover hidden patterns, detect outliers, and analyze correlations among key variables such as room capacity, pricing strategies (ADR), and service quality.
* **Statistical Hypothesis Testing:** Validate mathematical assumptions using Shapiro-Wilk and Pearson correlation tests.
* **Predictive Modeling:** Build, optimize, and evaluate robust regression models to accurately forecast future hotel revenue.

## 🛠️ Technologies & Libraries Used
* **Programming Language:** R
* **Environment:** RStudio
* **Key Libraries:** * `ggplot2` (Advanced Visualization)
  * `dplyr` (Data Manipulation Pipeline)
  * `corrplot` (Correlation Heatmaps)
  * `car` (Regression Diagnostics & VIF)
  * `psych` (Detailed Descriptive Statistics)
  * `caTools` (Machine Learning Train/Test Splits)

## 📂 Repository Structure
* `Hotel-Revenue-Determinants.R`: The primary R script containing the complete, commented data science pipeline.
* `HOTELS_2025.csv`: The core dataset utilized for the analysis.
* `Images/`: A directory containing all generated visual outputs, including:
  * Histograms and Density Curves
  * Boxplots for Outlier Detection
  * Correlation Heatmaps and Scatterplot Matrices
  * Q-Q Plots and Residual Diagnostic Graphs
* `Hotel-Revenue-Determinants.docx`: The detailed academic/professional report explaining the methodology and strategic findings.

## 📈 Methodology Pipeline
1. **Data Integrity Check:** Handled duplicates and missing values to ensure model readiness.
2. **Feature Engineering:** Converted categorical data (e.g., Hotel Quality Rank) into ordered factors.
3. **Bivariate & Multivariate Analysis:** Identified `RoomsAvailable` and `ADR` as primary revenue drivers.
4. **Machine Learning Training:** Split data into 70% Training and 30% Testing sets.
5. **Model Evaluation:** Achieved high predictive accuracy, validated by R-Squared metrics, low RMSE, and healthy residual plots.

## 💡 Key Strategic Findings
1. **Capacity is the Ceiling:** `RoomsAvailable` exhibits the strongest positive correlation with revenue.
2. **The Premium of Quality:** Upgrading a hotel's quality rank yields a non-linear, significant jump in revenue potential.
3. **Pricing Power:** Average Daily Rate (ADR) strongly impacts revenue, indicating that value-addition strategies are far superior to price-dropping/discounting.
4. **Model Robustness:** The final Multiple Linear Regression model successfully avoids multicollinearity (VIF < 5) and accurately maps actual vs. predicted revenue.

## 🚀 How to Run the Project
1. **Clone the repository** to your local machine.
2. Open `Task A.R` in **RStudio**.
3. Set your working directory to the repository folder to ensure `HOTELS_2025.csv` loads correctly.
4. Uncomment and run the `install.packages()` line at the top of the script if you are missing any libraries.
5. Execute the script step-by-step to explore the console outputs and generate the analytical plots.

---
