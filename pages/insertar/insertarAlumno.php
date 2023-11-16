<?php

include("../../model/conexion.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['insertarAlumno'])) {
    $data = json_decode(file_get_contents("php://input"));
    $nomAlumno = $data->nomAlumno;
    $correoAlumno = $data->correoAlumno;
    $telefonoAlumno = $data->telefonoAlumno;
    $idPais = $data->idPais;
    $idServicio = $data->idServicio;
    $idCargo = $data->idCargo;
    $idArea = $data->idArea;
    $usuario = $data->usuario;
    $password = $data->password;
    $tipoUsuario = $data->tipoUsuario;
    $nomRol = $data->nomRol;
    $usuarioCreacion = $data->usuarioCreacion;


    $query = "CALL SP_insertarAlumno('$nomAlumno','$correoAlumno','$telefonoAlumno', $idPais, $idServicio, $idArea, $idCargo, '$usuario','$password','$tipoUsuario','$usuarioCreacion', $nomRol, @p0, @p1)";
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
                'OUT_CODRESULT' => $row['OUT_CODRESULT'],
                'OUT_MJERESULT' => $row['OUT_MJERESULT'],
                'idAlumno' => $row['idAlumno'],
                'nomAlumno' => $row['UPPER(alum.nomAlumno)'],
                'correoAlumno' => $row['UPPER(alum.correoAlumno)'],
                'telefonoAlumno' => $row['UPPER(alum.telefonoAlumno)'],
                'nomServicio' => $row['UPPER(serv.nomServicio)'],
                'nomArea' => $row['UPPER(ar.nomArea)'],
                'nomPais' => $row['UPPER(pa.nomPais)'],
                'nomCargo' => $row['UPPER(car.nomCargo)']
            );
        }
    }
    $jsonstring = json_encode($json);
    echo $jsonstring;
} else {
    echo json_encode("Error");
}
