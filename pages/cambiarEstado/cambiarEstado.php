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

        $json[] = array(
            'OUT_CODRESULT' => $row['OUT_CODRESULT'],
            'OUT_MJERESULT' => $row['OUT_MJERESULT']
        );
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
    mysqli_close($conection);
} else {
    echo json_encode("Error");
}
