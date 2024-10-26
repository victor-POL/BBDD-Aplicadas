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
CREATE OR REPLACE PROCEDURE negocio.importar_empleados(path_csv VARCHAR) LANGUAGE plpgsql AS $$
DECLARE i RECORD;
BEGIN DROP TABLE IF EXISTS temp_empleado;
DROP TABLE IF EXISTS temp_empleados_formatted;
CREATE TEMP TABLE temp_empleado (
    legajo_id VARCHAR(10),
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    dni VARCHAR(15),
    direccion VARCHAR(255),
    email_personal VARCHAR(100),
    email_empresa VARCHAR(100),
    cuil VARCHAR(15),
    cargo_nombre VARCHAR(50),
    sucursal_ciudad VARCHAR(100),
    turno_nombre VARCHAR(50)
);
EXECUTE format(
    'COPY temp_empleado (legajo_id, nombre, apellido, dni, direccion, email_personal, email_empresa, cuil, cargo_nombre, sucursal_ciudad, turno_nombre)
    FROM %L DELIMITER '';'' CSV HEADER;',
    path_csv
);
CREATE TEMP TABLE temp_empleados_formatted AS
SELECT legajo_id,
    upper(nombre) AS nombre,
    upper(apellido) AS apellido,
    dni,
    split_part(direccion, ',', 1) AS calle,
    split_part(direccion, ',', 2) AS ciudad,
    split_part(direccion, ',', 3) AS provincia,
    REGEXP_REPLACE(LOWER(email_personal), '[ \t]+', '', 'g') AS email_personal,
    REGEXP_REPLACE(LOWER(email_empresa), '[ \t]+', '', 'g') AS email_empresa,
    cuil,
    cargo_nombre,
    sucursal_ciudad,
    turno_nombre,
    (
        SELECT id_cargo
        FROM negocio.cargo_laboral
        WHERE LOWER(cargo_laboral.nombre) = LOWER(temp_empleado.cargo_nombre)
        LIMIT 1
    ) AS id_cargo,
    (
        SELECT id_sucursal
        FROM negocio.sucursal
        WHERE LOWER(UNACCENT(sucursal.ciudad)) = LOWER(UNACCENT(temp_empleado.sucursal_ciudad))
        LIMIT 1
    ) AS id_sucursal,
    (
        SELECT id_turno
        FROM negocio.turno_laboral
        WHERE LOWER(turno_laboral.nombre) = LOWER(temp_empleado.turno_nombre)
        LIMIT 1
    ) AS id_turno
FROM temp_empleado;
FOR i IN
SELECT *
FROM temp_empleados_formatted LOOP IF i.id_cargo IS NULL THEN RAISE NOTICE 'No se encontró el cargo laboral %',
    i.cargo_nombre;
ELSIF i.id_sucursal IS NULL THEN RAISE NOTICE 'No se encontró la sucursal %',
i.sucursal_ciudad;
ELSIF i.id_turno IS NULL THEN RAISE NOTICE 'No se encontró el turno laboral %',
i.turno_nombre;
ELSE
INSERT INTO negocio.empleado (
        legajo,
        nombre,
        apellido,
        tipo_identificacion,
        numero_identificacion,
        direccion,
        email_personal,
        email_laboral,
        cuil,
        id_cargo,
        id_sucursal,
        id_turno
    )
VALUES (
        i.legajo_id,
        i.nombre,
        i.apellido,
        'DNI',
        i.dni,
        i.calle,
        i.email_personal,
        i.email_empresa,
        i.cuil,
        i.id_cargo,
        i.id_sucursal,
        i.id_turno
    );
END IF;
END LOOP;
END $$;
TRUNCATE TABLE negocio.empleado;
CALL negocio.importar_empleados(
    'C:\Users\Facundo\Documents\Facundo\Universidad\2-Segundo\Bases de Datos Aplicadas\TP\Integrador\BBDD-Aplicadas\data\datos_basicos\empleados.csv'
)