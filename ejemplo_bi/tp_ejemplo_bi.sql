USE [GD1C2024]
GO

-- Crea dimension Rango_Etario
CREATE TABLE TESLA_TEAM.BI_rango_etario (
    id_rango_etario INT IDENTITY(1,1),
    edad_min INT,
    edad_max INT,
    PRIMARY KEY (id_rango_etario)
);

-- Crea dimension Turno
CREATE TABLE TESLA_TEAM.BI_turno (
    id_turno INT IDENTITY(1,1),
    inicio_turno INT,
    fin_turno INT,
    PRIMARY KEY (id_turno)
);

-- Crea dimension Ubicacion
CREATE TABLE TESLA_TEAM.BI_ubicacion (
    id_localidad INT,
    nombre NVARCHAR(255),
    PRIMARY KEY (id_localidad)
);

-- Crea dimension Tipo_Caja
CREATE TABLE TESLA_TEAM.BI_tipo_caja (
    id_tipo_caja INT,
    nombre NVARCHAR(255),
    PRIMARY KEY (id_tipo_caja)
);

-- Crea dimension Sucursal
CREATE TABLE TESLA_TEAM.BI_sucursal (
    id_sucursal INT,
    nombre NVARCHAR(255),
    PRIMARY KEY (id_sucursal)
);

-- Crea dimension Categoria/Subcategoria
CREATE TABLE TESLA_TEAM.BI_categoria (
    id_categoria INT,
    categoria NVARCHAR(255),
    PRIMARY KEY (id_categoria)
);

-- Crea dimension Tiempo
CREATE TABLE TESLA_TEAM.BI_tiempo (
    id_tiempo INT IDENTITY(1,1),
    mes INT,
    cuatrimestre INT,
    anio INT,
    PRIMARY KEY (id_tiempo)
);

-- Crea dimension Medio_Pago
CREATE TABLE TESLA_TEAM.BI_medio_pago (
    id_medio_pago INT,
    nombre NVARCHAR(255),
    PRIMARY KEY (id_medio_pago)
);

-- Crea tabla Venta
CREATE TABLE TESLA_TEAM.BI_venta (
    id_ubicacion INT,
    id_tiempo INT,
    total DECIMAL(18,2),
    descuento_total DECIMAL(18,2),
    id_turno INT,
    cantidad_unidades decimal(18,0),
    id_rango_empleado INT,
    id_tipo_caja INT,
    CONSTRAINT [FK_id_ubicacion_en_BI_venta.id_ubicacion]
        FOREIGN KEY ([id_ubicacion])
        REFERENCES [TESLA_TEAM].[BI_ubicacion]([id_localidad]),
    CONSTRAINT [FK_id_tiempo_en_BI_venta.id_tiempo]
        FOREIGN KEY ([id_tiempo])
        REFERENCES [TESLA_TEAM].[BI_tiempo]([id_tiempo]),
    CONSTRAINT [FK_id_turno_en_BI_venta.id_turno]
        FOREIGN KEY ([id_turno])
        REFERENCES [TESLA_TEAM].[BI_turno]([id_turno]),
    CONSTRAINT [FK_id_rango_empleado_en_BI_venta.id_rango_empleado]
        FOREIGN KEY ([id_rango_empleado])
        REFERENCES [TESLA_TEAM].[BI_rango_etario]([id_rango_etario]),
    CONSTRAINT [FK_id_tipo_caja_en_BI_venta.id_tipo_caja]
        FOREIGN KEY ([id_tipo_caja])
        REFERENCES [TESLA_TEAM].[BI_tipo_caja]([id_tipo_caja])
);

-- Crea tabla Producto_Vendido
CREATE TABLE TESLA_TEAM.BI_producto_vendido (
    descuento_promo DECIMAL(18,2),
    id_categoria INT,
    id_tiempo INT
    CONSTRAINT [FK_id_categoria_en_BI_producto_vendido.id_categoria]
        FOREIGN KEY ([id_categoria])
        REFERENCES [TESLA_TEAM].[BI_categoria]([id_categoria]),
    CONSTRAINT [FK_id_tiempo_en_BI_producto_vendido.id_tiempo]
        FOREIGN KEY ([id_tiempo])
        REFERENCES [TESLA_TEAM].[BI_tiempo]([id_tiempo])
);

