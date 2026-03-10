# JarvisApp (MVP base)

Esta versión deja una base funcional del MVP:

- Configuración persistida de host y token.
- Chat real contra `/v1/chat/completions` en backend compatible OpenAI.
- UI simple para conversación + pantalla de ajustes.

## Notas

- El token local se mantiene en `lib/core/config/dev_gateway_local.dart` para desarrollo.
- En entorno real, usar un flujo de autenticación seguro y no hardcodear secretos.
