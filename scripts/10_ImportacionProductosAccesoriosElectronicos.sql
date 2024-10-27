---------------------------------------------------------------------------------------------------------------------
-- DESCRIPCION: CARGAR INFO PRODUCTOS ACCESORIOS ELECTRONICOS DESDE ARCHIVO CSV Electronic accessories
-- TODO: FECHA ENTREGA:
-- COMISION: 01-2900
-- GRUPO: 11
-- MATERIA: BASES DE DATOS APLICADAS
-- INTEGRANTE_1: POVOLI OLIVERA, VICTOR 43103780
-- INTEGRANTE_2: CARBALLO, FACUNDO NICOLAS TODO: DNI
-- INTEGRANTE_3: TODO: DATOS
-- INTEGRANTE_4: TODO: DATOS
---------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE negocio.importar_catalogo_productos_acc_electronicos(path_csv VARCHAR) LANGUAGE plpgsql AS $$
DECLARE i RECORD;
BEGIN 

DROP TABLE IF EXISTS temp_producto_electronico;
CREATE TEMP TABLE temp_producto_electronico (
    product VARCHAR(50),
    precio_unit_usd VARCHAR(10)
);

EXECUTE format('COPY temp_producto_electronico (product, precio_unit_usd)
FROM %L DELIMITER '';'' CSV HEADER;', path_csv);


FOR i IN
(SELECT DISTINCT product, precio_unit_usd
FROM temp_producto_electronico) LOOP 

INSERT INTO negocio.producto (nombre, id_categoria, descripcion, precio, ultimo_cambio)
VALUES (
    i.product,
    (SELECT categoria_producto.id_categoria FROM negocio.categoria_producto WHERE categoria_producto.nombre = 'Accesorios Electronicos'), 
    NULL, 
    CAST(REPLACE((REPLACE(REPLACE(i.precio_unit_usd, '$', ''), ' ', '')), ',', '.') AS DECIMAL(10, 2)), 
    NOW()
);

END LOOP;

END $$;