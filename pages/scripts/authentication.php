<?php
include("../../model/conexion.php");


$params = base64_decode($_SERVER['QUERY_STRING']);
$exploded = explode('&', $params);
$result = array();

foreach ($exploded as $key) {
    parse_str($key, $output);
    array_push($result, $output);
}

$idEDDEvaluacion = ($result[0]['idEDDEvaluacion']);
$idProyecto = ($result[1]['idProyecto']);
$cargoEnProy = ($result[2]['cargoEnProy']);
$idEDDProyEmpEvaluador = ($result[3]['idEDDProyEmpEvaluador']);


//crear sp enviandole los parámetros recibidos, retornando true o false dependiendo si coinciden
//idEvaluacion, idProyecto, cargoEnProy, idEDDProyEmpEvaluador
//validar evalrespondida = 0, reconocer cargo, validad fechas vigencia x cargo, dias vigencia x cargo, email enviado = 0
//validar fechas 

$queryAuthentication = "CALL SP_authenticationEmail('$idEDDEvaluacion','$idProyecto','$$cargoEnProy', $idEDDProyEmpEvaluador, @p0, @p1)";
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
            if ($row['RESULT'] === '1' || $row['RESULT'] !== '') {
                header("Location: https://entornotsoft.com/formulario");
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
    exit();
}



