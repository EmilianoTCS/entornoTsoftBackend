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
    $data->cantidadPorPagina = "" || null ? $cantidadPorPagina = 10 : $cantidadPorPagina = $data->cantidadPorPagina;
    $inicio = ($num_boton - 1) * $cantidadPorPagina;

    $query = "CALL SP_ihh_listadoAcop('$inicio', '$cantidadPorPagina')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();

    if (mysqli_num_rows($result) > 0) {
        while ($row = mysqli_fetch_array($result)) {

            $json[] = array(
                'idAcop' => $row['idAcop'],
                'nomAcop' => $row['nomAcop'],
                'numAcop' => $row['numAcop'],
                'valorUSD' => $row['valorUSD'],
                'fechaIni' => $row['fechaIni'],
                'fechaFin' => $row['fechaFin'],
                'fechaValorUSD' => $row['fechaValorUSD'],
                'presupuestoTotal' => $row['presupuestoTotal'],
                'presupuestoTotalPesos' => $row['presupuestoTotalPesos'],
                'presupuestoGeneral' => $row['presupuestoGeneral'],
                'presupuestoGeneralPesos' => $row['presupuestoGeneralPesos'],
                'presupuestoMiscelaneo' => $row['presupuestoMiscelaneo'],
                'presupuestoMiscelaneoPesos' => $row['presupuestoMiscelaneoPesos'],
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
            'idAcop' => 'empty / vacio',
            'nomAcop' => 'empty / vacio',
            'valorUSD' => '0',
            'fechaIni' => 'empty / vacio',
            'fechaFin' => 'empty / vacio',
            'presupuestoTotal' => 'empty / vacio'
        );

        $FN_cantPaginas = cantPaginas(1, $cantidadPorPagina);
        $jsonstring = json_encode([
            'datos' => $json,
            'paginador' => $FN_cantPaginas
        ]);
        echo $jsonstring;
    }
}
