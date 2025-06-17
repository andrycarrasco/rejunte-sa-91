-- CREATE FACTS TABLES
GO
CREATE TABLE REJUNTE_SA.BI_factura (
    id_sucursal BIGINT,
    id_tiempo BIGINT,
    id_cliente BIGINT,
    id_turno_venta BIGINT,
    total decimal (38,2)
)

GO
CREATE TABLE REJUNTE_SA.BI_pedido (
    id_sucursal BIGINT,
    id_cliente BIGINT,
    id_tiempo BIGINT,
    id_estado_pedido BIGINT,
    id_modelo BIGINT,
    -- id_turno_venta BIGINT,
    total decimal(18,2),
)

GO
CREATE TABLE REJUNTE_SA.BI_compra (
    id_sucursal BIGINT,
    id_cliente BIGINT,
    id_tiempo BIGINT,
    total decimal(38,2)
)

GO
CREATE TABLE REJUNTE_SA.BI_envio(
    id_cliente BIGINT,
    id_sucursal BIGINT,
    fecha_programada DATETIME2(6),
    fecha_entrega DATETIME2(6),
    es_fecha_entrega BIT,
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

GO
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

-- COMPRA FKs
ALTER TABLE REJUNTE_SA.BI_compra
ADD FOREIGN KEY (id_sucursal) REFERENCES REJUNTE_SA.BI_sucursal(id);
ALTER TABLE REJUNTE_SA.BI_compra
ADD FOREIGN KEY (id_cliente) REFERENCES REJUNTE_SA.BI_cliente(id);
ALTER TABLE REJUNTE_SA.BI_compra
ADD FOREIGN KEY (id_tiempo) REFERENCES REJUNTE_SA.BI_tiempo(id);

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
CREATE FUNCTION REJUNTE_SA.obtenerCuatrimestre(@fecha DATETIME2(6))
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
      WHERE anio = YEAR(@fecha) AND mes = MONTH(@fecha) AND cuatrimestre = REJUNTE_SA.obtenerCuatrimestre(@fecha)
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


-- CREATE PROCEDURES
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
    SELECT DISTINCT YEAR(f.fecha), MONTH(f.fecha), REJUNTE_SA.obtenerCuatrimestre(f.fecha)
    FROM REJUNTE_SA.Factura f
    UNION
    SELECT DISTINCT YEAR(c.fecha), MONTH(c.fecha), REJUNTE_SA.obtenerCuatrimestre(c.fecha)
    FROM REJUNTE_SA.Compra c
    UNION
    SELECT DISTINCT YEAR(fecha), MONTH(fecha), REJUNTE_SA.obtenerCuatrimestre(fecha)
    FROM REJUNTE_SA.Cancelacion_Pedido 
    UNION
    SELECT DISTINCT YEAR(e.fecha_entrega), MONTH(e.fecha_entrega), REJUNTE_SA.obtenerCuatrimestre(e.fecha_entrega)
    FROM REJUNTE_SA.Envio e
    UNION
    SELECT DISTINCT YEAR(e.fecha_programada), MONTH(e.fecha_programada), REJUNTE_SA.obtenerCuatrimestre(e.fecha_programada)
    FROM REJUNTE_SA.Envio e
    UNION
    SELECT DISTINCT YEAR(p.fecha), MONTH(p.fecha), REJUNTE_SA.obtenerCuatrimestre(p.fecha)
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
CREATE PROCEDURE REJUNTE_SA.migrar_bi_factura AS 
BEGIN
    INSERT INTO REJUNTE_SA.BI_factura (id, id_sucursal, id_cliente, id_tiempo, id_turno_venta, total)
    SELECT
        id,
        id_sucursal,
        id_cliente,
        REJUNTE_SA.obtener_id_tiempo(fecha) AS 'id_tiempo',
        REJUNTE_SA.obtener_id_turno(fecha) AS 'id_turno_venta',
        total
    FROM REJUNTE_SA.Factura
    ORDER BY id
END

GO
CREATE PROCEDURE REJUNTE_SA.migrar_bi_compra AS
BEGIN 
    INSERT INTO REJUNTE_SA.BI_compra (id, id_sucursal, id_proveedor, id_tiempo, total)
    SELECT
        id,
        id_sucursal,
        id_proveedor,
        REJUNTE_SA.obtener_id_tiempo(fecha) AS 'id_tiempo',
        total
    FROM REJUNTE_SA.Compra c
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
CREATE PROCEDURE REJUNTE_SA.migrar_bi_envio AS
BEGIN
   INSERT INTO REJUNTE_SA.BI_envio(id, id_factura, fecha_programada, fecha_entrega, importe_traslado, importe_subida, importe_total)
    select
        E.id,
        E.id_factura,
        E.fecha_programada,
        E.fecha_entrega,
        E.importe_traslado,
        E.importe_subida,
        E.importe_total
    from REJUNTE_SA.Envio E
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
        c.id
    FROM REJUNTE_SA.Cliente c
    JOIN REJUNTE_SA.BI_rango_etario r
        ON (YEAR(GETDATE()) - YEAR(c.fecha_nacimiento)) BETWEEN r.edad_minima AND r.edad_maxima
    ORDER BY c.id
END

GO
CREATE PROCEDURE REJUNTE_SA.migrar_bi_pedido AS
BEGIN
    INSERT INTO REJUNTE_SA.BI_pedido(id, id_sucursal, id_cliente, id_tiempo, id_turno_venta, total, id_estado_pedido)
    SELECT
        p.id,
        p.id_sucursal,
        p.id_cliente,
        REJUNTE_SA.obtener_id_tiempo(p.fecha),
        REJUNTE_SA.obtener_id_turno(p.fecha),
        p.total,
        p.id_estado_pedido
    FROM REJUNTE_SA.Pedido p
END


-- CREATE VIEWS
GO -- 1
CREATE VIEW REJUNTE_SA.BI_ganancias AS
SELECT
    suc.id AS Sucursal,
    tiempo.anio as Anio,
    tiempo.mes as MES,
    ISNULL(fact.total_facturas, 0) - ISNULL(comp.total_compras, 0) AS Ganancia
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

GO -- 2
CREATE VIEW REJUNTE_SA.BI_factura_promedio_mensual AS
SELECT
    Bt.anio AS anio,
    Bt.cuatrimestre AS cuatrimestre,
    Bu.provincia AS provincia,
    COUNT(*) AS cantidad_facturas,
    SUM(bf.total) AS total_importe,
    SUM(bf.total) * 1.0 / COUNT(*) AS factura_promedio_mensual
FROM
    REJUNTE_SA.BI_factura Bf
INNER JOIN
    REJUNTE_SA.BI_sucursal Bs ON bs.id = bf.id_sucursal
INNER JOIN
    REJUNTE_SA.BI_ubicacion Bu ON BU.id = BS.id_ubicacion
INNER JOIN
    REJUNTE_SA.BI_tiempo Bt ON Bt.id = BF.id_tiempo
GROUP BY
    Bt.anio,
    Bt.cuatrimestre,
    Bu.provincia;

GO -- 3
CREATE VIEW REJUNTE_SA.BI_rendimiento_de_modelos AS
    SELECT 1 as test

GO -- 4
CREATE VIEW REJUNTE_SA.BI_volumen_pedidos AS
SELECT
    s.id as 'sucursal',
    t.anio,
    t.mes,
    tv.horario_inicio AS 'horario inicio turno',
    tv.horario_fin AS 'horario fin turno',
    COUNT(DISTINCT p.id) AS 'Numero de pedidos en el mes'
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

GO -- 6
CREATE VIEW REJUNTE_SA.BI_tiempo_promedio_de_fabricacion AS
    SELECT 1 as test

GO -- 7
CREATE VIEW REJUNTE_SA.BI_promedio_de_compras AS
    SELECT 1 as test

GO -- 8
CREATE VIEW REJUNTE_SA.BI_compras_por_tipo_de_material AS
    SELECT 1 as test

GO -- 9
CREATE VIEW REJUNTE_SA.BI_porcentaje_de_cumplimiento_de_envios AS
    SELECT 1 as test

GO -- 10
CREATE VIEW REJUNTE_SA.BI_localidades_que_pagan_mayor_costo_de_envio AS
    SELECT 1 as test


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
exec REJUNTE_SA.migrar_bi_factura
GO
exec REJUNTE_SA.migrar_bi_compra
GO
exec REJUNTE_SA.migrar_bi_sucursal
GO
exec REJUNTE_SA.migrar_bi_modelo
GO
exec REJUNTE_SA.migrar_bi_envio
GO
exec REJUNTE_SA.migrar_bi_tipo_material
GO
exec REJUNTE_SA.migrar_bi_cliente
GO
exec REJUNTE_SA.migrar_bi_pedido


-- SELECT VIEWS

-- select *
-- from REJUNTE_SA.BI_ganancias Bg;
--
-- select *
-- from REJUNTE_SA.BI_factura_promedio_mensual Bfpm;
--
-- select *
-- from REJUNTE_SA.BI_volumen_pedidos Bvp;
