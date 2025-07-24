--------------------------------------------------------------------------------------------------
---TABELA URZADZEN Z BC Z DOPISANYMI DATAMI WEJSCIA NA MAGAZYN JEZELI URZADZENIE PRZESZLO Z NAV---

	
DECLARE @DataAnalizy DATE;
SET @DataAnalizy = '2025-03-21';	

WITH Urzadzenia_BC AS (

DECLARE @DataAnalizy DATE;
SET @DataAnalizy = '2025-03-31';

	SELECT 
		[Item No_]
	   ,[Serial No_] 
		,SUM([Quantity]) AS [Ilosc na stanie]
		,CAST(MIN([Posting Date]) AS DATE) AS [Pierwsza data]
		,CAST(MAX([Posting Date]) AS DATE) AS [Ostatnia data]
		,DATEDIFF(DAY, MIN([Posting Date]), @DataAnalizy) AS [WIEK]
		,CASE 
			WHEN DATEDIFF(DAY, MIN([Posting Date]), @DataAnalizy) > 2555 THEN 'Powyzej 7 lat'
			WHEN DATEDIFF(DAY, MIN([Posting Date]), @DataAnalizy) > 1825 THEN '5-7 lat'
			WHEN DATEDIFF(DAY, MIN([Posting Date]), @DataAnalizy) > 1095 THEN '3-5 lat'
			WHEN DATEDIFF(DAY, MIN([Posting Date]), @DataAnalizy) > 730 THEN '2-3 lat'
			WHEN DATEDIFF(DAY, MIN([Posting Date]), @DataAnalizy) > 365 THEN '1-2 lat'
			ELSE '0-1'
		END AS WIEK_URZADZEN
	FROM
		[Wiekowanie].dbo.[Zymetric$Item Ledger Entry$437dbf0e-84ff-417a-965d-ed2bb9650972]
	WHERE 
		[Serial No_] IS NOT NULL
		AND [Serial No_] <> ''
		AND [Posting Date] <= '2025-03-31'
--		AND [ITEM nO_] = 'MI/HBT-A160/240CDS9B'
	GROUP BY 
		[Item No_]
		,[Serial No_] 
	HAVING
		SUM([Quantity]) > 0  --WARUNEK DLA STANÓW KTÓRE NIE SĄ ZEROWE

),

Urzadzenia_NAV AS (

DECLARE @DataAnalizy DATE;
SET @DataAnalizy = '2025-03-31';

	SELECT 
		[Item No_]
		,[Serial No_] 
		,SUM([Quantity]) AS [Ilosc na stanie]
		,CAST(MIN([Posting Date]) AS DATE) AS [Pierwsza data]
		,CAST(MAX([Posting Date]) AS DATE) AS [Ostatnia data]
		,DATEDIFF(DAY, MIN([Posting Date]), @DataAnalizy) AS [WIEK W DNIACH] 
		,CASE 
			WHEN DATEDIFF(DAY, MIN([Posting Date]), @DataAnalizy) > 2555 THEN 'Powyzej 7 lat'
			WHEN DATEDIFF(DAY, MIN([Posting Date]), @DataAnalizy) > 1825 THEN '5-7 lat'
			WHEN DATEDIFF(DAY, MIN([Posting Date]), @DataAnalizy) > 1095 THEN '3-5 lat'
			WHEN DATEDIFF(DAY, MIN([Posting Date]), @DataAnalizy) > 730 THEN '2-3 lat'
			WHEN DATEDIFF(DAY, MIN([Posting Date]), @DataAnalizy) > 365 THEN '1-2 lat'
			ELSE 'Do roku'
		END AS WIEK_URZADZEN
		FROM
			[Wiekowanie].dbo.[Zymetric_Sp_zoo$Item Ledger Entry]
		WHERE 
			[Serial No_] IS NOT NULL
			AND [Serial No_] <> ''
			AND [Posting Date] <= '2025-03-31'
			and [Item No_] = 'MI/MI2-28Q4DN1'
		GROUP BY 
			[Item No_]
			,[Serial No_] 
		HAVING
			SUM([Quantity]) > 0  --WARUNEK DLA STANÓW KTÓRE PRZESZŁY DO BC
),

Koszt_Urzadzen AS (
	SELECT
		[No_]
		,[Description]
		,[Description 2]
		,[Unit Cost]
	FROM
		[Wiekowanie].dbo.[Zymetric$Item$437dbf0e-84ff-417a-965d-ed2bb9650972]
),

Numer_seryjny_z_wiekiem AS (

DECLARE @DataAnalizy DATE;
SET @DataAnalizy = '2025-03-31';

SELECT 
	BC.[Item No_]
	,BC.[Serial No_] 
	,BC.[Ilosc na stanie]
	,BC.[Pierwsza data] AS [Pierwsza data z BC]
	,NAV.[Pierwsza data] AS [Pierwsza data z NAV]
	,BC.[Ostatnia data] 
	,COALESCE(NAV.[Pierwsza data], BC.[Pierwsza data]) AS [NajwczesniejszaData]
	,CASE 
		WHEN DATEDIFF(DAY, COALESCE(NAV.[Pierwsza data], BC.[Pierwsza data]), @DataAnalizy) > 2555 THEN 'Powyzej 7 lat'
		WHEN DATEDIFF(DAY, COALESCE(NAV.[Pierwsza data], BC.[Pierwsza data]), @DataAnalizy) > 1825 THEN '5-7 lat'
		WHEN DATEDIFF(DAY, COALESCE(NAV.[Pierwsza data], BC.[Pierwsza data]), @DataAnalizy) > 1095 THEN '3-5 lat'
		WHEN DATEDIFF(DAY, COALESCE(NAV.[Pierwsza data], BC.[Pierwsza data]), @DataAnalizy) > 730 THEN '2-3 lat'
		WHEN DATEDIFF(DAY, COALESCE(NAV.[Pierwsza data], BC.[Pierwsza data]), @DataAnalizy) > 365 THEN '1-2 lat'
		ELSE '0-1'
	END AS [WIEK_URZADZEN]
FROM 
	Urzadzenia_BC AS BC
LEFT JOIN 
	Urzadzenia_NAV AS NAV 
	ON BC.[Serial No_] = NAV.[Serial No_]
	AND BC.[Item No_] = NAV.[Item No_]
)

