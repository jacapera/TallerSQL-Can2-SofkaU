-- -----------------------------------------------------
-- Consulta 1
-- -----------------------------------------------------
SELECT
  v.ven_id AS Id_Venta,
  cl.cli_nombre AS Cliente,
  v.ven_fecha AS Fecha,
  dv.detven_cantidad_producto AS Cant,
  pr.prod_descripcion AS Producto,
  pr.prod_precio_venta AS Precio,
  dv.detven_cantidad_producto * pr.prod_precio_venta AS Subtotal,
  v.ven_valor_total AS Total_Venta,
  v.ven_eliminada
  FROM venta v
  JOIN cliente cl ON v.cliente_cli_id = cl.cli_id
  JOIN detalle_venta dv ON v.ven_id = dv.venta_ven_id
  JOIN producto pr ON dv.producto_prod_id = pr.prod_id
  WHERE v.ven_eliminada = 0 AND cl.cli_tipo_documento = 'CC' AND cl.cli_documento = '3417453';
-- -----------------------------------------------------
-- Consulta 2
-- -----------------------------------------------------
SELECT
  pr.prod_id AS Id,
  pr.prod_descripcion AS Descripcion,
  pr.prod_precio_compra AS Precio_Compra,
  pr.prod_precio_venta AS Precio_Venta,
  prd.prov_nombre AS Proveedor_Principal,
  c.comp_fecha AS Fecha_Compra,
  prd_c.prov_nombre AS Proveedor_Compra
  FROM
    producto pr
    LEFT JOIN proveedor prd ON pr.prod_proveedor_id = prd.prov_id
    LEFT JOIN detalle_compra dc ON dc.producto_prod_id = pr.prod_id
    LEFT JOIN compra c ON dc.compra_comp_id = c.comp_id
    LEFT JOIN proveedor prd_c ON c.proveedor_prov_id = prd_c.prov_id;
-- -----------------------------------------------------
-- Consulta 3 [PLUS]
-- -----------------------------------------------------
SELECT
  pr.prod_id,
  pr.prod_descripcion,
  SUM(dv.detven_cantidad_producto) AS Cantidad_Vendida
  FROM
    producto pr
    INNER JOIN detalle_venta dv ON dv.producto_prod_id = pr.prod_id
  GROUP BY pr.prod_id
  ORDER BY Cantidad_Vendida DESC;


