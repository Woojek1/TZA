-- Znalezienie symboli urządzen które zawierają baterie
WITH Urzadzenia_z_bateriami AS
(
	SELECT
		"NoItem"
		,"KeyNoItem"
		,"ednBatteryCode"
		,"ednBatteryItem"
		,"ednBatteryQuantity"
	FROM
		gold.v_bc_items
	WHERE
		"ednBatteryQuantity" > 0
),

-- znalezienie regionów do ktorych sprzedawane są urządzenia i nie są eksportowymi
Regiony_w_kraju as
(
	select
		distinct("Shortcut_Dimension_4_Code")
	from
		bronze.bc_items_ledger_entries_aircon
	where
		"Shortcut_Dimension_4_Code" not like '%EXP%'
)

Item_Ledger_entry as 
(
	select
		
	from
		bronze.bc_items_ledger_entries_aircon
)

	