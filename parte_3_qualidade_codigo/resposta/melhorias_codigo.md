# Parte 3 - Qualidade do Código

📄 **[Enunciado](https://github.com/maaottoni/goomer-analytcs-engineer-test/blob/main/parte_3_qualidade_codigo/enunciado/parte_3_enunciado.txt)**


A seguir, algumas sugestões de medidas que podem ser adotadas para melhorar a qualidade do código fornecido:

## Organização do Código
- Utilizar indentação adequada para melhorar a legibilidade.
- Adicionar comentários explicando o objetivo principal da query e das CTEs.
- Utilizar aliases para as tabelas referenciadas nas CTEs para facilitar a leitura e compreensão do código.

## Otimização de Performance
- Adicionar um índice na coluna `data_expiracao` no filtro da CTE `base_assinaturas`, caso não exista.
- Expandir o campo `items` chamando a função `json_array_elements` uma única vez com o operador `LATERAL`.
- Usar `COALESCE` ao invés de `CASE` para tratar os valores do campo `pacote`.
- Aplicar o filtro `due_date >= '2022-07-01'` na CTE `assinatura_raw` e o filtro `ia.quantity > 0` na CTE `items_assinatura` para diminuir o número de registros processados nas etapas seguintes.

## Exemplo de Código Final
- A query disponivel [nesse link](https://github.com/maaottoni/goomer-analytcs-engineer-test/blob/main/parte_3_qualidade_codigo/resposta/consulta_assinaturas_melhorada.sql) apresenta um exemplo de código final, com as sugestões de melhoria apresentadas acima.


[⬅️ Voltar para o README](https://github.com/maaottoni/goomer-analytcs-engineer-test/blob/main/README.md)

