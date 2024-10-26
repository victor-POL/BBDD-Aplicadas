---------------------------------------------------------------------------------------------------------------------
-- DESCRIPCION: CARGAR PRODUCTOS DEL CATALOGO DESDE ARCHIVO CSV CATALOGO
-- COMISION: 01-2900
-- GRUPO: 11
-- MATERIA: BASES DE DATOS APLICADAS
-- INTEGRANTE_1: POVOLI OLIVERA, VICTOR 43103780
-- INTEGRANTE_2: CARBALLO, FACUNDO NICOLAS TODO: DNI
-- INTEGRANTE_3: TODO: DATOS
-- INTEGRANTE_4: TODO: DATOS
---------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE negocio.importar_catalogo_productos(path_csv VARCHAR) LANGUAGE plpgsql AS $$
DECLARE i RECORD;
BEGIN 

DROP TABLE IF EXISTS temp_productos;
CREATE TEMP TABLE temp_productos (
    id VARCHAR(10),
	category VARCHAR(50),
	name_product VARCHAR(100),
	price VARCHAR(10),
	reference_price VARCHAR(10),
	reference_unit VARCHAR(10),
	date_product VARCHAR(25)
);

EXECUTE format('COPY temp_productos (id, category, name_product, price, reference_price, reference_unit, date_product)
FROM %L DELIMITER '','' CSV HEADER;', path_csv);


FOR i IN
(SELECT id, category, name_product, price, reference_price, reference_unit, date_product
FROM temp_productos) LOOP 
-- TODO: Validar que la fecha del catalogo sea mayor al ultimo cambio para realmente insertarlo
-- TODO: Validar que el producto no exista en la base de datos para insertarlo O actualizarlo
-- TODO: Verificar que hacer con los productos que no se encontro la categoria

IF (SELECT 1 FROM negocio.categoria_producto WHERE categoria_producto.nombre = i.category) IS NULL THEN
    RAISE NOTICE 'No se encontro la categoria del producto con nombre %', i.name_product;
ELSE
INSERT INTO negocio.producto (codigo, nombre, id_categoria, descripcion, precio, ultimo_cambio)
VALUES (
    i.id,
    i.name_product,
    (SELECT categoria_producto.id_categoria FROM negocio.categoria_producto WHERE categoria_producto.nombre = i.category), 
    NULL, 
    CAST(REPLACE((REPLACE(REPLACE(i.reference_price, '$', ''), ' ', '')), ',', '.') AS DECIMAL(10, 2)), 
    NOW()
);
END IF;

END LOOP;

END $$;

/* -------------------------------------------------------------------------- */
/*                                 IMPORTACION                                */
/* -------------------------------------------------------------------------- */
CALL negocio.importar_catalogo_productos(
    'C:\Users\pc-vic\Desktop\BBDD-Aplicadas\data\datos_basicos\catalogo.csv'
);