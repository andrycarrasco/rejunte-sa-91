USE GD1C2025 
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'REJUNTE_SA')
BEGIN 
	EXEC ('CREATE SCHEMA REJUNTE_SA AUTHORIZATION dbo')
END
GO

-- Borra todas las FKs
GO
DECLARE @sql NVARCHAR(MAX) = N'';
SELECT @sql += N'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) +
    ' DROP CONSTRAINT ' + QUOTENAME(name) + ';'
FROM sys.foreign_keys;
EXEC sp_executesql @sql;

-- Borra todas las tablas en el esquema REJUNTESA
GO
DECLARE @dropTableSQL NVARCHAR(MAX) = N'';
SELECT @dropTableSQL += 'DROP TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(object_id)) + '.' + QUOTENAME(name) + '; '
FROM sys.tables
WHERE SCHEMA_NAME(schema_id) = 'REJUNTE_SA';
EXEC sp_executesql @dropTableSQL;

-- INICIO: DROP SPs
GO
IF EXISTS(	select
		*
	from sys.sysobjects
	where xtype = 'P' and name like 'migrar_%'
	)
	BEGIN

	PRINT 'Existen procedures de una ejecucion pasada'
	PRINT 'Se procede a borrarlos...'
	DECLARE @sql NVARCHAR(MAX) = N'';
	SELECT @sql += N'
	DROP PROCEDURE [REJUNTE_SA].'
	  + QUOTENAME(name) + ';'
	FROM sys.sysobjects
	WHERE xtype = 'P' and name like '%migrar_%'
	--PRINT @sql;
	EXEC sp_executesql @sql
	END
-- FIN: DROP SPs


-- INICIO: DROP Functions
GO
IF EXISTS (
    SELECT *
    FROM sys.objects
    WHERE type IN ('FN', 'IF', 'TF')
)
BEGIN
    PRINT 'Existen funciones de una ejecución pasada'
    PRINT 'Se procede a borrarlas...'
    DECLARE @sql NVARCHAR(MAX) = N'';
    SELECT @sql += N'
    DROP FUNCTION ' + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(name) + ';'
    FROM sys.objects
    WHERE type IN ('FN', 'IF', 'TF')
    --PRINT @sql;
    EXEC sp_executesql @sql;
END
-- FIN: DROP Functions


-- INICIO: DROP Views
GO
IF EXISTS (
    SELECT *
    FROM sys.objects
    WHERE type = 'V'
)
BEGIN
    PRINT 'Existen vistas de una ejecución pasada'
    PRINT 'Se procede a borrarlas...'
    DECLARE @sql NVARCHAR(MAX) = N'';
    SELECT @sql += N'
    DROP VIEW ' + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(name) + ';'
    FROM sys.objects
    WHERE type = 'V';
    --PRINT @sql;
    EXEC sp_executesql @sql;
END
-- FIN: DROP Views

--TABLES

-- ok
CREATE TABLE REJUNTE_SA.DatosContacto (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    telefono NVARCHAR(255),
    mail NVARCHAR(255)
)
GO

-- ok
CREATE TABLE REJUNTE_SA.Localidad (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    id_provincia BIGINT,
    nombre NVARCHAR(255)
)
GO

-- ok
CREATE TABLE REJUNTE_SA.Provincia (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(255)
)
GO

-- ok
CREATE TABLE REJUNTE_SA.Proveedor (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    razon_social NVARCHAR(255),
    cuit NVARCHAR(255),
    direccion NVARCHAR(255),
    id_datos_contacto BIGINT,
    id_localidad BIGINT
)
GO

-- ok
CREATE TABLE REJUNTE_SA.Cliente (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    dni BIGINT UNIQUE,
    nombre NVARCHAR(255),
    apellido NVARCHAR(255),
    fecha_nacimiento DATETIME2(6),
    direccion NVARCHAR(255),
    id_datos_contacto BIGINT,
    id_localidad BIGINT
)
GO

-- ok
CREATE TABLE REJUNTE_SA.Sucursal (
    id BIGINT PRIMARY KEY,
    id_datos_contacto BIGINT,
    id_localidad BIGINT,
    direccion NVARCHAR(255)
)
GO

-- ok
CREATE TABLE REJUNTE_SA.Compra (
    id DECIMAL(18, 0) PRIMARY KEY,
    id_sucursal BIGINT,
    id_proveedor BIGINT,
    fecha DATETIME2(6),
    total DECIMAL(18, 2)
)
GO

