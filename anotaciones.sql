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