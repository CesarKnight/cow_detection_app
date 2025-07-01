import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/image_analyze_request.dart';
import '../models/image_analysis_response.dart';

class BackendService {
  static Future<ImageAnalysisResponse> detectBreed(File imageFile) async {
    try {
      // Lee la imagen como bytes y conviértela a base64
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Construye el request model
      final requestModel = ImageAnalyzeRequest(
        base64_image: base64Image
      );

      print(requestModel.toJson());
      
      // Envía la petición POST con JSON
      final response = await http.post(
        Uri.parse(AppConfig.backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestModel.toJson()),
      ).timeout(Duration(seconds: AppConfig.requestTimeoutSeconds));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return ImageAnalysisResponse.fromJson(decoded);
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Error: tiempo de espera agotado');
    } on SocketException {
      throw Exception('Error: sin conexión al servidor');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}
