
# Modelagem de tabealas

Para responder as perguntas listadas no enunciado ao menos duas tabelas seriam necessárias:

<b> 1 - Tabela faturas </b>
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
```

<b>2 - Tabela assinaturas</b>
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
```

<b>Relacionamento entre as tabelas:</b>

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
```

### Respondendo as perguntas com as tabelas

<b>Quantos reais tivemos em Faturas geradas em julho/2022 que estão aguardando o pagamento?</b>

```sql
SELECT 
    SUM(valor_total) AS total_aguardando
FROM 
    faturas
WHERE 
    DATE_TRUNC(data_emissao, MONTH) = '2022-07-01'
    AND status = 'aguardando_pagamento'
```