<?php

require_once("../../model/conexion.php");

// Set headers
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
date_default_timezone_set("America/Argentina/Buenos_Aires");

/**
 * Process a single response by calling the stored procedure
 * @param mysqli $conection Database connection
 * @param object $item Response data
 * @return array Operation result
 */
function processResponse($conection, $item) {
    $query = sprintf(
        "CALL SP_oi_insertarRespForm(%d, %d, %d, '%s', 1, 1, 1, '%s', @p0, @p1)",
        intval($item->idRespuesta),
        intval($item->idPregunta),
        intval($item->idEDDProyEmp),
        mysqli_real_escape_string($conection, $item->respuesta),
        mysqli_real_escape_string($conection, $item->usuarioCreacion)
    );

    try {
        $result = mysqli_query($conection, $query);
        if (!$result) {
            throw new Exception(mysqli_error($conection));
        }

        $response = [];
        while ($row = mysqli_fetch_array($result)) {
            $response[] = [
                'OUT_CODRESULT' => $row['OUT_CODRESULT'],
                'OUT_MJERESULT' => $row['OUT_MJERESULT']
            ];
        }
        mysqli_free_result($result);
        mysqli_next_result($conection);
        
        return $response;
    } catch (Exception $e) {
        return ['error' => $e->getMessage()];
    }
}

/**
 * Main API handler
 */
function handleRequest() {
    global $conection;
    
    if (!isset($_GET['oi_insertarRespPregForm'])) {
        http_response_code(400);
        return ['error' => 'Invalid request'];
    }

    try {
        $inputData = json_decode(file_get_contents("php://input"));
        if (json_last_error() !== JSON_ERROR_NONE) {
            throw new Exception('Invalid JSON data');
        }
        // echo json_encode($inputData->respuestas);
        if (!isset($inputData->respuestas)) {
            throw new Exception('Missing or invalid respuestas field');
        }

        $results = [];
        foreach ($inputData->respuestas as $item) {
            if (strtolower(trim($item->tipoResp)) === "matriz") {
                foreach ($item->respuestas as $itemMatriz) {
                    $results[] = processResponse($conection, $itemMatriz);
                }
            } else {
                $results[] = processResponse($conection, $item);
            }
        }

        return ['status' => 'success', 'results' => $results];
    } catch (Exception $e) {
        http_response_code(500);
        return ['error' => $e->getMessage()];
    }
}

// Execute and output response
echo json_encode(handleRequest());