<?php


// Esta función recibe un archivo CSV como parámetro para luego separar los encabezados y las filas y retornándolos en un array

function leerCSV($nombreArchivo)
{   
    // print_r("nomArchivo " . $nombreArchivo . "\n");
    // Abrir el archivo en modo lectura
    if (($archivo = fopen($nombreArchivo, "r")) !== FALSE) {
        // print_r("fopen true \n");
        // print_r("nomArchivo " . $archivo . "\n");
        // Obtener los encabezados de la primera fila, suponiendo que están delimitados por ";"
        $encabezados = fgetcsv($archivo, 10000, ";");
        // print_r("encabezados; " . $encabezados[5] . "\n");


        // Array para almacenar todas las filas
        $filas = [];

        // Leer cada fila del archivo CSV
        while (($fila = fgetcsv($archivo, 10000, ";")) !== FALSE) {
            
            // Combinar los encabezados con la fila para obtener un array asociativo
            if (count($encabezados) == count($fila)) {  // Verificar que la fila tiene el mismo número de elementos que los encabezados
                $filas[] = array_combine($encabezados, $fila);
            } else {
                echo "Error: la fila tiene un número diferente de elementos que los encabezados\n";
            }
        }

        // Cerrar el archivo
        fclose($archivo);
        // print_r("fila: " . $filas[10]['nombre Cliente'] . "\n");
        return [
            'encabezados' => $encabezados,
            'filas' => $filas
        ];
    } else {
        // Manejar el error si el archivo no se puede abrir
        return false;
    }
}
