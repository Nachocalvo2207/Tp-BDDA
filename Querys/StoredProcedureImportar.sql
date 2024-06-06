
--SQL Server Stored Procedure to import data from a CSV file to a SQL Server table
--Importar Pacientes

USE Com2900G03
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'clinicaImportar')
    EXEC('CREATE SCHEMA clinicaImportar')
GO

CREATE PROCEDURE clinicaImportar.ImportarPacientes
AS
BEGIN
    -- 1. Crear la tabla temporal
    DROP TABLE clinicaImportar.PacienteTemporal;

    CREATE TABLE clinicaImportar.PacienteTemporal
    (
        Nombre VARCHAR(50) COLLATE Modern_Spanish_CI_AS NOT NULL,
        Apellido VARCHAR(50) COLLATE Modern_Spanish_CI_AS NOT NULL,
        Fecha_Nacimiento VARCHAR(15) NOT NULL,
        Tipo_Documento VARCHAR(10) NOT NULL,
        DNI INT NOT NULL,
        Sexo VARCHAR(9) NOT NULL CHECK (Sexo IN ('Masculino', 'Femenino')),
        Genero VARCHAR(10) NOT NULL,
        Telefono VARCHAR(20) NOT NULL,
        Nacionalidad VARCHAR(50) NOT NULL,
        Email VARCHAR(50) NOT NULL,
        Direccion VARCHAR(100) COLLATE Modern_Spanish_CI_AS NOT NULL,
        Localidad VARCHAR(75) COLLATE Modern_Spanish_CI_AS NOT NULL,
        Provincia VARCHAR(57) COLLATE Modern_Spanish_CI_AS NOT NULL
    );

    -- 2. Importar los datos del archivo CSV
    BULK INSERT clinicaImportar.PacienteTemporal
    FROM 'C:\Users\fede0\Desktop\BDDA\Tp-BDDA\Tp-BDDA\Dataset\Pacientes.csv'
    WITH
    (
        FIELDTERMINATOR = ';',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
    );

    -- 3. Insertar los datos en la tabla final
    WHILE (SELECT COUNT(*) FROM clinicaImportar.PacienteTemporal) > 0
    BEGIN
        DECLARE @Nombre VARCHAR(50);
        DECLARE @Apellido VARCHAR(50);
        DECLARE @Fecha_Nacimiento DATE;
        DECLARE @Tipo_Documento VARCHAR(10);
        DECLARE @DNI VARCHAR(20);
        DECLARE @Sexo CHAR(1);
        DECLARE @Genero VARCHAR(20);
        DECLARE @Telefono VARCHAR(20);
        DECLARE @Nacionalidad VARCHAR(50);
        DECLARE @Email VARCHAR(50);
        DECLARE @Direccion VARCHAR(100);
        DECLARE @Localidad VARCHAR(50);
        DECLARE @Provincia VARCHAR(50);

        SELECT TOP 1
            @Nombre = Nombre,
            @Apellido = Apellido,
            @Fecha_Nacimiento = Fecha_Nacimiento,
            @Tipo_Documento = Tipo_Documento,
            @DNI = DNI,
            @Sexo = Sexo,
            @Genero = Genero,
            @Telefono = Telefono,
            @Nacionalidad = Nacionalidad,
            @Email = Email,
            @Direccion = CONCAT(
                UPPER(LEFT(Direccion, 1)),
                LOWER(SUBSTRING(Direccion, 2, LEN(Direccion)-1))),
            @Localidad = CONCAT(
                UPPER(LEFT(Localidad, 1)),
                LOWER(SUBSTRING(Localidad, 2, LEN(Localidad)-1))),
            @Provincia = CONCAT(
                UPPER(LEFT(Provincia, 1)),
                LOWER(SUBSTRING(Provincia, 2, LEN(Provincia)-1)))
        FROM clinicaImportar.PacienteTemporal;

        INSERT INTO clinica.Paciente
        (
            Nombre,
            Apellido,
            Fecha_Nacimiento,
            Tipo_Documento,
            Numero_Documento,
            Sexo_Biologico,
            Genero,
            Nacionalidad,
            Mail,
            Telefono_Fijo,
            Telefono_Contacto_Alternativo,
            Telefono_Laboral,
            Fecha_Registro,
            Usuario_Actualizacion
        )
        VALUES
        (
            @Nombre,
            @Apellido,
            @Fecha_Nacimiento,
            @Tipo_Documento,
            @DNI,
            @Sexo,
            @Genero,
            @Nacionalidad,
            @Email,
            @Telefono,
            NULL,
            NULL,
            GETDATE(),
            'Importacion'
        );

        DELETE FROM clinicaImportar.PacienteTemporal
        WHERE Id_paciente = (SELECT TOP 1 Id_paciente FROM clinicaImportar.PacienteTemporal)        
    END;
END;
GO

DROP PROCEDURE IF EXISTS clinicaImportar.ImportarPacientes;

EXEC clinicaImportar.ImportarPacientes;


