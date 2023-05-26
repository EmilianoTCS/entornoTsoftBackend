<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['insertarCliente'])) {
    $data = json_decode(file_get_contents("php://input"));
    $nomCliente = $data->nomCliente;
    $direccionCliente = $data->direccionCliente;
    $idPais = $data->idPais;
    $usuarioAdmin = $data->usuarioAdmin;

    $query = "CALL SP_insertarServicio('$nomCliente', '$direccionCliente', $idPais,'$usuarioAdmin', @p0, @p1)";
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
                'idCliente' => $row['idCliente'],
                'nomCliente' => $row['UPPER(cli.nomCliente)'],
                'direccionCliente' => $row['UPPER(cli.direccionCliente)'],
                'nomPais' => $row['UPPER(pa.nomPais)'],
            );
        }
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
} else {
    echo json_encode("Error");
}
