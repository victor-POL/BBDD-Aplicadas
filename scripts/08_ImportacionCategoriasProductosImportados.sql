---------------------------------------------------------------------------------------------------------------------
-- DESCRIPCION: CARGAR CATEGORIAS DE PRODUCTOS IMPROTADOS DESDE ARCHIVO CSV PRODUCTOS_IMPORTADOS
-- TODO: FECHA ENTREGA:
-- COMISION: 01-2900
-- GRUPO: 11
-- MATERIA: BASES DE DATOS APLICADAS
-- INTEGRANTE_1: POVOLI OLIVERA, VICTOR 43103780
-- INTEGRANTE_2: CARBALLO, FACUNDO NICOLAS TODO: DNI
-- INTEGRANTE_3: TODO: DATOS
-- INTEGRANTE_4: TODO: DATOS
---------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE negocio.importar_categorias_productos_importados(path_csv VARCHAR) LANGUAGE plpgsql AS $$
DECLARE i RECORD;
BEGIN 

DROP TABLE IF EXISTS temp_categoria_producto_importado;
CREATE TEMP TABLE temp_categoria_producto_importado (
    id_producto VARCHAR(15),
    nombre_producto VARCHAR(50),
	proveedor VARCHAR(100),
	categoria VARCHAR(100),
	cantidad_por_unidad VARCHAR(50),
	precio_unidad VARCHAR(15)
);

EXECUTE format('COPY temp_categoria_producto_importado (id_producto, nombre_producto, proveedor, categoria, cantidad_por_unidad, precio_unidad)
FROM %L DELIMITER '';'' CSV HEADER;', path_csv);


FOR i IN
SELECT DISTINCT categoria
FROM temp_categoria_producto_importado LOOP 
IF (SELECT 1 FROM negocio.categoria_producto WHERE categoria_producto.nombre = i.categoria AND categoria_producto.id_clasificacion IS NOT NULL) = 1 
THEN RAISE NOTICE 'La categoria ya existe %',
    i.categoria;
ELSIF (SELECT 1 FROM negocio.categoria_producto WHERE categoria_producto.nombre = i.categoria AND categoria_producto.id_clasificacion IS NULL) = 1 
THEN
    UPDATE negocio.categoria_producto
    SET id_clasificacion = (SELECT id_clasificacion FROM negocio.clasfificacion_categoria_producto WHERE clasfificacion_categoria_producto.nombre = 'Importados')
    WHERE categoria_producto.nombre = i.categoria AND categoria_producto.id_clasificacion IS NULL;
ELSE
INSERT INTO negocio.categoria_producto (nombre, id_clasificacion)
VALUES (i.categoria, (SELECT id_clasificacion FROM negocio.clasfificacion_categoria_producto WHERE clasfificacion_categoria_producto.nombre = 'Importados'));
END IF;
END LOOP;

END $$;

/* -------------------------------------------------------------------------- */
/*                                 IMPORTACION                                */
/* -------------------------------------------------------------------------- */
CALL negocio.importar_categorias_productos_importados(
    'C:\Users\pc-vic\Desktop\BBDD-Aplicadas\data\datos_basicos\Productos_importados.csv'
);