import 'dart:convert';
import 'package:flutter/material.dart';
import '../viewmodels/camera_viewmodel.dart';
import '../models/image_analysis_response.dart';

class DetectionControlSheet extends StatelessWidget {
  final CameraViewModel viewModel;
  final double initialChildSize;
  final DraggableScrollableController scrollableController;
  final Future<void> Function() onToggleDetection;

  const DetectionControlSheet({
    super.key,
    required this.viewModel,
    required this.initialChildSize,
    required this.scrollableController,
    required this.onToggleDetection,
  });

  @override
  Widget build(BuildContext context) {
    final analysis = viewModel.analysis;
    final errorMessage = viewModel.errorMessage;

    return DraggableScrollableSheet(
      controller: scrollableController,
      initialChildSize: initialChildSize,
      minChildSize: initialChildSize,
      maxChildSize: 1.0,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, -2))
            ],
          ),
          padding: EdgeInsets.all(16),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: viewModel.isDetecting ? Colors.red : Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: Icon(viewModel.isDetecting ? Icons.stop : Icons.play_arrow),
                label: Text(viewModel.isDetecting ? 'Detener detección' : 'Iniciar detección'),
                onPressed: () async {
                  await onToggleDetection();
                },
              ),
              SizedBox(height: 16),

              // Mostrar mensaje de error si existe
              if (errorMessage != null && errorMessage.isNotEmpty)
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.redAccent.withOpacity(0.8),
                  ),
                  child: Center(
                    child: Text(
                      errorMessage,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),

              // Mostrar análisis si existe
              if (analysis != null) ...[
                Text('Raza: ${analysis.breed}', style: TextStyle(color: Colors.white, fontSize: 18)),
                Text('Confianza: ${(analysis.confidence * 100).toStringAsFixed(1)}%', style: TextStyle(color: Colors.white)),
                Text('Peso estimado: ${analysis.weight} kg', style: TextStyle(color: Colors.white)),
                Text('Origen: ${analysis.origin}', style: TextStyle(color: Colors.white)),
                SizedBox(height: 8),
                if (analysis.visualization.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(
                      base64Decode(analysis.visualization),
                      height: 500,
                      fit: BoxFit.contain,
                    ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}