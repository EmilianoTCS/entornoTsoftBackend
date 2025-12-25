<?php

include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['listadoRespPregEvaluaciones'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idEvaluacion = $data->idEvaluacion;
    $idEmpleado = $data->idEmpleado;
    $idEDDProyEmpEvaluado = $data->idEDDProyEmpEvaluado;
    $cicloEvaluacion = $data->cicloEvaluacion;

    $query = "CALL SP_listadoRespPregEvaluaciones('$idEvaluacion', '$idEmpleado', $idEDDProyEmpEvaluado, $cicloEvaluacion, @p0, @p1)";
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
                'nomEvaluacion' => $row['nomEvaluacion'],
                'tipoEvaluacion' => $row['tipoEvaluacion'],
                'descFormulario' => $row['descFormulario'],
                'ordenPregunta' => $row['ordenPregunta'],
                'idEDDEvalProyEmp' => $row['idEDDEvalProyEmp'],
                'idEDDProyEmpEvaluador' => $row['idEDDProyEmpEvaluador'],
                'idEDDEvalPregunta' => $row['idEDDEvalPregunta'],
                'nomPregunta' => $row['nomPregunta'],
                'tipoResp' => $row['tipoResp'],
                'ordenRespPreg' => $row['ordenRespPreg'],
                'idEDDEvalRespPreg' => $row['idEDDEvalRespPreg'],
                'nomRespPreg' => $row['nomRespPreg'],
                'preguntaObligatoria' => $row['preguntaObligatoria'],
                'nomCompetencia' => $row['nomCompetencia'],
                'logoFormulario' => "data:image/jpeg; base64, " . base64_encode($row['logoFormulario'])
            );
        }
    }
    $jsonstring = json_encode(($json));
    echo $jsonstring;
    mysqli_close($conection);
}
