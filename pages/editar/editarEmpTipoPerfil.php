<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['editarEmpTipoPerfil'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idEmpTipoPerfil = $data->idEmpTipoPerfil;
    $idEmpleado = $data->idEmpleado;
    $idTipoPerfil = $data->idTipoPerfil;
    $isActive = $data->isActive;
    $usuarioModificacion = $data->usuarioModificacion;

    $query = "CALL SP_editarEmpTipoPerfil('$idEmpTipoPerfil', '$idEmpleado','$idTipoPerfil', $isActive, '$usuarioModificacion', @p0, @p1)";
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
                'idEmpTipoPerfil' => $row['idEmpTipoPerfil'],
                'nomTipoPerfil' => $row['UPPER(tp.nomTipoPerfil)'],
                'nomEmpleado' => $row['UPPER(emp.nomEmpleado)'],
            );
        }
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
} else {
    echo json_encode("Error");
}