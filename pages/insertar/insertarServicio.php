<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['insertarServicio'])) {
    $data = json_decode(file_get_contents("php://input"));
    $nomServicio = $data->nomServicio;
    $idCliente = $data->idCliente;
    $usuarioAdmin = $data->usuarioAdmin;

    $query = "CALL SP_insertarServicio('$nomServicio',$idCliente,'$usuarioAdmin', @p0, @p1)";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }


    $json = array();
    while ($row = mysqli_fetch_array($result)) {
        if ($row['OUT_STATUSERROR'] != '00') {
            $json[] = array(
                'OUT_CODRESULT' => $row['OUT_CODRESULT'],
                'OUT_MJERESULT' => $row['OUT_MJERESULT']
            );
        } else {
            $json[] = array(
                'idServicio' => $row['idServicio'],
                'nomServicio' => $row['nomServicio'],
                'isActive' => $row['isActive'],
                'idCliente' => $row['idCliente'],
                'fechaCreacion' => $row['fechaCreacion'],
                'usuarioCreacion' => $row['usuarioCreacion'],
                'fechaModificacion' => $row['fechaModificacion'],
                'usuarioModificacion' => $row['usuarioModificacion'],
            );
        }
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
} else {
    echo json_encode("Error");
}
