# Instalar Coucou Community

Los instaladores anteriores se han retirado porque compartían los identificadores de Coucou.

La nueva [preview independiente](https://github.com/Jose-SMG/Mochi-test/releases/tag/coucou-community-v0.1.1-beta.1) se publica cuando pasan las compilaciones y comprobaciones de aislamiento. GitHub genera el DMG universal de macOS y los instaladores EXE/MSI de Windows desde el código de este repositorio; los manifiestos indican el commit y las sumas SHA-256.

En Mac, abre el DMG y arrastra **Coucou Community** a Aplicaciones. En Windows, ejecuta el EXE o MSI. Usa nombre, versión, identificadores y ajustes propios, y puede convivir con Coucou. No importa ni elimina las preferencias de Coucou. Los hooks de agentes, atajos globales y actualizaciones automáticas están desactivados.

Los paquetes de Windows no tienen firma de confianza y el DMG usa firma ad-hoc, sin notarización. Estos cambios de identidad no eliminan por sí solos los avisos de Windows o macOS. No incluye sincronización iCloud/iPhone.

Habitación y atuendos son una preview comunitaria. Enganches y saltos siguen siendo experimentales y no se presentan como funciones totalmente validadas.

Si ya instalaste la antigua beta que se llamaba Coucou, la preview independiente no restaura por sí sola la aplicación que aquella hubiera sustituido. Conserva una copia de tus preferencias y usa las [descargas oficiales de Coucou](https://github.com/Louis-CFM/coucou/releases) para recuperarla. No utilices el antiguo desinstalador para limpiar carpetas compartidas ni borres manualmente los ajustes de Claude Code.

La app muestra **Coucou** en su barra y junto al reloj. El instalador y el acceso de Inicio se llaman **Coucou Community**.

Para quedarte con una sola versión en Windows, cierra ambas desde la bandeja del reloj. En Configuración → Aplicaciones → Aplicaciones instaladas, retira el Coucou antiguo y Mochi Studio Preview; después instala Coucou Community. Desinstalar nuestra preview conserva la habitación y los estilos guardados en su carpeta de preferencias. No borres manualmente esas carpetas.
