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
CREATE TABLE negocio.sucursal(
    id_sucursal smallserial NOT NULL,
    nombre varchar(25),
    calle varchar(50),
    ciudad varchar(25),
    codigo_postal varchar(8),
    provincia varchar(25),
    telefono varchar(13),
    -- +54 11 1234 5678 (13 dígitos si se incluye el código de país y excluyendo espacios)
    CONSTRAINT PK_sucursal PRIMARY KEY (id_sucursal),
    CONSTRAINT UQ_direccion UNIQUE (calle, ciudad, codigo_postal, provincia)
);

CREATE TABLE negocio.sucursal_horario(
    id smallserial NOT NULL,
    id_sucursal smallint NOT NULL,
    dia_semana char(1) NOT NULL,
    -- 1: Lunes, 2: Martes, 3: Miércoles, 4: Jueves, 5: Viernes, 6: Sábado, 7: Domingo
    hora_apertura time(0) NOT NULL,
    -- 0: es para que no tenga milisegundos
    hora_cierre time(0) NOT NULL,
    -- 0: es para que no tenga milisegundos
    CONSTRAINT PK_sucursal_horario PRIMARY KEY (id),
    CONSTRAINT FK_sucursal_horario_sucursal FOREIGN KEY (id_sucursal) REFERENCES negocio.sucursal(id_sucursal),
    CONSTRAINT UQ_sucursal_horario UNIQUE (id_sucursal, dia_semana, hora_apertura, hora_cierre),
    CONSTRAINT CK_sucursal_horario_dia_semana CHECK (dia_semana IN ('1', '2', '3', '4', '5', '6', '7')),
    CONSTRAINT CK_horarios CHECK ((hora_apertura < hora_cierre) AND (hora_cierre <> hora_apertura))
);

-- PARA TABLA EMPLEADO
CREATE TABLE negocio.cargo_laboral(
    id_cargo smallserial NOT NULL,
    nombre varchar(25) NOT NULL UNIQUE,
    CONSTRAINT PK_cargo PRIMARY KEY (id_cargo)
);

CREATE TABLE negocio.turno_laboral(
    id_turno smallserial NOT NULL,
    nombre varchar(25) NOT NULL UNIQUE,
    CONSTRAINT PK_turno PRIMARY KEY (id_turno)
);

CREATE TABLE negocio.empleado(
    id_empleado smallserial NOT NULL,
    legajo varchar(10) NOT NULL UNIQUE,
    nombre varchar(50) NOT NULL,
    apellido varchar(50) NOT NULL,
    tipo_identificacion varchar(3) NOT NULL,
    -- DNI, LC, LE, CI, PAS
    numero_identificacion varchar(11) NOT NULL UNIQUE,
    direccion varchar(50),
    email_personal varchar(80),
    email_laboral varchar(80),
    cuil varchar(13),
    id_cargo smallint NOT NULL,
    id_sucursal smallint,
    id_turno smallint NOT NULL,
    CONSTRAINT PK_empleado PRIMARY KEY (id_empleado),
    CONSTRAINT FK_empleado_sucursal FOREIGN KEY (id_sucursal) REFERENCES negocio.sucursal(id_sucursal),
    CONSTRAINT FK_empleado_cargo FOREIGN KEY (id_cargo) REFERENCES negocio.cargo_laboral(id_cargo),
    CONSTRAINT FK_empleado_turno FOREIGN KEY (id_turno) REFERENCES negocio.turno_laboral(id_turno),
    CONSTRAINT CK_empleado_tipo_identificacion CHECK (tipo_identificacion IN ('DNI', 'LC', 'LE', 'CI', 'PAS')),
    CONSTRAINT CK_empleado_cuil CHECK (negocio.validar_cuil(cuil))
);

-- PARA TABLA PRODUCTO
CREATE TABLE negocio.clasfificacion_categoria_producto(
    id_clasificacion smallserial NOT NULL,
    nombre varchar(25) NOT NULL UNIQUE,
    CONSTRAINT PK_clasificacion PRIMARY KEY (id_clasificacion)
);

CREATE TABLE negocio.categoria_producto(
    id_categoria smallserial NOT NULL,
    nombre varchar(50) NOT NULL,
    id_clasificacion smallint,
    CONSTRAINT PK_categoria_producto PRIMARY KEY (id_categoria),
    CONSTRAINT FK_clasificacion_categoria_producto FOREIGN KEY (id_clasificacion) REFERENCES negocio.clasfificacion_categoria_producto(id_clasificacion)
);

