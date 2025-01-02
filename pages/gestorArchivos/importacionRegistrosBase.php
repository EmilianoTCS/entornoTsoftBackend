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

    //nom Cliente
    if ($fila['nombre Cliente'] === "" || $fila['nombre Cliente'] === null) {
        $str_errorPlantilla = 'Error fila: ' . $numFila . ', campo "nombre Cliente" está vacío o nulo.';
        $bool_errores = true;
        $str_error =  $str_error . $str_errorPlantilla . "\n";
    }
    //dir cliente
    if ($fila['direccion Cliente'] === "" || $fila['direccion Cliente'] === null) {
        $str_errorPlantilla = 'Error fila: ' . $numFila . ', campo "direccion Cliente" está vacío o nulo.';
        $bool_errores = true;
        $str_error =  $str_error . $str_errorPlantilla . "\n";
    }

    //pais cliente
    if ($fila['pais Cliente'] === "" || $fila['pais Cliente'] === null) {
        $str_errorPlantilla = "Error fila: " . $numFila . ", campo 'pais Cliente' está vacío o nulo.";
        $bool_errores = true;
        $str_error =  $str_error . $str_errorPlantilla . "\n";
    }

    //servicio cliente
    if ($fila['servicio Cliente'] === "" || $fila['servicio Cliente'] === null) {
        $str_errorPlantilla = "Error fila: " . $numFila . ", campo 'servicio Cliente' está vacío o nulo.";
        $bool_errores = true;
        $str_error =  $str_error . $str_errorPlantilla . "\n";
    }

    //nomContacto
    if ($fila['nombre contacto cliente'] === "" || $fila['nombre contacto cliente'] === null) {
        $str_errorPlantilla = "Error fila: " . $numFila . ", campo 'nombre contacto cliente' está vacío o nulo.";
        $bool_errores = true;
        $str_error =  $str_error . $str_errorPlantilla . "\n";
    }

    //correo contacto 1
    if ($fila['correo contacto 1 cliente'] === "" || $fila['correo contacto 1 cliente'] === null || !filter_var($fila['correo contacto 1 cliente'], FILTER_VALIDATE_EMAIL)) {
        $str_errorPlantilla = "Error fila: " . $numFila . ", campo 'correo contacto 1 cliente' está vacío o nulo.";
        $bool_errores = true;
        $str_error =  $str_error . $str_errorPlantilla . "\n";
    }

    //correo contacto 2
    if (!empty($fila['correo contacto 2 cliente']) && !filter_var($fila['correo contacto 2 cliente'], FILTER_VALIDATE_EMAIL)) {
        $str_errorPlantilla = "Error fila: " . $numFila . ", campo 'correo contacto 2 cliente' está vacío o nulo.";
        $bool_errores = true;
        $str_error =  $str_error . $str_errorPlantilla . "\n";
    }

    //fecha ini vigencia contacto
    if ($fila['fecha inicio vigencia contacto'] === "" || $fila['fecha inicio vigencia contacto'] === null) {
        $str_errorPlantilla = "Error fila: " . $numFila . ", campo 'fecha inicio vigencia contacto' está vacío o nulo.";
        $bool_errores = true;
        $str_error =  $str_error . $str_errorPlantilla . "\n";
    }

    // fecha fin vigencia contacto
    if ($fila['fecha fin vigencia contacto'] === "" || $fila['fecha fin vigencia contacto'] === null) {
        $str_errorPlantilla = "Error fila: " . $numFila . ", campo 'fecha fin vigencia contacto' está vacío o nulo.";
        $bool_errores = true;
        $str_error =  $str_error . $str_errorPlantilla . "\n";
    }

    if ($fila['correo contacto 2 cliente'] === "" || $fila['correo contacto 2 cliente'] === null) {
        $str_errorPlantilla = "Error fila: " . $numFila . ", campo 'correo contacto 2 cliente' está vacío o nulo.";
        $bool_errores = true;
        $str_error =  $str_error . $str_errorPlantilla . "\n";
    }

    // nombre Proyecto
    if ($fila['nombre Proyecto'] === "" || $fila['nombre Proyecto'] === null) {
        $str_errorPlantilla = "Error fila: " . $numFila . ", campo 'nombre Proyecto' está vacío o nulo.";
        $bool_errores = true;
        $str_error =  $str_error . $str_errorPlantilla . "\n";
    }

    // fecha Inicio proyecto
    if ($fila['fecha Inicio proyecto'] === "" || $fila['fecha Inicio proyecto'] === null) {
        $str_errorPlantilla = "Error fila: " . $numFila . ", campo 'fecha Inicio proyecto' está vacío o nulo.";
        $bool_errores = true;
        $str_error =  $str_error . $str_errorPlantilla . "\n";
    }

    // fecha fin proyecto
    if ($fila['fecha fin proyecto'] === "" || $fila['fecha fin proyecto'] === null) {
        $str_errorPlantilla = "Error fila: " . $numFila . ", campo 'fecha fin proyecto' está vacío o nulo.";
        $bool_errores = true;
        $str_error =  $str_error . $str_errorPlantilla . "\n";
    }

    // tipo de proyecto
    if ($fila['tipo de proyecto (llave en mano o eshopping)'] === "" || $fila['tipo de proyecto (llave en mano o eshopping)'] === null || !preg_match('/^(LLAVE EN MANO|ESHOPPING|)$/i', strtoupper($fila['tipo de proyecto (llave en mano o eshopping)']))) {
        $str_errorPlantilla = "Error fila: " . $numFila . ", campo 'tipo de proyecto (llave en mano o eshopping)' está vacío, nulo o no contiene los valores 'LLAVE EN MANO' o 'ESHOPPING'.";
        $bool_errores = true;
        $str_error =  $str_error . $str_errorPlantilla . "\n";
    }

    // presupuesto total
    if (trim($fila['presupuesto total']) === "" || $fila['presupuesto total'] === null || !preg_match('/^\d{0,9}$/', $fila['presupuesto total'])) {
        $str_errorPlantilla = "Error fila: " . $numFila . ", campo 'presupuesto total' está vacío o nulo o contiene caracteres incorrectos, ingresa solamente valores numéricos.";
        $bool_errores = true;
        $str_error =  $str_error . $str_errorPlantilla . "\n";
    }

    // nombre colaborador
    if ($fila['nombre colaborador'] === "" || $fila['nombre colaborador'] === null) {
        $str_errorPlantilla = "Error fila: " . $numFila . ", campo 'nombre colaborador' está vacío o nulo.";
        $bool_errores = true;
        $str_error =  $str_error . $str_errorPlantilla . "\n";
    }

    // Lider proyecto (si o no)
    if ($fila['Lider proyecto (si o no)'] === "" || $fila['Lider proyecto (si o no)'] === null || !preg_match('/^(SÍ|SI|NO|si|sí|no)$/i', $fila['Lider proyecto (si o no)'])) {
        $str_errorPlantilla = "Error fila: " . $numFila . ", campo 'Lider proyecto (si o no)' está vacío, nulo o contiene formato incorrecto, se espera 'SÍ', 'si', 'NO', 'no'.";
        $bool_errores = true;
        $str_error =  $str_error . $str_errorPlantilla . "\n";
    }

    // correo colaborador
    if ($fila['correo colaborador'] === "" || $fila['correo colaborador'] === null || !filter_var($fila['correo colaborador'], FILTER_VALIDATE_EMAIL)) {
        $str_errorPlantilla = "Error fila: " . $numFila . ", campo 'correo colaborador' está vacío, nulo o el correo es inválido.";
        $bool_errores = true;
        $str_error =  $str_error . $str_errorPlantilla . "\n";
    }


    // pais del colaborador
    if ($fila['pais del colaborador'] === "" || $fila['pais del colaborador'] === null) {
        $str_errorPlantilla = "Error fila: " . $numFila . ", campo 'pais del colaborador' está vacío o nulo.";
        $bool_errores = true;
        $str_error =  $str_error . $str_errorPlantilla . "\n";
    }

    // area colaborador
    if ($fila['area colaborador'] === "" || $fila['area colaborador'] === null) {
        $str_errorPlantilla = "Error fila: " . $numFila . ", campo 'area colaborador' está vacío o nulo.";
        $bool_errores = true;
        $str_error =  $str_error . $str_errorPlantilla . "\n";
    }

    // valor hh colaborador
    if ($fila['valor hh colaborador'] === "" || $fila['valor hh colaborador'] === null || !preg_match('/^\d{0,9}$/', $fila['valor hh colaborador'])) {
        $str_errorPlantilla = "Error fila: " . $numFila . ", campo 'valor hh colaborador' está vacío, nulo o contiene caracteres incorrectos, ingresa solamente valores numéricos.";
        $bool_errores = true;
        $str_error =  $str_error . $str_errorPlantilla . "\n";
    }

    // monetizado
    if ($fila['monetizado'] === "" || $fila['monetizado'] === null || !preg_match('/^(SÍ|SI|NO|si|sí|no)$/i', $fila['monetizado'])) {
        $str_errorPlantilla = "Error fila: " . $numFila . ", campo 'monetizado' está vacío, nulo o contiene formato incorrecto, se espera 'SÍ', 'si', 'NO', 'no'.";
        $bool_errores = true;
        $str_error =  $str_error . $str_errorPlantilla . "\n";
    }

    //telefono colaborador
    if (!empty($fila['telefono colaborador (opcional)']) && preg_match('/^\d{9}$/', $fila['telefono colaborador (opcional)'])) {
        $str_errorPlantilla = "Error fila: " . $numFila . ", campo 'telefono colaborador (opcional)' es inválido o nulo.";
        $bool_errores = true;
        $str_error =  $str_error . $str_errorPlantilla . "\n";
    }
    //telefono contacto

    if (!empty($fila['telefono contacto']) && preg_match('/^\d{9}$/', $fila['telefono contacto'])) {
        $str_errorPlantilla = "Error fila: " . $numFila . ", campo 'telefono contacto' es inválido o nulo. Se esperan valores numéricos.";
        $bool_errores = true;
        $str_error =  $str_error . $str_errorPlantilla . "\n";
    }

    if (trim($fila['cargo colaborador']) === "" || $fila['cargo colaborador'] === null) {
        $str_errorPlantilla = "Error fila: " . $numFila . ", campo 'cargo colaborador' es inválido o nulo. Se esperan valores como 'Dev', 'QA automatizador'.";
        $bool_errores = true;
        $str_error =  $str_error . $str_errorPlantilla . "\n";
    }

    // print_r($str_error);
    // print_r(['errores' => $str_error, 'bool_errores' => $bool_errores, 'Fila' => $fila, 'num' => $numFila]);
    return ['errores' => $str_error, 'bool_errores' => $bool_errores, 'fila' => $fila];
}
function formatearFecha($fechaOriginal)
{
    try {
        // Crear un objeto DateTime desde la fecha original
        $fecha = DateTime::createFromFormat('d/m/Y', $fechaOriginal);

        // Verificar si la fecha fue creada correctamente
        if (!$fecha) {
            throw new Exception("Error al crear el objeto DateTime");
        }

        // Convertir la fecha al formato 'Y-m-d'
        return $fecha->format('Y-m-d');
    } catch (Exception $e) {
        return "Error: " . $e->getMessage();
    }
}

