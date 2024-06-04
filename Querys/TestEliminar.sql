-- Delete from Usuario

INSERT INTO clinica.Usuario (Id_Usuario, Contraseña, Fecha_Creacion, Id_Historia_Clinica) 
VALUES (1, '1234', '2021-06-01', 1)

--Test Usuario
EXEC clinicaEliminar.Eliminar_Usuario 1