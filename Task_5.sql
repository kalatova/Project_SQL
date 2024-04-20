/* OTÁZKA 5: Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji 
 v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším 
 růstem? */

-- view na ekonomické hodnoty

CREATE OR REPLACE VIEW v_tereza_kalatova_GDP_diff AS
	SELECT 
		tksf.`year` AS previous_year,
		tksf1.`year` AS current_year,
		round (tksf1.GDP / tksf.GDP * 100 - 100, 2) AS GDP_percentage_diff
	FROM t_tereza_kalatova_project_sql_secondary_final tksf  
	LEFT JOIN t_tereza_kalatova_project_sql_secondary_final tksf1 
		ON tksf.`year` = tksf1.`year` - 1
		AND tksf.country = tksf1.country 
	WHERE tksf.year BETWEEN 2006 AND 2018
		AND tksf.country = 'Czech Republic'
	ORDER BY tksf.`year` 
;	


-- a) porovnání totožných období rozdílů HDP, cen i platů
			
SELECT 
	vgd.previous_year AS previous_year, 
	vgd.current_year AS current_year,
	vgd.GDP_percentage_diff,
	vppd.prc_percentage_diff,
	vppd.pay_percentage_diff,
	CASE 
		WHEN (vgd.GDP_percentage_diff > 0 AND vppd.prc_percentage_diff > 0)
			OR (vgd.GDP_percentage_diff <= 0 AND vppd.prc_percentage_diff <= 0) THEN 'same'
		ELSE 'not_same'
	END AS GDP_price_context,
	CASE 
		WHEN (vgd.GDP_percentage_diff > 0 AND vppd.pay_percentage_diff > 0) 
			OR (vgd.GDP_percentage_diff <= 0 AND vppd.pay_percentage_diff <= 0) THEN 'same'
		ELSE 'not_same'
	END AS GDP_payroll_context
FROM v_tereza_kalatova_gdp_diff vgd 	
LEFT JOIN v_tereza_kalatova_price_vs_payroll_diff vppd 
	ON vgd.previous_year = vppd.previous_year
	WHERE vppd.previous_year != 2018
ORDER BY vppd.previous_year 
;


-- b) porovnání vlivu předchozího období na období následující

SELECT 
	vgd.previous_year AS previous_year_GDP, 
	vgd.current_year AS current_year_GDP,
	vgd.GDP_percentage_diff,
	vppd.previous_year AS previous_year_PP,
	vppd.current_year AS current_year_PP,
	vppd.prc_percentage_diff,
	vppd.pay_percentage_diff,
	CASE
		WHEN (vgd.GDP_percentage_diff > 0 AND vppd.prc_percentage_diff > 0)
			OR (vgd.GDP_percentage_diff <= 0 AND vppd.prc_percentage_diff <= 0) THEN 'same'
		ELSE 'not_same'
		END AS GDP_price_context,
	CASE
		WHEN (vgd.GDP_percentage_diff > 0 AND vppd.pay_percentage_diff > 0)
			OR (vgd.GDP_percentage_diff <= 0 AND vppd.pay_percentage_diff <= 0) THEN 'same'
		ELSE 'not_same'
		END AS GDP_payroll_context
FROM v_tereza_kalatova_gdp_diff vgd 	
LEFT JOIN v_tereza_kalatova_price_vs_payroll_diff vppd 
	ON vgd.previous_year = vppd.previous_year - 1 
WHERE vgd.previous_year != 2018
ORDER BY vgd.previous_year
;

