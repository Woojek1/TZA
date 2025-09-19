SELECT
"ednCostIncrease"
,"ednOryUnitCost"
,"ednOryUnitCostLCY"
,"unitCost"
,"unitCostLCY"
FROM
	bronze.bc_posted_sales_invoices_lines_aircon
where
	"ednCostIncrease" is not null