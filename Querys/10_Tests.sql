/*--------------------------------------------------------------
* Fecha de entrega:

* NUMERO DE GRUPO: 3
* NOMBRE DE LA MATERIA: Base de Datos Aplicada
* NOMBRE Y DNI DE LOS ALUMNOS: 
    1. Calvo Ignacio, 411162300
    2. Rossendy Federico, 37804899
    3. Veliz Nicolas, 42648268
--------------------------------------------------------------*/

/*Modificar ruta*/

EXEC Clinica.importarMedicos '\Tp-BDDA\Dataset\Medicos.csv'
EXEC Clinica.importarPrestadores '\Tp-BDDA\Dataset\Prestador.csv'
EXEC Clinica.importarSedes '\Tp-BDDA\Dataset\Sedes.csv'
EXEC Clinica.ImportarEstudios '\Tp-BDDA\Dataset\Centro_Autorizaciones.Estudios clinicos.json'
EXEC Clinica.ImportarPacientes '\Tp-BDDA\Dataset\Pacientes.csv'

EXEC Clinica.CrearXML 'OSDE', '2021-01-01', '2021-12-31'
