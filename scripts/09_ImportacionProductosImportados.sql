---------------------------------------------------------------------------------------------------------------------
-- DESCRIPCION: CARGAR INFO PRODUCTOS IMPROTADOS DESDE ARCHIVO CSV PRODUCTOS_IMPORTADOS
-- TODO: FECHA ENTREGA:
-- COMISION: 01-2900
-- GRUPO: 11
-- MATERIA: BASES DE DATOS APLICADAS
-- INTEGRANTE_1: POVOLI OLIVERA, VICTOR 43103780
-- INTEGRANTE_2: CARBALLO, FACUNDO NICOLAS TODO: DNI
-- INTEGRANTE_3: TODO: DATOS
-- INTEGRANTE_4: TODO: DATOS
---------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE negocio.importar_catalogo_productos_importados(path_csv VARCHAR) LANGUAGE plpgsql AS $$
DECLARE i RECORD;
BEGIN 

DROP TABLE IF EXISTS temp_producto_importado;
CREATE TEMP TABLE temp_producto_importado (
    id_producto VARCHAR(15),
    nombre_producto VARCHAR(50),
	proveedor VARCHAR(100),
	categoria VARCHAR(100),
	cantidad_por_unidad VARCHAR(50),
	precio_unidad VARCHAR(15)
);

EXECUTE format('COPY temp_producto_importado (id_producto, nombre_producto, proveedor, categoria, cantidad_por_unidad, precio_unidad)
FROM %L DELIMITER '';'' CSV HEADER;', path_csv);


FOR i IN
(SELECT nombre_producto, categoria, cantidad_por_unidad, precio_unidad
FROM temp_producto_importado) LOOP 

INSERT INTO negocio.producto (nombre, id_categoria, descripcion, precio, ultimo_cambio)
VALUES (
    i.nombre_producto,
    (SELECT categoria_producto.id_categoria FROM negocio.categoria_producto WHERE categoria_producto.nombre = i.categoria), 
    i.cantidad_por_unidad, 
    CAST(REPLACE((REPLACE(REPLACE(i.precio_unidad, '$', ''), ' ', '')), ',', '.') AS DECIMAL(10, 2)), 
    NOW()
);

END LOOP;

END $$;

/* -------------------------------------------------------------------------- */
/*                                 IMPORTACION                                */
/* -------------------------------------------------------------------------- */
CALL negocio.importar_catalogo_productos_importados(
    'C:\Users\pc-vic\Desktop\BBDD-Aplicadas\data\datos_basicos\Productos_importados.csv'
);