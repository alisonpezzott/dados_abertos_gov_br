CREATE MATERIALIZED VIEW mte_rais.mv_frais AS

SELECT 
	LPAD(t.cnae_20_subclasse, 7, '0') AS cnae_id
	,CASE 
		WHEN t.tamanho_estabelecimento = '-1'
			THEN '99'
		WHEN t.tamanho_estabelecimento IN ('01', '02', '03')
			THEN '1'
		WHEN t.tamanho_estabelecimento IN ('09', '10')
			THEN '4'
		WHEN (t.tamanho_estabelecimento IN ('04', '05'))
			AND (u.secao_id NOT IN ('A', 'B', 'C', 'Z'))
			THEN '2'
		WHEN t.tamanho_estabelecimento = '06'
			AND (u.secao_id NOT IN ('A', 'B', 'C', 'Z'))
			THEN '3'
		WHEN (t.tamanho_estabelecimento IN ('07', '08'))
			AND (u.secao_id NOT IN ('A', 'B', 'C', 'Z'))
			THEN '4'
		WHEN t.tamanho_estabelecimento = '04'
			AND (u.secao_id IN ('A', 'B', 'C'))
			THEN '1'
		WHEN (t.tamanho_estabelecimento IN ('05', '06'))
			AND (u.secao_id IN ('A', 'B', 'C'))
			THEN '2'
		WHEN (t.tamanho_estabelecimento IN ('07', '08'))
			AND (u.secao_id IN ('A', 'B', 'C'))
			THEN '3'
		ELSE '99'
		END AS porte_id
	,t.uf AS estado_id
	,t.ano_base
	,SUM(t.qtd_vinculos_ativos::INTEGER) AS vinculos_ativos
FROM (
	SELECT *
	FROM mte_rais.tbl_rais_2017 a
	
	UNION
	
	SELECT *
	FROM mte_rais.tbl_rais_2018 b
	
	UNION
	
	SELECT *
	FROM mte_rais.tbl_rais_2019 c
	
	UNION
	
	SELECT *
	FROM mte_rais.tbl_rais_2020 d
	) t
LEFT JOIN ibge_cnae.tbl_ibge_cnae u ON u.subclasse_id = LPAD(t.cnae_20_subclasse, 7, '0')
GROUP BY t.cnae_20_subclasse
	,(
		CASE 
			WHEN t.tamanho_estabelecimento = '-1'
			THEN '99'
		WHEN t.tamanho_estabelecimento IN ('01', '02', '03')
			THEN '1'
		WHEN t.tamanho_estabelecimento IN ('09', '10')
			THEN '4'
		WHEN (t.tamanho_estabelecimento IN ('04', '05'))
			AND (u.secao_id NOT IN ('A', 'B', 'C', 'Z'))
			THEN '2'
		WHEN t.tamanho_estabelecimento = '06'
			AND (u.secao_id NOT IN ('A', 'B', 'C', 'Z'))
			THEN '3'
		WHEN (t.tamanho_estabelecimento IN ('07', '08'))
			AND (u.secao_id NOT IN ('A', 'B', 'C', 'Z'))
			THEN '4'
		WHEN t.tamanho_estabelecimento = '04'
			AND (u.secao_id IN ('A', 'B', 'C'))
			THEN '1'
		WHEN (t.tamanho_estabelecimento IN ('05', '06'))
			AND (u.secao_id IN ('A', 'B', 'C'))
			THEN '2'
		WHEN (t.tamanho_estabelecimento IN ('07', '08'))
			AND (u.secao_id IN ('A', 'B', 'C'))
			THEN '3'
		ELSE '99'
			END
		)
	,t.uf
	,t.ano_base;
