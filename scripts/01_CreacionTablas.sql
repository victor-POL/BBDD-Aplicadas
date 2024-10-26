---------------------------------------------------------------------------------------------------------------------
-- DESCRIPCION: CREACION DE TABLAS 
-- TODO: FECHA ENTREGA:
-- COMISION: 01-2900
-- GRUPO: 11
-- MATERIA: BASES DE DATOS APLICADAS
-- INTEGRANTE_1: POVOLI OLIVERA, VICTOR 43103780
-- INTEGRANTE_2: CARBALLO, FACUNDO NICOLAS TODO: DNI
-- INTEGRANTE_3: TODO: DATOS
-- INTEGRANTE_4: TODO: DATOS
---------------------------------------------------------------------------------------------------------------------
-- PARA TABLA SUCURSAL
CREATE TABLE
    negocio.ciudad (
        id_ciudad SERIAL NOT NULL,
        nombre VARCHAR(25) NOT NULL,
        codigo_postal VARCHAR(10) NOT NULL,
        provincia VARCHAR(25) NOT NULL,
        CONSTRAINT PK_ciudad PRIMARY KEY (id_ciudad)
    );

CREATE TABLE
    negocio.sucursal (
        id_sucursal SMALLSERIAL NOT NULL,
        nombre VARCHAR(25) NOT NULL,
        id_ciudad SMALLINT NOT NULL,
        direccion VARCHAR(50) NOT NULL UNIQUE,
        telefono VARCHAR(13) NOT NULL, -- +54 11 1234 5678 (13 dígitos si se incluye el código de país y excluyendo espacios)
        CONSTRAINT PK_sucursal PRIMARY KEY (id_sucursal),
        CONSTRAINT FK_sucursal_ciudad FOREIGN KEY (id_ciudad) REFERENCES negocio.ciudad (id_ciudad)
    );

CREATE TABLE
    negocio.sucursal_horario (
        id SMALLSERIAL NOT NULL,
        id_sucursal SMALLINT NOT NULL,
        dia_semana char(1) NOT NULL, -- 1: Lunes, 2: Martes, 3: Miércoles, 4: Jueves, 5: Viernes, 6: Sábado, 7: Domingo
        hora_apertura TIME(0) NOT NULL, -- 0: es para que no tenga milisegundos
        hora_cierre TIME(0) NOT NULL, -- 0: es para que no tenga milisegundos
        CONSTRAINT PK_sucursal_horario PRIMARY KEY (id),
        CONSTRAINT FK_sucursal_horario_sucursal FOREIGN KEY (id_sucursal) REFERENCES negocio.sucursal (id_sucursal),
        CONSTRAINT CK_sucursal_horario_dia_semana CHECK (dia_semana IN ('1', '2', '3', '4', '5', '6', '7')),
        CONSTRAINT CK_horarios CHECK (
            (hora_apertura < hora_cierre)
            and (hora_cierre <> hora_apertura)
        )
    );

-- PARA TABLA EMPLEADO
CREATE TABLE
    negocio.cargo_laboral (
        id_cargo SMALLSERIAL NOT NULL,
        nombre VARCHAR(25) NOT NULL,
        CONSTRAINT PK_cargo PRIMARY KEY (id_cargo)
    );

CREATE TABLE
    negocio.turno_laboral (
        id_turno SMALLSERIAL NOT NULL,
        nombre VARCHAR(25) NOT NULL,
        CONSTRAINT PK_turno PRIMARY KEY (id_turno)
    );

CREATE TABLE
    negocio.empleado (
        id_empleado SMALLSERIAL NOT NULL,
        legajo VARCHAR(10) NOT NULL UNIQUE,
        nombre VARCHAR(25) NOT NULL,
        apellido VARCHAR(25) NOT NULL,
        tipo_identificacion VARCHAR(3) NOT NULL, -- DNI, LC, LE, CI, PAS
        numero_identificacion VARCHAR(11) NOT NULL UNIQUE,
        direccion VARCHAR(50) NOT NULL,
        email_personal VARCHAR(50) NOT NULL,
        email_laboral VARCHAR(50),
        cuil VARCHAR(13) NOT NULL,
        id_cargo SMALLINT NOT NULL,
        id_sucursal SMALLINT NOT NULL,
        id_turno SMALLINT NOT NULL,
        CONSTRAINT PK_empleado PRIMARY KEY (id_empleado),
        CONSTRAINT FK_empleado_sucursal FOREIGN KEY (id_sucursal) REFERENCES negocio.sucursal (id_sucursal),
        CONSTRAINT FK_empleado_cargo FOREIGN KEY (id_cargo) REFERENCES negocio.cargo_laboral (id_cargo),
        CONSTRAINT FK_empleado_turno FOREIGN KEY (id_turno) REFERENCES negocio.turno_laboral (id_turno),
        CONSTRAINT CK_empleado_tipo_identificacion CHECK (
            tipo_identificacion IN ('DNI', 'LC', 'LE', 'CI', 'PAS')
        ),
        CONSTRAINT CK_empleado_cuil CHECK (negocio.validar_cuil (cuil))
    );

-- PARA TABLA PRODUCTO
CREATE TABLE
    negocio.categoria_producto (
        id_categoria SERIAL NOT NULL,
        nombre VARCHAR(25) NOT NULL,
        CONSTRAINT PK_categoria_producto PRIMARY KEY (id_categoria)
    );

CREATE TABLE
    negocio.producto (
        id_producto SERIAL NOT NULL,
        nombre VARCHAR(100) NOT NULL,
        -- determinado por el catalogo.csv que tenia como longitud maxima 90
        id_categoria SMALLINT NOT NULL,
        descripcion VARCHAR(12) NOT NULL,
        -- al chequear el catalogo.csv se observo que la longitud maxima era 6, por lo que se puso como longitud maxima 10 por las dudas
        precio DECIMAL(10, 2) NOT NULL,
        -- al chequear el catalogo.csv, electronicaccesories.csv y productosimportados.csv se observo que se tenia hasta 2 decimales
        ultimo_cambio TIMESTAMP NOT NULL,
        -- TODO: verificar que tanta precision queremos en el timestamp
        CONSTRAINT PK_producto PRIMARY KEY (id_producto),
        CONSTRAINT FK_producto_categoria FOREIGN KEY (id_categoria) REFERENCES negocio.categoria_producto (id_categoria)
    );

-- PARA TABLA VENTA
CREATE TABLE
    negocio.tipo_cliente (
        id_tipo SERIAL NOT NULL,
        nombre VARCHAR(15) NOT NULL,
        CONSTRAINT PK_cliente_tipo PRIMARY KEY (id_tipo)
    );

CREATE TABLE
    negocio.medio_pago (
        id_medio_pago SERIAL NOT NULL,
        nombre VARCHAR(25) NOT NULL,
        nombre_en VARCHAR(25) NOT NULL,
        CONSTRAINT PK_medio_pago PRIMARY KEY (id_medio_pago)
    );