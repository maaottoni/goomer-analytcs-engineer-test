Quantos reais tivemos em Faturas geradas em julho/2022 que estão aguardando o pagamento?
E quantos reais tivemos em Faturas expiradas em julho/2022?
Quantos reais tivemos de Faturas pagas por mês de Assinaturas por produto?
E quanto tivemos de Receita mensal de Taxa de Implementação e Projetos?
Quantas Assinaturas canceladas temos por mês?

Para responder as perguntas listadas no enunciado ao menos duas tabelas seriam necessárias:

1 - Tabela faturas
Tabela contendo informações sobre as faturas geradas, suas respectivas datas de emissão, de vencimento, de pagamento, valor total da fatura, status da fatura (aguardando_pagamento, pago, expirado, cancelada, etc), produto.


```mermaid
erDiagram
    FATURAS {
        int fatura_id PK
        int assinatura_id FK
        date data_emissao
        date data_vencimento
        date data_pagamento
        float valor_total
        string status
        string tipo_receita
        string produto
    }


2 - Tabela assinaturas
Tabela contendo informações sobre as assinaturas dos clientes com suas respectivas datas de início, de cancelamento, valor da assinatura mensal, status da assinatura (ativa, cancelada, etc), produto associado.

```mermaid
erDiagram
    ASSINATURAS {
        int assinatura_id PK
        int cliente_id FK
        date data_inicio
        date data_cancelamento
        string status_assinatura
        string produto
        float valor_assinatura_mensal
    }

## Relacionamento entre as tabelas:

```mermaid
erDiagram
    FATURAS {
        int fatura_id PK
        int assinatura_id FK
        date data_emissao
        date data_vencimento
        date data_pagamento
        float valor_total
        string status
        string tipo_receita
        string produto
    }

    ASSINATURAS {
        int assinatura_id PK
        int cliente_id FK
        date data_inicio
        date data_cancelamento
        string status_assinatura
        string produto
        float valor_assinatura_mensal
    }

    ASSINATURAS ||--o{ FATURAS : "gera"
