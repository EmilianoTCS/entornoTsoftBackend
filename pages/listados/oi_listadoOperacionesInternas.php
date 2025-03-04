<?php
include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['oi_listadoOperacionesInternas'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idEmpleado = $data->usuario;
    $idCargo = $data->cargo;
    $disponibilidad = $data->disponibilidad;
    $data->num_boton = "" || null ? $num_boton = 1 : $num_boton = $data->num_boton;
    $data->cantidadPorPagina = "" || null ? $cantidadPorPagina = 10 : $cantidadPorPagina = $data->cantidadPorPagina;
    $inicio = ($num_boton - 1) * $cantidadPorPagina;


    

    $query = "CALL SP_oi_listadoOperacionesInternas('$idEmpleado','$idCargo','$disponibilidad','$inicio', '$cantidadPorPagina')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();

    if (mysqli_num_rows($result) > 0) {
        while ($row = mysqli_fetch_array($result)) {

            $json[] = array(
                'nomEmpleado' => $row['nomEmpleado'],
                'idEmpleado' => $row['idEmpleado'],
                'idCargo' => $row['idCargo'],
                'nomCliente' => $row['nomCliente'],
                'idEstadoColaborador' => $row['idEstadoColaborador'],
                'idElementoImp' => $row['idElementoImp'],
                'nomCargo' => $row['nomCargo'],
                'nomCliente' => $row['nomCliente'],
                'idCliente' => $row['idCliente'],
                'porcAprobEDD' => $row['porcAprobEDD'],
                'disponibilidad' => $row['disponibilidad'],
                'nomElemento' => $row['nomElemento'],
                'fechaIni' => $row['fechaIni'],
                'fechaFin' => $row['fechaFin'],
                'observaciones' => $row['observaciones'],
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
            'nomEmpleado' => 'empty / vacio',
            'idEmpleado' => 'empty / vacio',
            'idCargo' => 'empty / vacio',
            'nomCliente' => 'empty / vacio',
            'idEstadoColaborador' => 'empty / vacio',
            'idElementoImp' => 'empty / vacio',
            'nomCargo' => 'empty / vacio',
            'nomCliente' => 'empty / vacio',
            'idCliente' => 'empty / vacio',
            'porcAprobEDD' => 'empty / vacio',
            'disponibilidad' => 'empty / vacio',
            'nomElemento' => 'empty / vacio',
            'fechaIni' => 'empty / vacio',
            'fechaFin' => 'empty / vacio',
            'observaciones' => 'empty / vacio',
        );
        $FN_cantPaginas = cantPaginas(1, $cantidadPorPagina);
        $jsonstring = json_encode([
            'datos' => $json,
            'paginador' => $FN_cantPaginas
        ]);
        echo $jsonstring;
    }
}
