WITH klienci_z_firm AS (
	SELECT
		[VAT Registration No_]
		,[Salesperson Code]
		,'Aircon' AS Firma
	FROM BC_DEV_cycle.dbo.[Aircon$Customer$437dbf0e-84ff-417a-965d-ed2bb9650972]

	UNION ALL

	SELECT
		[VAT Registration No_]
		,[Salesperson Code]
		,'Technab' AS Firma
	FROM BC_DEV_cycle.dbo.[Nabilaton$Customer$437dbf0e-84ff-417a-965d-ed2bb9650972]

	UNION ALL

	SELECT
		[VAT Registration No_]
		,[Salesperson Code]
		,'Zymetric' AS Firma
	FROM BC_DEV_cycle.dbo.[Zymetric$Customer$437dbf0e-84ff-417a-965d-ed2bb9650972]
),

klienci_do_faktur AS (
	SELECT
		[VAT Registration No_]
		,MAX(CASE WHEN Firma = 'Aircon' THEN [Salesperson Code] END) AS [Aircon Salesperson]
		,MAX(CASE WHEN Firma = 'Technab' THEN [Salesperson Code] END) AS [Technab Salesperson]
		,MAX(CASE WHEN Firma = 'Zymetric' THEN [Salesperson Code] END) AS [Zymetric Salesperson]
	FROM
		klienci_z_firm
	GROUP BY
		[VAT Registration No_]
),

faktury_technab AS (
	SELECT
		sih.[No_] AS [Numer faktury]
		,CAST(sih.[Posting Date] AS DATE) AS [Posting Date]
		,sil.[Line No_]
		,sih.[Salesperson Code] AS [Salesperson na fakturze]
		,sih.[VAT Registration No_]
		,sil.[No_] AS [Symbol urzadzenia]
		,sil.[Amount]
		,i.[Manufacturer Code]
	FROM
		BC_DEV_cycle.dbo.[Nabilaton$Sales Invoice Line$437dbf0e-84ff-417a-965d-ed2bb9650972] sil
	INNER JOIN
		BC_DEV_cycle.dbo.[Nabilaton$Sales Invoice Header$437dbf0e-84ff-417a-965d-ed2bb9650972] sih
	ON
		sil.[Document No_] = sih.[No_]
	INNER JOIN
		BC_DEV_cycle.dbo.[Nabilaton$Item$437dbf0e-84ff-417a-965d-ed2bb9650972] i
	ON
		sil.[No_] = i.[No_]
)

SELECT
	ft.*
	,kf.[Aircon Salesperson]
	,kf.[Technab Salesperson]
	,kf.[Zymetric Salesperson]
FROM
	faktury_technab ft
LEFT JOIN
	klienci_do_faktur kf
ON
	ft.[VAT Registration No_] = kf.[VAT Registration No_]
ORDER BY
	[Posting Date] DESC



	
