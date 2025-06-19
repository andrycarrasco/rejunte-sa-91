USE [GD1C2024]

-- Borra todas las FKs
GO
DECLARE @sql NVARCHAR(MAX) = N'';
SELECT @sql += N'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) +
    ' DROP CONSTRAINT ' + QUOTENAME(name) + ';'
FROM sys.foreign_keys;
EXEC sp_executesql @sql;

-- Borra todas las tablas en el esquema TESLA_TEAM
GO
DECLARE @dropTableSQL NVARCHAR(MAX) = N'';
SELECT @dropTableSQL += 'DROP TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(object_id)) + '.' + QUOTENAME(name) + '; '
FROM sys.tables
WHERE SCHEMA_NAME(schema_id) = 'TESLA_TEAM';
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
	DROP PROCEDURE [TESLA_TEAM].'
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

-- INICIO: CREACION DE ESQUEMA
GO
IF EXISTS(
SELECT * FROM sys.schemas where name = 'TESLA_TEAM'
)
BEGIN
	DROP SCHEMA [TESLA_TEAM]
END
GO

CREATE SCHEMA [TESLA_TEAM];
GO
-- FIN: CREACION DE ESQUEMA

-- Datos de negocio

CREATE TABLE [TESLA_TEAM].[categoria] (
  [id_categoria] int IDENTITY(1,1),
  [categoria] nvarchar(255),
  PRIMARY KEY ([id_categoria])
);

CREATE TABLE [TESLA_TEAM].[subcategoria] (
  [id_subcategoria] int IDENTITY(1,1),
  [id_categoria] int,
  [subcategoria] nvarchar(255),
  PRIMARY KEY ([id_subcategoria]),
  CONSTRAINT [FK_id_categoria.id_categoria]
    FOREIGN KEY ([id_categoria])
      REFERENCES [TESLA_TEAM].[categoria]([id_categoria])
);

CREATE TABLE [TESLA_TEAM].[producto] (
  [id_producto] int IDENTITY(1,1),
  [id_subcategoria] int,
  [nombre] nvarchar(255),
  [descripcion] nvarchar(255),
  [precio] decimal(18,2),
  [marca] nvarchar(255),
  PRIMARY KEY ([id_producto]),
  CONSTRAINT [FK_id_subcategoria.id_subcategoria]
    FOREIGN KEY ([id_subcategoria])
      REFERENCES [TESLA_TEAM].[subcategoria]([id_subcategoria])
);

CREATE TABLE [TESLA_TEAM].[regla] (
  [id_regla] int IDENTITY(1,1),
  [descripcion] nvarchar(255),
  [descuento] decimal(18,2),
  [cantidad_aplicable_regla] decimal(18,0),
  [cantidad_aplicable_descuento] decimal(18,0),
  [veces_aplicable] decimal(18,0),
  [misma_marca] decimal(18,0),
  [mismo_producto] decimal(18,0),
  PRIMARY KEY ([id_regla])
);

CREATE TABLE [TESLA_TEAM].[promocion_producto] (
  [cod_promocion] decimal(18,0),
  [descripcion] nvarchar(255),
  [fecha_inicio] datetime,
  [fecha_final] datetime,
  PRIMARY KEY ([cod_promocion])
);

CREATE TABLE [TESLA_TEAM].[medio_pago] (
  [id_medio_pago] int IDENTITY(1,1),
  [tipo] nvarchar(255),
  [nombre] nvarchar(255),
  PRIMARY KEY ([id_medio_pago])
);

CREATE TABLE [TESLA_TEAM].[descuento_medio_pago] (
  [cod_descuento] decimal(18,0),
  [descripcion] nvarchar(255),
  [fecha_inicio] datetime,
  [fecha_final] datetime,
  [porcentaje] decimal(18,2),
  [tope] decimal(18,2),
  PRIMARY KEY ([cod_descuento])
);

CREATE TABLE [TESLA_TEAM].[localidad] (
  [id_localidad] int IDENTITY(1,1),
  [id_provincia] int,
  [nombre] nvarchar(255),
  PRIMARY KEY ([id_localidad])
);

CREATE TABLE [TESLA_TEAM].[provincia] (
  [id_provincia] int IDENTITY(1,1),
  [nombre] nvarchar(255),
  PRIMARY KEY ([id_provincia])
);

CREATE TABLE [TESLA_TEAM].[cliente] (
  [id_cliente] int IDENTITY(1,1),
  [dni] decimal(18,0),
  [nombre] nvarchar(255),
  [apellido] nvarchar(255),
  [domicilio] nvarchar(255),
  [registro] datetime,
  [telefono] decimal(18,0),
  [mail] nvarchar(255),
  [nacimiento] date,
  [id_localidad] int,
  [id_provincia] int,
  PRIMARY KEY ([id_cliente]),
  CONSTRAINT [FK_id_localidad_en_cliente.id_localidad]
    FOREIGN KEY ([id_localidad])
      REFERENCES [TESLA_TEAM].[localidad]([id_localidad]),
  CONSTRAINT [FK_id_provincia_en_cliente.id_provincia]
    FOREIGN KEY ([id_provincia])
      REFERENCES [TESLA_TEAM].[provincia]([id_provincia])
);

CREATE TABLE [TESLA_TEAM].[detalle_pago] (
  [id_detalle_pago] int IDENTITY(1,1),
  [id_cliente] int,
  [nro_tarjeta] nvarchar(255),
  [vencimiento_tarjeta] datetime,
  [cuotas] decimal(18,0),
  PRIMARY KEY ([id_detalle_pago]),
  CONSTRAINT [FK_id_cliente.id_cliente]
    FOREIGN KEY ([id_cliente])
      REFERENCES [TESLA_TEAM].[cliente]([id_cliente])
);

