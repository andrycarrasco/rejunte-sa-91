
-- Borradores (ELIMINAR AL ENTREGAR)
select
    BS.id as Sucursal,
    BT.anio,
    Bt.mes,
    SUM(distinct Bf.total) AS total_facturas,
    SUM(distinct Bc.total) AS total_compras,
    SUM(distinct Bf.total) - sum(distinct Bc.total) AS ganancia
from REJUNTE_SA.BI_sucursal Bs
LEFT JOIN REJUNTE_SA.BI_factura Bf
    ON Bs.id = Bf.id_sucursal
LEFT JOIN REJUNTE_SA.BI_compra Bc
    ON Bs.id = Bc.id_sucursal
INNER JOIN REJUNTE_SA.BI_tiempo Bt
    ON Bf.id_tiempo = Bt.id
        AND Bc.id_tiempo = Bt.id
GROUP BY bS.id, BT.anio, Bt.mes
ORDER BY BS.ID, Bt.anio, Bt.mes;


SELECT
    suc.id AS id_sucursal,
    tiempo.anio,
    tiempo.mes,
    ISNULL(fact.total_facturas, 0) AS total_facturas,
    ISNULL(comp.total_compras, 0) AS total_compras,
    ISNULL(fact.total_facturas, 0) - ISNULL(comp.total_compras, 0) AS ganancia
FROM REJUNTE_SA.BI_sucursal suc
CROSS JOIN REJUNTE_SA.BI_tiempo tiempo
LEFT JOIN (
    SELECT id_sucursal, id_tiempo, SUM(total) AS total_facturas
    FROM REJUNTE_SA.BI_factura
    GROUP BY id_sucursal, id_tiempo
) fact
    ON fact.id_sucursal = suc.id AND fact.id_tiempo = tiempo.id
LEFT JOIN (
    SELECT id_sucursal, id_tiempo, SUM(total) AS total_compras
    FROM REJUNTE_SA.BI_compra
    GROUP BY id_sucursal, id_tiempo
) comp
    ON comp.id_sucursal = suc.id AND comp.id_tiempo = tiempo.id
ORDER BY suc.id, tiempo.anio, tiempo.mes;

select
    BS.id,
    BT.anio,
    Bt.mes,
    Bf.total,
    Bc.total
--     SUM(Bf.total) AS total_facturas,
--     SUM(Bc.total) AS total_compras,
--     SUM(Bf.total - Bc.total) AS ganancia
from REJUNTE_SA.BI_sucursal Bs
INNER JOIN REJUNTE_SA.BI_factura Bf
    ON Bs.id = Bf.id_sucursal
INNER JOIN REJUNTE_SA.BI_compra Bc
    ON Bs.id = Bc.id_sucursal
INNER JOIN REJUNTE_SA.BI_tiempo Bt
    ON Bf.id_tiempo = Bt.id
        AND Bc.id_tiempo = Bt.id
where Bs.id = 37 and BT.anio = 2026 and Bt.mes = 1
-- GROUP BY bS.id, BT.anio, Bt.mes
ORDER BY BS.ID, Bt.anio, Bt.mes;

-- +--+----+---+--------------+-------------+--------------+
-- |id|anio|mes|total_facturas|total_compras|ganancia      |
-- +--+----+---+--------------+-------------+--------------+
-- |37|2026|1  |81585607.96   |1442220608.40|-1360635000.44|
-- |37|2026|4  |254811547.02  |5284885066.90|-5030073519.88|
-- |37|2026|5  |149698650.50  |1453487365.68|-1303788715.18|
-- |37|2026|6  |70096215.29   |767724135.25 |-697627919.96 |
-- |37|2026|10 |91133545.90   |1441169323.79|-1350035777.89|
-- |37|2026|12 |163923826.02  |2344305246.90|-2180381420.88|
-- |37|2027|2  |72210995.35   |1854226709.16|-1782015713.81|
-- |37|2027|5  |100276231.08  |2365637630.36|-2265361399.28|
-- |37|2027|7  |58159521.74   |1152029106.72|-1093869584.98|
-- +--+----+---+--------------+-------------+--------------+

Go
select sum(total) as total -- 40.792.803,98
from REJUNTE_SA.Factura F
where F.id_sucursal=37 and year(F.fecha) = 2026 and month(F.fecha) = 1;

select sum(total) as total -- 27.735.011,70
from REJUNTE_SA.Compra C
where C.id_sucursal=37 and year(C.fecha) = 2026 and month(C.fecha) = 1;


-- select 40792803.98 - 27735011.70 as result

select sum(total) as total
from REJUNTE_SA.BI_factura Bf
where id_tiempo=1 and id_sucursal=37;

select sum(total) as total
from REJUNTE_SA.BI_compra Bc
where id_tiempo=1 and id_sucursal=37;


select *
from REJUNTE_SA.BI_tiempo Bt;


select *
from REJUNTE_SA.BI_factura_promedio_mensual_2 Bfpm
order by anio, cuatrimestre, provincia;

-- +----+------------+------------+-----------------+-------------+------------------------+
-- |anio|cuatrimestre|provincia   |cantidad_facturas|total_importe|factura_promedio_mensual|
-- +----+------------+------------+-----------------+-------------+------------------------+
-- |2026|1           |Buenos Aires|785              |652520853.85 |831236.756496           |
-- |2026|1           |Cordoba     |383              |326081192.74 |851386.926214           |
-- |2026|1           |Entre Rios  |404              |351515590.28 |870088.094752           |
-- +----+------------+------------+-----------------+-------------+------------------------+

-- select *
-- from REJUNTE_SA.BI_volumen_pedidos Bvp
-- ORDER BY sucursal, anio, mes, [horario inicio turno]

select *
from REJUNTE_SA.BI_ubicacion Bu;


select
    count(bf.id) as cantidad_facturas,
    sum(bf.total) as total_importe,
    avg(bf.total * 1.0) as factura_promedio_mensual
from REJUNTE_SA.BI_factura Bf
inner join REJUNTE_SA.BI_sucursal Bs on Bs.id = Bf.id_sucursal
WHERE BF.id_tiempo in (1,2,3,4)
  and bs.id_ubicacion in (select id_localidad from REJUNTE_SA.BI_ubicacion Bu where nombre_provincia='Buenos Aires')

SELECT
    Bt.anio AS anio,
    Bt.cuatrimestre AS cuatrimestre,
    Bu.nombre_provincia AS provincia,
    COUNT(bf.id) AS cantidad_facturas,
    SUM(bf.total) AS total_importe,
    AVG(bf.total * 1.0) AS factura_promedio_mensual
FROM
    REJUNTE_SA.BI_factura Bf
INNER JOIN
    REJUNTE_SA.BI_sucursal Bs ON bs.id = bf.id_sucursal
INNER JOIN
    REJUNTE_SA.BI_ubicacion Bu ON BU.id_localidad = BS.id_ubicacion
INNER JOIN
    REJUNTE_SA.BI_tiempo Bt ON Bt.id = BF.id_tiempo
GROUP BY
    Bt.anio,
    Bt.cuatrimestre,
    Bu.nombre_provincia
order by anio, cuatrimestre, provincia;

select *
from REJUNTE_SA.Compra C
inner join REJUNTE_SA.Detalle_Compra DC on C.id = DC.id_compra
where id_compra=12242231;

select *
from REJUNTE_SA.Detalle_Compra DC
where id_compra=12242231;


select *
from REJUNTE_SA.Envio E;