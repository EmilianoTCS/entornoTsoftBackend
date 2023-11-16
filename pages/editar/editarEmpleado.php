<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['editarEmpleado'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idEmpleado = $data->idEmpleado;
    $nomEmpleado = $data->nomEmpleado;
    $correoEmpleado = $data->correoEmpleado;
    $telefonoEmpleado = $data->telefonoEmpleado;
    $idPais = $data->idPais;
    $idArea = $data->idArea;
    $idCargo = $data->idCargo;
    $idCliente = $data->idCliente;
    $usuarioModificacion = $data->usuarioModificacion;


    $query = "CALL SP_editarEmpleado($idEmpleado,'$nomEmpleado','$correoEmpleado','$telefonoEmpleado',$idPais,$idArea,$idCargo, $idCliente,'$usuarioModificacion', @p0, @p1)";
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
                'OUT_CODRESULT' => $row['OUT_CODRESULT'],
                'OUT_MJERESULT' => $row['OUT_MJERESULT'],
                'idEmpleado' => $row['idEmpleado'],
                'nomEmpleado' => $row['UPPER(emp.nomEmpleado)'],
                'correoEmpleado' => $row['UPPER(emp.correoEmpleado)'],
                'telefonoEmpleado' => $row['telefonoEmpleado'],
                'nomArea' => $row['UPPER(ar.nomArea)'],
                'nomPais' => $row['UPPER(pa.nomPais)'],
                'nomCargo' => $row['UPPER(ca.nomCargo)']
            );
        }
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
    mysqli_close($conection);
} else {
    echo json_encode("Error");
}
