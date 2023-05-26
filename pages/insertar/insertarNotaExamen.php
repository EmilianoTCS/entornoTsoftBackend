<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['insertarNotaExamen'])) {
    $data = json_decode(file_get_contents("php://input"));
    $notaExamen = $data->notaExamen;
    $apruebaExamen = $data->apruebaExamen;
    $isActive = $data->isActive;
    $idRamoExamen = $data->idRamoExamen;
    $idCursoAlumno = $data->idCursoAlumno;
    $usuarioCreacion = $data->usuarioCreacion;


    $query = "CALL SP_insertarNotaExamen( $notaExamen,'$apruebaExamen','$isActive', $idRamoExamen, $idCursoAlumno, '$usuarioCreacion', @p0, @p1)";
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
            $json[] = array(
                'idNotaExamen' => $row['idNotaExamen'],
                'notaExamen' => $row['notaExamen'],
                'apruebaExamen' => $row['UPPER(notaEx.apruebaExamen)'],
                'nomExamen' => $row['UPPER(ramoEx.nomExamen)'],
                'idCursoAlumno' => $row['idCursoAlumno']
            );
        }
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
} else {
    echo json_encode("Error");
}
