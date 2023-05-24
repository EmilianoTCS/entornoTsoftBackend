<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['editarCurso'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idCurso = $data->idCurso;
    $codCurso = $data->codCurso;
    $nomCurso = $data->nomCurso;
    $tipoHH = $data->tipoHH;
    $duracionCursoHH = $data->duracionCursoHH;
    $cantSesionesCurso = $data->cantSesionesCurso;
    $isActive = $data->isActive;
    $usuarioAdmin = $data->usuarioAdmin;

    $query = "CALL SP_editarCurso($idCurso,'$codCurso','$nomCurso','$tipoHH', $duracionCursoHH, $cantSesionesCurso, $isActive, '$usuarioAdmin', @p1, @p2, @p3)";
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
                'idCurso' => $row['idCurso'],
                'codCurso' => $row['codCurso'],
                'nomCurso' => $row['nomCurso'],
                'tipoHH' => $row['tipoHH'],
                'duracionCursoHH' => $row['duracionCursoHH'],
                'cantSesionesCurso' => $row['cantSesionesCurso'],
                'isActive' => $row['isActive'],
                'fechaCreacion' => $row['fechaCreacion'],
                'usuarioCreacion' => $row['usuarioCreacion'],
                'fechaModificacion' => $row['fechaModificacion'],
                'usuarioModificacion' => $row['usuarioModificacion'],
            );
        }
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
} else {
    echo json_encode("Error");
}
