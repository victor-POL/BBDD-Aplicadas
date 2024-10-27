---------------------------------------------------------------------------------------------------------------------
-- DESCRIPCION: SCRIPT PARA IMPORTAR TODOS LOS DATOS RECIBIDOS POR CSV
-- COMISION: 01-2900
-- GRUPO: 11
-- MATERIA: BASES DE DATOS APLICADAS
-- INTEGRANTE_1: POVOLI OLIVERA || VICTOR 43103780
-- INTEGRANTE_2: CARBALLO || FACUNDO NICOLAS TODO: DNI
-- INTEGRANTE_3: TODO: DATOS
-- INTEGRANTE_4: TODO: DATOS
---------------------------------------------------------------------------------------------------------------------
/* ----------------------------- CARGA EMPLEADOS ---------------------------- */
CALL negocio.importar_empleados('C:/Users/pc-vic/Desktop/BBDD-Aplicadas/data/datos_basicos/' || 'empleados.csv');

CALL negocio.importar_clasificacion_productos('C:/Users/pc-vic/Desktop/BBDD-Aplicadas/data/datos_basicos/' || 'clasificacion_productos.csv');

CALL negocio.importar_categorias_productos('C:/Users/pc-vic/Desktop/BBDD-Aplicadas/data/datos_basicos/' || 'catalogo.csv');

CALL negocio.importar_clasificacion_categoria_productos('C:/Users/pc-vic/Desktop/BBDD-Aplicadas/data/datos_basicos/' || 'clasificacion_productos.csv');

CALL negocio.importar_categorias_productos_importados('C:/Users/pc-vic/Desktop/BBDD-Aplicadas/data/datos_basicos/' || 'Productos_importados.csv');


/* ------------------- CARGA DE PRODUCTOS DESDE CATALOGOS ------------------- */
CALL negocio.importar_catalogo_productos_importados('C:/Users/pc-vic/Desktop/BBDD-Aplicadas/data/datos_basicos/' || 'Productos_importados.csv');

CALL negocio.importar_catalogo_productos_acc_electronicos('C:/Users/pc-vic/Desktop/BBDD-Aplicadas/data/datos_basicos/' || 'Electronic_accessories.csv');

CALL negocio.importar_catalogo_productos('C:/Users/pc-vic/Desktop/BBDD-Aplicadas/data/datos_basicos/' || 'catalogo.csv');


/* ----------------------- CARGA DE VENTAS REGISTRADAS ---------------------- */
CALL negocio.importar_ventas_registradas('C:/Users/pc-vic/Desktop/BBDD-Aplicadas/data/datos_basicos/' || 'Ventas_registradas.csv');

