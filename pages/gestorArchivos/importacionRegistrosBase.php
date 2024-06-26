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
function formatearFecha($fechaOriginal) {
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

                    $nombreCliente = $fila['nombre Cliente'];
                    $direccionCliente = $fila['direccion Cliente'];
                    $paisCliente = $fila['pais Cliente'];
                    $servicioCliente = $fila['servicio Cliente'];
                    $nombreContactoCliente = $fila['nombre contacto cliente'];
                    $telefonoContacto = $fila['telefono contacto'];
                    $correoContacto1Cliente = $fila['correo contacto 1 cliente'];
                    $correoContacto2Cliente = $fila['correo contacto 2 cliente'];
                    $fechaInicioVigenciaContacto = formatearFecha($fila['fecha inicio vigencia contacto']);
                    $fechaFinVigenciaContacto = formatearFecha($fila['fecha fin vigencia contacto']);
                    $nombreProyecto = $fila['nombre Proyecto'];
                    $fechaInicioProyecto = formatearFecha($fila['fecha Inicio proyecto']);
                    $fechaFinProyecto = formatearFecha($fila['fecha fin proyecto']);
                    $tipoDeProyecto = $fila['tipo de proyecto (llave en mano o eshopping)'];
                    $presupuestoTotal = $fila['presupuesto total'];
                    $nombreColaborador = $fila['nombre colaborador'];
                    $liderProyecto = $fila['Lider proyecto (si o no)'];
                    $correoColaborador = $fila['correo colaborador'];
                    $telefonoColaboradorOpcional = $fila['telefono colaborador (opcional)'];
                    $paisDelColaborador = $fila['pais del colaborador'];
                    $cargoColaborador = $fila['cargo colaborador'];
                    $areaColaborador = $fila['area colaborador'];
                    $valorHHColaborador = $fila['valor hh colaborador'];
                    $monetizado = $fila['monetizado'];

                    // print_r("nombreContactoCliente: " . $nombreContactoCliente ."\n");
                    // print_r("telefonoContacto: " . $telefonoContacto ."\n");
                    // print_r("correoContacto1Cliente: " . $correoContacto1Cliente ."\n");
                    // print_r("correoContacto2Cliente: " . $correoContacto2Cliente ."\n");
                    // print_r("fechaInicioVigenciaContacto: " . $fechaInicioVigenciaContacto ."\n");
                    // print_r("fechaFinVigenciaContacto: " . $fechaFinVigenciaContacto ."\n");
                    // print_r("valorHHColaborador: " . $valorHHColaborador ."\n");
                    // print_r("liderProyecto: " . $liderProyecto ."\n");




                    // Ejecución de QUERY
                    $query = "CALL SP_ihh_cargaDatosBase(
                        '$nombreCliente',
                        '$direccionCliente',
                        '$paisCliente',
                        '$servicioCliente',
                        '$nombreContactoCliente',
                        '$correoContacto1Cliente',
                        '$correoContacto2Cliente',
                        '$telefonoContacto',
                        '$fechaInicioVigenciaContacto',
                        '$fechaFinVigenciaContacto',
                        '$nombreProyecto',
                        '$fechaInicioProyecto',
                        '$fechaFinProyecto',
                        '$tipoDeProyecto',
                        '$presupuestoTotal',
                        '$nombreColaborador',
                        '$liderProyecto',
                        '$correoColaborador',
                        '$cargoColaborador',
                        '$telefonoColaboradorOpcional',
                        '$paisDelColaborador',
                        '$areaColaborador',
                        '$valorHHColaborador',

                    @p0, @p1)";
                    $result = mysqli_query($conection, $query);
                    if (!$result) {
                        die('Query Failed' . mysqli_error($conection));
                    }



                    // $json = array();
                    // while ($row = mysqli_fetch_array($result)) {
                    //     $json[] = array(
                    //         'OUT_CODRESULT' => $row['OUT_CODRESULT'],
                    //         'OUT_MJERESULT' => $row['OUT_MJERESULT'],
                    //         'idServicio' => $row['int_idServicio']
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
