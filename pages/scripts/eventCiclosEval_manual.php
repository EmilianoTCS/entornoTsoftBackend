<?php

include("../../model/conexion.php");
require("./emailEDD.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['eventCiclosEval_manual'])) {

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
    do {
        // Captura cada conjunto de resultados
        if ($result = mysqli_store_result($conection)) {
            while ($row = mysqli_fetch_array($result)) {
                $OUT_CODRESULT = $row['OUT_CODRESULT'];
                $OUT_MJERESULT = $row['OUT_MJERESULT'];
                $numCicloEval = isset($row['numCicloEval']) ? $row['numCicloEval'] : null;

                // Asigna el ciclo de evaluación si existe en este conjunto de resultados
                if ($OUT_CODRESULT === '00' && $numCicloEval !== null) {
                    $cicloEvaluacion = $numCicloEval;
                    $datos[] = array(
                        'OUT_CODRESULT' => $OUT_CODRESULT,
                        'OUT_MJERESULT' => $OUT_MJERESULT,
                        'cicloEvaluacion' => $cicloEvaluacion,
                    );
                }
            }
            mysqli_free_result($result);
        }
    } while (mysqli_next_result($conection));

    mysqli_close($conection);
    // echo json_encode($datos);

    if ($cicloEvaluacion !== null && $cicloEvaluacion !== '') {
    emailEDD($idProyecto, $cicloEvaluacion, $cargoEnProy, $listContactos, $tipoConfDato);
    }
}
