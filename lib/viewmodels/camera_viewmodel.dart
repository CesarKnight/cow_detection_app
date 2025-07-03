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
  Timer? _timer;

  ImageAnalysisResponse? get analysis => _analysis;
  String? get errorMessage => _errorMessage;

  Future<void> startDetection(Future<File> Function() takePicture) async {
    _timer = Timer.periodic(
      Duration(seconds: AppConfig.captureIntervalSeconds),
      (timer) async {
        try {
          final file = await takePicture();

          final directory = await getTemporaryDirectory();
          final tempImage = await file.copy(
            path.join(directory.path, '${DateTime.now().millisecondsSinceEpoch}.jpg'));

          final response = await BackendService.analyzeImage(tempImage);
  
          _analysis = response;
          _errorMessage = null;
          notifyListeners();
        } catch (e) {
          print('Error: $e');
          _analysis = null;
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
          notifyListeners();
        }
      },
    );
  }

  void stopDetection() {
    _timer?.cancel();
    _analysis = null;
    _errorMessage = null;
    notifyListeners();
  }
}