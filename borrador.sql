
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


-- Vistas
go -- 2
select
    bt.anio,
    bt.cuatrimestre,
    bu.provincia,
    isnull(avg(bf.total), 0) as factura_promedio_mensual
from REJUNTE_SA.BI_factura Bf
inner join REJUNTE_SA.BI_sucursal Bs on Bf.id_sucursal = Bs.id
inner join REJUNTE_SA.BI_ubicacion Bu on Bu.id = Bs.id_ubicacion
inner join REJUNTE_SA.BI_tiempo Bt on Bf.id_tiempo = Bt.id
group by bt.anio, bt.cuatrimestre, bu.provincia
order by bt.anio, bt.cuatrimestre, bu.provincia;

GO -- 3
WITH ventas_modelos AS (SELECT
    bt.anio,
    bt.cuatrimestre,
    bu.id,
    bu.localidad,
    BP.id_modelo,
    concat(bre.edad_minima,'-', bre.edad_maxima) as rango_etario,
    ROW_NUMBER() OVER (
            PARTITION BY bt.anio, bt.cuatrimestre, bu.id, bu.localidad, bre.id, bre.edad_maxima, bre.edad_minima
            ORDER BY SUM(BP.total) DESC
        ) AS ranking,
    sum(BP.total) as total
FROM REJUNTE_SA.BI_pedido Bp
inner join REJUNTE_SA.BI_tiempo Bt on Bp.id_tiempo = Bt.id
inner join REJUNTE_SA.BI_sucursal Bs on Bp.id_sucursal = Bs.id
inner join REJUNTE_SA.BI_ubicacion Bu on Bu.id = Bs.id_ubicacion
inner join REJUNTE_SA.BI_cliente Bc on Bp.id_cliente = Bc.id
inner join REJUNTE_SA.BI_rango_etario Bre on Bc.id_rango_etario = Bre.id
group by bt.anio, bt.cuatrimestre, bu.id, bu.localidad, bre.id, bre.edad_maxima, bre.edad_minima, BP.id_modelo
)
SELECT
    anio,
    cuatrimestre,
    localidad,
    rango_etario,
    id_modelo,
    total
FROM ventas_modelos
WHERE ranking <= 3
ORDER BY anio, cuatrimestre, localidad, rango_etario, ranking;

select *
from REJUNTE_SA.BI_rango_etario Bre;

SELECT
    s.id as 'sucursal',
    t.anio,
    t.mes,
    tv.horario_inicio AS 'horario inicio turno',
    tv.horario_fin AS 'horario fin turno',
    COUNT(DISTINCT p.cantidad) AS 'Numero de pedidos en el mes'
FROM REJUNTE_SA.BI_sucursal s
INNER JOIN REJUNTE_SA.BI_pedido p
    ON p.id_sucursal = s.id
INNER JOIN REJUNTE_SA.BI_tiempo t
    ON t.id = p.id_tiempo
INNER JOIN REJUNTE_SA.BI_turno_venta tv
    ON tv.id = p.id_turno_venta
GROUP BY s.id, t.anio, t.mes, tv.id, tv.horario_inicio, tv.horario_fin

GO
-- select *
-- from REJUNTE_SA.BI_pedido Bp
-- inner join REJUNTE_SA.BI_tiempo Bt on Bp.id_tiempo = Bt.id
-- INNER JOIN REJUNTE_SA.BI_sucursal Bs on Bp.id_sucursal = Bs.id
-- INNER JOIN REJUNTE_SA.BI_turno_venta Btv on bp.

-- 5
go
select
    bs.id as sucursal,
    bt.anio,
    bt.cuatrimestre,
    bep.descripcion as estado,
    concat(round((
        select
            isnull(cast(sum(bp.cantidad) * 100.00 / sum(bp2.cantidad) as decimal(9,2)), 0.00)
        from REJUNTE_SA.BI_pedido Bp2
        inner join REJUNTE_SA.BI_tiempo Bt2 on Bp2.id_tiempo = Bt2.id
        where Bp2.id_sucursal = bs.id
          and bt2.cuatrimestre = bt.cuatrimestre
            and bt2.anio = bt.anio
    ), 2), '%') as porcentaje,
    sum(bp.cantidad) as cantidad
