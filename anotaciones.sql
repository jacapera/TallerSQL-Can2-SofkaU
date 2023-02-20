-- ----------------------------------------------------------
-- OTRAS ACCIONES CORRECTIVAS EN MI TALLER POR FAVOR IGNORAR
-- ----------------------------------------------------------

-- cuando has olvidado poner AUTO_INCREMENT
ALTER TABLE producto
CHANGE COLUMN prod_id prod_id INT NOT NULL AUTO_INCREMENT ;

-- cuando necesitas cambiar a NULL un campo en la tabla
/*
al crear la tabla productos los campos para guardar los id de las tablas relacionadas y
haberlos dejado NOT NULL al momento de ingresar un producto nuevo no me lo deja crear
porque se debe relacionar un id para venta y compra, por tal razon debo cambiar estos
campos a NULL
 */
-- primero eliminar llaves foraneas
ALTER TABLE producto
DROP FOREIGN KEY fk_producto_compra1,
DROP FOREIGN KEY fk_producto_venta1;

-- cambiando a NULL
ALTER TABLE producto
CHANGE COLUMN venta_ven_id venta_ven_id INT NULL ,
CHANGE COLUMN compra_comp_id compra_comp_id INT NULL ;

-- volviendo agregar las llaves foraneas
ALTER TABLE producto
ADD CONSTRAINT fk_producto_compra1
  FOREIGN KEY (compra_comp_id)
  REFERENCES compra (comp_id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
ADD CONSTRAINT fk_producto_venta1
  FOREIGN KEY (venta_ven_id)
  REFERENCES venta (ven_id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;

-- borrar de toda la tabla
-- nunca hacer esta ejecución es mala practica y echada segura
DELETE FROM producto;
DELETE FROM compra;

-- agregar un campo(columna) a la tabla
ALTER TABLE producto ADD COLUMN proveedor_id INTEGER;
-- actualiando valores al nuevo campo adicionado
UPDATE producto SET proveedor_id = 3 WHERE prod_id IN (7, 8, 9);
-- agregando campo(columna) para el borrado lógico en la tabla venta
ALTER TABLE venta ADD eliminada BOOLEAN DEFAULT 0 NOT NULL;

ALTER TABLE producto
CHANGE COLUMN proveedor_id prod_proveedor_id INT NULL DEFAULT NULL ;

--=======================================================================
--                      SELECT
--=======================================================================
-- -----------------------------------------------------
-- Tabla cliente
-- -----------------------------------------------------
SELECT
  cli_id,
  cli_nombre,
  cli_documento,
  cli_tipo_documento
FROM
  cliente;
-- -----------------------------------------------------
-- Tabla producto
-- -----------------------------------------------------
SELECT
  prod_id,
  cli_descripcion,
  prod_precio_compra,
  prod_precio_venta,
  prd.prov_nombre AS Proveedor
FROM
  producto p
JOIN proveedor prd ON p.proveedor_id = prd.prov_id;
-- -----------------------------------------------------
-- Tabla proveedor
-- -----------------------------------------------------
SELECT
  prov_id,
  prov_nombre,
  prov_email
FROM
  proveedor;
-- -----------------------------------------------------
-- Tabla telefono
-- -----------------------------------------------------
SELECT
  tel_id,
  tel_numero,
  proveedor_prov_id
FROM
  telefono;
-- -----------------------------------------------------
-- Tabla venta
-- -----------------------------------------------------
SELECT
  ven_id,
  ven_fecha,
  ven_valor_total,
  cliente_cli_id
FROM
  venta;
-- -----------------------------------------------------
-- Tabla compra
-- -----------------------------------------------------
SELECT
  comp_id,
  comp_fecha,
  comp_valor-total,
  proveedor_prov_id
FROM
  compra;
-- -----------------------------------------------------
-- Tabla detalle_compra
-- -----------------------------------------------------
SELECT
  iddetalle_compra,
  compra_comp_id,
  producto_prod_id,
  detcomp_cantidad_producto
FROM
  detalle_compra;
-- -----------------------------------------------------
-- Tabla detalle_venta
-- -----------------------------------------------------
SELECT
  iddetalle_venta,
  detven_cantidad_producto,
  venta_ven_id,
  producto_prod_id
FROM
  detalle_venta;
-- -----------------------------------------------------
-- consulta de compras
-- -----------------------------------------------------
SELECT
  c.comp_id AS Id,
  p.prov_nombre AS Proveedor,
  c.comp_fecha AS Fecha,
  pr.prod_id AS Id_Producto,
  pr.prod_descripcion AS Descripcion,
  dc.detcomp_cantidad_producto AS Cantidad,
  pr.prod_precio_compra AS Valor_Unitario,
  dc.detcomp_cantidad_producto * pr.prod_precio_compra AS Subtotal,
  c.comp_valor_total AS Total_Compra
FROM
  compra c
JOIN proveedor p ON c.proveedor_prov_id = p.prov_id
JOIN detalle_compra dc ON c.comp_id = dc.compra_comp_id
JOIN producto pr ON dc.producto_prod_id = pr.prod_id;
-- -----------------------------------------------------
-- consulta de ventas
-- -----------------------------------------------------
SELECT
  v.ven_id AS Id,
  cl.cli_nombre AS Cliente,
  v.ven_fecha AS Fecha,
  dv.detven_cantidad_producto AS Cant,
  pr.prod_descripcion AS Producto,
  pr.prod_precio_venta AS Precio,
  dv.detven_cantidad_producto * pr.prod_precio_venta AS Subtotal,
  v.ven_valor_total AS Total_Venta
FROM
  venta v
JOIN cliente cl ON v.cliente_cli_id = cl.cli_id
JOIN detalle_venta dv ON v.ven_id = dv.venta_ven_id
JOIN producto pr ON dv.producto_prod_id = pr.prod_id
WHERE ven_eliminada = 0;