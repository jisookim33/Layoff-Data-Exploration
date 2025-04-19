# Layoff-Data-Exploration
I analyzed a layoff dataset spanning from March 2020 to March 2023 using SQL Server to extract valuable insights.

## 📚 Table of Contents
- [Business Task](#business-task)
- [Why This Task Matters](#why-this-task-matters)
- [Data Exploration](#data-exploration)
  - [Company Size & Layoff](#a-company-size--layoff)

***

## Business Task
Analyze layoff trends to identify industry and geographic vulnerabilities during economic downturns, and provide insights to guide workforce planning and risk mitigation strategies.

## Why This Task Matters
- The COVID-19 pandemic caused widespread disruption starting in March 2020.
- Many companies had to make tough decisions around staffing.
- Understanding these patterns can help organizations:
  - Prepare better for future crises.
  - Benchmark themselves against competitors.
  - Identify industries or roles most affected and build more resilient HR strategies.

## Data Exploration

### A. Company Size & Layoff
#### 1. I looked at the percentage of layoffs to understand how large the reductions were.
````sql
SELECT MAX(percentage_laid_off),  MIN(percentage_laid_off)
FROM world_layoffs.layoffs_staging2
WHERE  percentage_laid_off IS NOT NULL;
````
#### Answer: 
![image](https://github.com/user-attachments/assets/e7d1dbe3-5d0c-468c-afe0-4a188ff6a30e)
- The percentage ranges from 0 to 1, where 0 indicates no layoffs and 1 indicates that the entire company was laid off.

#### 2. Which companies had 1 `percentage_laid_off` which is 100% of the company laid off?
````sql
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE  percentage_laid_off = 1;
````
#### Answer:
![image](https://github.com/user-attachments/assets/4dcfdd9f-658b-4adc-88f1-d0d15d57aedf)
- Most of the companies that went out of business during this period were startups.

#### 3. What can we learn about the size of these companies if we order the data by `funds_raised_millions`?
````sql
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE  percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;
````
#### Answer:
![image](https://github.com/user-attachments/assets/9614ffa4-293a-4232-ad3d-62bbbd95dee5)
- BritishVolt was an electric vehicle battery startup and Quibi was a streaming service company. They raised around 2 billion dollars, but they are no longer operating - ouch!

### B. Trend Analysis

How did layoff numbers change over time?
Were there spikes that correlate with key pandemic-related events?

### C. Industry Impact:

Which industries were hit hardest?
How quickly did different sectors recover?

### D. Geographic Insights:

Were some states or countries more affected than others?
Any correlation between layoff volume and COVID-19 case surges or policy responses?

Company Size & Layoffs:

Were larger companies more likely to lay off employees?
Did startups or smaller firms recover faster?

Diversity Impact (if demographic data is included):

Were certain demographic groups more affected?

Forecasting:

Can you build a model to predict potential layoff risks based on economic indicators?