CREATE TABLE [TESLA_TEAM].[supermercado] (
  [id_supermercado] int IDENTITY(1,1),
  [nombre] nvarchar(255),
  [razon_social] nvarchar(255),
  [cuit] nvarchar(255),
  [iibb] nvarchar(255),
  [domicilio] nvarchar(255),
  [fecha_inicio_actividad] datetime,
  [comision_fiscal] nvarchar(255),
  [id_localidad] int,
  [id_provincia] int,
  PRIMARY KEY ([id_supermercado]),
  CONSTRAINT [FK_id_localidad_en_supermercado.id_localidad]
    FOREIGN KEY ([id_localidad])
      REFERENCES [TESLA_TEAM].[localidad]([id_localidad]),
  CONSTRAINT [FK_id_provincia_en_supermercado.id_provincia]
    FOREIGN KEY ([id_provincia])
      REFERENCES [TESLA_TEAM].[provincia]([id_provincia])
);

CREATE TABLE [TESLA_TEAM].[sucursal] (
  [id_sucursal] int IDENTITY(1,1),
  [id_supermercado] int,
  [nombre] nvarchar(255),
  [direccion] nvarchar(255),
  [id_localidad] int,
  [id_provincia] int,
  PRIMARY KEY ([id_sucursal]),
  CONSTRAINT [FK_id_supermercado.id_supermercado]
    FOREIGN KEY ([id_supermercado])
      REFERENCES [TESLA_TEAM].[supermercado]([id_supermercado]),
  CONSTRAINT [FK_id_localidad.id_localidad]
    FOREIGN KEY ([id_localidad])
      REFERENCES [TESLA_TEAM].[localidad]([id_localidad]),
  CONSTRAINT [FK_id_provincia.id_provincia]
    FOREIGN KEY ([id_provincia])
      REFERENCES [TESLA_TEAM].[provincia]([id_provincia])
);

CREATE TABLE [TESLA_TEAM].[tipo_caja] (
  [id_tipo_caja] int IDENTITY(1,1),
  [nombre] nvarchar(255),
  PRIMARY KEY ([id_tipo_caja])
);


CREATE TABLE [TESLA_TEAM].[caja] (
  [nro_caja] decimal(18,0),
  [id_sucursal] int,
  [id_tipo_caja] int,
  PRIMARY KEY ([nro_caja], [id_sucursal]),
  CONSTRAINT [FK_id_sucursal_en_caja.id_sucursal]
    FOREIGN KEY ([id_sucursal])
      REFERENCES [TESLA_TEAM].[sucursal]([id_sucursal]),
  CONSTRAINT [FK_id_tipo_caja.id_tipo_caja]
    FOREIGN KEY ([id_tipo_caja])
      REFERENCES [TESLA_TEAM].[tipo_caja]([id_tipo_caja])
);

CREATE TABLE [TESLA_TEAM].[empleado] (
  [legajo_empleado] int IDENTITY(1,1),
  [id_sucursal] int,
  [dni] decimal(18,0),
  [nombre] nvarchar(255),
  [apellido] nvarchar(255),
  [telefono] decimal(18,0),
  [mail] nvarchar(255),
  [nacimiento] date,
  [registro] datetime,
  PRIMARY KEY ([legajo_empleado]),
  CONSTRAINT [FK_id_sucursal_en_empleado.id_sucursal]
    FOREIGN KEY ([id_sucursal])
      REFERENCES [TESLA_TEAM].[sucursal]([id_sucursal])
);

CREATE TABLE [TESLA_TEAM].[venta] (
  [id_venta] int IDENTITY(1,1),
  [nro_ticket] decimal(18,0),
  [id_sucursal] int,
  [fecha] datetime,
  [legajo_empleado] int,
  [nro_caja] decimal(18,0),
  [tipo_comprobante] nvarchar(255),
  [sub_total] decimal(18,2),
  [descuento_promociones] decimal(18,2),
  [descuento_medio] decimal(18,2),
  [total] decimal(18,2),
  [total_costo_envios] decimal(18,2),
  PRIMARY KEY ([id_venta]),
  CONSTRAINT [FK_id_sucursal_en_venta.id_sucursal]
    FOREIGN KEY ([id_sucursal])
      REFERENCES [TESLA_TEAM].[sucursal]([id_sucursal]),
  CONSTRAINT [FK_venta_nro_caja_id_sucursal]
    FOREIGN KEY ([nro_caja], [id_sucursal])
      REFERENCES [TESLA_TEAM].[caja]([nro_caja], [id_sucursal]),
  CONSTRAINT [FK_legajo_empleado.legajo_empleado]
    FOREIGN KEY ([legajo_empleado])
      REFERENCES [TESLA_TEAM].[empleado]([legajo_empleado])
);

CREATE TABLE [TESLA_TEAM].[pago] (
  [nro_pago] int IDENTITY(1,1),
  [id_venta] int,
  [id_medio_pago] int,
  [id_detalle_pago] int,
  [fecha_pago] datetime,
  [importe] decimal(18,2),
  [descuento_aplicado] decimal(18,2),
  PRIMARY KEY ([nro_pago]),
  CONSTRAINT [FK_id_venta_en_pago.id_venta]
    FOREIGN KEY ([id_venta])
      REFERENCES [TESLA_TEAM].[venta]([id_venta]),
  CONSTRAINT [FK_id_medio_pago.id_medio_pago]
    FOREIGN KEY ([id_medio_pago])
      REFERENCES [TESLA_TEAM].[medio_pago]([id_medio_pago]),
  CONSTRAINT [FK_id_detalle_pago.id_detalle_pago]
    FOREIGN KEY ([id_detalle_pago])
      REFERENCES [TESLA_TEAM].[detalle_pago]([id_detalle_pago])
);

CREATE TABLE [TESLA_TEAM].[envio] (
  [id_envio] int IDENTITY(1,1),
  [id_venta] int,
  [id_cliente] int,
  [fecha_programada] datetime,
  [hora_rango_inicio] decimal(18,0),
  [hora_rango_final] decimal(18,0),
  [costo] decimal(18,2),
  [estado] nvarchar(255),
  [fecha_entrega] datetime,
  PRIMARY KEY ([id_envio]),
  CONSTRAINT [FK_id_cliente_en_envio.id_cliente]
    FOREIGN KEY ([id_cliente])
      REFERENCES [TESLA_TEAM].[cliente]([id_cliente]),
  CONSTRAINT [FK_id_venta_en_envio.id_venta]
    FOREIGN KEY ([id_venta])
      REFERENCES [TESLA_TEAM].[venta]([id_venta])
);

