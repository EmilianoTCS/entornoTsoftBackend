<?php

include("../../model/conexion.php");
require("./emailEDD.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['eventCiclosEval_manual'])) {

    //Declaración de variables
    $data = json_decode(file_get_contents("php://input"));
    $idProyecto = $data->idProyecto;
    $cargoEnProy = $data->cargoEnProy;
    $tipoConfDato = $data->tipoConfDato;
    $subTipoConfDato = $data->subTipoConfDato;
    $cicloEvaluacion = '';
    $listContactos = $data->listContactos === "" || null ? "" : $data->listContactos;



    $query = "CALL SP_duplicarRefEddEvalProyEmp_manual('$idProyecto', '$cargoEnProy', @p0, @p1)";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $datos = array();
    while ($row = mysqli_fetch_array($result)) {
        if ($row['out_codResp'] != '00') {
            $datos[] = array(
                'out_codResp' => $row['out_codResp'],
                'out_msjResp' => $row['out_msjResp']
            );
        } else {
            $cicloEvaluacion = $row['numCicloEval'];
        }
    }
    // $jsonstring = json_encode(($json));
    // echo $jsonstring;
    mysqli_close($conection);

    // print_r($datos);
    print_r($cicloEvaluacion);

    emailEDD($idProyecto, $cicloEvaluacion, $cargoEnProy, $listContactos, $tipoConfDato);
}
