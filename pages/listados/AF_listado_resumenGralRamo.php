<?php
include("../../model/conexion.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['AF_listado_resumenGralRamo'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idCurso = $data->idCurso;
    $fechaInicio = $data->fechaInicio === "" ? null : $data->fechaInicio;
    $fechaFin = $data->fechaFin === "" ? null : $data->fechaFin;
    $estadoRamo = $data->estadoRamo;

    $query = "CALL SP_resumenGralRamo($idCurso, '$fechaInicio', '$fechaFin', '$estadoRamo', @p0, @p1)";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }   

    $json = array();

    if (mysqli_num_rows($result) > 0) {
        while ($row = mysqli_fetch_array($result)) {
            $json[] = array(
                'idCurso' => $row['idCurso'],
                'idRamo' => $row['idRamo'],
                'nomCurso' => $row['nomCurso'],
                'cantColaboradores' => $row['cantColaboradores'],
                'cantRamos' => $row['cantRamos'],
                'cantRamosTerminados' => $row['cantRamosTerminados'],
                'porcRamosTerminados' => $row['porcRamosTerminados'],
                'cantAprobados' => $row['cantAprobados'],
                'cantDesaprobados' => $row['cantDesaprobados'],
                'cantDesertores' => $row['cantDesertores'],
                'porcDesertados' => $row['porcDesertados'],
                'porcAprobacionGeneral' => $row['porcAprobacionGeneral'],
                'nomRamo' => $row['nomRamo'],
                'promedioAsistencia' => $row['promedioAsistencia'],
                'cantSesiones' => $row['cantSesiones'],
                'cantSesionesTerminadas' => $row['cantSesionesTerminadas'],
            );
        }

        $jsonstring = json_encode($json);
        echo $jsonstring;
    } else {
        $jsonstring = json_encode([]);
        echo $jsonstring;
    }
}
