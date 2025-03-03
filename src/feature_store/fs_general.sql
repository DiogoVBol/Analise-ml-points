
WITH tb_rfv AS (

    SELECT  idCustomer,
            CAST(min(julianday('{date}') - julianday(dtTransaction)) AS INTEGER) AS recenciaDias,
            COUNT(DISTINCT(DATE(dtTransaction))) AS frequenciasDias,
            SUM(CASE WHEN pointsTransaction > 0 THEN pointsTransaction END) AS valorPoints

    FROM transactions

    WHERE dtTransaction < '{date}'
    AND dtTransaction >= DATE('{date}', '-21 day')

    GROUP BY idCustomer

),

tb_ref_idade AS (

    SELECT  idCustomer,
            CAST(MAX(julianday('{date}') - julianday(dtTransaction)) AS INTEGER) AS idadeBaseDias

    FROM transactions

    GROUP BY idCustomer
)

SELECT  '{date}' AS dtRef,
        t1.*,
        t2.idadeBaseDias,
        t3.flEmail

FROM tb_rfv AS t1

LEFT JOIN tb_ref_idade AS t2
ON t1.idCustomer = t2.idCustomer

LEFT JOIN customers AS t3
ON t1.idCustomer = t3.idCustomer