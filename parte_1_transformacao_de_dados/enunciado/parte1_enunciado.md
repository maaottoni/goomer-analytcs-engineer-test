### Enunciado
O nosso Analista de BI solicitou uma tabela que cruze as informações de faturas pagas com a de MRR por loja e por produto por mês. A hipótese é de que estamos gerando muitos descontos através de processos operacionais.

#### Parte 1.1
Através dos dados de MRR de cada estabelecimento por produto, devemos criar um SQL que transforme os eventos de MRR e distribua nos meses até que ocorra uma alteração (mudança de valor) ou churn (valor 0). Vídeo 1.

#### Parte 1.2
Continuando no mesmo código SQL: cruze com os dados de faturas pagas e trate as seguintes questões:

- **Filtrar**: MRR do estabelecimento por produto = Valor pago em faturas por estabelecimento por produto
- **Classificar como partially_discount**: MRR do estabelecimento por produto > Valor pago em faturas por estabelecimento por produto
- **Classificar como total_discount**: MRR do estabelecimento por produto AND Valor pago em faturas por estabelecimento por produto is null
- **Classificar como duplicate**: (2x MRR do estabelecimento por produto) = Valor pago em faturas por estabelecimento por produto
- **Classificar como overpaid**: MRR do estabelecimento por produto < Valor pago em faturas por estabelecimento por produto

O seu código SQL será avaliado baseado na lógica para resolução do desafio. Por isso você pode fazer o SQL em um notepad de sua preferência ou pode subir para alguma ferramenta, criar as tabelas, importar os CSVs e executar de fato o seu código. Você terá os CSV_1_MRR e CSV_2_INVOICES como base simulando os dados das tabelas e um vídeo explicativo.


✨ [Resolução](https://github.com/maaottoni/goomer-analytcs-engineer-test/blob/main/parte_1_transformacao_de_dados/resposta/transformacao_dados.md)