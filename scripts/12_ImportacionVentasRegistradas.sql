---------------------------------------------------------------------------------------------------------------------
-- DESCRIPCION: CARGAR VENTAS REGISTRADAS DEL SISTEMA ANTIGUO
-- COMISION: 01-2900
-- GRUPO: 11
-- MATERIA: BASES DE DATOS APLICADAS
-- INTEGRANTE_1: POVOLI OLIVERA, VICTOR 43103780
-- INTEGRANTE_2: CARBALLO, FACUNDO NICOLAS TODO: DNI
-- INTEGRANTE_3: TODO: DATOS
-- INTEGRANTE_4: TODO: DATOS
---------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE negocio.importar_ventas_registradas(path_csv VARCHAR) LANGUAGE plpgsql AS $$
DECLARE i RECORD;
BEGIN 

DROP TABLE IF EXISTS temp_ventas;
CREATE TEMP TABLE temp_ventas (
    id_factura VARCHAR(20),
    tipo_factura CHAR(1),
    ciudad VARCHAR(25),
    tipo_cliente VARCHAR(15),
    genero VARCHAR(8),
    producto VARCHAR(100),
    precio_unitario VARCHAR(15),
    cantidad VARCHAR(4),
    fecha VARCHAR(10),
    hora VARCHAR(5),
    medio_pago VARCHAR(25),
    empleado VARCHAR(10),
    identificador_pago VARCHAR(30)
);

EXECUTE format('COPY temp_ventas (id_factura, tipo_factura, ciudad, tipo_cliente, genero, producto, precio_unitario, cantidad, fecha, hora, medio_pago, empleado, identificador_pago) 
FROM %L DELIMITER '';'' CSV HEADER;', path_csv);


FOR i IN
(SELECT id_factura, tipo_factura, ciudad, tipo_cliente, genero, producto, precio_unitario, cantidad, fecha, hora, medio_pago, empleado, identificador_pago
FROM temp_ventas) LOOP 

    INSERT INTO negocio.venta (cod_factura, tipo_factura, ciudad_sucursal, tipo_cliente, genero_cliente, nombre_producto, precio_unitario, cantidad, fecha_venta, medio_pago_nombre, identificador_pago, id_empleado, legajo_empleado)
    VALUES (
        -- factura
        i.id_factura, 
        i.tipo_factura, 
        -- sucursal
        CASE i.ciudad
            WHEN 'Yangon' THEN 'San Justo'
            WHEN 'Naypyitaw' THEN 'Ramos Mejia'
            WHEN 'Mandalay' THEN 'Lomas del Mirador'
            ELSE i.ciudad
        END, 
        -- cliente
        i.tipo_cliente, 
        CASE i.genero
            WHEN 'Female' THEN 'F'
            WHEN 'Male' THEN 'M'
            ELSE 'O'
        END, 
        -- producto
        i.producto, 
        CAST(i.precio_unitario AS DECIMAL(10, 2)), 
        CAST(i.cantidad AS SMALLINT), 
        -- venta
        CAST(TO_DATE(i.fecha, 'MM/DD/YYYY') AS TIMESTAMP) + CAST(i.hora AS TIME), 
        -- medio pago
        i.medio_pago, 
        CASE i.identificador_pago
            WHEN '--' THEN NULL
            ELSE i.identificador_pago
        END,
        -- empleado
        (SELECT id_empleado FROM negocio.empleado WHERE empleado.legajo = i.empleado),
        i.empleado

    );

END LOOP;

END $$;