from REJUNTE_SA.BI_pedido Bp
inner join REJUNTE_SA.BI_tiempo Bt on Bp.id_tiempo = Bt.id
inner join REJUNTE_SA.BI_estado_pedido Bep on Bp.id_estado_pedido = Bep.id
inner join REJUNTE_SA.BI_sucursal Bs on Bp.id_sucursal = Bs.id
group by bep.descripcion, bt.anio, bt.cuatrimestre, bs.id
order by 1,2,3,4


GO -- 5
SELECT
    s.id AS id_sucursal,
    t.anio,
    t.cuatrimestre,
    ep.descripcion AS 'Estado pedido',
    concat(
	round(( select isnull(cast(sum(p.cantidad) * 100.00 /
	sum(bp2.cantidad) as decimal(9,2)), 0.00) from REJUNTE_SA.BI_pedido Bp2
	inner join REJUNTE_SA.BI_tiempo Bt2 on Bp2.id_tiempo = Bt2.id
	where Bp2.id_sucursal = s.id and bt2.cuatrimestre = t.cuatrimestre and bt2.anio = t.anio), 2), '%'
    ) as porcentaje
FROM
	REJUNTE_SA.BI_sucursal s
	JOIN REJUNTE_SA.BI_pedido p ON p.id_sucursal = s.id
    JOIN REJUNTE_SA.BI_tiempo t ON p.id_tiempo = t.id
    JOIN REJUNTE_SA.BI_estado_pedido ep ON p.id_estado_pedido = ep.id
    GROUP BY s.id, t.anio, t.cuatrimestre, ep.descripcion
    ORDER BY s.id, t.anio, t.cuatrimestre, ep.descripcion

SELECT
    s.id AS id_sucursal,
    t.anio,
    t.cuatrimestre,
    ep.descripcion AS 'Estado pedido',
    concat(round((
        select
            isnull(cast(
                sum(p.cantidad) * 100.00 / sum(bp2.cantidad) as decimal(9,2)), 0.00
            )
        from REJUNTE_SA.BI_pedido Bp2
        inner join REJUNTE_SA.BI_tiempo Bt2 on Bp2.id_tiempo = Bt2.id
        where Bp2.id_sucursal = s.id and bt2.cuatrimestre = t.cuatrimestre and bt2.anio = t.anio), 2), '%'
    ) as porcentaje
FROM
	REJUNTE_SA.BI_sucursal s
	JOIN REJUNTE_SA.BI_pedido p ON p.id_sucursal = s.id
    JOIN REJUNTE_SA.BI_tiempo t ON p.id_tiempo = t.id
    JOIN REJUNTE_SA.BI_estado_pedido ep ON p.id_estado_pedido = ep.id
GROUP BY
    s.id,
	t.anio,
    t.cuatrimestre,
    ep.descripcion
ORDER BY
	s.id,
	t.anio,
    t.cuatrimestre,
    ep.descripcion

SELECT
    p.id_sucursal,
    t.anio,
    t.cuatrimestre,
    ep.descripcion AS 'Estado pedido',
    CAST (
        (COUNT(*) * 100.00) / (
		  SELECT COUNT(*) FROM REJUNTE_SA.BI_pedido  p1
		  JOIN REJUNTE_SA.BI_tiempo t1
		  ON t1.id = p1.id_tiempo
		  WHERE id_sucursal = p.id_sucursal
		  AND t1.id = t.id
		  GROUP BY t1.id, p1.id_sucursal
		) AS decimal(18, 2)
    ) AS 'Porcentaje de pedidos sobre los pedidos hechos en el periodo'
