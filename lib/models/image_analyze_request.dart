import 'package:json_annotation/json_annotation.dart';

part 'image_analyze_request.g.dart';

@JsonSerializable()
class ImageAnalyzeRequest {
  final String? base64_image;
  final String? image_url;

  ImageAnalyzeRequest({
    this.base64_image,
    this.image_url,
  });

  factory ImageAnalyzeRequest.fromJson(Map<String, dynamic> json) =>
      _$ImageAnalyzeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ImageAnalyzeRequestToJson(this);
}