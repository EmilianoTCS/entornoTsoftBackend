<?php

include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['ihh_listadoTodaInfoIHH'])) {
    $query = "CALL SP_todaInfoIHH()";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }
    if (mysqli_num_rows($result) > 0) {

        while ($row = mysqli_fetch_array($result)) {
            $datosTabla[] = array(
                'Proyecto' => $row['nomProyecto'],
                'FechaInicio' => $row['fechaInicio'],
                'FechaFin' => $row['fechaFin'],
                'PptoTotal' => $row['presupuestoTotal'],
                'Mes' => $row['mes'],
                'PptoMen' => $row['presupuestoMensual'],
                'CostoMen' => $row['costoMensual'],
                'SaldoMen' => $row['saldoMensual'],
                'SaldoPpto' => $row['saldoPresupuesto'],
                'PptoAcumulado' => $row['presupuestoAcumulado'],
                'Colaborador' => $row['nomEmpleado'],
                'Elemento' => $row['nomElemento'],
                'CantHH' => $row['cantHorasPeriodo'],
                'ValorHH' => $row['valorHH'],
                'CostoHH' => $row['costoHH'],
                'Costeado' => $row['empCosteado'],
                'Monetizado' => $row['empMonetizado'],
            );
        }

        $jsonstring = json_encode($datosTabla);
        echo $jsonstring;
    } else {
        $datosTabla[] = array(
            'Proyecto' => 'empty / vacio',
            'FechaInicio' => 'empty / vacio',
            'FechaFin' => 'empty / vacio',
            'PptoTotal' => 'empty / vacio',
            'Mes' => 'empty / vacio',
            'PptoMen' => 'empty / vacio',
            'CostoMen' => 'empty / vacio',
            'SaldoMen' => 'empty / vacio',
            'SaldoPpto' => 'empty / vacio',
            'PptoAcumulado' => 'empty / vacio',
            'Colaborador' => 'empty / vacio',
            'Elemento' => 'empty / vacio',
            'CantHH' => 'empty / vacio',
            'ValorHH' => 'empty / vacio',
            'CostoHH' => 'empty / vacio',
            'Costeado' => 'empty / vacio',
            'Monetizado' => 'empty / vacio',
        );
        $jsonstring = json_encode($datosTabla);
        echo $jsonstring;
    }
}
