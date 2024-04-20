-- tabulka 1:

CREATE OR REPLACE TABLE t_tereza_kalatova_project_SQL_primary_final AS
	SELECT
		cpay.industry_branch_code AS branch_code,
		cpay.payroll_year AS pay_year, 
		round (avg (cpay.value), 2) AS avg_payroll,
		cpib.name AS branch_name, 
		cprc.category_code AS prc_code,
		round (avg (cprc.value), 2) AS avg_price, 
		cpcg.name AS cat_name
	FROM czechia_payroll cpay 
	LEFT JOIN czechia_payroll_industry_branch cpib 
		ON cpay.industry_branch_code = cpib.code
	LEFT JOIN czechia_price cprc 
		ON cpay.payroll_year = YEAR (cprc.date_from)
	LEFT JOIN czechia_price_category cpcg 
		ON cprc.category_code = cpcg.code
	WHERE cpay.value_type_code = 5958
		AND cpay.unit_code = 200
		AND cpay.calculation_code = 200
		AND cpay.industry_branch_code IS NOT NULL 
		AND cpay.payroll_year BETWEEN 2006 AND 2018
	GROUP BY branch_code, pay_year, prc_code, YEAR (date_from)
	ORDER BY branch_code, pay_year, prc_code, date_from
;


/* zjištění minima a maxima data

SELECT 
	min (payroll_year),
	max (payroll_year)
FROM czechia_payroll cp 
;

SELECT 
	min (date_from),
	max (date_to)
FROM czechia_price cp
; 
		
SELECT 
	min (year),
	max (year)
FROM economies e 
; 

*/


-- tabulka 2:

CREATE OR REPLACE TABLE t_tereza_kalatova_project_SQL_secondary_final AS
	SELECT 
		country,
		YEAR,
		GDP,
		population,
		gini
	FROM economies e 
	WHERE YEAR BETWEEN 2006 AND 2018
		AND country IN (
		SELECT 
			country
		FROM countries c 
		WHERE
		continent = 'Europe'
		AND continent IS NOT NULL 
		)
	ORDER BY country, YEAR
;