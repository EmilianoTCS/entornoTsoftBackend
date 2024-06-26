<?php
function validarTelefono($telefono)
{
    // Expresión regular para validar un número de teléfono que no contenga letras
    $pattern = '/^\+?\d{1,4}?[ .-]?\(?\d{1,4}?\)?[ .-]?\d{1,4}[ .-]?\d{1,4}[ .-]?\d{1,9}$/';

    if (preg_match($pattern, $telefono)) {
        return true;
    } else {
        return false;
    }
}

// Ejemplo de uso:
$telefono1 = "+1234567890";
$telefono2 = "123-456-7890";
$telefono3 = "(123) 456-7890";
$telefono4 = "123 456 7890";
$telefono5 = "123.456.7890";
$telefono6 = "1234567890";
$telefono7 = "12345";
$telefono8 = "1234A567890"; // Ejemplo de número con letra

if (validarTelefono($telefono1)) {
    echo "$telefono1 es un número de teléfono válido.\n";
} else {
    echo "$telefono1 no es un número de teléfono válido.\n";
}

if (validarTelefono($telefono2)) {
    echo "$telefono2 es un número de teléfono válido.\n";
} else {
    echo "$telefono2 no es un número de teléfono válido.\n";
}

if (validarTelefono($telefono3)) {
    echo "$telefono3 es un número de teléfono válido.\n";
} else {
    echo "$telefono3 no es un número de teléfono válido.\n";
}

if (validarTelefono($telefono4)) {
    echo "$telefono4 es un número de teléfono válido.\n";
} else {
    echo "$telefono4 no es un número de teléfono válido.\n";
}

if (validarTelefono($telefono5)) {
    echo "$telefono5 es un número de teléfono válido.\n";
} else {
    echo "$telefono5 no es un número de teléfono válido.\n";
}

if (validarTelefono($telefono6)) {
    echo "$telefono6 es un número de teléfono válido.\n";
} else {
    echo "$telefono6 no es un número de teléfono válido.\n";
}

if (validarTelefono($telefono7)) {
    echo "$telefono7 es un número de teléfono válido.\n";
} else {
    echo "$telefono7 no es un número de teléfono válido.\n";
}

if (validarTelefono($telefono8)) {
    echo "$telefono8 es un número de teléfono válido.\n";
} else {
    echo "$telefono8 no es un número de teléfono válido.\n";
}
?>
