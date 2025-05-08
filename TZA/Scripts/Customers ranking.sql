WITH Sprzedaz AS (
	SELECT
		[Document No_]
		,MAX([Sell-to Customer No_]) as Nabywca
		,SUM([Line Amount]) as Wartosc
		,MAX(cast([Posting Date] as DATE)) AS [Posting Date]
FROM BC_DEV_cycle.dbo.[Zymetric$Sales Invoice Line$437dbf0e-84ff-417a-965d-ed2bb9650972]
GROUP BY [Document No_]),

Nabywca as (
SELECT
	[No_]
	,[Name]
FROM BC_DEV_cycle.dbo.[Zymetric$Customer$437dbf0e-84ff-417a-965d-ed2bb9650972]
)

SELECT
	DENSE_RANK() OVER(ORDER BY SUM(s.Wartosc) DESC) as Ranking
	,s.Nabywca
	,MAX(n.Name) AS Nabywca
	,SUM(s.Wartosc) AS [Wartosc sprzedazy]
FROM Sprzedaz s
INNER JOIN
	Nabywca n
ON s.[Nabywca] = n.[No_]
GROUP BY
	s.Nabywca