# Layoff Exploration Data Analysis
I analyzed a layoff dataset spanning from March 2020 to March 2023 using SQL Server to extract valuable insights.

## 📚 Table of Contents
- [Business Task](#business-task)
- [Why This Task Matters](#why-this-task-matters)
- [Data Exploration](#data-exploration)
  - [A. Trend Analysis](#a-trend-analysis)
  - [B. Industry Impact](#b-industry-impact)
  - [C. Geographic Insights](#c-geographic-insights)
  - [D. Size & Layoff](#d-company-size--layoff)

***

## Business Task
Analyze layoff trends to identify industry and regional vulnerabilities during the economic downturn caused by the 2023 pandemic.

## Why This Task Matters
- The COVID-19 pandemic caused widespread disruption starting in March 2020.
- Many companies had to make tough decisions around staffing.
- Understanding these patterns can help organizations:
  - Prepare better for future crises.
  - Benchmark themselves against competitors.
  - Identify industries or roles most affected and build more resilient HR strategies.

## Data Exploration

### A. Trend Analysis
#### 1. How did layoff numbers change over time?
````sql
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
WHERE Year(`date`) IS NOT NULL
GROUP BY YEAR(`date`)
ORDER BY 1 ASC;
````
#### Answer: 
![image](https://github.com/user-attachments/assets/b0e69e4c-4ffb-4690-b88e-224857828596)
- In 2020, there were 80,998 layoffs. In 2021, that number dropped to 15,823. But in 2022, layoffs surged to 160,661—the highest in the period. In 2023, there were 125,677 layoffs, which might seem like an improvement compared to 2022. However, that number only represents data from the first three months of 2023.

#### 2. Can you show me the cumulative (rolling) total of layoffs by month using a Common Table Expression (CTE)?
````sql
WITH DATE_CTE AS 
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates, total_laid_off, SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;
````
#### Answer:
![image](https://github.com/user-attachments/assets/9d21ad6a-b63c-4c05-ab5e-60e91932fb62)![image](https://github.com/user-attachments/assets/b3ad3556-0771-4dd8-9461-eb0b0221e22f)
- This provides a more detailed breakdown of the previous question. Notably, certain months in 2021 show significantly lower layoff figures compared to corresponding months in other years.

#### 3. Which three companies were most affected each year?
````sql
WITH Company_Year AS 
(
  SELECT company, YEAR(`date`) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging2
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;
````
#### Answer:
![image](https://github.com/user-attachments/assets/7c8a9774-6d07-41d1-b7cc-ff265e4ba479)
- The three most affected companies in 2020 were Uber, Booking.com, and Groupon. In 2021, the companies most impacted were ByteDance, Katerra, and Zillow. For 2022, Meta, Amazon, and Cisco recorded the highest layoffs. Finally, in 2023, the most affected companies were Google, Microsoft, and Ericsson.

***
### B. Industry Impact
#### 1. Which industries were hit hardest?
````sql
SELECT industry, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;
````
#### Answer:
![image](https://github.com/user-attachments/assets/8cdc7b1e-f82f-4a62-8935-52fad7d5ad23)<br />
.<br />
.<br />
.<br />
![image](https://github.com/user-attachments/assets/34430402-d876-4050-902d-9524541c4647)
- Consumer and retail sectors were hit really hard, which makes sense given that shops closed down because people couldn’t go in due to the coronavirus. Following that, the most impacted industries were transportation, finance, healthcare, food, and so on. The least impacted industries were manufacturing, fintech, aerospace, energy, legal, and product.

#### 2. What are the top 5 companies with the largest single layoffs?
````sql
SELECT company, total_laid_off
FROM world_layoffs.layoffs_staging
ORDER BY 2 DESC
LIMIT 5;
````
#### Answer:
![image](https://github.com/user-attachments/assets/666ddd14-474f-4636-98d6-cb0604264f63)
- They are large companies: Google, Meta, Amazon, Microsoft, and Ericsson.

#### 3. What are the top 10 companies with the highest total layoffs?
````sql
SELECT company, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;
````
#### Answer:
![image](https://github.com/user-attachments/assets/4dfffb5e-8a8f-40aa-a46e-10c1b20273a2)
- Again, the top 10 companies with the highest total layoffs are large companies: Amazon, Google, Meta, Salesforce, Microsoft, and other major tech companies.

***

### C. Geographic Insights

#### 1. Which countries were most affected?
````sql
SELECT country, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY 2 DESC
Limit 10;
````
#### Answer:
![image](https://github.com/user-attachments/assets/4f4482dd-4003-4d8a-8304-650860eb46c3)
- United States, India, Netherlands, Sweden, Brazil, Germany, United Kingdom, Canada, Singapore, and China are affected the most.

#### 2. Which cities were most affected?
````sql
SELECT location, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;
````
#### Answer:
![image](https://github.com/user-attachments/assets/daba9e51-765e-41e4-a141-00a7d8c06f60)
- The most affected cities are the San Francisco Bay Area, Seattle, New York City, Bengaluru, Amsterdam, Stockholm, Boston, São Paulo, Austin, and Chicago.

***

### D. Company Size & Layoff

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

***

