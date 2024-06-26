<?php
include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['ihh_listadoAcop'])) {
    $data = json_decode(file_get_contents("php://input"));
    $data->num_boton = "" || null ? $num_boton = 1 : $num_boton = $data->num_boton;
    $data->idProyecto = "" || null ? $idProyecto = null : $idProyecto = $data->idProyecto;
    $data->cantidadPorPagina = "" || null ? $cantidadPorPagina = 10 : $cantidadPorPagina = $data->cantidadPorPagina;
    $inicio = ($num_boton - 1) * $cantidadPorPagina;

    $query = "CALL SP_ihh_listadoAcop('$idProyecto', '$inicio', '$cantidadPorPagina')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    $jsonUF = array();

    if (mysqli_num_rows($result) > 0) {
        while ($row = mysqli_fetch_array($result)) {
            // $hoy = new DateTime();
            // $hoyFormat = $hoy->format('d-m-Y');
            // $fechaFin = new DateTime($row['fechaFinProy']);
            // $fechaFinFormat = $fechaFin->format('d-m-Y');

            // if ($hoy < $fechaFin && $row['fechaFinProy'] !== null) {
            //     $apiUrl = 'https://mindicador.cl/api/uf/' . $hoyFormat;
            //     $jsonUF = json_decode(file_get_contents($apiUrl));
            // } else {
            //     $apiUrl = 'https://mindicador.cl/api/uf/' . $fechaFinFormat;
            //     $jsonUF = json_decode(file_get_contents($apiUrl));
            // }

            $json[] = array(
                'idAcop' => $row['idAcop'],
                'idProyecto' => $row['idProyecto'],
                'nomProyecto' => $row['nomProyecto'],
                'fechaIniProy' => $row['fechaIniProy'],
                'fechaFinProy' => $row['fechaFinProy'],
                'presupuestoTotal' => $row['presupuestoTotal'],
                'presupuestoMen' => $row['presupuestoMen'],
                'cantTotalMeses' => $row['cantTotalMeses'],
                'mesesRevisados' => $row['mesesRevisados'],
                'mesesActualRevisado' => $row['mesesActualRevisado'],
                'saldoRestante' => $row['saldoRestante'],
                // 'valorUF' => $jsonUF->serie[0]->valor
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
            'idProyecto' => 'empty / vacio',
            'nomProyecto' => 'empty / vacio',
            'fechaIniProy' => 'empty / vacio',
            'fechaFinProy' => 'empty / vacio',
            'presupuestoTotal' => 'empty / vacio',
            'presupuestoMen' => 'empty / vacio',
            'cantTotalMeses' => 'empty / vacio',
            'mesesRevisados' => 'empty / vacio',
            'saldoRestante' => 'empty / vacio',
            'mesesActualRevisado' => 'empty / vacio'
        );

        $FN_cantPaginas = cantPaginas(1, $cantidadPorPagina);
        $jsonstring = json_encode([
            'datos' => $json,
            'paginador' => $FN_cantPaginas
        ]);
        echo $jsonstring;
    }
}
