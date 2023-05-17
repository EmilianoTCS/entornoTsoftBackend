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
    $usuarioModificacion = $data->usuarioModificacion;


    $query = "CALL SP_editarEmpleado($idEmpleado,'$nomEmpleado','$correoEmpleado','$telefonoEmpleado',$idPais,$idArea,$idCargo,'$usuarioModificacion', @p0)";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    while ($row = mysqli_fetch_array($result)) {
        $json[] = array(
            'idEmpleado' => $row['idEmpleado'],
            'nomEmpleado' => $row['nomEmpleado'],
            'correoEmpleado' => $row['correoEmpleado'],
            'telefonoEmpleado' => $row['telefonoEmpleado'],
            'nomArea' => $row['nomArea'],
            'nomPais' => $row['nomPais'],
            'nomCargo' => $row['nomCargo']
        );
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
    mysqli_close($conection);
} else {
    echo json_encode("Error");
}
