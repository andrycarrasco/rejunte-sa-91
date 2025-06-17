# rejunte-sa-91

[Documento de estategia](https://docs.google.com/document/d/1AvhBETJXtDPDTCWGxcB-HI_BDj7XrWqMHGBwwzTivP4/edit?usp=sharing)
---
> Integrantes:  
> Gutierrez Zevallos, Jose Leonardo - 212.988-7  
> Alpuy Feliu, Facundo - 172.969-0  
> Carrasco Chui, Andry Julian - 175.611-4

---
Para correr el archivo **.puml**, deben tener instalado:
- La extension [PlanUML](https://marketplace.visualstudio.com/items?itemName=jebbs.plantuml)
- [Java](http://java.com/en/download/) o 
``sudo apt install default-jre``
- [Graphviz](http://www.graphviz.org/download/) o
``sudo apt install graphviz ``
---

## Modelo BI (EN PROCESO)
### Creacion de Tablas/Dimensiones BI
- [X] BI_ubicacion
- [X] BI_tiempo
- [X] BI_rango_etario
- [X] BI_turno_ventas
- [X] BI_tipo_material
- [X] BI_modelo_sillon
- [X] BI_estado_pedido
- [X] BI_factura
- [X] BI_compra
- [X] BI_sucursal
- [X] BI_envio
- [x] Bi_cliente
- [X] BI_pedido

#### Dimensiones a tener en cuenta para cada vista
1. **Ganancias**: Total de ingresos (facturación) – total de egresos (compras), por cada mes, por cada sucursal.

> Hechos: Factura, Compra  
> Dimensiones: Tiempo, Sucursal

2. **Factura promedio mensual**: Valor promedio de las facturas (en $) según la provincia de la sucursal para cada cuatrimestre de cada año. Se calcula en función de la sumatoria del importe de las facturas sobre el total de las mismas durante dicho período.

> Hechos: Factura  
> Dimensiones: Sucursal, Ubicacion, Tiempo

3. **Rendimiento de modelos**: Los 3 modelos con mayores ventas para cada cuatrimestre de cada año según la localidad de la sucursal y rango etario de los clientes.

> Hechos: Pedido o Detalle_Pedido  
> Dimensiones: Modelo, Ubicacion, Sucursal, Tiempo, Cliente, Rango_Etario

4. **Volumen de pedidos**: Cantidad de pedidos registrados por turno, por sucursal según el mes de cada año.

> Hechos: Pedido  
> Dimensiones: Turno, Sucursal, Tiempo

5. **Conversión de pedidos**: Porcentaje de pedidos según estado, por cuatrimestre y sucursal.

> Hechos: Pedido  
> Dimensiones: Estado_Pedido, Tiempo, Sucursal

6. **Tiempo promedio de fabricación**: Tiempo promedio que tarda cada sucursal entre que se registra un pedido y registra la factura para el mismo. Por cuatrimestre.

> Hechos: Pedido + Factura  
> Dimensiones: Sucursal, Tiempo

7. **Promedio de Compras**: Importe promedio de compras por mes.

> Hechos: Compra  
> Dimensiones: Tiempo

8. **Compras por Tipo de Material**: Importe total gastado por tipo de material, sucursal y cuatrimestre.

> Hechos: Compra o Detalle_Compra  
> Dimensiones: Tipo_Material, Sucursal, Tiempo

9. **Porcentaje de cumplimiento de envíos** en los tiempos programados por mes.  
   Se calcula teniendo en cuenta los envíos cumplidos en fecha sobre el total de envíos para el período.

> Hechos: Envio  
> Dimensiones: Tiempo, Sucursal?

10. **Localidades que pagan mayor costo de envío**: Las 3 localidades (tomando la localidad del cliente) con mayor promedio de costo de envío (total).

> Hechos: Envio  
> Dimensiones: Ubicacion, Cliente



### Creacion de Procedures BI
- [x] migrar_bi_ubicacion
- [x] migrar_bi_tiempo
- [x] migrar_bi_turno_venta
- [x] migrar_bi_rango_etario
- [x] migrar_bi_estado_pedido
- [x] migrar_bi_factura
- [x] migrar_bi_compra
- [x] migrar_bi_sucursal
- [x] migrar_bi_modelo
- [x] migrar_bi_envio
- [x] migrar_bi_tipo_material
- [x] migrar_bi_cliente
- [x] migrar_bi_pedido
 
### Creacion de Views BI
- [x] 1-Ganancias
- [x] 2-Factura promedio mensual
- [ ] 3-Rendimiento de modelos
- [X] 4-Volumen de pedidos
- [ ] 5-Conversion de pedidos
- [ ] 6-Tiempo promedio de fabricación
- [ ] 7-Promedio de Compras
- [ ] 8-Compras por Tipo de Material
- [ ] 9-Porcentaje de cumpliento de envíos
- [ ] 10-Localidades que pagan mayor costo de envío

## Base de datos (LISTO)

### Creacion de Tablas
- [x] Pedido
- [x] Estado_Pedido
- [x] Detalle_Pedido
- [x] Cancelacion_Pedido
- [x] Sucursal
- [x] Cliente
- [x] Datos_Contacto
- [x] Localidad
- [x] Provincia
- [x] Proveedor
- [x] Factura
- [x] Compra
- [x] Detalle_Factura
- [x] Detalle_Compra
- [x] Envio
- [x] Sillon
- [x] Relleno
- [x] Densidad
- [x] Modelo
- [x] Medida
- [x] Tela
- [x] Textura
- [x] Madera
- [x] Dureza
- [x] Material_Tipo
- [x] Material
- [x] Color
- [x] Material_X_Tela
- [x] Material_X_Madera
- [x] Material_X_Relleno

## Creacion de Procedures
- [x] Pedido
- [x] Estado_Pedido
- [x] Detalle_Pedido
- [x] Cancelacion_Pedido
- [x] Sucursal
- [x] Cliente
- [x] Datos_Contacto
- [x] Localidad
- [x] Provincia
- [x] Proveedor
- [x] Factura
- [x] Compra
- [x] Detalle_Factura
- [x] Detalle_Compra
- [x] Envio
- [x] Sillon
- [x] Modelo
- [x] Medida
- [x] Relleno
- [x] Tela
- [x] Madera
- [x] Textura
- [x] Dureza
- [x] Color
- [x] Material
- [x] Material_Tipo
- [x] Material_X_Tela
- [x] Material_X_Madera
- [x] Material_X_Relleno
