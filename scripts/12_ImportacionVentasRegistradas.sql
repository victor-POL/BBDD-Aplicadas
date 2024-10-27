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
CREATE OR REPLACE PROCEDURE negocio.importar_ventas_registradas(path_csv varchar)
LANGUAGE plpgsql
AS $$
DECLARE
    i RECORD;
BEGIN
    DROP TABLE IF EXISTS temp_ventas;
    CREATE TEMP TABLE temp_ventas(
        id_factura varchar(20 ),
        tipo_factura char(1 ),
        ciudad varchar(25 ),
        tipo_cliente varchar(15 ),
        genero varchar(8 ),
        producto varchar(100 ),
        precio_unitario varchar(15 ),
        cantidad varchar(4 ),
        fecha varchar(10 ),
        hora varchar(5 ),
        medio_pago varchar(25 ),
        empleado varchar(10 ),
        identificador_pago varchar(30 )
    );
    EXECUTE format('COPY temp_ventas (id_factura, tipo_factura, ciudad, tipo_cliente, genero, producto, precio_unitario, cantidad, fecha, hora, medio_pago, empleado, identificador_pago) 
FROM %L DELIMITER '';'' CSV HEADER;', path_csv);
    FOR i IN (
        SELECT
            id_factura,
            tipo_factura,
            ciudad,
            tipo_cliente,
            genero,
            producto,
            precio_unitario,
            cantidad,
            fecha,
            hora,
            medio_pago,
            empleado,
            identificador_pago
        FROM
            temp_ventas)
        LOOP
            INSERT INTO negocio.venta(cod_factura, tipo_factura, ciudad_sucursal, tipo_cliente, genero_cliente, nombre_producto, precio_unitario, cantidad, fecha_venta, medio_pago_nombre, identificador_pago, id_empleado, legajo_empleado)
                VALUES (
                    -- factura
                    i.id_factura, i.tipo_factura,
                    -- sucursal
                    CASE i.ciudad
                    WHEN 'Yangon' THEN
                        'San Justo'
                    WHEN 'Naypyitaw' THEN
                        'Ramos Mejia'
                    WHEN 'Mandalay' THEN
                        'Lomas del Mirador'
                    ELSE
                        i.ciudad
                    END,
                    -- cliente
                    i.tipo_cliente, CASE i.genero
                    WHEN 'Female' THEN
                        'F'
                    WHEN 'Male' THEN
                        'M'
                    ELSE
                        'O'
                    END,
                    -- producto
                    i.producto, CAST(i.precio_unitario AS DECIMAL(10, 2)), CAST(i.cantidad AS smallint),
                    -- venta
                    CAST(TO_DATE(i.fecha, 'MM/DD/YYYY') AS timestamp) + CAST(i.hora AS time),
                    -- medio pago
                    i.medio_pago, CASE i.identificador_pago
                    WHEN '--' THEN
                        NULL
                    ELSE
                        i.identificador_pago
                    END,
                    -- empleado
(
                        SELECT
                            id_empleado
                        FROM negocio.empleado
                        WHERE
                            empleado.legajo = i.empleado), i.empleado);
        END LOOP;
END
$$;

