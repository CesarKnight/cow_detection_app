import 'package:json_annotation/json_annotation.dart';

part 'image_analysis_response.g.dart';

@JsonSerializable()
class ImageAnalysisResponse {
  final String status;
  final String breed;
  final double confidence;
  final int weight;
  final String origin;
  final DateTime timestamp;
  final String visualization;

  ImageAnalysisResponse({
    required this.status,
    required this.breed,
    required this.confidence,
    required this.weight,
    required this.origin,
    required this.timestamp,
    required this.visualization,
  });

  factory ImageAnalysisResponse.fromJson(Map<String, dynamic> json) =>
      _$ImageAnalysisResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ImageAnalysisResponseToJson(this);
}