CREATE TABLE [TESLA_TEAM].[producto_vendido] (
  [id_venta] int,
  [id_producto] int,
  [cantidad] decimal(18,0),
  [precio_total] decimal(18,2),
  PRIMARY KEY ([id_venta], [id_producto]),
  CONSTRAINT [FK_id_producto.id_producto]
    FOREIGN KEY ([id_producto])
      REFERENCES [TESLA_TEAM].[producto]([id_producto]),
  CONSTRAINT [FK_id_venta_en_producto_vendido.id_venta]
    FOREIGN KEY ([id_venta])
      REFERENCES [TESLA_TEAM].[venta]([id_venta])
);

CREATE TABLE [TESLA_TEAM].[promocion_aplicada] (
  [id_venta] int,
  [id_producto] int,
  [cod_promocion] decimal(18,0),
  [descuento_total] decimal(18,2),
  PRIMARY KEY ([id_venta], [id_producto], [cod_promocion]),
  CONSTRAINT [FK_id_venta_en_promocion_aplicada.id_venta]
    FOREIGN KEY ([id_venta],[id_producto])
      REFERENCES [TESLA_TEAM].[producto_vendido]([id_venta],[id_producto]),
  CONSTRAINT [FK_cod_promocion.cod_promocion]
    FOREIGN KEY ([cod_promocion])
      REFERENCES [TESLA_TEAM].[promocion_producto]([cod_promocion])
);

-- Intermedias

CREATE TABLE [TESLA_TEAM].[producto_x_promocion_producto] (
  [id_producto] int,
  [cod_promocion] decimal(18,0),
  PRIMARY KEY ([id_producto], [cod_promocion]),
  CONSTRAINT [FK_id_producto_en_producto_x_promocion_producto.id_producto]
    FOREIGN KEY ([id_producto])
      REFERENCES [TESLA_TEAM].[producto]([id_producto]),
  CONSTRAINT [FK_cod_promocion_en_producto_x_promocion_producto.cod_promocion]
    FOREIGN KEY ([cod_promocion])
      REFERENCES [TESLA_TEAM].[promocion_producto]([cod_promocion])
);

CREATE TABLE [TESLA_TEAM].[promocion_producto_x_regla] (
  [cod_promocion] decimal(18,0),
  [id_regla] int,
  PRIMARY KEY ([cod_promocion], [id_regla]),
  CONSTRAINT [FK_cod_promocion_en_promocion_producto_x_regla.cod_promocion]
    FOREIGN KEY ([cod_promocion])
      REFERENCES [TESLA_TEAM].[promocion_producto]([cod_promocion]),
  CONSTRAINT [FK_id_regla.id_regla]
    FOREIGN KEY ([id_regla])
      REFERENCES [TESLA_TEAM].[regla]([id_regla])
);

CREATE TABLE [TESLA_TEAM].[descuento_x_medio_pago] (
  [id_medio_pago] int,
  [cod_descuento] decimal(18,0),
  PRIMARY KEY ([id_medio_pago], [cod_descuento]),
  CONSTRAINT [FK_id_medio_pago_en_descuento_x_medio_pago.id_medio_pago]
    FOREIGN KEY ([id_medio_pago])
      REFERENCES [TESLA_TEAM].[medio_pago]([id_medio_pago]),
  CONSTRAINT [FK_cod_descuento.cod_descuento]
    FOREIGN KEY ([cod_descuento])
      REFERENCES [TESLA_TEAM].[descuento_medio_pago]([cod_descuento])
);

-- FIN: CREACION DE TABLAS

-- INICIO: NORMALIZACION DE DATOS - STORED PROCEDURES.


GO
CREATE PROCEDURE [TESLA_TEAM].migrar_tipo_caja 
AS 
BEGIN
  INSERT INTO [TESLA_TEAM].tipo_caja(nombre)
  SELECT DISTINCT
    CAJA_TIPO as nombre
  FROM gd_esquema.Maestra
  WHERE CAJA_TIPO is not null

  IF @@ERROR != 0
  PRINT('SP TIPO CAJA FAIL!')
  ELSE
  PRINT('SP TIPO CAJA OK!')
END


GO
CREATE PROCEDURE [TESLA_TEAM].migrar_categoria 
AS 
BEGIN
  INSERT INTO [TESLA_TEAM].categoria(categoria)
  SELECT DISTINCT
    PRODUCTO_CATEGORIA as categoria
  FROM gd_esquema.Maestra
  WHERE PRODUCTO_CATEGORIA is not null

  IF @@ERROR != 0
  PRINT('SP CATEGORIA FAIL!')
  ELSE
  PRINT('SP CATEGORIA OK!')
END


GO
CREATE PROCEDURE [TESLA_TEAM].migrar_subcategoria 
AS 
BEGIN
  INSERT INTO [TESLA_TEAM].subcategoria(id_categoria, subcategoria)
  SELECT DISTINCT
    c.id_categoria,
    PRODUCTO_SUB_CATEGORIA as subcategoria
  FROM gd_esquema.Maestra
  JOIN categoria c ON c.categoria = PRODUCTO_CATEGORIA
  WHERE 
  PRODUCTO_CATEGORIA      is not null and
  PRODUCTO_SUB_CATEGORIA  is not null
  IF @@ERROR != 0
  PRINT('SP SUBCATEGORIA FAIL!')
  ELSE
  PRINT('SP SUBCATEGORIA OK!')
END


