-- CREATE FACTS TABLES
GO
CREATE TABLE REJUNTE_SA.BI_factura (
    id_sucursal BIGINT,
    id_tiempo BIGINT,
    id_cliente BIGINT,
    id_turno_venta BIGINT,
    cantidad BIGINT,
    total decimal (38,2)
)

GO
CREATE TABLE REJUNTE_SA.BI_pedido (
    id_sucursal BIGINT,
    id_cliente BIGINT,
    id_tiempo BIGINT,
    id_estado_pedido BIGINT,
    id_modelo BIGINT,
    id_turno_venta BIGINT,
    cantidad BIGINT,
    total decimal(18,2),
)

GO
CREATE TABLE REJUNTE_SA.BI_compra (
    id_sucursal BIGINT,
    id_material_tipo BIGINT,
    id_tiempo BIGINT,
    cantidad BIGINT,
    total decimal(38,2)
)

GO
CREATE TABLE REJUNTE_SA.BI_envio(
    id_cliente BIGINT,
    id_sucursal BIGINT,
    fecha_programada DATETIME2(6),
    fecha_entrega DATETIME2(6),
    es_fecha_entrega BIT,
    cantidad BIGINT,
    importe_traslado DECIMAL(18, 2),
    importe_subida DECIMAL(18, 2),
    importe_total DECIMAL(18, 2)
)


-- CREATE DIMENSIONS TABLES
GO
CREATE TABLE REJUNTE_SA.BI_tiempo (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    anio INT,
    mes INT,
    cuatrimestre INT
)

GO
CREATE TABLE REJUNTE_SA.BI_ubicacion (
    id BIGINT PRIMARY KEY,
    localidad NVARCHAR(255),
    provincia NVARCHAR(255)
)

GO
CREATE TABLE REJUNTE_SA.BI_sucursal (
    id BIGINT PRIMARY KEY,
    id_datos_contacto BIGINT,
    id_ubicacion BIGINT,
    direccion NVARCHAR(255)
)

GO
CREATE TABLE REJUNTE_SA.BI_modelo(
    id BIGINT PRIMARY KEY,
    modelo NVARCHAR(255),
    descripcion NVARCHAR(255),
    precio DECIMAL(18, 2)
)

GO
CREATE TABLE REJUNTE_SA.BI_rango_etario (
  id BIGINT IDENTITY(1,1) PRIMARY KEY,
  edad_minima INT,
  edad_maxima INT
)

GO
CREATE TABLE REJUNTE_SA.BI_turno_venta (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    horario_inicio TIME, 
    horario_fin TIME
)

GO
CREATE TABLE REJUNTE_SA.BI_estado_pedido (
    id BIGINT PRIMARY KEY,
    descripcion NVARCHAR(255)
)

GO
CREATE TABLE REJUNTE_SA.BI_tipo_material(
    id BIGINT PRIMARY KEY,
    descripcion NVARCHAR(255)
)

GO -- Revisar campos innecesarios de acuerdo al DER
CREATE TABLE REJUNTE_SA.BI_cliente (
    id BIGINT PRIMARY KEY,
    dni BIGINT UNIQUE,
    nombre NVARCHAR(255),
    apellido NVARCHAR(255),
    id_rango_etario BIGINT,
    direccion NVARCHAR(255),
    id_datos_contacto BIGINT,
    id_ubicacion BIGINT
)

-- CREATE FOREIGN KEYS
GO
-- FACTURA FKs
ALTER TABLE REJUNTE_SA.BI_factura
ADD FOREIGN KEY (id_sucursal) REFERENCES REJUNTE_SA.BI_sucursal(id);
ALTER TABLE REJUNTE_SA.BI_factura
ADD FOREIGN KEY (id_tiempo) REFERENCES REJUNTE_SA.BI_tiempo(id);
ALTER TABLE REJUNTE_SA.BI_factura
ADD FOREIGN KEY (id_cliente) REFERENCES REJUNTE_SA.BI_cliente(id);
ALTER TABLE REJUNTE_SA.BI_factura
ADD FOREIGN KEY (id_turno_venta) REFERENCES REJUNTE_SA.BI_turno_venta(id);

