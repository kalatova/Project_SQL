-- OTÁZKA 4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

SELECT DISTINCT 
	tkpf.pay_year AS previous_year,
	tkpf1.pay_year AS current_year,
	round (avg (tkpf1.avg_price) / avg (tkpf.avg_price) * 100 - 100, 2) AS prc_percentage_diff,
	round (avg (tkpf1.avg_payroll) / avg (tkpf.avg_payroll) * 100 - 100, 2) AS pay_percentage_diff,
	round (avg (tkpf1.avg_price) / avg (tkpf.avg_price) * 100 - 100, 2) - round (avg (tkpf1.avg_payroll) / avg (tkpf.avg_payroll) * 100 - 100, 2) AS difference
FROM t_tereza_kalatova_project_sql_primary_final tkpf
LEFT JOIN t_tereza_kalatova_project_sql_primary_final tkpf1
	ON tkpf.pay_year = tkpf1.pay_year - 1
	AND tkpf.prc_code = tkpf.prc_code 
GROUP BY tkpf.pay_year 
;


-- Je nárůst cen potravin někdy vyšší o více jak 10 % než nárůst mezd?

CREATE OR REPLACE VIEW v_tereza_kalatova_price_vs_payroll_diff AS
	SELECT DISTINCT 
		tkpf.pay_year AS previous_year,
		tkpf1.pay_year AS current_year,
		round (avg (tkpf1.avg_price) / avg (tkpf.avg_price) * 100 - 100, 2) AS prc_percentage_diff,
		round (avg (tkpf1.avg_payroll) / avg (tkpf.avg_payroll) * 100 - 100, 2) AS pay_percentage_diff,
		round (avg (tkpf1.avg_price) / avg (tkpf.avg_price) * 100 - 100, 2) - round (avg (tkpf1.avg_payroll) / avg (tkpf.avg_payroll) * 100 - 100, 2) AS difference
	FROM t_tereza_kalatova_project_sql_primary_final tkpf
	LEFT JOIN t_tereza_kalatova_project_sql_primary_final tkpf1
		ON tkpf.pay_year = tkpf1.pay_year - 1
		AND tkpf.prc_code = tkpf.prc_code 
	GROUP BY tkpf.pay_year

SELECT DISTINCT 
	vppd.previous_year,
	vppd.current_year,
	vppd.difference,
	CASE 
		WHEN vppd.difference > 10 THEN 'YES'
		ELSE 'NO'
	END AS perc_diff_over_10	
FROM v_tereza_kalatova_price_vs_payroll_diff vppd 
;


-- Kde je rozdíl nárůstu cen nejvyšší oproti mzdám?

SELECT 
	vppd.previous_year,
	vppd.current_year,
	vppd.prc_percentage_diff,
	vppd.pay_percentage_diff, 
	max (vppd.difference) AS max_perc_diff
FROM v_tereza_kalatova_price_vs_payroll_diff vppd
GROUP BY vppd.previous_year, vppd.current_year, vppd.prc_percentage_diff, vppd.pay_percentage_diff 
ORDER BY max_perc_diff DESC 
LIMIT 1
;
