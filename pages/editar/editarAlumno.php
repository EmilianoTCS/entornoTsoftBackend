<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['editarAlumno'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idAlumno = $data->idAlumno;
    $nomAlumno = $data->nomAlumno;
    $correoAlumno = $data->correoAlumno;
    $telefonoAlumno = $data->telefonoAlumno;
    $idPais = $data->idPais;
    $idServicio = $data->idServicio;
    $idArea = $data->idArea;
    $idCargo = $data->idCargo;
    $usuarioModificacion = $data->usuarioModificacion;


    $query = "CALL SP_editarAlumno($idAlumno,'$nomAlumno','$correoAlumno','$telefonoAlumno',$idPais, $idServicio, $idArea, $idCargo,'$usuarioModificacion', @p0, @p1)";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();
    while ($row = mysqli_fetch_array($result)) {
        if ($row['OUT_CODRESULT'] != '00') {
            $json[] = array(
                'OUT_CODRESULT' => $row['OUT_CODRESULT'],
                'OUT_MJERESULT' => $row['OUT_MJERESULT']
            );
        } else {
            $json[] = array(
                'idAlumno' => $row['idAlumno'],
                'nomAlumno' => $row['nomAlumno'],
                'correoAlumno' => $row['correoAlumno'],
                'telefonoAlumno' => $row['telefonoAlumno'],
                'nomArea' => $row['nomArea'],
                'nomServicio' => $row['nomServicio'],
                'nomPais' => $row['nomPais'],
                'nomCargo' => $row['nomCargo']
            );
        }
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
    mysqli_close($conection);
} else {
    echo json_encode("Error");
}
