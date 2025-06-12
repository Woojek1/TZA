with Technab_Customer as (
	select 
		"VAT_Registration_No"
		,"EDN_Invoice_Email_Address"
		,"Phone_No"
		,"MagentoID"
	from
		bronze.bc_customers_technab
	where
		"MagentoID" > 0
	and "VAT_Registration_No" <> ''
),

Technab_Invoices as (
	select
		sih."No"
		,sih."VAT_Registration_No"
		,sum(sil."lineAmount")
		,max(sih."Posting_Date")
	from
		bronze.bc_posted_sales_invoices_header_technab sih
	inner join
		bronze.bc_posted_sales_invoices_lines_technab sil
	on sih."No" = sil."documentNo"
	where 
		sih."Posting_Date" > '2025-03-01'
	and sih."ITI_Posting_Description" like '/ECM/'
	group by
		sih."No"
		,sih."VAT_Registration_No"
	order by 
		2, 1, 4
)

select ti.*
from
	Technab_Invoices ti
inner join
	Technab_Customer tc
on ti."VAT_Registration_No" = tc."VAT_Registration_No"
order by 2

	