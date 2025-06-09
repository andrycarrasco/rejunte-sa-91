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
CREATE PROCEDURE REJUNTE_SA.migrar_rango_etario AS 
BEGIN 
INSERT INTO REJUNTE_SA.BI_rango_etario(edad_minima, edad_maxima) VALUES
  (0,25)
  ,(25,35)
  ,(35,50)
  ,(50,150)
END 
-- Create Views


-- Exec Procedures
GO
exec REJUNTE_SA.migrar_bi_ubicacion
GO
exec REJUNTE_SA.migrar_bi_tiempo
GO
exec REJUNTE_SA.migrar_bi_rango_etario
