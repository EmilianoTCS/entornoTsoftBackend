<?php

include("../../model/conexion.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['editarRamoExamen'])) {

    $data = json_decode(file_get_contents("php://input"));
    $idRamoExamen = $data->idRamoExamen;
    $nomExamen = $data->nomExamen;
    $apruebaExamen = $data->apruebaExamen;
    $isActive = $data->isActive;
    $idRamo = $data->idRamo;
    $idCursoAlumno = $data->idCursoAlumno;
    $usuarioCreacion = $data->usuarioCreacion;

    $query = "CALL SP_editarRamoExamen($idRamoExamen, '$nomExamen', '$apruebaExamen', '$isActive', '$idRamo', '$idCursoAlumno', '$usuarioCreacion', @p0, @p1)";
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
                'idRamoExamen' => $row['idRamoExamen'],
                'nomExamen' => $row['UPPER(ramEx.nomExamen)'],
                'fechaExamen' => $row['fechaExamen'],
                'nomRamo' => $row['UPPER(ram.nomRamo)']
            );
        }
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
}
