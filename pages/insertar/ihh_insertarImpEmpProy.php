<?php
// Este endpoint recibe las nuevas impugnaciones desde la impugnacion de los proyectos A UN COLABORADOR.
include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['ihh_insertarImpEmpProy'])) {
    $data = json_decode(file_get_contents("php://input"));
    $nuevasImpugnaciones = $data->nuevasImpugnaciones;
    $elementosEliminados = $data->elementosEliminados;
    $mes = $data->mes;
    $json = array();

    // Lee los registros a desactivar
    if (count($elementosEliminados) !== 0) {
        foreach ($elementosEliminados as $item) {
            if ($item->idImpugnacionEmp !== null) {
                $query1 = "CALL SP_desactivarImpugnacionEmp(
                    '$item->idImpugnacionEmp',
                    @p0, 
                    @p1)";
                $result1 = mysqli_query($conection, $query1);
                if (!$result1) {
                    die('Query Failed: ' . mysqli_error($conection));
                } else {
                    do {
                        if ($result1 = mysqli_store_result($conection)) {
                            while ($row = mysqli_fetch_array($result1)) {
                                if ($row['OUT_CODRESULT'] !== '00') {
                                    $json[] = array(
                                        'OUT_CODRESULT' => $row['OUT_CODRESULT'],
                                        'OUT_MJERESULT' => $row['OUT_MJERESULT']
                                    );
                                    echo json_encode($json); // Imprimir error y terminar
                                    exit;
                                }
                            }
                            mysqli_free_result($result1);
                        }
                    } while (mysqli_next_result($conection));
                }
            }
        }
    }
    mysqli_next_result($conection);

    // Lee los nuevos registros a insertar
    foreach ($nuevasImpugnaciones as $item) {
        $query = "CALL SP_ihh_impEmpProy(
            '$item->nomEmpleado',
            '$item->nomProyecto',
            '$item->nomElemento',
            $mes,
            '$item->cantHorasPeriodo',
            '$item->cantHorasExtra',
            '$item->numAcop',
            '$item->tipoHHEE',
            '$item->idNotaImpugnacion',
            '$item->nota',
            '$item->monetizado',
            @p0, 
            @p1)";
        
        $result = mysqli_query($conection, $query);
        if (!$result) {
            die('Query Failed: ' . mysqli_error($conection));
        } else {
            do {
                if ($res = mysqli_store_result($conection)) {
                    while ($row = mysqli_fetch_array($res)) {
                        if ($row['OUT_CODRESULT'] !== '00') {
                            $json[] = array(
                                'OUT_CODRESULT' => $row['OUT_CODRESULT'],
                                'OUT_MJERESULT' => $row['OUT_MJERESULT']
                            );
                            echo json_encode($json); // Imprimir error y terminar
                            exit;
                        }
                    }
                    mysqli_free_result($res);
                }
            } while (mysqli_next_result($conection));
        }
    }

    $json[] = array(
        'OUT_CODRESULT' => '00',
        'OUT_MJERESULT' => 'SUCCESS'
    );
    echo json_encode($json);

} else {
    echo json_encode(array('Error' => 'Invalid Request'));
}
?>
