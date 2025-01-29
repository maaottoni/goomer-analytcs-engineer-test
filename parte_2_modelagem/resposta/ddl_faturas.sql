CREATE TABLE `total-vertex-449213-i7.goomer.faturas` (
    fatura_id INT64 NOT NULL, -- Chave primária
    assinatura_id INT64 NOT NULL, -- Chave estrangeira para a tabela ASSINATURAS
    data_emissao DATE NOT NULL, -- Data de emissão da fatura
    data_vencimento DATE NOT NULL, -- Data de vencimento da fatura
    data_pagamento DATE, -- Data de pagamento (NULLABLE caso ainda não tenha sido pago)
    valor_total FLOAT64 NOT NULL, -- Valor total da fatura
    status STRING NOT NULL, -- Status da fatura (ex.: 'pago', 'pendente', 'expirado')
    tipo_receita STRING NOT NULL, -- Tipo de receita (ex.: 'assinatura', 'projeto', etc.)
    produto STRING -- Produto relacionado (pode ser NULLABLE caso não se aplique)
)
OPTIONS(
    description = "Tabela de faturas relacionadas a assinaturas com informações financeiras e status"
);