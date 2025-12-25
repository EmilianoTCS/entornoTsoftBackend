<?php

include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['listadoConfigDatos'])) {
    $data = json_decode(file_get_contents("php://input"));
    $tipoConfDato = $data->tipoConfDato;
    $subTipoConfDato = $data->subTipoConfDato;

    $query = "CALL SP_listadoConfigDatos('$tipoConfDato','$subTipoConfDato', @p0, @p1)";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    while ($row = mysqli_fetch_array($result)) {
        if ($row['OUT_CODRESULT'] != '00') {
            $json[] = array(
                'idConfDatos' => '0 / vacío',
                'tipoConfDato' => '0 / vacío',
                'subTipoConfDato' => '0 / vacío',
                'orden' => '0 / vacío',
                'datoVisible' => '0 / vacío',
                'datoNoVisible' => '0 / vacío',
                'descDato' => '0 / vacío',
                'OUT_CODRESULT' => $row['OUT_CODRESULT'],
                'OUT_MJERESULT' => $row['OUT_MJERESULT']
            );
        } else {
            $json[] = array(
                'idConfDatos' => $row['idConfDatos'],
                'tipoConfDato' => $row['tipoConfDato'],
                'subTipoConfDato' => $row['subTipoConfDato'],
                'orden' => $row['orden'],
                'datoVisible' => $row['datoVisible'],
                'datoNoVisible' => $row['datoNoVisible'],
                'descDato' => $row['descDato'],
            );
        }
    }
    $jsonstring = json_encode(($json));
    echo $jsonstring;
    mysqli_close($conection);
}
