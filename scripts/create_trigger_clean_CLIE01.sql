/*
Trigger para limpiar los datos de los clientes antes de insertar o actualizar en la tabla CLIE01.

Caracteres a limpiar:
    - Espacios al inicio y al final
    - Saltos de línea (ASCII 13 y 10)

Columnas a limpiar:
    - NOMBRE
    - CALLE
    - NUMEXT
    - NUMINT
    - COLONIA
*/
SET TERM ^ ;

CREATE TRIGGER BI_CLIE01_CLEAN
BEFORE INSERT OR UPDATE
ON CLIE01
AS
BEGIN
    NEW.NOMBRE = NULLIF(TRIM(REPLACE(REPLACE(NEW.NOMBRE, ASCII_CHAR(13), ''), ASCII_CHAR(10), '')), '');
    NEW.CALLE = NULLIF(TRIM(REPLACE(REPLACE(NEW.CALLE, ASCII_CHAR(13), ''), ASCII_CHAR(10), '')), '');
    NEW.NUMEXT = NULLIF(TRIM(REPLACE(REPLACE(NEW.NUMEXT, ASCII_CHAR(13), ''), ASCII_CHAR(10), '')), '');
    NEW.NUMINT = NULLIF(TRIM(REPLACE(REPLACE(NEW.NUMINT, ASCII_CHAR(13), ''), ASCII_CHAR(10), '')), '');
    NEW.COLONIA = NULLIF(TRIM(REPLACE(REPLACE(NEW.COLONIA, ASCII_CHAR(13), ''), ASCII_CHAR(10), '')), '');
END^

SET TERM ; ^