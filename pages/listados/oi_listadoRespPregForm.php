<?php
include("../../model/conexion.php");
include("../paginador/cantPaginas.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if (isset($_GET['oi_listadoRespPregForm'])) {
    $data = json_decode(file_get_contents("php://input"));
    $idFormulario = $data->idFormulario;
    $idEDDProyEmp = $data->idEDDProyEmp;

    $query = "CALL SP_oi_listadoRespPregFormulario('$idFormulario', '$idEDDProyEmp', @p0, @p1)";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }

    $json = array();

    if (mysqli_num_rows($result) > 0) {
        while ($row = mysqli_fetch_array($result)) {

            $json[] = array(
                'idFormulario' => $row['idFormulario'],
                'descFormulario' => $row['descFormulario'],
                'nomFormulario' => $row['nomFormulario'],
                'idPregunta' => $row['idPregunta'],
                'nomPregunta' => $row['nomPregunta'],
                'ordenPregunta' => $row['ordenPregunta'],
                'preguntaObligatoria' => $row['preguntaObligatoria'],
                'tipoResp' => $row['tipoResp'],
                'idRespPreg' => $row['idRespPreg'],
                'nomRespuesta' => $row['nomRespuesta'],
                'nomEmpleado' => $row['nomEmpleado'],
                'nomProyecto' => $row['nomProyecto'],
                'idEmpleado' => $row['idEmpleado'],
                'idProyecto' => $row['idProyecto'],
                'tipoMatriz' => $row['tipoMatriz'],
                'respuesta' => $row['respuesta'],
            );
        }

        $jsonstring = json_encode($json);
        echo $jsonstring;
    } else {


        $json[] = array(
            'idFormulario' => 'Empty / vacío',
            'descFormulario' => 'Empty / vacío',
            'nomFormulario' => 'Empty / vacío',
            'idPregunta' => 'Empty / vacío',
            'nomPregunta' => 'Empty / vacío',
            'ordenPregunta' => 'Empty / vacío',
            'preguntaObligatoria' => 'Empty / vacío',
            'tipoResp' => 'Empty / vacío',
            'idRespPreg' => 'Empty / vacío',
            'nomRespuesta' => 'Empty / vacío',
            'nomEmpleado' => 'Empty / vacío',
            'nomProyecto' => 'Empty / vacío',
            'idEmpleado' => 'Empty / vacío',
            'idProyecto' => 'Empty / vacío',
            'respuesta' => 'Empty / vacío',
        );  
        $jsonstring = json_encode($json);
        echo $jsonstring;
    }
}
