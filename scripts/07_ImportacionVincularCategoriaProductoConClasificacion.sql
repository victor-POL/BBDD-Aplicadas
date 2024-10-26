---------------------------------------------------------------------------------------------------------------------
-- DESCRIPCION: CARGAR CATEGORIAS DE PRODUCTOS DESDE ARCHIVO CSV INFORMACION COMPLEMENTARIA HOJA CLASIFICACION PRODUCTOS
-- TODO: FECHA ENTREGA:
-- COMISION: 01-2900
-- GRUPO: 11
-- MATERIA: BASES DE DATOS APLICADAS
-- INTEGRANTE_1: POVOLI OLIVERA, VICTOR 43103780
-- INTEGRANTE_2: CARBALLO, FACUNDO NICOLAS TODO: DNI
-- INTEGRANTE_3: TODO: DATOS
-- INTEGRANTE_4: TODO: DATOS
---------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE negocio.importar_clasificacion_categoria_productos(path_csv VARCHAR) LANGUAGE plpgsql AS $$
DECLARE i RECORD;
BEGIN

DROP TABLE IF EXISTS temp_clasificacion_categoria;

CREATE TEMP TABLE temp_clasificacion_categoria (
    nombre_clasificacion VARCHAR(70),
    nombre_categoria_producto VARCHAR(70)
);

EXECUTE format(
    'COPY temp_clasificacion_categoria (nombre_clasificacion, nombre_categoria_producto)
FROM %L DELIMITER '';'' CSV HEADER;',
    path_csv
);

FOR i IN
SELECT nombre_clasificacion, nombre_categoria_producto
FROM temp_clasificacion_categoria 
LOOP 

    IF (SELECT 1 FROM negocio.categoria_producto WHERE categoria_producto.nombre = i.nombre_categoria_producto AND categoria_producto IS NOT NULL) = 1 
    THEN 
        RAISE NOTICE 'La categoria de producto % ya posee asociada una clasificacion',
        i.nombre_categoria_producto;
    ELSE 
        IF (SELECT 1 FROM negocio.clasfificacion_categoria_producto WHERE clasfificacion_categoria_producto.nombre = i.nombre_clasificacion) = 1 
        THEN 
            UPDATE negocio.categoria_producto
            SET id_clasificacion = (SELECT id_clasificacion FROM negocio.clasfificacion_categoria_producto WHERE clasfificacion_categoria_producto.nombre = i.nombre_clasificacion)
            WHERE nombre = i.nombre_categoria_producto;
        ELSE
            RAISE NOTICE 'La clasificacion % no existe',
            i.nombre_clasificacion;
        END IF;
    END IF;

END LOOP;

END $$;


CALL negocio.importar_clasificacion_categoria_productos(
    'C:\Users\pc-vic\Desktop\BBDD-Aplicadas\data\datos_basicos\clasificacion_productos.csv'
)