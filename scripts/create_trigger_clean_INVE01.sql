/*
Trigger para limpiar los productos antes de insertar o actualizar en la tabla INVE01.

Caracteres a limpiar:
    - Espacios al inicio y al final
    - Tabuladores (ASCII 9)
    - Espacios no separables (ASCII 160)
    - Saltos de línea (ASCII 13 y 10)

Columnas a limpiar:
    - CVE_ART
    - DESCR
*/
SET TERM ^ ;

CREATE TRIGGER BI_INVE01_CLEAN
BEFORE INSERT OR UPDATE
ON INVE01
AS
BEGIN
    NEW.CVE_ART = TRIM(BOTH FROM REPLACE(REPLACE(REPLACE(REPLACE(NEW.CVE_ART, ASCII_CHAR(9), ''), ASCII_CHAR(160), ''), ASCII_CHAR(13), ''), ASCII_CHAR(10), ''));
    NEW.DESCR = TRIM(BOTH FROM REPLACE(REPLACE(REPLACE(REPLACE(NEW.DESCR, ASCII_CHAR(9), ''), ASCII_CHAR(160), ''), ASCII_CHAR(13), ''), ASCII_CHAR(10), ''));
END^

SET TERM ; ^