-- PEDIDO FKs
ALTER TABLE REJUNTE_SA.BI_pedido
ADD FOREIGN KEY (id_sucursal) REFERENCES REJUNTE_SA.BI_sucursal(id);
ALTER TABLE REJUNTE_SA.BI_pedido
ADD FOREIGN KEY (id_cliente) REFERENCES REJUNTE_SA.BI_cliente(id);
ALTER TABLE REJUNTE_SA.BI_pedido
ADD FOREIGN KEY (id_tiempo) REFERENCES REJUNTE_SA.BI_tiempo(id);
ALTER TABLE REJUNTE_SA.BI_pedido
ADD FOREIGN KEY (id_estado_pedido) REFERENCES REJUNTE_SA.BI_estado_pedido(id);
ALTER TABLE REJUNTE_SA.BI_pedido
ADD FOREIGN KEY (id_modelo) REFERENCES REJUNTE_SA.BI_modelo(id);
ALTER TABLE REJUNTE_SA.BI_pedido
ADD FOREIGN KEY (id_turno_venta) REFERENCES REJUNTE_SA.BI_turno_venta(id);

-- COMPRA FKs
ALTER TABLE REJUNTE_SA.BI_compra
ADD FOREIGN KEY (id_sucursal) REFERENCES REJUNTE_SA.BI_sucursal(id);
ALTER TABLE REJUNTE_SA.BI_compra
ADD FOREIGN KEY (id_tiempo) REFERENCES REJUNTE_SA.BI_tiempo(id);
ALTER TABLE REJUNTE_SA.BI_compra
ADD FOREIGN KEY (id_material_tipo) REFERENCES REJUNTE_SA.BI_tipo_material(id);
-- ENVIO FKs
ALTER TABLE REJUNTE_SA.BI_envio
ADD FOREIGN KEY (id_sucursal) REFERENCES REJUNTE_SA.BI_sucursal(id);
ALTER TABLE REJUNTE_SA.BI_envio
ADD FOREIGN KEY (id_cliente) REFERENCES REJUNTE_SA.BI_cliente(id);

-- SUCURSAL FKs
ALTER TABLE REJUNTE_SA.BI_sucursal
ADD FOREIGN KEY (id_ubicacion) REFERENCES REJUNTE_SA.BI_ubicacion(id);

-- CLIENTE FKs
ALTER TABLE REJUNTE_SA.BI_cliente
ADD FOREIGN KEY (id_ubicacion) REFERENCES REJUNTE_SA.BI_ubicacion(id);
ALTER TABLE REJUNTE_SA.BI_cliente
ADD FOREIGN KEY (id_rango_etario) REFERENCES REJUNTE_SA.BI_rango_etario(id);

-- CREATE FUNCTIONS
GO 
CREATE FUNCTION REJUNTE_SA.obtener_cuatrimestre(@fecha DATETIME2(6))
RETURNS INT
AS
BEGIN
    DECLARE @mes INT, @cuatrimestre INT;
    SET @mes = MONTH(@fecha);

    IF(@mes >= 1 AND @mes < 5)
    BEGIN
        SET @cuatrimestre = 1;
    END

    IF(@mes >= 5 AND @mes < 9)
    BEGIN 
        SET @cuatrimestre = 2;
    END 

    IF(@mes >= 9 AND @mes <= 12)
    BEGIN 
        SET @cuatrimestre = 3;
    END 
RETURN @cuatrimestre;
END

GO
CREATE FUNCTION REJUNTE_SA.obtener_id_tiempo (@fecha DATETIME2(6))
RETURNS BIGINT AS 
BEGIN 
    DECLARE @id_tiempo BIGINT
    SET @id_tiempo = (
      SELECT id
      FROM REJUNTE_SA.BI_tiempo
      WHERE anio = YEAR(@fecha) AND mes = MONTH(@fecha) AND cuatrimestre = REJUNTE_SA.obtener_cuatrimestre(@fecha)
    )
    RETURN @id_tiempo
