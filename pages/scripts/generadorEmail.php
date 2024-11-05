<?php

// use PHPMailer\PHPMailer\PHPMailer;
// use PHPMailer\PHPMailer\SMTP;
// use PHPMailer\PHPMailer\Exception;

// // require '../../PHPMailer/src/Exception.php';
// // require '../../PHPMailer/src/PHPMailer.php';
// // require '../../PHPMailer/src/SMTP.php';
// // require '../../PHPMailer/src/OAuth.php';
// // require '../../PHPMailer/src/OAuthTokenProvider.php';

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

//Load Composer's autoloader
require '../../vendor/autoload.php';




function GeneradorEmails($destinatario, $cuerpoCorreo, $asunto)
{
    $mail = new PHPMailer(true);

    try {
        // Configuración del servidor
        $mail->isSMTP();                                            //Send using SMTP
        $mail->SMTPDebug = SMTP::DEBUG_SERVER;                      //Enable verbose debug output
        $mail->Host       = 'smtp-mail.outlook.com';                     //Set the SMTP server to send through
        $mail->SMTPAuth   = true;                                   //Enable SMTP authentication
        $mail->Username   = 'testCorreosCoe@outlook.com';                     //SMTP username
        $mail->Password   = 'examplepassword12345';                               //SMTP password
        $mail->SMTPSecure = 'tls';
        $mail->Port       = 587;

        // Recipientes
        $mail->setFrom('testCorreosCoe@outlook.com', 'Gerencia Delivery - TSOFT Chile');
        $mail->addAddress($destinatario, 'Usuario Final');

        // Contenido del correo
        $mail->isHTML(true);
        $mail->CharSet = 'UTF-8';
        $mail->Subject = $asunto;
        $mail->Body    = $cuerpoCorreo;
        $mail->AltBody = 'Evaluaciones de desempeño';

        // Enviar el correo
        $mail->send();
        echo json_encode(['status' => 'Message has been sent']);
    } catch (Exception $e) {
        echo json_encode("Message could not be sent. Mailer Error: {$mail->ErrorInfo}");
    }
}
