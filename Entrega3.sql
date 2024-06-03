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
    Telefono_Contacto_Alternativo VARCHAR(20),
    Telefono_Laboral VARCHAR(20),
    Fecha_Registro DATETIME NOT NULL,
    Fecha_Actualizacion DATETIME,
    Usuario_Actualizacion VARCHAR(50) NOT NULL
);

--Tabla usuario (id usuario, contraseña, fecha de creacion)
--Un usuario puede tener un paciente, un paciente puede tener un usuario

--Tabla usuario (ID usuario, contraseña, fecha de creación)
--Un usuario puede tener un paciente, un paciente puede tener un usuario

CREATE TABLE clinica.Usuario
(
    Id_Usuario INT PRIMARY KEY,
    Contraseña VARCHAR(50) NOT NULL,
    Fecha_Creacion DATETIME NOT NULL,
    Id_Historia_Clinica INT NOT NULL,
    FOREIGN KEY (Id_Historia_Clinica) REFERENCES clinica.Paciente(Id_Historia_Clinica)
);

--Tabla estudio (ID estudio, fecha, nombre estudio, autorizado, documento resultado, imagen resultado)
--Un estudio puede tener un solo paciente, pero un paciente puede tener varios estudios

CREATE TABLE clinica.Estudio
(
    Id_Estudio INT PRIMARY KEY,
    Fecha DATE NOT NULL,
    Nombre_Estudio VARCHAR(50) NOT NULL,
    Autorizado INT NOT NULL,
    Documento_Resultado VARCHAR(100) NOT NULL,
    Imagen_Resultado VARCHAR(100) NOT NULL,
    Id_Historia_Clinica INT NOT NULL,
    FOREIGN KEY (Id_Historia_Clinica) REFERENCES clinica.Paciente(Id_Historia_Clinica)
);  

CREATE TABLE clinica.Sede_De_Atencion
{
    Id_Sede INT PRIMARY KEY
    ,Nombre_De_Sede VARCHAR(50) NOT NULL
    ,Direccion VARCHAR(100) NOT NULL
};
}