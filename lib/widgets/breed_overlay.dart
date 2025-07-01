import 'package:flutter/material.dart';

class BreedOverlay extends StatelessWidget {
  final String breed;

  const BreedOverlay({super.key, required this.breed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 20,
      child: Container(
        color: Colors.black54,
        padding: EdgeInsets.all(8),
        child: Text(
          'Raza: $breed',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}