-- ok
CREATE TABLE REJUNTE_SA.Material (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    id_material_tipo BIGINT,
    nombre NVARCHAR(255),
    descripcion NVARCHAR(255),
    precio DECIMAL(38, 2)
)
GO

-- ok
CREATE TABLE REJUNTE_SA.DetalleCompra (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    id_compra DECIMAL(18, 0),
    id_material BIGINT,
    precio DECIMAL(18, 2),
    cantidad DECIMAL(18, 0),
    subtotal DECIMAL(18, 2)
)
GO

-- ok
CREATE TABLE REJUNTE_SA.Pedido (
    id DECIMAL(18, 0) PRIMARY KEY,
    id_sucursal BIGINT,
    id_cliente BIGINT,
    fecha DATETIME2(6),
    total DECIMAL(18, 2),
    id_estado_pedido BIGINT
)
GO

-- ok
CREATE TABLE REJUNTE_SA.EstadoPedido (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    descripcion NVARCHAR(255)
)
GO

-- ok
CREATE TABLE REJUNTE_SA.CancelacionPedido (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    id_pedido DECIMAL(18, 0),
    fecha DATETIME2(6),
    motivo VARCHAR(255)
)
GO

-- ok
CREATE TABLE REJUNTE_SA.DetallePedido (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    id_pedido DECIMAL(18, 0),
    id_sillon BIGINT,
    cantidad BIGINT,
    precio DECIMAL(18, 2),
    subtotal DECIMAL(18, 2),
)
GO

-- ok
CREATE TABLE REJUNTE_SA.Factura (
    id BIGINT PRIMARY KEY,
    id_sucursal BIGINT,
    id_cliente BIGINT,
    fecha DATETIME2(6),
    total DECIMAL(38, 2)
)
GO

-- ok
CREATE TABLE REJUNTE_SA.Envio (
    id decimal(18,0) PRIMARY KEY,
    id_factura BIGINT,
    fecha_programada DATETIME2(6),
    fecha_entrega DATETIME2(6),
    importe_traslado DECIMAL(18, 2),
    importe_subida DECIMAL(18, 2)
)
GO

-- ok
CREATE TABLE REJUNTE_SA.DetalleFactura (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    id_factura BIGINT,
    id_detalle_pedido BIGINT,
    precio DECIMAL(18, 2),
    cantidad DECIMAL(18, 0),
    sub_total DECIMAL(18, 2)
)
GO

-- ok
CREATE TABLE REJUNTE_SA.Modelo (
    id BIGINT PRIMARY KEY,
    modelo NVARCHAR(255),
    descripcion NVARCHAR(255),
    precio DECIMAL(18, 2)
)
GO

-- ok
CREATE TABLE REJUNTE_SA.Medida (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    alto DECIMAL(18, 2),
    ancho DECIMAL(18, 2),
    profundidad DECIMAL(18, 2),
    precio DECIMAL(18, 2)
)
GO

-- ok
CREATE TABLE REJUNTE_SA.Tela (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    id_material BIGINT,
    id_color BIGINT,
    id_textura BIGINT
)
GO

CREATE TABLE REJUNTE_SA.Textura (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    descripcion NVARCHAR(255)
)
GO

-- ok
CREATE TABLE REJUNTE_SA.Relleno (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    id_material BIGINT,
    id_densidad BIGINT
)
GO

CREATE TABLE REJUNTE_SA.Densidad (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    densidad DECIMAL(38,2)
)
GO

-- ok
CREATE TABLE REJUNTE_SA.Madera (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    id_material BIGINT,
    id_color BIGINT,
    id_dureza BIGINT
)
GO

CREATE TABLE REJUNTE_SA.Dureza (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    descripcion NVARCHAR(255)
)
GO

-- ok
CREATE TABLE REJUNTE_SA.Sillon (
    id BIGINT PRIMARY KEY,
    id_modelo BIGINT,
    id_medida BIGINT,
    id_madera BIGINT,
    id_tela BIGINT, 
    id_relleno BIGINT
)
GO

-- ok
CREATE TABLE REJUNTE_SA.MaterialTipo (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    descripcion NVARCHAR(255)
)
GO

-- ok
CREATE TABLE REJUNTE_SA.Color (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    descripcion NVARCHAR(255)
)
GO


--FOREIGN KEYS
ALTER TABLE REJUNTE_SA.Localidad
ADD FOREIGN KEY (id_provincia) REFERENCES REJUNTE_SA.Provincia(id);