-- Crea tabla Envio
CREATE TABLE TESLA_TEAM.BI_envio (
    fecha_cumplida DECIMAL(18,2),
    cantidad_envios DECIMAL(18,2),
    id_sucursal INT,
    id_tiempo INT,
    id_rango_cliente INT,
    id_ubicacion_destino INT,
    costo_promedio DECIMAL(18,2),
    CONSTRAINT [FK_id_sucursal_en_BI_envio.id_sucursal]
        FOREIGN KEY ([id_sucursal])
        REFERENCES [TESLA_TEAM].[BI_sucursal]([id_sucursal]),
    CONSTRAINT [FK_id_tiempo_en_BI_envio.id_tiempo]
        FOREIGN KEY ([id_tiempo])
        REFERENCES [TESLA_TEAM].[BI_tiempo]([id_tiempo]),
    CONSTRAINT [FK_id_rango_cliente_en_BI_envio.id_rango_cliente]
        FOREIGN KEY ([id_rango_cliente])
        REFERENCES [TESLA_TEAM].[BI_rango_etario]([id_rango_etario]),
    CONSTRAINT [FK_id_ubicacion_destino_en_BI_envio.id_ubicacion_destino]
        FOREIGN KEY ([id_ubicacion_destino])
        REFERENCES [TESLA_TEAM].[BI_ubicacion]([id_localidad])
);

-- Crea tabla Pago
CREATE TABLE TESLA_TEAM.BI_pago (
    id_medio_pago INT,
    id_tiempo INT,
    id_sucursal INT,
    id_rango_cliente INT,
    cantidad_pagos_cuotas DECIMAL(18,2),
    suma_importe_cuotas DECIMAL(18,2),
    suma_importe_contado DECIMAL(18,2),
    importe_cuota_promedio DECIMAL(18,2),
    descuento_medio DECIMAL(18,2),
    CONSTRAINT [FK_id_sucursal_en_BI_pago.id_sucursal]
        FOREIGN KEY ([id_sucursal])
        REFERENCES [TESLA_TEAM].[BI_sucursal]([id_sucursal]),
    CONSTRAINT [FK_id_tiempo_en_BI_pago.id_tiempo]
        FOREIGN KEY ([id_tiempo])
        REFERENCES [TESLA_TEAM].[BI_tiempo]([id_tiempo]),
    CONSTRAINT [FK_id_rango_cliente_en_BI_pago.id_rango_cliente]
        FOREIGN KEY ([id_rango_cliente])
        REFERENCES [TESLA_TEAM].[BI_rango_etario]([id_rango_etario]),
    CONSTRAINT [FK_id_medio_pago_en_BI_pago.id_medio_pago]
        FOREIGN KEY ([id_medio_pago])
        REFERENCES [TESLA_TEAM].[BI_medio_pago]([id_medio_pago]),
);

-- Migraciones
GO
CREATE PROCEDURE [TESLA_TEAM].migrar_BI_rango_etario
AS
BEGIN
	INSERT INTO [TESLA_TEAM].BI_rango_etario(edad_min, edad_max) VALUES(0,25)
	INSERT INTO [TESLA_TEAM].BI_rango_etario(edad_min, edad_max) VALUES(25,35)
	INSERT INTO [TESLA_TEAM].BI_rango_etario(edad_min, edad_max) VALUES(35,50)
	INSERT INTO [TESLA_TEAM].BI_rango_etario(edad_min, edad_max) VALUES(50,200)
	IF @@ERROR != 0
	PRINT('SP RANGO ETARIO BI FAIL!')
	ELSE
	PRINT('SP RANGO ETARIO BI OK!')
END

