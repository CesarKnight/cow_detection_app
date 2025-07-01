import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'views/camera_page.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cow Breed Detector',
      theme: ThemeData(primarySwatch: Colors.green),
      home: CameraPage(camera: cameras.first),
    );
  }
}