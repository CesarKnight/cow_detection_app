import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import '../viewmodels/camera_viewmodel.dart';
import '../widgets/breed_overlay.dart';

class CameraPage extends StatelessWidget {
  final CameraDescription camera;
  const CameraPage({required this.camera});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CameraViewModel(),
      child: CameraViewBody(camera: camera),
    );
  }
}

class CameraViewBody extends StatefulWidget {
  final CameraDescription camera;
  const CameraViewBody({required this.camera});

  @override
  State<CameraViewBody> createState() => _CameraViewBodyState();
}

class _CameraViewBodyState extends State<CameraViewBody> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<File> _takePicture() async {
    await _initializeControllerFuture;
    final image = await _controller.takePicture();
    return File(image.path);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CameraViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Detectar raza de vaca')),
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black, // color de fondo si la cámara tarda
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CameraPreview(_controller),
                  ),
                ),
                BreedOverlay(
                  analysis: viewModel.analysis,
                  errorMessage: viewModel.errorMessage,
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'start',
            onPressed: () {
              viewModel.startDetection(_takePicture);
            },
            child: Icon(Icons.play_arrow),
            tooltip: 'Iniciar detección',
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            heroTag: 'stop',
            onPressed: viewModel.stopDetection,
            child: Icon(Icons.stop),
            tooltip: 'Detener detección',
          ),
        ],
      ),
    );
  }
}
