# Jardín Botánico Garden'Species D&M

> **Una aplicación interactiva especializada para explorar especies botánicas, zonas geográficas y rutas ecológicas guiadas**

---

## Descripción General

**Jardín Botánico Garden'Species D&M** es una aplicación kiosco interactiva especializada desarrollada con el motor **Unity**. Su propósito principal es servir como un centro digital de información para jardines botánicos, permitiendo a los visitantes explorar especies vegetales, zonas geográficas y rutas ecológicas guiadas. El sistema integra una base de datos SQLite para gestionar datos taxonómicos e imágenes botánicas de alta resolución.

La aplicación está diseñada para interacción táctil en pantallas de kiosco, proporcionando una interfaz visual y educativa para los visitantes. Cierra la brecha entre los especímenes botánicos físicos e información digital, ofreciendo vistas categorizadas basadas en zonas geográficas (como Zona Norte, Zona Tropical) y colecciones ecológicas (como Bosque de Niebla, Plantas Exóticas).

### Especificaciones Técnicas

| Componente | Descripción |
|-----------|-------------|
| **Motor** | Unity 2023.2.20f1 |
| **Almacenamiento de Datos** | SQLite (`Informacion.db`) |
| **Lenguaje Primario** | C# |
| **Hardware Objetivo** | Kioscos Interactivos / PC |

---

## Propósito del Sistema y Contexto

La aplicación proporciona una interfaz de educación e información visual para visitantes de jardines botánicos. Su arquitectura permite una fácil navegación entre diferentes categorías de plantas y zonas, facilitando tanto la exploración libre como recorridos guiados temáticos basados en aspectos ecológicos y educativos.

Los usuarios pueden acceder a información detallada sobre cada especie, incluyendo fotografías, datos taxonómicos y su ubicación dentro del jardín.

---

## Estructura del Repositorio

El repositorio está organizado para incluir no solo el código fuente funcional, sino también documentación académica y demostraciones multimedia del sistema en acción.


### Contenido Multimedia

El repositorio incluye cuatro videos MP4 que demuestran la capacidad de respuesta y diseño visual del sistema:

- **Interaccion.mp4**: Demostración de interacción táctil general
- **Menu navegacion.mp4**: Flujo entre módulos principales
- **Recorridos.mp4**: Demostración de rutas guiadas
- **Zonas Especimenes.mp4**: Exploración de áreas geográficas específicas

---

## Arquitectura Funcional de Alto Nivel

La aplicación sigue una arquitectura de navegación basada en escenas típica de proyectos Unity. Los datos se desvinculan de la interfaz de usuario, con una base de datos SQLite central proporcionando contenido para las pantallas de especímenes.

### Mapeo del Sistema: Software a Entidades Botánicas

El sistema mapea entidades de software (Scripts y Escenas) a la estructura física y organizacional del jardín botánico:

```
Base de Datos SQLite (Informacion.db)
    ↓
Especímenes (Fotos, Datos Taxonómicos)
    ↓
Zonas Geográficas (Zona Norte, Zona Tropical, etc.)
    ↓
Rutas Ecológicas Guiadas (Agua, Energía, Evolución, Memoria, Suelo)
    ↓
Interfaz de Usuario Unity
    ↓
Pantalla Táctil del Kiosco
```

---

## Experiencia de Usuario y Flujo de Navegación

El flujo de la aplicación comienza desde una pantalla de inicio (`Inicio`) que lleva a un `Menu` central. Desde el menú, los usuarios pueden acceder a diferentes módulos:

### Módulos Principales

1. **Mapa**: Una vista interactiva general del jardín
2. **Recorridos**: Cinco rutas específicas guiadas
   - Agua
   - Energía
   - Evolución
   - Memoria
   - Suelo
3. **Zonas**: Cuatro sectores geográficos
4. **Especímenes**: Lista búsqueda de plantas individuales

### Flujo de Escenas

```
Inicio (Pantalla de Carga)
    ↓
Menu (Centro de Navegación)
    ├── Mapa
    ├── Recorridos
    ├── Zonas
    ├── Especímenes
    ├── Info
    └── Ayuda
```

---

## Arquitectura del Proyecto Unity

### Estructura de Escenas

El proyecto utiliza una estructura de escenas bien definida que facilita la navegación y la gestión de contenido:

**Escenas de Navegación Principal**
- `Inicio`: Pantalla de presentación y carga
- `Menu`: Centro de navegación principal
- `Mapa`: Vista interactiva del jardín
- `Recorridos`: Gestor de rutas ecológicas guiadas
- `Info`: Información general del proyecto
- `Ayuda`: Guía de ayuda interactiva

**Escenas de Contenido**
- `Especimenes`: Galería de plantas individuales
- `Zona`: Vistas específicas de zonas geográficas

### Capa de Scripts C#

Los scripts C# proporcionan la lógica funcional central:

- Gestión de conexión a base de datos SQLite
- Carga dinámica de contenido (especímenes, fotos, datos taxonómicos)
- Manejo de interacciones táctiles
- Control de animaciones y transiciones de UI
- Gestión de estados de navegación

### Animaciones y Controladores Animator

El proyecto utiliza Animator Controllers de Unity para gestionar:

- Animaciones de botones de navegación (mostrar/ocultar)
- Transiciones suave entre escenas
- Efectos visuales de interacción táctil
- Cambios de estado de UI

---

## Documentación y Guías

El proyecto está respaldado por dos manuales primarios que facilitan el mantenimiento y la operación:

### Manual Desarrollo.pdf

Enfocado en el ambiente técnico:
- Estructura del proyecto

### Manual Usuario.pdf

Explica las interacciones de interfaz:
- Guía de navegación paso a paso
- Instrucciones para operadores de kiosco

---

## Glosario de Términos

- **Kiosco**: Terminal interactiva de pantalla táctil para acceso público
- **Especímenes**: Ejemplares individuales de plantas en el jardín
- **Zona**: Sector geográfico o ecológico del jardín
- **Recorrido**: Ruta temática guiada que agrupa especies por característica ecológica
- **Taxonómico**: Relativo a la clasificación científica de organismos
- **Prefab**: Plantilla de GameObject prediseñada en Unity
- **Animator Controller**: Máquina de estados para gestionar animaciones

---

## Autoría

Este programa fue desarrollado como proyecto de tesis en la **Universidad Distrital Francisco José de Caldas** por **Dalia Marcela Muñoz Araque y Maycol Hernández García** bajo la dirección de **Paulo Alonso Gaona García**.

---

## Disclaimer

Jardín Botánico Garden'Species D&M es una herramienta educativa e informativa. La información botánica y taxonómica proporcionada debe ser verificada con fuentes especializadas en botánica y taxonomía. El sistema está diseñado como complemento a la experiencia física en el jardín botánico y no reemplaza las guías profesionales de expertos en botánica.
