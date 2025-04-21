-- Exploratory Data Analysis Project

-- total number of the laid-off
SELECT SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2;


-- A. Trend Analysis
--  1. How did layoff numbers change over time?
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
WHERE Year(`date`) IS NOT NULL
GROUP BY YEAR(`date`)
ORDER BY 1 ASC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
WHERE Year(`date`) IS NOT NULL
GROUP BY Year(`date`)
ORDER BY 1 DESC;
-- In 2020, there were 80,998 layoffs. In 2021, that number dropped to 15,823. 
-- But in 2022, layoffs surged to 160,661—the highest in the period. 
-- In 2023, there were 125,677 layoffs, which might seem like an improvement compared to 2022. 
-- However, that number only represents data from the first three months of 2023.

-- 2. Can you show me the cumulative (rolling) total of layoffs by month using a Common Table Expression (CTE)?
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
-- This provides a more detailed breakdown of the previous question. 
-- Notably, certain months in 2021 show significantly lower layoff figures compared to corresponding months in other years.

-- 3. What are the top 3 most affected companies per year?
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
-- The three most affected companies in 2020 were Uber, Booking.com, and Groupon. 
-- In 2021, the companies most impacted were ByteDance, Katerra, and Zillow. 
-- For 2022, Meta, Amazon, and Cisco recorded the highest layoffs. 
-- Finally, in 2023, the most affected companies were Google, Microsoft, and Ericsson.


-- B. Industry Impact
SELECT industry, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;
-- Consumer and retail sectors were hit really hard, which makes sense given that shops closed down because people couldn’t go in due to the coronavirus.
-- Following that, the most impacted industries were transportation, finance, healthcare, food, and so on.
-- The least impacted industries were manufacturing, fintech, aerospace, energy, legal, and product.

--  2. Companies with the biggest single Layoff
SELECT company, total_laid_off
FROM world_layoffs.layoffs_staging
ORDER BY 2 DESC
LIMIT 5;
-- They are large companies: Google, Meta, Amazon, Microsoft, and Ericsson.

--  3. "What are the top 10 companies with the highest total layoffs?
SELECT company, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;
-- Again, the top 10 companies with the highest t otal layoffs are large companies: Amazon, Google, Meta, Salesforce, Microsoft, and other major tech companies.

-- C. Geographic Insights
-- 1. Which countries were most affected??
SELECT country, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY 2 DESC
Limit 10;
-- United States, India, Netherlands, Sweden, Brazil, Germany, United Kingdom, Canada, Singapore, and China are affected the most.

--  2. Which cities were most affected?
SELECT location, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;
-- The most affected cities are the San Francisco Bay Area, Seattle, New York City, Bengaluru, Amsterdam, Stockholm, Boston, São Paulo, Austin, and Chicago.


-- D. Size & Layoff
--  1. I looked at the percentage of layoffs to understand how large the reductions were.
SELECT MAX(percentage_laid_off),  MIN(percentage_laid_off)
FROM world_layoffs.layoffs_staging2
WHERE  percentage_laid_off IS NOT NULL;
-- The percentage ranges from 0 to 1, where 0 indicates no layoffs and 1 indicates that the entire company was laid off.

--  2. Which companies had 1 `percentage_laid_off` which is 100% of the company laid off?
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE  percentage_laid_off = 1;
-- Most of the companies that went out of business during this period were startups.

--  3. What can we learn about the size of these companies if we order the data by `funds_raised_millions`?
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE  percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;
-- BritishVolt was an electric vehicle battery startup and Quibi was a streaming service company. They raised around 2 billion dollars, but they are no longer operating - ouch!