ALTER TABLE REJUNTE_SA.Proveedor
ADD FOREIGN KEY (id_datos_contacto) REFERENCES REJUNTE_SA.DatosContacto(id);
ALTER TABLE REJUNTE_SA.Proveedor
ADD FOREIGN KEY (id_localidad) REFERENCES REJUNTE_SA.Localidad(id);

ALTER TABLE REJUNTE_SA.Cliente
ADD FOREIGN KEY (id_datos_contacto) REFERENCES REJUNTE_SA.DatosContacto(id);
ALTER TABLE REJUNTE_SA.Cliente
ADD FOREIGN KEY (id_localidad) REFERENCES REJUNTE_SA.Localidad(id);


ALTER TABLE REJUNTE_SA.Sucursal
ADD FOREIGN KEY (id_datos_contacto) REFERENCES REJUNTE_SA.DatosContacto(id);
ALTER TABLE REJUNTE_SA.Sucursal
ADD FOREIGN KEY (id_localidad) REFERENCES REJUNTE_SA.Localidad(id);

ALTER TABLE REJUNTE_SA.Compra
ADD FOREIGN KEY (id_sucursal) REFERENCES REJUNTE_SA.Sucursal(id);
ALTER TABLE REJUNTE_SA.Compra
ADD FOREIGN KEY (id_proveedor) REFERENCES REJUNTE_SA.Proveedor(id);

ALTER TABLE REJUNTE_SA.DetalleCompra
ADD FOREIGN KEY (id_compra) REFERENCES REJUNTE_SA.Compra(id);
ALTER TABLE REJUNTE_SA.DetalleCompra
ADD FOREIGN KEY (id_material) REFERENCES REJUNTE_SA.Material(id);

ALTER TABLE REJUNTE_SA.Pedido
ADD FOREIGN KEY (id_sucursal) REFERENCES REJUNTE_SA.Sucursal(id);
ALTER TABLE REJUNTE_SA.Pedido
ADD FOREIGN KEY (id_cliente) REFERENCES REJUNTE_SA.Cliente(id);
ALTER TABLE REJUNTE_SA.Pedido
ADD FOREIGN KEY (id_estado_pedido) REFERENCES REJUNTE_SA.EstadoPedido(id);

ALTER TABLE REJUNTE_SA.CancelacionPedido
ADD FOREIGN KEY (id_pedido) REFERENCES REJUNTE_SA.Pedido(id);

ALTER TABLE REJUNTE_SA.DetallePedido
ADD FOREIGN KEY (id_pedido) REFERENCES REJUNTE_SA.Pedido(id);
ALTER TABLE REJUNTE_SA.DetallePedido
ADD FOREIGN KEY (id_sillon) REFERENCES REJUNTE_SA.Sillon(id);


ALTER TABLE REJUNTE_SA.Factura
ADD FOREIGN KEY (id_sucursal) REFERENCES REJUNTE_SA.Sucursal(id);
ALTER TABLE REJUNTE_SA.Factura
ADD FOREIGN KEY (id_cliente) REFERENCES REJUNTE_SA.Cliente(id);

ALTER TABLE REJUNTE_SA.Envio
ADD FOREIGN KEY (id_factura) REFERENCES REJUNTE_SA.Factura(id);

ALTER TABLE REJUNTE_SA.DetalleFactura
ADD FOREIGN KEY (id_factura) REFERENCES REJUNTE_SA.Factura(id);
ALTER TABLE REJUNTE_SA.DetalleFactura
ADD FOREIGN KEY(id_detalle_pedido) REFERENCES REJUNTE_SA.DetallePedido(id);

ALTER TABLE REJUNTE_SA.Sillon
ADD FOREIGN KEY (id_modelo) REFERENCES REJUNTE_SA.Modelo(id);
ALTER TABLE REJUNTE_SA.Sillon
ADD FOREIGN KEY (id_medida) REFERENCES REJUNTE_SA.Medida(id);
ALTER TABLE REJUNTE_SA.Sillon
ADD FOREIGN KEY (id_madera) REFERENCES REJUNTE_SA.Madera(id);
ALTER TABLE REJUNTE_SA.Sillon
ADD FOREIGN KEY (id_tela) REFERENCES REJUNTE_SA.Tela(id);
ALTER TABLE REJUNTE_SA.Sillon
ADD FOREIGN KEY (id_relleno) REFERENCES REJUNTE_SA.Relleno(id);

