with 
faktury as (
	select
		"Company"
		,"NoInvoice"
		,max("PostingDate") as "Posting_Date"
		,sum("AmountLCY") as "Amount_LCY"
		,sum("AmountIncludingVatLCY") as "Amount_Including_Vat_LCY"
		,max("RemainingAmountLCY") as "Remaining_Amount_LCY"
	from
		gold.v_bc_posted_sales_invoices
	where
		"Company" = 'Aircon'
	group by
		"Company" 
		,"NoInvoice"
),

data_platnosci_ as (
	select
		cle."Document_No"
		,cle."Entry_No"
		,sum(cdl."Amount") as "Remaining_Amount"
		,sum(cdl."Amount_LCY") as "Remaining_Amount_LCY"
		,max(cdl."Posting_Date") as "Payment_Date"
	from 
		bronze.bc_customer_ledger_entries_aircon cle
	inner join
		bronze.bc_customer_detailed_ledger_aircon cdl
	on
		cle."Entry_No" = cdl."Cust_Ledger_Entry_No"
	group by
		cle."Document_No"
		,cle."Entry_No"
)

select
	f.*
	,dp."Remaining_Amount_LCY"
	,case
		when dp."Remaining_Amount_LCY" = 0 then dp."Payment_Date"
		else null
	end as "Payment_Date"
from 
	faktury f
inner join
	data_platnosci dp
on
	f."NoInvoice" = dp."Document_No"