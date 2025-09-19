with item_on_stack as (

select 
	"Posting_Date"
	,"Item_No"
	,"Entry_Type"
	,"Quantity"
	,"Remaining_Quantity"
	,"Cost_Amount_Expected"
	,"Cost_Amount_Actual"
	,"Completely_Invoiced"
from
	silver.bc_items_ledger_entries_aircon
where
	"Entry_Type" = 'Purchase'
and
	"Remaining_Quantity" <> 0
),


WITH base AS (
    SELECT
        "Item_No",
        ("Cost_Amount_Actual" / NULLIF("Quantity",0))::numeric AS unit_price
    FROM silver.bc_items_ledger_entries_aircon
    WHERE "Entry_Type" = 'Purchase'
      AND "Remaining_Quantity" <> 0
      AND "Quantity" <> 0
      AND "Posting_Date" >= (current_date - interval '12 months')
),
stats AS (
    SELECT 
        "Item_No",
        percentile_cont(0.25) WITHIN GROUP (ORDER BY unit_price) AS q1,
        percentile_cont(0.75) WITHIN GROUP (ORDER BY unit_price) AS q3
    FROM base
    GROUP BY "Item_No"
),
limits AS (
    SELECT 
        "Item_No",
        q1,
        q3,
        (q1 - 1.5 * (q3 - q1)) AS low_whisker,
        (q3 + 1.5 * (q3 - q1)) AS high_whisker
    FROM stats
),
filtered AS (
    SELECT b."Item_No", b.unit_price
    FROM base b
    JOIN limits l ON b."Item_No" = l."Item_No"
    WHERE b.unit_price BETWEEN l.low_whisker AND l.high_whisker
)
SELECT 
    "Item_No",
    avg(unit_price) AS mean_price,
    percentile_cont(0.5) WITHIN GROUP (ORDER BY unit_price) AS median_price
FROM filtered
GROUP BY "Item_No";

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------


WITH base AS (
    SELECT
        "Item_No",
        ("Cost_Amount_Actual" / NULLIF("Quantity",0))::numeric AS unit_price,
        "Posting_Date"
    FROM silver.bc_items_ledger_entries_aircon
    WHERE "Entry_Type" = 'Purchase'
      AND "Remaining_Quantity" <> 0
      AND "Quantity" <> 0
),
stats AS (
    SELECT 
        "Item_No",
        percentile_cont(0.25) WITHIN GROUP (ORDER BY unit_price) AS q1,
        percentile_cont(0.75) WITHIN GROUP (ORDER BY unit_price) AS q3
    FROM base
    WHERE "Posting_Date" >= (current_date - interval '12 months')
    GROUP BY "Item_No"

    
  ),
limits AS (
    SELECT 
        "Item_No",
        q1,
        q3,
        (q1 - 1.5 * (q3 - q1)) AS low_whisker,
        (q3 + 1.5 * (q3 - q1)) AS high_whisker
    FROM stats
),
filtered AS (
    SELECT b."Item_No", b.unit_price
    FROM base b
    JOIN limits l ON b."Item_No" = l."Item_No"
    WHERE b."Posting_Date" >= (current_date - interval '12 months')
      AND b.unit_price BETWEEN l.low_whisker AND l.high_whisker
)
SELECT 
    b."Item_No",
    -- średnia ze wszystkich wpisów (globalna)
    avg(b.unit_price) AS mean_all,
    -- średnia i mediana z ostatnich 12 miesięcy po odrzuceniu outlierów
    avg(f.unit_price) AS mean_last_12m,
    percentile_cont(0.5) WITHIN GROUP (ORDER BY f.unit_price) AS median_last_12m
FROM base b
LEFT JOIN filtered f ON b."Item_No" = f."Item_No"
GROUP BY b."Item_No";

