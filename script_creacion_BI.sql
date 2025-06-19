USE GD1C2025

-- CREATE FACTS TABLES
GO
CREATE TABLE REJUNTE_SA.BI_factura (
    id_sucursal BIGINT,
    id_tiempo BIGINT,
    id_cliente BIGINT,
    id_turno_venta BIGINT,
    fecha DATETIME2(6),
    cantidad BIGINT,
    total DECIMAL (38,2)
)

GO
CREATE TABLE REJUNTE_SA.BI_pedido (
    id_sucursal BIGINT,
    id_cliente BIGINT,
    id_tiempo BIGINT,
    id_estado_pedido BIGINT,
    id_modelo BIGINT,
    id_turno_venta BIGINT,
    fecha DATETIME2(6),
    cantidad BIGINT,
    total DECIMAL(18,2),
)

GO
CREATE TABLE REJUNTE_SA.BI_compra (
    id_sucursal BIGINT,
    id_material_tipo BIGINT,
    id_tiempo BIGINT,
    cantidad BIGINT,
    total DECIMAL(38,2)
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
        WHERE CAST(@fecha AS TIME) BETWEEN horario_inicio AND horario_fin
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
    INSERT INTO REJUNTE_SA.BI_factura (id_sucursal, id_cliente, id_tiempo, id_turno_venta, fecha, cantidad, total)
    SELECT
        F.id_sucursal,
        F.id_cliente,
        REJUNTE_SA.obtener_id_tiempo(F.fecha) AS 'id_tiempo',
        REJUNTE_SA.obtener_id_turno(F.fecha) AS 'id_turno_venta',
        F.fecha,
        COUNT(DISTINCT F.id) AS cantidad,
        SUM(F.total) AS total
    FROM REJUNTE_SA.Factura F
    GROUP BY
        F.id_sucursal,
        F.id_cliente,
        F.fecha,
        REJUNTE_SA.obtener_id_tiempo(F.fecha),
        REJUNTE_SA.obtener_id_turno(F.fecha)
END

GO
CREATE PROCEDURE REJUNTE_SA.migrar_bi_pedido AS
BEGIN
    INSERT INTO REJUNTE_SA.BI_pedido(id_sucursal, id_cliente, id_tiempo, id_estado_pedido, id_modelo, id_turno_venta, fecha, cantidad, total)
    SELECT
        p.id_sucursal,
        p.id_cliente,
        REJUNTE_SA.obtener_id_tiempo(p.fecha) AS id_tiempo,
        p.id_estado_pedido,
        s.id_modelo,
        REJUNTE_SA.obtener_id_turno(p.fecha) AS id_turno_venta,
        P.fecha,
        COUNT(p.id) AS cantidad,
        SUM(p.total) AS total
    FROM REJUNTE_SA.Pedido p
    INNER JOIN REJUNTE_SA.Detalle_Pedido DP ON p.id = DP.id_pedido
    INNER JOIN REJUNTE_SA.Sillon S ON S.id = DP.id_sillon
    GROUP BY
        id_sucursal,
        id_cliente,
        REJUNTE_SA.obtener_id_tiempo(p.fecha),
        p.id_estado_pedido,
        s.id_modelo,
        p.fecha,
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
        COUNT(DISTINCT c.id) AS cantidad,
        SUM(total) AS total
    FROM REJUNTE_SA.Compra c
    INNER JOIN REJUNTE_SA.Detalle_Compra DC ON c.id = DC.id_compra
    INNER JOIN REJUNTE_SA.Material M ON DC.id_material = M.id
    GROUP BY c.id_sucursal,  M.id_material_tipo, REJUNTE_SA.obtener_id_tiempo(fecha)
END

GO
CREATE PROCEDURE REJUNTE_SA.migrar_bi_envio AS
BEGIN
    INSERT INTO REJUNTE_SA.BI_envio(id_cliente, id_sucursal, fecha_programada, fecha_entrega, es_fecha_entrega, cantidad, importe_traslado, importe_subida, importe_total)
    SELECT
        F.id_cliente,
        F.id_sucursal,
        E.fecha_programada,
        E.fecha_entrega,
        REJUNTE_SA.obtener_es_fecha_cumplida(E.fecha_programada, E.fecha_entrega) AS 'es_fecha_entrega',
        COUNT(E.id) AS cantidad,
        SUM(E.importe_traslado) AS importe_traslado,
        SUM(E.importe_subida) AS importe_subida,
        SUM(E.importe_total) AS importe_total
    FROM REJUNTE_SA.Envio E
    INNER JOIN REJUNTE_SA.Factura F ON F.id = e.id_factura
    GROUP BY
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
    SELECT
        M.id,
        M.modelo,
        M.descripcion,
        M.precio
    FROM REJUNTE_SA.Modelo M
END

GO
CREATE PROCEDURE REJUNTE_SA.migrar_bi_tipo_material AS
BEGIN
   INSERT INTO REJUNTE_SA.BI_tipo_material(id, descripcion)
    SELECT
        MT.id,
        MT.descripcion
    FROM REJUNTE_SA.Material_Tipo MT
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
    ISNULL(SUM(DISTINCT bf.total), 0) - ISNULL(SUM(DISTINCT bc.total), 0) AS Ganancia
FROM REJUNTE_SA.BI_factura Bf
FULL JOIN REJUNTE_SA.BI_compra Bc ON bc.id_sucursal = bf.id_sucursal AND bc.id_tiempo = bf.id_tiempo
INNER JOIN REJUNTE_SA.BI_sucursal Bs ON Bs.id = bf.id_sucursal
INNER JOIN REJUNTE_SA.BI_tiempo Bt ON Bt.id = bf.id_tiempo
GROUP BY bt.anio, bt.mes, bs.id

GO -- 2
CREATE VIEW REJUNTE_SA.BI_factura_promedio_mensual AS
SELECT
    bt.anio,
    bt.cuatrimestre,
    bu.provincia,
    ISNULL(AVG(bf.total), 0) AS factura_promedio_mensual
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
        CONCAT(bre.edad_minima,'-', bre.edad_maxima) AS rango_etario,
        ROW_NUMBER() OVER (
                PARTITION BY bt.anio, bt.cuatrimestre, bu.id, bu.localidad, bre.id, bre.edad_maxima, bre.edad_minima
                ORDER BY SUM(BP.total) DESC
            ) AS ranking,
        SUM(BP.total) AS total
    FROM REJUNTE_SA.BI_pedido Bp
    INNER JOIN REJUNTE_SA.BI_tiempo Bt ON Bp.id_tiempo = Bt.id
    INNER JOIN REJUNTE_SA.BI_sucursal Bs ON Bp.id_sucursal = Bs.id
    INNER JOIN REJUNTE_SA.BI_ubicacion Bu ON Bu.id = Bs.id_ubicacion
    INNER JOIN REJUNTE_SA.BI_cliente Bc ON Bp.id_cliente = Bc.id
    INNER JOIN REJUNTE_SA.BI_rango_etario Bre ON Bc.id_rango_etario = Bre.id
    GROUP BY bt.anio, bt.cuatrimestre, bu.id, bu.localidad, bre.id, bre.edad_maxima, bre.edad_minima, BP.id_modelo
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
    s.id AS 'sucursal',
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
		  AND t1.id = t.id AND t1.cuatrimestre = t.cuatrimestre
		  GROUP BY t1.id, t1.cuatrimestre, p1.id_sucursal
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

GO -- 6
CREATE VIEW REJUNTE_SA.BI_tiempo_promedio_de_fabricacion AS
SELECT
    Bp.id_sucursal,
    bt.cuatrimestre,
    AVG(DATEDIFF(DAY, bp.fecha, bf.fecha)) AS dias_fabricacion
FROM REJUNTE_SA.BI_pedido Bp
INNER JOIN REJUNTE_SA.BI_factura Bf
    ON Bp.id_sucursal = Bf.id_sucursal
           AND bp.id_cliente = bf.id_cliente
           AND bp.id_tiempo = bf.id_tiempo
INNER JOIN REJUNTE_SA.BI_tiempo Bt
    ON Bp.id_tiempo = Bt.id
GROUP BY Bp.id_sucursal, bt.cuatrimestre

GO -- 7
CREATE VIEW REJUNTE_SA.BI_promedio_de_compras AS
SELECT
    t.anio,
    t.mes,
    CAST(AVG(c.total) AS decimal(18, 2)) AS 'Promedio de compras por mes'
FROM
    REJUNTE_SA.BI_compra c
    JOIN REJUNTE_SA.BI_tiempo t ON c.id_tiempo = t.id
GROUP BY
    t.anio,
    t.mes

GO -- 8
CREATE VIEW REJUNTE_SA.BI_compras_por_tipo_de_material AS
SELECT
    Btm.descripcion,
    Bc.id_sucursal,
    Bt.cuatrimestre,
    SUM(Bc.total) AS total
FROM REJUNTE_SA.BI_compra Bc
INNER JOIN REJUNTE_SA.BI_tiempo Bt ON Bt.id = Bc.id_tiempo
INNER JOIN REJUNTE_SA.BI_tipo_material Btm ON Btm.id = Bc.id_material_tipo
GROUP BY Btm.descripcion, Bc.id_sucursal, Bt.cuatrimestre

GO -- 9
CREATE VIEW REJUNTE_SA.BI_porcentaje_de_cumplimiento_de_envios AS
    SELECT 1 AS test

GO -- 10
CREATE VIEW REJUNTE_SA.BI_localidades_que_pagan_mayor_costo_de_envio AS
SELECT
    top 3
    Bu.localidad,
    CAST(AVG(be.importe_total) AS decimal(18,2)) AS promedio_envio_total
FROM REJUNTE_SA.BI_envio Be
INNER JOIN REJUNTE_SA.BI_cliente Bc ON Bc.id = Be.id_cliente
INNER JOIN REJUNTE_SA.BI_ubicacion Bu ON Bc.id_ubicacion = Bu.id
GROUP BY Bu.localidad
ORDER BY promedio_envio_total DESC


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
-- SELECT *
-- FROM REJUNTE_SA.BI_ganancias Bg;
-- 2
-- SELECT *
-- FROM REJUNTE_SA.BI_factura_promedio_mensual Bfpm;
-- 3
-- SELECT *
-- FROM REJUNTE_SA.BI_rendimiento_de_modelos Brdm;
-- 4
-- SELECT *
-- FROM REJUNTE_SA.BI_volumen_pedidos Bvp;
-- 5
-- SELECT *
-- FROM REJUNTE_SA.BI_conversion_de_pedidos Bcdp;
-- 6
-- SELECT *
-- FROM REJUNTE_SA.BI_tiempo_promedio_de_fabricacion Btpdf;
-- 7
-- SELECT *
-- FROM REJUNTE_SA.BI_promedio_de_compras Bpdc;
-- 8
-- SELECT *
-- FROM REJUNTE_SA.BI_compras_por_tipo_de_material Bcptdm;
-- 9
-- SELECT *
-- FROM REJUNTE_SA.BI_porcentaje_de_cumplimiento_de_envios Bpdcde;
-- 10
-- SELECT *
-- FROM REJUNTE_SA.BI_localidades_que_pagan_mayor_costo_de_envio Blqpmcde;
