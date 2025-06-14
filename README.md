# 📅 Aplicación Web para Gestión de Espacios

Este proyecto es una aplicación web desarrollada como Trabajo Fin de Grado para la **Universidad de Granada**, cuyo objetivo principal es facilitar la gestión de espacios compartidos (como aulas, laboratorios o salas de reuniones), permitiendo a usuarios realizar reservas y a los administradores gestionar los recursos y solicitudes.

---

## 📌 Funcionalidades principales

- **Autenticación de usuarios** (Firebase Authentication)
- **Distintos roles**: usuarios normales y administradores
- **Administradores**:
  - Crear/editar/eliminar usuarios
  - Crear/editar/eliminar espacios
  - Aceptar o rechazar reservas
  - Importar reservas desde archivo `.txt`
- **Usuarios**:
  - Visualizar disponibilidad por fecha y espacio
  - Solicitar reservas sobre espacios disponibles
- **Interfaz gráfica adaptable** (responsive design)
- **Persistencia en la nube** con Firebase Firestore

---

## 🛠 Tecnologías utilizadas

| Tecnología     | Uso principal                        |
|----------------|--------------------------------------|
| Flutter        | Interfaz de usuario (Frontend)       |
| Firebase       | Backend serverless                   |
| Firestore      | Base de datos NoSQL en tiempo real   |
| Firebase Auth  | Autenticación de usuarios            |

---

## 🚀 Cómo ejecutar el proyecto

### 1. Requisitos previos

- Tener instalado [Flutter](https://docs.flutter.dev/get-started/install)
- Entorno de desarrollo compatible (VS Code, Android Studio, etc)
- Versión SDK minima: 3.5.4

### 2. Clonar el repositorio

```bash
git clone https://github.com/tu-usuario/tfg-gestion-espacios.git
cd tfg-gestion-espacios
```

### 3. Instalar dependencias
```bash
flutter pub get
```

### 4. Ejecutar la aplicación
```bash
flutter run -d chrome
```

## 📂 Estructura del proyecto
- /lib
- ├── Usuario.dart              # Lógica del modelo de usuarios
- ├── Espacio.dart              # Lógica del modelo de espacios
- ├── Reserva.dart              # Lógica del modelo de reservas
- ├── HomeAdmin.dart            # Pantalla principal para administradores
- ├── HomeUser.dart             # Pantalla principal para usuarios
- ├── CrearUsuario.dart         # Formulario para crear nuevos usuarios
- ├── CrearEspacio.dart         # Formulario para crear nuevos espacios
- ├── ListaUsuarios.dart        # Vista para administrar usuarios
- ├── ListaEspacios.dart        # Vista para administrar espacios
- ├── ImportarHorarios.dart     # Funcionalidad de importación de reservas
- ├── RealizarReserva.dart      # Formulario de reserva para usuarios
- ├── EditarUsuario.dart        # Pantalla de edición de un usuario
- ├── EditarEspacio.dart        # Pantalla de edición de un espacio
- ├── MisReservas.dart          # Pantalla de lista de reservas realizadas por un usuario
- ├── firebase_options.dart     # Opciones necesarias para la inicialización de la aplicación

 ## 📚 Autor
 - Daniel Lozano Moya
 - ✉️ lozanomoyadaniel@gmail.com
 - 🧑‍💼 www.linkedin.com/in/danieellozano


