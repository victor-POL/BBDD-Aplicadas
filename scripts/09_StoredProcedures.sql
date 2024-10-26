CREATE OR REPLACE PROCEDURE negocio.insertar_empleado(
        IN p_legajo VARCHAR(10),
        IN p_nombre VARCHAR(50),
        IN p_apellido VARCHAR(50),
        IN p_tipo_identificacion VARCHAR(3),
        IN p_numero_identificacion VARCHAR(11),
        IN p_direccion VARCHAR(50),
        IN p_email_personal VARCHAR(80),
        IN p_email_laboral VARCHAR(80),
        IN p_cuil VARCHAR(13),
        IN p_id_cargo SMALLINT,
        IN p_id_sucursal SMALLINT,
        IN p_id_turno SMALLINT
    ) LANGUAGE plpgsql AS $$ BEGIN
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
        p_legajo,
        p_nombre,
        p_apellido,
        p_tipo_identificacion,
        p_numero_identificacion,
        p_direccion,
        p_email_personal,
        p_email_laboral,
        p_cuil,
        p_id_cargo,
        p_id_sucursal,
        p_id_turno
    );
END;
$$;

CREATE OR REPLACE PROCEDURE negocio.insertar_sucursal(
        IN p_nombre VARCHAR(25),
        IN p_calle VARCHAR(50),
        IN p_ciudad VARCHAR(25),
        IN p_codigo_postal VARCHAR(8),
        IN p_provincia VARCHAR(25),
        IN p_telefono VARCHAR(13)
    ) LANGUAGE plpgsql AS $$ BEGIN
INSERT INTO negocio.sucursal (
        nombre,
        calle,
        ciudad,
        codigo_postal,
        provincia,
        telefono
    )
VALUES (
        p_nombre,
        p_calle,
        p_ciudad,
        p_codigo_postal,
        p_provincia,
        p_telefono
    );
END;
$$;