END 

GO
CREATE FUNCTION REJUNTE_SA.obtener_id_turno (@fecha DATETIME2(6))
RETURNS BIGINT AS 
BEGIN 
    DECLARE @id_turno BIGINT
    SET @id_turno = (
        SELECT id
        FROM REJUNTE_SA.BI_turno_venta
        WHERE CAST(@fecha as TIME) BETWEEN horario_inicio AND horario_fin
    )
    RETURN @id_turno
END

GO
CREATE FUNCTION REJUNTE_SA.obtener_es_fecha_cumplida (@fecha_programada DATETIME2(6), @fecha_entrega DATETIME2(6))
RETURNS BIT AS
BEGIN
    DECLARE @es_fecha_cumplida BIT
    if (@fecha_programada = @fecha_entrega)
    BEGIN
        SET @es_fecha_cumplida = 1
    END
    else
        SET @es_fecha_cumplida = 0
    RETURN @es_fecha_cumplida
END


-- CREATE PROCEDURE
-- MIGRATE FACT TABLES
GO
CREATE PROCEDURE REJUNTE_SA.migrar_bi_factura AS
BEGIN
    INSERT INTO REJUNTE_SA.BI_factura (id_sucursal, id_cliente, id_tiempo, id_turno_venta, cantidad, total)
    SELECT
        F.id_sucursal,
        F.id_cliente,
        REJUNTE_SA.obtener_id_tiempo(F.fecha) AS 'id_tiempo',
        REJUNTE_SA.obtener_id_turno(F.fecha) AS 'id_turno_venta',
        count(distinct F.id) as cantidad,
        sum(F.total) as total
    FROM REJUNTE_SA.Factura F
    group by
        F.id_sucursal,
        F.id_cliente,
        REJUNTE_SA.obtener_id_tiempo(F.fecha),
        REJUNTE_SA.obtener_id_turno(F.fecha)
END

GO
CREATE PROCEDURE REJUNTE_SA.migrar_bi_pedido AS
BEGIN
    INSERT INTO REJUNTE_SA.BI_pedido(id_sucursal, id_cliente, id_tiempo, id_estado_pedido, id_modelo, id_turno_venta, cantidad, total)
    SELECT
        p.id_sucursal,
        p.id_cliente,
        REJUNTE_SA.obtener_id_tiempo(p.fecha) as id_tiempo,
        p.id_estado_pedido,
        s.id_modelo,
        REJUNTE_SA.obtener_id_turno(p.fecha) as id_turno_venta,
        count(p.id) as cantidad,
        sum(p.total) as total
    FROM REJUNTE_SA.Pedido p
    inner join REJUNTE_SA.Detalle_Pedido DP on p.id = DP.id_pedido
    inner join REJUNTE_SA.Sillon S on S.id = DP.id_sillon
    group by
        id_sucursal,
        id_cliente,
        REJUNTE_SA.obtener_id_tiempo(p.fecha),
        p.id_estado_pedido,
        s.id_modelo,
        REJUNTE_SA.obtener_id_turno(p.fecha)
END

GO
CREATE PROCEDURE REJUNTE_SA.migrar_bi_compra AS
BEGIN
    INSERT INTO REJUNTE_SA.BI_compra (id_sucursal, id_material_tipo, id_tiempo, cantidad, total)
    SELECT
        c.id_sucursal,
        M.id_material_tipo,
        REJUNTE_SA.obtener_id_tiempo(fecha) AS id_tiempo,
        count(distinct c.id) as cantidad,
        sum(total) as total
    FROM REJUNTE_SA.Compra c
    inner join REJUNTE_SA.Detalle_Compra DC on c.id = DC.id_compra
    inner join REJUNTE_SA.Material M on DC.id_material = M.id
    group by c.id_sucursal,  M.id_material_tipo, REJUNTE_SA.obtener_id_tiempo(fecha)
END