//Recibe la solicitud del archivo
if (isset($_POST)) {
    $archivo = $_FILES['file'];

    if ($archivo['error'] !== UPLOAD_ERR_OK) {
        echo json_encode(['error' => "Error al subir el archivo."]);
        exit;
    }

    $nomDocumento = basename($_FILES['file']['name']);
    $tipo = strtolower(pathinfo($nomDocumento, PATHINFO_EXTENSION));

    if ($tipo !== "csv") {
        echo json_encode([
            'OUT_CODRESULT' => '01',
            'OUT_MJERESULT' => 'El formato del archivo es incorrecto, debe ser .CSV de forma obligatoria.'
        ]);
        exit;
    }

    $resultadoCSV = leerCSV($_FILES['file']['tmp_name']);
    $filas = $resultadoCSV['filas'];
    $encabezados = $resultadoCSV['encabezados'];

    $errores = array();
    $contadorExitosos = 0;
    $contadorFallidos = 0;
    $contadorTotales = 0;

    foreach ($filas as $i => $fila) {
        $contadorTotales++;
        $resultadoValidarCampos = validarFormatoCampos($fila, $i + 2);

        if ($resultadoValidarCampos['bool_errores']) {
            $errores[] = $resultadoValidarCampos['errores'];
            $contadorFallidos++;
            continue;
        }

        $fila = $resultadoValidarCampos['fila'];

        // Prepare the query with placeholders
        $query = "CALL SP_ihh_cargaDatosBase(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, @p0, @p1);";
        $query .= "SELECT @p0 AS OUT_CODRESULT, @p1 AS OUT_MJERESULT;";

        // Prepare the statement
        $stmt = mysqli_prepare($conection, $query);
        if (!$stmt) {
            $errores[] = "Error preparing statement: " . mysqli_error($conection);
            $contadorFallidos++;
            continue;
        }

        // Bind parameters
        mysqli_stmt_bind_param(
            $stmt,
            "ssssssssssssssssssssssss",
            $fila['nombre Cliente'],
            $fila['direccion Cliente'],
            $fila['pais Cliente'],
            $fila['servicio Cliente'],
            $fila['nombre contacto cliente'],
            $fila['correo contacto 1 cliente'],
            $fila['correo contacto 2 cliente'],
            $fila['telefono contacto'],
            formatearFecha($fila['fecha inicio vigencia contacto']),
            formatearFecha($fila['fecha fin vigencia contacto']),
            $fila['nombre Proyecto'],
            formatearFecha($fila['fecha Inicio proyecto']),
            formatearFecha($fila['fecha fin proyecto']),
            $fila['tipo de proyecto (llave en mano o eshopping)'],
            $fila['presupuesto total'],
            $fila['nombre colaborador'],
            $fila['Lider proyecto (si o no)'],
            $fila['correo colaborador'],
            $fila['cargo colaborador'],
            $fila['telefono colaborador (opcional)'],
            $fila['pais del colaborador'],
            $fila['area colaborador'],
            $fila['valor hh colaborador']
        );

        // Execute the statement
        if (mysqli_stmt_execute($stmt)) {
            $result = mysqli_stmt_get_result($stmt);
            $row = mysqli_fetch_assoc($result);
            if ($row['OUT_CODRESULT'] !== '00') {
                $errores[] = "Error en fila " . ($i + 2) . ": " . $row['OUT_MJERESULT'];
                $contadorFallidos++;
            } else {
                $contadorExitosos++;
            }
            mysqli_free_result($result);
        } else {
            $errores[] = "Error executing query for row " . ($i + 2) . ": " . mysqli_stmt_error($stmt);
            $contadorFallidos++;
        }

        mysqli_stmt_close($stmt);
    }

    echo json_encode([
        'cantExitosos' => $contadorExitosos,
        'cantFallidos' => $contadorFallidos,
        'cantTotal' => $contadorTotales,
        'errores' => $errores,
    ]);
}

mysqli_close($conection);
