---------------------------------------------------------------------------------------------------------------------
-- DESCRIPCION: CARGAR CATEGORIAS DE PRODUCTOS DESDE ARCHIVO CSV CATALOGO
-- TODO: FECHA ENTREGA:
-- COMISION: 01-2900
-- GRUPO: 11
-- MATERIA: BASES DE DATOS APLICADAS
-- INTEGRANTE_1: POVOLI OLIVERA, VICTOR 43103780
-- INTEGRANTE_2: CARBALLO, FACUNDO NICOLAS TODO: DNI
-- INTEGRANTE_3: TODO: DATOS
-- INTEGRANTE_4: TODO: DATOS
---------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE negocio.importar_categorias_productos(path_csv VARCHAR) LANGUAGE plpgsql AS $$
DECLARE i RECORD;
BEGIN 

DROP TABLE IF EXISTS temp_categoria_product;
CREATE TEMP TABLE temp_categoria_product (
    id VARCHAR(10),
    category VARCHAR(50),
	name_product VARCHAR(100),
	price VARCHAR(10),
	reference_price VARCHAR(10),
	reference_unit VARCHAR(10),
	date_product VARCHAR(25)
);

EXECUTE format('COPY temp_categoria_product (id, category, name_product, price, reference_price, reference_unit, date_product)
FROM %L DELIMITER '','' CSV HEADER;', path_csv);


FOR i IN
SELECT DISTINCT category
FROM temp_categoria_product LOOP 
IF (SELECT 1 FROM negocio.categoria_producto WHERE categoria_producto.nombre = i.category) = 1 
THEN RAISE NOTICE 'La categoria ya existe %',
    i.category;
ELSE
INSERT INTO negocio.categoria_producto (nombre)
VALUES (i.category);
END IF;
END LOOP;

END $$;


CALL negocio.importar_categorias_productos(
    'C:\Users\pc-vic\Desktop\BBDD-Aplicadas\data\datos_basicos\catalogo.csv'
);