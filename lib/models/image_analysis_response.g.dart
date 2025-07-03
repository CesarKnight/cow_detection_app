// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_analysis_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageAnalysisResponse _$ImageAnalysisResponseFromJson(
  Map<String, dynamic> json,
) => ImageAnalysisResponse(
  status: json['status'] as String,
  breed: json['breed'] as String,
  confidence: (json['confidence'] as num).toDouble(),
  weight: (json['weight'] as num).toInt(),
  origin: json['origin'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  visualization: json['visualization'] as String,
);

Map<String, dynamic> _$ImageAnalysisResponseToJson(
  ImageAnalysisResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'breed': instance.breed,
  'confidence': instance.confidence,
  'weight': instance.weight,
  'origin': instance.origin,
  'timestamp': instance.timestamp.toIso8601String(),
  'visualization': instance.visualization,
};
