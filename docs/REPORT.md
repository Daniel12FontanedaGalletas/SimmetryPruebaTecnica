# Reporte de Desarrollo - Applicant Showcase App

## 1. Introducción
Al comenzar este proyecto, mi objetivo era claro: implementar una funcionalidad que permitiera a los periodistas subir sus propios artículos. Aunque partía con una base sólida en desarrollo, me enfrentaba a tecnologías con las que no tenía experiencia directa, como la gestión de estado con **Flutter BLoC** y la **Clean Architecture** específica de este proyecto. 

## 2. Aprendizaje
Mi primera tarea fue sumergirme en el ecosistema de Flutter y Firebase. Seguí la ruta de aprendizaje sugerida, comenzando con los tutoriales oficiales de Flutter y avanzando hacia la integración con Firebase. El verdadero "click" ocurrió al estudiar la Clean Architecture. Entender cómo las capas de **Domain, Data y Presentation** se comunican, pero se mantienen independientes, fue fundamental para todo el trabajo posterior.

Apliqué este conocimiento de forma práctica:
-   **Domain Layer:** Definí las entidades y los contratos (repositorios abstractos) que formarían el núcleo de la nueva funcionalidad, sin pensar en Firebase o en la UI.
-   **Data Layer:** Implementé los repositorios, conectándolos a una fuente de datos de Firebase que yo mismo diseñé.
-   **Presentation Layer:** Utilicé Cubits para manejar el estado de la UI de forma reactiva, separando la lógica de la vista y gestionando los ciclos de carga, éxito y error.

## 3. Desafíos Superados
En esta etapa no tuve problemas de ningún tipo.

### El Muro de la Compilación en Windows
El desafío más grande fue, sin duda, la compilación nativa para Windows. Me encontré con una serie de errores persistentes que impedían que la aplicación se ejecutara:
-   **Errores de Enlazado (Linker):** El compilador no encontraba las librerías nativas de Firebase (`firebase_core.lib`, etc.). La solución no era simplemente nombrar las librerías, sino entender cómo CMake gestiona las dependencias. Tras investigar, modifiqué el `CMakeLists.txt` para enlazar contra los *targets* que los propios plugins de Flutter exponen (ej. `firebase_core_plugin`), lo que finalmente resolvió el problema de rutas.
-   **Errores de Inclusión de Encabezados:** El archivo `generated_plugin_registrant.h` no se encontraba. Comprendí que el problema era una ruta de inclusión faltante y la añadí explícitamente en el `CMakeLists.txt` del `runner`.
-   **Errores de Parseo en CMake:** Un error particularmente frustrante fue causado por caracteres de espacio invisibles en el `CMakeLists.txt`. Esto me enseñó la importancia de la pulcritud del código incluso en los archivos de configuración.

### La Autenticación de Firebase en Windows
Una vez compilada, la subida de imágenes fallaba con un error `403 Permission Denied`, a pesar de que mis reglas de seguridad eran correctas. Descubrí que el SDK de Firebase para Windows no gestionaba la autenticación de la misma forma que en móvil o web. Investigué el protocolo subyacente y **implementé una solución alternativa usando una llamada REST directa** a la API de Firebase Storage, inyectando manualmente el token de autenticación del usuario en la cabecera `Authorization`. Esto solucionó el problema.

### La Estructura de la Inyección de Dependencias
El uso de `get_it` presentó sus propios retos, con errores de "dependencia no registrada". El problema real era una configuración conflictiva y un orden de inicialización incorrecto. Centralicé toda la lógica en `injection_container.dart`, eliminé duplicados y reorganicé la inicialización para que las dependencias asíncronas (como la base de datos local) se completaran antes de que la aplicación intentara usarlas.

## 4. Reflexión y Futuras Direcciones
Para el futuro, consideraría implementar un sistema de caché más avanzado en el `Data Layer` para mejorar el rendimiento offline o añadir tests unitarios y de integración para blindar la funcionalidad que he creado, siguiendo la filosofía TDD que promueve Symmetry.

## 5. Overdelivery
Fiel al valor de "Maximally Overdeliver", no me limité a implementar la funcionalidad básica. Añadí varias capas de robustez y calidad:

1.  **Seguridad Real en el Backend:** En lugar de usar las reglas de testeo por defecto, diseñé e implementé **reglas de seguridad completas para Firestore y Storage**. Mis reglas validan que los datos tengan la estructura correcta y, más importante, que cada usuario solo pueda escribir en su propia carpeta de almacenamiento (`/media/articles/{userId}/...`), garantizando la privacidad y la integridad de los datos.

2.  **Arquitectura Modular y Escalable:** La funcionalidad de "subida de artículos" se construyó en su propio módulo (`features/article_upload`), completamente aislado del módulo de noticias (`daily_news`). Esto significa que el equipo puede trabajar en una funcionalidad sin riesgo de afectar a la otra, un principio clave para la mantenibilidad a largo plazo.

3.  **Manejo de Errores Funcional:** Adopté la librería `dartz` para implementar el patrón `Either`. En lugar de usar `try-catch` de forma indiscriminada, mis repositorios y casos de uso devuelven un `Either<Failure, Success>`, lo que permite a la capa de presentación manejar los errores de forma declarativa y mostrar mensajes claros al usuario ante cualquier fallo.

4.  **Integración Completa del Ciclo de Vida del Artículo:** Pensé en el flujo completo. No solo creé artículos, sino que me aseguré de que se pudieran **publicar en la portada principal**, **guardar en favoritos** (solucionando un problema con los IDs para la base de datos local) y **eliminar de la portada**, integrando la nueva entidad con los BLoCs existentes.

## 6. FIN =D