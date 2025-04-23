WITH invoices_lines AS (
	SELECT 
		[Document No_]
		,[Sell-to Customer No_]	
		,[Line No_]
		,[Description]
		,[Quantity]
		,[Unit Price]
		,[Unit Cost (LCY)]
		,[Amount]
	FROM
		BC_DEV_cycle.dbo.[Zymetric$Sales Invoice Line$437dbf0e-84ff-417a-965d-ed2bb9650972]
	WHERE
		[Posting Group] = 'TOWARY'
),

invoices_headers AS (
	SELECT 
		[No_]
		,[Sell-to Customer No_]
		,[Bill-to Name]
		,[Customer Posting Group]
		,[Currency Factor]
		,[Salesperson Code]
		,[Posting date]
	FROM
		BC_DEV_cycle.dbo.[Zymetric$Sales Invoice Header$437dbf0e-84ff-417a-965d-ed2bb9650972]
)

--ft AS(
SELECT
	ih.[Salesperson Code]
	,ih.[Bill-to Name]
	,ih.[No_]	
	,ih.[Customer Posting Group]
	,CAST(ih.[Posting date] AS DATE) AS [Posting date]
	,il.[Line No_]
	,il.[Description]
	,il.[Quantity]
	,il.[Unit Price]
	,il.[Unit Cost (LCY)]
	,il.[Amount]
	,ih.[Currency Factor]
	,[Unit Cost (LCY)] * [Quantity] AS [Cost (LCY)]
	,[Amount]/[Currency Factor] AS [Amount (LCY)]
	,(([Amount]/[Currency Factor]) - ([Unit Cost (LCY)] * [Quantity])) / ([Amount]/[Currency Factor]) * 100 AS [Margin]	
FROM
	invoices_lines AS il
INNER JOIN
	invoices_headers AS ih
ON il.[Document No_] = ih.[No_]
WHERE 
	ih.[Salesperson Code] IN ('JDUTKIEWIC', 'LGLADYSZ', 'ASZYDLOWSKI', 'JGLOWACKA')								
AND
	il.[Quantity] <> 0
AND
	ih.[Posting Date] BETWEEN '2024-04-01' AND '2025-03-31'
ORDER BY
	ih.[Salesperson Code]
	,ih.[Bill-to Name]
	,ih.[Posting date]
	,[No_]
	