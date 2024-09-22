-- Exploratory Data Analysis

SELECT *
FROM layoffs2_dupes;

SELECT max(total_laid_off), max(percentage_laid_off)
FROM layoffs2_dupes;

SELECT *
FROM layoffs2_dupes
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT *
FROM layoffs2_dupes
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs2_dupes
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs2_dupes;

SELECT YEAR(`date`), sum(total_laid_off)
FROM layoffs2_dupes
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;


SELECT stage, SUM(total_laid_off)
FROM layoffs2_dupes
GROUP BY stage
ORDER BY 2 DESC;


SELECT company, AVG(percentage_laid_off)
FROM layoffs2_dupes
GROUP BY company
ORDER BY 2 DESC;

SELECT SUBSTRING(`date`,6,2) AS `Month` , SUM(total_laid_off)
FROM layoffs2_dupes
GROUP BY SUBSTRING(`date`,6,2);


SELECT SUBSTRING(`date`,1,7) AS `Month` , SUM(total_laid_off)
FROM layoffs2_dupes
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 ASC;

WITH Rolling_total AS
(
SELECT SUBSTRING(`date`,1,7) AS `Month` , SUM(total_laid_off) AS total_off
FROM layoffs2_dupes
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 ASC
)
SELECT `Month` , total_off
,SUM(total_off) OVER(ORDER BY `Month`) AS rolling_total
FROM Rolling_total;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs2_dupes
GROUP BY company, YEAR(`date`)
ORDER BY company ASC;


SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs2_dupes
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH company_year (company, years, total_laid_off) AS
(SELECT company, YEAR(`date`), SUM(total_laid_off)
from layoffs2_dupes
GROUP BY company, YEAR(`date`)
), company_year_rank AS
(SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM company_year
WHERE years IS NOT NULL
)
SELECT *
FROM company_year_rank
WHERE ranking <=5;


