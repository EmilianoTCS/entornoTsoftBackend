<?php

include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['ihh_listadoDetalleProyecto'])) {
    $data = json_decode(file_get_contents("php://input"));
    $data->idProyecto = "" || null ? $idProyecto = null : $idProyecto = $data->idProyecto;

    $query = "CALL SP_ihh_detallePresupuestoProyecto('$idProyecto')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    if (mysqli_num_rows($result) > 0) {

        while ($row = mysqli_fetch_array($result)) {
            $json[] = array(
                'idResumenPerProy' => $row['idresumenperproy'],
                'mes' => $row['mes'],
                'presupuestoMensual' => $row['presupuestoMensual'],
                'presupuestoMensualMiscelaneo' => $row['presupuestoMensualMiscelaneo'],
                'presupuestoAcumulado' => $row['presupuestoAcumulado'],
                'presupuestoAcumuladoMiscelaneo' => $row['presupuestoAcumuladoMiscelaneo'],
                'costoMensual' => $row['costoMensual'],
                'costoMensualMiscelaneo' => $row['costoMensualMiscelaneo'],
                'saldoMensual' => $row['saldoMensual'],
                'saldoMensualMiscelaneo' => $row['saldoMensualMiscelaneo'],
                'saldoPresupuesto' => $row['saldoPresupuesto'],
                'saldoPresupuestoMiscelaneo' => $row['saldoPresupuestoMiscelaneo'],
                'nomProyecto' => $row['nomProyecto'],
                'fechaIniProy' => $row['fechaIniProy'],
                'fechaFinProy' => $row['fechaFinProy'],
                'nomProyecto' => $row['nomProyecto'],
                'presupuestoTotal' => $row['presupuestoTotal'],
                'presupuestoTotalMiscelaneo' => $row['presupuestoTotalMiscelaneo'],
                'porc_rentabilidad_reco' => $row['porc_rentabilidad_reco'],
                'porc_rentabilidad_real' => $row['porc_rentabilidad_real'],
            );
        }
        $jsonstring = json_encode($json);
        echo $jsonstring;
    } else {
        $json[] = array(
            'idResumenPerProy' => 'empty / vacio',
            'mes' => 'empty / vacio',
            'presupuestoMensual' => 'empty / vacio',
            'costoMensual' => 'empty / vacio',
            'saldoMensual' => 'empty / vacio',
            'saldoPresupuesto' => 'empty / vacio',
            'nomProyecto' => 'empty / vacio',
            'fechaIniProy' => 'empty / vacio',
            'fechaFinProy' => 'empty / vacio',
            'nomProyecto' => 'empty / vacio',
            'presupuestoTotal' => 'empty / vacio',
            'idRandom' => uniqid(),
            'idAcop' => 'empty / vacio',

        );

        $jsonstring = json_encode($json);
        echo $jsonstring;
    }
}
