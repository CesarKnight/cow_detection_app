import 'package:flutter/material.dart';
import '../viewmodels/camera_viewmodel.dart';

class DetectionStatusLabel extends StatelessWidget {
  final CameraViewModel viewModel;

  const DetectionStatusLabel({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    if (!viewModel.isDetecting && !viewModel.showCameraFlash) {
      return SizedBox.shrink();
    }

    return Positioned(
      top: 16,
      right: 16,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(8),
        ),
        child: viewModel.showCameraFlash
            ? Icon(Icons.camera, color: Colors.white, size: 24)
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Detectando...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
      ),
    );
  }
}