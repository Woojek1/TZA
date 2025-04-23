---CZESC DO PRZYPISANIA DAT NA BILANSIE OTWARCIA W BC------------------
----

;WITH Podstawowa_iae_BC AS(
	SELECT 
		ile.[Item No_]
		,ile.[Remaining Quantity] 		-- odnosi się do kolumny z Item Ledger Entry pokazuje pozostałą ilość urządzen z konkretnego przyjecia
		,ile.[Serial No_]
	    ,iae.[Item Ledger Entry No_] 
	    ,iae.[Inbound Item Entry No_]
--	    ,iae.[Outbound Item Entry No_]
	    ,iae.[Quantity]					-- odnosi się do ilości urządze we wpisie w Item Application Entry
	    ,CAST(iae.[Posting Date] AS DATE) AS [Posting Date]
	FROM 
	    Wiekowanie.dbo.[Nabilaton$Item Application Entry$437dbf0e-84ff-417a-965d-ed2bb9650972] iae
	LEFT JOIN 
	    Wiekowanie.dbo.[Nabilaton$Item Ledger Entry$437dbf0e-84ff-417a-965d-ed2bb9650972] ile
	ON iae.[Item Ledger Entry No_] = ile.[Entry No_]
	WHERE 
		iae.[Posting Date] <= '2025-03-31'
	AND
		ile.[Serial No_] = ''
),

Urzadzenia_z_NAV_poprz_data AS (
	SELECT
		[Item No_] 
		,[Remaining Quantity]
		,MIN(CAST([Posting Date] AS DATE)) AS [Posting Date]
	FROM
		Wiekowanie.dbo.[Nabilaton_Sp_zoo$Item Ledger Entry]
	WHERE 
		[Remaining Quantity] > 0
	GROUP BY [Item No_], [Remaining Quantity]
),

BO_z_BC_daty_NAV AS (
	SELECT Podstawowa_iae_BC.*
		,Urzadzenia_z_NAV_poprz_data.[Posting Date] as [Posting Date z NAV]
	FROM
		Podstawowa_iae_BC
	LEFT JOIN Urzadzenia_z_NAV_poprz_data
	ON 
	Podstawowa_iae_BC.[Item No_] = Urzadzenia_z_NAV_poprz_data.[Item No_]
	AND 	
		Podstawowa_iae_BC.[Quantity] = Urzadzenia_z_NAV_poprz_data.[Remaining Quantity]
	AND 
		Podstawowa_iae_BC.[Posting Date] = '2024-04-01'		-- warunek żeby szukać odpowiadającyhc ilości tylko dla urzadzen przyjetych do BC na otwarciu
),

iae_starsze_daty AS (
	SELECT 
		[Item No_]
--		,[Remaining Quantity]
		,[Serial No_]
		,[Item Ledger Entry No_]
		,[Inbound Item Entry No_]
--		,[Outbound Item Entry No_]
		,[Quantity]
--		,[Transferred-from Entry No_]
		,COALESCE ([Posting Date z NAV], [Posting Date]) AS [Starsza data]
	FROM
		BO_z_BC_daty_NAV
)


SELECT
	MIN([Item No_]) AS [Item No_]
	,MIN([Inbound Item Entry No_]) AS [Inbound Item Entry No_]
	,SUM([Quantity]) AS  [TotalQuantity]
	,MIN([Starsza data]) AS [Wczesniejsza data]
FROM
	iae_starsze_daty
GROUP BY
	[Inbound Item Entry No_]
HAVING
	SUM([Quantity]) > 0
order by 1


-- Z ostatniego selecta stworzona jest tabela "rep_fifo_na_stanie_Nabilaton"


SELECT 
	[Item No_]
	,MIN([Wczesniejsza data]) AS [Wczesniejsza data]
	,SUM([TotalQuantity]) AS [Ilosc na stanie]
FROM
	Wiekowanie.dbo.[rep_fifo_na_stanie_Nabilaton]
GROUP BY
	[Item No_]
	,[Wczesniejsza data]
	
-- Z tego selecta tworzona jest tabela "rep_fifo_agregacja_ilosci_na_stanie_Nabilaton"
	
-- ------ -------- ------------
	

DECLARE @DataAnalizy DATE;
SET @DataAnalizy = '2025-03-31'

;WITH Koszt_Urzadzen AS (
	SELECT
		[No_]
		,[Description]
		,[Description 2]
		,[Unit Cost]
	FROM
		[Wiekowanie].dbo.[Nabilaton$Item$437dbf0e-84ff-417a-965d-ed2bb9650972]
),

Numer_seryjny_z_wiekiem AS (

SELECT 
	BC.[Item No_]
	,BC.[Ilosc na stanie]
	,CASE 
		WHEN DATEDIFF(DAY, [Wczesniejsza data], @DataAnalizy) > 2555 THEN 'Powyzej 7 lat'
		WHEN DATEDIFF(DAY, [Wczesniejsza data], @DataAnalizy) > 1825 THEN '5-7 lat'
		WHEN DATEDIFF(DAY, [Wczesniejsza data], @DataAnalizy) > 1095 THEN '3-5 lat'
		WHEN DATEDIFF(DAY, [Wczesniejsza data], @DataAnalizy) > 730 THEN '2-3 lat'
		WHEN DATEDIFF(DAY, [Wczesniejsza data], @DataAnalizy) > 365 THEN '1-2 lat'
		ELSE '0-1'
	END AS [WIEK_URZADZEN]
FROM 
	[Wiekowanie].dbo.[rep_fifo_agregacja_ilosci_na_stanie_Nabilaton] AS BC

)

SELECT
    Numer_seryjny_z_wiekiem.[Item No_]
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

-- Z tego selecta tworzona jest tabela "rep_FIFO_Nabilaton"

-- Jako Raport koncowy tworzony jest widok z tabel "rep_FIFO_..." i "rep_SER_..."

CREATE VIEW dbo.rep_Aircon AS

Select *
From rep_SER_Aircon

union all

Select *
From rep_FIFO_Aircon


--- Widok do eksportu 
SELECT *
FROM Wiekowanie.dbo.rep_Nabilaton




















