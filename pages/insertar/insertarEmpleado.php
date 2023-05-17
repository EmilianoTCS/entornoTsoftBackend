<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['insertarEmpleado'])) {
    $data = json_decode(file_get_contents("php://input"));
    $nomEmpleado = $data->nomEmpleado;
    $correoEmpleado = $data->correoEmpleado;
    $telefonoEmpleado = $data->telefonoEmpleado;
    $idPais = $data->idPais;
    $idCargo = $data->idCargo;
    $idArea = $data->idArea;
    $usuario = $data->usuario;
    $password = $data->password;
    $tipoUsuario = $data->tipoUsuario;
    $nomRol = $data->nomRol;
    $usuarioAdmin = $data->usuarioAdmin;
    

    $query = "CALL SP_insertarEmpleado('$nomEmpleado','$correoEmpleado','$telefonoEmpleado',$idPais,$idArea,$idCargo,'$usuario','$password','$tipoUsuario','$usuarioAdmin', '$nomRol', @p0)";
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
