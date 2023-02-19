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