<?php

include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['listadoAlumnos'])) {

    $data = json_decode(file_get_contents("php://input"));
    $data->num_boton = "" || null ? $num_boton = 1 : $num_boton = $data->num_boton;
    $data->idPais = "" || null ? $idPais = null : $idPais = $data->num_boidPaiston;
    $data->idServicio = "" || null ? $idServicio = null : $idServicio = $data->idServicio;
    $data->idArea = "" || null ? $idArea = null : $idArea = $data->idArea;
    $data->idCargo = "" || null ? $idCargo = null : $idCargo = $data->idCargo;
    $data->cantidadPorPagina = "" || null ? $cantidadPorPagina = 10 : $cantidadPorPagina = $data->cantidadPorPagina;
  
    
    $inicio = ($num_boton - 1) * $cantidadPorPagina;


    $query = "CALL SP_listadoAlumnos('$inicio', '$cantidadPorPagina', '$idPais','$idServicio', '$idArea', '$idCargo')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }
    $json = array();
    if (mysqli_num_rows($result) > 0) {

        while ($row = mysqli_fetch_array($result)) {
            $json[] = array(
                'idAlumno' => $row['idAlumno'],
                'nomAlumno' => $row['UPPER(alum.nomAlumno)'],
                'correoAlumno' => $row['UPPER(alum.correoAlumno)'],
                'telefonoAlumno' => $row['UPPER(alum.telefonoAlumno)'],
                'nomServicio' => $row['UPPER(serv.nomServicio)'],
                'nomArea' => $row['UPPER(ar.nomArea)'],
                'nomPais' => $row['UPPER(pa.nomPais)'],
                'nomCargo' => $row['UPPER(car.nomCargo)']
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
            'idAlumno' => 'empty / vacio',
            'nomAlumno' => 'empty / vacio',
            'correoAlumno' => 'empty / vacio',
            'telefonoAlumno' => 'empty / vacio',
            'nomServicio' => 'empty / vacio',
            'nomArea' => 'empty / vacio',
            'nomPais' => 'empty / vacio',
            'nomCargo' => 'empty / vacio',
        );

        $FN_cantPaginas = cantPaginas(1, $cantidadPorPagina);
        $jsonstring = json_encode([
            'datos' => $json,
            'paginador' => $FN_cantPaginas
        ]);
        echo $jsonstring;
    }
}
