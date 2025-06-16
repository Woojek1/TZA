with Technab_Customer as (
	select 
		"VAT_Registration_No"
		,"MagentoID"
	from
		bronze.bc_customers_technab
	where
		"MagentoID" > 0
	and "VAT_Registration_No" <> ''
),

Technab_Invoices_Online as (
	select
		sih."VAT_Registration_No" 
		,sum(sil."lineAmount") as "TechnabZakupOnline"
		,count(distinct(sih."No")) as "TechnabIloscZakupowOnline"
	from
		bronze.bc_posted_sales_invoices_header_technab sih
	inner join
		bronze.bc_posted_sales_invoices_lines_technab sil
	on sih."No" = sil."documentNo"
	where 
		sih."Posting_Date" > '2025-03-01'
	and 
		"Order_No" like '%ECM%'
	group by
		sih."VAT_Registration_No"
	order by 
		2, 1
),

Technab_Invoices as (
	select 
		sih."VAT_Registration_No"
		,sum(sil."lineAmount") as "TechnabZakupOffline"
		,count(distinct(sih."No")) as "TechnabIloscZakupowOffline"
	from
		bronze.bc_posted_sales_invoices_header_technab sih
	inner join
		bronze.bc_posted_sales_invoices_lines_technab sil
	on sih."No" = sil."documentNo"
	where 
		sih."Posting_Date" > '2025-03-01'
	and 
		"Order_No" not like '%ECM%'
	group by
	
		sih."VAT_Registration_No"
	order by 
		2, 1
),

Aircon_Invoices as (
	select
		sih."VAT_Registration_No"
		,sum(sil."lineAmount") as "AirconZakupOffline"
		,count(distinct(sih."No")) as "AirconIloscZakupowOffline"
	from
		bronze.bc_posted_sales_invoices_header_aircon sih
	inner join
		bronze.bc_posted_sales_invoices_lines_aircon sil
	on sih."No" = sil."documentNo"
	where 
		sih."Posting_Date" > '2025-03-01'
	and 
		"Order_No" not like '%ECM%'
	group by
		sih."VAT_Registration_No"
	order by 
		2, 1
),

Zymetric_Invoices as (
	select
		sih."VAT_Registration_No"
		,sum(sil."lineAmount") as "ZymetricZakupOffline"
		,count(distinct(sih."No")) as "ZymetricIloscZakupowOffline"
	from
		bronze.bc_posted_sales_invoices_header_zymetric sih
	inner join
		bronze.bc_posted_sales_invoices_lines_zymetric sil
	on sih."No" = sil."documentNo"
	where 
		sih."Posting_Date" > '2025-03-01'
	and 
		"Order_No" not like '%ECM%'
	group by
		sih."VAT_Registration_No"
	order by 
		2, 1
)

select
	tc.*
	,tio."TechnabZakupOnline"
	,tio."TechnabIloscZakupowOnline"	
	,ti."TechnabZakupOffline"
	,ti."TechnabIloscZakupowOffline"
	,ai."AirconZakupOffline"
	,ai."AirconIloscZakupowOffline"
	,zi."ZymetricZakupOffline"	
	,zi."ZymetricIloscZakupowOffline"
from
	Technab_Customer tc
left join 
	Technab_Invoices_Online	tio
on tc."VAT_Registration_No" = tio."VAT_Registration_No"
left join 
	Technab_Invoices ti
on tc."VAT_Registration_No" = ti."VAT_Registration_No"
left join
	Aircon_Invoices ai
on tc."VAT_Registration_No" = ai."VAT_Registration_No"	
left join
	Zymetric_Invoices zi
on tc."VAT_Registration_No" = zi."VAT_Registration_No"	
order by "TechnabZakupOnline" asc

	



select
	"No"
from
	bronze.bc_sales_orders_header_technab
where
	"Order_Source" = 'MAGENTO'


	
	
select ti.*
from
	Technab_Invoices ti
inner join
	Technab_Customer tc
on ti."VAT_Registration_No" = tc."VAT_Registration_No"
order by 2

	