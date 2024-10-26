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
CREATE TABLE negocio.ciudad (
    id_ciudad SERIAL NOT NULL,
    nombre VARCHAR(25) NOT NULL,
    codigo_postal VARCHAR(8) NOT NULL,
    provincia VARCHAR(25) NOT NULL,
    CONSTRAINT PK_ciudad PRIMARY KEY (id_ciudad),
    CONSTRAINT UQ_nombre_cp_provincia UNIQUE (nombre, codigo_postal, provincia),
    CONSTRAINT CK_provincia CHECK (
        provincia IN (
            'Ciudad Autónoma de Buenos Aires',
            'Provincia de Buenos Aires',
            'Catamarca',
            'Chaco',
            'Chubut',
            'Córdoba',
            'Corrientes',
            'Entre Ríos',
            'Formosa',
            'Jujuy',
            'La Pampa',
            'La Rioja',
            'Mendoza',
            'Misiones',
            'Neuquén',
            'Río Negro',
            'Salta',
            'San Juan',
            'San Luis',
            'Santa Cruz',
            'Santa Fe',
            'Santiago del Estero',
            'Tierra del Fuego',
            'Tucumán'
        )
    )
);
CREATE TABLE negocio.sucursal (
    id_sucursal SMALLSERIAL NOT NULL,
    nombre VARCHAR(25),
    calle VARCHAR(50),
    ciudad VARCHAR(25),
    codigo_postal VARCHAR(8),
    provincia VARCHAR(25),
    telefono VARCHAR(13),
    -- +54 11 1234 5678 (13 dígitos si se incluye el código de país y excluyendo espacios)
    CONSTRAINT PK_sucursal PRIMARY KEY (id_sucursal),
    CONSTRAINT UQ_direccion UNIQUE(calle, ciudad, codigo_postal, provincia)
);
CREATE TABLE negocio.sucursal_horario (
    id SMALLSERIAL NOT NULL,
    id_sucursal SMALLINT NOT NULL,
    dia_semana char(1) NOT NULL,
    -- 1: Lunes, 2: Martes, 3: Miércoles, 4: Jueves, 5: Viernes, 6: Sábado, 7: Domingo
    hora_apertura TIME(0) NOT NULL,
    -- 0: es para que no tenga milisegundos
    hora_cierre TIME(0) NOT NULL,
    -- 0: es para que no tenga milisegundos
    CONSTRAINT PK_sucursal_horario PRIMARY KEY (id),
    CONSTRAINT FK_sucursal_horario_sucursal FOREIGN KEY (id_sucursal) REFERENCES negocio.sucursal (id_sucursal),
    CONSTRAINT UQ_sucursal_horario UNIQUE (
        id_sucursal,
        dia_semana,
        hora_apertura,
        hora_cierre
    ),
    CONSTRAINT CK_sucursal_horario_dia_semana CHECK (
        dia_semana IN ('1', '2', '3', '4', '5', '6', '7')
    ),
    CONSTRAINT CK_horarios CHECK (
        (hora_apertura < hora_cierre)
        and (hora_cierre <> hora_apertura)
    )
);
-- PARA TABLA EMPLEADO
CREATE TABLE negocio.cargo_laboral (
    id_cargo SMALLSERIAL NOT NULL,
    nombre VARCHAR(25) NOT NULL UNIQUE,
    CONSTRAINT PK_cargo PRIMARY KEY (id_cargo)
);
CREATE TABLE negocio.turno_laboral (
    id_turno SMALLSERIAL NOT NULL,
    nombre VARCHAR(25) NOT NULL UNIQUE,
    CONSTRAINT PK_turno PRIMARY KEY (id_turno)
);
CREATE TABLE negocio.empleado (
    id_empleado SMALLSERIAL NOT NULL,
    legajo VARCHAR(10) NOT NULL UNIQUE,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    tipo_identificacion VARCHAR(3) NOT NULL,
    -- DNI, LC, LE, CI, PAS
    numero_identificacion VARCHAR(11) NOT NULL UNIQUE,
    direccion VARCHAR(50),
    email_personal VARCHAR(80),
    email_laboral VARCHAR(80),
    cuil VARCHAR(13),
    id_cargo SMALLINT NOT NULL,
    id_sucursal SMALLINT,
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
CREATE TABLE negocio.clasfificacion_categoria_producto (
    id_clasificacion SMALLSERIAL NOT NULL,
    nombre VARCHAR(25) NOT NULL UNIQUE,
    CONSTRAINT PK_clasificacion PRIMARY KEY (id_clasificacion)
);
CREATE TABLE negocio.categoria_producto (
    id_categoria SMALLSERIAL NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    id_clasificacion SMALLINT,
    CONSTRAINT PK_categoria_producto PRIMARY KEY (id_categoria),
    CONSTRAINT FK_clasificacion_categoria_producto FOREIGN KEY (id_clasificacion) REFERENCES negocio.clasfificacion_categoria_producto (id_clasificacion)
);
CREATE TABLE negocio.producto (
    id_producto SERIAL NOT NULL,
    codigo VARCHAR(10),
    nombre VARCHAR(100) NOT NULL,
    -- determinado por el catalogo.csv que tenia como longitud maxima 90
    id_categoria SMALLINT NOT NULL,
    descripcion VARCHAR(70),
    -- al chequear el catalogo.csv se observo que la longitud maxima era 6, por lo que se puso como longitud maxima 10 por las dudas
    precio DECIMAL(10, 2) NOT NULL,
    -- al chequear el catalogo.csv, electronicaccesories.csv y productosimportados.csv se observo que se tenia hasta 2 decimales
    ultimo_cambio TIMESTAMP NOT NULL,
    -- TODO: verificar que tanta precision queremos en el timestamp
    CONSTRAINT PK_producto PRIMARY KEY (id_producto),
    CONSTRAINT FK_producto_categoria FOREIGN KEY (id_categoria) REFERENCES negocio.categoria_producto (id_categoria),
    CONSTRAINT UQ_producto UNIQUE (codigo, nombre, id_categoria)
);
CREATE TABLE negocio.extra_info_producto (
    id_extra_info SMALLSERIAL NOT NULL,
    id_producto SMALLINT NOT NULL,
    precio_referencia DECIMAL(10,2) NOT NULL,
    unidad_referencia VARCHAR(10) NOT NULL,
    CONSTRAINT PK_extra_info_producto PRIMARY KEY (id_extra_info),
    CONSTRAINT FK_extra_info_producto_producto FOREIGN KEY (id_producto) REFERENCES negocio.producto (id_producto)
);
-- PARA TABLA CLIENTE
CREATE TABLE negocio.tipo_cliente (
    id_tipo SMALLSERIAL NOT NULL,
    nombre VARCHAR(15) NOT NULL,
    CONSTRAINT PK_cliente_tipo PRIMARY KEY (id_tipo)
);

CREATE TABLE negocio.cliente (
    id_cliente SERIAL NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    tipo_identificacion VARCHAR(3) NOT NULL,
    -- DNI, LC, LE, CI, PAS
    numero_identificacion VARCHAR(11) NOT NULL UNIQUE,
    genero CHAR(1),
    direccion VARCHAR(50),
    email VARCHAR(80),
    cuil VARCHAR(13),
    id_tipo_cliente SMALLINT NOT NULL,
    CONSTRAINT PK_cliente PRIMARY KEY (id_cliente),
    CONSTRAINT FK_cliente_tipo FOREIGN KEY (id_tipo_cliente) REFERENCES negocio.tipo_cliente (id_tipo),
    CONSTRAINT CK_cliente_tipo_identificacion CHECK (
        tipo_identificacion IN ('DNI', 'LC', 'LE', 'CI', 'PAS')
    ),
    CONSTRAINT CK_cliente_cuil CHECK (negocio.validar_cuil (cuil)),
    CONSTRAINT CK_cliente_genero CHECK (genero IN ('M', 'F', 'O')),
    CONSTRAINT UQ_cliente UNIQUE (tipo_identificacion, numero_identificacion),
    CONSTRAINT UQ_cuil UNIQUE (cuil)
);

-- PARA TABLA VENTA
CREATE TABLE negocio.medio_pago (
    id_medio_pago SMALLSERIAL NOT NULL,
    nombre VARCHAR(25) NOT NULL,
    nombre_en VARCHAR(25) NOT NULL,
    CONSTRAINT PK_medio_pago PRIMARY KEY (id_medio_pago)
);

CREATE TABLE negocio.venta (
    id_venta SERIAL NOT NULL,
    -- factura
    cod_factura VARCHAR(20) NOT NULL UNIQUE,
    tipo_factura CHAR(1) NOT NULL,
    -- sucursal
    id_sucursal SMALLINT,
    ciudad_sucursal VARCHAR(25) NOT NULL,
    -- cliente
    id_cliente SMALLINT,
    tipo_cliente VARCHAR(15),
    genero_cliente CHAR(1),
    -- producto
    id_producto SMALLINT,
    nombre_producto VARCHAR(100) NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    cantidad SMALLINT NOT NULL,
    -- venta
    fecha_venta TIMESTAMP NOT NULL,
    -- medio pago
    id_medio_pago SMALLINT,
    medio_pago_nombre VARCHAR(25) NOT NULL,
    identificador_pago VARCHAR(30) UNIQUE,
    -- empleado
    id_empleado SMALLINT,
    legajo_empleado VARCHAR(10) NOT NULL,
    CONSTRAINT PK_venta PRIMARY KEY (id_venta),
    CONSTRAINT FK_venta_sucursal FOREIGN KEY (id_sucursal) REFERENCES negocio.sucursal (id_sucursal),
    CONSTRAINT FK_venta_cliente FOREIGN KEY (id_cliente) REFERENCES negocio.cliente (id_cliente),
    CONSTRAINT FK_venta_producto FOREIGN KEY (id_producto) REFERENCES negocio.producto (id_producto),
    CONSTRAINT FK_venta_medio_pago FOREIGN KEY (id_medio_pago) REFERENCES negocio.medio_pago (id_medio_pago),
    CONSTRAINT FK_venta_empleado FOREIGN KEY (id_empleado) REFERENCES negocio.empleado (id_empleado),
    CONSTRAINT CHECK_tipo_factura CHECK (tipo_factura IN ('A', 'B', 'C'))
);