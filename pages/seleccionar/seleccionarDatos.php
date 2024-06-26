<?php

include("../../model/conexion.php");


header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['seleccionarDatos'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idRegistro = $data->idRegistro;
    $nombreTabla = $data->nombreTabla;

    // $idRegistro = 1;
    // $nombreTabla = "empsubsist";

    $query = "CALL SP_seleccionarDatos('$nombreTabla', $idRegistro, @p0, @p1)";
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
                        'nomAlumno' => $row['UPPER(alum.nomAlumno)'],
                        'correoAlumno' => $row['UPPER(alum.correoAlumno)'],
                        'telefonoAlumno' => $row['UPPER(alum.telefonoAlumno)'],
                        'idServicio' => $row['idServicio'],
                        'idArea' => $row['idArea'],
                        'idPais' => $row['idPais'],
                        'idCargo' => $row['idCargo']
                    );
                    break;
                case 'cliente':
                    $json[] = array(
                        'idCliente' => $row['idCliente'],
                        'nomCliente' => $row['UPPER(cli.nomCliente)'],
                        'direccionCliente' => $row['UPPER(cli.direccionCliente)'],
                        'idPais' => $row['idPais'],
                    );
                    break;
                case 'contacto':
                    $json[] = array(
                        'idContacto' => $row['idContacto'],
                        'nomContacto' => $row['UPPER(con.nomContacto)'],
                        'correoContacto' => $row['UPPER(con.correoContacto)'],
                        'telefonoContacto' => $row['telefonoContacto'],
                        'fechaIni' => $row['fechaIni'],
                        'fechaFin' => $row['fechaFin'],
                        'idServicio' => $row['idServicio']
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
                        'idEmpleado' => $row['idEmpleado'],
                        'idCurso' => $row['idCurso']
                    );
                    break;
                case 'cursoalumno_sesion':
                    $json[] = array(
                        'idCursoAlumnoSesion' => $row['idCursoAlumnoSesion'],
                        'fechaIni' => $row['fechaIni'],
                        'fechaFin' => $row['fechaFin'],
                        'horaIni' => $row['horaIni'],
                        'horaFin' => $row['horaFin'],
                        'asistencia' => $row['asistencia'],
                        'participacion' => $row['participacion'],
                        'idSesion' => $row['idSesion'],
                        'idCursoAlumno' => $row['idCursoAlumno']
                    );
                    break;
                case 'empleado':
                    $json[] = array(
                        'idEmpleado' => $row['idEmpleado'],
                        'nomEmpleado' => $row['UPPER(emp.nomEmpleado)'],
                        'correoEmpleado' => $row['UPPER(emp.correoEmpleado)'],
                        'telefonoEmpleado' => $row['telefonoEmpleado'],
                        'idArea' => $row['idArea'],
                        'idPais' => $row['idPais'],
                        'idCargo' => $row['idCargo']
                    );
                    break;
                case 'notaexamen':
                    $json[] = array(
                        'idNotaExamen' => $row['idNotaExamen'],
                        'notaExamen' => $row['notaExamen'],
                        'apruebaExamen' => $row['UPPER(notaEx.apruebaExamen)'],
                        'idRamoExamen' => $row['idRamoExamen'],
                        'idCursoAlumno' => $row['idCursoAlumno']
                    );
                    break;
                case 'ramo':
                    $json[] = array(
                        'codRamo' => $row['UPPER(ram.codRamo)'],
                        'nomRamo' => $row['UPPER(ram.nomRamo)'],
                        'tipoRamo' => $row['UPPER(ram.tipoRamo)'],
                        'tipoRamoHH' => $row['UPPER(ram.tipoRamoHH)'],
                        'duracionRamo' => $row['duracionRamoHH'],
                        'cantSesionesRamo' => $row['cantSesionesRamo'],
                        'idCurso' => $row['idCurso']
                    );
                    break;
                case 'ramoexamen':
                    $json[] = array(
                        'idRamoExamen' => $row['idRamoExamen'],
                        'nomExamen' => $row['UPPER(ramEx.nomExamen)'],
                        'fechaExamen' => $row['fechaExamen'],
                        'idRamo' => $row['idRamo']
                    );
                    break;
                case 'relatorramo':
                    $json[] = array(
                        'idRelatorRamo' => $row['idRelatorRamo'],
                        'fechaIni' => $row['fechaIni'],
                        'fechaFin' => $row['fechaFin'],
                        'idEmpleado' => $row['idEmpleado'],
                        'idRamo' => $row['idRamo']
                    );
                    break;
                case 'reqcurso':
                    $json[] = array(
                        'idReqCurso' => $row['idReqCurso'],
                        'idCurso' => $row['idCurso'],
                        'requisitoCurso' => $row['requisitoCurso']
                    );
                    break;
                case 'servicio':
                    $json[] = array(
                        'idServicio' => $row['idServicio'],
                        'nomServicio' => $row['UPPER(serv.nomServicio)'],
                        'idCliente' => $row['idCliente'],
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
                        'idRamo' => $row['idRamo']
                    );
                    break;
                case 'eddproyecto':
                    $json[] = array(
                        'idEDDProyecto' => $row['idEDDProyecto'],
                        'nomProyecto' => $row['nomProyecto'],
                        'fechaIni' => $row['fechaIni'],
                        'fechaFin' => $row['fechaFin'],
                        'nomServicio' => $row['nomServicio'],
                        'idServicio' => $row['idServicio'],
                        'tipoProyecto' => $row['tipoProyecto'],
                    );
                    break;
                case 'eddproyemp':
                    $json[] = array(
                        'idEDDProyEmp' => $row['idEDDProyEmp'],
                        'idProyecto' => $row['idProyecto'],
                        'idEmpleado' => $row['idEmpleado'],
                        'cargoEnProy' => $row['cargoEnProy'],
                    );
                    break;
                case 'emptipoperfil':
                    $json[] = array(
                        'idEmpTipoPerfil' => $row['idEmpTipoPerfil'],
                        'idEmpleado' => $row['idEmpleado'],
                        'idTipoPerfil' => $row['idTipoPerfil'],
                    );
                    break;
                case 'empsubsist':
                    $json[] = array(
                        'idEmpSubsist' => $row['idEmpSubsist'],
                        'idEmpleado' => $row['idEmpleado'],
                        'idSubsistema' => $row['idSubsistema'],
                    );
                    break;
                case 'eddevalcompetencia':
                    $json[] = array(
                        'nomCompetencia' => $row['nomCompetencia'],
                    );
                    break;
                case 'eddevalresppreg':
                    $json[] = array(
                        'nomRespPreg' => $row['nomRespPreg'],
                        'ordenRespPreg' => $row['ordenRespPreg'],
                        'idEDDEvalPregunta' => $row['idEDDEvalPregunta'],
                    );
                    break;
                case 'eddevalpregunta':
                    $json[] = array(
                        'nomPregunta' => $row['nomPregunta'],
                        'ordenPregunta' => $row['ordenPregunta'],
                        'idEDDEvaluacion' => $row['idEDDEvaluacion'],
                        'idEDDEvalCompetencia' => $row['idEDDEvalCompetencia'],
                        'tipoResp' => $row['tipoResp'],
                        'preguntaObligatoria' => $row['preguntaObligatoria'],
                    );
                    break;
                case 'eddevalproyresp':
                    $json[] = array(
                        'idEDDEvalProyResp' => $row['idEDDEvalProyResp'],
                        'idEDDEvaluacion' => $row['idEDDEvaluacion'],
                        'idEDDProyEmp' => $row['idEDDProyEmp'],
                        'respuesta' => $row['respuesta'],
                        'idEDDEvalProyEmp' => $row['idEDDEvalProyEmp'],
                        'idEDDEvalPregunta' => $row['idEDDEvalPregunta'],
                        'idEDDEvalRespPreg' => $row['idEDDEvalRespPreg']
                    );
                    break;
                case 'eddevaluacion':
                    $json[] = array(
                        'idEDDEvaluacion' => $row['idEDDEvaluacion'],
                        'nomEvaluacion' => $row['nomEvaluacion'],
                        'tipoEvaluacion' => $row['tipoEvaluacion'],
                        'fechaIni' => $row['fechaIni'],
                        'fechaFin' => $row['fechaFin'],
                    );
                    break;
                case 'eddevalproyemp':
                    $json[] = array(
                        'idEDDEvalProyEmp' => $row['idEDDEvalProyEmp'],
                        'idEDDEvaluacion' => $row['idEDDEvaluacion'],
                        'idEDDProyEmpEvaluador' => $row['idEDDProyEmpEvaluador'],
                        'idEDDProyEmpEvaluado' => $row['idEDDProyEmpEvaluado'],
                        'cicloEvaluacion' => $row['cicloEvaluacion'],
                        'evalRespondida' => $row['evalRespondida'],
                        'fechaIni' => $row['fechaIni'],
                        'fechaFin' => $row['fechaFin'],
                        'idProyecto' => $row['idProyecto'],
                        'nomProyecto' => $row['nomProyecto'],
                    );
                    break;

                case 'ihhacop':
                    $json[] = array(
                        'idAcop' => $row['idAcop'],
                        'idProyecto' => $row['idProyecto'],
                        'presupuestoTotal' => $row['presupuestoTotal'],
                        'cantTotalMeses' => $row['cantTotalMeses'],
                    );
                    break;

                case 'ihhelementoimp':
                    $json[] = array(
                        'idElementoImp' => $row['idElementoImp'],
                        'idTipoElemento' => $row['idTipoElemento'],
                        'nomElemento' => $row['nomElemento'],
                        'descripcion' => $row['descripcion'],
                    );
                    break;

                case 'ihhimpugnacionemp':
                    $json[] = array(
                        'idImpugnacionEmp' => $row['idImpugnacionEmp'],
                        'idEmpleado' => $row['idEmpleado'],
                        'idElemento' => $row['idElemento'],
                        'idPeriodo' => $row['idPeriodo'],
                        'cantHorasPeriodo' => $row['cantHorasPeriodo'],
                        'cantHorasExtra' => $row['cantHorasExtra'],
                        'factor' => $row['factor'],
                        'idAcop' => $row['idAcop'],
                    );
                    break;

                case 'ihhperiodo':
                    $json[] = array(
                        'idPeriodo' => $row['idPeriodo'],
                        'idTipoPeriodo' => $row['idTipoPeriodo'],
                        'nomPeriodo' => $row['nomPeriodo'],
                        'descripcion' => $row['descripcion'],

                    );
                    break;
                case 'ihhtipoelemento':
                    $json[] = array(
                        'idTipoElemento' => $row['idTipoElemento'],
                        'nomTipoElemento' => $row['nomTipoElemento'],
                        'descripcion' => $row['descripcion'],
                    );
                    break;

                case 'ihhtipoperiodo':
                    $json[] = array(
                        'idTipoPeriodo' => $row['idTipoPeriodo'],
                        'nomTipoPeriodo' => $row['nomTipoPeriodo'],
                        'dias' => $row['dias'],
                        'descripcion' => $row['descripcion'],
                    );
                    break;
                case 'ihhnotaimpugnacion':
                    $json[] = array(
                        'idNotaImpugnacion' => $row['idNotaImpugnacion'],
                        'idImpugnacionEmp' => $row['idImpugnacionEmp'],
                        'nota' => $row['nota'],
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
