# Mochi Studio · instaladores beta

Descargas públicas de [Mochi Studio 0.6.0-beta.1](https://github.com/Jose-SMG/Mochi-test/releases/tag/mochi-studio-v0.6.0-beta.1).

| Sistema | Descarga directa |
| --- | --- |
| Windows 10/11 x64 | [Instalador EXE](https://github.com/Jose-SMG/Mochi-test/releases/download/mochi-studio-v0.6.0-beta.1/Coucou-Mochi-0.6.0-beta.1-Windows-x64-setup.exe) |
| macOS 15+, Intel y Apple Silicon | [DMG universal](https://github.com/Jose-SMG/Mochi-test/releases/download/mochi-studio-v0.6.0-beta.1/Coucou-Mochi-0.6.0-beta.1-macOS-universal.dmg) |

La release también contiene MSI, ZIP portable, manifiestos y SHA-256. No hace falta una cuenta de GitHub para descargar los archivos de una release pública.

Cierra Coucou antes de instalar y guarda una copia de tus preferencias. La beta mantiene los identificadores de la aplicación original y puede sustituirla en la misma ubicación. En Windows ejecuta el EXE o MSI; en Mac abre el DMG y arrastra Coucou a Aplicaciones. El ZIP portable conserva el uso de las preferencias de Coucou y no crea un perfil aislado.

## Estado de la beta

- Windows no tiene firma comercial. Mac usa firma ad-hoc y no está notarizado. Los avisos del navegador o del sistema pueden continuar.
- El paquete de Mac usa Debug optimizado con `-O`; la integración PHONE_LINK/iCloud de la configuración Release original no está compilada en esta beta. Windows usa Release.
- Los dos paquetes nativos compilaron desde el mismo código y superaron la verificación de recursos y empaquetado. La prueba completa de arrastre, seguimiento y salto en la aplicación instalada todavía no ha pasado. Consulta [las limitaciones](docs/mochi/KNOWN-ISSUES.md).
- Esta es una beta de la comunidad para revisión y pruebas; no es una release oficial de Louis.

Los archivos se copian sin modificar desde la release previamente publicada en Jose-SMG/Pruebas. `distribution/import.json` fija los ocho archivos, sus tamaños y SHA-256; el proceso de migración verifica todo antes de publicar las descargas aquí. Los manifiestos conservan la revisión exacta de compilación `6b4e5ea2f80ab59375973c73034d1f16d020b49e`.

Para revisar el trabajo sin ejecutar un instalador, usa el [código y la presentación](presentation/review/README.md).
