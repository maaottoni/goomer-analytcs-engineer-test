with assinatura_raw as (select id as assinatura_id, external_id as store_id, created_at as data_criacao, due_date as data_expiracao, plan as pacote, interval as intervalo_pagamento, items
from datalake.subscription a ),
items_assinatura as (select distinct assinatura_id, cast(json_array_elements_text(items::json)::json->>'name' as varchar) as nome_item, cast(json_array_elements_text(items::json)::json->>'quantity' as int )as quantity, cast(json_array_elements_text(items::json)::json->>'price_cents' as float ) / 100.00 as preco_item
from assinatura_raw),
base_assinaturas as (select assinatura_id, store_id, data_criacao, data_expiracao, case when pacote is null then 'gratis' else pacote end as pacote, intervalo_pagamento, first_value(assinatura_id) over (partition by store_id order by data_criacao asc) id_primeira_assinatura
from assinatura_raw
where data_expiracao >= '2022-07-01')
select ba.assinatura_id, ba.store_id, ba.data_criacao, ba.data_expiracao, ba.pacote, ba.intervalo_pagamento, ba.id_primeira_assinatura, ia.nome_item, ia.quantity, ia.preco_item, ia.quantity * ia.preco_item as preco_item_total, (ia.quantity * ia.preco_item) / coalesce(intervalo_pagamento, 1) as preco_item_intervalo_pagamento, sum(ia.quantity * ia.preco_item) over (partition by ba.assinatura_id) as preco_assinatura_total
from base_assinaturas ba left join items_assinatura ia on ia.assinatura_id = ba.assinatura_id
where ia.quantity > 0;