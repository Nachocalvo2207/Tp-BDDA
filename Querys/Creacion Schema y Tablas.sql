--la fecha de entrega, número de grupo, nombre de la materia, nombres y DNI de los alumnos.  

/*--------------------------------------------------------------
* Fecha de entrega:

* NUMERO DE GRUPO: 3
* NOMBRE DE LA MATERIA: Base de Datos Aplicada
* NOMBRE Y DNI DE LOS ALUMNOS: 
    1. Calvo Ignacio, 411162300
    2. Rossendy Federico, 37804899
    3. Veliz Nicolas, xxxxxxxx
--------------------------------------------------------------*/



-- Se crea la base de datos:
IF NOT EXISTS(SELECT name FROM master.dbo.sysdatabases WHERE name = 'Com2900G03') 
BEGIN 
    CREATE DATABASE Com2900G03 COLLATE Modern_Spanish_CI_AS;
END

USE Com2900G03
GO


--Se crea el SCHEMA:
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Clinica')
BEGIN
    EXEC('CREATE SCHEMA Clinica')
END
GO


--Se crean las tablas:
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Paciente' AND TABLE_SCHEMA = 'clinica')
BEGIN
    CREATE TABLE clinica.Paciente
    (
        Id_Historia_Clinica INT IDENTITY(1,1) PRIMARY KEY,
        Nombre VARCHAR(50) NOT NULL,
        Apellido VARCHAR(50) NOT NULL,
        Apellido_Materno VARCHAR(50),
        Fecha_Nacimiento DATE NOT NULL,
        Tipo_Documento VARCHAR(10) NOT NULL,
        Numero_Documento INT NOT NULL,
        Sexo_Biologico VARCHAR(10) NOT NULL,
        Genero VARCHAR(20) NOT NULL,
        Nacionalidad VARCHAR(50) NOT NULL,
        Foto_Perfil VARCHAR(100),
        Mail VARCHAR(50) NOT NULL,
        Telefono_Fijo VARCHAR(20),
        Telefono_Contacto_Alternativo VARCHAR(20),
        Telefono_Laboral VARCHAR(20),
        Fecha_Registro DATE DEFAULT GETDATE(),
        Fecha_Actualizacion DATETIME,
        Usuario_Actualizacion VARCHAR(50)
    );
END



IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Usuario' AND TABLE_SCHEMA = 'clinica')
BEGIN
    CREATE TABLE clinica.Usuario
    (
        Id_Usuario INT PRIMARY KEY,
        Contraseña VARCHAR(50) NOT NULL,
        Fecha_Creacion DATE DEFAULT GETDATE(),
        Id_Historia_Clinica INT NOT NULL,
        FOREIGN KEY (Id_Historia_Clinica) REFERENCES clinica.Paciente(Id_Historia_Clinica)
    );
END


IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Estudio' AND TABLE_SCHEMA = 'clinica')
BEGIN
    CREATE TABLE clinica.Estudio
    (
        Id_Estudio INT PRIMARY KEY,
        Fecha DATE NOT NULL,
        Nombre_Estudio VARCHAR(50) NOT NULL,
        Autorizado INT NOT NULL,
        Documento_Resultado VARCHAR(100) NOT NULL,
        Imagen_Resultado VARCHAR(100),
        Id_Historia_Clinica INT NOT NULL,
        FOREIGN KEY (Id_Historia_Clinica) REFERENCES clinica.Paciente(Id_Historia_Clinica)
    );
END



IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Cobertura' AND TABLE_SCHEMA = 'clinica')
BEGIN
    CREATE TABLE clinica.Cobertura
    (
        Id_Cobertura INT IDENTITY(1,1) PRIMARY KEY,
        Imagen_Credencial VARCHAR(100),
        Nro_Socio VARCHAR(50) NOT NULL,
        Fecha_Registro DATETIME NOT NULL,
        Id_Historia_Clinica INT NOT NULL,
        FOREIGN KEY (Id_Historia_Clinica) REFERENCES clinica.Paciente(Id_Historia_Clinica)
    );
END



IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Prestador' AND TABLE_SCHEMA = 'clinica')
BEGIN
    CREATE TABLE clinica.Prestador
    (
        Id_Prestador INT PRIMARY KEY,
        Nombre_Prestador VARCHAR(50) NOT NULL,
        Plan_Prestador VARCHAR(50) NOT NULL,
        Id_Cobertura INT NOT NULL,
        FOREIGN KEY (Id_Cobertura) REFERENCES clinica.Cobertura(Id_Cobertura)
    );
