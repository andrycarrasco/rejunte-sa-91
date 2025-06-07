-- TODO: Agregar scripts iniciales para limpiar la base

-- Create Tables
GO
CREATE TABLE REJUNTE_SA.BI_ubicacion(
    id_localidad BIGINT,
    nombre NVARCHAR(255),
    PRIMARY KEY (id_localidad)
)

CREATE TABLE REJUNTE_SA.BI_turno_venta (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    horario_inicio TIME, 
    horario_fin TIME
)
-- Create Procedures
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

CREATE PROCEDURE REJUNTE_SA.migrar_bi_turno_venta AS
BEGIN 
  INSERT INTO REJUNTE_SA.BI_turno_venta (horario_inicio, horario_fin) VALUES
    ('08:00:00', '14:00:00'),
    ('14:00:01', '20:00:00');

END 
-- Create Views


-- Exec Procedures
GO
exec REJUNTE_SA.migrar_bi_ubicacion
