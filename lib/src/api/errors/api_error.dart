import 'package:json_annotation/json_annotation.dart';

part 'api_error.g.dart';

@JsonSerializable()
class ApiError {
  final String? message;
  final String? content;

  ApiError({this.message, this.content});

  factory ApiError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorFromJson(json);
  Map<String, dynamic> toJson() => _$ApiErrorToJson(this);

  static ApiError customErrorConverter(Map<String, dynamic> json) {
    return ApiError.fromJson(json);
  }
}