GO
CREATE PROCEDURE [TESLA_TEAM].migrar_producto 
AS 
BEGIN
  INSERT INTO [TESLA_TEAM].producto(id_subcategoria, nombre, descripcion, precio, marca)
  
  SELECT DISTINCT
    s.id_subcategoria     as id_subcategoria,
    PRODUCTO_NOMBRE       as nombre,
    PRODUCTO_DESCRIPCION  as descripcion,
    PRODUCTO_PRECIO       as precio,
    PRODUCTO_MARCA        as marca
  FROM gd_esquema.Maestra

  JOIN TESLA_TEAM.categoria c ON PRODUCTO_CATEGORIA = c.categoria
  JOIN TESLA_TEAM.subcategoria s ON
      s.subcategoria = PRODUCTO_SUB_CATEGORIA AND
      s.id_categoria = c.id_categoria

  WHERE 
      PRODUCTO_SUB_CATEGORIA  is not null and
      PRODUCTO_NOMBRE         is not null and
      PRODUCTO_DESCRIPCION    is not null and
      PRODUCTO_PRECIO         is not null and
      PRODUCTO_MARCA          is not null

  IF @@ERROR != 0
  PRINT('SP PRODUCTO FAIL!')
  ELSE
  PRINT('SP PRODUCTO OK!')
END

GO
CREATE PROCEDURE [TESLA_TEAM].migrar_regla 
AS 
BEGIN
  INSERT INTO [TESLA_TEAM].regla(descripcion, descuento, cantidad_aplicable_regla, cantidad_aplicable_descuento, veces_aplicable, misma_marca, mismo_producto)
  SELECT DISTINCT      
    REGLA_DESCRIPCION               as descripcion,
    REGLA_DESCUENTO_APLICABLE_PROD  as descuento,
    REGLA_CANT_APLICABLE_REGLA      as cantidad_aplicable_regla,
    REGLA_CANT_APLICA_DESCUENTO     as cantidad_aplicable_descuento,
    REGLA_CANT_MAX_PROD             as veces_aplicable,
    REGLA_APLICA_MISMA_MARCA        as misma_marca,
    REGLA_APLICA_MISMO_PROD         as mismo_producto
  FROM gd_esquema.Maestra
  WHERE 
  REGLA_DESCRIPCION                 is not null and
  REGLA_DESCUENTO_APLICABLE_PROD    is not null and
  REGLA_CANT_APLICABLE_REGLA        is not null and
  REGLA_CANT_APLICA_DESCUENTO       is not null and
  REGLA_APLICA_MISMA_MARCA          is not null and
  REGLA_APLICA_MISMO_PROD           is not null
  IF @@ERROR != 0
  PRINT('SP REGLA FAIL!')
  ELSE
  PRINT('SP REGLA OK!')
END


GO
CREATE PROCEDURE [TESLA_TEAM].migrar_promocion_producto 
AS 
BEGIN
  INSERT INTO [TESLA_TEAM].promocion_producto(cod_promocion, descripcion, fecha_inicio, fecha_final)
  SELECT DISTINCT
	  PROMO_CODIGO			      as cod_promocion,
    PROMOCION_DESCRIPCION   as descripcion,
    PROMOCION_FECHA_INICIO  as fecha_inicio,
    PROMOCION_FECHA_FIN     as fecha_final
  FROM gd_esquema.Maestra
  WHERE
  PROMO_CODIGO			     is not null and
  PROMOCION_DESCRIPCION  is not null and
  PROMOCION_FECHA_INICIO is not null and
  PROMOCION_FECHA_FIN    is not null
  IF @@ERROR != 0
  PRINT('SP PROMOCION FAIL!')
  ELSE
  PRINT('SP PROMOCION OK!')
END


GO
CREATE PROCEDURE [TESLA_TEAM].migrar_medio_pago 
AS 
BEGIN
  INSERT INTO [TESLA_TEAM].medio_pago(tipo, nombre)
  SELECT DISTINCT
    PAGO_TIPO_MEDIO_PAGO  as tipo,
    PAGO_MEDIO_PAGO       as nombre
  FROM gd_esquema.Maestra
  WHERE 
  PAGO_MEDIO_PAGO      is not null and
  PAGO_TIPO_MEDIO_PAGO is not null
  IF @@ERROR != 0
  PRINT('SP MEDIO PAGO FAIL!')
  ELSE
  PRINT('SP MEDIO PAGO OK!')
END
 


GO
CREATE PROCEDURE [TESLA_TEAM].migrar_localidad
AS 
BEGIN
	INSERT INTO [TESLA_TEAM].localidad(nombre, id_provincia)
	(SELECT DISTINCT
    CLIENTE_LOCALIDAD,
    p.id_provincia
  FROM gd_esquema.Maestra
	JOIN provincia p on p.nombre = CLIENTE_PROVINCIA
	WHERE CLIENTE_LOCALIDAD  is not null
	AND CLIENTE_PROVINCIA    is not null)
    UNION 
  (SELECT DISTINCT
    SUPER_LOCALIDAD,
    p.id_provincia 
	FROM gd_esquema.Maestra
	JOIN provincia p on p.nombre = SUPER_PROVINCIA
	WHERE SUPER_LOCALIDAD  is not null
	AND SUPER_PROVINCIA    is not null)
	  UNION 
  (SELECT DISTINCT
    SUCURSAL_LOCALIDAD,
    p.id_provincia
	FROM gd_esquema.Maestra 
	JOIN TESLA_TEAM.provincia p on p.nombre = SUCURSAL_PROVINCIA
	WHERE SUCURSAL_LOCALIDAD   is not null
	AND SUCURSAL_PROVINCIA     is not null)
	IF @@ERROR != 0
	PRINT('SP LOCALIDAD FAIL!')
	ELSE
	PRINT('SP LOCALIDAD OK!')
END


GO
CREATE PROCEDURE [TESLA_TEAM].migrar_provincia
AS 
BEGIN
	INSERT INTO [TESLA_TEAM].provincia(nombre)
	(SELECT DISTINCT
    CLIENTE_PROVINCIA as nombre 
	FROM gd_esquema.Maestra 
	WHERE CLIENTE_PROVINCIA is not null)
    UNION 
  (SELECT DISTINCT
    SUPER_PROVINCIA
	FROM gd_esquema.Maestra 
	WHERE SUPER_PROVINCIA is not null)
	  UNION 
  (SELECT DISTINCT
    SUCURSAL_PROVINCIA
	FROM gd_esquema.Maestra 
	WHERE SUCURSAL_PROVINCIA is not null)
	IF @@ERROR != 0
	PRINT('SP PROVINCIA FAIL!')
	ELSE
	PRINT('SP PROVINCIA OK!')
