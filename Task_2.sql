/* Q 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné 
 období v dostupných datech cen a mezd? */

SELECT
	tkpf.pay_year,
	tkpf.avg_payroll,
	tkpf.cat_name,
	tkpf.avg_price,
	round (tkpf.avg_payroll / tkpf.avg_price) AS pay_power
FROM t_tereza_kalatova_project_sql_primary_final tkpf
LEFT JOIN czechia_price_category cpc 
	ON cpc.code = tkpf.prc_code
WHERE
	tkpf.branch_code IS NOT NULL 
	AND tkpf.pay_year IN (2006, 2018)
	AND tkpf.prc_code IN (111301, 114201)
GROUP BY tkpf.pay_year, tkpf.cat_name 
;


-- pomocný select na zjištění kódu chleba a mléka:

SELECT 
	cpc.name,
	cpc.code
FROM czechia_price_category cpc 
WHERE cpc.name LIKE 'Chléb%' OR cpc.name LIKE 'Mléko%'
;