GO
CREATE PROCEDURE [TESLA_TEAM].migrar_BI_turno
AS
BEGIN
	INSERT INTO [TESLA_TEAM].BI_turno(inicio_turno, fin_turno) VALUES(8,12)
	INSERT INTO [TESLA_TEAM].BI_turno(inicio_turno, fin_turno) VALUES(12,16)
	INSERT INTO [TESLA_TEAM].BI_turno(inicio_turno, fin_turno) VALUES(16,20)
	IF @@ERROR != 0
	PRINT('SP RANGO HORARIO BI FAIL!')
	ELSE
	PRINT('SP RANGO HORARIO BI OK!')
END
GO


GO
CREATE PROCEDURE [TESLA_TEAM].migrar_BI_ubicacion
AS
BEGIN
	INSERT INTO [TESLA_TEAM].BI_ubicacion(id_localidad,nombre)
	SELECT
		id_localidad,
        nombre
	FROM TESLA_TEAM.localidad
	IF @@ERROR != 0
	PRINT('SP BI_ubicacion  FAIL!')
	ELSE
	PRINT('SP BI_ubicacion OK!')
END
GO

GO
CREATE PROCEDURE [TESLA_TEAM].migrar_BI_tipo_caja
AS
BEGIN
    INSERT INTO [TESLA_TEAM].BI_tipo_caja(id_tipo_caja, nombre)
    SELECT
		id_tipo_caja,
        nombre
    FROM [TESLA_TEAM].tipo_caja
    IF @@ERROR != 0
    PRINT('SP TIPO CAJA BI FAIL!')
    ELSE
    PRINT('SP TIPO CAJA BI OK!')
END

GO
CREATE PROCEDURE [TESLA_TEAM].migrar_BI_sucursal
AS
BEGIN
    INSERT INTO [TESLA_TEAM].BI_sucursal(id_sucursal, nombre)
    SELECT
		id_sucursal,
        nombre
    FROM [TESLA_TEAM].sucursal
    IF @@ERROR != 0
    PRINT('SP BI sucursal FAIL!')
    ELSE
    PRINT('SP BI sucursal OK!')
END

GO
CREATE PROCEDURE [TESLA_TEAM].migrar_BI_categoria
AS
BEGIN
    INSERT INTO [TESLA_TEAM].BI_categoria(id_categoria, categoria)
    SELECT
		id_categoria,
        categoria
    FROM [TESLA_TEAM].categoria
    IF @@ERROR != 0
    PRINT('SP BI categoria FAIL!')
    ELSE
    PRINT('SP BI categoria OK!')
END


GO
CREATE PROCEDURE [TESLA_TEAM].migrar_BI_medio_pago
AS
BEGIN
    INSERT INTO [TESLA_TEAM].BI_medio_pago(id_medio_pago, nombre)
    SELECT
		id_medio_pago,
        nombre
    FROM [TESLA_TEAM].medio_pago
    IF @@ERROR != 0
    PRINT('SP BI medio pago FAIL!')
    ELSE
    PRINT('SP BI medio pago OK!')
END


GO
CREATE PROCEDURE [TESLA_TEAM].migrar_BI_tiempo
AS

DECLARE @primerAnio int = 1900;
DECLARE @primerMes int = 1;
SELECT @primerAnio = YEAR(MIN(fecha)), @primerMes = MONTH(MIN(fecha))
FROM [TESLA_TEAM].venta

DECLARE @cantidadMeses int = 12;
SELECT @cantidadMeses = DATEDIFF(month,MIN(f.fecha),MAX(f.fecha)) + 1
FROM (
    SELECT fecha FROM [TESLA_TEAM].venta
    UNION
    SELECT fecha_pago as fecha FROM [TESLA_TEAM].pago
    UNION
    SELECT fecha_programada as fecha FROM [TESLA_TEAM].envio
    UNION
    SELECT fecha_entrega as fecha FROM [TESLA_TEAM].envio
) as f

