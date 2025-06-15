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



#### Dimensiones a tener en cuenta para cada vista
1. Dimension mes    
2. Dimension provincia, cuatrimestre    
3. Dimension modelos, localidad y rango etario  
4. Dimension turnos, sucursal, mes  
5. Dimension estado, cuatrimestre y sucursal  
6. Dimension sucursal, cuatrimestre  
7. Dimension mes  
8. Dimension tipo_material, sucursal, cuatrimestre  
9. Dimension envios  
10. Dimension localidades  

### Creacion de Procedures BI
- [ ] migracion_bi_ubicacion
- [ ] migracion_bi_rango_etario
- [ ] migracion_bi_tiempo
- [ ] migracion_bi_turno_ventas
- [ ] migracion_bi_tipo_material
- [ ] migracion_bi_modelo_sillon
- [ ] migracion_bi_estado_pedido
 
### Creacion de Views BI
- [x] 1-Ganancias
- [ ] 2-Factura promedio mensual
- [ ] 3-Rendimiento de modelos
- [ ] 4-Volumen de pedidos
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
