select *
from
	gold.v_bc_posted_sales_invoices vbpsi
where
--	"Salesperson" in ('JGLOWACKA', 'JDUTKIEWIC', 'ASZYDLOWSKI', 'MDRAG')
--AND 
EXTRACT(MONTH FROM "PostingDate") in (6)
AND EXTRACT(YEAR FROM "PostingDate") = 2025