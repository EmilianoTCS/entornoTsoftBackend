<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
include("../../model/conexion.php");
require("./fn_leerCSV.php");

function validarFormatoCampos($fila, $numFila)
{
    $bool_errores = false;
    $str_error = '';

    //nom colaborador
    if ($fila['nombre colaborador'] === "" || $fila['nombre colaborador'] === null) {
        $str_errorPlantilla = 'Error fila: ' . $numFila . ', campo "nombre colaborador" está vacío o nulo.';
        $bool_errores = true;
        $str_error =  $str_error . $str_errorPlantilla . "\n";
    }
    //nombre proyecto
    if ($fila['nombre proyecto'] === "" || $fila['nombre proyecto'] === null) {
        $str_errorPlantilla = 'Error fila: ' . $numFila . ', campo "nombre proyecto" está vacío o nulo.';
        $bool_errores = true;
        $str_error =  $str_error . $str_errorPlantilla . "\n";
    }

    // mes
    if (trim($fila['mes (formato YYYYMM)']) === "" || $fila['mes (formato YYYYMM)'] === null || !preg_match('/^\d{0,9}$/', $fila['mes (formato YYYYMM)'])) {
        $str_errorPlantilla = "Error fila: " . $numFila . ", campo 'mes (formato YYYYMM)' está vacío, nulo o contiene caracteres incorrectos, ingresa solamente valores numéricos.";
        $bool_errores = true;
        $str_error =  $str_error . $str_errorPlantilla . "\n";
    }

    // cant horas
    if (trim($fila['cantidad horas']) === "" || $fila['cantidad horas'] === null || !preg_match('/^\d{0,9}$/', $fila['cantidad horas'])) {
        $str_errorPlantilla = "Error fila: " . $numFila . ", campo 'cantidad horas' está vacío, nulo o contiene caracteres incorrectos, ingresa solamente valores numéricos.";
        $bool_errores = true;
        $str_error =  $str_error . $str_errorPlantilla . "\n";
    }

    // cant horas extra
    if (trim($fila['cantidad horas extra']) !== "" && !preg_match('/^\d{0,9}$/', $fila['cantidad horas extra'])) {
        $str_errorPlantilla = "Error fila: " . $numFila . ", campo 'cantidad horas extra' contiene caracteres incorrectos, ingresa solamente valores numéricos.";
        $bool_errores = true;
        $str_error =  $str_error . $str_errorPlantilla . "\n";
    }

    // valor hh colaborador
    if ($fila['valor HH'] === "" || $fila['valor HH'] === null || !preg_match('/^\d{0,9}$/', $fila['valor HH'])) {
        $str_errorPlantilla = "Error fila: " . $numFila . ", campo 'valor hh colaborador' está vacío, nulo o contiene caracteres incorrectos, ingresa solamente valores numéricos.";
        $bool_errores = true;
        $str_error =  $str_error . $str_errorPlantilla . "\n";
    }

    return ['errores' => $str_error, 'bool_errores' => $bool_errores, 'fila' => $fila];
}


//Recibe la solicitud del archivo
if (isset($_POST)) {
    $archivo = $_FILES['file'];
    //Valida que no tenga errores
    if ($archivo['error'] !== UPLOAD_ERR_OK) {
        echo "Error al subir el archivo.";
        exit;
    } else {
        $nomDocumento = basename($_FILES['file']['name']);
        $tipo = strtolower(pathinfo($nomDocumento, PATHINFO_EXTENSION));

        //Verifica el tipo de archivo
        if ($tipo === "csv") {
            $errores = array();
            $contadorExitosos = 0;
            $contadorFallidos = 0;
            $contadorTotales = 0;

            //Leo el archivo y obtengo las filas y los encabezados por separado, se utiliza la función leerCSV().
            $resultadoCSV = array();
            $resultadoCSV = leerCSV($_FILES['file']['tmp_name']);


            $filas = $resultadoCSV['filas'];
            $encabezados = $resultadoCSV['encabezados'];

            for ($i = 0; $i < count($filas); $i++) {
                $resultadoValidarCampos = validarFormatoCampos($filas[$i], $i + 2);
                $contadorTotales = $contadorTotales + 1;

                if (!empty($resultadoValidarCampos['bool_errores']) || $resultadoValidarCampos['bool_errores'] === true) {
                    array_push($errores, $resultadoValidarCampos['errores']);
                    $contadorFallidos = $contadorFallidos + 1;
                } else {
                    // Declaración de variables
                    $fila = $resultadoValidarCampos['fila'];
                    $contadorExitosos = $contadorExitosos + 1;

                    // print_r($fila);
                    $nombreColaborador = $fila['nombre colaborador'];
                    $nombreProyecto = $fila['nombre proyecto'];
                    $mes = $fila['mes (formato YYYYMM)'];
                    $miscelaneo = $fila['miscelaneo (opcional)'];
                    $cantHH = $fila['cantidad horas'];
                    $cantHHExtra = $fila['cantidad horas extra'];
                    $valorHH = $fila['valor HH'];

                    // Ejecución de QUERY
                    $query = "CALL SP_ihh_cargaImpHoras(
                        '$nombreColaborador',
                        '$nombreProyecto',
                        '$mes',
                        '$miscelaneo',
                        '$cantHH',
                        '$cantHHExtra',
                        '$valorHH',
                    @p0, @p1)";

                    // $result = mysqli_query($conection, $query);
                    // if (!$result) {
                    //     die('Query Failed' . mysqli_error($conection));
                    // }

                    // $json = array();
                    // while ($row = mysqli_fetch_array($result)) {
                    //     $json[] = array(
                    //         'OUT_CODRESULT' => $row['OUT_CODRESULT'],
                    //         'OUT_MJERESULT' => $row['OUT_MJERESULT'],
                    //     );
                    //     echo json_encode($json);
                    // }
                }
            }

            echo json_encode([
                'cantExitosos' => $contadorExitosos,
                'cantFallidos' => $contadorFallidos,
                'cantTotal' => $contadorTotales,
                'errores' => $errores,
            ]);
        } else {
            echo json_encode([
                'OUT_CODRESULT' => '01',
                'MJE_CODRESULT' => 'El formato del archivo es incorrecto, debe ser .CSV de forma obligatoria.'
            ]);
        }
    }
}
