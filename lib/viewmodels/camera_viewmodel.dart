import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../models/image_analysis_response.dart';
import '../services/backend_service.dart';
import '../config.dart';

class CameraViewModel extends ChangeNotifier {
  ImageAnalysisResponse? _analysis;
  String? _errorMessage;
  bool _isDetecting = false;
  bool _showCameraFlash = false; // nuevo

  ImageAnalysisResponse? get analysis => _analysis;
  String? get errorMessage => _errorMessage;
  bool get isDetecting => _isDetecting;
  bool get showCameraFlash => _showCameraFlash; // nuevo

  Future<void> startDetection(Future<File> Function() takePicture) async {
    if (_isDetecting) return;
    _isDetecting = true;
    _errorMessage = null;
    _analysis = null;
    notifyListeners();

    await _detectionLoop(takePicture);
  }

  Future<void> _detectionLoop(Future<File> Function() takePicture) async {
    while (_isDetecting) {
      try {
        _showCameraFlash = true;
        notifyListeners();
        await Future.delayed(Duration(milliseconds: AppConfig.cameraFlashDurationMs));
        _showCameraFlash = false;
        notifyListeners();
        
        final file = await takePicture();
        final directory = await getTemporaryDirectory();
        final tempImage = await file.copy(
          path.join(directory.path, '${DateTime.now().millisecondsSinceEpoch}.jpg'),
        );

        final response = await BackendService.analyzeImage(tempImage);

        _analysis = response;
        _errorMessage = null;
        _isDetecting = false;
        notifyListeners();
        break;
      } catch (e) {
        print('Error: $e');
        _analysis = null;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        notifyListeners();

        // Espera el intervalo antes de reintentar
        await Future.delayed(Duration(seconds: AppConfig.captureIntervalSeconds));
      }
    }
  }

  void stopDetection() {
    _isDetecting = false;
    _analysis = null;
    _errorMessage = null;
    notifyListeners();
  }
}