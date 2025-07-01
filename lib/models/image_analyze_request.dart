import 'package:json_annotation/json_annotation.dart';

part 'image_analyze_request.g.dart';

@JsonSerializable()
class ImageAnalyzeRequest {
  final String? base64_image;
  final String? image_url;
  final String? prompt;
  final String? model;

  ImageAnalyzeRequest({
    // ignore: non_constant_identifier_names
    this.base64_image,
    // ignore: non_constant_identifier_names
    this.image_url,
    this.prompt,
    this.model,
  });

  factory ImageAnalyzeRequest.fromJson(Map<String, dynamic> json) =>
      _$ImageAnalyzeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ImageAnalyzeRequestToJson(this);
}