DECLARE @i int = @primerMes - 1;
WHILE @i < @cantidadMeses + @primerMes -1
BEGIN
    INSERT INTO [TESLA_TEAM].BI_tiempo(mes, cuatrimestre, anio) VALUES(
        (@i%12) + 1,
        ((@i/4)%3) + 1,
        @i/12 + @primerAnio
    )
    SET @i = @i + 1
    IF @@ERROR != 0
    PRINT('SP BI Tiempo FAIL!')
    ELSE
    PRINT('SP BI Tiempo OK!')
END

GO
CREATE FUNCTION [TESLA_TEAM].calcular_edad(@fecha_nacimiento DATE, @fechaEdad datetime)
RETURNS INT
AS
BEGIN
    DECLARE @edad INT;
    SET @edad = DATEDIFF(YEAR, @fecha_nacimiento, @fechaEdad);
    RETURN @edad;
END

GO
CREATE FUNCTION [TESLA_TEAM].obtener_rango_etario(@edad int)
RETURNS INT
AS
BEGIN
    DECLARE @id INT;
    SELECT @id = id_rango_etario
    FROM [TESLA_TEAM].BI_rango_etario
    WHERE @edad BETWEEN edad_min AND edad_max;
    RETURN isnull(@id,NULL);
END

GO
CREATE FUNCTION [TESLA_TEAM].obtener_rango_etario_cliente(@id_cliente int, @fechaEdad datetime)
RETURNS INT
AS
BEGIN
    DECLARE @edad INT;
    SELECT @edad = [TESLA_TEAM].calcular_edad(nacimiento, @fechaEdad)
    FROM [TESLA_TEAM].cliente
    WHERE id_cliente = @id_cliente;
    RETURN [TESLA_TEAM].obtener_rango_etario(@edad);
END

GO
CREATE FUNCTION [TESLA_TEAM].obtener_rango_etario_empleado(@legajo_empleado int, @fechaEdad datetime)
RETURNS INT
AS
BEGIN
    DECLARE @edad INT;
    SELECT @edad = [TESLA_TEAM].calcular_edad(nacimiento, @fechaEdad)
    FROM [TESLA_TEAM].empleado
    WHERE legajo_empleado = @legajo_empleado
    RETURN [TESLA_TEAM].obtener_rango_etario(@edad)
END

GO
CREATE FUNCTION [TESLA_TEAM].obtener_turno(@fecha datetime)
RETURNS INT
AS
BEGIN
    DECLARE @hora INT = DATEPART(HOUR, @fecha)
    DECLARE @id INT;
    SELECT @id = id_turno
    FROM [TESLA_TEAM].BI_turno
    WHERE @hora BETWEEN inicio_turno AND fin_turno
    RETURN isnull(@id, 1)
END

GO
CREATE PROCEDURE [TESLA_TEAM].migrar_BI_venta
AS
BEGIN
    INSERT INTO [TESLA_TEAM].BI_venta(id_ubicacion,id_tiempo,total,descuento_total,id_turno,cantidad_unidades,id_rango_empleado,id_tipo_caja)
    SELECT
        s.id_localidad,
        t.id_tiempo,
        v.total,
        MAX(v.descuento_promociones + v.descuento_medio) as descuento_total,
        MAX([TESLA_TEAM].obtener_turno(v.fecha)) as id_turno,
        SUM(pv.cantidad) as cantidad_unidades,
        MAX([TESLA_TEAM].obtener_rango_etario_empleado(v.legajo_empleado, v.fecha)) as id_rango_empleado,
        c.id_tipo_caja
    FROM [TESLA_TEAM].venta v
    JOIN [TESLA_TEAM].sucursal s on s.id_sucursal = v.id_sucursal
    JOIN [TESLA_TEAM].caja c on c.nro_caja = v.nro_caja and c.id_sucursal = v.id_sucursal
    JOIN [TESLA_TEAM].producto_vendido pv ON v.id_venta = pv.id_venta
    JOIN [TESLA_TEAM].BI_tiempo t ON MONTH(v.fecha) = t.mes AND YEAR(v.fecha) = t.anio
    GROUP BY
        s.id_localidad,
        t.id_tiempo,
        v.total,
        c.id_tipo_caja
    IF @@ERROR != 0
    PRINT('SP BI Venta FAIL!')
    ELSE
    PRINT('SP BI Venta OK!')
