<?php
include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['oi_listadoDetalleColab'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idEmpleado = $data->idEmpleado;

    $query = "CALL SP_oi_detalleAsignacionColaborador('$idEmpleado')";
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
                'antiguedad' => $row['antiguedad'],
                'nomCargo' => $row['nomCargo'],
                'idEDDEvalCompetencia' => $row['idEDDEvalCompetencia'],
                'nomCompetencia' => $row['nomCompetencia'],
                'porcentaje' => $row['porcentaje'],
                'diasSinAsig' => $row['diasSinAsig'],
                'nomEmpLider' => $row['nomEmpLider'],
                'idMotivo' => $row['idMotivo'],
                'idUltimoLider' => $row['idUltimoLider'],
                'idEDDProyEmp' => $row['idEDDProyEmp'],
                'nomProyecto' => $row['nomProyecto'],
                'idProyecto' => $row['idProyecto'],
                'idFormulario' => $row['idFormulario'],
                'formRespondido' => $row['formRespondido'],
            );
        }

        $jsonstring = json_encode([
            'datos' => $json,
        ]);
        echo $jsonstring;
    } else {


        $json[] = array(
            'idMovimientoColabTsoft' => 'empty / vacio',
            'idEmpleado' => 'empty / vacio',
            'idMotivo' => 'empty / vacio',
            'fechaIni' => 'empty / vacio',
            'fechaFin' => 'empty / vacio',
            'observaciones' => 'empty / vacio',
            'nombreMotivo' => 'empty / vacio',
            'nomEmpleado' => 'empty / vacio',
            'formRespondido' => 'empty / vacio',
        );
        $jsonstring = json_encode([
            'datos' => $json,
        ]);
        echo $jsonstring;
    }
}
