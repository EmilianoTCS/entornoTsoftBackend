<?php

include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['listadoNotaExamen'])) {
    $data = json_decode(file_get_contents("php://input"));
    $data->num_boton = "" || null ? $num_boton = 1 : $num_boton = $data->num_boton;
    $data->idRamoExamen = "" || null ? $idRamoExamen = null : $idRamoExamen = $data->idRamoExamen;
    $data->cantidadPorPagina = "" || null ? $cantidadPorPagina = 10 : $cantidadPorPagina = $data->cantidadPorPagina;
    $inicio = ($num_boton - 1) * $cantidadPorPagina;
    $json = array();


    $query = "CALL SP_listadoNotaExamen('$inicio', '$cantidadPorPagina', '$idRamoExamen')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    if (mysqli_num_rows($result) > 0) {
        while ($row = mysqli_fetch_array($result)) {
            $json[] = array(
                'idNotaExamen' => $row['idNotaExamen'],
                'notaExamen' => $row['notaExamen'],
                'apruebaExamen' => $row['apruebaExamen'],
                'nomExamen' => $row['UPPER(ramoEx.nomExamen)'],
                'idCursoAlumno' => $row['idCursoAlumno'],
                'nomEmpleado' => $row['nomEmpleado'],
                'nomCurso' => $row['nomCurso'],
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
                'idNotaExamen' => 'empty / vacio',
                'notaExamen' => 'empty / vacio',
                'apruebaExamen' => 'empty / vacio',
                'nomExamen' => 'empty / vacio',
                'idCursoAlumno' => 'empty / vacio',
                'nomEmpleado' => 'empty / vacio',
                'nomCurso' => 'empty / vacio'
            );

        $FN_cantPaginas = cantPaginas(1, $cantidadPorPagina);
        $jsonstring = json_encode([
            'datos' => $json,
            'paginador' => $FN_cantPaginas
        ]);
        echo $jsonstring;
    }
}
