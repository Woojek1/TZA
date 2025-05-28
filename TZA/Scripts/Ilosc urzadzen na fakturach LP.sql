--use BC_DEV_cycle

--numery spółek LP w BC
WITH NumerKlientaLPP as (
	SELECT DISTINCT ([Sell-to Customer No_])
		,[Bill-to Name]
	FROM [Zymetric$Sales Invoice Header$437dbf0e-84ff-417a-965d-ed2bb9650972] as SalesInvoiceHeader
	WHERE SalesInvoiceHeader.[Bill-to Name] like '%LP%'
),


--złączona tabela LP
SELECT *
	FROM 
	    [Zymetric$Sales Invoice Header$437dbf0e-84ff-417a-965d-ed2bb9650972] AS SalesHeader
	INNER JOIN 
	    [Zymetric$Sales Invoice Line$437dbf0e-84ff-417a-965d-ed2bb9650972] AS SaleSInvoiceLine
	    ON SaleSInvoiceLine.[Document No_] = SalesHeader.[No_]
	WHERE SalesHeader.[Bill-to Name] like '%LP%'



	 	
--sumowanie dla sprawdzenia wartości całych faktur
SELECT DISTINCT 
    [SalesHeader].[No_] AS NumerFaktury
    ,[ITI Sales Date$a41facb4-aa1f-4f4b-a6d5-a574d9a33911] AS DataSprzedazy
    ,[SalesHeader].[Bill-to Name] AS NazwaSpolki
    ,[SaleSInvoiceLine].[No_] AS Symbol
    ,[SaleSInvoiceLine].[Description]
    ,[SaleSInvoiceLine].[Description 2]
    ,[SaleSInvoiceLine].[Quantity] AS Ilosc
    ,[SaleSInvoiceLine].[Unit Price] AS Cena
    ,[SaleSInvoiceLine].[Line Discount _]/100 AS Rabat
    ,ROUND([SaleSInvoiceLine].[Quantity] * [SaleSInvoiceLine].[Unit Price] * (1 - [SaleSInvoiceLine].[Line Discount _] / 100),2) AS Wartosc
FROM 
    [Zymetric$Sales Invoice Header$437dbf0e-84ff-417a-965d-ed2bb9650972] AS SalesHeader
INNER JOIN 
    [Zymetric$Sales Invoice Line$437dbf0e-84ff-417a-965d-ed2bb9650972] AS SaleSInvoiceLine
    ON SaleSInvoiceLine.[Document No_] = SalesHeader.[No_]
WHERE 
    SalesHeader.[Bill-to Name] LIKE '%LP%'
    AND SalesHeader.[No_] LIKE '%/24/%'

	 	
	 	
--unikatowe urządzenia na fakturach LP

SELECT DISTINCT 
	[SaleSInvoiceLine].[No_]
	,[SaleSInvoiceLine].[Description]
	,[SaleSInvoiceLine].[Description 2]	
	FROM 
	    [Zymetric$Sales Invoice Header$437dbf0e-84ff-417a-965d-ed2bb9650972] AS SalesHeader
	INNER JOIN 
	    [Zymetric$Sales Invoice Line$437dbf0e-84ff-417a-965d-ed2bb9650972] AS SaleSInvoiceLine
	    ON SaleSInvoiceLine.[Document No_] = SalesHeader.[No_]
	 WHERE [SalesHeader].[Bill-to Name] like '%LP%'
	 	AND [SalesHeader].[No_] like '%/24/%'
	 order by 2
	 
	 

--tabela z urzadzeniami na fakturach dla LP
SELECT DISTINCT 
	[SalesHeader].[No_]
	,[SalesHeader].[Bill-to Name]
	,[SaleSInvoiceLine].[No_]
	,[SaleSInvoiceLine].[Description]
	,[SaleSInvoiceLine].[Description 2]	
	,[SaleSInvoiceLine].[Quantity]
	,[SaleSInvoiceLine].[Unit Price]
	,[SaleSInvoiceLine].[Line Discount _]
	,CASE
		WHEN
		[SaleSInvoiceLine].[Line Discount _] = 0 THEN 1
		ELSE [SaleSInvoiceLine].[Line Discount _]
		END AS [NOWY_RABAT]
	,([SaleSInvoiceLine].[Quantity] * [SaleSInvoiceLine].[Unit Price]*[NOWY_RABAT]) AS Wartosc
	FROM 
	    [Zymetric$Sales Invoice Header$437dbf0e-84ff-417a-965d-ed2bb9650972] AS SalesHeader
	INNER JOIN 
	    [Zymetric$Sales Invoice Line$437dbf0e-84ff-417a-965d-ed2bb9650972] AS SaleSInvoiceLine
	    ON SaleSInvoiceLine.[Document No_] = SalesHeader.[No_]
	 WHERE [SalesHeader].[Bill-to Name] like '%LPP%'
	 	AND [SalesHeader].[No_] like '%/24/%'

  

	    
