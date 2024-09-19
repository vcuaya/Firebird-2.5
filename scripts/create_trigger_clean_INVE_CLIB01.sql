/*
Trigger para limpiar los campos libres antes de insertar o actualizar en la tabla INVE_CLIB01.

Caracteres a limpiar:
    - Espacios al inicio y al final
    - Tabuladores (ASCII 9)
    - Espacios no separables (ASCII 160)
    - Saltos de línea (ASCII 13 y 10)

Columnas a limpiar:
    - CAMPLIB2
    - CAMPLIB3
*/
SET TERM ^ ;

CREATE TRIGGER BI_INVE_CLIB01_CLEAN
BEFORE INSERT OR UPDATE
ON INVE_CLIB01
AS
BEGIN
    NEW.CAMPLIB2 = TRIM(BOTH FROM REPLACE(REPLACE(REPLACE(REPLACE(NEW.CAMPLIB2, ASCII_CHAR(9), ''), ASCII_CHAR(160), ''), ASCII_CHAR(13), ''), ASCII_CHAR(10), ''));
    NEW.CAMPLIB3 = TRIM(BOTH FROM REPLACE(REPLACE(REPLACE(REPLACE(NEW.CAMPLIB3, ASCII_CHAR(9), ''), ASCII_CHAR(160), ''), ASCII_CHAR(13), ''), ASCII_CHAR(10), ''));
END^

SET TERM ; ^