ALTER TABLE REJUNTE_SA.Tela
ADD FOREIGN KEY(id_material) REFERENCES REJUNTE_SA.Material(id);
ALTER TABLE REJUNTE_SA.Tela
ADD FOREIGN KEY(id_color) REFERENCES REJUNTE_SA.Color(id);
ALTER TABLE REJUNTE_SA.Tela
ADD FOREIGN KEY(id_textura) REFERENCES REJUNTE_SA.Textura(id);

ALTER TABLE REJUNTE_SA.Madera
ADD FOREIGN KEY(id_material) REFERENCES REJUNTE_SA.Material(id);
ALTER TABLE REJUNTE_SA.Madera
ADD FOREIGN KEY(id_color) REFERENCES REJUNTE_SA.Color(id);
ALTER TABLE REJUNTE_SA.Madera
ADD FOREIGN KEY(id_dureza) REFERENCES REJUNTE_SA.Dureza(id);

ALTER TABLE REJUNTE_SA.Relleno
ADD FOREIGN KEY(id_material) REFERENCES REJUNTE_SA.Material(id);
ALTER TABLE REJUNTE_SA.Relleno
ADD FOREIGN KEY(id_densidad) REFERENCES REJUNTE_SA.Densidad(id);

ALTER TABLE REJUNTE_SA.Material
ADD FOREIGN KEY(id_material_tipo) REFERENCES REJUNTE_SA.MaterialTipo(id);

--Vista para migrar provincias y localidades
GO
CREATE VIEW REJUNTE_SA.VistaLugares AS
SELECT Cliente_Provincia AS Provincia,  Cliente_Localidad as Localidad FROM [GD1C2025].[gd_esquema].[Maestra] WHERE Cliente_Provincia IS NOT NULL AND Cliente_Localidad IS NOT NULL
UNION
SELECT Proveedor_Provincia, Proveedor_Localidad FROM [GD1C2025].[gd_esquema].[Maestra] WHERE Proveedor_Provincia IS NOT NULL AND Proveedor_Localidad IS NOT NULL
UNION
SELECT Sucursal_Provincia, Sucursal_Localidad FROM [GD1C2025].[gd_esquema].[Maestra] WHERE Sucursal_Provincia IS NOT NULL AND Sucursal_Localidad IS NOT NULL



--MIGRACION DE DATOS PROCEDURES
GO
CREATE PROCEDURE REJUNTE_SA.migrar_provincias AS
BEGIN
    INSERT INTO REJUNTE_SA.Provincia (nombre)
    SELECT DISTINCT Provincia FROM REJUNTE_SA.VistaLugares
END

GO
CREATE PROCEDURE REJUNTE_SA.migrar_localidades
AS
BEGIN
    INSERT INTO REJUNTE_SA.Localidad (id_provincia, nombre)
        SELECT DISTINCT
            p.id AS num_provincia,
            l.localidad
    FROM REJUNTE_SA.VistaLugares l
    JOIN REJUNTE_SA.Provincia p
        ON l.provincia = p.nombre;
END

GO
CREATE VIEW REJUNTE_SA.TelefonoMail AS
SELECT Cliente_Telefono AS telefono, Cliente_Mail AS mail
    FROM [GD1C2025].[gd_esquema].[Maestra]
    WHERE Cliente_Telefono IS NOT NULL AND Cliente_Mail IS NOT NULL
    UNION
    SELECT Proveedor_Telefono, Proveedor_Mail
    FROM [GD1C2025].[gd_esquema].[Maestra]
    WHERE Proveedor_Telefono IS NOT NULL AND Proveedor_Mail IS NOT NULL
    UNION
    SELECT Sucursal_Telefono, Sucursal_Mail
    FROM [GD1C2025].[gd_esquema].[Maestra]
    WHERE Sucursal_Telefono IS NOT NULL AND Sucursal_Mail IS NOT NULL

GO
CREATE PROCEDURE REJUNTE_SA.migrar_datos_contacto
AS
BEGIN
    INSERT INTO REJUNTE_SA.DatosContacto (telefono, mail)
    SELECT * FROM REJUNTE_SA.TelefonoMail
END

