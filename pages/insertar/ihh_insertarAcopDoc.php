<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_POST)) {
    
    $file = $_FILES['file']['tmp_name']; // Obtener la ruta temporal del archivo
    $nomDocumento = basename($_FILES['file']['name']); // Nombre del archivo
    $tipo = strtolower(pathinfo($nomDocumento, PATHINFO_EXTENSION)); // Tipo del archivo (extensión)
    $fileContent = addslashes(file_get_contents($file)); // Convertir el archivo a binario (BLOB)

    // Procesar datos JSON
    $data = json_decode($_POST['data']);
    $idAcop = $data->idAcop;
    $usuarioCreacion = $data->usuarioCreacion;

    // Preparar y ejecutar la stored procedure
    $query = "CALL SP_ihh_insertarAcopDoc(
        '$nomDocumento',
        '$tipo',
        '$fileContent',
        '$idAcop',
        '$usuarioCreacion',
        @p0, @p1)";
    
    if (!$result = mysqli_query($conection, $query)) {
        echo json_encode([
            'OUT_CODRESULT' => '01',
            'OUT_MJERESULT' => 'Query Failed: ' . mysqli_error($conection)
        ]);
        exit;
    }

    // Procesar el resultado devuelto por la stored procedure
    $json = array();
    while ($row = mysqli_fetch_assoc($result)) {
        $json[] = array(
            'OUT_CODRESULT' => $row['OUT_CODRESULT'],
            'OUT_MJERESULT' => $row['OUT_MJERESULT']
        );
    }

    echo json_encode($json);
} else {
    echo json_encode([
        'OUT_CODRESULT' => '01',
        'OUT_MJERESULT' => 'No POST data received'
    ]);
}

?>
