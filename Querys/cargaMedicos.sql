/* Ejemplo de archivo CSV
Nombre;Apellidos;Especialidad;Número de colegiado
Dra. ALONSO; Claudia;CLINICA MEDICA;119901
Dra. BIGNOTTI; Alicia;CLINICA MEDICA;119902
*/


CREATE OR ALTER PROCEDURE Clinica.importarMedicos
@rutaArchivo NVARCHAR(MAX)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX)

    --Chequeamos si la tabla temporal existe, si existe la borramos
    DROP TABLE IF EXISTS clinica.#tempMedico
    CREATE TABLE clinica.#tempMedico
    (
        apellido VARCHAR(30),
        nombre VARCHAR(30),
        especialidad VARCHAR(30),
        colegiado INT NOT NULL
    )
	--Corro el BULK del import
	DECLARE @ImportMedicos NVARCHAR(MAX)
	SET @ImportMedicos = 
    'BULK INSERT clinica.#tempMedico ' +
    'FROM ''' + @rutaArchivo + ''' ' +
    'WITH ( ' +
    '    FIELDTERMINATOR = '';'', ' +
    '    ROWTERMINATOR = ''\n'', ' +
    '    FIRSTROW = 2, ' +
    '    CODEPAGE = ''65001''' +
    ')'

   EXEC sp_executesql @ImportMedicos

-- Limpio los datos:

--Quito el Dr. y Dra. de los nombres:
    UPDATE clinica.#tempMedico
    SET apellido = REPLACE(apellido, 'Dra. ', '')

    UPDATE clinica.#tempMedico
    SET apellido = REPLACE(apellido, 'Dr. ', '')

--Chequeo si la matricula ya existe en la tabla final, si ya existe no lo inserto (suponemos que la matricula es unica):
--    DELETE FROM clinica.#tempMedico
--    WHERE colegiado IN (SELECT Nro_Matricula FROM clinica.Medico)

--Updateo tabla clinica medico en caso de que el registro ya exista:
UPDATE clinica.Medico 
SET
    Nombre = a.Nombre,
    Apellido = a.Apellido
FROM clinica.#tempMedico a
WHERE clinica.Medico.Nro_Matricula = a.colegiado

--Inserto los datos en la tabla final:
INSERT INTO clinica.Medico
(
    Nombre,
    Apellido,
    Nro_Matricula
)
SELECT
    Nombre
    ,Apellido
    ,colegiado
FROM clinica.#tempMedico
WHERE colegiado NOT IN (SELECT Nro_Matricula FROM clinica.Medico)

--Limpio la tabla temporal
DROP TABLE clinica.#tempMedico

END


