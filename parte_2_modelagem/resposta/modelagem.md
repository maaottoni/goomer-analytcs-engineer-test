
# Modelagem de tabealas

Para responder as perguntas listadas no enunciado ao menos duas tabelas seriam necessárias:

<b> 1 - Tabela faturas </b>
<br>Tabela contendo informações sobre as faturas geradas, suas respectivas datas de emissão, de vencimento, de pagamento, valor total da fatura, status da fatura (aguardando_pagamento, pago, expirado, cancelada, etc), produto.


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

> 💡 Confira [aqui](https://github.com/maaottoni/goomer-analytcs-engineer-test/blob/main/parte_2_modelagem/resposta/faturas.csv) um exemplo da tabela `faturas` populada com alguns dados ficticios.  


<b> 2 - Tabela assinaturas</b>
<br>Tabela contendo informações sobre as assinaturas dos clientes com suas respectivas datas de início, de cancelamento, valor da assinatura mensal, status da assinatura (ativa, cancelada, etc), produto associado.

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
> 💡 Confira [aqui](https://github.com/maaottoni/goomer-analytcs-engineer-test/blob/main/parte_2_modelagem/resposta/assinaturas.csv) um exemplo da tabela `assinaturas` populada com alguns dados ficticios.

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

A seguir alguns exemplos de como responder as perguntas realizadas com as tabelas sugeridas:

<b> 1 - Quantos reais tivemos em Faturas geradas em julho/2022 que estão aguardando o pagamento?</b>

```sql
SELECT 
    SUM(valor_total) AS total_aguardando
FROM 
    faturas
WHERE 
    DATE_TRUNC(data_emissao, MONTH) = '2022-07-01'
    AND status = 'aguardando_pagamento'
```


<b>2 - Quantos reais tivemos em Faturas expiradas em julho/2022?</b>

```sql
SELECT 
    SUM(valor_total) AS total_expirado
FROM 
    faturas
WHERE 
    DATE_TRUNC(data_vencimento, MONTH) = '2022-07-01'
    AND status = 'expirado';
```

<b> 3 - Quantos reais tivemos de Faturas pagas por mês de Assinaturas por produto?</b>

```sql
WITH base as (
    SELECT 
    DATE_TRUNC(data_pagamento, MONTH) AS mes,
    produto,
    SUM(valor_total) over (partition by DATE_TRUNC(data_pagamento, MONTH), produto) AS total_pago
FROM 
    faturas
WHERE 
    tipo_receita = 'assinatura'
    AND status = 'pago'
) SELECT * FROM base group by mes, produto, total_pago;
```

<b> 4 - Quanto tivemos de Receita mensal de Taxa de Implementação e Projetos?</b>

```sql
WITH base as (
    SELECT 
    DATE_TRUNC(data_pagamento, MONTH) AS mes,
    tipo_receita,
    SUM(valor_total) over (partition by DATE_TRUNC(data_pagamento, MONTH), tipo_receita) AS total_receita
FROM 
    faturas
WHERE 
    tipo_receita IN ('taxa_implementacao', 'projeto')
    AND status = 'pago'
) SELECT * FROM base GROUP BY mes, tipo_receita, total_receita
```

<b> 5 - Quantas Assinaturas canceladas temos por mês? </b>

```sql
SELECT 
    DATE_TRUNC(data_cancelamento, MONTH) AS mes,
    COUNT(*) AS total_canceladas
FROM 
    assinaturas
WHERE 
    status_assinatura = 'cancelada'
GROUP BY data_cancelamento

```