--migrar clientes
GO
CREATE PROCEDURE REJUNTE_SA.migrar_clientes
AS
BEGIN
    INSERT INTO REJUNTE_SA.Cliente (dni, nombre, apellido, fecha_nacimiento, direccion, id_datos_contacto, id_localidad)
    SELECT
        distinct
        m.Cliente_Dni,
        m.Cliente_Nombre,
        m.Cliente_Apellido,
        m.Cliente_FechaNacimiento,
        m.Cliente_Direccion,
        d.id,
        l.id AS num_localidad
    FROM [GD1C2025].[gd_esquema].[Maestra] m
    JOIN REJUNTE_SA.DatosContacto d
        ON d.telefono = m.Cliente_Telefono AND d.mail = m.Cliente_Mail
    JOIN REJUNTE_SA.Provincia p
        ON p.nombre = m.Cliente_Provincia
    JOIN REJUNTE_SA.Localidad l
        ON l.nombre = m.Cliente_Localidad AND l.id_provincia = p.id
    WHERE m.Cliente_Dni IS NOT NULL
    AND m.Cliente_Direccion IS NOT NULL
END

--migrar proveedores
GO
CREATE PROCEDURE REJUNTE_SA.migrar_proveedores
AS
BEGIN 
    INSERT INTO REJUNTE_SA.Proveedor (razon_social, cuit, direccion, id_datos_contacto, id_localidad)
    SELECT
        DISTINCT m.Proveedor_RazonSocial,
        m.Proveedor_Cuit,
        m.Proveedor_Direccion,
        d.id,
        l.id
    FROM [GD1C2025].[gd_esquema].[Maestra] m
    JOIN REJUNTE_SA.DatosContacto d
        ON d.telefono = m.Proveedor_Telefono AND d.mail = m.Proveedor_Mail
    JOIN REJUNTE_SA.Localidad l
        ON l.nombre = m.Proveedor_Localidad
    JOIN REJUNTE_SA.Provincia P
        ON P.id = L.id_provincia AND M.Proveedor_Provincia = P.nombre
    WHERE m.Proveedor_RazonSocial IS NOT NULL AND m.Proveedor_Cuit IS NOT NULL
END 

GO
CREATE PROCEDURE REJUNTE_SA.migrar_sucursales
AS
BEGIN
    INSERT INTO REJUNTE_SA.Sucursal (id, id_datos_contacto, direccion, id_localidad)
    SELECT
        DISTINCT Sucursal_NroSucursal,
        dc.id,
        Sucursal_Direccion,
        l2.id
    FROM gd_esquema.Maestra M4
    JOIN REJUNTE_SA.Provincia P ON p.nombre = M4.Sucursal_Provincia
    JOIN REJUNTE_SA.Localidad L2 ON l2.nombre = M4.Sucursal_Localidad AND L2.id_provincia = P.id
    JOIN REJUNTE_SA.DatosContacto DC ON DC.mail = M4.Sucursal_mail AND DC.telefono = M4.Sucursal_telefono
END
GO
	
--migrar estados pedido 
CREATE PROCEDURE REJUNTE_SA.migrar_estados_pedido AS
BEGIN 
INSERT INTO REJUNTE_SA.EstadoPedido (descripcion)
SELECT DISTINCT m.Pedido_Estado 
FROM [GD1C2025].[gd_esquema].[Maestra] m 
WHERE m.Pedido_Estado IS NOT NULL
END 
GO

--migrar Pedido
GO
CREATE PROCEDURE REJUNTE_SA.migrar_pedidos
AS
BEGIN

    INSERT INTO REJUNTE_SA.Pedido (nro_pedido, id_sucursal, id_cliente, fecha, total, id_estado_pedido)
        SELECT DISTINCT m.Pedido_Numero,
            s.id,
            c.id,
            m.Pedido_Fecha,
            m.Pedido_Total,
            ep.id
        FROM [GD1C2025].[gd_esquema].[Maestra] m
        JOIN REJUNTE_SA.Sucursal s
         ON s.numero_sucursal = m.Sucursal_NroSucursal AND s.direccion = m.Sucursal_Direccion 
		 JOIN REJUNTE_SA.Localidad l
		 ON l.nombre = m.Sucursal_Localidad AND l.id = s.id_localidad
		 JOIN REJUNTE_SA.Provincia p 
		 ON p.nombre = m.Sucursal_Provincia AND p.id = l.id_provincia
		 JOIN REJUNTE_SA.Cliente c
         ON c.nombre = m.Cliente_Nombre AND c.apellido = m.Cliente_Apellido AND c.dni = m.Cliente_Dni AND c.direccion = m.Cliente_Direccion 
         JOIN REJUNTE_SA.EstadoPedido ep
         ON ep.descripcion = m.Pedido_Estado
         WHERE m.Pedido_Numero IS NOT NULL AND m.Pedido_Fecha IS NOT NULL AND m.Pedido_Total IS NOT NULL
END
GO

