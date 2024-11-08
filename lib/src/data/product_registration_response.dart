import 'dart:convert';

List<ProductRegistrationResponse> productRegistrationResponseFromJson(
        String str) =>
    List<ProductRegistrationResponse>.from(
        json.decode(str).map((x) => ProductRegistrationResponse.fromJson(x)));

String productRegistrationResponseToJson(
        List<ProductRegistrationResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductRegistrationResponse {
  String message;
  int returnCode;

  ProductRegistrationResponse({
    required this.message,
    required this.returnCode,
  });

  factory ProductRegistrationResponse.fromJson(Map<String, dynamic> json) =>
      ProductRegistrationResponse(
        message: json["Message"],
        returnCode: json["ReturnCode"],
      );

  Map<String, dynamic> toJson() => {
        "Message": message,
        "ReturnCode": returnCode,
      };
}
