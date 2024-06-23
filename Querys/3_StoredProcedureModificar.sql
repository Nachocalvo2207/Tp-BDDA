USE Com2900G03;
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'clinicaModificacion')
    EXEC('CREATE SCHEMA clinicaModificacion')
GO

--Modificar Paciente

CREATE OR ALTER PROCEDURE clinicaModificacion.Modificar_Paciente
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
    UPDATE clinica.Paciente
    SET
        Nombre = @Nombre,
        Apellido = @Apellido,
        Apellido_Materno = @Apellido_Materno,
        Fecha_Nacimiento = @Fecha_Nacimiento,
        Tipo_Documento = @Tipo_Documento,
        Numero_Documento = @Numero_Documento,
        Sexo_Biologico = @Sexo_Biologico,
        Genero = @Genero,
        Nacionalidad = @Nacionalidad,
        Foto_Perfil = @Foto_Perfil,
        Mail = @Mail,
        Telefono_Fijo = @Telefono_Fijo,
        Telefono_Contacto_Alternativo = @Telefono_Contacto_Alternativo,
        Telefono_Laboral = @Telefono_Laboral,
        Fecha_Registro = @Fecha_Registro,
        Fecha_Actualizacion = @Fecha_Actualizacion,
        Usuario_Actualizacion = @Usuario_Actualizacion
    WHERE Id_Historia_Clinica = @Id_Historia_Clinica;
END;
GO

--Modificar Usuario

CREATE OR ALTER PROCEDURE clinicaModificacion.Modificar_Usuario
(
    @Id_Usuario INT,
    @Contraseña VARCHAR(50),
    @Fecha_Creacion DATETIME,
    @Id_Historia_Clinica INT
)
AS
BEGIN
    UPDATE clinica.Usuario
    SET
        Contraseña = @Contraseña,
        Fecha_Creacion = @Fecha_Creacion,
        Id_Historia_Clinica = @Id_Historia_Clinica
    WHERE Id_Usuario = @Id_Usuario;
END;
GO

--Modificar Estudio

CREATE OR ALTER PROCEDURE clinicaModificacion.Modificar_Estudio
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
    UPDATE clinica.Estudio
    SET
        Fecha = @Fecha,
        Nombre_Estudio = @Nombre_Estudio,
        Autorizado = @Autorizado,
        Documento_Resultado = @Documento_Resultado,
        Imagen_Resultado = @Imagen_Resultado
    WHERE Id_Estudio = @Id_Estudio;
END;
GO

--Modificar Cobertura

CREATE OR ALTER PROCEDURE clinicaModificacion.Modificar_Cobertura
(
    @Id_Cobertura INT,
    @Imagen_Credencial VARCHAR(100),
    @Nro_Socio VARCHAR(50),
    @Fecha_Registro DATETIME,
    @Id_Historia_Clinica INT
)
AS
BEGIN
    UPDATE clinica.Cobertura
    SET
        Imagen_Credencial = @Imagen_Credencial,
        Nro_Socio = @Nro_Socio,
        Fecha_Registro = @Fecha_Registro
    WHERE Id_Cobertura = @Id_Cobertura;
END;
GO

--Modificar Prestador

CREATE OR ALTER PROCEDURE clinicaModificacion.Modificar_Prestador
(
    @Id_Prestador INT,
    @Nombre_Prestador VARCHAR(50),
    @Plan_Prestador VARCHAR(50),
    @Id_Cobertura INT
)
AS
BEGIN
    UPDATE clinica.Prestador
    SET
        Nombre_Prestador = @Nombre_Prestador,
        Plan_Prestador = @Plan_Prestador
    WHERE Id_Prestador = @Id_Prestador;
END;
GO

--Modificar Domicilio

