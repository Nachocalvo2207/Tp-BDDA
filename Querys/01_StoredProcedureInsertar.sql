--Genere store procedures para manejar la inserción, modificado, borrado 
--(si corresponde, también debe decidir si determinadas entidades solo admitirán borrado lógico) de cada tabla. 
--Los nombres de los store procedures NO deben comenzar con “SP”.  

USE Com2900G03;
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'clinicaInsercion')
    EXEC('CREATE SCHEMA clinicaInsercion')
GO

CREATE OR ALTER PROCEDURE clinica.Insertar_Paciente
(
    @Id_Historia_Clinica INT,
    @Nombre VARCHAR(50),
    @Apellido VARCHAR(50),
    @Apellido_Materno VARCHAR(50),
    @Fecha_Nacimiento DATE,
    @Tipo_Documento VARCHAR(10),
    @Numero_Documento VARCHAR(20),
    @Sexo_Biologico CHAR(1),
    @Genero VARCHAR(20),
    @Nacionalidad VARCHAR(50),
    @Foto_Perfil VARCHAR(100),
    @Mail VARCHAR(50),
    @Telefono_Fijo VARCHAR(20),
    @Telefono_Contacto_Alternativo VARCHAR(20),
    @Telefono_Laboral VARCHAR(20),
    @Fecha_Registro DATETIME,
    @Fecha_Actualizacion DATETIME,
    @Usuario_Actualizacion VARCHAR(50)
)
AS
BEGIN
    INSERT INTO clinica.Paciente
    (
        Id_Historia_Clinica,
        Nombre,
        Apellido,
        Apellido_Materno,
        Fecha_Nacimiento,
        Tipo_Documento,
        Numero_Documento,
        Sexo_Biologico,
        Genero,
        Nacionalidad,
        Foto_Perfil,
        Mail,
        Telefono_Fijo,
        Telefono_Contacto_Alternativo,
        Telefono_Laboral,
        Fecha_Registro,
        Fecha_Actualizacion,
        Usuario_Actualizacion
    )
    VALUES
    (
        @Id_Historia_Clinica,
        @Nombre,
        @Apellido,
        @Apellido_Materno,
        @Fecha_Nacimiento,
        @Tipo_Documento,
        @Numero_Documento,
        @Sexo_Biologico,
        @Genero,
        @Nacionalidad,
        @Foto_Perfil,
        @Mail,
        @Telefono_Fijo,
        @Telefono_Contacto_Alternativo,
        @Telefono_Laboral,
        @Fecha_Registro,
        @Fecha_Actualizacion,
        @Usuario_Actualizacion
    );
END;
GO

--Insertar Usuario

CREATE OR ALTER PROCEDURE clinica.Insertar_Usuario
(
    @Id_Usuario INT,
    @Contraseña VARCHAR(50),
    @Fecha_Creacion DATETIME,
    @Id_Historia_Clinica INT
)
AS
BEGIN
    IF @Fecha_Creacion > GETDATE()
    BEGIN
        RAISERROR('La Fecha_Creacion debe ser menor o igual al dia de hoy', 1, 1);
        RETURN;
    END

    IF @Fecha_Creacion < '1900-01-01'
    BEGIN
        RAISERROR('La Fecha_Creacion debe ser mayor al 01/01/1900', 1, 1);
        RETURN;
    END

    IF LEN(@Contraseña) < 12 
    BEGIN
        RAISERROR('La contraseña debe tener al menos 12 caracteres', 1, 1);
        RETURN;
    END

    INSERT INTO clinica.Usuario
    (
        Id_Usuario,
        Contraseña,
        Fecha_Creacion,
        Id_Historia_Clinica
    )
    VALUES
    (
        @Id_Usuario,
        @Contraseña,
        @Fecha_Creacion,
        @Id_Historia_Clinica
    );
END;
GO

--Insertar Estudio