END


GO
CREATE PROCEDURE [TESLA_TEAM].migrar_cliente 
AS 
BEGIN
  INSERT INTO [TESLA_TEAM].cliente(dni, nombre, apellido, domicilio, registro, telefono, mail, nacimiento, id_localidad, id_provincia)
  SELECT DISTINCT
    CLIENTE_DNI                 as dni,
    CLIENTE_NOMBRE              as nombre,
    CLIENTE_APELLIDO            as apellido,
    CLIENTE_DOMICILIO           as domicilio,
    CLIENTE_FECHA_REGISTRO      as registro,
    CLIENTE_TELEFONO            as telefono,
    CLIENTE_MAIL                as mail,
    CLIENTE_FECHA_NACIMIENTO    as nacimiento,
    l.id_localidad              as id_localidad,
    p.id_provincia              as id_provincia
  FROM gd_esquema.Maestra
  JOIN localidad l ON CLIENTE_LOCALIDAD = l.nombre
  JOIN provincia p ON CLIENTE_PROVINCIA = p.nombre AND l.id_provincia = p.id_provincia
  WHERE 
    CLIENTE_NOMBRE            is not null and
    CLIENTE_APELLIDO          is not null and
    CLIENTE_DNI               is not null and
    CLIENTE_FECHA_REGISTRO    is not null and
    CLIENTE_TELEFONO          is not null and
    CLIENTE_MAIL              is not null and
    CLIENTE_FECHA_NACIMIENTO  is not null and
    CLIENTE_DOMICILIO         is not null and
    CLIENTE_LOCALIDAD         is not null and
    CLIENTE_PROVINCIA         is not null
  IF @@ERROR != 0
  PRINT('SP MIGRAR CLIENTE FAIL!')
  ELSE
  PRINT('SP MIGRAR CLIENTE OK!')
END

GO
CREATE PROCEDURE [TESLA_TEAM].migrar_supermercado
AS
BEGIN
  INSERT INTO [TESLA_TEAM].supermercado(nombre, razon_social, cuit, iibb, domicilio, fecha_inicio_actividad, comision_fiscal, id_localidad, id_provincia)
  SELECT DISTINCT
    SUPER_NOMBRE                as nombre,
    SUPER_RAZON_SOC             as razon_social,
    SUPER_CUIT                  as cuit,
    SUPER_IIBB                  as iibb,
    SUPER_DOMICILIO             as domicilio,
    SUPER_FECHA_INI_ACTIVIDAD   as fecha_inicio_actividad,
    SUPER_CONDICION_FISCAL      as comision_fiscal,
    l.id_localidad              as id_localidad,
    p.id_provincia              as id_provincia
  FROM gd_esquema.Maestra
  JOIN localidad l ON SUPER_LOCALIDAD = l.nombre
  JOIN provincia p ON SUPER_PROVINCIA = p.nombre AND l.id_provincia = p.id_provincia
  WHERE
    SUPER_NOMBRE              is not null and
    SUPER_RAZON_SOC           is not null and
    SUPER_CUIT                is not null and
    SUPER_IIBB                is not null and
    SUPER_DOMICILIO           is not null and
    SUPER_FECHA_INI_ACTIVIDAD is not null and
    SUPER_CONDICION_FISCAL    is not null and
    SUPER_LOCALIDAD           is not null and
    SUPER_PROVINCIA           is not null
  IF @@ERROR != 0
  PRINT('SP MIGRAR SUPERMERCADO FAIL!')
  ELSE
  PRINT('SP MIGRAR SUPERMERCADO OK!')
END

GO
CREATE PROCEDURE [TESLA_TEAM].migrar_sucursal
AS
BEGIN
  INSERT INTO [TESLA_TEAM].sucursal(id_supermercado, nombre, direccion, id_localidad, id_provincia)
  SELECT DISTINCT
    s.id_supermercado   as id_supermercado,
    SUCURSAL_NOMBRE     as nombre,
    SUCURSAL_DIRECCION  as direccion,
    l.id_localidad      as id_localidad,
    p.id_provincia      as id_provincia
  FROM gd_esquema.Maestra
  JOIN [TESLA_TEAM].localidad l    on l.nombre = SUCURSAL_LOCALIDAD
  JOIN [TESLA_TEAM].provincia p    on p.id_provincia = l.id_provincia
  JOIN [TESLA_TEAM].supermercado s on s.nombre = SUPER_NOMBRE
  WHERE
  SUCURSAL_NOMBRE    is not null and
  SUCURSAL_DIRECCION is not null and
  SUCURSAL_LOCALIDAD is not null and
  SUCURSAL_PROVINCIA is not null
  IF @@ERROR != 0
  PRINT('SP Sucursal FAIL!')
  ELSE
  PRINT('SP Sucursal OK!')
END

GO
CREATE PROCEDURE [TESLA_TEAM].migrar_caja 
AS 
BEGIN
  INSERT INTO [TESLA_TEAM].caja(nro_caja, id_sucursal,id_tipo_caja)
  SELECT DISTINCT
	  CAJA_NUMERO         as nro_caja,
    suc.id_sucursal     as id_sucursal,
	  t.id_tipo_caja      as id_tipo_caja
  FROM gd_esquema.Maestra

  JOIN tipo_caja t      on CAJA_TIPO = t.nombre
  JOIN supermercado sup on SUPER_NOMBRE = sup.nombre
  JOIN sucursal suc     on SUCURSAL_NOMBRE = suc.nombre and suc.id_supermercado = sup.id_supermercado

  WHERE CAJA_TIPO is not null and SUCURSAL_NOMBRE is not null and CAJA_NUMERO is not null

  IF @@ERROR != 0
  PRINT('SP CAJA FAIL!')
  ELSE
  PRINT('SP CAJA OK!')
END

