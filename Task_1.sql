-- Q 1: Rostou v průběhu let mzdy ve všech odvětvích nebo v některých klesají?

SELECT DISTINCT 
	tkpf.branch_code,
	tkpf.branch_name,
	tkpf.pay_year,
	tkpf.avg_payroll,
	tkpf1.pay_year,
	tkpf1.avg_payroll,
	round (tkpf1.avg_payroll / tkpf.avg_payroll * 100 - 100, 2) AS percentage_diff
FROM t_tereza_kalatova_project_sql_primary_final tkpf
LEFT JOIN t_tereza_kalatova_project_sql_primary_final tkpf1
	ON tkpf.pay_year = tkpf1.pay_year - 1
	AND tkpf.branch_code = tkpf1.branch_code
WHERE
	tkpf.branch_code IS NOT NULL 
	AND tkpf1.branch_code IS NOT NULL 
;
