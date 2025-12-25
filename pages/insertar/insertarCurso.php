<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['insertarCurso'])) {
    $data = json_decode(file_get_contents("php://input"));
    $codCurso = $data->codCurso;
    $nomCurso = $data->nomCurso;
    $tipoHH = $data->tipoHH;
    $duracionCursoHH = $data->duracionCursoHH;
    $cantSesionesCurso = $data->cantSesionesCurso;
    $isActive = $data->isActive;
    $usuarioCreacion = $data->usuarioCreacion;

    $query = "CALL SP_insertarCurso( '$codCurso','$nomCurso','$tipoHH', $duracionCursoHH, $cantSesionesCurso, $isActive, '$usuarioCreacion', @p0, @p1, @p2)";
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
                'idCurso' => $row['idCurso'],
                'codCurso' => $row['UPPER(cur.codCurso)'],
                'nomCurso' => $row['UPPER(cur.nomCurso)'],
                'tipoHH' => $row['UPPER(cur.tipoHH)'],
                'duracionCursoHH' => $row['duracionCursoHH'],
                'cantSesionesCurso' => $row['cantSesionesCurso']
            );
        }
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
} else {
    echo json_encode("Error");
}
