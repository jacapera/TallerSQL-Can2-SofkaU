CREATE SCHEMA IF NOT EXISTS tienda DEFAULT CHARACTER SET utf8;
USE tienda;
-- -----------------------------------------------------
-- Tabla cliente
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS cliente (
  cli_id INT NOT NULL AUTO_INCREMENT,
  cli_nombre VARCHAR(45) NOT NULL,
  cli_documento VARCHAR(12) NOT NULL,
  cli_tipo_documento VARCHAR(4) NOT NULL,
  PRIMARY KEY (cli_id),
  UNIQUE INDEX cli_documento_UNIQUE
    ( cli_documento ASC, cli_tipo_documento ASC ) VISIBLE
) ENGINE = InnoDB;
-- -----------------------------------------------------
-- Tabla producto
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS producto (
  prod_id INT NOT NULL AUTO_INCREMENT,
  prod_descripcion VARCHAR(45) NOT NULL,
  prod_precio_compra DECIMAL(10,2),
  prod_precio_venta DECIMAL(10,2),
  proveedor_id INT NULL,
  PRIMARY KEY ( prod_id ),
) ENGINE = InnoDB;
-- -----------------------------------------------------
-- Tabla proveedor
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS proveedor (
  prov_id INT NOT NULL AUTO_INCREMENT,
  prov_nombre VARCHAR(45) NOT NULL,
  prov_email VARCHAR(45) NOT NULL,
  PRIMARY KEY ( prov_id )
) ENGINE = InnoDB;
-- -----------------------------------------------------
-- Tabla telefono
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS telefono (
  tel_id INT NOT NULL AUTO_INCREMENT,
  tel_numero VARCHAR(15) NOT NULL,
  proveedor_prov_id INT NOT NULL,
  PRIMARY KEY ( tel_id ),
  INDEX fk_telefono_proveedor1_idx ( proveedor_prov_id ASC ) VISIBLE,
  CONSTRAINT fk_telefono_proveedor1
    FOREIGN KEY ( proveedor_prov_id )
    REFERENCES proveedor ( prov_id )
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB;
-- -----------------------------------------------------
-- Tabla compra
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS compra (
  comp_id INT NOT NULL AUTO_INCREMENT,
  proveedor_prov_id INT NOT NULL,
  comp_fecha DATE NOT NULL,
  comp_valor_total DECIMAL(10,2) NOT NULL,
  PRIMARY KEY ( comp_id ),
  INDEX fk_compra_proveedor1_idx ( proveedor_prov_id ASC ) VISIBLE,
  CONSTRAINT fk_compra_proveedor1
    FOREIGN KEY ( proveedor_prov_id )
    REFERENCES proveedor ( prov_id )
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table detalle_compra
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS detalle_compra (
  iddetalle_compra INT NOT NULL AUTO_INCREMENT,
  compra_comp_id INT NOT NULL,
  producto_prod_id INT NOT NULL,
  detcomp_cantidad_producto INT NOT NULL,
  PRIMARY KEY (iddetalle_compra),
  INDEX fk_detalle_compra_compra1_idx
    (compra_comp_id ASC) VISIBLE,
  INDEX fk_detalle_compra_producto1_idx
    (producto_prod_id ASC) VISIBLE,
  CONSTRAINT fk_detalle_compra_compra1
    FOREIGN KEY (compra_comp_id)
    REFERENCES compra (comp_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_detalle_compra_producto1
    FOREIGN KEY (producto_prod_id)
    REFERENCES producto (prod_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB;
-- -----------------------------------------------------
-- Tabla venta
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS venta (
  ven_id INT NOT NULL AUTO_INCREMENT,
  ven_fecha DATE NOT NULL,
  ven_valor_total DECIMAL(10,2) NOT NULL,
  cliente_cli_id INT NOT NULL,
  PRIMARY KEY( ven_id ),
  INDEX fk_venta_cliente_idx ( cliente_cli_id ASC ) VISIBLE,
  CONSTRAINT fk_venta_cliente
    FOREIGN KEY ( cliente_cli_id )
    REFERENCES cliente ( cli_id )
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table detalle_venta
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS detalle_venta (
  iddetalle_venta INT NOT NULL AUTO_INCREMENT,
  detven_cantidad_producto INT NOT NULL,
  venta_ven_id INT NOT NULL,
  producto_prod_id INT NOT NULL,
  PRIMARY KEY (iddetalle_venta),
  INDEX fk_detalle_venta_venta1_idx (venta_ven_id ASC) VISIBLE,
  INDEX fk_detalle_venta_producto1_idx (producto_prod_id ASC) VISIBLE,
  CONSTRAINT fk_detalle_venta_venta1
    FOREIGN KEY (venta_ven_id)
    REFERENCES venta (ven_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_detalle_venta_producto1
    FOREIGN KEY (producto_prod_id)
    REFERENCES producto (prod_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB;

--=======================================================================
--                      INSERT
--=======================================================================
-- -----------------------------------------------------
-- Tabla cliente
-- -----------------------------------------------------
INSERT INTO cliente
  ( cli_nombre, cli_tipo_documento, cli_documento )
  VALUES ( 'Sandra Cardenas', 'CC', '3417453' ),
    ( 'Andres Rodriguez', 'CC', '541289' ),
    ( 'Yulieth Morales', 'TI', '10093453231');
-- -----------------------------------------------------
-- Tabla producto
-- -----------------------------------------------------
INSERT INTO producto
  (prod_descripcion, prod_precio_compra, prod_precio_venta, proveedor_id)
  VALUES('Tomate', 2000, 3000, 3), ('Cebolla', 2500, 3500, 3), ('Lechuga', 2000, 2800, 3),
    ('Aceite', 1800, 3500, 1), ('Azucar', 2200, 3400, 1), ('fideos', 1700, 2500, 1),
    ('Leche', 2200, 3800, 2), ('Huevos', 11200, 19000, 2), ('Jamon', 5500, 9200, 2);
-- -----------------------------------------------------
-- Tabla proveedor
-- -----------------------------------------------------
-- al ingresar un proveedor ingreso sus numeros de telefono en una sola instruccion
BEGIN;
  INSERT INTO proveedor (prov_nombre, prov_email)
    VALUES ('Distribuidora La Nieve', 'dis.lanieve@gmail.com');
  INSERT INTO telefono (tel_numero, proveedor_prov_id)
    VALUES ('3114789654', LAST_INSERT_ID()),
      ('0684567412', LAST_INSERT_ID());
COMMIT;

BEGIN;
  INSERT INTO proveedor (prov_nombre, prov_email)
    VALUES ('Distribuidora Rodrimar', 'rodrimar@gmail.com');
  INSERT INTO telefono (tel_numero, proveedor_prov_id)
    VALUES ('32287496321', LAST_INSERT_ID()),
      ('0686358684', LAST_INSERT_ID());
COMMIT;

BEGIN;
  INSERT INTO proveedor (prov_nombre, prov_email)
    VALUES ('El Rosalito', 'rosalito@gmail.com');
  INSERT INTO telefono (tel_numero, proveedor_prov_id)
    VALUES ('3204781247', LAST_INSERT_ID()),
      ('0686348512', LAST_INSERT_ID());
COMMIT;
-- -----------------------------------------------------
-- insertar compra
-- -----------------------------------------------------
START TRANSACTION;
  -- Insertar un registro en la tabla compra
  INSERT INTO compra
    (proveedor_prov_id, comp_fecha,comp_valor_total )
    VALUES (1, '2023-02-19', 0);
  -- Obtener el ID de la compra recién creada
  SET @compra_id = LAST_INSERT_ID();
  -- Para cada producto que se haya comprado, insertar un registro en la tabla detalle_compra
  INSERT INTO detalle_compra
    (compra_comp_id, producto_prod_id, detcomp_cantidad_producto)
    VALUES(@compra_id, 1, 100);
  INSERT INTO detalle_compra
    (compra_comp_id, producto_prod_id, detcomp_cantidad_producto)
    VALUES(@compra_id, 2, 120);
  INSERT INTO detalle_compra
    (compra_comp_id, producto_prod_id, detcomp_cantidad_producto)
    VALUES(@compra_id, 3, 50);
  -- Calcular el valor total de la compra
  SELECT
    SUM(detcomp_cantidad_producto * prod_precio_compra)
    INTO @valor_total
  FROM detalle_compra
    INNER JOIN producto ON detalle_compra.producto_prod_id = producto.prod_id
  WHERE compra_comp_id = @compra_id;
  -- Actualizar el registro en la tabla compra con el valor total de la compra
  UPDATE compra
  SET comp_valor_total = @valor_total
  WHERE comp_id = @compra_id;
  -- Confirmar la transacción
COMMIT;

START TRANSACTION;
  -- Insertar un registro en la tabla compra
  INSERT INTO compra
    (proveedor_prov_id, comp_fecha,comp_valor_total )
    VALUES(2, '2023-02-05', 0);
  -- Obtener el ID de la compra recién creada
  SET @compra_id = LAST_INSERT_ID();
  -- Para cada producto que se haya comprado, insertar un registro en la tabla detalle_compra
  INSERT INTO detalle_compra
    (compra_comp_id, producto_prod_id, detcomp_cantidad_producto)
    VALUES (@compra_id, 4, 25);
  INSERT INTO detalle_compra
    (compra_comp_id, producto_prod_id, detcomp_cantidad_producto)
    VALUES (@compra_id, 5, 60);
  INSERT INTO detalle_compra
    (compra_comp_id, producto_prod_id, detcomp_cantidad_producto)
    VALUES (@compra_id, 6, 75);
  -- Calcular el valor total de la compra
  SELECT
    SUM(detcomp_cantidad_producto * prod_precio_compra)
    INTO @valor_total
  FROM detalle_compra
    INNER JOIN producto ON detalle_compra.producto_prod_id = producto.prod_id
  WHERE compra_comp_id = @compra_id;
  -- Actualizar el registro en la tabla compra con el valor total de la compra
  UPDATE compra
  SET comp_valor_total = @valor_total
  WHERE comp_id = @compra_id;
  -- Confirmar la transacción
COMMIT;

START TRANSACTION;
  -- Insertar un registro en la tabla compra
  INSERT INTO compra
    (proveedor_prov_id, comp_fecha,comp_valor_total )
    VALUES(3, '2023-02-15', 0);
  -- Obtener el ID de la compra recién creada
  SET @compra_id = LAST_INSERT_ID();
  -- Para cada producto que se haya comprado, insertar un registro en la tabla detalle_compra
  INSERT INTO detalle_compra
    (compra_comp_id, producto_prod_id, detcomp_cantidad_producto)
    VALUES (@compra_id, 7, 40);
  INSERT INTO detalle_compra
    (compra_comp_id, producto_prod_id, detcomp_cantidad_producto)
    VALUES (@compra_id, 8, 250);
  INSERT INTO detalle_compra
    (compra_comp_id, producto_prod_id, detcomp_cantidad_producto)
    VALUES (@compra_id, 9, 30);
  -- Calcular el valor total de la compra
  SELECT
    SUM(detcomp_cantidad_producto * prod_precio_compra)
    INTO @valor_total
  FROM detalle_compra
    INNER JOIN producto ON detalle_compra.producto_prod_id = producto.prod_id
  WHERE compra_comp_id = @compra_id;
  -- Actualizar el registro en la tabla compra con el valor total de la compra
  UPDATE compra
  SET comp_valor_total = @valor_total
  WHERE comp_id = @compra_id;
  -- Confirmar la transacción
COMMIT;
-- -----------------------------------------------------
-- insertar venta
-- -----------------------------------------------------
START TRANSACTION;
  -- Insertar un registro en la tabla venta
  INSERT INTO venta
    (cliente_cli_id, ven_fecha,ven_valor_total )
    VALUES (1, '2023-01-15', 0);
  -- Obtener el ID de la venta recién creada
  SET @venta_id = LAST_INSERT_ID();
  -- Para cada producto que se haya vendido, insertar un registro en la tabla detalle_venta
  INSERT INTO detalle_venta
    (venta_ven_id, producto_prod_id, detven_cantidad_producto)
    VALUES (@venta_id, 1, 4);
  INSERT INTO detalle_venta
    (venta_ven_id, producto_prod_id, detven_cantidad_producto)
    VALUES (@venta_id, 2, 2);
  INSERT INTO detalle_venta
    (venta_ven_id, producto_prod_id, detven_cantidad_producto)
    VALUES (@venta_id, 3, 1);
  INSERT INTO detalle_venta
    (venta_ven_id, producto_prod_id, detven_cantidad_producto)
    VALUES (@venta_id, 4, 2);
  INSERT INTO detalle_venta
    (venta_ven_id, producto_prod_id, detven_cantidad_producto)
    VALUES (@venta_id, 9, 1);
  -- Calcular el valor total de la venta
  SELECT
    SUM(detven_cantidad_producto * prod_precio_venta) INTO @valor_total
  FROM detalle_venta
    INNER JOIN producto ON detalle_venta.producto_prod_id = producto.prod_id
  WHERE venta_ven_id = @venta_id;
  -- Actualizar el registro en la tabla venta con el valor total de la venta
  UPDATE venta
  SET ven_valor_total = @valor_total
  WHERE ven_id = @venta_id;
  -- Confirmar la transacción
COMMIT;

START TRANSACTION;
  -- Insertar un registro en la tabla venta
  INSERT INTO venta
    (cliente_cli_id, ven_fecha,ven_valor_total )
    VALUES (2, '2023-01-30', 0);
  -- Obtener el ID de la venta recién creada
  SET @venta_id = LAST_INSERT_ID();
  -- Para cada producto que se haya vendido, insertar un registro en la tabla detalle_venta
  INSERT INTO detalle_venta
    (venta_ven_id, producto_prod_id, detven_cantidad_producto)
    VALUES (@venta_id, 1, 6);
  INSERT INTO detalle_venta
    (venta_ven_id, producto_prod_id, detven_cantidad_producto)
    VALUES (@venta_id, 2, 1);
  INSERT INTO detalle_venta
    (venta_ven_id, producto_prod_id, detven_cantidad_producto)
    VALUES (@venta_id, 3, 3);
  INSERT INTO detalle_venta
    (venta_ven_id, producto_prod_id, detven_cantidad_producto)
    VALUES (@venta_id, 4, 2);
  INSERT INTO detalle_venta
    (venta_ven_id, producto_prod_id, detven_cantidad_producto)
    VALUES (@venta_id, 5, 2);
  INSERT INTO detalle_venta
    (venta_ven_id, producto_prod_id, detven_cantidad_producto)
    VALUES (@venta_id, 6, 2);
  INSERT INTO detalle_venta
    (venta_ven_id, producto_prod_id, detven_cantidad_producto)
    VALUES (@venta_id, 9, 1);
  -- Calcular el valor total de la venta
  SELECT
    SUM(detven_cantidad_producto * prod_precio_venta) INTO @valor_total
  FROM detalle_venta
    INNER JOIN producto ON detalle_venta.producto_prod_id = producto.prod_id
  WHERE venta_ven_id = @venta_id;
  -- Actualizar el registro en la tabla venta con el valor total de la venta
  UPDATE venta
  SET ven_valor_total = @valor_total
  WHERE ven_id = @venta_id;
  -- Confirmar la transacción
COMMIT;

START TRANSACTION;
  -- Insertar un registro en la tabla venta
  INSERT INTO venta
    (cliente_cli_id, ven_fecha,ven_valor_total )
    VALUES (3, '2023-02-15', 0);
  -- Obtener el ID de la venta recién creada
  SET @venta_id = LAST_INSERT_ID();
  -- Para cada producto que se haya vendido, insertar un registro en la tabla detalle_venta
  INSERT INTO detalle_venta
    (venta_ven_id, producto_prod_id, detven_cantidad_producto)
    VALUES (@venta_id, 1, 20);
  INSERT INTO detalle_venta
    (venta_ven_id, producto_prod_id, detven_cantidad_producto)
    VALUES (@venta_id, 2, 10);
  INSERT INTO detalle_venta
    (venta_ven_id, producto_prod_id, detven_cantidad_producto)
    VALUES (@venta_id, 3, 9);
  INSERT INTO detalle_venta
    (venta_ven_id, producto_prod_id, detven_cantidad_producto)
    VALUES (@venta_id, 4, 2);
  INSERT INTO detalle_venta
    (venta_ven_id, producto_prod_id, detven_cantidad_producto)
    VALUES (@venta_id, 5, 5);
  INSERT INTO detalle_venta
    (venta_ven_id, producto_prod_id, detven_cantidad_producto)
    VALUES (@venta_id, 7, 5);
  INSERT INTO detalle_venta
    (venta_ven_id, producto_prod_id, detven_cantidad_producto)
    VALUES (@venta_id, 8, 5);
  -- Calcular el valor total de la venta
  SELECT
    SUM(detven_cantidad_producto * prod_precio_venta) INTO @valor_total
  FROM detalle_venta
    INNER JOIN producto ON detalle_venta.producto_prod_id = producto.prod_id
  WHERE venta_ven_id = @venta_id;
  -- Actualizar el registro en la tabla venta con el valor total de la venta
  UPDATE venta
  SET ven_valor_total = @valor_total
  WHERE ven_id = @venta_id;
  -- Confirmar la transacción
COMMIT;

START TRANSACTION;
  -- Insertar un registro en la tabla venta
  INSERT INTO venta
    (cliente_cli_id, ven_fecha,ven_valor_total )
    VALUES (1, '2023-02-19', 0);
  -- Obtener el ID de la venta recién creada
  SET @venta_id = LAST_INSERT_ID();
  -- Para cada producto que se haya vendido, insertar un registro en la tabla detalle_venta
  INSERT INTO detalle_venta
    (venta_ven_id, producto_prod_id, detven_cantidad_producto)
    VALUES (@venta_id, 1, 10);
  INSERT INTO detalle_venta
    (venta_ven_id, producto_prod_id, detven_cantidad_producto)
    VALUES (@venta_id, 2, 5);
  INSERT INTO detalle_venta
    (venta_ven_id, producto_prod_id, detven_cantidad_producto)
    VALUES (@venta_id, 3, 2);
  INSERT INTO detalle_venta
    (venta_ven_id, producto_prod_id, detven_cantidad_producto)
    VALUES (@venta_id, 4, 8);
  -- Calcular el valor total de la venta
  SELECT
    SUM(detven_cantidad_producto * prod_precio_venta) INTO @valor_total
  FROM detalle_venta
    INNER JOIN producto ON detalle_venta.producto_prod_id = producto.prod_id
  WHERE venta_ven_id = @venta_id;
  -- Actualizar el registro en la tabla venta con el valor total de la venta
  UPDATE venta
  SET ven_valor_total = @valor_total
  WHERE ven_id = @venta_id;
  -- Confirmar la transacción
COMMIT;

