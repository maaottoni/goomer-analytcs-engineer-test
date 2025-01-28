WITH raw_mrr AS (
    SELECT 
        t.establishment_id,
        DATE(t.event_month) AS event_month,
        t.product,
        t.accumulated_mrr,
    FROM `total-vertex-449213-i7.goomer.mrr` t
),
mrr_intervalos AS (
    SELECT
        b.establishment_id,
        b.event_month,
        b.product,
        b.accumulated_mrr,
        LEAD(b.event_month) OVER (PARTITION BY b.establishment_id, b.product ORDER BY b.event_month) AS proximo_mes
    FROM raw_mrr b
),
mrr_meses_faltantes AS (
    SELECT 
        mi.establishment_id,
        DATE_ADD(mi.event_month, INTERVAL n MONTH) AS event_month,
        mi.product,
        mi.accumulated_mrr,
    FROM mrr_intervalos mi, 
    UNNEST(GENERATE_ARRAY(1, TIMESTAMP_DIFF(mi.proximo_mes, mi.event_month, MONTH) - 1)) AS n
    WHERE mi.proximo_mes IS NOT NULL
), 
mrr_meses_nivelados AS (
    SELECT * FROM mrr_meses_faltantes
    UNION ALL
    SELECT * FROM raw_mrr
), 
mrr_sum_per_product AS ( 
    SELECT 
        mn.establishment_id, 
        mn.product,
        SUM(mn.accumulated_mrr) OVER (PARTITION BY mn.establishment_id, mn.product) AS mrr_per_product
    FROM mrr_meses_nivelados mn
),
base_mrr AS (
    SELECT * FROM mrr_sum_per_product
    GROUP BY 1, 2, 3
),
raw_invoices AS (
    SELECT 
        ti.establishment_id,
        ti.product_code AS product,
        ti.invoice_expired_dt,
        ti.paid,
        SUM(paid) OVER (PARTITION BY ti.establishment_id, ti.product_code) AS invoice_per_product
    FROM `total-vertex-449213-i7.goomer.invoices` ti
), 
base_invoices AS (
    SELECT 
        bi.establishment_id, 
        bi.product,
        bi.invoice_per_product
    FROM raw_invoices bi
    GROUP BY 1, 2, 3
    ORDER BY establishment_id, product
), 
base_analise AS (
    SELECT 
        mrr.establishment_id,
        mrr.product,
        mrr.mrr_per_product,
        inv.invoice_per_product
    FROM base_mrr mrr 
    LEFT JOIN base_invoices inv
        ON mrr.establishment_id = inv.establishment_id 
        AND mrr.product = inv.product 
) 
SELECT 
    ba.establishment_id,
    ba.product, 
    ba.mrr_per_product,
    ba.invoice_per_product,
    CASE 
        WHEN ba.mrr_per_product IS NOT NULL AND ba.invoice_per_product IS NULL THEN 'total_discount'
        WHEN ba.mrr_per_product > ba.invoice_per_product THEN 'partially_discount'
        WHEN 2 * ba.mrr_per_product = ba.invoice_per_product THEN 'duplicate'
        WHEN ba.mrr_per_product < ba.invoice_per_product THEN 'overpaid'
    END AS payment_status
FROM base_analise ba
WHERE COALESCE(mrr_per_product, 1) <> COALESCE(invoice_per_product, 1);
