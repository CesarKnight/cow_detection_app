import 'package:json_annotation/json_annotation.dart';

part 'image_analysis_response.g.dart';

@JsonSerializable()
class ImageAnalysisResponse {
  final String analysis;
  final String status;
  final DateTime timestamp;

  ImageAnalysisResponse({
    required this.analysis,
    required this.status,
    required this.timestamp,
  });

  factory ImageAnalysisResponse.fromJson(Map<String, dynamic> json) =>
      _$ImageAnalysisResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ImageAnalysisResponseToJson(this);
}