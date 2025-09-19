-- Krok 1a: Zliczamy wszystkie zdarzenia dla każdego klienta
WITH EventCounts AS (
SELECT
	user_id,
	COUNT(event_id) AS total_events
FROM
	gold.v_magento_prod_event_logger
GROUP BY
	user_id
	),
	
-- Krok 1b: Zliczamy zamówienia ze sklepu o statusie 'complete' lub 'processing'
MagentoOrderCounts AS (
SELECT
	customer_id,
	COUNT(entity_id) as magento_orders_count
FROM
	gold.v_magento_prod_sales_order
WHERE
	status IN ('complete', 'processing')
GROUP BY
	customer_id
)
-- Krok 2: Główne zapytanie, które łączy wszystkie przygotowane dane

SELECT
-- bc."NoCustomer",
	bc."VATRegistrationNo" as NIP,
	bc."Name",
	bc."City" as Miasto,
	bc."County" as Wojewodztwo,
	COALESCE(ec.total_events, 0) AS liczbaa_aktywnosci_ecommerce_sierpien25,
	COALESCE(moc.magento_orders_count, 0) AS zamowienia_ecommerce,
	COUNT(DISTINCT o."No_Order") AS Zamowien_ogolem,
	-- COALESCE(moc.magento_orders_count, 0) AS zamowienia_ecommerce,
	--COALESCE(ec.total_events, 0) AS suma_aktywnosci_ecommerce,
	COUNT(DISTINCT CASE WHEN o."Company" = 'Aircon' THEN o."No_Order" END) AS zamowienia_aircon,
	COUNT(DISTINCT CASE WHEN o."Company" = 'Zymetric' THEN o."No_Order" END) AS zamowienia_zymetric,
	COUNT(DISTINCT CASE WHEN o."Company" = 'Technab' THEN o."No_Order" END) AS zamowienia_technab
from
	gold.v_orders o
join
	gold.v_bc_customers bc
ON o."KeyNoCustomer" = bc."KeyNoCustomer"
LEFT join
	EventCounts ec
ON bc."MagentoID" = ec.user_id
-- Dołączamy zliczone zamówienia ze sklepu
LEFT join
	MagentoOrderCounts moc
ON bc."MagentoID" = moc.customer_id
where
	bc."MagentoID" > 0
--	AND o."OrderDate" >= '2025-01-01'
GROUP by
	bc."NoCustomer",
	bc."KeyNoCustomer",
	bc."VATRegistrationNo",
	bc."City",
	bc."County",
	bc."Name",
	ec.total_events,
	moc.magento_orders_count
ORDER BY Zamowien_ogolem desc

