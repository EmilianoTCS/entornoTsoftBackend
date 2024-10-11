<?php
include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['AF_listadoDetalleRamo'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idRamo = $data->idRamo;


    $query = "CALL SP_AF_listadoDetalleRamo('$idRamo')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();

    if (mysqli_num_rows($result) > 0) {
        while ($row = mysqli_fetch_array($result)) {
            $json[] = array(
                'idEmpleado' => $row['idEmpleado'],
                'nomEmpleado' => $row['nomEmpleado'],
                'idCursoAlumnoRamoSesion' => $row['idCursoAlumnoRamoSesion'],
                'porcAsistencia' => $row['porcAsistencia'],
                'porcAprobacion' => $row['porcAprobacion'],
                'porcParticipacion' => $row['porcParticipacion'],
                'aux_porcDesaprobadoRamo' => $row['aux_porcDesaprobadoRamo'],
                'cantAprobados' => $row['cantAprobados'],
                'cantReprobados' => $row['cantReprobados'],
                'cantExamenes' => $row['cantExamenes'],
                'nomExamen' => $row['nomExamen'],

            );
        }

        $jsonstring = json_encode($json);
        echo $jsonstring;
    } else {

        $jsonstring = json_encode([]);
        echo $jsonstring;
    }
}