END



IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Domicilio' AND TABLE_SCHEMA = 'clinica')
BEGIN
    CREATE TABLE clinica.Domicilio
    (
        Id_Domicilio INT PRIMARY KEY,
        Calle VARCHAR(50) NOT NULL,
        Numero VARCHAR(50) NOT NULL,
        Piso VARCHAR(50),
        Departamento VARCHAR(50),
        Codigo_Postal VARCHAR(50) NOT NULL,
        Pais VARCHAR(50) NOT NULL,
        Provincia VARCHAR(50) NOT NULL,
        Localidad VARCHAR(50) NOT NULL,
        Id_Historia_Clinica INT NOT NULL,
        FOREIGN KEY (Id_Historia_Clinica) REFERENCES clinica.Paciente(Id_Historia_Clinica)
    );
END



IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Reserva_Turno_Medico' AND TABLE_SCHEMA = 'clinica')
BEGIN
    CREATE TABLE clinica.Reserva_Turno_Medico
    (
        Id_Turno INT PRIMARY KEY,
        Fecha DATE NOT NULL,
        Hora TIME NOT NULL,
        Id_Medico INT NOT NULL,
        Id_Especialidad INT NOT NULL,
        Id_Direccion_Atencion INT NOT NULL,
        Id_Estado_Turno INT NOT NULL,
        Id_Tipo_Turno INT NOT NULL,
        FOREIGN KEY (Id_Medico) REFERENCES clinica.Medico(Id_Medico),
        FOREIGN KEY (Id_Especialidad) REFERENCES clinica.Especialidad(Id_Especialidad),
        FOREIGN KEY (Id_Direccion_Atencion) REFERENCES clinica.Sede_De_Atencion(Id_Sede),
        FOREIGN KEY (Id_Estado_Turno) REFERENCES clinica.Estado_Turno(Id_Estado),
        FOREIGN KEY (Id_Tipo_Turno) REFERENCES clinica.Tipo_Turno(Id_Tipo_Turno)
    );
END


IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Estado_Turno' AND TABLE_SCHEMA = 'clinica')
BEGIN
    CREATE TABLE clinica.Estado_Turno
    (
        Id_Estado INT PRIMARY KEY,
        Nombre_Estado VARCHAR(50) NOT NULL
    );
END


IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Tipo_Turno' AND TABLE_SCHEMA = 'clinica')
BEGIN
    CREATE TABLE clinica.Tipo_Turno
    (
        Id_Tipo_Turno INT PRIMARY KEY,
        Nombre_Tipo_Turno VARCHAR(50) NOT NULL
    );
END


IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Dias_Por_Sede' AND TABLE_SCHEMA = 'clinica')
BEGIN
    CREATE TABLE clinica.Dias_Por_Sede
    (
        Id_Sede INT PRIMARY KEY,
        Id_Medico INT NOT NULL,
        Dia VARCHAR(20) NOT NULL,
        Hora_Inicio TIME NOT NULL
        FOREIGN KEY (Id_Medico) REFERENCES clinica.Medico(Id_Medico),
        FOREIGN KEY (Id_Sede) REFERENCES clinica.Sede_De_Atencion(Id_Sede)
    );
END


IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Medico' AND TABLE_SCHEMA = 'clinica')
BEGIN
    CREATE TABLE clinica.Medico
    (
        Id_Medico INT IDENTITY(1,1) PRIMARY KEY,
        Nombre VARCHAR(50) NOT NULL,
        Apellido VARCHAR(50) NOT NULL,
        Nro_Matricula INTEGER NOT NULL,
        Id_Especialidad INT,
        FOREIGN KEY (Id_Especialidad) REFERENCES clinica.Especialidad(Id_Especialidad)
    );
END


IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Especialidad' AND TABLE_SCHEMA = 'clinica')
BEGIN
    CREATE TABLE clinica.Especialidad
    (
        Id_Especialidad INT IDENTITY(1,1)PRIMARY KEY,
        Nombre_Especialidad VARCHAR(50) NOT NULL
    );
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Sede_De_Atencion' AND TABLE_SCHEMA = 'clinica')
BEGIN
    CREATE TABLE clinica.Sede_De_Atencion
    (
        Id_Sede INT IDENTITY(1,1) PRIMARY KEY,
        Nombre_Sede VARCHAR(50) NOT NULL,
        Direccion VARCHAR(50) NOT NULL
    );
END