FROM
    REJUNTE_SA.BI_pedido p
    JOIN REJUNTE_SA.BI_tiempo t ON p.id_tiempo = t.id
    JOIN REJUNTE_SA.BI_estado_pedido ep ON p.id_estado_pedido = ep.id
GROUP BY
    p.id_sucursal,
	t.id,
	t.anio,
    t.cuatrimestre,
    ep.descripcion

SELECT
    p.id_sucursal,
    t.anio,
    t.cuatrimestre,
    ep.descripcion AS 'Estado pedido',
    CAST (
        (COUNT(*) * 100.00) / (totales.total_pedidos) AS decimal(18, 2)
    ) AS 'Porcentaje de pedidos sobre los pedidos hechos en el periodo'
FROM
    REJUNTE_SA.BI_pedido p
    JOIN REJUNTE_SA.BI_tiempo t ON p.id_tiempo = t.id
    JOIN REJUNTE_SA.BI_estado_pedido ep ON p.id_estado_pedido = ep.id
    JOIN (
        SELECT
            p.id_sucursal,
            t.anio,
            t.cuatrimestre,
            COUNT(*) AS total_pedidos
        FROM
            REJUNTE_SA.BI_pedido p
            JOIN REJUNTE_SA.BI_tiempo t ON p.id_tiempo = t.id
        GROUP BY
            p.id_sucursal,
            t.anio,
            t.cuatrimestre
    ) totales ON p.id_sucursal = totales.id_sucursal
    AND t.anio = totales.anio
    AND t.cuatrimestre = totales.cuatrimestre
GROUP BY
    p.id_sucursal,
    t.anio,
    t.cuatrimestre,
    ep.id,
    ep.descripcion,
    totales.total_pedidos

select
    bs.id as sucursal,
    bt.cuatrimestre,
    bep.id as estado,
    bp.cantidad
from REJUNTE_SA.BI_pedido Bp
inner join REJUNTE_SA.BI_tiempo Bt on Bp.id_tiempo = Bt.id
inner join REJUNTE_SA.BI_sucursal Bs on Bp.id_sucursal = Bs.id
inner join REJUNTE_SA.BI_estado_pedido Bep on Bp.id_estado_pedido = Bep.id
where bs.id = 37 and bt.cuatrimestre = 1

-- 7
SELECT
    t.anio,
    t.mes,
    cast(AVG(C.total) as decimal(18,2)) as promedio
FROM REJUNTE_SA.BI_compra c
INNER JOIN REJUNTE_SA.BI_tiempo t ON c.id_tiempo = t.id
GROUP BY
    t.anio,
    t.mes

-- 9
SELECT
    t.anio,
    t.mes,
    cast(sum(cast(e.es_fecha_entrega as int)) * 100.00 / count(*) as decimal(9,2)) as 'Porcentaje de envios cumplidos'
