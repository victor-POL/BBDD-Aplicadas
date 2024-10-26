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
-- FUNCION AUXILIAR PARA OBTENER EL ID DE UNA SUCURSAL
CREATE OR REPLACE FUNCTION negocio.get_id_sucursal(nombre_sucursal VARCHAR) 
RETURNS SMALLINT AS $$
DECLARE
    id_sucursal_res SMALLINT;
BEGIN
    SELECT
        id_sucursal
    INTO
        id_sucursal_res
    FROM
        negocio.sucursal
    WHERE
        nombre = nombre_sucursal
    LIMIT
        1;

    RETURN id_sucursal_res;  -- Retorna NULL si no se encuentra
END;
$$ LANGUAGE plpgsql;

-- CARGA DE CIUDADES
INSERT INTO
    negocio.ciudad (nombre, codigo_postal, provincia)
VALUES
    ('San Justo', 'B1754', 'Provincia de Buenos Aires'),
    (
        'Ramos Mejía',
        'B1704',
        'Provincia de Buenos Aires'
    ),
    (
        'Villa Luzuriaga',
        'B1753AWO',
        'Provincia de Buenos Aires'
    );

-- CARGA DE SUCURSALES
INSERT INTO
    negocio.sucursal (nombre, id_ciudad, direccion, telefono)
VALUES
    (
        'Sucursal 1',
        (
            SELECT
                id_ciudad
            FROM
                negocio.ciudad
            WHERE
                nombre = 'San Justo'
            LIMIT
                1
        ),
        'Av. Brig. Gral. Juan Manuel de Rosas 3634',
        '5555-5551'
    ),
    (
        'Sucursal 2',
        (
            SELECT
                id_ciudad
            FROM
                negocio.ciudad
            WHERE
                nombre = 'Ramos Mejía'
            LIMIT
                1
        ),
        'Av. de Mayo 791',
        '5555-5552'
    ),
    (
        'Sucursal 3',
        (
            SELECT
                id_ciudad
            FROM
                negocio.ciudad
            WHERE
                nombre = 'Villa Luzuriaga'
            LIMIT
                1
        ),
        'Pres. Juan Domingo Perón 763',
        '5555-5553'
    );

-- CARGA HORARIO SUCURSAL
INSERT INTO
    negocio.sucursal_horario (id_sucursal, dia_semana, hora_apertura, hora_cierre)
VALUES 
(negocio.get_id_sucursal('Sucursal 1'), '1', '08:00', '21:00'),
(negocio.get_id_sucursal('Sucursal 1'), '2', '08:00', '21:00'),
(negocio.get_id_sucursal('Sucursal 1'), '3', '08:00', '21:00'),
(negocio.get_id_sucursal('Sucursal 1'), '4', '08:00', '21:00'),
(negocio.get_id_sucursal('Sucursal 1'), '5', '08:00', '21:00'),
(negocio.get_id_sucursal('Sucursal 1'), '6', '09:00', '20:00'),
(negocio.get_id_sucursal('Sucursal 1'), '7', '09:00', '20:00'),
(negocio.get_id_sucursal('Sucursal 2'), '1', '08:00', '21:00'),
(negocio.get_id_sucursal('Sucursal 2'), '2', '08:00', '21:00'),
(negocio.get_id_sucursal('Sucursal 2'), '3', '08:00', '21:00'),
(negocio.get_id_sucursal('Sucursal 2'), '4', '08:00', '21:00'),
(negocio.get_id_sucursal('Sucursal 2'), '5', '08:00', '21:00'),
(negocio.get_id_sucursal('Sucursal 2'), '6', '09:00', '20:00'),
(negocio.get_id_sucursal('Sucursal 2'), '7', '09:00', '20:00'),
(negocio.get_id_sucursal('Sucursal 3'), '1', '08:00', '21:00'),
(negocio.get_id_sucursal('Sucursal 3'), '2', '08:00', '21:00'),
(negocio.get_id_sucursal('Sucursal 3'), '3', '08:00', '21:00'),
(negocio.get_id_sucursal('Sucursal 3'), '4', '08:00', '21:00'),
(negocio.get_id_sucursal('Sucursal 3'), '5', '08:00', '21:00'),
(negocio.get_id_sucursal('Sucursal 3'), '6', '09:00', '20:00'),
(negocio.get_id_sucursal('Sucursal 3'), '7', '09:00', '20:00');