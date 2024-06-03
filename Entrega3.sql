-- Microsoft SQL Server query

CREATE DATABASE BD_Clinica;
GO

USE BD_Clinica;
GO

CREATE SCHEMA Clinica;
GO

--Tabla paciente (ID historia clinica, nombre, apellido, apellido materno, fecha de nacimiento, tipo documento, numero documento, 
--sexo biologico, genero, nacionalidad, foto de perfil, mail, telefono fijo, telefono de contacto alternativo, telefono laboral, 
--fecha de registro, fecha de actualizacion, usuario actualizacion)

CREATE TABLE clinica.Paciente
(
    Id_Historia_Clinica INT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    Apellido_Materno VARCHAR(50),
    Fecha_Nacimiento DATE NOT NULL,
    Tipo_Documento VARCHAR(10) NOT NULL,
    Numero_Documento VARCHAR(20) NOT NULL,
    Sexo_Biologico CHAR(1) NOT NULL,
    Genero VARCHAR(20) NOT NULL,
    Nacionalidad VARCHAR(50) NOT NULL,
    Foto_Perfil VARCHAR(100),
    Mail VARCHAR(50) NOT NULL,
    Telefono_Fijo VARCHAR(20),
    Telefono_Contacto_Alternativo VARCHAR(20) NOT NULL,
    Telefono_Laboral VARCHAR(20) NOT NULL,
    Fecha_Registro DATETIME NOT NULL,
    Fecha_Actualizacion DATETIME NOT NULL,
    Usuario_Actualizacion VARCHAR(50) NOT NULL
);

--Tabla usuario (id usuario, contraseña, fecha de creacion)
--Un usuario puede tener un paciente, un paciente puede tener un usuario

CREATE TABLE clinica.Usuario
(
    idUsuario INT PRIMARY KEY,
    contraseña VARCHAR(50) NOT NULL,
    fechaCreacion DATETIME NOT NULL,
    idHistoriaClinica INT NOT NULL,
    FOREIGN KEY (idHistoriaClinica) REFERENCES clinica.Paciente(idHistoriaClinica)
);

--Tabla estudio(id estudio, fecha, nombre estudio, autoriazado, documento resultado, imagen resultado)
--Un estudio puede tener un solo paciente, pero un paciente puede tener varios estudios

CREATE TABLE clinica.Estudio
(
    idEstudio INT PRIMARY KEY,
    fecha DATE NOT NULL,
    nombreEstudio VARCHAR(50) NOT NULL,
    autorizado BIT NOT NULL,
    documentoResultado VARCHAR(100) NOT NULL,
    imagenResultado VARCHAR(100) NOT NULL,
    idHistoriaClinica INT NOT NULL,
    FOREIGN KEY (idHistoriaClinica) REFERENCES clinica.Paciente(idHistoriaClinica)
);  
