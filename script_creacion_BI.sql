-- TODO: Agregar scripts iniciales para limpiar la base

-- Create Tables
GO
CREATE TABLE REJUNTE_SA.BI_ubicacion(
    id_localidad BIGINT,
    nombre NVARCHAR(255),
    PRIMARY KEY (id_localidad)
)

GO
CREATE TABLE REJUNTE_SA.BI_turno_venta (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    horario_inicio TIME, 
    horario_fin TIME
)

GO
CREATE TABLE REJUNTE_SA.BI_tiempo (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    anio INT,
    mes INT,
    cuatrimestre INT
)

GO 
CREATE TABLE REJUNTE_SA.BI_rango_etario (
  id BIGINT IDENTITY(1,1) PRIMARY KEY,
  edad_minima INT,
  edad_maxima INT
)
    
GO
CREATE TABLE REJUNTE_SA.BI_estado_pedido (
    id BIGINT PRIMARY KEY,
    descripcion NVARCHAR(255)
)

GO
CREATE TABLE REJUNTE_SA.BI_factura (
    id BIGINT PRIMARY KEY,
    id_sucursal BIGINT,
    id_cliente BIGINT,
    id_tiempo BIGINT,
    id_turno_venta BIGINT,
    total decimal (38,2)
)
    
GO
CREATE TABLE REJUNTE_SA.BI_compra (
    id DECIMAL(18, 0) PRIMARY KEY,
    id_sucursal BIGINT,
    id_proveedor BIGINT,
    id_tiempo BIGINT,
    total decimal(38,2)
)
    
GO
CREATE TABLE REJUNTE_SA.BI_sucursal (
    id BIGINT PRIMARY KEY,
    id_datos_contacto BIGINT,
    id_ubicacion BIGINT,
    direccion NVARCHAR(255)
)

GO
CREATE TABLE REJUNTE_SA.BI_tipo_material(
    id BIGINT PRIMARY KEY,
    descripcion NVARCHAR(255)
)

GO
CREATE TABLE REJUNTE_SA.BI_envio(
    id decimal(18,0) PRIMARY KEY,
    id_factura BIGINT,
    fecha_programada DATETIME2(6),
    fecha_entrega DATETIME2(6),
    importe_traslado DECIMAL(18, 2),
    importe_subida DECIMAL(18, 2),
    importe_total DECIMAL(18, 2)
)

GO
CREATE TABLE REJUNTE_SA.BI_modelo(
    id BIGINT PRIMARY KEY,
    modelo NVARCHAR(255),
    descripcion NVARCHAR(255),
    precio DECIMAL(18, 2)
)

--utils 
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



-- Create Procedures migracion
GO
CREATE PROCEDURE REJUNTE_SA.migrar_bi_ubicacion
AS
BEGIN
    INSERT INTO REJUNTE_SA.BI_UBICACION(id_localidad, nombre)
    SELECT
        L.id,
        L.nombre
    from REJUNTE_SA.Localidad L;
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
      (0,25)
      ,(25,35)
      ,(35,50)
      ,(50,150)
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
        u.id_localidad,
        s.direccion
    FROM REJUNTE_SA.Sucursal s
    JOIN REJUNTE_SA.BI_ubicacion u
        ON s.id_localidad = u.id_localidad
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


-- Create Views


-- Exec Procedures
GO
exec REJUNTE_SA.migrar_bi_ubicacion
GO
exec REJUNTE_SA.migrar_bi_tiempo
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