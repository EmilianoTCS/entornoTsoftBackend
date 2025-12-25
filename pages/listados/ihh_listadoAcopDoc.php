<?php
include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['ihh_listadoAcopDoc'])) {
    $data = json_decode(file_get_contents("php://input"));
    $data->idAcop = "" || null ? $idAcop = 0 : $idAcop = $data->idAcop;
    $data->num_boton = "" || null ? $num_boton = 1 : $num_boton = $data->num_boton;
    $data->cantidadPorPagina = "" || null ? $cantidadPorPagina = 10 : $cantidadPorPagina = $data->cantidadPorPagina;
    $inicio = ($num_boton - 1) * $cantidadPorPagina;

    $query = "CALL SP_ihh_listadoAcopDoc('$idAcop', '$inicio', '$cantidadPorPagina')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();

    if (mysqli_num_rows($result) > 0) {
        while ($row = mysqli_fetch_array($result)) {
            // Codificar el BLOB en base64
            $archivoBase64 = base64_encode($row['archivo']);
            
            $json[] = array(
                'idAcopDoc' => $row['idAcopDoc'],
                'nomDoc' => $row['nomDoc'],
                'tipoDoc' => $row['tipoDoc'],
                'archivo' => $archivoBase64, // Enviar el archivo como base64
                'idAcop' => $row['idAcop'],
                'nomAcop' => $row['nomAcop']
            );
            $FN_cantPaginas = cantPaginas($row['temp_cantRegistros'], $cantidadPorPagina);
        }

        $jsonstring = json_encode([
            'datos' => $json,
            'paginador' => $FN_cantPaginas
        ]);
        echo $jsonstring;
    } else {
        $json[] = array(
            'idAcopDoc' => 'empty / vacio',
            'nomDoc' => 'empty / vacio',
            'tipoDoc' => 'empty / vacio',
            'archivo' => 'empty / vacio',
            'idAcop' => 'empty / vacio',
            'nomAcop' => 'empty / vacio',
        );

        $FN_cantPaginas = cantPaginas(1, $cantidadPorPagina);
        $jsonstring = json_encode([
            'datos' => $json,
            'paginador' => $FN_cantPaginas
        ]);
        echo $jsonstring;
    }
}
