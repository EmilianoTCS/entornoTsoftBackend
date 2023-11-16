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
    $usuarioCreacion = $data->usuarioCreacion;
    $idCliente = $data->idCliente;



    $query = "CALL SP_insertarEmpleado('$nomEmpleado','$correoEmpleado','$telefonoEmpleado', $idPais, $idArea, $idCargo, $idCliente, '$usuario','$password','$tipoUsuario','$usuarioCreacion', $nomRol, @p0, @p1)";
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
} else {
    echo json_encode("Error");
}
