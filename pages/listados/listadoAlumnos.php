<?php

include("../../model/conexion.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['listadoAlumnos'])) {

    $data = json_decode(file_get_contents("php://input"));
    $data->num_boton = "" || null ? $num_boton = 1 : $num_boton = $data->num_boton;
    $data->cantidadPorPagina = "" || null ? $cantidadPorPagina = 10 : $cantidadPorPagina = $data->cantidadPorPagina;
    $inicio = ($num_boton - 1) * $cantidadPorPagina;


    $query = "CALL SP_listadoAlumnos('$inicio', '$cantidadPorPagina')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    while ($row = mysqli_fetch_array($result)) {
        $json[] = array(
            'idAlumno' => $row['idAlumno'],
            'nomAlumno' => $row['nomAlumno'],
            'correoAlumno' => $row['correoAlumno'],
            'telefonoAlumno' => $row['telefonoAlumno'],
            'nomServicio' => $row['nomServicio'],
            'nomArea' => $row['nomArea'],
            'nomPais' => $row['nomPais'],
            'nomCargo' => $row['nomCargo']
        );
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
}