END

GO
CREATE PROCEDURE [TESLA_TEAM].migrar_BI_producto_vendido
AS
BEGIN
    INSERT INTO [TESLA_TEAM].BI_producto_vendido (descuento_promo,id_categoria,id_tiempo)
	SELECT
        SUM(pa.descuento_total),
        c.id_categoria,
        t.id_tiempo
	from [TESLA_TEAM].producto_vendido pv
	JOIN [TESLA_TEAM].venta v ON pv.id_venta = v.id_venta
    JOIN [TESLA_TEAM].BI_tiempo t ON MONTH(v.fecha) = t.mes AND YEAR(v.fecha) = t.anio
	JOIN [TESLA_TEAM].producto p ON pv.id_producto = p.id_producto
	JOIN [TESLA_TEAM].subcategoria sc ON sc.id_subcategoria = p.id_subcategoria
	JOIN [TESLA_TEAM].categoria c ON c.id_categoria = sc.id_categoria
    LEFT JOIN [TESLA_TEAM].promocion_aplicada pa ON pv.id_venta = pa.id_venta AND pv.id_producto = pa.id_producto
    GROUP BY
        c.id_categoria,
        t.id_tiempo
    ORDER BY id_tiempo, id_categoria
    IF @@ERROR != 0
    PRINT('SP BI Producto Vendido FAIL!')
    ELSE
    PRINT('SP BI Producto Vendido OK!')
END


GO
CREATE PROCEDURE [TESLA_TEAM].migrar_BI_envio
AS
BEGIN
    INSERT INTO [TESLA_TEAM].BI_envio (fecha_cumplida,cantidad_envios,id_sucursal,id_tiempo,id_rango_cliente,id_ubicacion_destino, costo_promedio)
    SELECT
        SUM(CASE
                WHEN    -- Distinta fecha
                    CAST(fecha_programada as date) != CAST(fecha_entrega as date)
                    OR  -- Fecha bien, fuera de horario
                    (CAST(fecha_programada as date) = CAST(fecha_entrega as date)
                    AND (DATEPART(HOUR, fecha_entrega) > hora_rango_final
                    OR DATEPART(HOUR, fecha_entrega) < hora_rango_inicio)) THEN 0
                ELSE 1
        END) as fecha_cumplida,
        COUNT(*) as cantidad_envios,
        v.id_sucursal,
        t.id_tiempo,
        [TESLA_TEAM].obtener_rango_etario_cliente(c.id_cliente, v.fecha) as id_rango_cliente,
        c.id_localidad,
        AVG(e.costo) as costo_promedio
    FROM [TESLA_TEAM].envio e
    JOIN [TESLA_TEAM].venta v ON v.id_venta = e.id_venta
    JOIN [TESLA_TEAM].cliente c ON e.id_cliente = c.id_cliente
    JOIN [TESLA_TEAM].sucursal s ON s.id_sucursal = v.id_sucursal
    JOIN [TESLA_TEAM].BI_tiempo t ON MONTH(e.fecha_entrega) = t.mes AND YEAR(e.fecha_entrega) = t.anio
    GROUP BY
        v.id_sucursal,
        t.id_tiempo,
        [TESLA_TEAM].obtener_rango_etario_cliente(c.id_cliente, v.fecha),
        c.id_localidad
    IF @@ERROR != 0
    PRINT('SP BI Envio FAIL!')
    ELSE
    PRINT('SP BI Envio OK!')
END

