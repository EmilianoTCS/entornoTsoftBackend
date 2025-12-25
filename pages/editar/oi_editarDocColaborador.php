<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_POST) && isset($_FILES['file'])) {
    $data = json_decode($_POST['data']);
    $archivo = $_FILES['file']['tmp_name'];
    $nombreArchivo = $_FILES['file']['name'];
    $tipo = strtolower(pathinfo($nombreArchivo, PATHINFO_EXTENSION));
    $idEmpleado = $data->idEmpleado;
    $idDocumento = $data->idDocumento;
    $isActive = $data->isActive;
    $usuarioCreacion = $data->usuarioCreacion;

    $archivoContent = addslashes(file_get_contents($archivo));

    $query = "CALL SP_oi_editarDocColaborador(
    '$idDocumento',
    '$idEmpleado',
    '$nombreArchivo',
    '$tipo',
    '$archivoContent',
    '$isActive', 
    '$usuarioCreacion', @p0, @p1)";

    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }


    $json = array();
    while ($row = mysqli_fetch_array($result)) {
        $json[] = array(
            'OUT_CODRESULT' => $row['OUT_CODRESULT'],
            'OUT_MJERESULT' => $row['OUT_MJERESULT']
        );
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
} else {
    echo json_encode("Error");
}
