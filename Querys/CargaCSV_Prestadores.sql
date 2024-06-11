CREATE OR ALTER PROCEDURE Clinica.importarPrestadores
@rutaArchivo NVARCHAR(MAX)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX)

    --Chequeamos si la tabla temporal existe, si existe la borramos
    DROP TABLE IF EXISTS clinica.tempPrestador
    CREATE TABLE clinica.tempPrestador
    (
        Nombre_Prestador VARCHAR(50)
        ,Plan_prestador VARCHAR(50)
    )
    --Corro el BULK del import
    DECLARE @ImportPrestadores NVARCHAR(MAX)
    SET @ImportPrestadores = 
    'BULK INSERT clinica.tempPrestador ' +
    'FROM ''' + @rutaArchivo + ''' ' +
    'WITH ( ' +
    '    FIELDTERMINATOR = '';'', ' +
    '    ROWTERMINATOR = ''\n'', ' +
    '    FIRSTROW = 2, ' +
    '    CODEPAGE = ''65001''' +
    ')'

   EXEC sp_executesql @ImportPrestadores



   --Limpio los datos de la tabla STG quitando los ";;" del final de la linea
    UPDATE clinica.tempPrestador
    SET Plan_prestador = LEFT(Plan_prestador, LEN(Plan_prestador) - 2)
    WHERE Plan_prestador LIKE '%;;'



	--Inserto los datos nuevos en la tabla final:

	--Inserto los datos nuevos en la tabla final, evitando duplicados:
	INSERT INTO clinica.Prestador
	(
		Nombre_Prestador,
		Plan_prestador
	)
	SELECT Nombre_Prestador, Plan_prestador
	FROM clinica.tempPrestador A
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM clinica.Prestador B
        WHERE A.Nombre_Prestador = B.Nombre_Prestador
        AND A.Plan_prestador = B.Plan_prestador
    )
END