GO
CREATE PROCEDURE REJUNTE_SA.migrar_bi_envio AS
BEGIN
    INSERT INTO REJUNTE_SA.BI_envio(id_cliente, id_sucursal, fecha_programada, fecha_entrega, es_fecha_entrega, cantidad, importe_traslado, importe_subida, importe_total)
    select
        F.id_cliente,
        F.id_sucursal,
        E.fecha_programada,
        E.fecha_entrega,
        REJUNTE_SA.obtener_es_fecha_cumplida(E.fecha_programada, E.fecha_entrega) AS 'es_fecha_entrega',
        count(E.id) as cantidad,
        sum(E.importe_traslado) as importe_traslado,
        sum(E.importe_subida) as importe_subida,
        sum(E.importe_total) as importe_total
    from REJUNTE_SA.Envio E
    inner join REJUNTE_SA.Factura F on F.id = e.id_factura
    group by
        F.id_cliente,
        F.id_sucursal,
        E.fecha_programada,
        E.fecha_entrega,
        REJUNTE_SA.obtener_es_fecha_cumplida(E.fecha_programada, E.fecha_entrega)
END


-- MIGRATE DIMENSION TABLES
GO
CREATE PROCEDURE REJUNTE_SA.migrar_bi_ubicacion
AS
BEGIN
    INSERT INTO REJUNTE_SA.BI_ubicacion (id, localidad, provincia)
    SELECT
        l.id,
        l.nombre,
        p.nombre
        FROM REJUNTE_SA.Localidad l
    INNER JOIN REJUNTE_SA.Provincia p
        ON p.id = l.id_provincia
END

GO
CREATE PROCEDURE REJUNTE_SA.migrar_bi_turno_venta AS
BEGIN 
  INSERT INTO REJUNTE_SA.BI_turno_venta (horario_inicio, horario_fin) VALUES
    ('08:00:00', '14:00:00'),
    ('14:00:01', '20:00:00');

END 

GO
CREATE PROCEDURE REJUNTE_SA.migrar_bi_tiempo AS 
BEGIN 
    INSERT INTO REJUNTE_SA.BI_tiempo (anio, mes, cuatrimestre)
    SELECT DISTINCT YEAR(f.fecha), MONTH(f.fecha), REJUNTE_SA.obtener_cuatrimestre(f.fecha)
    FROM REJUNTE_SA.Factura f
    UNION
    SELECT DISTINCT YEAR(c.fecha), MONTH(c.fecha), REJUNTE_SA.obtener_cuatrimestre(c.fecha)
    FROM REJUNTE_SA.Compra c
    UNION
    SELECT DISTINCT YEAR(fecha), MONTH(fecha), REJUNTE_SA.obtener_cuatrimestre(fecha)
    FROM REJUNTE_SA.Cancelacion_Pedido 
    UNION
    SELECT DISTINCT YEAR(e.fecha_entrega), MONTH(e.fecha_entrega), REJUNTE_SA.obtener_cuatrimestre(e.fecha_entrega)
    FROM REJUNTE_SA.Envio e
    UNION
    SELECT DISTINCT YEAR(e.fecha_programada), MONTH(e.fecha_programada), REJUNTE_SA.obtener_cuatrimestre(e.fecha_programada)
    FROM REJUNTE_SA.Envio e
    UNION
    SELECT DISTINCT YEAR(p.fecha), MONTH(p.fecha), REJUNTE_SA.obtener_cuatrimestre(p.fecha)
    FROM REJUNTE_SA.Pedido p
    ORDER BY 1,2,3 desc
END
    
GO
CREATE PROCEDURE REJUNTE_SA.migrar_bi_rango_etario AS
BEGIN 
INSERT INTO REJUNTE_SA.BI_rango_etario(edad_minima, edad_maxima) VALUES
  (0,24)
  ,(25,35)
  ,(36,50)
  ,(51,150)
END 

GO
CREATE PROCEDURE REJUNTE_SA.migrar_bi_estado_pedido AS
BEGIN 
    INSERT INTO REJUNTE_SA.BI_estado_pedido (id, descripcion)
    SELECT * FROM REJUNTE_SA.Estado_Pedido
