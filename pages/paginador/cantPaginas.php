<?php
function cantPaginas($cantRegistros, $cantidadPorPagina)
{
    $CantidadPaginas = ceil($cantRegistros / $cantidadPorPagina);

    for ($i = 1; $i <= $CantidadPaginas; $i++) {
        $cantPaginas[] = array(
            'paginas' => $i
        );
    }
    return ['cantPaginas' => $cantPaginas];
}
