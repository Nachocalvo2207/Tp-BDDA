/*
Sede;Direccion;Localidad;Provincia
Avellaneda;Av. Mitre 1248; Avellaneda;Buenos Aires
Barrio Norte;Larrea 949; Barrio Norte;Buenos Aires
*/

CREATE OR ALTER PROCEDURE Clinica.importarSedes
@rutaArchivo NVARCHAR(MAX)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX)

    --Chequeamos si la tabla temporal existe, si existe la borramos
    DROP TABLE IF EXISTS clinica.#tempSede
    CREATE TABLE clinica.#tempSede
    (
        Nombre_Sede VARCHAR(50)
        ,Direccion VARCHAR(100)
        ,Localidad VARCHAR(50)
        ,Provincia VARCHAR(50)
    )
    --Corro el BULK del import
    DECLARE @ImportSedes NVARCHAR(MAX)
    SET @ImportSedes = 
    'BULK INSERT clinica.#tempSede ' +
    'FROM ''' + @rutaArchivo + ''' ' +
    'WITH ( ' +
    '    FIELDTERMINATOR = '';'', ' +
    '    ROWTERMINATOR = ''\n'', ' +
    '    FIRSTROW = 2, ' +
    '    CODEPAGE = ''65001''' +
    ')'

   EXEC sp_executesql @ImportSedes

--Updateo tabla clinica sede en caso de que el registro ya exista(Chequemos con direccion ante la falta de un id):
UPDATE clinica.Sede_De_Atencion
SET
    Direccion = a.Direccion
FROM clinica.#tempSede a
WHERE clinica.Sede_De_Atencion.Nombre_Sede = a.Nombre_Sede

--Inserto los datos nuevos en la tabla final:

INSERT INTO clinica.Sede_De_Atencion
(
    Nombre_Sede
    ,Direccion

)
SELECT
    Nombre_Sede
    ,Direccion

FROM clinica.#tempSede A
WHERE a.Nombre_Sede NOT IN (SELECT Nombre_Sede FROM clinica.Sede_De_Atencion )

--Drop la tabla temporal
DROP TABLE clinica.#tempSede

END
