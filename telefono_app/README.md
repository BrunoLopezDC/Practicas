## Limitaciones Técnicas: Implementación BLE
Durante la fase de integración, se identificaron inconsistencias en la capa de abstracción de BLE al utilizar emuladores de Android Studio, aunque se validó la arquitectura lógica servidor-cliente (BleServer y BleClient) conforme a los estándares GATT y el uso de notificaciones (NOTIFY), el stack de comunicación de radio virtual en el entorno de emulación presenta limitaciones de estabilidad que impiden la resolución completa de los handshakes de conexión entre instancias de emuladores.

Notas de la implementación:

Arquitectura: El proyecto sigue estrictamente el flujo de datos unidireccional: SensorSimulator → BleServer → BleClient → ActivityProvider → UI.

Estado: Se confirmó mediante adb devices y las herramientas de desarrollo de Android que la infraestructura de red virtual está correctamente configurada, pero el radio BLE virtual presenta intermitencias en la persistencia de las conexiones GATT.