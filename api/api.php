<?php
include 'config.php';  // Incluir las credenciales de la base de datos
include 'BDController.php';  // Incluir la clase BDController

// Crear una instancia de la clase BDController
$bd = new BDController();

// Verificar si se ha enviado un parámetro 'action' por GET
$action = $_GET['action'] ?? '';

// Dependiendo del valor de 'action', se ejecuta un método diferente
switch ($action) {
    
    case 'get_usuario':
        // Verificar si se ha enviado un parámetro 'id' por GET
        $id = $_GET['id'] ?? '';
        // Llamar al método getUsuario con el id proporcionado
        $usuario = $bd->getUsuario($id);
        // Devolver el resultado en formato JSON
        echo json_encode($usuario);
        break;
    default:
        echo "Acción no válida";
        break;
}

?>