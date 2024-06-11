USE Com2900G03
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'clinicaImportar')
    EXEC('CREATE SCHEMA clinicaImportar')
GO

DROP PROCEDURE IF EXISTS clinicaImportar.ImportarPacientes;
GO

--Funcion para capitalizar strings
DROP FUNCTION IF EXISTS [Clinica].[InitCap] 
GO

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

DROP FUNCTION IF EXISTS [Clinica].[getFinalNumber]
GO

CREATE FUNCTION [Clinica].[getFinalNumber] 
( 
    @str varchar(100)
)
RETURNS varchar(100)
AS
BEGIN
    DECLARE @result varchar(100)
	SET @str = TRIM(@str)
    SET @result = RIGHT(@str, patindex('%[^0-9]%', REVERSE(@str))-1)
    RETURN @result
END
GO

DROP FUNCTION IF EXISTS [Clinica].[getFirstString]
GO

CREATE FUNCTION [Clinica].[getFirstString] 
( 
    @str varchar(100)
)
RETURNS varchar(100)
AS
BEGIN
    DECLARE @result varchar(100)
	DECLARE @index int
	SET @index = patindex('%[0-9]%', @str)
	SET @str = TRIM(@str)
	IF @index < 1
	BEGIN
		set @index = 1
	END
    SET @result = left(@str, @index -1)
    RETURN @result
END
GO

-- Importar los pacientes desde un archivo CSV

DROP PROCEDURE IF EXISTS Clinica.ImportarPacientes
GO

CREATE PROCEDURE Clinica.ImportarPacientes
   @rutaArchivo NVARCHAR(MAX)
AS
BEGIN
    --DECLARE @rutaArchivo NVARCHAR(MAX)
    --SET @rutaArchivo = 'C:\Users\fede0\Desktop\BDDA\Tp-BDDA\Tp-BDDA\Dataset\Pacientes.csv'
    DECLARE @sql NVARCHAR(MAX)

    -- 1. Crear la tabla temporal
    DROP TABLE IF EXISTS Clinica.PacienteTemporal
    CREATE TABLE Clinica.PacienteTemporal
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
        Provincia VARCHAR(57),
    );

	DROP TABLE IF EXISTS Clinica.DomicilioTemporal
    CREATE TABLE Clinica.DomicilioTemporal
    (
        Id_Domicilio INT IDENTITY(1,1) PRIMARY KEY,
        Direccion VARCHAR(100),
        Calle VARCHAR(50),
        Numero VARCHAR(50),
        Piso VARCHAR(50),
        Departamento VARCHAR(50),
        Codigo_Postal VARCHAR(50),
        Pais VARCHAR(50),
        Provincia VARCHAR(50),
        Localidad VARCHAR(50),
    );

    -- 2. Importar los datos del archivo CSV

    DECLARE @ImportPacientes NVARCHAR(MAX)
    SET @ImportPacientes =
    'BULK INSERT clinica.PacienteTemporal ' +
    'FROM ''' + @rutaArchivo + ''' ' +
    'WITH ( ' +
    '    FIELDTERMINATOR = '';'', ' +
    '    ROWTERMINATOR = ''\n'', ' +
    '    FIRSTROW = 2, ' +
    '    CODEPAGE = ''65001''' +
    ')'

    EXEC sp_executesql @ImportPacientes
    
    -- Limpiar los datos:
    UPDATE Clinica.PacienteTemporal
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
    
    -- 3. Insertar los datos en la tabla domicilio temporal

    INSERT INTO Clinica.DomicilioTemporal
    (
        Direccion,
        Pais,
        Provincia,
        Localidad
    )
    SELECT DISTINCT
        Direccion,
        Nacionalidad,
        Provincia,
        Localidad
    FROM Clinica.PacienteTemporal
	WHERE Direccion NOT IN (SELECT Direccion FROM Clinica.DomicilioTemporal);

    UPDATE Clinica.DomicilioTemporal
    SET Calle = [Clinica].[getFirstString](Direccion),
        Numero = [Clinica].[getFinalNumber](Direccion);

    -- 4. Insertar los datos en la tabla domicilio

    INSERT INTO Clinica.Domicilio
    (
        Calle,
        Numero,
        Piso,
        Departamento,
        Codigo_Postal,
        Pais,
        Provincia,
        Localidad
    )
    SELECT
        Calle,
        Numero,
        Piso,
        Departamento,
        Codigo_Postal,
        Pais,
        Provincia,
        Localidad
    FROM Clinica.DomicilioTemporal
    WHERE Calle NOT IN (SELECT Calle FROM Clinica.Domicilio);

    -- 4. Insertar los datos en la tabla paciente
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
        Mail,
        Id_Domicilio
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
        Email,
        Id_Domicilio
    FROM Clinica.PacienteTemporal JOIN Clinica.DomicilioTemporal ON Clinica.PacienteTemporal.Direccion = Clinica.DomicilioTemporal.Direccion
    WHERE DNI NOT IN (SELECT Numero_Documento FROM Clinica.Paciente);

	--SELECT * FROM Clinica.PacienteTemporal INNER JOIN Clinica.DomicilioTemporal 
	--ON Clinica.PacienteTemporal.Direccion = Clinica.DomicilioTemporal.Direccion

    -- 5. Limpiar la tabla temporal
    DROP TABLE Clinica.PacienteTemporal;
    DROP TABLE Clinica.DomicilioTemporal;

END
GO


