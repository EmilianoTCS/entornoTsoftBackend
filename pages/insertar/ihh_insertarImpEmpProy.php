<?php
// Este endpoint recibe las nuevas impugnaciones desde la impugnación de los proyectos a un colaborador.
include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET, POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['ihh_insertarImpEmpProy'])) {
    $data = json_decode(file_get_contents("php://input"));
    $nuevasImpugnaciones = $data->nuevasImpugnaciones;
    $elementosEliminados = $data->elementosEliminados;
    $mes = $data->mes;
    $json = array();

    function ejecutarSP($conection, $query) {
        if (mysqli_multi_query($conection, $query)) {
            do {
                if ($result = mysqli_store_result($conection)) {
                    while ($row = mysqli_fetch_array($result)) {
                        if ($row['OUT_CODRESULT'] !== '00') {
                            mysqli_free_result($result);
                            return array(
                                'OUT_CODRESULT' => $row['OUT_CODRESULT'],
                                'OUT_MJERESULT' => $row['OUT_MJERESULT']
                            );
                        }
                    }
                    mysqli_free_result($result);
                }
            } while (mysqli_next_result($conection));
        } else {
            die('Query Failed: ' . mysqli_error($conection));
        }
        return null; // Sin errores
    }

    // Procesa los registros a desactivar.
    if (count($elementosEliminados) !== 0) {
        foreach ($elementosEliminados as $item) {
            if (!empty($item->idImpugnacionEmp)) {
                $query1 = "CALL SP_desactivarImpugnacionEmp('$item->idImpugnacionEmp', @p0, @p1)";
                $error = ejecutarSP($conection, $query1);
                if ($error) {
                    echo json_encode(array($error)); // Retorna el error y termina.
                    exit;
                }
            }
        }
    }

    // Procesa los nuevos registros a insertar.
    foreach ($nuevasImpugnaciones as $item) {
        $query2 = "CALL SP_ihh_impEmpProy(
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
            @p0, @p1)";

        $error = ejecutarSP($conection, $query2);
        if ($error) {
            echo json_encode(array($error)); // Retorna el error y termina.
            exit;
        }
    }

    // Respuesta exitosa si no hubo errores.
    $json[] = array(
        'OUT_CODRESULT' => '00',
        'OUT_MJERESULT' => 'SUCCESS'
    );
    echo json_encode($json);
} else {
    echo json_encode(array('Error' => 'Invalid Request'));
}

mysqli_close($conection); // Cierra la conexión.
?>
