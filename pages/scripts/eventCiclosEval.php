<?php

include("../../model/conexion.php");
require("./emailEDD_auto.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['eventCiclosEval'])) {


    $query = "CALL SP_duplicarRefEddEvalProyEmp(@p0, @p1)";
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
            $datos[] = array(
                'numCicloEval' => $row['numCicloEval'],
                'idProyecto' => $row['idProyecto'],
                'cargoEnProy' => $row['cargoEnProy']
            );
        }
    }
    // $jsonstring = json_encode(($json));
    // echo $jsonstring;
    mysqli_close($conection);

    print_r($datos);

    $reduc = array();

    $auxProyecto = "";
    $auxCicloEval = "";
    $auxCargoEnProy = "";
    $acu = 0;

    for ($i = 0; $i < count($datos); $i++) {
        if ($auxProyecto !== $datos[$i]['idProyecto'] || $auxCicloEval != $datos[$i]['numCicloEval'] || $auxCargoEnProy != $datos[$i]['cargoEnProy']) {

            $auxCargoEnProy = $datos[$i]['cargoEnProy'];
            $auxProyecto = $datos[$i]['idProyecto'];
            $auxCicloEval = $datos[$i]['numCicloEval'];


               emailEDD_auto($auxProyecto, $auxCargoEnProy, $auxCicloEval);
        }
    }


}
