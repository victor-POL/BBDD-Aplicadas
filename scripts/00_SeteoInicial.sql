---------------------------------------------------------------------------------------------------------------------
-- DESCRIPCION: SETEO INICIAL 
-- TODO: FECHA ENTREGA:
-- COMISION: 01-2900
-- GRUPO: 11
-- MATERIA: BASES DE DATOS APLICADAS
-- INTEGRANTE_1: POVOLI OLIVERA, VICTOR 43103780
-- INTEGRANTE_2: CARBALLO, FACUNDO NICOLAS TODO: DNI
-- INTEGRANTE_3: TODO: DATOS
-- INTEGRANTE_4: TODO: DATOS
---------------------------------------------------------------------------------------------------------------------

CREATE SCHEMA negocio

-- ELIMINO CUALQUIER TABLA DE LA DDBB
DROP TABLE IF EXISTS negocio.sucursal CASCADE;
DROP TABLE IF EXISTS negocio.ciudad;
DROP TABLE IF EXISTS negocio.sucursal_horario;
DROP TABLE IF EXISTS negocio.empleado;
DROP TABLE IF EXISTS negocio.cargo_laboral;
DROP TABLE IF EXISTS negocio.turno_laboral;
DROP TABLE IF EXISTS negocio.producto;
DROP TABLE IF EXISTS negocio.categoria_producto;
DROP TABLE IF EXISTS negocio.tipo_cliente;
DROP TABLE IF EXISTS negocio.medio_pago;


-- FUNCIONES PARA LAS TABLAS
CREATE OR REPLACE FUNCTION negocio.validar_cuil(cuil TEXT) 
RETURNS BOOLEAN AS $$
BEGIN
    -- TODO: Implementar la función que valide un CUIL
    
    RETURN true;
END;
$$ LANGUAGE plpgsql;


-- auxiliar comapraciones CI y AI
-- https://www.postgresql.org/docs/current/collation.html
-- https://dba.stackexchange.com/questions/299477/collation-for-accent-insensitive-comparison-on-postgres
-- https://help.scriptcase.net/portal/en/kb/articles/how-to-use-the-ignore-accent-option#Enabling_extension
CREATE EXTENSION unaccent;
