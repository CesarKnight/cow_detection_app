import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../services/backend_service.dart';
import '../widgets/breed_overlay.dart';
import '../config.dart';

class CameraPage extends StatefulWidget {
  final CameraDescription camera;
  const CameraPage({super.key, required this.camera});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  Timer? _timer;
  String? _breedDetected;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startDetection() {
    _timer = Timer.periodic(Duration(seconds: AppConfig.captureIntervalSeconds), (timer) async {
      try {
        await _initializeControllerFuture;

        final image = await _controller.takePicture();

        // Guarda temporalmente (opcional)
        final directory = await getTemporaryDirectory();
        final tempImage = await File(image.path).copy(
          path.join(directory.path, '${DateTime.now().millisecondsSinceEpoch}.jpg'));

        // Llama al backend (ahora pasando el File)
        final response = await BackendService.detectBreed(tempImage);

        setState(() {
          _breedDetected = response.analysis;
        });
      } catch (e) {
        print('Error capturando o enviando: $e');
        setState(() {
          _breedDetected = 'Error: $e';
        });
      }
    });
  }

  void _stopDetection() {
    _timer?.cancel();
    setState(() {
      _breedDetected = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detectar raza de vaca')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                CameraPreview(_controller),
                if (_breedDetected != null)
                  BreedOverlay(breed: _breedDetected!)
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
            onPressed: _startDetection,
            child: Icon(Icons.play_arrow),
            tooltip: 'Iniciar detección',
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            heroTag: 'stop',
            onPressed: _stopDetection,
            child: Icon(Icons.stop),
            tooltip: 'Detener detección',
          ),
        ],
      ),
    );
  }
}