END

GO
CREATE PROCEDURE REJUNTE_SA.migrar_bi_sucursal AS 
BEGIN 
    INSERT INTO REJUNTE_SA.BI_sucursal (id, id_datos_contacto, id_ubicacion, direccion)
    SELECT
        s.id,
        s.id_datos_contacto,
        u.id,
        s.direccion
    FROM REJUNTE_SA.Sucursal s
    JOIN REJUNTE_SA.BI_ubicacion u
        ON s.id = u.id
END


GO
CREATE PROCEDURE REJUNTE_SA.migrar_bi_modelo AS
BEGIN
   INSERT INTO REJUNTE_SA.BI_modelo(id, modelo, descripcion, precio)
    select
        M.id,
        M.modelo,
        M.descripcion,
        M.precio
    from REJUNTE_SA.Modelo M
END

GO
CREATE PROCEDURE REJUNTE_SA.migrar_bi_tipo_material AS
BEGIN
   INSERT INTO REJUNTE_SA.BI_tipo_material(id, descripcion)
    select
        MT.id,
        MT.descripcion
    from REJUNTE_SA.Material_Tipo MT
END

GO
CREATE PROCEDURE REJUNTE_SA.migrar_bi_cliente AS
BEGIN
    INSERT INTO REJUNTE_SA.BI_cliente (id, dni, nombre, apellido, id_rango_etario, direccion, id_datos_contacto, id_ubicacion)
    SELECT
        c.id,
        c.dni,
        c.nombre,
        c.apellido,
        r.id AS 'Id rango etario',
        c.direccion,
        c.id_datos_contacto,
        c.id_localidad
    FROM REJUNTE_SA.Cliente c
    JOIN REJUNTE_SA.BI_rango_etario r
        ON (YEAR(GETDATE()) - YEAR(c.fecha_nacimiento)) BETWEEN r.edad_minima AND r.edad_maxima
    ORDER BY c.id
END


-- CREATE VIEWS
GO -- 1
CREATE VIEW REJUNTE_SA.BI_ganancias AS
SELECT
    bs.id AS Sucursal,
    bt.anio AS Anio,
    bt.mes AS Mes,
--     isnull(sum(distinct bf.total), 0) AS total_facturas,
--     isnull(sum(distinct bc.total), 0) AS total_compras,
    isnull(sum(distinct bf.total), 0) - isnull(sum(distinct bc.total), 0) AS Ganancia
FROM REJUNTE_SA.BI_factura Bf
FULL JOIN REJUNTE_SA.BI_compra Bc on bc.id_sucursal = bf.id_sucursal and bc.id_tiempo = bf.id_tiempo
INNER JOIN REJUNTE_SA.BI_sucursal Bs on Bs.id = bf.id_sucursal
INNER JOIN REJUNTE_SA.BI_tiempo Bt on Bt.id = bf.id_tiempo
GROUP BY bt.anio, bt.mes, bs.id

GO -- 2
CREATE VIEW REJUNTE_SA.BI_factura_promedio_mensual AS
SELECT
    bt.anio,
    bt.cuatrimestre,
    bu.provincia,
    isnull(avg(bf.total), 0) AS factura_promedio_mensual
FROM REJUNTE_SA.BI_factura Bf
INNER JOIN REJUNTE_SA.BI_sucursal Bs ON Bf.id_sucursal = Bs.id
INNER JOIN REJUNTE_SA.BI_ubicacion Bu ON Bu.id = Bs.id_ubicacion
INNER JOIN REJUNTE_SA.BI_tiempo Bt ON Bf.id_tiempo = Bt.id
GROUP BY bt.anio, bt.cuatrimestre, bu.provincia

