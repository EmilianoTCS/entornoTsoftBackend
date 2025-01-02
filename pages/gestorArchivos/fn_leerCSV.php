<?php


// Esta función recibe un archivo CSV como parámetro para luego separar los encabezados y las filas y retornándolos en un array

function leerCSV($nombreArchivo)
{
    // Abrir el archivo en modo lectura
    if (($archivo = fopen($nombreArchivo, "r")) !== FALSE) {
        // Obtener los encabezados de la primera fila, suponiendo que están delimitados por ";"
        $encabezados = fgetcsv($archivo, 10000, ";");

        // Remove BOM from headers
        $encabezados = array_map(function ($header) {
            return preg_replace('/^\xEF\xBB\xBF/', '', $header);
        }, $encabezados);

        // Array para almacenar todas las filas
        $filas = [];

        // Leer cada fila del archivo CSV
        while (($fila = fgetcsv($archivo, 10000, ";")) !== FALSE) {
            // Remove BOM from row values
            $fila = array_map(function ($value) {
                return preg_replace('/^\xEF\xBB\xBF/', '', $value);
            }, $fila);

            // Combinar los encabezados con la fila para obtener un array asociativo
            if (count($encabezados) == count($fila)) {  // Verificar que la fila tiene el mismo número de elementos que los encabezados
                $filas[] = array_combine($encabezados, $fila);
            } else {
                echo "Error: la fila tiene un número diferente de elementos que los encabezados\n";
            }
        }

        // Cerrar el archivo
        fclose($archivo);

        return [
            'encabezados' => $encabezados,
            'filas' => $filas
        ];
    } else {
        // Manejar el error si el archivo no se puede abrir
        return false;
    }
}
