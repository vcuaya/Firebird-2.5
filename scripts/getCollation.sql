/*
Descripción:
    Este script recupera el nombre del conjunto de caracteres utilizado por la base de datos.
    El querie consulta la tabla de sistema RDB$DATABASE para obtener el RDB$CHARACTER_SET_NAME.

Uso:
    Ejecute este script en un entorno Firebird SQL para obtener el nombre del conjunto de caracteres.
 */
SELECT RDB$CHARACTER_SET_NAME FROM RDB$DATABASE;