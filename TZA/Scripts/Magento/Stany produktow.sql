SELECT
    p.entity_id AS id,
    p.sku,
    name.value AS name,
    brand_label.value AS brand,
    '' AS lowest_count_item,
    CAST(SUM(stock.quantity) AS INT) AS quantity,
    'Prosty' AS product_type
FROM
    bronze.magento_prod_catalog_product_entity AS p
JOIN
    bronze.magento_prod_catalog_product_entity_varchar AS name
    ON name.row_id = p.row_id
    AND name.attribute_id = 73  -- product name
    AND name.store_id = 1
JOIN
    bronze.magento_prod_inventory_source_item AS stock
    ON stock.sku = p.sku
LEFT JOIN
    bronze.magento_prod_catalog_product_entity_int AS brand_attr
    ON brand_attr.row_id = p.row_id
    AND brand_attr.attribute_id = 215  -- catalog_brand attribute
    AND brand_attr.store_id = 0
LEFT JOIN
    bronze.magento_prod_eav_attribute_option_value AS brand_label
    ON brand_label.option_id = brand_attr.value
    AND brand_label.store_id = 0
WHERE
    p.type_id = 'simple'
GROUP BY
    p.entity_id,
    p.sku,
    name.value,
    brand_label.value
ORDER BY
    name.value;
    
    
 -----------------------------------------------------------------------------------
    
 SELECT
    id,
    bundle_sku AS sku,
    bundle_name AS name,
    brand,
    child_sku AS lowest_count_item,
    total_quantity AS quantity,
    'Zestaw' AS product_type
FROM (
    SELECT
        bundle.entity_id AS id,
        bundle.sku AS bundle_sku,
        bundle_name.value AS bundle_name,
        brand_option_value.value AS brand,
        child.sku AS child_sku,
        stock_agg.total_quantity,
        ROW_NUMBER() OVER (PARTITION BY bundle.sku ORDER BY stock_agg.total_quantity ASC) AS rn
    FROM
        bronze.magento_prod_catalog_product_entity AS bundle
    JOIN
        bronze.magento_prod_catalog_product_bundle_option AS option ON option.parent_id = bundle.entity_id
    JOIN
        bronze.magento_prod_catalog_product_bundle_selection AS sel ON sel.option_id = option.option_id
    JOIN
        bronze.magento_prod_catalog_product_entity AS child ON child.entity_id = sel.product_id
    JOIN (
        SELECT
            sku,
            CAST(SUM(quantity) AS INT) AS total_quantity
        FROM
            bronze.magento_prod_inventory_source_item
        GROUP BY
            sku
    ) AS stock_agg ON stock_agg.sku = child.sku
    JOIN
        bronze.magento_prod_catalog_product_entity_varchar AS bundle_name ON bundle_name.row_id = bundle.row_id
            AND bundle_name.attribute_id = 73  -- name
            AND bundle_name.store_id = 1
    LEFT JOIN
        bronze.magento_prod_catalog_product_entity_int AS brand_attr ON brand_attr.row_id = bundle.row_id
            AND brand_attr.attribute_id = 215  -- catalog_brand
            AND brand_attr.store_id = 0
    LEFT JOIN
        bronze.magento_prod_eav_attribute_option_value AS brand_option_value ON brand_option_value.option_id = brand_attr.value
            AND brand_option_value.store_id = 0
    WHERE
        bundle.type_id = 'bundle'
) AS sub
WHERE rn = 1   
