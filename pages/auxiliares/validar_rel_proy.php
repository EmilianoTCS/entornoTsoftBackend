<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['validar_rel_proy'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idProyecto = $data->idProyecto;


    $query = "CALL SP_validar_rel_proy('$idProyecto', @p0, @p1)";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }


    if (mysqli_num_rows($result) > 0) {
        while ($row = mysqli_fetch_array($result)) {

            $json[] = array(
                'OUT_CODRESULT' => $row['OUT_CODRESULT'],
                'OUT_MJERESULT' => $row['OUT_MJERESULT'],
                'idImpugnacionEmp' => $row['idImpugnacionEmp'],
                'idEDDEvalProyEmp' => $row['idEDDEvalProyEmp'],
                'nomEvaluacion' => $row['nomEvaluacion'],
                'mes' => $row['mes'],
                'idresumenperproy' => $row['idresumenperproy'],
            );
        }

        $jsonstring = json_encode($json);
        echo $jsonstring;
    } else {
        $json[] = array(
            'OUT_CODRESULT' => 'empty / vacio',
            'OUT_MJERESULT' => 'empty / vacio',
            'idImpugnacionEmp' => 'empty / vacio',
            'idEDDEvalProyEmp' => 'empty / vacio',
            'nomEvaluacion' => 'empty / vacio',
            'mes' => 'empty / vacio',
            'idresumenperproy' => 'empty / vacio'
        );

        $jsonstring = json_encode($json);
        echo $jsonstring;
    }
} else {
    echo json_encode("Error");
}
