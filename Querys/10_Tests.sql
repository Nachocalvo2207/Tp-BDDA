/*--------------------------------------------------------------
* Fecha de entrega:

* NUMERO DE GRUPO: 3
* NOMBRE DE LA MATERIA: Base de Datos Aplicada
* NOMBRE Y DNI DE LOS ALUMNOS: 
    1. Calvo Ignacio, 411162300
    2. Rossendy Federico, 37804899
    3. Veliz Nicolas, 42648268
--------------------------------------------------------------*/

EXEC Clinica.importarMedicos 'C:\Users\fede0\Desktop\BDDA\Tp-BDDA\Tp-BDDA\Dataset\Medicos.csv'
EXEC Clinica.importarPrestadores 'C:\Users\fede0\Desktop\BDDA\Tp-BDDA\Tp-BDDA\Dataset\Prestador.csv'
EXEC Clinica.importarSedes 'C:\Users\fede0\Desktop\BDDA\Tp-BDDA\Tp-BDDA\Dataset\Sedes.csv'
EXEC Clinica.ImportarEstudios 'C:\Users\fede0\Desktop\BDDA\Tp-BDDA\Tp-BDDA\Dataset\Centro_Autorizaciones.Estudios clinicos.json'
EXEC Clinica.ImportarPacientes 'C:\Users\fede0\Desktop\BDDA\Tp-BDDA\Tp-BDDA\Dataset\Pacientes.csv'

EXEC Clinica.CrearXML 'OSDE', '2021-01-01', '2021-12-31'
