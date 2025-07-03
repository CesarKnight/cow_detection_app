class AppConfig {
  // Camera configs
  static const int cameraFlashDurationMs = 500; // Duración del flash de la cámara en milisegundos
  static const int captureIntervalSeconds = 5;
  
  // Server configs
  static const String backendUrl = 'http://192.168.0.10:8000/api/image/analyze';
  static const int requestTimeoutSeconds = 7; // por ejemplo, 5 segundos
}