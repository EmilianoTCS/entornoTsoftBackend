<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
include("../../model/conexion.php");


if (isset($_POST)) {
    $file = $_FILES['file'];
    $nomDocumento = basename($_FILES['file']['name']);
    $tipo = strtolower(pathinfo($nomDocumento, PATHINFO_EXTENSION));
    $data = json_decode($_POST['data']);
    $ruta = "C:/xampp/htdocs/entornoTsoft/files/ihh/acop/";
    $descripcion = $data->descripcion;
    $nomTabla = $data->nomTabla;
    $idRegistro = $data->idRegistro;
    $isActive = $data->isActive;
    $usuarioCreacion = $data->usuarioCreacion;



    if (file_exists($ruta)) {
        if ($tipo !== "xlsx" || $tipo !== "pdf") {
            if (move_uploaded_file($file['tmp_name'], $ruta . $nomDocumento)) {
                
                $query = "CALL SP_ihh_insertarDocumento('$nomDocumento', '$ruta', '$tipo', '$descripcion', '$nomTabla', '$idRegistro', '$isActive', '$usuarioCreacion', @p0, @p1)";
                $result = mysqli_query($conection, $query);
                if (!$result) {
                    die('Query Failed' . mysqli_error($conection));
                }

                $json = array();
                while ($row = mysqli_fetch_array($result)) {
                    $json[] = array(
                        'OUT_CODRESULT' => $row['OUT_CODRESULT'],
                        'OUT_MJERESULT' => $row['OUT_MJERESULT']
                    );
                    echo json_encode($json);
                }
            }
        }
    } else {
        mkdir($ruta, 0700, true);

        if ($tipo !== "xlsx" || $tipo !== "pdf") {
            if (move_uploaded_file($file['tmp_name'], $ruta  . $nomDocumento)) {

                $query = "CALL SP_ihh_insertarDocumento('$nomDocumento', '$ruta', '$tipo', '$descripcion', '$nomTabla', '$idRegistro', '$isActive', '$usuarioCreacion', @p0, @p1)";
                $result = mysqli_query($conection, $query);
                if (!$result) {
                    die('Query Failed' . mysqli_error($conection));
                }

                $json = array();
                while ($row = mysqli_fetch_array($result)) {
                    $json[] = array(
                        'OUT_CODRESULT' => $row['OUT_CODRESULT'],
                        'OUT_MJERESULT' => $row['OUT_MJERESULT']
                    );
                }
            }
        }
    }
}
