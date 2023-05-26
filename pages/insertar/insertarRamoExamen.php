<?php

include("../../model/conexion.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['insertarRamoExamen'])) {

    $data = json_decode(file_get_contents("php://input"));
    $nomExamen = $data->nomExamen;
    $apruebaExamen = $data->apruebaExamen;
    $isActive = $data->isActive;
    $idRamoExamen = $data->idRamoExamen;
    $idCursoAlumno = $data->idCursoAlumno;
    $usuarioCreacion = $data->usuarioCreacion;

    $query = "CALL SP_insertarRamoExamen('$nomExamen', '$apruebaExamen', '$isActive', '$idRamoExamen', '$idCursoAlumno', '$usuarioCreacion', @p0, @p1)";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    while ($row = mysqli_fetch_array($result)) {
        $json[] = array(
            'idRamoExamen' => $row['idRamoExamen'],
            'nomExamen' => $row['UPPER(ramEx.nomExamen)'],
            'fechaExamen' => $row['fechaExamen'],
            'nomRamo' => $row['UPPER(ram.nomRamo)']
        );
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
}
