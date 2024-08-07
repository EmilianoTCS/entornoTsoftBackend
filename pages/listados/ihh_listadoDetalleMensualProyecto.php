<?php

include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['ihh_listadoDetalleMensualProyecto'])) {
    $data = json_decode(file_get_contents("php://input"));
    $data->idProyecto = "" || null ? $idProyecto = null : $idProyecto = $data->idProyecto;
    $data->mes = "" || null ? $mes = null : $mes = $data->mes;

    $query = "CALL SP_ihh_detalleMensualProyecto('$idProyecto', '$mes')";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $datosResumen = array();
    $datosTabla = array();
    if (mysqli_num_rows($result) > 0) {

        while ($row = mysqli_fetch_array($result)) {
            $datosTabla[] = array(
                'idImpugnacionEmp' => $row['idImpugnacionEmp'],
                'idEmpleado' => $row['idEmpleado'],
                'cantHorasPeriodo' => $row['cantHorasPeriodo'],
                'cantHorasExtra' => $row['cantHorasExtra'],
                'nomEmpleado' => $row['nomEmpleado'],
                'valorHH' => $row['valorHH'],
                'idElemento' => $row['idElemento'],
                'nomElemento' => $row['nomElemento'],
                'idPeriodo' => 1,
                // 'idAcop' => $row['idAcop'],
                'idRandom' => uniqid(),
            );
            $datosResumen[] = array(
                'idProyecto' => $row['idProyecto'],
                'nomProyecto' => $row['nomProyecto'],
                'presupuestoTotal' => $row['presupuestoTotal'],
                // 'cantTotalMeses' => $row['cantTotalMeses'],
                'fechaIniProy' => $row['fechaIniProy'],
                'fechaFinProy' => $row['fechaFinProy'],
                // 'idAcop' => $row['idAcop'],
                'presupuestoMensual' => $row['presupuestoMensual'],
                'presupuestoAcumulado' => $row['presupuestoAcumulado'],
                'costoMensual' => $row['costoMensual'],
                'saldoMensual' => $row['saldoMensual'],
                'saldoPresupuesto' => $row['saldoPresupuesto'],
                'idresumenperproy' => $row['idresumenperproy'],
                'mes' => $row['mes'],
            );
        }
 
        $jsonstring = json_encode([
            'datosResumen' => $datosResumen,
            'datosTabla' => $datosTabla
        ]);
        echo $jsonstring;
    } else {
        $datosTabla[] = array(
            'idImpugnacionEmp' => null,
            'idEmpleado' => null,
            'cantHorasPeriodo' => null,
            'cantHorasExtra' => null,
            'valorHHImp' => null,
            'nomEmpleado' => null,
            'valorHHEmp' => null,
            'idElemento' => null,
            'nomElemento' => null,
            'idRandom' => uniqid(),
        );
        $datosResumen[] = array(
            'idProyecto' => $row['idProyecto'],
            'nomProyecto' => $row['nomProyecto'],
            'presupuestoTotal' => $row['presupuestoTotal'],
            // 'cantTotalMeses' => $row['cantTotalMeses'],
            'fechaIniProy' => $row['fechaIniProy'],
            'fechaFinProy' => $row['fechaFinProy'],
            'presupuestoMensual' => $row['presupuestoMensual'],
            'costoMensual' => $row['costoMensual'],
            'saldoMensual' => $row['saldoMensual'],
            'saldoPresupuesto' => $row['saldoPresupuesto'],
            'idresumenperproy' => $row['idresumenperproy'],
            'mes' => $row['mes'],
            'idPeriodo' => 1,
        );
    }
    $jsonstring = json_encode([
        'datosResumen' => $datosResumen,
        'datosTabla' => $datosTabla
    ]);
}