CREATE TABLE negocio.producto(
    id_producto serial NOT NULL,
    codigo varchar(10),
    nombre varchar(100) NOT NULL,
    -- determinado por el catalogo.csv que tenia como longitud maxima 90
    id_categoria smallint NOT NULL,
    descripcion varchar(70),
    -- al chequear el catalogo.csv se observo que la longitud maxima era 6, por lo que se puso como longitud maxima 10 por las dudas
    precio DECIMAL(10, 2) NOT NULL,
    -- al chequear el catalogo.csv, electronicaccesories.csv y productosimportados.csv se observo que se tenia hasta 2 decimales
    ultimo_cambio timestamp NOT NULL,
    -- TODO: verificar que tanta precision queremos en el timestamp
    CONSTRAINT PK_producto PRIMARY KEY (id_producto),
    CONSTRAINT FK_producto_categoria FOREIGN KEY (id_categoria) REFERENCES negocio.categoria_producto(id_categoria),
    CONSTRAINT UQ_producto UNIQUE (codigo, nombre, id_categoria)
);

CREATE TABLE negocio.extra_info_producto(
    id_extra_info smallserial NOT NULL,
    id_producto smallint NOT NULL,
    precio_referencia DECIMAL(10, 2) NOT NULL,
    unidad_referencia varchar(10) NOT NULL,
    CONSTRAINT PK_extra_info_producto PRIMARY KEY (id_extra_info),
    CONSTRAINT FK_extra_info_producto_producto FOREIGN KEY (id_producto) REFERENCES negocio.producto(id_producto)
);

-- PARA TABLA CLIENTE
CREATE TABLE negocio.tipo_cliente(
    id_tipo smallserial NOT NULL,
    nombre varchar(15) NOT NULL,
    CONSTRAINT PK_cliente_tipo PRIMARY KEY (id_tipo)
);

CREATE TABLE negocio.cliente(
    id_cliente serial NOT NULL,
    nombre varchar(50) NOT NULL,
    apellido varchar(50) NOT NULL,
    tipo_identificacion varchar(3) NOT NULL,
    -- DNI, LC, LE, CI, PAS
    numero_identificacion varchar(11) NOT NULL UNIQUE,
    genero char(1),
    direccion varchar(50),
    email varchar(80),
    cuil varchar(13),
    id_tipo_cliente smallint NOT NULL,
    CONSTRAINT PK_cliente PRIMARY KEY (id_cliente),
    CONSTRAINT FK_cliente_tipo FOREIGN KEY (id_tipo_cliente) REFERENCES negocio.tipo_cliente(id_tipo),
    CONSTRAINT CK_cliente_tipo_identificacion CHECK (tipo_identificacion IN ('DNI', 'LC', 'LE', 'CI', 'PAS')),
    CONSTRAINT CK_cliente_cuil CHECK (negocio.validar_cuil(cuil)),
    CONSTRAINT CK_cliente_genero CHECK (genero IN ('M', 'F', 'O')),
    CONSTRAINT UQ_cliente UNIQUE (tipo_identificacion, numero_identificacion),
    CONSTRAINT UQ_cuil UNIQUE (cuil)
);

-- PARA TABLA VENTA
CREATE TABLE negocio.medio_pago(
    id_medio_pago smallserial NOT NULL,
    nombre varchar(25) NOT NULL,
    nombre_en varchar(25) NOT NULL,
    CONSTRAINT PK_medio_pago PRIMARY KEY (id_medio_pago)
);

CREATE TABLE negocio.venta(
    id_venta serial NOT NULL,
    -- factura
    cod_factura varchar(20) NOT NULL UNIQUE,
    tipo_factura char(1) NOT NULL,
    -- sucursal
    id_sucursal smallint,
    ciudad_sucursal varchar(25) NOT NULL,
    -- cliente
    id_cliente smallint,
    tipo_cliente varchar(15),
    genero_cliente char(1),
    -- producto
    id_producto smallint,
    nombre_producto varchar(100) NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    cantidad smallint NOT NULL,
    -- venta
    fecha_venta timestamp NOT NULL,
    -- medio pago
    id_medio_pago smallint,
    medio_pago_nombre varchar(25) NOT NULL,
    identificador_pago varchar(30) UNIQUE,
    -- empleado
    id_empleado smallint,
    legajo_empleado varchar(10) NOT NULL,
    CONSTRAINT PK_venta PRIMARY KEY (id_venta),
    CONSTRAINT FK_venta_sucursal FOREIGN KEY (id_sucursal) REFERENCES negocio.sucursal(id_sucursal),
    CONSTRAINT FK_venta_cliente FOREIGN KEY (id_cliente) REFERENCES negocio.cliente(id_cliente),
    CONSTRAINT FK_venta_producto FOREIGN KEY (id_producto) REFERENCES negocio.producto(id_producto),
    CONSTRAINT FK_venta_medio_pago FOREIGN KEY (id_medio_pago) REFERENCES negocio.medio_pago(id_medio_pago),
    CONSTRAINT FK_venta_empleado FOREIGN KEY (id_empleado) REFERENCES negocio.empleado(id_empleado),
    CONSTRAINT CHECK_tipo_factura CHECK (tipo_factura IN ('A', 'B', 'C'))
);

