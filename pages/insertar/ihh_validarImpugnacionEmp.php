<?php
include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");

if (isset($_GET['ihh_validarImpugnacionEmp'])) {
    $data = json_decode(file_get_contents("php://input"));
    $nuevasImpugnaciones = $data->nuevasImpugnaciones ?? [];
    $datosResumen = $data->datosResumen ?? null;
    $elementosEliminados = $data->elementosEliminados ?? [];
    $isActive = $data->isActive;
    $usuarioCreacion = $data->usuarioCreacion;

    $json = [];
    $codResult = '00'; // Asumimos éxito inicialmente

    // Función para manejar resultados de las consultas
    function manejarResultados($conection, &$json, &$codResult) {
        do {
            if ($result = mysqli_store_result($conection)) {
                while ($row = mysqli_fetch_assoc($result)) {
                    $json[] = [
                        'OUT_CODRESULT' => $row['OUT_CODRESULT'],
                        'OUT_MJERESULT' => $row['OUT_MJERESULT'],
                    ];
                    // Actualizar codResult si hay algún error
                    if ($row['OUT_CODRESULT'] !== '00') {
                        $codResult = $row['OUT_CODRESULT'];
                    }
                }
                mysqli_free_result($result);
            }
        } while (mysqli_next_result($conection));
    }

    // Procesar los elementos eliminados
    foreach ($elementosEliminados as $item) {
        if (!empty($item->idImpugnacionEmp)) {
            $query1 = "CALL SP_desactivarImpugnacionEmp('$item->idImpugnacionEmp', @p0, @p1)";
            if (!mysqli_query($conection, $query1)) {
                $codResult = '99';
                $json[] = [
                    'OUT_CODRESULT' => '99',
                    'OUT_MJERESULT' => 'Error al desactivar: ' . mysqli_error($conection)
                ];
                break; // Salir si hay un error
            }
            manejarResultados($conection, $json, $codResult);
        }
    }

    // Procesar nuevas impugnaciones
    foreach ($nuevasImpugnaciones as $item) {
        $query2 = "CALL SP_ihh_validarImpugnacionEmp(
            '$datosResumen->idresumenperproy',
            '$item->idImpugnacionEmp',
            '$item->idEmpleado',
            '$item->idElemento',
            '$item->idPeriodo',
            '$item->cantHorasPeriodo',
            '$item->cantHorasExtra',
            '$item->numAcop',
            '$item->tipoHHEE',
            '$item->valorHH',
            '$item->idNotaImpugnacion',
            '$item->nota',
            '$item->monetizado',
            '$isActive',
            '$usuarioCreacion',
            @p0,
            @p1)";

        if (!mysqli_query($conection, $query2)) {
            $codResult = '99';
            $json[] = [
                'OUT_CODRESULT' => '99',
                'OUT_MJERESULT' => 'Error al insertar: ' . mysqli_error($conection)
            ];
            break; // Salir si hay un error
        }
        manejarResultados($conection, $json, $codResult);
    }

    // Resultado final si todas las operaciones fueron exitosas
    if ($codResult === '00') {
        $json[] = [
            'OUT_CODRESULT' => '00',
            'OUT_MJERESULT' => 'SUCCESS'
        ];
    }

    // Enviar respuesta JSON
    echo json_encode($json);

} else {
    echo json_encode([
        'OUT_CODRESULT' => '98',
        'OUT_MJERESULT' => 'Error: Parámetros no encontrados.'
    ]);
}
?>
