<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['cambiarEstadoEmpleado'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idEmpleado = $data->idEmpleado;
    $usuarioModificacion = $data->usuarioModificacion;


    $query = "CALL SP_cambiarEstadoEmpleado($idEmpleado,'$usuarioModificacion', @p0)";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    while ($row = mysqli_fetch_array($result)) {
        $json[] = array(
            'nomEmp' => $row['nomEmp'],
            'correoEmp' => $row['correoEmp'],
            'isActive' => $row['isActive'],
            'nomCargo' => $row['nomCargo'],
            'nomArea' => $row['nomArea'],
            'fechaModificacion' => $row['fechaModificacion'],
            'usuarioModificacion' => $row['usuarioModificacion'],
        );
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
    mysqli_close($conection);

} else {
    echo json_encode("Error");
}
