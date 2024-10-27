---------------------------------------------------------------------------------------------------------------------
-- DESCRIPCION: CARGAR LAS CLASIFICACIONES DE LAS CATEGORIAS DE PRODUCTOS DESDE EL ARCHIVO CSV DE IMFORMACION COMPLEMENTARIA HOJA Clasificacion productos
-- TODO: FECHA ENTREGA:
-- COMISION: 01-2900
-- GRUPO: 11
-- MATERIA: BASES DE DATOS APLICADAS
-- INTEGRANTE_1: POVOLI OLIVERA, VICTOR 43103780
-- INTEGRANTE_2: CARBALLO, FACUNDO NICOLAS TODO: DNI
-- INTEGRANTE_3: TODO: DATOS
-- INTEGRANTE_4: TODO: DATOS
---------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE negocio.importar_clasificacion_productos(path_csv varchar)
LANGUAGE plpgsql
AS $$
DECLARE
    i RECORD;
BEGIN
    DROP TABLE IF EXISTS temp_clasificacion_producto;
    CREATE TEMP TABLE temp_clasificacion_producto(
        linea_producto varchar(70 ),
        producto varchar(70 )
    );
    EXECUTE format('COPY temp_clasificacion_producto (linea_producto, producto)
FROM %L DELIMITER '';'' CSV HEADER;', path_csv);
    FOR i IN ( SELECT DISTINCT
            linea_producto
        FROM
            temp_clasificacion_producto)
        LOOP
            IF (
                SELECT
                    1
                FROM
                    negocio.clasfificacion_categoria_producto
                WHERE
                    clasfificacion_categoria_producto.nombre = i.linea_producto) = 1 THEN
                RAISE NOTICE 'La clasificacion ya existe %', i.linea_producto;
            ELSE
                INSERT INTO negocio.clasfificacion_categoria_producto(nombre)
                    VALUES (i.linea_producto);
            END IF;
        END LOOP;
END
$$;

