import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/image_analysis_response.dart';

class BreedOverlay extends StatelessWidget {
  final ImageAnalysisResponse? analysis;
  final String? errorMessage;

  const BreedOverlay({
    super.key,
    required this.analysis,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null && errorMessage!.isNotEmpty) {
      // Mostrar mensaje de error
      return Positioned(
        bottom: 20,
        left: 20,
        right: 20,
        child: Container(
          color: Colors.redAccent.withOpacity(0.8),
          padding: EdgeInsets.all(8),
          child: Text(
            errorMessage!,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    } else if (analysis != null) {
      // Mostrar datos de análisis
      return Positioned(
        bottom: 20,
        left: 20,
        right: 20,
        child: Container(
          color: Colors.black54,
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Raza: ${analysis!.breed}', style: TextStyle(color: Colors.white, fontSize: 18)),
              Text('Confianza: ${(analysis!.confidence * 100).toStringAsFixed(1)}%', style: TextStyle(color: Colors.white)),
              Text('Peso estimado: ${analysis!.weight} kg', style: TextStyle(color: Colors.white)),
              Text('Origen: ${analysis!.origin}', style: TextStyle(color: Colors.white)),
              SizedBox(height: 4),
              if (analysis!.visualization.isNotEmpty)
                Image.memory(
                  base64Decode(analysis!.visualization),
                  height: 100,
                  fit: BoxFit.cover,
                ),
            ],
          ),
        ),
      );
    } else {
      // Nada que mostrar
      return SizedBox.shrink();
    }
  }
}