CREATE OR ALTER PROCEDURE clinicaModificacion.Modificar_Domicilio
(
    @Id_Domicilio INT,
    @Calle VARCHAR(50),
    @Numero VARCHAR(50),
    @Piso VARCHAR(50),
    @Departamento VARCHAR(50),
    @Codigo_Postal VARCHAR(50),
    @Pais VARCHAR(50),
    @Provincia VARCHAR(50),
    @Localidad VARCHAR(50),
    @Id_Historia_Clinica INT
)
AS
BEGIN
    UPDATE clinica.Domicilio
    SET
        Calle = @Calle,
        Numero = @Numero,
        Piso = @Piso,
        Departamento = @Departamento,
        Codigo_Postal = @Codigo_Postal,
        Pais = @Pais,
        Provincia = @Provincia,
        Localidad = @Localidad
    WHERE Id_Domicilio = @Id_Domicilio;
END;
GO

--Modificar Reserva_Turno_Medico

CREATE OR ALTER PROCEDURE clinicaModificacion.Modificar_Reserva_Turno_Medico
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
    UPDATE clinica.Reserva_Turno_Medico
    SET
        Fecha = @Fecha,
        Hora = @Hora,
        Id_Medico = @Id_Medico,
        Id_Especialidad = @Id_Especialidad,
        Id_Direccion_Atencion = @Id_Direccion_Atencion,
        Id_Estado_Turno = @Id_Estado_Turno,
        Id_Tipo_Turno = @Id_Tipo_Turno
    WHERE Id_Turno = @Id_Turno;
END;
GO

--Modificar Estado_Turno

CREATE OR ALTER PROCEDURE clinicaModificacion.Modificar_Estado_Turno
(
    @Id_Estado INT,
    @Nombre_Estado VARCHAR(50)
)
AS
BEGIN
    UPDATE clinica.Estado_Turno
    SET
        Nombre_Estado = @Nombre_Estado
    WHERE Id_Estado = @Id_Estado;
END;
GO

--Modificar Tipo_Turno

CREATE OR ALTER PROCEDURE clinicaModificacion.Modificar_Tipo_Turno
(
    @Id_Tipo_Turno INT,
    @Nombre_Tipo_Turno VARCHAR(50)
)
AS
BEGIN
    UPDATE clinica.Tipo_Turno
    SET
        Nombre_Tipo_Turno = @Nombre_Tipo_Turno
    WHERE Id_Tipo_Turno = @Id_Tipo_Turno;
END;
GO

--Modificar Dias_Por_Sede

CREATE OR ALTER PROCEDURE clinicaModificacion.Modificar_Dias_Por_Sede
(
    @Id_Sede INT,
    @Id_Medico INT,
    @Dia VARCHAR(20),
    @Hora_Inicio TIME
)
AS
BEGIN
    UPDATE clinica.Dias_Por_Sede
    SET
        Id_Medico = @Id_Medico,
        Dia = @Dia,
        Hora_Inicio = @Hora_Inicio
    WHERE Id_Sede = @Id_Sede;
END;
GO

--Modificar Medico

CREATE OR ALTER PROCEDURE clinicaModificacion.Modificar_Medico
(
    @Id_Medico INT,
    @Nombre VARCHAR(50),
    @Apellido VARCHAR(50),
    @Nro_Matricula VARCHAR(50)
)
AS
BEGIN
    UPDATE clinica.Medico
    SET
        Nombre = @Nombre,
        Apellido = @Apellido,
        Nro_Matricula = @Nro_Matricula
    WHERE Id_Medico = @Id_Medico;
END;
GO

--Modificar Especialidad

CREATE OR ALTER PROCEDURE clinicaModificacion.Modificar_Especialidad
(
    @Id_Especialidad INT,
    @Nombre_Especialidad VARCHAR(50)
)
AS
BEGIN
    UPDATE clinica.Especialidad
    SET
        Nombre_Especialidad = @Nombre_Especialidad
    WHERE Id_Especialidad = @Id_Especialidad;
END;
GO

--Modificar Sede_De_Atencion

CREATE OR ALTER PROCEDURE clinicaModificacion.Modificar_Sede_De_Atencion
(
    @Id_Sede INT,
    @Nombre_Sede VARCHAR(50),
    @Direccion VARCHAR(50)
)
AS
BEGIN
    UPDATE clinica.Sede_De_Atencion
    SET
        Nombre_Sede = @Nombre_Sede,
        Direccion = @Direccion
    WHERE Id_Sede = @Id_Sede;
END;
GO
