select
	"PostingDate" 
	,"NoItem"
	,"ItemDescription"
	,max(round("AmountLCY"/"Quantity", 2)) as "AmountPLN"
	,max(round("Amount"/"Quantity", 2)) as "Amount"
	,"CurrencyCode" as "OryginalCurrency"
from
	gold.v_bc_posted_sales_invoices
where
	"Quantity" > 0
and
	"PostingDate" >= '2025-04-01' 
and
	"PostingDate" <= '2025-07-31' 
and	
	"Type" = 'Towar'
group by 
	"NoItem"
	,"ItemDescription"
	,"CurrencyCode"
order by
	2, 1