with
mitsu_items_aircon as
	(
	select
		"No_"
		,"Manufacturer Code"
	from
		bronze.nav_items_aircon
	where
		"Manufacturer Code" = 'MITSU'
	),
	
mitsu_items_technab as
	(
	select
		"No_"
		,"Manufacturer Code"
	from
		bronze.nav_items_technab
	where
		"Manufacturer Code" = 'MITSU'
	),
	
mitsu_items_zymetric as
	(
	select
		"no_" as "No_"
		,"Manufacturer Code"
	from
		bronze.nav_items_zymetric
	where
		"Manufacturer Code" = 'MITSU'
	),

mitsu_all_items as
	(
	select
		"No_"
	from
		"mitsu_items_technab"
	union
	select
		"No_"
	from
		"mitsu_items_zymetric"
	),

invoices_technab as
	(
	select
		sil."No_"
		,sil."Sell-to Customer No_"
		,c."Name"
		,c."VAT Registration No_"
	from
		bronze.nav_posted_sales_invoices_lines_technab sil
	inner join
		bronze.nav_customers_technab c
	on 
		sil."Sell-to Customer No_" = c."No_"
	),
	
invoices_zymetric as
	(
	select
		sil."No_"
		,sil."Sell-to Customer No_"
		,c."Name"
		,c."VAT Registration No_"
	from
		bronze.nav_posted_sales_invoices_lines_zymetric sil
	inner join
		bronze.nav_customers_zymetric c
	on 
		sil."Sell-to Customer No_" = c."No_"
	),
	
invoices_all as 
	(
	select *
	from 
		invoices_technab
	union all
	select *
	from
		invoices_zymetric
	),

customers_bought_mitsu as
	(
	select
		max("Name") as "Customer_Name"
		,max("Sell-to Customer No_") as "Customer_No"
		,"VAT Registration No_"
	from 
		invoices_all inv
	inner join
		mitsu_all_items ite
	on inv."No_" = ite."No_"
	group by 
		"VAT Registration No_"
	order by 1
	)