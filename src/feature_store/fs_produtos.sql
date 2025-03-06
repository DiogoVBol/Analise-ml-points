
WITH tb_transactions_products AS (
    SELECT  t1.*,
            t2.NameProduct,
            t2.QuantityProduct

    FROM transactions AS t1

    LEFT JOIN transactions_product AS t2
    ON t1.idTransaction = t2.idTransaction

    WHERE t1.dtTransaction < "{date}"
    AND t1.dtTransaction >= DATE("{date}", "-21 day")
), 

tb_share AS (

    SELECT idCustomer,

        SUM(CASE WHEN NameProduct = 'Lista de presença' THEN QuantityProduct ELSE 0 END) AS qtdeListadepresença,
        SUM(CASE WHEN NameProduct = 'ChatMessage' THEN QuantityProduct ELSE 0 END) AS qtdeChatMessage,
        SUM(CASE WHEN NameProduct = 'Presença Streak' THEN QuantityProduct ELSE 0 END) AS qtdePresençaStreak,
        SUM(CASE WHEN NameProduct = 'Resgatar Ponei' THEN QuantityProduct ELSE 0 END) AS qtdeResgatarPonei,
        SUM(CASE WHEN NameProduct = 'Troca de Pontos StreamElements' THEN QuantityProduct ELSE 0 END) AS qtdeTrocaDePontosStreamElements,
        SUM(CASE WHEN NameProduct = 'Airflow Lover' THEN QuantityProduct ELSE 0 END) AS qtdeAirflowLover,
        SUM(CASE WHEN NameProduct = 'R Lover' THEN QuantityProduct ELSE 0 END) AS qtdeRLover,
        SUM(CASE WHEN NameProduct = 'Churn_5pp' THEN QuantityProduct ELSE 0 END) AS qtdeChurn_5pp,
        SUM(CASE WHEN NameProduct = 'Churn_2pp' THEN QuantityProduct ELSE 0 END) AS qtdeChurn_2pp,
        SUM(CASE WHEN NameProduct = 'Churn_10pp' THEN QuantityProduct ELSE 0 END) AS qtdeChurn_10pp,


        SUM(CASE WHEN NameProduct = 'Lista de presença' THEN pointsTransaction ELSE 0 END) AS pointsListadepresença,
        SUM(CASE WHEN NameProduct = 'ChatMessage' THEN pointsTransaction ELSE 0 END) AS pointsChatMessage,
        SUM(CASE WHEN NameProduct = 'Presença Streak' THEN pointsTransaction ELSE 0 END) AS pointsPresençaStreak,
        SUM(CASE WHEN NameProduct = 'Resgatar Ponei' THEN pointsTransaction ELSE 0 END) AS pointsResgatarPonei,
        SUM(CASE WHEN NameProduct = 'Troca de Pontos StreamElements' THEN pointsTransaction ELSE 0 END) AS pointsTrocaDePontosStreamElements,
        SUM(CASE WHEN NameProduct = 'Airflow Lover' THEN pointsTransaction ELSE 0 END) AS pointsAirflowLover,
        SUM(CASE WHEN NameProduct = 'R Lover' THEN pointsTransaction ELSE 0 END) AS pointsRLover,
        SUM(CASE WHEN NameProduct = 'Churn_5pp' THEN pointsTransaction ELSE 0 END) AS pointsChurn_5pp,
        SUM(CASE WHEN NameProduct = 'Churn_2pp' THEN pointsTransaction ELSE 0 END) AS pointsChurn_2pp,
        SUM(CASE WHEN NameProduct = 'Churn_10pp' THEN pointsTransaction ELSE 0 END) AS pointsChurn_10pp,


        1.0 * SUM(CASE WHEN NameProduct = 'ChatMessage' THEN QuantityProduct ELSE 0 END) / SUM(QuantityProduct) AS pctChatMessage,
        1.0 * SUM(CASE WHEN NameProduct = 'Lista de presença' THEN QuantityProduct ELSE 0 END) / SUM(QuantityProduct) AS pctListadepresença,
        1.0 * SUM(CASE WHEN NameProduct = 'Presença Streak' THEN QuantityProduct ELSE 0 END)/ SUM(QuantityProduct)  AS pctPresençaStreak,
        1.0 * SUM(CASE WHEN NameProduct = 'Resgatar Ponei' THEN QuantityProduct ELSE 0 END) / SUM(QuantityProduct) AS pctResgatarPonei,
        1.0 * SUM(CASE WHEN NameProduct = 'Troca de Pontos StreamElements' THEN QuantityProduct ELSE 0 END) / SUM(QuantityProduct) AS pctTrocaDePontosStreamElements,
        1.0 * SUM(CASE WHEN NameProduct = 'Airflow Lover' THEN QuantityProduct ELSE 0 END) / SUM(QuantityProduct) AS pctAirflowLover,
        1.0 * SUM(CASE WHEN NameProduct = 'R Lover' THEN QuantityProduct ELSE 0 END) / SUM(QuantityProduct) AS pctRLover,
        1.0 * SUM(CASE WHEN NameProduct = 'Churn_5pp' THEN QuantityProduct ELSE 0 END) / SUM(QuantityProduct)  AS pctChurn_5pp,
        1.0 * SUM(CASE WHEN NameProduct = 'Churn_2pp' THEN QuantityProduct ELSE 0 END) / SUM(QuantityProduct) AS pctChurn_2pp,
        1.0 * SUM(CASE WHEN NameProduct = 'Churn_10pp' THEN QuantityProduct ELSE 0 END) / SUM(QuantityProduct) AS pctChurn_10pp,

        1.0 * SUM(CASE WHEN NameProduct = 'ChatMessage' THEN QuantityProduct ELSE 0 END) / COUNT(DISTINCT DATE(dtTransaction)) AS avgChatLive


    FROM tb_transactions_products

    GROUP BY idCustomer
), 

tb_group AS (

SELECT idCustomer,
        NameProduct,
        SUM(QuantityProduct) AS qtde,
        SUM(pointsTransaction) AS points

FROM tb_transactions_products

GROUP BY idCustomer, NameProduct
),

tb_rn AS (

    SELECT *,
            ROW_NUMBER() OVER (PARTITION BY idCustomer ORDER BY qtde DESC, points DESC) rnQTDE

    FROM tb_group
),

tb_produto_max AS (

    SELECT *
    FROM tb_rn

    WHERE rnQTDE = 1
)

SELECT  "{date}" AS dt_ref,
        t1.*,
        t2.NameProduct AS productMaxQtde

FROM tb_share AS t1
LEFT JOIN tb_produto_max AS t2
ON t1.idCustomer = t2.idCustomer