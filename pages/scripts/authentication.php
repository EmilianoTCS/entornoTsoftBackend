<?php
include("../../model/conexion.php");


$params = base64_decode($_SERVER['QUERY_STRING']);
$exploded = explode('&', $params);
$result = array();

foreach ($exploded as $key) {
    parse_str($key, $output);
    array_push($result, $output);
}
// echo json_encode($result);

$idEDDEvaluacion = ($result[0]['idEDDEvaluacion']);
$idProyecto = ($result[1]['idProyecto']);
$cargoEnProy = ($result[2]['cargoEnProy']);
$idEDDProyEmpEvaluador = ($result[3]['idEDDProyEmpEvaluador']);
$idEDDProyEmpEvaluado = ($result[4]['idEDDProyEmpEvaluado']);

// print_r($params);

//crear sp enviandole los parámetros recibidos, retornando true o false dependiendo si coinciden
//idEvaluacion, idProyecto, cargoEnProy, idEDDProyEmpEvaluador
//validar evalrespondida = 0, reconocer cargo, validad fechas vigencia x cargo, dias vigencia x cargo, email enviado = 0
//validar fechas 

$queryAuthentication = "CALL SP_authenticationEmail($idEDDEvaluacion, $idProyecto, '$cargoEnProy', $idEDDProyEmpEvaluador, @p0, @p1)";
$resultAuthentication = mysqli_query($conection, $queryAuthentication);
if (!$resultAuthentication) {
    die('Query Failed' . mysqli_error($conection));
}
if (mysqli_num_rows($resultAuthentication) > 0) {
    while ($row = mysqli_fetch_array($resultAuthentication)) {
        if ($row['OUT_CODRESULT'] !== '00') {
            $json[] = array(
                'OUT_CODRESULT' => $row['OUT_CODRESULT'],
                'OUT_MJERESULT' => $row['OUT_MJERESULT']
            );

            echo json_encode($json);
        } else {
            if ($row['RESULT'] === '1') {
                $encoded = base64_encode("{$idEDDEvaluacion},{$idEDDProyEmpEvaluado},{$idEDDProyEmpEvaluador}");
                header("Location: http://localhost:3000/login?{$encoded}");
                exit();
            } else {
                // header("Location: http://localhost:3000/RedirectErrorMail");
                header("Location: http://www.google.com.ar");
                exit();
            }
        }
    }
} else {
    header("Location: http://www.google.com.ar");
    // header("Location: http://localhost:3000/RedirectErrorMail");

    exit();
}