GO
CREATE PROCEDURE [TESLA_TEAM].migrar_detalle_pago
AS 
BEGIN
  INSERT INTO [TESLA_TEAM].detalle_pago(id_cliente, nro_tarjeta, vencimiento_tarjeta, cuotas)

  SELECT
    MAX(c.id_cliente)            as id_cliente,
    MAX(PAGO_TARJETA_NRO)        as nro_tarjeta,
    MAX(PAGO_TARJETA_FECHA_VENC) as vencimiento_tarjeta,
    MAX(PAGO_TARJETA_CUOTAS)     as cuotas
  FROM [gd_esquema].[Maestra]
  LEFT OUTER JOIN TESLA_TEAM.cliente c ON CLIENTE_DNI = c.dni
  WHERE CLIENTE_DNI is not null OR PAGO_TARJETA_NRO is not null
  GROUP BY TICKET_NUMERO, SUCURSAL_NOMBRE, TICKET_FECHA_HORA
  HAVING MAX(PAGO_TARJETA_NRO) is not null

  IF @@ERROR != 0
  PRINT('SP DETALLE PAGO FAIL!')
  ELSE
  PRINT('SP DETALLE PAGO OK!')
END

GO
CREATE PROCEDURE [TESLA_TEAM].migrar_descuento_medio_pago 
AS 
BEGIN
  INSERT INTO [TESLA_TEAM].descuento_medio_pago(cod_descuento, descripcion, fecha_inicio, fecha_final, porcentaje, tope)
  SELECT DISTINCT 
    DESCUENTO_CODIGO          as cod_descuento,
    DESCUENTO_DESCRIPCION     as descripcion,
    DESCUENTO_FECHA_INICIO    as fecha_inicio,
    DESCUENTO_FECHA_FIN       as fecha_final,
    DESCUENTO_PORCENTAJE_DESC as porcentaje,
    DESCUENTO_TOPE            as tope
  FROM gd_esquema.Maestra
  WHERE 
  DESCUENTO_CODIGO          is not null and
  DESCUENTO_FECHA_INICIO    is not null and
  DESCUENTO_FECHA_FIN       is not null and
  DESCUENTO_PORCENTAJE_DESC is not null and
  DESCUENTO_TOPE            is not null
  IF @@ERROR != 0
  PRINT('SP DESCUENTO MEDIO PAGO FAIL!')
  ELSE
  PRINT('SP DESCUENTO MEDIO PAGO OK!')
END

GO
CREATE PROCEDURE [TESLA_TEAM].migrar_empleado
AS 
BEGIN
  INSERT INTO [TESLA_TEAM].empleado(id_sucursal, dni, nombre, apellido, telefono, mail, nacimiento, registro)
  SELECT DISTINCT                        
    suc.id_sucursal           as id_sucursal,
    EMPLEADO_DNI              as dni,
    EMPLEADO_NOMBRE           as nombre,
    EMPLEADO_APELLIDO         as apellido,
    EMPLEADO_TELEFONO         as telefono,
    EMPLEADO_MAIL             as mail,
    EMPLEADO_FECHA_NACIMIENTO as nacimiento,
    EMPLEADO_FECHA_REGISTRO   as registro
  FROM gd_esquema.Maestra

  JOIN supermercado sup ON SUPER_NOMBRE = sup.nombre
  JOIN sucursal suc ON suc.id_supermercado = sup.id_supermercado AND SUCURSAL_NOMBRE = suc.nombre

  WHERE
  EMPLEADO_DNI            is not null and
  EMPLEADO_NOMBRE         is not null and
  EMPLEADO_FECHA_REGISTRO is not null
  IF @@ERROR != 0
  PRINT('SP EMPLEADO FAIL!')
  ELSE
  PRINT('SP EMPLEADO OK!')
END

GO
CREATE PROCEDURE [TESLA_TEAM].migrar_producto_x_promocion_producto
AS 
BEGIN
  INSERT INTO [TESLA_TEAM].producto_x_promocion_producto(id_producto, cod_promocion)
  
  SELECT DISTINCT
    p.id_producto as id_producto,
    PROMO_CODIGO  as cod_promocion
  FROM gd_esquema.Maestra

  JOIN TESLA_TEAM.categoria c ON PRODUCTO_CATEGORIA = c.categoria
    JOIN TESLA_TEAM.subcategoria s ON
        s.subcategoria = PRODUCTO_SUB_CATEGORIA AND
        s.id_categoria = c.id_categoria
        JOIN TESLA_TEAM.producto p ON
          s.id_subcategoria = p.id_subcategoria AND
          PRODUCTO_NOMBRE = p.nombre AND
          PRODUCTO_PRECIO = p.precio AND
          PRODUCTO_DESCRIPCION = p.descripcion AND
          PRODUCTO_MARCA = p.marca

  WHERE PROMO_CODIGO is not null
  IF @@ERROR != 0
  PRINT('SP PRODUCTO X PROMOCION_PRODUCTO FAIL!')
  ELSE
  PRINT('SP PRODUCTO X PROMOCION_PRODUCTO OK!')
END

GO
CREATE PROCEDURE [TESLA_TEAM].migrar_promocion_producto_x_regla
AS 
BEGIN
  INSERT INTO [TESLA_TEAM].promocion_producto_x_regla(cod_promocion, id_regla)
  SELECT DISTINCT
    PROMO_CODIGO   as cod_promocion,
	  r.id_regla	   as id_regla
  FROM [GD1C2024].[gd_esquema].[Maestra]

  JOIN regla r ON
	REGLA_APLICA_MISMA_MARCA        = r.misma_marca                   AND
	REGLA_APLICA_MISMO_PROD         = r.mismo_producto                AND
	REGLA_CANT_APLICA_DESCUENTO     = r.cantidad_aplicable_descuento  AND
  REGLA_CANT_APLICABLE_REGLA      = r.cantidad_aplicable_regla      AND
	REGLA_CANT_MAX_PROD             = r.veces_aplicable               AND
	REGLA_DESCRIPCION               = r.descripcion                   AND
	REGLA_DESCUENTO_APLICABLE_PROD  = r.descuento

  WHERE
  PROMO_CODIGO is not null
  IF @@ERROR != 0
  PRINT('SP PROMOCION_PRODUCTO X REGLA FAIL!')
  ELSE
  PRINT('SP PROMOCION_PRODUCTO X REGLA OK!')
