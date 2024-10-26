---------------------------------------------------------------------------------------------------------------------
-- DESCRIPCION: CARGAR DATOS BASICOS COMO PROVINCIAS, CIUDADES, CARGOS LABORALES, TURNOS, ETC
-- TODO: FECHA ENTREGA:
-- COMISION: 01-2900
-- GRUPO: 11
-- MATERIA: BASES DE DATOS APLICADAS
-- INTEGRANTE_1: POVOLI OLIVERA, VICTOR 43103780
-- INTEGRANTE_2: CARBALLO, FACUNDO NICOLAS TODO: DNI
-- INTEGRANTE_3: TODO: DATOS
-- INTEGRANTE_4: TODO: DATOS
---------------------------------------------------------------------------------------------------------------------
/* -------------------------------------------------------------------------- */
/*                              CARGA SUCURSALES                              */
/* -------------------------------------------------------------------------- */
INSERT INTO negocio.sucursal (
        calle,
        ciudad,
        codigo_postal,
        provincia,
        telefono
    )
VALUES (
        'Av. Brig. Gral. Juan Manuel de Rosas 3634',
        'San Justo',
        'B1754',
        'Provincia de Buenos Aires',
        '5555-5551'
    ),
    (
        'Av. de Mayo 791',
        'Ramos Mejía',
        'B1704',
        'Provincia de Buenos Aires',
        '5555-5552'
    ),
    (
        'Pres. Juan Domingo Perón 763',
        'Villa Luzuriaga',
        'B1753AWO',
        'Provincia de Buenos Aires',
        '5555-5553'
    );
-- CARGA HORARIO SUCURSAL
-- INSERT INTO negocio.sucursal_horario (
--         id_sucursal,
--         dia_semana,
--         hora_apertura,
--         hora_cierre
--     )
-- VALUES (
--         negocio.get_id_sucursal('Sucursal 1'),
--         '1',
--         '08:00',
--         '21:00'
--     ),
--     (
--         negocio.get_id_sucursal('Sucursal 1'),
--         '2',
--         '08:00',
--         '21:00'
--     ),
--     (
--         negocio.get_id_sucursal('Sucursal 1'),
--         '3',
--         '08:00',
--         '21:00'
--     ),
--     (
--         negocio.get_id_sucursal('Sucursal 1'),
--         '4',
--         '08:00',
--         '21:00'
--     ),
--     (
--         negocio.get_id_sucursal('Sucursal 1'),
--         '5',
--         '08:00',
--         '21:00'
--     ),
--     (
--         negocio.get_id_sucursal('Sucursal 1'),
--         '6',
--         '09:00',
--         '20:00'
--     ),
--     (
--         negocio.get_id_sucursal('Sucursal 1'),
--         '7',
--         '09:00',
--         '20:00'
--     ),
--     (
--         negocio.get_id_sucursal('Sucursal 2'),
--         '1',
--         '08:00',
--         '21:00'
--     ),
--     (
--         negocio.get_id_sucursal('Sucursal 2'),
--         '2',
--         '08:00',
--         '21:00'
--     ),
--     (
--         negocio.get_id_sucursal('Sucursal 2'),
--         '3',
--         '08:00',
--         '21:00'
--     ),
--     (
--         negocio.get_id_sucursal('Sucursal 2'),
--         '4',
--         '08:00',
--         '21:00'
--     ),
--     (
--         negocio.get_id_sucursal('Sucursal 2'),
--         '5',
--         '08:00',
--         '21:00'
--     ),
--     (
--         negocio.get_id_sucursal('Sucursal 2'),
--         '6',
--         '09:00',
--         '20:00'
--     ),
--     (
--         negocio.get_id_sucursal('Sucursal 2'),
--         '7',
--         '09:00',
--         '20:00'
--     ),
--     (
--         negocio.get_id_sucursal('Sucursal 3'),
--         '1',
--         '08:00',
--         '21:00'
--     ),
--     (
--         negocio.get_id_sucursal('Sucursal 3'),
--         '2',
--         '08:00',
--         '21:00'
--     ),
--     (
--         negocio.get_id_sucursal('Sucursal 3'),
--         '3',
--         '08:00',
--         '21:00'
--     ),
--     (
--         negocio.get_id_sucursal('Sucursal 3'),
--         '4',
--         '08:00',
--         '21:00'
--     ),
--     (
--         negocio.get_id_sucursal('Sucursal 3'),
--         '5',
--         '08:00',
--         '21:00'
--     ),
--     (
--         negocio.get_id_sucursal('Sucursal 3'),
--         '6',
--         '09:00',
--         '20:00'
--     ),
--     (
--         negocio.get_id_sucursal('Sucursal 3'),
--         '7',
--         '09:00',
--         '20:00'
--     );
/* -------------------------------------------------------------------------- */
/*                             CARGA DE EMPLEADOS                             */
/* -------------------------------------------------------------------------- */
-- CARGA DE CARGOS LABORALES
INSERT INTO negocio.cargo_laboral (nombre)
VALUES ('Cajero'),
    ('Supervisor'),
    ('Gerente de sucursal');
-- CARGA DE TURNOS LABORALES
INSERT INTO negocio.turno_laboral (nombre)
VALUES ('TM'),
    ('TT'),
    ('TN'),
    -- ('Jornada completa');
    /* -------------------------------------------------------------------------- */
    /*                            CARGA MEDIOS DE PAGO                            */
    /* -------------------------------------------------------------------------- */
INSERT INTO negocio.medio_pago (nombre, nombre_en)
VALUES ('Tarjeta de credito', 'Credit card'),
    ('Efectivo', 'Cash'),
    ('Billetera Electronica', 'Ewallet');
/* -------------------------------------------------------------------------- */
/*       CARGA CATEGORIAS DE CLASIFICACIONES DE CATEGORIAS DE PRODUCTOS       */
/* -------------------------------------------------------------------------- */
-- Para Productos_importados.csv
-- Para Electronic accessories.csv 
INSERT INTO negocio.clasfificacion_categoria_producto (nombre)
VALUES ('Importados'),
    ('Accesorios Electronicos');