SELECT
    [Item No_]
	,max([Description]) AS [Opis]
	,max([Description 2]) AS [Opis 2]
    ,[WIEK_URZADZEN]
    ,SUM([Ilosc na stanie]) AS [Ilosc na stanie]
    ,MAX(Koszt_Urzadzen.[Unit Cost]) AS [Koszt jednostkowy]
    ,ROUND((SUM([Ilosc na stanie]) * MAX(Koszt_Urzadzen.[Unit Cost])), 2) AS [Wartosc]
FROM
    Numer_seryjny_z_wiekiem
LEFT JOIN Koszt_Urzadzen
ON Koszt_Urzadzen.[No_] = Numer_seryjny_z_wiekiem.[Item No_]
GROUP BY
    [Item No_],
    [WIEK_URZADZEN]
ORDER BY 1, 4


---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------



--TABELA DO ANALIZY URZADZEN KTORE PRZESZLY NA STAN DO BC

DECLARE @DataAnalizy DATE;
SET @DataAnalizy = '2025-03-31';
	
SELECT 
	[Item No_]
   ,[Serial No_] 
	--,CAST([Posting Date] AS DATE) AS [Posting Date]
	--,[Entry Type]
--	,[Document No_]
--	,[Location Code]
--	,[Quantity]
--	,[Remaining Quantity]
	,SUM([Quantity]) AS [Ilosc na stanie]
	,CAST(MIN([Posting Date]) AS DATE) AS [Pierwsza data]
	,CAST(MAX([Posting Date]) AS DATE) AS [Ostatnia data]
	,DATEDIFF(DAY, MIN([Posting Date]), @DataAnalizy) AS [WIEK]
	,CASE 
		WHEN DATEDIFF(DAY, MIN([Posting Date]), @DataAnalizy) > 2555 THEN 'Powyzej 7 lat'
		WHEN DATEDIFF(DAY, MIN([Posting Date]), @DataAnalizy) > 1825 THEN '5-7 lat'
		WHEN DATEDIFF(DAY, MIN([Posting Date]), @DataAnalizy) > 1095 THEN '3-5 lat'
		WHEN DATEDIFF(DAY, MIN([Posting Date]), @DataAnalizy) > 730 THEN '2-3 lat'
		WHEN DATEDIFF(DAY, MIN([Posting Date]), @DataAnalizy) > 365 THEN '1-2 lat'
		ELSE 'Do roku'
	END AS WIEK_URZADZEN
FROM
	[Wiekowanie].dbo.[Nabilaton_Sp_zoo$Item Ledger Entry]
WHERE 
	[Serial No_] IS NOT NULL
	AND [Serial No_] <> ''
	AND [Posting Date] < '2025-03-31'
	--and [Item No_] = 'ENO-160-0.4-1-C'
GROUP BY 
	[Item No_]
	,[Serial No_] 
HAVING
	SUM([Quantity]) > 0  --WARUNEK DLA STANÓW KTÓRE PRZESZŁY DO BC
ORDER BY 
	WIEK DESC
	


---TABELA URZADZEN NA STANIE Z BUSINESS CENTRAL
	

DECLARE @DataAnalizy DATE;
SET @DataAnalizy = '2025-07-15';
	
SELECT 
	[Item No_]
   ,[Serial No_] 
	--,CAST([Posting Date] AS DATE) AS [Posting Date]
	--,[Entry Type]
--	,[Document No_]
--	,[Location Code]
--	,[Quantity]
--	,[Remaining Quantity]
	,SUM([Quantity]) AS [Ilosc na stanie]
	,CAST(MIN([Posting Date]) AS DATE) AS [Pierwsza data]
	,CAST(MAX([Posting Date]) AS DATE) AS [Ostatnia data]
	,DATEDIFF(DAY, MIN([Posting Date]), @DataAnalizy) AS [WIEK]
	,CASE 
		WHEN DATEDIFF(DAY, MIN([Posting Date]), @DataAnalizy) > 2555 THEN 'Powyzej 7 lat'
		WHEN DATEDIFF(DAY, MIN([Posting Date]), @DataAnalizy) > 1825 THEN '5-7 lat'
		WHEN DATEDIFF(DAY, MIN([Posting Date]), @DataAnalizy) > 1095 THEN '3-5 lat'
		WHEN DATEDIFF(DAY, MIN([Posting Date]), @DataAnalizy) > 730 THEN '2-3 lat'
		WHEN DATEDIFF(DAY, MIN([Posting Date]), @DataAnalizy) > 365 THEN '1-2 lat'
		ELSE 'Do roku'
	END AS WIEK_URZADZEN
FROM
	[Wiekowanie].dbo.[Nabilaton$Item Ledger Entry$437dbf0e-84ff-417a-965d-ed2bb9650972]
WHERE 
	[Serial No_] IS NOT NULL
	AND [Serial No_] <> ''	
	AND [Posting Date] <= '2025-03-31'
	--and [Item No_] = 'ENO-160-0.4-1-C'
GROUP BY 
	[Item No_]
	,[Serial No_] 
HAVING
	SUM([Quantity]) > 0
ORDER BY 
	[Wiek] DESC
	
	
	




