USE Com2900G03
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'clinicaImportar')
    EXEC('CREATE SCHEMA clinicaImportar')
GO

--Funcion para capitalizar strings
CREATE FUNCTION [Clinica].[InitCap] 
( 
    @InputString varchar(4000)
) 
RETURNS VARCHAR(4000)
AS
BEGIN

    DECLARE @Index          INT
    DECLARE @Char           CHAR(1)
    DECLARE @PrevChar       CHAR(1)
    DECLARE @OutputString   VARCHAR(255)

    SET @OutputString = LOWER(@InputString)
    SET @Index = 1

    WHILE @Index <= LEN(@InputString)
    BEGIN
        SET @Char     = SUBSTRING(@InputString, @Index, 1)
        SET @PrevChar = CASE WHEN @Index = 1 THEN ' '
        ELSE SUBSTRING(@InputString, @Index - 1, 1)
    END

    IF @PrevChar IN (' ', ';', ':', '!', '?', ',', '.', '_', '-', '/', '&', '''', '(')
    BEGIN
        IF @PrevChar != '''' OR UPPER(@Char) != 'S'
        SET @OutputString = STUFF(@OutputString, @Index, 1, UPPER(@Char))
    END
        SET @Index = @Index + 1
    END

    RETURN @OutputString
END
GO

DROP PROCEDURE IF EXISTS clinicaImportar.ImportarPacientes;
GO

-- Importar los pacientes desde un archivo CSV

CREATE PROCEDURE Clinica.ImportarPacientes
   @rutaArchivo NVARCHAR(MAX)
AS
BEGIN
    --DECLARE @rutaArchivo NVARCHAR(MAX)
    --SET @rutaArchivo = 'C:\Users\fede0\Desktop\BDDA\Tp-BDDA\Tp-BDDA\Dataset\Pacientes.csv'
    DECLARE @sql NVARCHAR(MAX)

    -- 1. Crear la tabla temporal
    DROP TABLE IF EXISTS Clinica.#PacienteTemporal;
    CREATE TABLE Clinica.#PacienteTemporal
    (
        Nombre VARCHAR(50),
        Apellido VARCHAR(50),
        Fecha_Nacimiento VARCHAR(15) NOT NULL,
        Tipo_Documento VARCHAR(10) NOT NULL,
        DNI INT NOT NULL,
        Sexo VARCHAR(9) NOT NULL CHECK (Sexo IN ('Masculino', 'Femenino')),
        Genero VARCHAR(10) NOT NULL,
        Telefono VARCHAR(20) NOT NULL,
        Nacionalidad VARCHAR(50) NOT NULL,
        Email VARCHAR(50)  NOT NULL,
        Direccion VARCHAR(100),
        Localidad VARCHAR(75),
        Provincia VARCHAR(57)  
    );

    -- 2. Importar los datos del archivo CSV

    DECLARE @ImportPacientes NVARCHAR(MAX)
    SET @ImportPacientes =
    'BULK INSERT clinica.#PacienteTemporal ' +
    'FROM ''' + @rutaArchivo + ''' ' +
    'WITH ( ' +
    '    FIELDTERMINATOR = '';'', ' +
    '    ROWTERMINATOR = ''\n'', ' +
    '    FIRSTROW = 2, ' +
    '    CODEPAGE = ''65001''' +
    ')'

    EXEC sp_executesql @ImportPacientes
    
    -- Limpiar los datos:
    UPDATE clinica.#PacienteTemporal
    SET Nombre = Nombre,
        Apellido = Apellido,
        Fecha_Nacimiento = CONVERT(DATE, Fecha_Nacimiento, 103),
        Tipo_Documento = REPLACE(Tipo_Documento, Tipo_Documento, UPPER(Tipo_Documento)),
        Sexo = REPLACE(Sexo, Sexo, UPPER(LEFT(Sexo, 1)) + LOWER(SUBSTRING(Sexo, 2, LEN(Sexo)-1))),
        Genero = REPLACE(Genero, Genero, UPPER(LEFT(Genero, 1)) + LOWER(SUBSTRING(Genero, 2, LEN(Genero)-1))),
        Telefono = Telefono,
        Nacionalidad = REPLACE(Nacionalidad, Nacionalidad, UPPER(LEFT(Nacionalidad, 1)) + LOWER(SUBSTRING(Nacionalidad, 2, LEN(Nacionalidad)-1))),
        Email = REPLACE(Email, Email, LOWER(Email)),
        Direccion = REPLACE(Direccion, Direccion, [Clinica].[InitCap](Direccion)),
        Localidad = REPLACE(Localidad, Localidad, [Clinica].[InitCap](Localidad)),
        Provincia = REPLACE(Provincia, Provincia, [Clinica].[InitCap](Provincia));
    
    -- 3. Insertar los datos en la tabla final
    
    INSERT INTO Clinica.Paciente
    (
        Nombre,
        Apellido,
        Fecha_Nacimiento,
        Tipo_Documento,
        Numero_Documento,
        Sexo_Biologico,
        Genero,
        Telefono_Fijo,
        Nacionalidad,
        Mail
    )
    SELECT
        Nombre,
        Apellido,
        Fecha_Nacimiento,
        Tipo_Documento,
        DNI,
        Sexo,
        Genero,
        Telefono,
        Nacionalidad,
        Email
    FROM Clinica.#PacienteTemporal
    WHERE DNI NOT IN (SELECT Numero_Documento FROM Clinica.Paciente);

    -- 4. Limpiar la tabla temporal
    DROP TABLE Clinica.#PacienteTemporal;

END;
GO

EXEC clinicaImportar.ImportarPacientes 'C:\Users\fede0\Desktop\BDDA\Tp-BDDA\Tp-BDDA\Dataset\Pacientes.csv';


