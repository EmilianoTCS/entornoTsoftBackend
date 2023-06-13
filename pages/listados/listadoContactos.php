<?php

include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['listadoContactos'])) {
    $data = json_decode(file_get_contents("php://input"));
    $data->num_boton = "" || null ? $num_boton = 1 : $num_boton = $data->num_boton;
    $data->idServicio = "" || null ? $idServicio = null : $num_boton = $data->idServicio;
    $data->cantidadPorPagina = "" || null ? $cantidadPorPagina = 10 : $cantidadPorPagina = $data->cantidadPorPagina;
    $inicio = ($num_boton - 1) * $cantidadPorPagina;


    $query = "CALL SP_listadoContactos('$inicio', '$cantidadPorPagina', '$idServicio')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    if (mysqli_num_rows($result) > 0) {

        while ($row = mysqli_fetch_array($result)) {
            $json[] = array(
                'idContacto' => $row['idContacto'],
                'nomContacto' => $row['UPPER(con.nomContacto)'],
                'correoContacto' => $row['UPPER(con.correoContacto)'],
                'telefonoContacto' => $row['telefonoContacto'],
                'fechaIni' => $row['fechaIni'],
                'fechaFin' => $row['fechaFin'],
                'nomServicio' => $row['UPPER(serv.nomServicio)']

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
            'idContacto' => 'empty / vacio',
            'nomContacto' => 'empty / vacio',
            'correoContacto' => 'empty / vacio',
            'telefonoContacto' => 'empty / vacio',
            'fechaIni' => 'empty / vacio',
            'fechaFin' => 'empty / vacio',
            'nomServicio' => 'empty / vacio'
        );

        $FN_cantPaginas = cantPaginas(1, $cantidadPorPagina);
        $jsonstring = json_encode([
            'datos' => $json,
            'paginador' => $FN_cantPaginas
        ]);
        echo $jsonstring;
    }
}
