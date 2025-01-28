-- Objetivo da consulta: Processar informações sobre as assinaturas dos clientes

-- Seleciona a base de dados inicial
WITH assinatura_raw AS (
    SELECT 
        s.id AS assinatura_id,
        s.external_id AS store_id,
        s.created_at AS data_criacao,
        s.due_date AS data_expiracao,
        COALESCE(s.plan, 'gratis') AS pacote,
        s.interval AS intervalo_pagamento,
        s.items
    FROM datalake.subscription s
    WHERE due_date >= '2022-07-01' -- Filtro de data
),
-- Expande o array de items 
items_assinatura AS (
    SELECT 
        ar.assinatura_id,
        CAST(item_data->>'name' AS VARCHAR) AS nome_item,
        CAST(item_data->>'quantity' AS INT) AS quantity,
        CAST(item_data->>'price_cents' AS FLOAT) / 100.00 AS preco_item
    FROM assinatura_raw ar,
    LATERAL json_array_elements(items::json) AS item_data
    WHERE CAST(item_data->>'quantity' AS INT) > 0 -- Filtra itens com quantidade maior que 0
),
-- Processa informações das assinaturas
base_assinaturas AS (
    SELECT 
        ar.assinatura_id,
        ar.store_id,
        ar.data_criacao,
        ar.data_expiracao,
        ar.pacote,
        ar.intervalo_pagamento,
        FIRST_VALUE(ar.assinatura_id) OVER (PARTITION BY ar.store_id ORDER BY ar.data_criacao ASC) AS id_primeira_assinatura
    FROM assinatura_raw ar
)
-- Consulta final
SELECT 
    ba.assinatura_id,
    ba.store_id,
    ba.data_criacao,
    ba.data_expiracao,
    ba.pacote,
    ba.intervalo_pagamento,
    ba.id_primeira_assinatura,
    ia.nome_item,
    ia.quantity,
    ia.preco_item,
    ia.quantity * ia.preco_item AS preco_item_total,
    (ia.quantity * ia.preco_item) / COALESCE(ba.intervalo_pagamento, 1) AS preco_item_intervalo_pagamento,
    SUM(ia.quantity * ia.preco_item) OVER (PARTITION BY ba.assinatura_id) AS preco_assinatura_total
FROM base_assinaturas ba
LEFT JOIN items_assinatura ia 
    ON ia.assinatura_id = ba.assinatura_id
