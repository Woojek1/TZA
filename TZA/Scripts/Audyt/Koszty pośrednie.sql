SELECT
	"Posting_Date" as "Data księgowania"
	,"Item_Ledger_Entry_Type" as "Typ zapisu księgi zapasów"
	,"Entry_Type" as "Typ zapisu"
	,"Document_No" as "Nr dokumentu"
	,"Item_Charge_No" as "Nr kosztu dodatkowego"
	,"Description" as "Opis"
	,"Cost_Amount_Expected" as "Kwota kosztu (przewidywana)"
	,"Cost_Amount_Actual" as "Kwota kosztu (rzeczywista)"
	,"Cost_Posted_to_G_L" as "Koszt zaksięgowany w K/G"
	,"Gen_Prod_Posting_Group" as "Gł. tow. grupa księgowa"
	,c."Name" as "Dostawca"
FROM
	bronze.bc_values_entries_zymetric ve
left join
	bronze.bc_vendors_zymetric c
on
	ve."Source_No" = c."No"
where
	"Item_Ledger_Entry_Type" = 'Purchase'
and
	"Posting_Date" BETWEEN '01-04-2024' and '31-05-2024'