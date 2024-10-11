<?php
include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['AF_listadoEmpleadoRamo'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idCurso = $data->idCurso;
    $data->num_boton = "" || null ? $num_boton = 1 : $num_boton = $data->num_boton;
    $data->cantidadPorPagina = "" || null ? $cantidadPorPagina = 10 : $cantidadPorPagina = $data->cantidadPorPagina;
    $inicio = ($num_boton - 1) * $cantidadPorPagina;

    $query = "CALL SP_AF_listadoEmpleadoRamo('$idCurso', '$inicio', '$cantidadPorPagina')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();

    if (mysqli_num_rows($result) > 0) {
        while ($row = mysqli_fetch_array($result)) {
            $json[] = array(
                'idCursoAlumnoRamo' => $row['idCursoAlumnoRamo'],
                'nomEmpleado' => $row['nomEmpleado'],
                'nomRamo' => $row['nomRamo'],
                'porcAprobacion' => $row['porcAprobacion'],
                'porcParticipacion' => $row['porcParticipacion'],
                'porcAsistencia' => $row['porcAsistencia'],
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
            'idCursoAlumnoRamo' => 'empty / vacio',
            'nomEmpleado' => 'empty / vacio',
            'nomRamo' => '0',
            'porcAprobacion' => 'empty / vacio',
            'porcParticipacion' => 'empty / vacio',
            'porcAsistencia' => 'empty / vacio'
        );

        $FN_cantPaginas = cantPaginas(1, $cantidadPorPagina);
        $jsonstring = json_encode([
            'datos' => $json,
            'paginador' => $FN_cantPaginas
        ]);
        echo $jsonstring;
    }
}
