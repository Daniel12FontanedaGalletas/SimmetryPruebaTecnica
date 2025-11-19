# Applicant Showcase App - Reporte de Desarrollo

## 1. Resumen Ejecutivo
El objetivo de este proyecto fue implementar la funcionalidad de carga de artículos para periodistas ("Reporter Feature") sobre una base de código existente, utilizando Flutter y Firebase. 

A pesar de no tener experiencia previa con Flutter BLoC ni Clean Architecture, logré implementar una solución funcional, modular y escalable en el plazo establecido, superando desafíos técnicos significativos relacionados con la configuración del entorno en Windows.

## 2. Implementación Técnica
Se respetó estrictamente la **Clean Architecture** para garantizar la escalabilidad:

* **Domain Layer:** Entidades puras y contratos (Interfaces) agnósticos de la implementación.
* **Data Layer:** Implementación robusta con `FirebaseFirestore` y `FirebaseStorage`. Se utilizó el patrón *Repository* para desacoplar la lógica de negocio de la fuente de datos.
* **Presentation Layer:** Gestión de estado reactiva utilizando **Flutter BLoC (Cubits)** para manejar los estados de carga, éxito y error de la UI.
* **Inyección de Dependencias:** Se implementó `get_it` para gestionar las dependencias y facilitar el testing y la mantenibilidad.

## 3. Desafíos y Soluciones ("Truth is King")

### Configuración de Entorno en Windows
**Desafío:** La configuración automática de Firebase (`flutterfire configure`) presentó incompatibilidades en el entorno de desarrollo Windows local.
**Solución:** En lugar de atascarme, opté por una **inicialización manual explícita** en `main.dart` utilizando las credenciales de `google-services.json`. Esto garantizó una conexión estable sin depender de herramientas CLI automáticas que fallaban en este entorno específico.

### Gestión de Rutas
**Desafío:** La integración de la nueva feature `article_upload` con el módulo existente `daily_news` generó conflictos de resolución de rutas en Dart.
**Solución:** Se refactorizó el sistema de importaciones para utilizar **rutas absolutas de paquete** (`package:news_app...`), asegurando que el compilador y el inyector de dependencias localizaran correctamente los nuevos módulos.

## 4. Maximally Overdeliver (Valor Añadido)

Además de los requisitos funcionales, añadí las siguientes mejoras:

1.  **Seguridad en Backend:** No me limité al "Test Mode" inseguro. Diseñé e implementé **Reglas de Seguridad (Firestore Rules & Storage Rules)** que validan la estructura de los datos (tipos de datos correctos) y aseguran que los archivos se guarden en carpetas aisladas por usuario.
2.  **Arquitectura Escalable:** La feature de subida de artículos está completamente aislada en su propia carpeta (`features/article_upload`), lo que permite que futuros desarrolladores trabajen en ella sin romper el módulo de noticias diarias.
3.  **Manejo de Errores:** Implementación de `dartz` (Either) para un manejo funcional de errores, permitiendo que la UI reaccione elegantemente ante fallos de red o base de datos.

---
*Desarrollado con pasión por la excelencia y la verdad.*