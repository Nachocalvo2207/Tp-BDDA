CREATE OR ALTER PROCEDURE Clinica.CrearXML
    (
    @ObraSocial VARCHAR(50),
    @FechaComienzo DATE,
    @FechaFin DATE
)
AS
BEGIN

    CREATE TABLE #TempXML
    (
        id_historia int,
        apellido VARCHAR(50),
        nombre VARCHAR(50),
        nombre_medico VARCHAR(50),
        matricula int,
        especialidad VARCHAR(50),
        fecha DATE,
        hora TIME
    )

    INSERT INTO #TempXML (id_historia, apellido, nombre, nombre_medico, matricula, especialidad, fecha, hora)
    SELECT ap.Id_Historia_Clinica, 
        ap.Apellido, 
        ap.Nombre,
        m.Nombre, 
        m.Nro_Matricula,
		e.Nombre_Especialidad,
        rtm.Fecha, 
        rtm.Hora
    FROM
        clinica.Paciente ap
        JOIN clinica.Reserva_Turno_Medico rtm ON ap.Id_Historia_Clinica = rtm.Id_Historia_Clinica
        JOIN clinica.Medico m ON rtm.Id_Medico = m.Id_Medico
        JOIN clinica.Especialidad e ON m.Id_Especialidad = e.Id_Especialidad
        JOIN clinica.Prestador pr ON ap.Id_Cobertura = pr.Id_Prestador
        JOIN clinica.Estado_Turno et ON rtm.Id_Estado_Turno = et.Id_Estado

    WHERE
        pr.nombre_prestador = @ObraSocial
        AND et.nombre_estado = 'Atendido'
        AND rtm.fecha >= @FechaComienzo
        AND rtm.fecha <= @FechaFin
    SELECT *
    FROM #TempXML
    FOR xml RAW('Turno'), ROOT('Turnos'), ELEMENTS XSINIL;
    
    DROP TABLE #TempXML

    END;
GO