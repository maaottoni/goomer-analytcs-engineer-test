# Exemplo de Diagrama Mermaid

Aqui está um exemplo de um diagrama Mermaid no Markdown:

```mermaid
erDiagram
    CLIENTES {
        int cliente_id PK
        string nome
        string email
        date data_cadastro
    }
    
    ASSINATURAS {
        int assinatura_id PK
        int cliente_id FK
        date data_inicio
        date data_cancelamento
        string produto
        float valor_assinatura_mensal
    }
    
    FATURAS {
        int fatura_id PK
        int assinatura_id FK
        date data_emissao
        date data_vencimento
        float valor_total
        string status
        date data_pagamento
        string tipo_receita
        string produto
    }
    
    RECEITAS_MENSAIS {
        string ano_mes PK
        string tipo_receita
        string produto
        float valor_total
    }
    
    CLIENTES ||--o{ ASSINATURAS : possui
    ASSINATURAS ||--o{ FATURAS : gera
    FATURAS }o--|| RECEITAS_MENSAIS : consolida
