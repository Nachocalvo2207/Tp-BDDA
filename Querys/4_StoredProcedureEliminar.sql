--Genere store procedures para manejar la inserción, modificado, borrado 
--(si corresponde, también debe decidir si determinadas entidades solo admitirán borrado lógico) de cada tabla. 
--Los nombres de los store procedures NO deben comenzar con “SP”.  

--Eliminar Paciente

USE Com2900G03;

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'clinicaEliminar')
    EXEC('CREATE SCHEMA clinicaEliminar')
GO

--Eliminar Paciente

CREATE OR ALTER PROCEDURE clinicaEliminar.Eliminar_Paciente
(
    @Id_Historia_Clinica INT
)
AS
BEGIN
    DELETE FROM clinica.Paciente
    WHERE Id_Historia_Clinica = @Id_Historia_Clinica;
END;
GO

--Eliminar Usuario

CREATE OR ALTER PROCEDURE clinicaEliminar.Eliminar_Usuario
(
    @Id_Usuario INT
)
AS
BEGIN
-- Creo LOG para que quede registro de usuarios eliminados:
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'UsuarioEliminado' AND TABLE_SCHEMA = 'clinica')
    BEGIN
        CREATE TABLE clinica.UsuarioEliminado
        (
            Id_Usuario INT PRIMARY KEY,
            Contraseña VARCHAR(50) NOT NULL,
            Fecha_Creacion DATETIME NOT NULL,
            Fecha_Eliminacion DATETIME DEFAULT GETDATE(),
            Id_Historia_Clinica INT NOT NULL,
            FOREIGN KEY (Id_Historia_Clinica) REFERENCES clinica.Paciente(Id_Historia_Clinica)
        );
    END

    INSERT INTO clinica.UsuarioEliminado (Id_Usuario, Contraseña, Fecha_Creacion, Id_Historia_Clinica)
    SELECT Id_Usuario, Contraseña, Fecha_Creacion, Id_Historia_Clinica FROM clinica.Usuario
    WHERE Id_Usuario = @Id_Usuario;

    DELETE FROM clinica.Usuario
    WHERE Id_Usuario = @Id_Usuario;
END
GO

--Eliminar Estudio

CREATE OR ALTER PROCEDURE clinicaEliminar.Eliminar_Estudio
(
    @Id_Estudio INT
)
AS
BEGIN
    DELETE FROM clinica.Estudio
    WHERE Id_Estudio = @Id_Estudio;
END;
GO

--Eliminar Cobertura

CREATE OR ALTER PROCEDURE clinicaEliminar.Eliminar_Cobertura
(
    @Id_Cobertura INT
)
AS
BEGIN
    DELETE FROM clinica.Cobertura
    WHERE Id_Cobertura = @Id_Cobertura;
END;
GO

--Eliminar Prestador

CREATE OR ALTER PROCEDURE clinicaEliminar.Eliminar_Prestador
(
    @Id_Prestador INT
)
AS
BEGIN
    DELETE FROM clinica.Prestador
    WHERE Id_Prestador = @Id_Prestador;
END;
GO

--Eliminar Domicilio

CREATE OR ALTER PROCEDURE clinicaEliminar.Eliminar_Domicilio
(
    @Id_Domicilio INT
)
AS
BEGIN
    DELETE FROM clinica.Domicilio
    WHERE Id_Domicilio = @Id_Domicilio;
END;
GO

--Eliminar Reserva Turno Medico

CREATE OR ALTER PROCEDURE clinicaEliminar.Eliminar_Reserva_Turno_Medico
(
    @Id_Turno INT
)
AS
BEGIN
    DELETE FROM clinica.Reserva_Turno_Medico
    WHERE Id_Turno = @Id_Turno;
END;
GO

--Eliminar Estado Turno

CREATE OR ALTER PROCEDURE clinicaEliminar.Eliminar_Estado_Turno
(
    @Id_Estado INT
)
AS
BEGIN
    DELETE FROM clinica.Estado_Turno
    WHERE Id_Estado = @Id_Estado;
END;
GO

--Eliminar Tipo Turno

CREATE OR ALTER PROCEDURE clinicaEliminar.Eliminar_Tipo_Turno
(
    @Id_Tipo_Turno INT
)
AS
BEGIN
    DELETE FROM clinica.Tipo_Turno
    WHERE Id_Tipo_Turno = @Id_Tipo_Turno;
END;
GO

--Eliminar Dias Por Sede

CREATE OR ALTER PROCEDURE clinicaEliminar.Eliminar_Dias_Por_Sede
(
    @Id_Sede INT
)
AS
BEGIN
    DELETE FROM clinica.Dias_Por_Sede
    WHERE Id_Sede = @Id_Sede;
END;
GO

--Eliminar Medico

CREATE OR ALTER PROCEDURE clinicaEliminar.Eliminar_Medico
(
    @Id_Medico INT
)
AS
BEGIN
    DELETE FROM clinica.Medico
    WHERE Id_Medico = @Id_Medico;
END;
GO

--Eliminar Especialidad

CREATE OR ALTER PROCEDURE clinicaEliminar.Eliminar_Especialidad
(
    @Id_Especialidad INT
)
AS
BEGIN
    DELETE FROM clinica.Especialidad
    WHERE Id_Especialidad = @Id_Especialidad;
END;
GO

--Eliminar Sede De Atencion

CREATE OR ALTER PROCEDURE clinicaEliminar.Eliminar_Sede_De_Atencion
(
    @Id_Sede INT
)
AS
BEGIN
    DELETE FROM clinica.Sede_De_Atencion
    WHERE Id_Sede = @Id_Sede;
END;
GO