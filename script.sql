USE GD1C2025 
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'REJUNTE_SA')
BEGIN 
	EXEC ('CREATE SCHEMA REJUNTE_SA AUTHORIZATION dbo')
END
GO

--DROP TABLES
IF OBJECT_ID('REJUNTE_SA.Tipo_Material', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.Tipo_Material;
IF OBJECT_ID('REJUNTE_SA.DatosContacto', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.DatosContacto;
IF OBJECT_ID('REJUNTE_SA.Localidad', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.Localidad;
IF OBJECT_ID('REJUNTE_SA.Provincia', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.Provincia;
IF OBJECT_ID('REJUNTE_SA.Proveedor', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.Proveedor;
IF OBJECT_ID('REJUNTE_SA.Cliente', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.Cliente;
IF OBJECT_ID('REJUNTE_SA.Sucursal', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.Sucursal;
IF OBJECT_ID('REJUNTE_SA.Compra', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.Compra;
IF OBJECT_ID('REJUNTE_SA.Material', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.Material;
IF OBJECT_ID('REJUNTE_SA.DetalleCompra', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.DetalleCompra;
IF OBJECT_ID('REJUNTE_SA.Pedido', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.Pedido;
IF OBJECT_ID('REJUNTE_SA.CancelacionPedido', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.CancelacionPedido;
IF OBJECT_ID('REJUNTE_SA.DetallePedido', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.DetallePedido;

IF OBJECT_ID('REJUNTE_SA.Factura', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.Factura;
IF OBJECT_ID('REJUNTE_SA.Envio', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.Envio;
IF OBJECT_ID('REJUNTE_SA.DetalleFactura', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.DetalleFactura;
IF OBJECT_ID('REJUNTE_SA.sillon_modelo', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.sillon_modelo;
IF OBJECT_ID('REJUNTE_SA.sillon_medida', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.sillon_medida;
IF OBJECT_ID('REJUNTE_SA.Tela', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.Tela;
IF OBJECT_ID('REJUNTE_SA.Relleno', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.Relleno;
IF OBJECT_ID('REJUNTE_SA.Madera', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.Madera;
IF OBJECT_ID('REJUNTE_SA.Sillon', 'U') IS NOT NULL DROP TABLE REJUNTE_SA.Sillon;

--TABLES

--CREATE TABLE REJUNTE_SA.Tipo_Material (
    -- No tiene campos definidos en el diagrama
--)
--GO

CREATE TABLE REJUNTE_SA.DatosContacto (
    id_datos BIGINT IDENTITY(1,1) PRIMARY KEY,
    telefono NVARCHAR(255),
    mail NVARCHAR(255)
)
GO

CREATE TABLE REJUNTE_SA.Localidad (
    numero BIGINT IDENTITY(1,1) PRIMARY KEY,
    num_provincia BIGINT,
    nombre NVARCHAR(255)
)
GO

CREATE TABLE REJUNTE_SA.Provincia (
    numero BIGINT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(255)
)
GO

CREATE TABLE REJUNTE_SA.Proveedor (
    id BIGINT PRIMARY KEY,
    razon_social NVARCHAR(255),
    cuit NVARCHAR(255),
    direccion NVARCHAR(255),
    datos_contacto BIGINT,
    num_localidad BIGINT
)
GO

CREATE TABLE REJUNTE_SA.Cliente (
    idCliente BIGINT PRIMARY KEY,
    DNI BIGINT UNIQUE,
    nombre NVARCHAR(255),
    apellido NVARCHAR(255),
    fechaNac DATETIME2(6),
    direccion NVARCHAR(255),
    datos_contacto BIGINT,
    num_localidad BIGINT
)
GO

CREATE TABLE REJUNTE_SA.Sucursal (
    NroSucursal BIGINT PRIMARY KEY,
    datos_contacto BIGINT,
    numero_localidad BIGINT
)
GO

CREATE TABLE REJUNTE_SA.Compra (
    numero DECIMAL(18, 0) PRIMARY KEY,
    numero_sucursal BIGINT,
    numero_proveedor BIGINT,
    fecha DATETIME2(6),
    total DECIMAL(18, 2)
)
GO

CREATE TABLE REJUNTE_SA.Material (
    numero BIGINT PRIMARY KEY,
    tipo NVARCHAR(255),
    nombre NVARCHAR(255),
    descripcion NVARCHAR(255),
    precio DECIMAL(38, 2)
)
GO

CREATE TABLE REJUNTE_SA.DetalleCompra (
    numero_compra DECIMAL(18, 0),
    material BIGINT,
    precio DECIMAL(18, 2),
    cantidad DECIMAL(18, 0),
    subtotal DECIMAL(18, 2)
)
GO

CREATE TABLE REJUNTE_SA.Pedido (
    numero DECIMAL(18, 0) PRIMARY KEY,
    sucursal BIGINT,
    cliente BIGINT,
    fecha DATETIME2(6),
    total DECIMAL(18, 2),
    estado NVARCHAR(255)
)
GO

CREATE TABLE REJUNTE_SA.CancelacionPedido (
    num_pedido DECIMAL(18, 0),
    fecha DATETIME2(6),
    motivo VARCHAR(255)
)
GO

CREATE TABLE REJUNTE_SA.DetallePedido (
    numero BIGINT PRIMARY KEY,
    pedido DECIMAL(18, 0),
    cantidad BIGINT,
    precio DECIMAL(18, 2),
    subtotal DECIMAL(18, 2),
    codigo_sillon BIGINT
)
GO

CREATE TABLE REJUNTE_SA.Factura (
    numero BIGINT PRIMARY KEY,
    sucursal BIGINT,
    cliente BIGINT,
    fecha DATETIME2(6),
    total DECIMAL(38, 2)
)
GO

CREATE TABLE REJUNTE_SA.Envio (
    numero decimal(18,0) PRIMARY KEY,
    factura_numero BIGINT,
    fecha_programada DATETIME2(6),
    fecha_entrega DATETIME2(6),
    importe_traslado DECIMAL(18, 2),
    importe_subida DECIMAL(18, 2)
)
GO

CREATE TABLE REJUNTE_SA.DetalleFactura (
    det_pedido BIGINT,
    precio DECIMAL(18, 2),
    cantidad DECIMAL(18, 0),
    sub_total DECIMAL(18, 2),
    numero_factura BIGINT
)
GO

CREATE TABLE REJUNTE_SA.sillon_modelo (
    codigo BIGINT PRIMARY KEY,
    modelo NVARCHAR(255),
    descripcion NVARCHAR(255),
    precio DECIMAL(18, 2)
)
GO

CREATE TABLE REJUNTE_SA.sillon_medida (
    codigo BIGINT PRIMARY KEY,
    alto DECIMAL(18, 2),
    ancho DECIMAL(18, 2),
    profundidad DECIMAL(18, 2),
    precio DECIMAL(18, 2)
)
GO

CREATE TABLE REJUNTE_SA.Tela (
    numero_tela BIGINT PRIMARY KEY,
    tela_color NVARCHAR(255),
    tela_textura NVARCHAR(255)
)
GO

CREATE TABLE REJUNTE_SA.Relleno (
    numero_relleno BIGINT PRIMARY KEY,
    relleno_densidad DECIMAL(38, 2)
)
GO

CREATE TABLE REJUNTE_SA.Madera (
    numero_madera BIGINT PRIMARY KEY,
    madera_color NVARCHAR(255),
    madera_dureza NVARCHAR(255)
)
GO

CREATE TABLE REJUNTE_SA.Sillon (
    id_sillon BIGINT PRIMARY KEY,
    codigo_modelo BIGINT,
    codigo_medida BIGINT,
    codigo_tela BIGINT,
    codigo_madera BIGINT,
    codigo_relleno BIGINT
)
GO

--FOREIGN KEYS
ALTER TABLE REJUNTE_SA.Localidad
ADD FOREIGN KEY (num_provincia) REFERENCES REJUNTE_SA.Provincia(numero);

ALTER TABLE REJUNTE_SA.Proveedor
ADD FOREIGN KEY (datos_contacto) REFERENCES REJUNTE_SA.DatosContacto(id_datos);
ALTER TABLE REJUNTE_SA.Proveedor
ADD FOREIGN KEY (num_localidad) REFERENCES REJUNTE_SA.Localidad(numero);

ALTER TABLE REJUNTE_SA.Cliente
ADD FOREIGN KEY (datos_contacto) REFERENCES REJUNTE_SA.DatosContacto(id_datos);
ALTER TABLE REJUNTE_SA.Cliente
ADD FOREIGN KEY (num_localidad) REFERENCES REJUNTE_SA.Localidad(numero);


ALTER TABLE REJUNTE_SA.Sucursal
ADD FOREIGN KEY (datos_contacto) REFERENCES REJUNTE_SA.DatosContacto(id_datos);
ALTER TABLE REJUNTE_SA.Sucursal
ADD FOREIGN KEY (numero_localidad) REFERENCES REJUNTE_SA.Localidad(numero);

ALTER TABLE REJUNTE_SA.Compra
ADD FOREIGN KEY (numero_sucursal) REFERENCES REJUNTE_SA.Sucursal(NroSucursal);
ALTER TABLE REJUNTE_SA.Compra
ADD FOREIGN KEY (numero_proveedor) REFERENCES REJUNTE_SA.Proveedor(id);

ALTER TABLE REJUNTE_SA.DetalleCompra
ADD FOREIGN KEY (numero_compra) REFERENCES REJUNTE_SA.Compra(numero);
ALTER TABLE REJUNTE_SA.DetalleCompra
ADD FOREIGN KEY (material) REFERENCES REJUNTE_SA.Material(numero);

ALTER TABLE REJUNTE_SA.Pedido
ADD FOREIGN KEY (sucursal) REFERENCES REJUNTE_SA.Sucursal(NroSucursal);
ALTER TABLE REJUNTE_SA.Pedido
ADD FOREIGN KEY (cliente) REFERENCES REJUNTE_SA.Cliente(idCliente);

ALTER TABLE REJUNTE_SA.CancelacionPedido
ADD FOREIGN KEY (num_pedido) REFERENCES REJUNTE_SA.Pedido(numero);

ALTER TABLE REJUNTE_SA.DetallePedido
ADD FOREIGN KEY (pedido) REFERENCES REJUNTE_SA.Pedido(numero);
ALTER TABLE REJUNTE_SA.DetallePedido
ADD FOREIGN KEY (codigo_sillon) REFERENCES REJUNTE_SA.Sillon(id_sillon);

ALTER TABLE REJUNTE_SA.Factura
ADD FOREIGN KEY (sucursal) REFERENCES REJUNTE_SA.Sucursal(NroSucursal);
ALTER TABLE REJUNTE_SA.Factura
ADD FOREIGN KEY (cliente) REFERENCES REJUNTE_SA.Cliente(idCliente);

ALTER TABLE REJUNTE_SA.Envio
ADD FOREIGN KEY (factura_numero) REFERENCES REJUNTE_SA.Factura(numero);

ALTER TABLE REJUNTE_SA.DetalleFactura
ADD FOREIGN KEY (det_pedido) REFERENCES REJUNTE_SA.DetallePedido(numero);
ALTER TABLE REJUNTE_SA.DetalleFactura
ADD FOREIGN KEY (numero_factura) REFERENCES REJUNTE_SA.Factura(numero);


ALTER TABLE REJUNTE_SA.Sillon
ADD FOREIGN KEY (codigo_modelo) REFERENCES REJUNTE_SA.sillon_modelo(codigo);
ALTER TABLE REJUNTE_SA.Sillon
ADD FOREIGN KEY (codigo_medida) REFERENCES REJUNTE_SA.sillon_medida(codigo);
ALTER TABLE REJUNTE_SA.Sillon
ADD FOREIGN KEY (codigo_tela) REFERENCES REJUNTE_SA.Tela(numero_tela);
ALTER TABLE REJUNTE_SA.Sillon
ADD FOREIGN KEY (codigo_madera) REFERENCES REJUNTE_SA.Madera(numero_madera);
ALTER TABLE REJUNTE_SA.Sillon
ADD FOREIGN KEY (codigo_relleno) REFERENCES REJUNTE_SA.Relleno(numero_relleno);


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
INSERT INTO REJUNTE_SA.Localidad (num_provincia, nombre)
SELECT DISTINCT
    p.numero AS num_provincia,
    loc.localidad
FROM REJUNTE_SA.VistaLugares loc
JOIN REJUNTE_SA.Provincia p ON loc.provincia = p.nombre;
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

--migrar clientes incoompleto
SELECT
	distinct 
    m.Cliente_Dni,
    m.Cliente_Nombre,
    m.Cliente_Apellido,
    m.Cliente_FechaNacimiento,
    m.Cliente_Direccion,
    dc.id_datos,
    l.numero AS num_localidad
FROM [GD1C2025].[gd_esquema].[Maestra] m
JOIN REJUNTE_SA.DatosContacto dc
    ON dc.telefono = m.Cliente_Telefono AND dc.mail = m.Cliente_Mail
JOIN REJUNTE_SA.Provincia p
    ON p.nombre = m.Cliente_Provincia
JOIN REJUNTE_SA.Localidad l
    ON l.nombre = m.Cliente_Localidad AND l.num_provincia = p.numero
WHERE m.Cliente_Dni IS NOT NULL
AND m.Cliente_Direccion IS NOT NULL
;



--RECORRER USANDO CURSOR
CREATE PROCEDURE REJUNTE_SA.migrar_Incidente_y_Involucrados_incidente AS
BEGIN
	-- Declaramos cursor para insertar datos en Incidente y Involucrados_Incidente
	DECLARE incidentes_cursor CURSOR FOR 
	SELECT 
		m.CODIGO_CARRERA,
		m.CODIGO_SECTOR,
		m.INCIDENTE_BANDERA, 
		m.INCIDENTE_NUMERO_VUELTA,
		m.INCIDENTE_TIEMPO,
		m.INCIDENTE_TIPO,
		m.PILOTO_NOMBRE,
		m.PILOTO_APELLIDO
	FROM gd_esquema.Maestra m
	WHERE INCIDENTE_BANDERA IS NOT NULL

	DECLARE @CODIGO_CARRERA INT
	DECLARE @CODIGO_SECTOR INT
	DECLARE @INCIDENTE_BANDERA NVARCHAR(255) 
	DECLARE @INCIDENTE_NUMERO_VUELTA DECIMAL(18,0)
	DECLARE @INCIDENTE_TIEMPO DECIMAL(18,2)
	DECLARE @INCIDENTE_TIPO NVARCHAR(255)
	DECLARE @PILOTO_NOMBRE NVARCHAR(255)
	DECLARE @PILOTO_APELLIDO NVARCHAR(255)

	OPEN incidentes_cursor

	FETCH NEXT FROM incidentes_cursor INTO 
		@CODIGO_CARRERA, @CODIGO_SECTOR, @INCIDENTE_BANDERA, @INCIDENTE_NUMERO_VUELTA,
		@INCIDENTE_TIEMPO, @INCIDENTE_TIPO, @PILOTO_NOMBRE, @PILOTO_APELLIDO

	DECLARE @incidente_codigo INT


	WHILE @@FETCH_STATUS = 0 
	BEGIN
		IF (REJUNTE_SA.incidente_existe(@CODIGO_CARRERA, @CODIGO_SECTOR, @INCIDENTE_BANDERA, @INCIDENTE_TIEMPO) = 0)
		BEGIN
			INSERT INTO REJUNTE_SA.Incidente VALUES (REJUNTE_SA.bandera_codigo(@INCIDENTE_BANDERA), @CODIGO_CARRERA, @CODIGO_SECTOR, @INCIDENTE_TIEMPO)
		END
		
		INSERT INTO REJUNTE_SA.Involucrados_Incidente
		VALUES (REJUNTE_SA.incidente_codigo(@CODIGO_CARRERA, @CODIGO_SECTOR, @INCIDENTE_BANDERA, @INCIDENTE_TIEMPO),
			    REJUNTE_SA.piloto_obtener_auto(@PILOTO_NOMBRE, @PILOTO_APELLIDO),
				@INCIDENTE_NUMERO_VUELTA,
				REJUNTE_SA.incidente_tipo_codigo(@INCIDENTE_TIPO))

		FETCH NEXT FROM incidentes_cursor INTO 
			@CODIGO_CARRERA, @CODIGO_SECTOR, @INCIDENTE_BANDERA, @INCIDENTE_NUMERO_VUELTA,
			@INCIDENTE_TIEMPO, @INCIDENTE_TIPO, @PILOTO_NOMBRE, @PILOTO_APELLIDO
	END

	CLOSE incidentes_cursor
	DEALLOCATE incidentes_cursor
END
GO

--------------------------------------
---------- DATA MIGRATION ------------
--------------------------------------

BEGIN TRANSACTION 
	EXECUTE REJUNTE_SA.migrar_caja
	EXECUTE REJUNTE_SA.migrar_Motor
	EXECUTE REJUNTE_SA.migrar_Neumatico_Tipo
	EXECUTE REJUNTE_SA.migrar_Neumatico
	EXECUTE REJUNTE_SA.migrar_Freno
	EXECUTE REJUNTE_SA.migrar_Bandera
	EXECUTE REJUNTE_SA.migrar_Incidente_Tipo
	EXECUTE REJUNTE_SA.migrar_Pais
	EXECUTE REJUNTE_SA.migrar_Circuito
	EXECUTE REJUNTE_SA.migrar_Carrera
	EXECUTE REJUNTE_SA.migrar_Sector_Tipo
	EXECUTE REJUNTE_SA.migrar_Sector
	EXECUTE REJUNTE_SA.migrar_Nacionalidad
	EXECUTE REJUNTE_SA.migrar_Piloto
	EXECUTE REJUNTE_SA.migrar_Escuderia
	EXECUTE REJUNTE_SA.migrar_Auto
	EXECUTE REJUNTE_SA.migrar_Telemetria
	EXECUTE REJUNTE_SA.migrar_Motor_Tele
	EXECUTE REJUNTE_SA.migrar_Caja_Tele
	EXECUTE REJUNTE_SA.migrar_Neumatico_Tele
	EXECUTE REJUNTE_SA.migrar_Freno_Tele
	EXECUTE REJUNTE_SA.migrar_Parada_y_Cambio_Neumatico
	EXECUTE REJUNTE_SA.migrar_Incidente_y_Involucrados_incidente
COMMIT TRANSACTION

--DROP PROCEDURES
DROP PROCEDURE REJUNTE_SA.migrar_caja
--DROP FUNCTIONS
DROP FUNCTION REJUNTE_SA.escuderia_obtener
