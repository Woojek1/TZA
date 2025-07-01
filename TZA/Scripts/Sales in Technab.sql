select
	"NoInvoice"
	,"NoOrder"
	,"PostingDate"
	,"CustomerName"
	,"AmountLCY"
	,"NoItem"
	,"ItemDescription"
	,"LineCostsLCY"
	,"ProfitLCY"	
FROM
	gold.v_bc_posted_sales_invoices
where
	"NoOrder" like '%ECM%'
and 
	"PostingDate" >= '2025-04-01'
order by 2