--migrar compras
GO
CREATE PROCEDURE REJUNTE_SA.migrar_compra
AS
BEGIN
    INSERT INTO REJUNTE_SA.Compra (id, id_sucursal, id_proveedor, fecha, total)
        SELECT DISTINCT m.Compra_Numero,
            s.id,
            p.id,
            m.Compra_Fecha,
            m.Compra_Total
        FROM [GD1C2025].[gd_esquema].[Maestra] m
        JOIN REJUNTE_SA.Sucursal s
        ON s.numero_sucursal = m.Sucursal_NroSucursal
        JOIN REJUNTE_SA.Proveedor p
        ON p.razon_social = m.Proveedor_RazonSocial AND p.cuit = m.Proveedor_Cuit
        WHERE m.Compra_Numero IS NOT NULL AND m.Compra_Fecha IS NOT NULL AND m.Compra_Total IS NOT NULL
END
GO


--migrar factura 
GO
CREATE PROCEDURE REJUNTE_SA.migrar_facturas
AS
BEGIN 
    INSERT INTO REJUNTE_SA.Factura (id, id_sucursal, id_cliente, fecha, total)
    SELECT
        DISTINCT m.Factura_numero,
        s.id,
        c.id,
        m.Factura_Fecha,
        m.Factura_Total
    FROM [GD1C2025].[gd_esquema].[Maestra] m
    JOIN REJUNTE_SA.Cliente c
        ON c.nombre = m.Cliente_Nombre AND c.apellido = m.Cliente_Apellido AND C.dni = M.Cliente_Dni
    JOIN REJUNTE_SA.Sucursal s
        ON s.id = m.Sucursal_NroSucursal
    WHERE
        m.Factura_Numero IS NOT NULL AND
        m.Factura_Fecha IS NOT NULL AND
        m.Factura_Total IS NOT NULL
END


GO
CREATE PROCEDURE REJUNTE_SA.migrar_colores
AS
BEGIN
    INSERT INTO REJUNTE_SA.Color (descripcion)
        SELECT DISTINCT Tela_Color
        FROM gd_esquema.Maestra M2
        WHERE Tela_Color IS NOT NULL
        UNION
        SELECT DISTINCT Madera_Color
        FROM gd_esquema.Maestra M3
        WHERE Madera_Color IS NOT NULL
END

GO
CREATE PROCEDURE REJUNTE_SA.migrar_dureza
AS
BEGIN
    INSERT INTO REJUNTE_SA.Dureza (descripcion)
        SELECT DISTINCT Madera_Dureza
        FROM gd_esquema.Maestra M2
        WHERE Madera_Dureza IS NOT NULL
END

GO
CREATE PROCEDURE REJUNTE_SA.migrar_textura
AS
BEGIN
    INSERT INTO REJUNTE_SA.Textura (descripcion)
        SELECT DISTINCT Tela_Textura
        FROM gd_esquema.Maestra M2
        WHERE Tela_Textura IS NOT NULL
END

GO
CREATE PROCEDURE REJUNTE_SA.migrar_densidad
AS
BEGIN
    INSERT INTO REJUNTE_SA.Densidad (densidad)
        SELECT DISTINCT Relleno_Densidad
        FROM gd_esquema.Maestra M2
        WHERE Relleno_Densidad IS NOT NULL
END

GO
CREATE PROCEDURE REJUNTE_SA.migrar_material_tipo
AS
BEGIN
    INSERT INTO REJUNTE_SA.MaterialTipo (descripcion)
        SELECT DISTINCT Material_Tipo
        FROM gd_esquema.Maestra M2
        WHERE Material_Tipo IS NOT NULL
END

GO
CREATE PROCEDURE REJUNTE_SA.migrar_materiales
AS
BEGIN
    INSERT INTO REJUNTE_SA.Material (id_material_tipo, nombre, descripcion, precio)
        SELECT DISTINCT
            MT.id,
            M.Material_Nombre,
            M.Material_Descripcion,
            M.Material_Precio
        FROM [GD1C2025].[gd_esquema].[Maestra] M
        JOIN REJUNTE_SA.MaterialTipo MT ON MT.descripcion = M.Material_Tipo
        WHERE
            Material_Nombre IS NOT NULL AND
            Material_Descripcion IS NOT NULL AND
            Material_Precio IS NOT NULL
END


