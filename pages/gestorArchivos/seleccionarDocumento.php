<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['nomTabla']) && isset($_GET['idRegistro'])) {
    $nomTabla = $_GET['nomTabla'];
    $idRegistro = $_GET['idRegistro'];

    $query = "CALL SP_seleccionarDocumento('$nomTabla', '$idRegistro')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    if (mysqli_num_rows($result) === 1) {
        $fila = mysqli_fetch_assoc($result);

        $archivo = $fila['nomDocumento'];
        $ruta = $fila['ruta'];

        if (file_exists($ruta . $archivo)) {
            header('Content-Type: application/octet-stream');
            header('Content-Disposition: attachment; filename="' . $archivo . '"');
            readfile($ruta . $archivo);
            exit; // Finaliza la ejecución después de enviar el archivo
        } else {
            echo json_encode("No existe el archivo.");
        }
    } else {
        echo json_encode("El archivo no existe en la base de datos");
    }
} else {
    echo json_encode("Error: Faltan parámetros");
}
?>
