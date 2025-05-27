USE GD1C2025 
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'REJUNTE_SA')
BEGIN 
	EXEC ('CREATE SCHEMA REJUNTE_SA AUTHORIZATION dbo')
END
GO

--DROP TABLES
IF OBJECT_ID('REJUNTE_SA.EstadoPedido', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.EstadoPedido;
IF OBJECT_ID('REJUNTE_SA.Factura', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.Factura;
IF OBJECT_ID('REJUNTE_SA.Envio', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.Envio;
IF OBJECT_ID('REJUNTE_SA.DetalleFactura', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.DetalleFactura;
IF OBJECT_ID('REJUNTE_SA.Modelo', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.Modelo;
IF OBJECT_ID('REJUNTE_SA.Medida', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.Medida;
IF OBJECT_ID('REJUNTE_SA.Tela', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.Tela;
IF OBJECT_ID('REJUNTE_SA.Relleno', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.Relleno;
IF OBJECT_ID('REJUNTE_SA.MaterialTipo', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.MaterialTipo;
IF OBJECT_ID('REJUNTE_SA.Material', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.Material;
IF OBJECT_ID('REJUNTE_SA.Madera', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.Madera;
IF OBJECT_ID('REJUNTE_SA.Sillon', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.Sillon;
IF OBJECT_ID('REJUNTE_SA.Color', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.Color;

IF OBJECT_ID('REJUNTE_SA.Cliente', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.Cliente;
IF OBJECT_ID('REJUNTE_SA.Proveedor', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.Proveedor;
IF OBJECT_ID('REJUNTE_SA.Sucursal', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.Sucursal;
IF OBJECT_ID('REJUNTE_SA.Localidad', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.Localidad;
IF OBJECT_ID('REJUNTE_SA.Provincia', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.Provincia;
IF OBJECT_ID('REJUNTE_SA.DatosContacto', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.DatosContacto;
IF OBJECT_ID('REJUNTE_SA.Compra', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.Compra;
IF OBJECT_ID('REJUNTE_SA.DetalleCompra', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.DetalleCompra;
IF OBJECT_ID('REJUNTE_SA.Pedido', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.Pedido;
IF OBJECT_ID('REJUNTE_SA.CancelacionPedido', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.CancelacionPedido;
IF OBJECT_ID('REJUNTE_SA.DetallePedido', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.DetallePedido;


--TABLES

--CREATE TABLE REJUNTE_SA.Tipo_Material (
    -- No tiene campos definidos en el diagrama
--)
--GO

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
    id_localidad BIGINT
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

-- ????
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
    id BIGINT,
    precio DECIMAL(18, 2),
    cantidad DECIMAL(18, 0),
    sub_total DECIMAL(18, 2),
    id_factura BIGINT
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
    id BIGINT PRIMARY KEY,
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
    tela_textura NVARCHAR(255)
)
GO

-- ok
CREATE TABLE REJUNTE_SA.Relleno (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    id_material BIGINT,
    relleno_densidad DECIMAL(38, 2)
)
GO

-- ok
CREATE TABLE REJUNTE_SA.Madera (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    id_material BIGINT,
    id_color BIGINT,
    madera_dureza NVARCHAR(255)
)
GO

-- ok
CREATE TABLE REJUNTE_SA.Sillon (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    id_modelo BIGINT,
    id_medida BIGINT
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

ALTER TABLE REJUNTE_SA.Sillon
ADD FOREIGN KEY (id_modelo) REFERENCES REJUNTE_SA.Modelo(id);
ALTER TABLE REJUNTE_SA.Sillon
ADD FOREIGN KEY (id_medida) REFERENCES REJUNTE_SA.Medida(id);

ALTER TABLE REJUNTE_SA.Tela
ADD FOREIGN KEY(id_material) REFERENCES REJUNTE_SA.Material(id);
ALTER TABLE REJUNTE_SA.Tela
ADD FOREIGN KEY(id_color) REFERENCES REJUNTE_SA.Color(id);

ALTER TABLE REJUNTE_SA.Madera
ADD FOREIGN KEY(id_material) REFERENCES REJUNTE_SA.Material(id);
ALTER TABLE REJUNTE_SA.Madera
ADD FOREIGN KEY(id_color) REFERENCES REJUNTE_SA.Color(id);

ALTER TABLE REJUNTE_SA.Relleno
ADD FOREIGN KEY(id_material) REFERENCES REJUNTE_SA.Material(id);

ALTER TABLE REJUNTE_SA.Material
ADD FOREIGN KEY(id_material_tipo) REFERENCES REJUNTE_SA.MaterialTipo(id);

--Vista para migrar provincias y localidades
CREATE VIEW REJUNTE_SA.VistaLugares AS
SELECT Cliente_Provincia AS Provincia,  Cliente_Localidad as Localidad FROM [GD1C2025].[gd_esquema].[Maestra] WHERE Cliente_Provincia IS NOT NULL AND Cliente_Localidad IS NOT NULL
UNION
SELECT Proveedor_Provincia, Proveedor_Localidad FROM [GD1C2025].[gd_esquema].[Maestra] WHERE Proveedor_Provincia IS NOT NULL AND Proveedor_Localidad IS NOT NULL
UNION
SELECT Sucursal_Provincia, Sucursal_Localidad FROM [GD1C2025].[gd_esquema].[Maestra] WHERE Sucursal_Provincia IS NOT NULL AND Sucursal_Localidad IS NOT NULL
GO


--MIGRACION DE DATOS PROCEDURES
CREATE PROCEDURE REJUNTE_SA.migrar_provincias AS
BEGIN
    INSERT INTO REJUNTE_SA.Provincia (nombre)
    SELECT DISTINCT Provincia FROM REJUNTE_sA.VistaLugares
END
GO

CREATE PROCEDURE REJUNTE_SA.migrar_Localidades
BEGIN
INSERT INTO REJUNTE_SA.Localidad (id_provincia, nombre)
SELECT DISTINCT
    p.id AS num_provincia,
    l.localidad
FROM REJUNTE_SA.VistaLugares l
JOIN REJUNTE_SA.Provincia p ON l.provincia = p.nombre;
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

CREATE PROCEDURE REJUNTE_SA.migrar_datosContacto
BEGIN
INSERT INTO REJUNTE_SA.DatosContacto (telefono, mail)
SELECT * FROM REJUNTE_SA.TelefonoMail
END
GO

--migrar clientes
CREATE PROCEDURE REJUNTE_SA.migrar_clientes
BEGIN
INSERT INTO REJUNTE_SA.Cliente (nombre, apellido, telefono, mail, direccion, provincia)
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
GO

--migrar proveedores
CREATE PROCEDURE REJUNTE_SA.migrar_proveedores
BEGIN 
INSERT INTO REJUNTE_SA.Proveedor (razon_social, cuit, direccion, datos_contacto, num_localidad)
SELECT 
m.Proveedor_RazonSocial,
m.Proveedor_Cuit,
m.Proveedor_Direccion,
d.id_datos 
l.numero
FROM [GD1C2025].[gd_esquema].[Maestra] m
JOIN REJUNTE_SA.DatosContacto d
ON d.telefono = m.Proveedor_Telefono AND d.mail = m.Proveedor_M
JOIN REJUNTE_SA.Localidad l 
ON l.nombre = m.Proveedor_Localidad
END 
GO

--migrar Sucursales
CREATE PROCEDURE REJUNTE_SA.migrar_sucursales
BEGIN
INSERT INTO REJUNTE_SA.Sucursal (NroSucursal, datos_contacto, direccion, numero_localidad)
SELECT 
m.Sucursal_NroSucursal,
d.id_datos,
m.Sucursal_Direccion,
l.numero
FROM [GD1C2025].[gd_esquema].[Maestra] m
JOIN REJUNTE_SA.DatosContacto d
ON d.telefono = m.Sucursal_Telefono AND d.mail = m.Sucursal_Mail
JOIN REJUNTE_SA.Localidad l
ON l.nombre = m.Sucursal_Localidad
END 
GO

--migrar factura 

CREATE PROCEDURE REJUNTE_SA.migrar_facturas
BEGIN 
INSERT INTO REJUNTE_SA.Factura (numero, sucursal, cliente, fecha, total)
SELECT m.Factura_numero,
s.NroSucursal
c.idCliente,
m.Factura_Fecha,
m.Factura_Total
FROM [GD1C2025].[gd_esquema].[Maestra] m
JOIN REJUNTE_SA.Cliente c
ON c.nombre = m.Cliente_Nombre AND c.apellido = m.Cliente_Apellido
JOIN REJUNTE_SA.Sucursal s 
ON s.NroSucursal = m.Sucursal_NroSucursal
END
GO
