<?php
session_start();
include("conexion.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");


if (isset($_GET['login'])) {
    $data = json_decode(file_get_contents("php://input"));
    $username = $data->username;
    $password = $data->password;


    function gToken($len)
    {
        $cadena = "_ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_";
        $tkn = "";
        for ($i = 0; $i < $len; $i++) {
            $tkn .= $cadena[rand(0, $len)];
        }
        return $tkn;
    }
    $token = gToken(40);

    $query = "CALL SP_login('$username', '$password', @p1)";
    $result = mysqli_query($conection, $query);
    if (!$result) {
        die('Query Failed' . mysqli_error($conection));
    }
    $row = mysqli_fetch_array($result);
    $password_bd = $row['password'];
    $pass_c = sha1($password);

    if ($password_bd == $pass_c) {
        $json[] = array(
            'statusConected' => true,
            'error' => false,
            'token' => $token,
            'usuario' => $row['usuario'],
            'nomRol' => $row['nomRol'],
            'idEmpleado' => $row['idEmpleado'],

        );
        echo json_encode($json);
    } else {
        $json[] = array(
            'statusConected' => false,
            'token' => null,
            'error' => true,
            'usuario' => null,
            'nomRol' => null,
            'nomEmpleado' => null,
            'idEmpleado' => null,
        );
        echo (json_encode($json));
    }
} else {
    $json[] = array(
        'statusConected' => false,
        'token' => null,
        'usuario' => null,
        'error' => true,
        'nomRol' => null,
        'nomEmpleado' => null,
        'idEmpleado' => null,
    );
    echo (json_encode($json));
}
