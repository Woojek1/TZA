WITH symbole_N...A AS (
	SELECT 
		[No_]
		,[Manufacturer Code]
	FROM [BC_DEV_cycle].dbo.[N...n$Item$437dbf0e-84ff-417a-965d-ed2bb9650972]
	WHERE 
		[Manufacturer Code] = 'N...A'
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
	FROM
		BC_DEV_cycle.dbo.[N...n$Sales Invoice Line$437dbf0e-84ff-417a-965d-ed2bb9650972]
	WHERE
		[Posting Date] BETWEEN '2025-04-01' AND '2025-04-30'
		AND [Location Code] = 'MK.GL'
)


SELECT
	fk.[No_] AS SYMBOL
	,fk.[Document No_] AS [NR FAKTURY]
	,SUM(fk.[Quantity]) AS ILOSC
	,SUM(fk.[Amount]) AS WARTOSC
FROM
	faktury_kwiecien fk 
INNER JOIN
	symbole_NOXA sn
ON fk.[No_] = sn.[No_]
GROUP BY
	fk.[No_]
	,fk.[Document No_]
ORDER BY 1, 2
	