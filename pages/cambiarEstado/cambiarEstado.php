<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['cambiarEstado'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idRegistro = $data->idRegistro;
    $nombreTabla = $data->nombreTabla;
    $usuarioModificacion = $data->usuarioModificacion;

    $query = "CALL SP_cambiarEstado('$nombreTabla', $idRegistro,'$usuarioModificacion', @p0, @p1)";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    while ($row = mysqli_fetch_array($result)) {
        if ($row['OUT_CODRESULT'] != '00') {
            $json[] = array(
                'OUT_CODRESULT' => $row['OUT_CODRESULT'],
                'OUT_MJERESULT' => $row['OUT_MJERESULT']
            );
        } else {
            switch ($nombreTabla) {
                case 'alumno':
                    $json[] = array(
                        'idAlumno' => $row['idAlumno'],
                        'nomAlumno' => $row['nomAlumno'],
                        'correoAlumno' => $row['correoAlumno'],
                        'telefonoAlumno' => $row['telefonoAlumno'],
                        'nomArea' => $row['nomArea'],
                        'nomServicio' => $row['nomServicio'],
                        'nomPais' => $row['nomPais'],
                        'nomCargo' => $row['nomCargo']
                    );
                    break;
                case 'cliente':
                    $json[] = array(
                        'idCliente' => $row['idCliente'],
                        'nomCliente' => $row['UPPER(cli.nomCliente)'],
                        'direccionCliente' => $row['UPPER(cli.direccionCliente)'],
                        'nomPais' => $row['UPPER(pa.nomPais)'],
                    );
                    break;
                case 'contacto':
                    $json[] = array(
                        'idContacto' => $row['idContacto'],
                        'nomContacto' => $row['UPPER(con.nomContacto)'],
                        'correoContacto' => $row['UPPER(con.correoContacto)'],
                        'fechaIni' => $row['fechaIni'],
                        'fechaFin' => $row['fechaFin'],
                        'nomServicio' => $row['UPPER(serv.nomServicio)']
                    );
                    break;
                case 'curso':
                    $json[] = array(
                        'idCurso' => $row['idCurso'],
                        'codCurso' => $row['UPPER(cur.codCurso)'],
                        'nomCurso' => $row['UPPER(cur.nomCurso)'],
                        'tipoHH' => $row['UPPER(cur.tipoHH)'],
                        'duracionCursoHH' => $row['duracionCursoHH'],
                        'cantSesionesCurso' => $row['cantSesionesCurso']
                    );
                    break;
                case 'cursoalumno':
                    $json[] = array(
                        'idCursoAlumno' => $row['idCursoAlumno'],
                        'fechaIni' => $row['fechaIni'],
                        'horaIni' => $row['horaIni'],
                        'fechaFin' => $row['fechaFin'],
                        'horaFin' => $row['horaFin'],
                        'porcAsistencia' => $row['porcAsistencia'],
                        'porcParticipacion' => $row['porcParticipacion'],
                        'claseAprobada' => $row['UPPER(curAl.claseAprobada)'],
                        'porcAprobacion' => $row['porcAprobacion'],
                        'estadoCurso' => $row['UPPER(curAl.estadoCurso)'],
                        'nomAlumno' => $row['UPPER(al.nomAlumno)'],
                        'nomCurso' => $row['UPPER(cur.nomCurso)']
                    );
                    break;
                case 'cursoalumno_sesion':
                    $json[] = array(
                        'idCursoAlumnoSesion' => $row['idCursoAlumnoSesion'],
                        'fechaIni' => $row['fechaIni'],
                        'fechaFin' => $row['fechaFin'],
                        'asistencia' => $row['asistencia'],
                        'participacion' => $row['participacion'],
                        'nomSesion' => $row['UPPER(se.nomSesion)'],
                        'idCursoAlumno' => $row['idCursoAlumno']
                    );
                    break;
                case 'empleado':
                    $json[] = array(
                        'idEmpleado' => $row['idEmpleado'],
                        'nomEmpleado' => $row['UPPER(emp.nomEmpleado)'],
                        'correoEmpleado' => $row['UPPER(emp.correoEmpleado)'],
                        'telefonoEmpleado' => $row['telefonoEmpleado'],
                        'nomArea' => $row['UPPER(ar.nomArea)'],
                        'nomPais' => $row['UPPER(pa.nomPais)'],
                        'nomCargo' => $row['UPPER(ca.nomCargo)']
                    );
                    break;
                case 'notaexamen':
                    $json[] = array(
                        'idNotaExamen' => $row['idNotaExamen'],
                        'notaExamen' => $row['notaExamen'],
                        'apruebaExamen' => $row['UPPER(notaEx.apruebaExamen)'],
                        'nomExamen' => $row['UPPER(ramoEx.nomExamen)'],
                        'idCursoAlumno' => $row['idCursoAlumno']
                    );
                    break;
                case 'ramoexamen':
                    $json[] = array(
                        'idRamoExamen' => $row['idRamoExamen'],
                        'nomExamen' => $row['UPPER(ramEx.nomExamen)'],
                        'fechaExamen' => $row['fechaExamen'],
                        'nomRamo' => $row['UPPER(ram.nomRamo)']
                    );
                    break;
                case 'relatorramo':
                    $json[] = array(
                        'idRelatorRamo' => $row['idRelatorRamo'],
                        'fechaIni' => $row['fechaIni'],
                        'fechaFin' => $row['fechaFin'],
                        'nomEmpleado' => $row['UPPER(emp.nomEmpleado)'],
                        'nomRamo' => $row['UPPER(ram.nomRamo)']
                    );
                    break;
                case 'reqcurso':
                    $json[] = array(
                        'idReqCurso' => $row['idReqCurso'],
                        'nomCurso' => $row['UPPER(cur.nomCurso)'],
                        'requisitoCurso' => $row['requisitoCurso']
                    );
                    break;
                case 'servicio':
                    $json[] = array(
                        'idServicio' => $row['idServicio'],
                        'nomServicio' => $row['UPPER(serv.nomServicio)'],
                        'nomCliente' => $row['UPPER(cli.nomCliente)'],
                    );
                    break;
                case 'sesion':
                    $json[] = array(
                        'idSesion' => $row['idSesion'],
                        'nroSesion' => $row['nroSesion'],
                        'nomSesion' => $row['UPPER(se.nomSesion)'],
                        'tipoSesion' => $row['UPPER(se.tipoSesion)'],
                        'tipoSesionHH' => $row['UPPER(se.tipoSesionHH)'],
                        'duracionSesionHH' => $row['UPPER(se.duracionSesionHH)'],
                        'nomRamo' => $row['UPPER(ram.nomRamo)']
                    );
                    break;
                case 'eddproyecto':
                    $json[] = array(
                        'idEDDProyecto' => $row['idEDDProyecto'],
                        'nomProyecto' => $row['nomProyecto'],
                        'fechaIni' => $row['fechaIni'],
                        'fechaFin' => $row['fechaFin'],
                        'nomServicio' => $row['nomServicio'],
                        'idServicio' => $row['idServicio']
                    );
                    break;
                case 'eddproyemp':
                    $json[] = array(
                        'idEDDProyEmp' => $row['idEDDProyEmp'],
                        'nomProyecto' => $row['nomProyecto'],
                        'nomEmpleado' => $row['nomEmpleado'],
                        'cargoEnProy' => $row['cargoEnProy'],
                    );
                    break;
                case 'emptipoperfil':
                    $json[] = array(
                        'idEDDProyecto' => $row['idEDDProyecto'],
                        'nomProyecto' => $row['nomProyecto'],
                        'fechaIni' => $row['fechaIni'],
                        'fechaFin' => $row['fechaFin'],
                        'nomServicio' => $row['nomServicio'],
                        'idServicio' => $row['idServicio']
                    );
                    break;
            }
        }
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
    mysqli_close($conection);
} else {
    echo json_encode("Error");
}