GO
CREATE PROCEDURE REJUNTE_SA.migrar_telas
AS
BEGIN
    INSERT INTO REJUNTE_SA.Tela (id_material, id_color, id_textura)
        SELECT DISTINCT
            M.id,
            C.id,
            T.id
        FROM [GD1C2025].[gd_esquema].[Maestra] M2
        JOIN REJUNTE_SA.Textura T ON T.descripcion = M2.Tela_Textura
        JOIN REJUNTE_SA.Color C ON C.descripcion = M2.Tela_Color
        JOIN REJUNTE_SA.Material M ON M.nombre = M2.Material_Nombre AND M.descripcion = M2.Material_Descripcion
        WHERE
            Material_Tipo = 'Tela' AND
            Material_Nombre IS NOT NULL AND
            Material_Descripcion IS NOT NULL
        GROUP BY C.id, Tela_Color, T.id, Tela_Textura, M.id, Material_Nombre, Material_Descripcion

END


GO
CREATE PROCEDURE REJUNTE_SA.migrar_maderas
AS
BEGIN
    INSERT INTO REJUNTE_SA.Madera (id_material, id_color, id_dureza)
        SELECT DISTINCT
            M.id,
            C.id,
            D.id
        FROM [GD1C2025].[gd_esquema].[Maestra] M2
        JOIN REJUNTE_SA.Dureza D ON D.descripcion = M2.Madera_Dureza
        JOIN REJUNTE_SA.Color C ON C.descripcion = M2.Madera_Color
        JOIN REJUNTE_SA.Material M ON M.nombre = M2.Material_Nombre AND M.descripcion = M2.Material_Descripcion
        WHERE
            Material_Tipo = 'Madera' AND
            Material_Nombre IS NOT NULL AND
            Material_Descripcion IS NOT NULL

END

GO
CREATE PROCEDURE REJUNTE_SA.migrar_rellenos
AS
BEGIN
    INSERT INTO REJUNTE_SA.Relleno (id_material, id_densidad)
        SELECT DISTINCT
            M.id,
            D.id
        FROM [GD1C2025].[gd_esquema].[Maestra] M2
        JOIN REJUNTE_SA.Densidad D ON D.densidad = M2.Relleno_Densidad
        JOIN REJUNTE_SA.Material M ON M.nombre = M2.Material_Nombre AND M.descripcion = M2.Material_Descripcion
        WHERE
            Material_Tipo = 'Relleno' AND
            Material_Nombre IS NOT NULL AND
            Material_Descripcion IS NOT NULL

END

GO
CREATE PROCEDURE REJUNTE_SA.migrar_modelos
AS
BEGIN
    INSERT INTO REJUNTE_SA.Modelo (id, modelo, descripcion, precio)
        SELECT DISTINCT
            M2.Sillon_Modelo_Codigo,
            M2.Sillon_Modelo,
            M2.Sillon_Modelo_Descripcion,
            M2.Sillon_Modelo_Precio
        FROM [GD1C2025].[gd_esquema].[Maestra] M2
        WHERE
            M2.Sillon_Modelo_Codigo IS NOT NULL AND
            M2.Sillon_Modelo IS NOT NULL AND
            M2.Sillon_Modelo_Descripcion IS NOT NULL
END

GO
CREATE PROCEDURE REJUNTE_SA.migrar_medidas
AS
BEGIN
    INSERT INTO REJUNTE_SA.Medida (alto, ancho, profundidad, precio)
        SELECT DISTINCT
            M2.Sillon_Medida_Alto,
            M2.Sillon_Medida_Ancho,
            M2.Sillon_Medida_Profundidad,
            M2.Sillon_Medida_Precio
        FROM [GD1C2025].[gd_esquema].[Maestra] M2
        WHERE
            M2.Sillon_Medida_Alto IS NOT NULL AND
            M2.Sillon_Medida_Ancho IS NOT NULL AND
            M2.Sillon_Medida_Profundidad IS NOT NULL
END

GO
CREATE VIEW REJUNTE_SA.VistaSillon AS
SELECT
    DISTINCT M6.Sillon_Codigo,
    M6.Sillon_Modelo_Codigo,
    M6.Sillon_Medida_Alto,
    M6.Sillon_Medida_Ancho,
    M6.Sillon_Medida_Profundidad,
    MAX(NULLIF(M6.Tela_Textura, null)) as tela_textura,
    MAX(NULLIF(M6.Tela_Color, null)) as tela_color,
    MAX(NULLIF(M6.Madera_Color, null)) as madera_color,
    MAX(NULLIF(M6.Madera_Dureza, null)) as madera_dureza,
    MAX(NULLIF(M6.Relleno_Densidad, null)) as relleno_densidad
