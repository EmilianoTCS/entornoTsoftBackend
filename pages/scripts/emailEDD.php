<?php

include("../../model/conexion.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET,POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
require('../scripts/generadorEmail.php');


if (isset($_GET['emailEDD'])) {

    //Declaración de variables
    $data = json_decode(file_get_contents("php://input"));
    $idProyecto = $data->idProyecto;
    $cargoEnProy = $data->cargoEnProy;
    $tipoConfDato = $data->tipoConfDato;
    $subTipoConfDato = $data->subTipoConfDato;
    $listContactos = $data->listContactos;
    $datosEmpleado = array();


    //Obtengo el listado de empleados sin tener en cuenta el cargo (se usa referente por default)
    $queryEmpleados = "CALL SP_AUX_listadoEmpCargoProy('$idProyecto', '', @p0, @p1)";
    $resultEmpleados = mysqli_query($conection, $queryEmpleados);
    if (!$resultEmpleados) {
        die('Query Failed' . mysqli_error($conection));
    }
    if (mysqli_num_rows($resultEmpleados) > 0) {
        while ($rowEmpleados = mysqli_fetch_array($resultEmpleados)) {
            $datosEmpleado[] = array(
                'idEDDProyEmp' => $rowEmpleados['idEDDProyEmp'],
                'idEDDProyecto' => $rowEmpleados['idEDDProyecto'],
                'nomProyecto' => $rowEmpleados['nomProyecto'],
                'idServicio' => $rowEmpleados['idServicio'],
                'nomServicio' => $rowEmpleados['nomServicio'],
                'idCliente' => $rowEmpleados['idCliente'],
                'nomCliente' => $rowEmpleados['nomCliente'],
                'idEmpleado' => $rowEmpleados['idEmpleado'],
                'nomEmpleado' => $rowEmpleados['nomEmpleado'],
                'correoEmpleado' => $rowEmpleados['correoEmpleado'],
                'cargoEnProy' => $rowEmpleados['cargoEnProy'],
                'idEDDEvaluacion' => $rowEmpleados['idEDDEvaluacion'],
                'nomEvaluacion' => $rowEmpleados['nomEvaluacion'],
                'fechaIni' => $rowEmpleados['fechaIni'],
                'fechaFin' => $rowEmpleados['fechaFin'],
                'idEDDEvalProyEmp' => $rowEmpleados['idEDDEvalProyEmp'],
                'idEDDProyEmpEvaluador' => $rowEmpleados['idEDDProyEmpEvaluador'],
                'idEDDProyEmpEvaluado' => $rowEmpleados['idEDDProyEmpEvaluado'],
                'evaluado' => $rowEmpleados['evaluado'],
                'idEmpleadoEvaluado' => $rowEmpleados['idEmpleadoEvaluado'],
                'nomClienteEvaluado' => $rowEmpleados['nomClienteEvaluado'],
            );
        }
    }

    mysqli_next_result($conection);

    //Obtengo el listado de empleados con el cargo colaborador
    $queryEmpleadosColab = "CALL SP_AUX_listadoEmpCargoProy('$idProyecto', 'colaborador', @p0, @p1)";
    $resultEmpleadosColab = mysqli_query($conection, $queryEmpleadosColab);
    if (!$resultEmpleadosColab) {
        die('Query Failed' . mysqli_error($conection));
    }
    if (mysqli_num_rows($resultEmpleadosColab) > 0) {
        while ($rowEmpleadosColab = mysqli_fetch_array($resultEmpleadosColab)) {
            $datosEmpleadoColab[] = array(
                'idEDDProyEmp' => $rowEmpleadosColab['idEDDProyEmp'],
                'idEDDProyecto' => $rowEmpleadosColab['idEDDProyecto'],
                'nomProyecto' => $rowEmpleadosColab['nomProyecto'],
                'idServicio' => $rowEmpleadosColab['idServicio'],
                'nomServicio' => $rowEmpleadosColab['nomServicio'],
                'idCliente' => $rowEmpleadosColab['idCliente'],
                'nomCliente' => $rowEmpleadosColab['nomCliente'],
                'idEmpleado' => $rowEmpleadosColab['idEmpleado'],
                'nomEmpleado' => $rowEmpleadosColab['nomEmpleado'],
                'correoEmpleado' => $rowEmpleadosColab['correoEmpleado'],
                'cargoEnProy' => $rowEmpleadosColab['cargoEnProy'],
                'idEDDEvaluacion' => $rowEmpleadosColab['idEDDEvaluacion'],
                'nomEvaluacion' => $rowEmpleadosColab['nomEvaluacion'],
                'fechaIni' => $rowEmpleadosColab['fechaIni'],
                'fechaFin' => $rowEmpleadosColab['fechaFin'],
                'idEDDEvalProyEmp' => $rowEmpleadosColab['idEDDEvalProyEmp'],
                'idEDDProyEmpEvaluador' => $rowEmpleadosColab['idEDDProyEmpEvaluador'],
                'idEDDProyEmpEvaluado' => $rowEmpleadosColab['idEDDProyEmpEvaluado'],
                'evaluado' => $rowEmpleadosColab['evaluado'],
                'idEmpleadoEvaluado' => $rowEmpleadosColab['idEmpleadoEvaluado'],
                'nomClienteEvaluado' => $rowEmpleadosColab['nomClienteEvaluado'],
            );
        }
    }
    mysqli_next_result($conection);

    //Obtengo las configuraciones de email desde la base de datos
    $queryConfig = "CALL SP_listadoConfigDatos('$tipoConfDato','', @p0, @p1)";
    $resultConfig = mysqli_query($conection, $queryConfig);
    if (!$resultConfig) {
        die('Query Failed' . mysqli_error($conection));
    }
    if (mysqli_num_rows($resultConfig) > 0) {
        while ($rowConfigs = mysqli_fetch_array($resultConfig)) {
            $datosConfig[] = array(
                'idConfDatos' => $rowConfigs['idConfDatos'],
                'tipoConfDato' => $rowConfigs['tipoConfDato'],
                'subTipoConfDato' => $rowConfigs['subTipoConfDato'],
                'orden' => $rowConfigs['orden'],
                'datoVisible' => $rowConfigs['datoVisible'],
                'datoNoVisible' => $rowConfigs['datoNoVisible']
            );
        }
    }

    $datosEmpleadoColabDes = $datosEmpleadoColab;  //Copia del array obtenido en otra variable SIN ORDENAR POR EVALUADO

    // Función de comparación personalizada para orden ascendente
    function compararPorEvaluadoAsc($a, $b)
    {
        return strcmp($a['evaluado'], $b['evaluado']);
    }

    // Ordenar el array utilizando la función de comparación personalizada
    usort($datosEmpleadoColab, 'compararPorEvaluadoAsc'); 

    //Hago la separación y procesado del listado de destinatarios adjuntos y lo almaceno en un nuevo array ($destinatarios)
    $adjuntos = '';
    $aux = '';
    $destinatarios = array();
    for ($indexConfig = 0; $indexConfig < count($datosConfig); $indexConfig++) {
        if ($datosConfig[$indexConfig]['subTipoConfDato'] === "DESTINATARIOS") {
            $adjuntos = $datosConfig[$indexConfig]['datoNoVisible'];
            $exploded = explode(';', $adjuntos);
            // print_r($exploded);
            for ($i = 0; $i < count($exploded); $i++) {
                $separated = explode(',', $exploded[$i]);
                $aux =
                    [
                        'nomContacto' => $separated[0],
                        'correoContacto' => $separated[1]
                    ];

                array_push($destinatarios, $aux);
            }
        }
    }



    // -----------------------------------------------------------------------GENERADORES-----------------------------------------------------------------------

    if ($cargoEnProy === "REFERENTE") {

        // ------------------------------------------------- REF GENERAL -------------------------------------------------
        $plantFilaRef =
            '
        <tr style="height: 16pt">
            <td rowspan="%%(Cant_Ref)%%" nowrap="" id="cssReferente">
            <b>
                <span>
                    %%(nom_referente)%%
                </span>
            </b>
            </td>

            <td nowrap="" id="cssColaborador" >
                <span>
                    %%(nom_colab)%%
                </span>  
            </td>
        </tr>
        ';

        $plantFilaColab2 =
            '
        <tr style="height: 16pt">
            <td nowrap="" id="cssColaborador" >
                <span>
                %%(nom_colab)%%
                </span>  
            </td>
        </tr>
        ';
        $auxFilaRef = '';
        $auxFilaColab = '';
        $cont_ref = 0;
        $cont_colab = 0;
        $marcador = 1;
        $auxNomRef = '';
        $auxNomColab = '';
        $plantillaInicial = '';
        $asuntoRef = '';
        $plantillaAsuntoRef = '[EDD_REF] - %%(nomEval)%% - %%(Fecha_ini)%% - %%(Fecha_fin)%%';
        $marcador2 = 1;


        for ($indexConfig = 0; $indexConfig < count($datosConfig); $indexConfig++) {
            for ($indexEmpleado = 0; $indexEmpleado < count($datosEmpleado); $indexEmpleado++) {

                //Genero el asunto del correo
                if ($datosConfig[$indexConfig]['subTipoConfDato'] === "ASUNTO_REF" && $datosConfig[$indexConfig]['subTipoConfDato'] !== "" || null) {
                    if ($marcador2 === 1) {
                        $asuntoRef = $datosConfig[$indexConfig]['datoNoVisible'];
                        $asuntoRef = str_replace('%%(nomEval)%%', $datosEmpleado[$indexEmpleado]['nomEvaluacion'], $asuntoRef);
                        $asuntoRef = str_replace('%%(Fecha_ini)%%', $datosEmpleado[$indexEmpleado]['fechaIni'], $asuntoRef);
                        $asuntoRef = str_replace('%%(Fecha_fin)%%', $datosEmpleado[$indexEmpleado]['fechaFin'], $asuntoRef);
                        $marcador2++;
                    }
                } else {
                    if ($marcador2 === 1) {
                        $asuntoRef = $plantillaAsuntoRef;
                        $asuntoRef = str_replace('%%(nomEval)%%', $datosEmpleado[$indexEmpleado]['nomEvaluacion'], $asuntoRef);
                        $asuntoRef = str_replace('%%(Fecha_ini)%%', $datosEmpleado[$indexEmpleado]['fechaIni'], $asuntoRef);
                        $asuntoRef = str_replace('%%(Fecha_fin)%%', $datosEmpleado[$indexEmpleado]['fechaFin'], $asuntoRef);
                        $marcador2++;
                    }
                }

                //Genero las variables estáticas del correo

                if ($datosConfig[$indexConfig]['subTipoConfDato'] === "REFERENTES_GRAL") {
                    if ($marcador === 1) {
                        $plantillaInicial = $datosConfig[$indexConfig]['datoNoVisible'];
                        $plantillaInicial = str_replace('%%(Fecha_ini)%%', $datosEmpleado[$indexEmpleado]['fechaIni'], $plantillaInicial);
                        $plantillaInicial = str_replace('%%(Fecha_fin)%%', $datosEmpleado[$indexEmpleado]['fechaFin'], $plantillaInicial);
                    }

                  //Genero la tabla que va incrustada en el correo de forma dinámica  
                    if (
                        $datosEmpleado[$indexEmpleado]['nomEmpleado'] !== $auxNomRef
                    ) {
                        if ($marcador > 1) {
                            $auxFilaRef = str_replace("%%(Cant_Ref)%%", $cont_colab, $auxFilaRef);
                        }
                        $cont_ref = 0;
                        $cont_colab = 0;

                        $auxFilaRef = $auxFilaRef . str_replace("%%(nom_referente)%%", $datosEmpleado[$indexEmpleado]['nomEmpleado'], $plantFilaRef);
                        $auxFilaRef =  str_replace('%%(nom_colab)%%', $datosEmpleado[$indexEmpleado]['evaluado'], $auxFilaRef);

                        $auxNomRef = $datosEmpleado[$indexEmpleado]['nomEmpleado'];
                        $cont_ref++;
                        $cont_colab++;
                    } else {
                        $auxFilaRef =  $auxFilaRef . str_replace('%%(nom_colab)%%', $datosEmpleado[$indexEmpleado]['evaluado'], $plantFilaColab2);
                        $cont_colab++;
                    }
                    $marcador++;
                }
            }
        }

        //Reemplazo los valores obtenidos anteriormente
        $plantillaInicial = str_replace('%%(auxFilaRef)%%', $auxFilaRef, $plantillaInicial);
        $plantillaInicial = str_replace('%%(Cant_Ref)%%', $cont_colab, $plantillaInicial);
        $plantillaInicial = str_replace('%%(auxFilaColab)%%', $auxFilaColab, $plantillaInicial);

        $cuerpoCorreo = $plantillaInicial; //Copia de la plantilla original

        
        //Envío los correos, primero se envían a los contactos que vienen desde el frontend, y luego se envían a los destinatarios procesados anteriormente

        // loop de contactos recibidos
        // foreach ($listContactos as $itemContactos) {
        //     $cuerpoCorreo = str_replace('%%(nom_Lider)%%', strtoupper($itemContactos->nomContacto), $cuerpoCorreo);
        //     GeneradorEmails($itemContactos->correoContacto, $cuerpoCorreo, $asuntoRef);
        //     $cuerpoCorreo = $plantillaInicial;
        // }

        // for ($indexDest = 0; $indexDest < count($destinatarios); $indexDest++) {
        //     $cuerpoCorreo = str_replace('%%(nom_Lider)%%', strtoupper($destinatarios[$indexDest]['nomContacto']), $cuerpoCorreo);
        //     GeneradorEmails($destinatarios[$indexDest]['correoContacto'], $cuerpoCorreo, $asuntoRef);
        //     $cuerpoCorreo = $plantillaInicial;
        // }


        // ------------------------------------------------- REF PERSONALIZADO -------------------------------------------------

        $plantInicialRefPers = '';
        $marcadorRefPers = 1;
        $marcadorAsuntoRefPers = 1;
        $plantFilaRefPers =
            '   
                <tr>
                    <td valign="bottom" nowrap="" id="cssColaborador">
                        <span style="color: black; font-size: 12pt">
                            %%(nom_Colab)%%
                        </span>
                    </td>
                </tr>

            ';
        $auxFilaRefPers = '';
        $auxNomRefPers = '';
        $auxNomEvaluado = '';
        $plantAux = '';

        for ($indexConfig = 0; $indexConfig < count($datosConfig); $indexConfig++) {
            for ($indexEmpleado = 0; $indexEmpleado < count($datosEmpleado); $indexEmpleado++) {


                if ($datosConfig[$indexConfig]['subTipoConfDato'] === "REFERENTES_PERS") {

                    if ($marcadorRefPers === 1) {
                        $baseURL = 'http://localhost/entornoTsoft/pages/scripts/authentication.php?';
                        $getMethodEncoded = base64_encode("idEDDEvaluacion={$datosEmpleado[$indexEmpleado]['idEDDEvaluacion']}&idProyecto={$idProyecto}&cargoEnProy={$cargoEnProy}&idEDDProyEmpEvaluador={$datosEmpleado[$indexEmpleado]['idEDDProyEmpEvaluador']}&idEDDProyEmpEvaluado={$datosEmpleado[$indexEmpleado]['idEDDProyEmpEvaluado']}");
                        $finalUrl = $baseURL . $getMethodEncoded;
                        $plantInicialRefPers = $datosConfig[$indexConfig]['datoNoVisible'];
                        $plantInicialRefPers = str_replace('%%(URL)%%', $finalUrl, $plantInicialRefPers);
                        $plantInicialRefPers = str_replace('%%(Fecha_ini)%%', $datosEmpleado[$indexEmpleado]['fechaIni'], $plantInicialRefPers);
                        $plantInicialRefPers = str_replace('%%(Fecha_fin)%%', $datosEmpleado[$indexEmpleado]['fechaFin'], $plantInicialRefPers);

                        // print_r($datosEmpleado);
                        // $plantAux = $plantInicialRefPers;
                    }

                    if (
                        $datosEmpleado[$indexEmpleado]['nomEmpleado'] !== $auxNomRefPers
                    ) {
                        if ($auxNomRefPers !== '') {
                            $plantAux = $plantInicialRefPers;
                            $plantAux = str_replace('%%(auxFilaRef)%%', $auxFilaRefPers, $plantAux);
                            $plantAux = str_replace('%%(nom_Referente)%%', $auxNomRefPers, $plantAux);
                            // GeneradorEmails($datosEmpleado[$indexEmpleado]['correoEmpleado'], $plantAux, $asuntoRef);
                            GeneradorEmails("testRespuestasCorreosCoe@outlook.com", $plantAux, $asuntoRef);

                            $plantAux = '';
                            $auxFilaRefPers = '';
                        }

                        $auxFilaRefPers =  $auxFilaRefPers . str_replace('%%(nom_Colab)%%', $datosEmpleado[$indexEmpleado]['evaluado'], $plantFilaRefPers);
                        $auxNomRefPers = $datosEmpleado[$indexEmpleado]['nomEmpleado'];
                        // print_r($auxFilaRefPers);
                    } else {
                        $auxFilaRefPers =  $auxFilaRefPers . str_replace('%%(nom_Colab)%%', $datosEmpleado[$indexEmpleado]['evaluado'], $plantFilaRefPers);

                        if ($indexEmpleado === count($datosEmpleado) - 1) {
                            $plantAux = $plantInicialRefPers;
                            $plantAux = str_replace('%%(auxFilaRef)%%', $auxFilaRefPers, $plantAux);
                            $plantAux = str_replace('%%(nom_Referente)%%', $auxNomRefPers, $plantAux);
                            // GeneradorEmails($datosEmpleado[$indexEmpleado]['correoEmpleado'], $plantAux, $asuntoRef);

                            $plantAux = '';
                            $auxFilaRefPers = '';
                        }
                    }

                    $marcadorRefPers++;
                }
            }
        }
    } else {

        // ------------------------------------------------- COLAB GENERAL -------------------------------------------------
        $plantFilaRef =
            '
        <tr style="height: 16pt"> 
            <td nowrap="" id="cssColaborador" >
                <span>
                    %%(nom_colab)%%
                </span>  
            </td>
            <td rowspan="%%(Cant_Ref)%%" nowrap="" id="cssReferente">
            <b>
                <span>
                    %%(nom_referente)%%
                </span>
            </b>
            </td>


        </tr>
        ';

        $plantFilaColab2 =
            '
        <tr style="height: 16pt">
            <td nowrap="" id="cssColaborador" >
                <span>
                %%(nom_colab)%%
                </span>  
            </td>
        </tr>
        ';
        $auxFilaRef = '';
        $auxFilaColab = '';
        $cont_ref = 0;
        $cont_colab = 0;
        $marcador = 1;
        $marcadorAsuntoColab = 1;
        $auxNomRef = '';
        $auxNomColab = '';
        $plantillaInicial = '';
        $asuntoColab = '';

        $plantillaAsuntoColab = '[EDD_COLAB] - %%(nomEval)%% - %%(Fecha_ini)%% - %%(Fecha_fin)%%';

        //crear variable plantilla de Asunto por si no se conecta a la bdd
        //separar el asunto en 2 registros (ref / colab) en la bdd

        for ($indexConfig = 0; $indexConfig < count($datosConfig); $indexConfig++) {
            for ($indexEmpleado = 0; $indexEmpleado < count($datosEmpleadoColab); $indexEmpleado++) {

                if ($datosConfig[$indexConfig]['subTipoConfDato'] === "ASUNTO_COLAB" && $datosConfig[$indexConfig]['subTipoConfDato'] !== "" || null) {
                    if ($marcadorAsuntoColab === 1) {
                        $asuntoColab = $datosConfig[$indexConfig]['datoNoVisible'];
                        $asuntoColab = str_replace('%%(nomEval)%%', $datosEmpleadoColab[$indexEmpleado]['nomEvaluacion'], $asuntoColab);
                        $asuntoColab = str_replace('%%(Fecha_ini)%%', $datosEmpleadoColab[$indexEmpleado]['fechaIni'], $asuntoColab);
                        $asuntoColab = str_replace('%%(Fecha_fin)%%', $datosEmpleadoColab[$indexEmpleado]['fechaFin'], $asuntoColab);
                        $marcadorAsuntoColab++;
                    }
                } else {
                    if ($marcadorAsuntoColab === 1) {
                        $asuntoColab = $plantillaAsuntoColab;
                        $asuntoColab = str_replace('%%(nomEval)%%', $datosEmpleadoColab[$indexEmpleado]['nomEvaluacion'], $asuntoColab);
                        $asuntoColab = str_replace('%%(Fecha_ini)%%', $datosEmpleadoColab[$indexEmpleado]['fechaIni'], $asuntoColab);
                        $asuntoColab = str_replace('%%(Fecha_fin)%%', $datosEmpleadoColab[$indexEmpleado]['fechaFin'], $asuntoColab);
                        $marcadorAsuntoColab++;
                    }
                }

                if ($datosConfig[$indexConfig]['subTipoConfDato'] === "COLAB_GRAL") {

                    if ($marcador === 1) {
                        $plantillaInicial = $datosConfig[$indexConfig]['datoNoVisible'];
                        $plantillaInicial = str_replace('%%(Fecha_ini)%%', $datosEmpleadoColab[$indexEmpleado]['fechaIni'], $plantillaInicial);
                        $plantillaInicial = str_replace('%%(Fecha_fin)%%', $datosEmpleadoColab[$indexEmpleado]['fechaFin'], $plantillaInicial);
                    }

                    if (
                        $datosEmpleadoColab[$indexEmpleado]['evaluado'] !== $auxNomRef
                    ) {
                        if ($marcador > 1) {
                            $auxFilaRef = str_replace("%%(Cant_Ref)%%", $cont_colab, $auxFilaRef);
                        }
                        $cont_ref = 0;
                        $cont_colab = 0;

                        if (str_contains(strtoupper($datosEmpleadoColab[$indexEmpleado]['nomClienteEvaluado']), "TSOFT") === true) {
                            $auxFilaRef = $auxFilaRef . str_replace("%%(nom_referente)%%", $datosEmpleadoColab[$indexEmpleado]['evaluado'] . ' (TSOFT)', $plantFilaRef);
                        } else {
                            $auxFilaRef = $auxFilaRef . str_replace("%%(nom_referente)%%", $datosEmpleadoColab[$indexEmpleado]['evaluado'], $plantFilaRef);
                        }
                        $auxFilaRef =  str_replace('%%(nom_colab)%%', $datosEmpleadoColab[$indexEmpleado]['nomEmpleado'], $auxFilaRef);

                        $auxNomRef = $datosEmpleadoColab[$indexEmpleado]['evaluado'];
                        $cont_ref++;
                        $cont_colab++;
                    } else {
                        $auxFilaRef =  $auxFilaRef . str_replace('%%(nom_colab)%%', $datosEmpleadoColab[$indexEmpleado]['nomEmpleado'], $plantFilaColab2);
                        $cont_colab++;
                    }
                    $marcador++;
                }
            }
        }

        $plantillaInicial = str_replace('%%(auxFilaRef)%%', $auxFilaRef, $plantillaInicial);
        $plantillaInicial = str_replace('%%(Cant_Ref)%%', $cont_colab, $plantillaInicial);
        $plantillaInicial = str_replace('%%(auxFilaColab)%%', $auxFilaColab, $plantillaInicial);

        $cuerpoCorreo = $plantillaInicial;

        // print_r($cuerpoCorreo);
        // loop de contactos recibidos
        // foreach ($listContactos as $itemContactos) {
        //     $cuerpoCorreo = str_replace('%%(nom_Lider)%%', strtoupper($itemContactos->nomContacto), $cuerpoCorreo);
        //     GeneradorEmails($itemContactos->correoContacto, $cuerpoCorreo, $asuntoColab);
        //     $cuerpoCorreo = $plantillaInicial;
        // }

        for ($indexDest = 0; $indexDest < count($destinatarios); $indexDest++) {
            $cuerpoCorreo = str_replace('%%(nom_Lider)%%', strtoupper($destinatarios[$indexDest]['nomContacto']), $cuerpoCorreo);
            GeneradorEmails($destinatarios[$indexDest]['correoContacto'], $cuerpoCorreo, $asuntoRef);
            $cuerpoCorreo = $plantillaInicial;
        }

        //----------------------------------------------------------------------------COLAB PERSONALIZADO-------------------------------------------------------------------

        $plantInicialColabPers = '';
        $marcadorColabPers = 1;
        $plantFilaColabPers =
            '   
          <tr style="height: 19pt">
                <td nowrap="" id="cssReferente" >
                    <b>
                        <span>
                            %%(nom_Ref)%%
                        </span>
                    </b>
                </td>
          </tr>

            ';
        $auxFilaColabPers = '';
        $auxNomColabPers = '';
        $auxNomEvaluado = '';
        $plantAux = '';
        for ($indexConfig = 0; $indexConfig < count($datosConfig); $indexConfig++) {
            for ($indexEmpleado = 0; $indexEmpleado < count($datosEmpleadoColabDes); $indexEmpleado++) {
                if ($datosConfig[$indexConfig]['subTipoConfDato'] === "COLAB_PERS") {

                    if ($marcadorColabPers === 1) {
                        $baseURL = 'http://localhost/entornoTsoft/pages/scripts/authentication.php?';
                        $getMethodEncoded = base64_encode("idEDDEvaluacion={$datosEmpleadoColabDes[$indexEmpleado]['idEDDEvaluacion']}&idProyecto={$idProyecto}&cargoEnProy={$cargoEnProy}&idEDDProyEmpEvaluador={$datosEmpleadoColabDes[$indexEmpleado]['idEDDProyEmpEvaluador']}&idEDDProyEmpEvaluado={$datosEmpleadoColabDes[$indexEmpleado]['idEDDProyEmpEvaluado']}");
                        $finalUrl = $baseURL . $getMethodEncoded;
                        $plantInicialColabPers = $datosConfig[$indexConfig]['datoNoVisible'];
                        $plantInicialColabPers = str_replace('%%(URL)%%', $finalUrl, $plantInicialColabPers);
                        $plantInicialColabPers = str_replace('%%(Fecha_ini)%%', $datosEmpleadoColabDes[$indexEmpleado]['fechaIni'], $plantInicialColabPers);
                        $plantInicialColabPers = str_replace('%%(Fecha_fin)%%', $datosEmpleadoColabDes[$indexEmpleado]['fechaFin'], $plantInicialColabPers);

                        // $plantAux = $plantInicialRefPers;
                    }

                    if (
                        $datosEmpleadoColabDes[$indexEmpleado]['nomEmpleado'] !== $auxNomColabPers
                    ) {
                        if ($auxNomColabPers !== '') {
                            $plantAux = $plantInicialColabPers;
                            $plantAux = str_replace('%%(auxFilaColab)%%', $auxFilaColabPers, $plantAux);
                            $plantAux = str_replace('%%(nom_Colab)%%', $auxNomColabPers, $plantAux);
                            // print_r($plantAux);
                            GeneradorEmails($datosEmpleadoColabDes[$indexEmpleado]['correoEmpleado'], $plantAux, $asuntoColab);

                            $plantAux = '';
                            $auxFilaColabPers = '';
                        }

                        $auxFilaColabPers =  $auxFilaColabPers . str_replace('%%(nom_Ref)%%', $datosEmpleadoColabDes[$indexEmpleado]['evaluado'], $plantFilaColabPers);
                        $auxNomColabPers = $datosEmpleadoColabDes[$indexEmpleado]['nomEmpleado'];
                        // print_r($auxFilaRefPers);
                    } else {
                        $auxFilaColabPers =  $auxFilaColabPers . str_replace('%%(nom_Ref)%%', $datosEmpleadoColabDes[$indexEmpleado]['evaluado'], $plantFilaColabPers);

                        if ($indexEmpleado === count($datosEmpleadoColabDes) - 1) {
                            $plantAux = $plantInicialColabPers;
                            $plantAux = str_replace('%%(auxFilaColab)%%', $auxFilaColabPers, $plantAux);
                            $plantAux = str_replace('%%(nom_Colab)%%', $auxNomColabPers, $plantAux);
                            // print_r($plantAux);
                            GeneradorEmails($datosEmpleadoColabDes[$indexEmpleado]['correoEmpleado'], $plantAux, $asuntoColab);

                            $plantAux = '';
                            $auxFilaColabPers = '';
                        }
                    }

                    $marcadorColabPers++;
                }
            }
        }
    }
}
