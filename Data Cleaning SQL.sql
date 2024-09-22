-- Data Cleaning

SELECT *
FROM layoffs;

CREATE TABLE layoffs2
LIKE layoffs;

SELECT *
FROM layoffs2;

INSERT layoffs2
SELECT *
FROM layoffs;

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`)
FROM layoffs2;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs2
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

CREATE TABLE `layoffs2_dupes` (
  `company` TEXT,
  `location` TEXT,
  `industry` TEXT,
  `total_laid_off` INT DEFAULT NULL,
  `percentage_laid_off` TEXT,
  `date` TEXT,
  `stage` TEXT,
  `country` TEXT,
  `funds_raised_millions` INT DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs2_dupes
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs2;

SELECT *
FROM layoffs2_dupes
WHERE row_num >= 2;

DELETE 
FROM layoffs2_dupes
WHERE row_num >= 2;

SELECT *
FROM layoffs2_dupes
WHERE row_num >= 2;


-- Standardising Data

SELECT company, TRIM(company)
FROM layoffs2_dupes;


UPDATE layoffs2_dupes
SET company = TRIM(company);

SELECT *
FROM layoffs2_dupes;


SELECT *
FROM layoffs2_dupes
WHERE industry LIKE 'crypto%';

UPDATE layoffs2_dupes
SET industry = 'crypto'
WHERE industry LIKE 'crypto%';

SELECT DISTINCT industry
FROM layoffs2_dupes;


SELECT DISTINCT location
FROM layoffs2_dupes
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs2_dupes
WHERE country = 'unitef states%'
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs2_dupes;

UPDATE layoffs2_dupes
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'united states%';

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs2_dupes;

UPDATE layoffs2_dupes
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT `date`
FROM layoffs2_dupes;

ALTER TABLE layoffs2_dupes
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs2_dupes;

-- Null and Blank Values

SELECT *
FROM layoffs2_dupes
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoffs2_dupes
SET industry = NULL
WHERE industry = '';


SELECT *
FROM layoffs2_dupes
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM layoffs2_dupes
WHERE company = 'airbnb';

SELECT *
FROM layoffs2_dupes t1
JOIN layoffs2_dupes t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry  = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs2_dupes t1
JOIN layoffs2_dupes t2
	ON t1.company = t2.company
    SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;


SELECT *
FROM layoffs2_dupes
WHERE company LIKE 'bally%';

DELETE
FROM layoffs2_dupes
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


SELECT *
FROM layoffs2_dupes;

-- Deleting columns or rows

ALTER TABLE layoffs2_dupes
DROP COLUMN row_num;