END

GO
CREATE PROCEDURE [TESLA_TEAM].migrar_descuento_x_medio_pago
AS 
BEGIN
  INSERT INTO [TESLA_TEAM].descuento_x_medio_pago(id_medio_pago, cod_descuento)
  SELECT DISTINCT
    m.id_medio_pago  as id_medio_pago,
	  DESCUENTO_CODIGO as cod_descuento
  FROM [GD1C2024].[gd_esquema].[Maestra]

  JOIN medio_pago m ON
	PAGO_MEDIO_PAGO = m.nombre AND
	PAGO_TIPO_MEDIO_PAGO = m.tipo

  WHERE
	PAGO_MEDIO_PAGO is not null AND
	PAGO_TIPO_MEDIO_PAGO is not null AND
	DESCUENTO_CODIGO is not null
  IF @@ERROR != 0
  PRINT('SP DESCUENTO X MEDIO_PAGO FAIL!')
  ELSE
  PRINT('SP DESCUENTO X MEDIO_PAGO OK!')
END

GO
CREATE PROCEDURE [TESLA_TEAM].migrar_envio
AS 
BEGIN
  INSERT INTO [TESLA_TEAM].envio(id_venta, id_cliente, fecha_programada, hora_rango_inicio, hora_rango_final, costo, estado, fecha_entrega)
  
  SELECT DISTINCT
    v.id_venta		            as id_venta,
    c.id_cliente		        as id_cliente,
    ENVIO_FECHA_PROGRAMADA	    as fecha_programada,
    ENVIO_HORA_INICIO	        as hora_rango_inicio,
    ENVIO_HORA_FIN		        as hora_rango_final,
    ENVIO_COSTO			        as costo,
    ENVIO_ESTADO		        as estado,
    ENVIO_FECHA_ENTREGA	        as fecha_entrega
  FROM [GD1C2024].[gd_esquema].[Maestra]

  JOIN TESLA_TEAM.cliente c ON CLIENTE_DNI = c.dni
  JOIN TESLA_TEAM.supermercado sup ON SUPER_NOMBRE = sup.nombre
  JOIN TESLA_TEAM.sucursal suc ON suc.id_supermercado = sup.id_supermercado AND SUCURSAL_NOMBRE = suc.nombre
  JOIN TESLA_TEAM.venta v ON
      TICKET_NUMERO = v.nro_ticket AND
      TICKET_FECHA_HORA = v.fecha AND
      suc.id_sucursal = v.id_sucursal
  WHERE ENVIO_COSTO is not null

  IF @@ERROR != 0
  PRINT('SP ENVIO FAIL!')
  ELSE
  PRINT('SP ENVIO OK!')
END

GO
CREATE PROCEDURE [TESLA_TEAM].migrar_venta
AS 
BEGIN
  INSERT INTO [TESLA_TEAM].venta(nro_ticket, id_sucursal, fecha, legajo_empleado, nro_caja, tipo_comprobante, sub_total, descuento_promociones, descuento_medio, total, total_costo_envios)
  
  SELECT
    TICKET_NUMERO                           as nro_ticket,
    suc.id_sucursal                         as id_sucursal,
    TICKET_FECHA_HORA                       as fecha,
    MAX(e.legajo_empleado)                  as legajo_empleado,
    MAX(CAJA_NUMERO)                        as nro_caja,
    MAX(TICKET_TIPO_COMPROBANTE)            as tipo_comprobante,
    MAX(TICKET_SUBTOTAL_PRODUCTOS)          as sub_total,
    MAX(TICKET_TOTAL_DESCUENTO_APLICADO)    as descuento_promociones,
    MAX(TICKET_TOTAL_DESCUENTO_APLICADO_MP) as descuento_medio,
    MAX(TICKET_TOTAL_TICKET)                as total,
    MAX(TICKET_TOTAL_ENVIO)                 as total_costo_envios
  FROM [gd_esquema].[Maestra]
  JOIN TESLA_TEAM.empleado e ON EMPLEADO_DNI = e.dni
  JOIN TESLA_TEAM.supermercado sup ON SUPER_NOMBRE = sup.nombre
  JOIN TESLA_TEAM.sucursal suc ON suc.id_supermercado = sup.id_supermercado AND SUCURSAL_NOMBRE = suc.nombre
  GROUP BY TICKET_NUMERO, suc.id_sucursal, TICKET_FECHA_HORA

  IF @@ERROR != 0
  PRINT('SP VENTA FAIL!')
  ELSE
  PRINT('SP VENTA OK!')
END


GO
CREATE PROCEDURE [TESLA_TEAM].migrar_pago 
AS 
BEGIN
  INSERT INTO [TESLA_TEAM].pago(id_venta, id_medio_pago, id_detalle_pago, fecha_pago, importe, descuento_aplicado)
  
  SELECT
    v.id_venta              as id_venta,
    mp.id_medio_pago        as id_medio_pago,
    MAX(dp.id_detalle_pago) as id_detalle_pago,
    PAGO_FECHA              as fecha_pago,
    PAGO_IMPORTE            as importe,
    PAGO_DESCUENTO_APLICADO as descuento_aplicado
  FROM [gd_esquema].[Maestra]
  LEFT OUTER JOIN [GD1C2024].TESLA_TEAM.medio_pago mp ON mp.nombre = PAGO_MEDIO_PAGO
  JOIN TESLA_TEAM.supermercado sup ON SUPER_NOMBRE = sup.nombre
  JOIN TESLA_TEAM.sucursal s ON SUCURSAL_NOMBRE = s.nombre AND SUPER_NOMBRE = sup.nombre
  JOIN TESLA_TEAM.venta v ON
      TICKET_NUMERO = v.nro_ticket AND
      SUCURSAL_NOMBRE = s.nombre AND
      TICKET_FECHA_HORA = v.fecha
  LEFT OUTER JOIN TESLA_TEAM.detalle_pago dp ON
      PAGO_TARJETA_NRO = dp.nro_tarjeta AND
      PAGO_TARJETA_FECHA_VENC = dp.vencimiento_tarjeta AND
      PAGO_TARJETA_CUOTAS = dp.cuotas
  WHERE PAGO_IMPORTE is not null
  GROUP BY v.id_venta, mp.id_medio_pago, PAGO_FECHA, PAGO_IMPORTE, PAGO_DESCUENTO_APLICADO

  IF @@ERROR != 0
  PRINT('SP PAGO FAIL!')
  ELSE
  PRINT('SP PAGO OK!')
