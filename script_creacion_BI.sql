-- TODO: Agregar scripts iniciales para limpiar la base

-- Create Tables
GO
CREATE TABLE REJUNTE_SA.BI_ubicacion(
    id_localidad BIGINT,
    nombre NVARCHAR(255),
    PRIMARY KEY (id_localidad)
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

-- Create Views



-- Exec Procedures
GO
exec REJUNTE_SA.migrar_bi_ubicacion
