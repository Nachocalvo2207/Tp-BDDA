CREATE OR ALTER PROCEDURE Clinica.ImportarEstudios
    @rutaArchivo NVARCHAR(MAX)
AS
BEGIN

    DROP TABLE IF EXISTS clinica.tempEstudio
    CREATE TABLE clinica.tempEstudio
    (
        Id_Estudio VARCHAR(50) PRIMARY KEY,
        Area VARCHAR(50),
        Nombre_Estudio VARCHAR(50),
        Prestador VARCHAR(50),
        Plan_ VARCHAR(50),
        Cobertura INT,
        Costo INT,
        Autorizacion VARCHAR(50),
    )

    DECLARE @sql NVARCHAR(MAX) = 
    INSERT INTO clinica.tempEstudio
    (
        Id_Estudio,
        Area,
        Nombre_Estudio,
        Prestador,
        Plan_,
        Cobertura,
        Costo,
        Autorizacion
    )
    
    SELECT
        Id_Estudio,
        Area,
        Nombre_Estudio,
        Prestador,
        Plan_,
        Cobertura,
        Costo,
        Autorizacion
    
    FROM OPENROWSET
    (
        BULK''' + @rutaArchivo + ''',
        Single_Clob
    )
    AS Estudios
    CROSS APPLY OPENJSON(BulkColumn)
    WITH
    (
        Id_Estudio VARCHAR(50) ''$._id."$oid"'',
        Area VARCHAR(50) ''$.Area'',
        Nombre_Estudio VARCHAR(50) ''$.Estudio'',
        Prestador VARCHAR(50) ''$.Prestador'',
        Plan_ VARCHAR(50) ''$.Plan'',
        Cobertura INT ''$."Porcentaje Cobertura"'',
        Costo INT ''$.Costo'',
        Autorizacion VARCHAR(50) ''$."Requiere Autorizacion"''
    )'

    EXEC sp_executesql @sql
END
GO