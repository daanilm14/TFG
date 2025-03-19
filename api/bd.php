<?php
include 'config.php';

class BDController{

    private $mysqli;

    // Constructor que se conecta a la base de datos
    public function __construct() {
        // Usamos las constantes definidas en el archivo config.php
        $this->mysqli = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
        
        // Verifica si hubo un error de conexión
        if ($this->mysqli->connect_errno) {
            error_log("Fallo al conectar a la base de datos: " . $this->mysqli->connect_error);
            echo "Lo sentimos, se ha producido un error en el servidor.";
            exit();  // Detiene la ejecución si no se puede conectar
        }
    }

    // Método para obtener todos los registros de la tabla 'usuarios'
    public function getUsuario($id) {
        $usuario = array('nombre' => '', 'email' => '', 'paswd' => '', 'rol' => '');
        $stmt= $this->mysqli->prepare("SELECT nombre, email, paswd, rol FROM usuarios WHERE id = ?");
        if (!$stmt) { // Verificar si la consulta se preparó correctamente
            error_log("Error al preparar la consulta: " . $this->mysqli->error);
            return $usuario; // Devolver actividad predeterminada en caso de error
        }

        $stmt->bind_param("i", $idEv);    // Asignar valores a la consulta
        if (!$stmt->execute()) {          // Ejecutar la consulta
            error_log("Error al ejecutar la consulta: " . $stmt->error);      // Registrar errores de ejecución
            $stmt->close();         // Cerrar la consulta                     
            return $usuario; // Devolver actividad predeterminada en caso de error
        }

        $res = $stmt->get_result();   // Obtener el resultado de la consulta
        if ($res->num_rows > 0){
            $row = $res->fetch_assoc(); // Obtener la fila de resultados
            $usuario['nombre'] = $row['nombre'];
            $usuario['email'] = $row['email'];
            $usuario['paswd'] = $row['paswd'];
            $usuario['rol'] = $row['rol'];
        }

        $stmt->close();          // Cerrar la consulta
        return $usuario; // Devolver el resultado
    }
}

?>