END


GO
CREATE PROCEDURE [TESLA_TEAM].migrar_producto_vendido
AS 
BEGIN
  INSERT INTO [TESLA_TEAM].producto_vendido(id_venta, id_producto, cantidad, precio_total)
  
  SELECT
    v.id_venta                                                  as id_venta,
    p.id_producto                                               as id_producto,
    SUM(TICKET_DET_CANTIDAD)                                    as cantidad,
    SUM(TICKET_DET_TOTAL - isnull(PROMO_APLICADA_DESCUENTO,0))  as precio_total
  FROM gd_esquema.Maestra
  JOIN TESLA_TEAM.categoria c ON PRODUCTO_CATEGORIA = c.categoria
    JOIN TESLA_TEAM.subcategoria s ON
        s.subcategoria = PRODUCTO_SUB_CATEGORIA AND
        s.id_categoria = c.id_categoria
  JOIN TESLA_TEAM.producto p ON
      s.id_subcategoria = p.id_subcategoria AND
      PRODUCTO_NOMBRE = p.nombre AND
      PRODUCTO_DESCRIPCION = p.descripcion AND
      PRODUCTO_PRECIO = p.precio AND
      PRODUCTO_MARCA = p.marca
  JOIN TESLA_TEAM.supermercado sup ON SUPER_NOMBRE = sup.nombre
  JOIN TESLA_TEAM.sucursal suc ON SUCURSAL_NOMBRE = suc.nombre AND SUPER_NOMBRE = sup.nombre
  JOIN TESLA_TEAM.venta v ON
      TICKET_NUMERO = v.nro_ticket AND
      SUCURSAL_NOMBRE = suc.nombre AND
      TICKET_FECHA_HORA = v.fecha
  GROUP BY v.id_venta, p.id_producto

  IF @@ERROR != 0
    PRINT('SP PRODUCTO VENDIDO FAIL!')
  ELSE
    PRINT('SP PRODUCTO VENDIDO OK!')
END

GO
CREATE PROCEDURE [TESLA_TEAM].migrar_promocion_aplicada
AS
BEGIN
  INSERT INTO [TESLA_TEAM].promocion_aplicada(id_venta, id_producto, cod_promocion, descuento_total)

  SELECT
    v.id_venta                    as id_venta,
    p.id_producto                 as id_producto,
    PROMO_CODIGO                  as cod_promocion,
    SUM(PROMO_APLICADA_DESCUENTO) as descuento_total
  FROM gd_esquema.Maestra
  JOIN TESLA_TEAM.categoria c ON PRODUCTO_CATEGORIA = c.categoria
    JOIN TESLA_TEAM.subcategoria s ON
        s.subcategoria = PRODUCTO_SUB_CATEGORIA AND
        s.id_categoria = c.id_categoria
  JOIN TESLA_TEAM.producto p ON
      s.id_subcategoria = p.id_subcategoria AND
      PRODUCTO_NOMBRE = p.nombre AND
      PRODUCTO_DESCRIPCION = p.descripcion AND
      PRODUCTO_PRECIO = p.precio AND
      PRODUCTO_MARCA = p.marca
  JOIN TESLA_TEAM.supermercado sup ON SUPER_NOMBRE = sup.nombre
  JOIN TESLA_TEAM.sucursal suc ON SUCURSAL_NOMBRE = suc.nombre AND SUPER_NOMBRE = sup.nombre
  JOIN TESLA_TEAM.venta v ON
      TICKET_NUMERO = v.nro_ticket AND
      SUCURSAL_NOMBRE = suc.nombre AND
      TICKET_FECHA_HORA = v.fecha
  WHERE PROMO_CODIGO is not null
  GROUP BY v.id_venta, p.id_producto, PROMO_CODIGO

  IF @@ERROR != 0
  PRINT('SP PROMOCION APLICADA FAIL!')
  ELSE
  PRINT('SP PROMOCION APLICADA OK!')
END

-- FIN: NORMALIZACION DE DATOS - STORED PROCEDURES.

-- INICIO: EJECUCION DE PROCEDURES.

GO
EXEC TESLA_TEAM.migrar_tipo_caja

GO
EXEC TESLA_TEAM.migrar_categoria

GO
EXEC TESLA_TEAM.migrar_subcategoria

GO
EXEC TESLA_TEAM.migrar_producto

GO
EXEC TESLA_TEAM.migrar_regla

GO
EXEC TESLA_TEAM.migrar_promocion_producto

GO
EXEC TESLA_TEAM.migrar_promocion_producto_x_regla

GO
EXEC TESLA_TEAM.migrar_producto_x_promocion_producto

GO
EXEC TESLA_TEAM.migrar_provincia

GO
EXEC TESLA_TEAM.migrar_localidad

GO
EXEC TESLA_TEAM.migrar_cliente

GO
EXEC TESLA_TEAM.migrar_supermercado

GO
EXEC TESLA_TEAM.migrar_sucursal

GO
EXEC TESLA_TEAM.migrar_caja

GO
EXEC TESLA_TEAM.migrar_descuento_medio_pago

GO
EXEC TESLA_TEAM.migrar_medio_pago

GO
EXEC TESLA_TEAM.migrar_descuento_x_medio_pago

GO
EXEC TESLA_TEAM.migrar_empleado

GO
EXEC TESLA_TEAM.migrar_venta

GO
EXEC TESLA_TEAM.migrar_envio

GO
EXEC TESLA_TEAM.migrar_detalle_pago

GO
EXEC TESLA_TEAM.migrar_pago

GO
EXEC TESLA_TEAM.migrar_producto_vendido

GO
EXEC TESLA_TEAM.migrar_promocion_aplicada

-- FIN: EJECUCION DE PROCEDURES.
