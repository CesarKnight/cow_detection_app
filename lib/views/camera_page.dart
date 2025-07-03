import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';

import '../viewmodels/camera_viewmodel.dart';
import '../widgets/breed_draggable.dart';
import '../widgets/detection_status_label.dart';

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
  final DraggableScrollableController _draggableController = DraggableScrollableController();
  bool _isPanelExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    _draggableController.dispose();
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

    // Cuando hay resultado, expandir panel
    if (viewModel.analysis != null && !_isPanelExpanded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _draggableController.animateTo(
          1.0,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
        _isPanelExpanded = true;
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Detección de raza bovina', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.info, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final screenHeight = constraints.maxHeight;
                final cameraHeightFraction = 0.8;
                final remainingFraction = 1 - cameraHeightFraction;

                return Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: screenHeight * cameraHeightFraction,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CameraPreview(_controller),
                        ),
                      ),
                    ),
                    DetectionStatusLabel(viewModel: viewModel),
                    DetectionControlSheet(
                      viewModel: viewModel,
                      initialChildSize: remainingFraction,
                      scrollableController: _draggableController,
                      onToggleDetection: () async {
                        if (viewModel.isDetecting) {
                          // Detener
                          viewModel.stopDetection();
                        } else {
                          // Si panel está expandido, colapsar antes de detectar
                          if (_isPanelExpanded) {
                            await _draggableController.animateTo(
                              remainingFraction,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeOut,
                            );
                            _isPanelExpanded = false;
                          }
                          // Iniciar detección
                          await viewModel.startDetection(_takePicture);
                        }
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}