GO -- 3
CREATE VIEW REJUNTE_SA.BI_rendimiento_de_modelos AS
WITH Rendimiento_Modelos AS (
    SELECT
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
    RM.anio,
    RM.cuatrimestre,
    RM.localidad,
    RM.rango_etario,
    RM.id_modelo,
    RM.total
FROM Rendimiento_Modelos RM
WHERE RM.ranking <= 3

GO -- 4
CREATE VIEW REJUNTE_SA.BI_volumen_pedidos AS
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

GO -- 5
CREATE VIEW REJUNTE_SA.BI_conversion_de_pedidos AS
    SELECT 1 as test

GO -- 6 PENDIENTE
CREATE VIEW REJUNTE_SA.BI_tiempo_promedio_de_fabricacion AS
    SELECT 1 as test

GO -- 7
CREATE VIEW REJUNTE_SA.BI_promedio_de_compras AS
    SELECT 1 as test

GO -- 8
CREATE VIEW REJUNTE_SA.BI_compras_por_tipo_de_material AS
SELECT
    Btm.descripcion,
    Bc.id_sucursal,
    Bt.cuatrimestre,
    sum(Bc.total) as total
FROM REJUNTE_SA.BI_compra Bc
INNER JOIN REJUNTE_SA.BI_tiempo Bt on Bt.id = Bc.id_tiempo
inner join REJUNTE_SA.BI_tipo_material Btm on Btm.id = Bc.id_material_tipo
group by Btm.descripcion, Bc.id_sucursal, Bt.cuatrimestre

GO -- 9
CREATE VIEW REJUNTE_SA.BI_porcentaje_de_cumplimiento_de_envios AS
    SELECT 1 as test

GO -- 10
CREATE VIEW REJUNTE_SA.BI_localidades_que_pagan_mayor_costo_de_envio AS
select
    top 3
    Bu.localidad,
    cast(avg(be.importe_total) as decimal(18,2)) as promedio_envio_total
from REJUNTE_SA.BI_envio Be
inner join REJUNTE_SA.BI_cliente Bc on Bc.id = Be.id_cliente
inner join REJUNTE_SA.BI_ubicacion Bu on Bc.id_ubicacion = Bu.id
group by Bu.localidad
order by promedio_envio_total desc


-- EXEC PROCEDURES
GO
exec REJUNTE_SA.migrar_bi_ubicacion
GO
exec REJUNTE_SA.migrar_bi_tiempo
GO
exec REJUNTE_SA.migrar_bi_turno_venta
GO
exec REJUNTE_SA.migrar_bi_rango_etario
GO
exec REJUNTE_SA.migrar_bi_estado_pedido
GO
exec REJUNTE_SA.migrar_bi_sucursal
GO
exec REJUNTE_SA.migrar_bi_modelo
GO
exec REJUNTE_SA.migrar_bi_tipo_material
GO
exec REJUNTE_SA.migrar_bi_cliente
GO
exec REJUNTE_SA.migrar_bi_factura
GO
exec REJUNTE_SA.migrar_bi_compra
GO
exec REJUNTE_SA.migrar_bi_envio
GO
exec REJUNTE_SA.migrar_bi_pedido


-- SELECT VIEWS

-- 1
-- select *
-- from REJUNTE_SA.BI_ganancias Bg;
-- 2
-- select *
-- from REJUNTE_SA.BI_factura_promedio_mensual Bfpm;
-- 3
-- select *
-- from REJUNTE_SA.BI_rendimiento_de_modelos Brdm;
-- 4
-- select *
-- from REJUNTE_SA.BI_volumen_pedidos Bvp;
-- 5
-- select *
-- from REJUNTE_SA.BI_conversion_de_pedidos Bcdp;
-- 6
-- select *
-- from REJUNTE_SA.BI_tiempo_promedio_de_fabricacion Btpdf;
-- 7
-- select *
-- from REJUNTE_SA.BI_promedio_de_compras Bpdc;
-- 8
-- select *
-- from REJUNTE_SA.BI_compras_por_tipo_de_material Bcptdm;
-- 9
-- select *
-- from REJUNTE_SA.BI_porcentaje_de_cumplimiento_de_envios Bpdcde;
-- 10
-- select *
-- from REJUNTE_SA.BI_localidades_que_pagan_mayor_costo_de_envio Blqpmcde;