CREATE OR ALTER PROCEDURE clinica.Insertar_Estudio
(
    @Id_Estudio INT,
    @Fecha DATE,
    @Nombre_Estudio VARCHAR(50),
    @Autorizado INT,
    @Documento_Resultado VARCHAR(100),
    @Imagen_Resultado VARCHAR(100),
    @Id_Historia_Clinica INT
)
AS
BEGIN
    IF @Fecha_Creacion > GETDATE()
    BEGIN
        RAISERROR('La Fecha_Creacion debe ser menor o igual al dia de hoy', 1, 1);
        RETURN;
    END

    IF @Fecha_Creacion < '1900-01-01'
    BEGIN
        RAISERROR('La Fecha_Creacion debe ser mayor al 01/01/1900', 1, 1);
        RETURN;
    END
    INSERT INTO clinica.Estudio
    (
        Id_Estudio,
        Fecha,
        Nombre_Estudio,
        Autorizado,
        Documento_Resultado,
        Imagen_Resultado,
        Id_Historia_Clinica
    )
    VALUES
    (
        @Id_Estudio,
        @Fecha,
        @Nombre_Estudio,
        @Autorizado,
        @Documento_Resultado,
        @Imagen_Resultado,
        @Id_Historia_Clinica
    );
END;
GO

--Insertar Cobertura

CREATE OR ALTER PROCEDURE clinica.Insertar_Cobertura
(
    @Id_Cobertura INT,
    @Imagen_Credencial VARCHAR(100),
    @Nro_Socio VARCHAR(50),
    @Fecha_Registro DATETIME,
    @Id_Prestador INT
)
AS
BEGIN
    IF @Fecha_Creacion > GETDATE()
    BEGIN
        RAISERROR('La Fecha_Creacion debe ser menor o igual al dia de hoy', 1, 1);
        RETURN;
    END

    IF @Fecha_Creacion < '1900-01-01'
    BEGIN
        RAISERROR('La Fecha_Creacion debe ser mayor al 01/01/1900', 1, 1);
        RETURN;
    END
    INSERT INTO clinica.Cobertura
    (
        Id_Cobertura,
        Imagen_Credencial,
        Nro_Socio,
        Fecha_Registro,
        Id_Prestador
    )
    VALUES
    (
        @Id_Cobertura,
        @Imagen_Credencial,
        @Nro_Socio,
        @Fecha_Registro,
        @Id_Prestador
    );
END;
GO

--Insertar Prestador

CREATE OR ALTER PROCEDURE clinica.Insertar_Prestador
(
    @Id_Prestador INT,
    @Nombre_Prestador VARCHAR(50),
    @Plan_Prestador VARCHAR(50),
    @Id_Cobertura INT
)
AS
BEGIN
IF @Nombre_Prestador NOT IN ('Union Personal', 'Osecac', 'Medicus', 'OSPOCE', 'OSDE')
    BEGIN
        RAISERROR('Nombre de prestador invalido', 1, 1);
        RETURN;
    END
    INSERT INTO clinica.Prestador
    (
        Id_Prestador,
        Nombre_Prestador,
        Plan_Prestador
    )
    VALUES
    (
        @Id_Prestador,
        @Nombre_Prestador,
        @Plan_Prestador
    );
END;
GO

--Insertar Domicilio

CREATE OR ALTER PROCEDURE clinica.Insertar_Domicilio
(
    @Id_Domicilio INT,
    @Calle VARCHAR(50),
    @Numero VARCHAR(50),
    @Piso VARCHAR(50),
    @Departamento VARCHAR(50),
    @Codigo_Postal VARCHAR(50),
    @Pais VARCHAR(50),
    @Provincia VARCHAR(50),
    @Localidad VARCHAR(50)
)
AS
BEGIN
    INSERT INTO clinica.Domicilio
    (
        Id_Domicilio,
        Calle,
        Numero,
        Piso,
        Departamento,
        Codigo_Postal,
        Pais,
        Provincia,
        Localidad
    )
    VALUES
    (
        @Id_Domicilio,
        @Calle,
        @Numero,
        @Piso,
        @Departamento,
        @Codigo_Postal,
        @Pais,
        @Provincia,
        @Localidad
    );
END;
GO

--Insertar Reserva Turno Medico

CREATE OR ALTER PROCEDURE clinica.Insertar_Reserva_Turno_Medico
(
    @Id_Turno INT,
    @Fecha DATE,
    @Hora TIME,
    @Id_Medico INT,
    @Id_Especialidad INT,
    @Id_Direccion_Atencion INT,
    @Id_Estado_Turno INT,
    @Id_Tipo_Turno INT
)
AS
BEGIN
    INSERT INTO clinica.Reserva_Turno_Medico
    (
        Id_Turno,
        Fecha,
        Hora,
        Id_Medico,
        Id_Especialidad,
        Id_Direccion_Atencion,
        Id_Estado_Turno,
        Id_Tipo_Turno
    )
    VALUES
    (
        @Id_Turno,
        @Fecha,
        @Hora,
        @Id_Medico,
        @Id_Especialidad,
        @Id_Direccion_Atencion,
        @Id_Estado_Turno,
        @Id_Tipo_Turno
    );
