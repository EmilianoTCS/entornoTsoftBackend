<?php

include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['listadoRamos'])) {

    $data = json_decode(file_get_contents("php://input"));
    $data->num_boton = "" || null ? $num_boton = 1 : $num_boton = $data->num_boton;
    $data->idCurso = "" || null ? $idCurso = null : $idCurso = $data->idCurso;
    $data->cantidadPorPagina = "" || null ? $cantidadPorPagina = 10 : $cantidadPorPagina = $data->cantidadPorPagina;
    $inicio = ($num_boton - 1) * $cantidadPorPagina;


    $query = "CALL SP_listadoRamos('$inicio', '$cantidadPorPagina', '$idCurso')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    if (mysqli_num_rows($result) > 0) {

    while ($row = mysqli_fetch_array($result)) {
        $json[] = array(
            'idRamo' => $row['idRamo'],
            'codRamo' => $row['UPPER(ram.codRamo)'],
            'nomRamo' => $row['UPPER(ram.nomRamo)'],
            'tipoRamo' => $row['UPPER(ram.tipoRamo)'],
            'tipoRamoHH' => $row['UPPER(ram.tipoRamoHH)'],
            'duracionRamoHH' => $row['duracionRamoHH'],
            'cantSesionesRamo' => $row['cantSesionesRamo'],
            'nomCurso' => $row['UPPER(cur.nomCurso)']
        );

            $FN_cantPaginas = cantPaginas($row['@temp_cantRegistros'], $cantidadPorPagina);
     
    }
    $jsonstring = json_encode([
        'datos' => $json,
        'paginador' => $FN_cantPaginas
    ]);
    echo $jsonstring;
    } else {
        $json[] = array(
            'idRamo' => 'empty / vacio',
            'codRamo' => 'empty / vacio',
            'nomRamo' => 'empty / vacio',
            'tipoRamo' => 'empty / vacio',
            'tipoRamoHH' => 'empty / vacio',
            'duracionRamoHH' => 'empty / vacio',
            'cantSesionesRamo' => 'empty / vacio',
            'nomCurso' => 'empty / vacio',

        );

        $FN_cantPaginas = cantPaginas(1, $cantidadPorPagina);
        $jsonstring = json_encode([
            'datos' => $json,
            'paginador' => $FN_cantPaginas
        ]);
        echo $jsonstring;
    }
}
