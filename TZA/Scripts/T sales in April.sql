WITH symbole_NOXA AS (
	SELECT 
		[No_]
		,[Manufacturer Code]
	FROM [BC_DEV_cycle].dbo.[Nabilaton$Item$437dbf0e-84ff-417a-965d-ed2bb9650972]
	WHERE 
		[Manufacturer Code] = 'NOXA'
),

faktury_kwiecien AS (
	SELECT
		[Document No_]
		,[No_]
		,[Quantity]
		,[Amount]
		,[Location Code]
		,[Posting Date]
		,[Type]
		,[Sell-to Customer No_]
	FROM
		BC_DEV_cycle.dbo.[Nabilaton$Sales Invoice Line$437dbf0e-84ff-417a-965d-ed2bb9650972]
	WHERE
		[Posting Date] BETWEEN '2025-04-01' AND '2025-04-30'
		AND [Location Code] = 'MK.GL'
),

klient AS (
	SELECT
		[No_]
		,[Name]
	FROM
		BC_DEV_cycle.dbo.[Nabilaton$Customer$437dbf0e-84ff-417a-965d-ed2bb9650972]
)

SELECT
	fk.[No_] AS SYMBOL
	,fk.[Document No_] AS [NR FAKTURY]
	,MIN(k.[Name]) AS [KLIENT]
	,SUM(fk.[Quantity]) AS ILOSC
	,SUM(fk.[Amount]) AS WARTOSC
FROM
	faktury_kwiecien fk 
INNER JOIN
	symbole_NOXA sn
ON fk.[No_] = sn.[No_]
INNER JOIN
	klient AS k
ON fk.[Sell-to Customer No_] = k.[No_]
GROUP BY
	fk.[No_]
	,fk.[Document No_]
ORDER BY 1, 2
	