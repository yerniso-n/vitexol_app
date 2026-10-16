# VITEXOL APP

Aplicación móvil para la gestión de productos, reparaciones, citas y atención al cliente de la empresa VITEXOL.

## Descripción del sistema

VITEXOL APP es una aplicación móvil desarrollada con Flutter para facilitar la gestión de diferentes servicios tecnológicos ofrecidos por VITEXOL.

La aplicación permite registrar usuarios, iniciar y cerrar sesión, consultar información del perfil y utilizar módulos funcionales para productos, reparaciones y citas.

Actualmente, VITEXOL APP cuenta con integración real con Firebase Authentication y Cloud Firestore, permitiendo autenticar usuarios y almacenar información generada desde la aplicación.

El sistema se encuentra en una versión funcional académica y ha sido probado directamente en un dispositivo Android físico.

## Objetivo general

Desarrollar una aplicación móvil que permita optimizar la gestión de productos, reparaciones, citas y atención al cliente de la empresa VITEXOL, ofreciendo una experiencia digital organizada, accesible y fácil de utilizar.

## Funcionalidades implementadas

- Pantalla de bienvenida.
- Registro real de usuarios.
- Inicio de sesión mediante correo electrónico y contraseña.
- Cierre de sesión.
- Integración con Firebase Authentication.
- Integración con Cloud Firestore.
- Pantalla principal de navegación.
- Módulo de Productos.
- Registro y visualización de productos.
- Almacenamiento de productos en Firestore.
- Módulo de Reparaciones.
- Registro y visualización de reparaciones.
- Manejo de estados de reparación.
- Almacenamiento de reparaciones en Firestore.
- Módulo de Citas.
- Programación de citas con fecha y hora.
- Visualización de citas programadas.
- Almacenamiento de citas en Firestore.
- Módulo Mi Perfil.
- Visualización del nombre, correo y teléfono del usuario autenticado.
- Ejecución funcional en un dispositivo Android físico.

## Base de datos

VITEXOL APP utiliza Cloud Firestore como base de datos.

Actualmente se utilizan las siguientes colecciones principales:

### usuarios

Almacena información básica de los usuarios registrados:

- UID.
- Nombre.
- Correo electrónico.
- Teléfono.
- Fecha de registro.

### productos

Almacena información relacionada con los productos:

- Nombre.
- Descripción.
- Precio.
- Fecha de registro.

### reparaciones

Almacena información de los equipos recibidos para reparación:

- Cliente.
- Equipo.
- Problema.
- Estado.
- Fecha de registro.

### citas

Almacena las citas programadas:

- Cliente.
- Servicio.
- Fecha y hora de la cita.
- Estado.
- Fecha de registro.

## Autenticación

La autenticación de usuarios se realiza mediante Firebase Authentication utilizando correo electrónico y contraseña.

El sistema permite:

- Crear una cuenta.
- Iniciar sesión.
- Mantener identificado al usuario durante su sesión.
- Consultar los datos correspondientes a su perfil.
- Cerrar sesión.

Las contraseñas no se almacenan directamente en Cloud Firestore. Su administración se realiza mediante Firebase Authentication.

## Tecnologías utilizadas

- Flutter.
- Dart.
- Firebase Core.
- Firebase Authentication.
- Cloud Firestore.
- Android Studio.
- Android SDK.
- Material Design 3.
- Git.
- GitHub.

## Requisitos

Para ejecutar el proyecto se necesita:

- Flutter SDK instalado.
- Dart.
- Android Studio.
- Android SDK.
- Git.
- Un dispositivo Android o emulador.
- Conexión a Internet para utilizar los servicios de Firebase.

## Instalación

Clonar el repositorio:

```bash
git clone https://github.com/yerniso-n/vitexol_app.git