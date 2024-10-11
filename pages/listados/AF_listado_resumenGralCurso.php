<?php
include("../../model/conexion.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['AF_listado_resumenGralCurso'])) {
    $data = json_decode(file_get_contents("php://input"));
    $fechaInicio = $data->fechaInicio === "" ? null : $data->fechaInicio;
    $fechaFin = $data->fechaFin === "" ? null : $data->fechaFin;
    $estadoCurso = $data->estadoCurso;

    $query = "CALL SP_resumenGralCurso('$fechaInicio', '$fechaFin', '$estadoCurso',@p0, @p1)";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();

    if (mysqli_num_rows($result) > 0) {
        while ($row = mysqli_fetch_array($result)) {

            $json[] = array(
                'idCurso' => $row['idCurso'],
                'nomCurso' => $row['nomCurso'],
                'fechaIni' => $row['fechaIni'],
                'fechaFin' => $row['fechaFin'],
                'cantColaboradores' => $row['cantColaboradores'],
                'cantInscripciones' => $row['cantInscripciones'],
                'cantCursosTerminados' => $row['cantCursosTerminados'],
                'porcCursosTerminados' => $row['porcCursosTerminados'],
                'cantAprobados' => $row['cantAprobados'],
                'cantDesaprobados' => $row['cantDesaprobados'],
                'cantDesertores' => $row['cantDesertores'],
                'porcDesertados' => $row['porcDesertados'],
                'porcAprobacionGeneral' => $row['porcAprobacionGeneral']

            );
        }

        $jsonstring = json_encode($json);
        echo $jsonstring;
    } else {
        $jsonstring = json_encode([]);
        echo $jsonstring;
    }
}
