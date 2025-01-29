CREATE TABLE `total-vertex-449213-i7.goomer.assinaturas` (
    assinatura_id INT64 NOT NULL, -- Chave primária da tabela
    cliente_id INT64 NOT NULL, -- Chave estrangeira para a tabela CLIENTES
    data_inicio DATE NOT NULL, -- Data de início da assinatura
    data_cancelamento DATE, -- Data de cancelamento da assinatura (NULLABLE se não foi cancelada)
    status_assinatura STRING NOT NULL, -- Status da assinatura (ex.: 'ativa', 'cancelada')
    produto STRING NOT NULL, -- Produto relacionado à assinatura (ex.: 'Plano Premium', 'Plano Pro')
    valor_assinatura_mensal FLOAT64 NOT NULL -- Valor mensal da assinatura
)
OPTIONS(
    description = "Tabela de assinaturas, contendo informações de clientes, status, e valores relacionados"
);
