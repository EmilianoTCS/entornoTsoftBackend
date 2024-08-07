<?php
// Este endpoint recibe las nuevas impugnaciones desde el simulador de costos, reconociendo aquellos registros se deben insertar y cuales deben ser desactivados
include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['ihh_validarImpugnacionEmp'])) {
    $data = json_decode(file_get_contents("php://input"));
    $nuevasImpugnaciones = $data->nuevasImpugnaciones;
    $datosResumen = $data->datosResumen;
    $elementosEliminados = $data->elementosEliminados;

    $isActive = $data->isActive;
    $usuarioCreacion = $data->usuarioCreacion;
    $json = array();
    $codResult = '';

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
                    die('Query Failed' . mysqli_error($conection));
                } else {
                    do {
                        if ($result1 = mysqli_store_result($conection)) {
                            while ($row = mysqli_fetch_array($result1)) {
                                if ($row['OUT_CODRESULT'] != '00') {
                                    $json[] = array(
                                        'OUT_CODRESULT' => $row['OUT_CODRESULT'],
                                        'OUT_MJERESULT' => $row['OUT_MJERESULT']
                                    );
                                    echo json_encode($json);
                                } else {
                                    $codResult =  $row['OUT_CODRESULT'];
                                    $json[] = array(
                                        'OUT_CODRESULT' => $row['OUT_CODRESULT'],
                                        'OUT_MJERESULT' => $row['OUT_MJERESULT']
                                    );
                                    echo json_encode(array_unique($json));
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
    //Lee los nuevos registros a insertar
    foreach ($nuevasImpugnaciones as $item) {
        $query = "CALL SP_ihh_validarImpugnacionEmp(
            '$datosResumen->idresumenperproy',
            '$item->idImpugnacionEmp',
            '$item->idEmpleado',
            '$item->idElemento',
            '$item->idPeriodo',
            '$item->cantHorasPeriodo',
            '$item->cantHorasExtra',
            '$item->valorHH',
            '$isActive',
            '$usuarioCreacion',
            @p0, 
            @p1)";
        $result = mysqli_query($conection, $query);
        if (!$result) {
            die('Query Failed' . mysqli_error($conection));
        } else {
            while ($row = mysqli_fetch_array($result)) {

                if ($row['OUT_CODRESULT'] != '00') {
                    $json[] = array(
                        'OUT_CODRESULT' => $row['OUT_CODRESULT'],
                        'OUT_MJERESULT' => $row['OUT_MJERESULT']
                    );
                    echo json_encode($json);
                } else {
                    $codResult =  $row['OUT_CODRESULT'];
                }
            }
        }
        mysqli_next_result($conection);
    }
    if ($codResult === "00") {
        $json[] = array(
            'OUT_CODRESULT' => '00',
            'OUT_MJERESULT' => 'SUCCESS'
        );
    echo json_encode($json);
    }


    // if ($codResult === "00") {
    //     $query2 = "CALL SP_editarResumenHHAuto(
    //         '$datosResumen->idresumenperproy',
    //         '$datosResumen->costoMensual',
    //         '$usuarioCreacion',
    //         '$isActive',
    //         @p0, 
    //         @p1)";
    //     $result = mysqli_query($conection, $query2);
    //     if (!$result) {
    //         die('Query Failed' . mysqli_error($conection));
    //     } else {
    //         while ($row = mysqli_fetch_array($result)) {
    //             $json[] = array(
    //                 'OUT_CODRESULT' => $row['OUT_CODRESULT'],
    //                 'OUT_MJERESULT' => $row['OUT_MJERESULT']
    //             );
    //         }
    //         echo json_encode($json);
    //     }
    // }
} else {
    echo json_encode("Error");
}