GO
CREATE PROCEDURE [TESLA_TEAM].migrar_BI_pago
AS
BEGIN
    INSERT INTO [TESLA_TEAM].BI_pago(id_medio_pago,id_tiempo,id_sucursal,id_rango_cliente,cantidad_pagos_cuotas,suma_importe_cuotas,suma_importe_contado,importe_cuota_promedio,descuento_medio)
	SELECT
        p.id_medio_pago,
        t.id_tiempo,
        v.id_sucursal,
        [TESLA_TEAM].obtener_rango_etario_cliente(dp.id_cliente, p.fecha_pago) as id_rango_cliente,
        SUM(CASE WHEN dp.cuotas is not null AND dp.cuotas > 1 THEN 1 ELSE 0 END) as cantidad_pagos_cuotas,
        SUM(CASE
                WHEN dp.cuotas is not null AND dp.cuotas > 1 THEN p.importe
                ELSE 0
        END) as suma_importe_cuotas,
        SUM(CASE
                WHEN dp.cuotas is null OR dp.cuotas <= 1 THEN p.importe
                ELSE 0
        END) as suma_importe_contado,
        (SUM(CASE
                WHEN dp.cuotas is not null AND dp.cuotas > 1 THEN p.importe / dp.cuotas
                ELSE 0
        END)
                /
        (CASE
            WHEN SUM(CASE WHEN dp.cuotas is not null AND dp.cuotas > 1 THEN 1 ELSE 0 END) = 0 THEN 1
            ELSE SUM(CASE WHEN dp.cuotas is not null AND dp.cuotas > 1 THEN 1 ELSE 0 END)
        END)) as importe_cuota_promedio,
        SUM(p.descuento_aplicado) as descuento_medio
    FROM [TESLA_TEAM].pago p
    JOIN [TESLA_TEAM].medio_pago mp on mp.id_medio_pago = p.id_medio_pago
    JOIN [TESLA_TEAM].venta v ON v.id_venta = p.id_venta
    LEFT JOIN [TESLA_TEAM].detalle_pago dp on dp.id_detalle_pago = p.id_detalle_pago
    JOIN [TESLA_TEAM].BI_tiempo t ON MONTH(p.fecha_pago) = t.mes AND YEAR(p.fecha_pago) = t.anio
    GROUP BY
        p.id_medio_pago,
        t.id_tiempo,
        v.id_sucursal,
        [TESLA_TEAM].obtener_rango_etario_cliente(dp.id_cliente, p.fecha_pago)
    IF @@ERROR != 0
    PRINT('SP BI Pago FAIL!')
    ELSE
    PRINT('SP BI Pago OK!')
END


-- Vistas
GO -- 1
CREATE VIEW [TESLA_TEAM].BI_Ticket_Promedio_Mensual
AS
SELECT
    v.id_ubicacion as Localidad,
    t.anio as Año,
    t.mes as Mes,
    AVG(v.total) AS [Promedio de ventas ($)]
FROM [TESLA_TEAM].BI_venta v
JOIN [TESLA_TEAM].BI_tiempo t ON t.id_tiempo = v.id_tiempo
GROUP BY v.id_ubicacion, t.anio, t.mes;

GO -- 2
CREATE VIEW [TESLA_TEAM].BI_Cantidad_Unidades_Promedio
AS
SELECT
	ti.anio AS Año,
    ti.cuatrimestre AS Cuatrimestre,
    v.id_turno AS Turno,
	AVG(v.cantidad_unidades) as [Cantidad promedio de unidades]
FROM [TESLA_TEAM].BI_venta v
JOIN [TESLA_TEAM].BI_tiempo ti ON ti.id_tiempo = v.id_tiempo
GROUP BY ti.anio, ti.cuatrimestre, v.id_turno

GO -- 3
CREATE VIEW [TESLA_TEAM].BI_Porcentaje_Anual_Ventas
AS
SELECT
	t.anio AS Año,
    t.cuatrimestre AS Cuatrimestre,
    v.id_rango_empleado AS [Rango etario (E)],
    v.id_tipo_caja AS [Tipo de caja],
    ROUND(count(*) * 100.0 / sum(count(*)) over(PARTITION BY t.anio), 4) AS [Porcentaje de ventas (%)]
FROM [TESLA_TEAM].BI_venta v
JOIN [TESLA_TEAM].BI_tiempo t ON t.id_tiempo = v.id_tiempo
GROUP BY t.anio, t.cuatrimestre, v.id_rango_empleado, v.id_tipo_caja

