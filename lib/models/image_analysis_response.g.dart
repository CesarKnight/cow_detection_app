// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_analysis_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageAnalysisResponse _$ImageAnalysisResponseFromJson(
  Map<String, dynamic> json,
) => ImageAnalysisResponse(
  analysis: json['analysis'] as String,
  status: json['status'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$ImageAnalysisResponseToJson(
  ImageAnalysisResponse instance,
) => <String, dynamic>{
  'analysis': instance.analysis,
  'status': instance.status,
  'timestamp': instance.timestamp.toIso8601String(),
};
