WITH tb_transaction_hours AS (

    SELECT idCustomer,
            pointsTransaction,
            CAST(strftime("%H", DATETIME(dtTransaction, '-3 hour')) AS INTEGER) AS hour

    FROM transactions

    WHERE dtTransaction < "{date}"
    AND dtTransaction >= DATE("{date}", "-21 day")
),

tb_share AS (

    SELECT idCustomer,
            SUM(CASE WHEN hour >= 8 AND hour < 12 THEN ABS(pointsTransaction)  ELSE 0 END) AS qtdePointsManha,
            SUM(CASE WHEN hour >= 12 AND hour < 18 THEN ABS(pointsTransaction) ELSE 0 END) AS qtdePointsTarde,
            SUM(CASE WHEN hour >= 18 AND hour <= 00 THEN ABS(pointsTransaction)  ELSE 0 END) AS qtdePointsNoite,

            1.0 * SUM(CASE WHEN hour >= 8 AND hour < 12 THEN ABS(pointsTransaction) ELSE 0 END) / SUM(abs(pointsTransaction))  AS pctPointsManha,
            1.0 * SUM(CASE WHEN hour >= 12 AND hour < 18 THEN ABS(pointsTransaction) ELSE 0 END) / SUM(abs(pointsTransaction))  AS pctPointsTarde,
            1.0 * SUM(CASE WHEN hour >= 18 AND hour <= 00 THEN ABS(pointsTransaction) ELSE 0 END) / SUM(abs(pointsTransaction))  AS pctPointsNoite,

            SUM(CASE WHEN hour >= 8 AND hour < 12 THEN 1  ELSE 0 END) AS qtdeTransacoesManha,
            SUM(CASE WHEN hour >= 12 AND hour < 18 THEN 1 ELSE 0 END) AS qtdeTransacoesTarde,
            SUM(CASE WHEN hour >= 18 AND hour <= 00 THEN 1  ELSE 0 END) AS qtdeTransacoesNoite,

            1.0 * SUM(CASE WHEN hour >= 8 AND hour < 12 THEN 1 ELSE 0 END) / SUM(1)  AS pctTransacoesManha,
            1.0 * SUM(CASE WHEN hour >= 12 AND hour < 18 THEN 1 ELSE 0 END) / SUM(1)  AS pctTransacoesTarde,
            1.0 * SUM(CASE WHEN hour >= 18 AND hour <= 00 THEN 1 ELSE 0 END) / SUM(1)  AS pctTransacoesNoite

    FROM tb_transaction_hours

    GROUP BY idCustomer

)

SELECT *

FROM tb_share