FROM [GD1C2025].[gd_esquema].[Maestra] M6
WHERE
    M6.Sillon_Codigo IS NOT NULL AND
    M6.Sillon_Modelo_Codigo IS NOT NULL AND
    M6.Sillon_Medida_Alto IS NOT NULL AND
    M6.Sillon_Medida_Ancho IS NOT NULL AND
    M6.Sillon_Medida_Profundidad IS NOT NULL
group by
    M6.Sillon_Codigo,
    M6.Sillon_Modelo_Codigo,
    M6.Sillon_Medida_Alto,
    M6.Sillon_Medida_Ancho,
    M6.Sillon_Medida_Profundidad

GO
CREATE PROCEDURE REJUNTE_SA.migrar_sillon
AS
BEGIN
    WITH MaderaFiltrada AS (
        SELECT id, id_color, id_dureza,
               ROW_NUMBER() OVER (PARTITION BY id_color, id_dureza ORDER BY id) AS rn
        FROM REJUNTE_SA.Madera
    ),
    TelaFiltrada AS (
        SELECT id, id_color,
               ROW_NUMBER() OVER (PARTITION BY id_color ORDER BY id) AS rn
        FROM REJUNTE_SA.Tela
    ),
    RellenoFiltrado AS (
        SELECT id, id_densidad,
               ROW_NUMBER() OVER (PARTITION BY id_densidad ORDER BY id) AS rn
        FROM REJUNTE_SA.Relleno
    )
    INSERT INTO REJUNTE_SA.Sillon (id, id_modelo, id_medida, id_madera, id_tela, id_relleno)
        SELECT
            DISTINCT M.Sillon_Codigo,
            M2.id as id_modelo,
            M3.id as id_medida,
            MF.id as id_madera,
            TF.id as id_textura,
            RF.id as id_relleno
        FROM [GD1C2025].[gd_esquema].[Maestra] M
        JOIN REJUNTE_SA.VistaSillon VS on M.Sillon_Codigo = VS.Sillon_Codigo
        JOIN REJUNTE_SA.Modelo M2 ON M2.id = VS.Sillon_Modelo_Codigo
        JOIN REJUNTE_SA.Medida M3 ON M3.alto = VS.Sillon_Medida_Alto AND M3.ancho = VS.Sillon_Medida_Ancho AND M3.profundidad = VS.Sillon_Medida_Profundidad
        JOIN REJUNTE_SA.Dureza D ON D.descripcion = VS.madera_dureza
        JOIN REJUNTE_SA.Color CT ON CT.descripcion = VS.tela_color
        JOIN REJUNTE_SA.Color CM ON CM.descripcion = VS.madera_color
        JOIN REJUNTE_SA.Densidad D2 ON D2.densidad = VS.relleno_densidad
        JOIN MaderaFiltrada MF ON MF.id_dureza = D.id AND MF.id_color = CM.id AND MF.rn = 1
        JOIN TelaFiltrada TF ON TF.id_color = CT.id AND TF.rn = 1
        JOIN RellenoFiltrado RF ON RF.id_densidad = D2.id AND RF.rn = 1
        WHERE
            M.Sillon_Codigo IS NOT NULL AND
            M.Sillon_Modelo_Codigo IS NOT NULL AND
            M.Sillon_Medida_Alto IS NOT NULL AND
            M.Sillon_Medida_Ancho IS NOT NULL AND
            M.Sillon_Medida_Profundidad IS NOT NULL
        ORDER BY 1, 2
END

-- INICIO EXECS PROCEDURES
go
exec REJUNTE_SA.migrar_provincias

go
exec REJUNTE_SA.migrar_localidades

go
exec REJUNTE_SA.migrar_datos_contacto

go
exec REJUNTE_SA.migrar_clientes

go
exec REJUNTE_SA.migrar_proveedores

go
exec REJUNTE_SA.migrar_sucursales

go
exec REJUNTE_SA.migrar_facturas

go
exec REJUNTE_SA.migrar_colores

go
exec REJUNTE_SA.migrar_dureza

go
exec REJUNTE_SA.migrar_densidad

go
exec REJUNTE_SA.migrar_textura

go
exec REJUNTE_SA.migrar_material_tipo

go
exec REJUNTE_SA.migrar_materiales

go
exec REJUNTE_SA.migrar_telas

go
exec REJUNTE_SA.migrar_maderas

go
exec REJUNTE_SA.migrar_rellenos

go
exec REJUNTE_SA.migrar_modelos

go
exec REJUNTE_SA.migrar_medidas

go
exec REJUNTE_SA.migrar_sillon