END;
GO

--Insertar Estado Turno

CREATE OR ALTER PROCEDURE clinica.Insertar_Estado_Turno
(
    @Id_Estado INT,
    @Nombre_Estado VARCHAR(50)
)
AS
BEGIN
    INSERT INTO clinica.Estado_Turno
    (
        Id_Estado,
        Nombre_Estado
    )
    VALUES
    (
        @Id_Estado,
        @Nombre_Estado
    );
END;
GO

--Insertar Tipo Turno

CREATE OR ALTER PROCEDURE clinica.Insertar_Tipo_Turno
(
    @Id_Tipo_Turno INT,
    @Nombre_Tipo_Turno VARCHAR(50)
)
AS
BEGIN
    INSERT INTO clinica.Tipo_Turno
    (
        Id_Tipo_Turno,
        Nombre_Tipo_Turno
    )
    VALUES
    (
        @Id_Tipo_Turno,
        @Nombre_Tipo_Turno
    );
END;
GO

--Insertar Dias Por Sede

CREATE OR ALTER PROCEDURE clinica.Insertar_Dias_Por_Sede
(
    @Id_Sede INT,
    @Id_Medico INT,
    @Dia VARCHAR(20),
    @Hora_Inicio TIME
)
AS
BEGIN
    INSERT INTO clinica.Dias_Por_Sede
    (
        Id_Sede,
        Id_Medico,
        Dia,
        Hora_Inicio
    )
    VALUES
    (
        @Id_Sede,
        @Id_Medico,
        @Dia,
        @Hora_Inicio
    );
END;
GO

--Insertar Medico

CREATE OR ALTER PROCEDURE clinica.Insertar_Medico
(
    @Id_Medico INT,
    @Nombre VARCHAR(50),
    @Apellido VARCHAR(50),
    @Nro_Matricula VARCHAR(50)
)
AS
BEGIN
    INSERT INTO clinica.Medico
    (
        Id_Medico,
        Nombre,
        Apellido,
        Nro_Matricula
    )
    VALUES
    (
        @Id_Medico,
        @Nombre,
        @Apellido,
        @Nro_Matricula
    );
END;
GO

--Insertar Especialidad

CREATE OR ALTER PROCEDURE clinica.Insertar_Especialidad
(
    @Id_Especialidad INT,
    @Nombre_Especialidad VARCHAR(50)
)
AS
BEGIN
    IF @Nombre_Especialidad NOT IN ('CLINICA MEDICA', 'MEDICINA FAMILIAR', 'ALERGIA', 
	'CARDIOLOGIA', 'DERMATOLOGIA', 'ENDOCRINLOGIA', 'FONOAUDIOLOGIA', 'GASTROENTEROLOGIA', 
	'GINECOLOGIA', 'HEPATOLOGÍA', 'KINESIOLOGIA', 'NEUROLOGIA', 'NUTRICION', 'OBSTETRICIA', 
	'OFTALMOLOGIA', 'TRAUMATOLOGIA', 'UROLOGIA')
    BEGIN
        RAISERROR('Nombre de especialidad invalido', 1, 1);
        RETURN;
    END

    INSERT INTO clinica.Especialidad
    (
        Id_Especialidad,
        Nombre_Especialidad
    )
    VALUES
    (
        @Id_Especialidad,
        @Nombre_Especialidad
    );
END;
GO

--Insertar Sede De Atencion

CREATE OR ALTER PROCEDURE clinica.Insertar_Sede_De_Atencion
(
    @Id_Sede INT,
    @Nombre_Sede VARCHAR(50),
    @Direccion VARCHAR(50)
)
AS
BEGIN
    INSERT INTO clinica.Sede_De_Atencion
    (
        Id_Sede,
        Nombre_Sede,
        Direccion
    )
    VALUES
    (
        @Id_Sede,
        @Nombre_Sede,
        @Direccion
    );
END;
GO