GO -- 4
CREATE VIEW [TESLA_TEAM].BI_Cantidad_Ventas_Registradas
AS
SELECT
    t.anio AS Año,
    t.mes AS Mes,
	v.id_turno AS Turno,
    v.id_ubicacion AS Localidad,
    COUNT(*) AS [Cantidad ventas]
FROM [TESLA_TEAM].BI_venta v
JOIN [TESLA_TEAM].BI_tiempo t ON t.id_tiempo = v.id_tiempo
GROUP BY t.anio, t.mes,v.id_turno, v.id_ubicacion

GO -- 5
CREATE VIEW [TESLA_TEAM].BI_Porcentaje_Descuento_Aplicado
AS
SELECT
    t.anio AS Año,
    t.mes AS Mes,
    CAST(ROUND((sum(v.descuento_total)/(sum(v.total)+sum(v.descuento_total))) * 100, 4) AS DECIMAL(12,4)) AS [Descuento aplicado (%)]
from [TESLA_TEAM].BI_Venta v
join [TESLA_TEAM].BI_tiempo t ON v.id_tiempo = t.id_tiempo
GROUP BY t.anio, t.mes

GO -- 6
CREATE VIEW [TESLA_TEAM].BI_Categorias_con_mayor_Descuento
AS
SELECT
    t.anio as Año,
    t.cuatrimestre as Cuatrimestre,
    ROW_NUMBER() over(PARTITION BY t.anio, t.cuatrimestre ORDER BY SUM(pv.descuento_promo) DESC) as Puesto,
    pv.id_categoria as Categoria
FROM [TESLA_TEAM].BI_producto_vendido pv
JOIN [TESLA_TEAM].BI_tiempo t ON pv.id_tiempo = t.id_tiempo
GROUP BY t.anio, t.cuatrimestre , pv.id_categoria

GO -- 7
CREATE VIEW [TESLA_TEAM].BI_Cumplimiento_Envios
AS
SELECT
    t.anio AS Año,
    t.mes AS Mes,
    e.id_sucursal AS Sucursal,
    ROUND(100 * SUM(e.fecha_cumplida) / SUM(e.cantidad_envios), 4) as [Porcentaje cumplimiento (%)]
FROM [TESLA_TEAM].BI_envio e
JOIN [TESLA_TEAM].BI_tiempo t on e.id_tiempo = t.id_tiempo
GROUP BY t.anio, t.mes, e.id_sucursal

GO -- 8
CREATE VIEW [TESLA_TEAM].BI_Envios_Rango_Etario
AS
SELECT
    t.anio AS Año,
    t.cuatrimestre AS Cuatrimestre,
    e.id_rango_cliente AS [Rango etario de los clientes],
    SUM(e.cantidad_envios) AS [Cantidad de envíos]
FROM [TESLA_TEAM].BI_envio e
JOIN [TESLA_TEAM].BI_tiempo t ON e.id_tiempo = t.id_tiempo
JOIN [TESLA_TEAM].BI_rango_etario re ON re.id_rango_etario = e.id_rango_cliente
GROUP BY t.anio, t.cuatrimestre, e.id_rango_cliente;

GO -- 9
CREATE VIEW [TESLA_TEAM].BI_Localidades_Mayor_Costo_Envio
AS
SELECT
    e.id_ubicacion_destino as [Localidad destino],
    ROW_NUMBER() over(ORDER BY SUM(e.costo_promedio * e.cantidad_envios) / SUM(e.cantidad_envios) DESC) as Puesto
FROM [TESLA_TEAM].BI_envio e
GROUP BY e.id_ubicacion_destino

GO -- 10
CREATE VIEW [TESLA_TEAM].BI_Sucursales_Mayor_Importe_Cuotas
AS
SELECT
    t.anio as Año,
    t.mes as Mes,
    p.id_medio_pago as [Medio de pago],
    ROW_NUMBER() over(PARTITION BY t.anio, t.mes, p.id_medio_pago ORDER BY SUM(p.suma_importe_cuotas) DESC) as Puesto,
    p.id_sucursal as [Sucursal]
