-- OTÁZKA 3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

WITH base AS (
SELECT
	tkpf.pay_year,
	tkpf.prc_code,
	tkpf.cat_name,
	tkpf.avg_price,
	lag (tkpf.avg_price) OVER
	 (PARTITION BY tkpf.cat_name ORDER BY tkpf.pay_year) AS lag_price
FROM t_tereza_kalatova_project_sql_primary_final tkpf 
WHERE
	tkpf.pay_year >= 2006
	AND tkpf.avg_price IS NOT NULL
GROUP BY tkpf.prc_code, tkpf.pay_year 
)	
SELECT 
	cat_name,
	round ((sum (avg_price - lag_price) / avg_price) * 100, 1) AS growth_perc
FROM base
GROUP BY cat_name
;
