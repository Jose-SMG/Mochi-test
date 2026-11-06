# Firma de la beta

La firma de confianza requiere una identidad real. Los scripts están preparados, pero no se ha emitido ni comprado ningún certificado y no se deben pegar claves o certificados privados en el chat.

## Averiguar qué tenéis

En Windows, PowerShell puede listar los certificados de firma ya instalados sin exportar sus claves:

```powershell
Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert | Select-Object Subject, NotAfter, HasPrivateKey
```

En Mac, Terminal puede listar identidades disponibles:

```sh
security find-identity -v -p codesigning
```

Si no aparece una identidad adecuada, coordinad la firma con Louis o con quien gestione la publicación. Para conservar las capacidades y los identificadores originales de Coucou debe revisarse también la configuración del equipo de desarrollo. Tener un certificado de desarrollo no equivale a tener Developer ID para distribuir fuera de la App Store.

## Windows

Instala el certificado y su clave privada en el almacén del usuario que compila, o adapta la firma a un proveedor gestionado. Configura `COUCOU_WINDOWS_CERT_THUMBPRINT` con la huella del certificado. El script genera una configuración de Tauri con SHA-256 y sello de tiempo y verifica las firmas del ejecutable y de los instaladores. La ruta opcional de firma todavía requiere una prueba con una identidad real.

## Mac

Con una identidad Developer ID válida instalada, configura `COUCOU_MAC_SIGN_IDENTITY`. Para notarizar, configura también `COUCOU_MAC_NOTARY_PROFILE` con un perfil de notarytool guardado en el llavero. El script firma, verifica y, cuando hay perfil, envía el DMG a Apple, grapa el ticket y lo valida. No configura ni exporta credenciales por sí solo.

## Comprobar antes de publicar

Revisa los manifiestos y el resultado efectivo: Authenticode válido en Windows, Developer ID y notarización/ticket válidos en Mac. Los certificados de prueba o una firma ad-hoc no crean reputación comercial. Incluso una firma válida no garantiza que desaparezcan todos los avisos del navegador o del sistema.