FROM [TESLA_TEAM].BI_pago p
JOIN [TESLA_TEAM].BI_tiempo t ON p.id_tiempo = t.id_tiempo
WHERE p.suma_importe_cuotas > 0
GROUP BY t.anio, t.mes, p.id_medio_pago, p.id_sucursal

GO -- 11
CREATE VIEW [TESLA_TEAM].BI_Promedio_Importe_Cuota
AS
SELECT
    id_rango_cliente as [Rango etario de los clientes],
    SUM(importe_cuota_promedio * cantidad_pagos_cuotas) / SUM(cantidad_pagos_cuotas) as [Promedio importe cuota ($)]
FROM [TESLA_TEAM].BI_pago
GROUP BY id_rango_cliente

GO -- 12
CREATE VIEW [TESLA_TEAM].BI_Porcentaje_Descuento_Medio_Pago
AS
SELECT
    t.anio as Año,
    t.cuatrimestre as Cuatrimestre,
    p.id_medio_pago as [Medio de pago],
    ROUND(100 * (SUM(p.descuento_medio)/(SUM(p.suma_importe_cuotas)+SUM(p.suma_importe_contado)+SUM(p.descuento_medio))), 4) as [Porcentaje de descuento (%)]
FROM [TESLA_TEAM].BI_pago p
JOIN [TESLA_TEAM].BI_tiempo t ON p.id_tiempo = t.id_tiempo
GROUP BY t.anio, t.cuatrimestre, p.id_medio_pago

GO
EXEC TESLA_TEAM.migrar_BI_rango_etario

GO
EXEC TESLA_TEAM.migrar_BI_turno

GO
EXEC TESLA_TEAM.migrar_BI_ubicacion

GO
EXEC TESLA_TEAM.migrar_BI_tipo_caja

GO
EXEC TESLA_TEAM.migrar_BI_sucursal

GO
EXEC TESLA_TEAM.migrar_BI_categoria

GO
EXEC TESLA_TEAM.migrar_BI_tiempo

GO
EXEC TESLA_TEAM.migrar_BI_medio_pago

GO
EXEC TESLA_TEAM.migrar_BI_venta

GO
EXEC TESLA_TEAM.migrar_BI_producto_vendido

GO
EXEC TESLA_TEAM.migrar_BI_envio

GO
EXEC TESLA_TEAM.migrar_BI_pago

/* CONSULTAS DE VISTAS

-- 1
SELECT * FROM [TESLA_TEAM].BI_Ticket_Promedio_Mensual
-- 2
SELECT * FROM [TESLA_TEAM].BI_Cantidad_Unidades_Promedio
-- 3
SELECT * FROM [TESLA_TEAM].BI_Porcentaje_Anual_Ventas
-- 4
SELECT * FROM [TESLA_TEAM].BI_Cantidad_Ventas_Registradas
-- 5
SELECT * FROM [TESLA_TEAM].BI_Porcentaje_Descuento_Aplicado
-- 6
SELECT * FROM [TESLA_TEAM].BI_Categorias_con_mayor_Descuento
WHERE Puesto in (1,2,3)
-- 7
SELECT * FROM [TESLA_TEAM].BI_Cumplimiento_Envios
-- 8
SELECT * FROM [TESLA_TEAM].BI_Envios_Rango_Etario
-- 9
SELECT * FROM [TESLA_TEAM].BI_Localidades_Mayor_Costo_Envio
WHERE Puesto in (1,2,3,4,5)
-- 10
SELECT * FROM [TESLA_TEAM].BI_Sucursales_Mayor_Importe_Cuotas
WHERE Puesto in (1,2,3)
-- 11
SELECT * FROM [TESLA_TEAM].BI_Promedio_Importe_Cuota
-- 12
SELECT * FROM [TESLA_TEAM].BI_Porcentaje_Descuento_Medio_Pago

*/
