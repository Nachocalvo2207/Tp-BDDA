--la fecha de entrega, número de grupo, nombre de la materia, nombres y DNI de los alumnos.  

/*--------------------------------------------------------------
* Fecha de entrega:

* NUMERO DE GRUPO: 3
* NOMBRE DE LA MATERIA: Base de Datos Aplicada
* NOMBRE Y DNI DE LOS ALUMNOS: 
    1. Calvo Ignacio, 411162300
    2. Rossendy Federico, xxxxxxxxx
    3. Veliz Nicolas, xxxxxxxx
--------------------------------------------------------------*/


CREATE DATABASE Com2900G03;
GO

USE Com2900G03;
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


--Tabla Cobertura(id cobertura, imagen de la credencial, nro de socio, fecha de registro)
--Una cobertura puede tener un solo paciente, un paciente pude tener una cobertura

CREATE TABLE clinica.Cobertura
(
    Id_Cobertura INT PRIMARY KEY,
    Imagen_Credencial VARCHAR(100) NOT NULL,
    Nro_Socio VARCHAR(50) NOT NULL,
    Fecha_Registro DATETIME NOT NULL,
    Id_Historia_Clinica INT NOT NULL,
    FOREIGN KEY (Id_Historia_Clinica) REFERENCES clinica.Paciente(Id_Historia_Clinica)
);

--Tabla Prestador(Id prestador, nombre prestador, plan prestador)
--Un prestador tiene una cobertura, una cobertura tiene un prestador

CREATE TABLE clinica.Prestador
(
    Id_Prestador INT PRIMARY KEY,
    Nombre_Prestador VARCHAR(50) NOT NULL,
    Plan_Prestador VARCHAR(50) NOT NULL,
    Id_Cobertura INT NOT NULL,
    FOREIGN KEY (Id_Cobertura) REFERENCES clinica.Cobertura(Id_Cobertura)
);

--Tabla Domicilio(id domicilio, calle, numero, piso, departamento, codigo postal, pais, provincia, localidad)
--Un domicilio puede tener un paciente, un paciente puede tener un domicilio

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

--Tabla reserva de turno medico(id turno, fecha, hora, id_medico, id_especialidad, id direccion atencion, id estado turno, id tipo turno)

CREATE TABLE clinica.Reserva_Turno_Medico
(
    Id_Turno INT PRIMARY KEY,
    Fecha DATE NOT NULL,
    Hora TIME NOT NULL,
    Id_Medico INT NOT NULL,
    Id_Especialidad INT NOT NULL,
    Id_Direccion_Atencion INT NOT NULL,
    Id_Estado_Turno INT NOT NULL,
    Id_Tipo_Turno INT NOT NULL
);

--Tabla estado turno(id estado, nombre estado)

CREATE TABLE clinica.Estado_Turno
(
    Id_Estado INT PRIMARY KEY,
    Nombre_Estado VARCHAR(50) NOT NULL
);

--Tabla tipo turno(id tipo turno, nombre tipo turno)
CREATE TABLE clinica.Tipo_Turno
(
    Id_Tipo_Turno INT PRIMARY KEY,
    Nombre_Tipo_Turno VARCHAR(50) NOT NULL
);

--Tabla dias por sede(id_sede, id medico, dia, hora inicio)

CREATE TABLE clinica.Dias_Por_Sede
(
    Id_Sede INT PRIMARY KEY,
    Id_Medico INT NOT NULL,
    Dia VARCHAR(20) NOT NULL,
    Hora_Inicio TIME NOT NULL
);

--Tabla medico(id medico, nombre, apellido, nro matricula)

CREATE TABLE clinica.Medico
(
    Id_Medico INT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    Nro_Matricula VARCHAR(50) NOT NULL
);

--Tabla especialidad(id especialidad, nombre especialidad)

CREATE TABLE clinica.Especialidad
(
    Id_Especialidad INT PRIMARY KEY,
    Nombre_Especialidad VARCHAR(50) NOT NULL
);


--Tabla sedes de atencion (id sede, nombre de sede, direccion)
-- N a 1 con la Dias_Por_Sede

CREATE TABLE clinica.Sede_De_Atencion
{
    Id_Sede INT PRIMARY KEY,
    Nombre_Sede VARCHAR(50) NOT NULL,
    Direccion VARCHAR(50) NOT NULL
};


--Genere store procedures para manejar la inserción, modificado, borrado (si corresponde, también debe decidir si determinadas entidades solo admitirán borrado lógico) de cada tabla. Los nombres de los store procedures NO deben comenzar con “SP”.  



--SP_Insertar_Paciente

CREATE PROCEDURE 