--     CAST(SUM(CASE WHEN (e.fecha_programada = e.fecha_entrega) THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS decimal(18,2)) AS 'Porcentaje de envios cumplidos'
FROM REJUNTE_SA.BI_envio e
INNER JOIN REJUNTE_SA.BI_tiempo t ON YEAR(e.fecha_programada) = t.anio AND MONTH(e.fecha_programada) = t.mes
GROUP BY t.id, t.anio, t.mes


select
    F.fecha,
    E.fecha_programada,
    E.fecha_entrega
from REJUNTE_SA.Factura F
inner join REJUNTE_SA.Envio E on F.id = E.id_factura
where E.id_factura = 46118858

GO -- 7
CREATE VIEW REJUNTE_SA.BI_promedio_de_compras AS
SELECT
    t.anio,
    t.mes,
    CAST(SUM(c.total) / COUNT(*) AS decimal(18, 2)) AS 'Promedio de compras por mes'
FROM
    REJUNTE_SA.BI_compra c
    JOIN REJUNTE_SA.BI_tiempo t ON c.id_tiempo = t.id
GROUP BY
    t.anio,
    t.mes

GO -- 9
CREATE VIEW REJUNTE_SA.BI_porcentaje_de_cumplimiento_de_envios AS
SELECT
    t.anio,
    t.mes,
    cast(
            sum(cast(e.es_fecha_entrega as int)) * 100.00 / count(*) as decimal(9,2)
    ) AS 'Porcentaje de envios cumplidos'
FROM REJUNTE_SA.BI_envio e
INNER JOIN REJUNTE_SA.BI_tiempo t ON YEAR(e.fecha_programada) = t.anio AND MONTH(e.fecha_programada) = t.mes
GROUP BY t.id, t.anio, t.mes


go -- 6
select
    Bp.id_sucursal,
    bt.cuatrimestre,
    avg(DATEDIFF(DAY, bp.fecha, bf.fecha)) AS dias_fabricacion
from REJUNTE_SA.BI_pedido Bp
inner join REJUNTE_SA.BI_factura Bf
    on Bp.id_sucursal = Bf.id_sucursal
           and bp.id_cliente = bf.id_cliente
           and bp.id_tiempo = bf.id_tiempo
inner join REJUNTE_SA.BI_tiempo Bt
    on Bp.id_tiempo = Bt.id
group by Bp.id_sucursal, bt.cuatrimestre
order by 1,2,3 desc

go
select
    p.id_sucursal,
    REJUNTE_SA.obtener_cuatrimestre(P.fecha) as cuatrimestre,
    P.fecha as fecha_pedido,
    F.fecha as fecha_factura,
    DATEDIFF(DAY, p.fecha, f.fecha) as diferencia_en_dias
from REJUNTE_SA.Pedido P
inner join REJUNTE_SA.Factura F on p.id_sucursal = f.id_sucursal and p.id_cliente = f.id_cliente
-- where p.id_sucursal=92 and REJUNTE_SA.obtener_cuatrimestre(P.fecha)=3
order by 1,2,5 desc


select
    avg(DATEDIFF(DAY, p.fecha, f.fecha)) as diferencia_en_dias
from REJUNTE_SA.Pedido P
inner join REJUNTE_SA.Factura F on p.id_sucursal = f.id_sucursal
where p.id_sucursal=92 and REJUNTE_SA.obtener_cuatrimestre(P.fecha)=3

-- +-----------+------------+----------------+
-- |id_sucursal|cuatrimestre|dias_fabricacion|
-- +-----------+------------+----------------+
-- |92         |3           |0               |
-- |107        |1           |0               |
-- |107        |2           |1               |
-- |107        |3           |-1              |
-- +-----------+------------+----------------+


go -- 8
select
    Btm.descripcion,
    Bc.id_sucursal,
    Bt.cuatrimestre,
    sum(Bc.total) as total
from REJUNTE_SA.BI_compra Bc
inner join REJUNTE_SA.BI_tiempo Bt on Bt.id = Bc.id_tiempo
inner join REJUNTE_SA.BI_tipo_material Btm on Btm.id = Bc.id_material_tipo
group by Btm.descripcion, Bc.id_sucursal, Bt.cuatrimestre

GO -- 10
select
    top 3
    Bu.localidad,
    cast(avg(be.importe_total) as decimal(18,2)) as promedio_envio_total
from REJUNTE_SA.BI_envio Be
inner join REJUNTE_SA.BI_cliente Bc on Bc.id = Be.id_cliente
inner join REJUNTE_SA.BI_ubicacion Bu on Bc.id_ubicacion = Bu.id
group by Bu.localidad
order by promedio_envio_total desc

go
select *
from REJUNTE_SA.Pedido P
inner join REJUNTE_SA.Factura F on F.id_cliente = P.id_cliente and F.id_sucursal = P.id_sucursal
where F.id_sucursal=37 and F.id_cliente=18024

select *
from REJUNTE_SA.Factura F
where id_sucursal=37 and id_cliente=4963