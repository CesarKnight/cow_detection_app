// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_analyze_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageAnalyzeRequest _$ImageAnalyzeRequestFromJson(Map<String, dynamic> json) =>
    ImageAnalyzeRequest(
      base64_image: json['base64_image'] as String?,
      image_url: json['image_url'] as String?,
      prompt: json['prompt'] as String?,
      model: json['model'] as String?,
    );

Map<String, dynamic> _$ImageAnalyzeRequestToJson(
  ImageAnalyzeRequest instance,
) => <String, dynamic>{
  'base64_image': instance.base64_image,
  'image_url': instance.image_url,
  'prompt': instance.prompt,
  'model': instance.model,
};
