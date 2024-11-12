import 'dart:convert';

ProductRegistrationRequest productRegistrationRequestFromJson(String str) =>
    ProductRegistrationRequest.fromJson(json.decode(str));

String productRegistrationRequestToJson(ProductRegistrationRequest data) =>
    json.encode(data.toJson());

class ProductRegistrationRequest {
  String srcSystemCode;
  List<Registration> registration;

  ProductRegistrationRequest({
    required this.srcSystemCode,
    required this.registration,
  });

  factory ProductRegistrationRequest.fromJson(Map<String, dynamic> json) =>
      ProductRegistrationRequest(
        srcSystemCode: json["src_system_code"],
        registration: List<Registration>.from(
            json["registration"].map((x) => Registration.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "src_system_code": srcSystemCode,
        "registration": List<dynamic>.from(registration.map((x) => x.toJson())),
      };
}

class Registration {
  String countryOfOrigin;
  String brandName;
  String functionalName;
  String manufacturerName;
  String registrationNumber;
  String batchNumber;
  String expirationDate;
  int quantity;
  String type;
  String location;

  Registration({
    required this.countryOfOrigin,
    required this.brandName,
    required this.functionalName,
    required this.manufacturerName,
    required this.registrationNumber,
    required this.batchNumber,
    required this.expirationDate,
    required this.quantity,
    required this.type,
    required this.location,
  });

  factory Registration.fromJson(Map<String, dynamic> json) => Registration(
        countryOfOrigin: json["country_of_origin"],
        brandName: json["brand_name"],
        functionalName: json["functional_name"],
        manufacturerName: json["manufacturer_name"],
        registrationNumber: json["registration_number"],
        batchNumber: json["batch_number"],
        expirationDate: json["expiration_date"],
        quantity: json["quantity"],
        type: json["type"],
        location: json["location"],
      );

  Map<String, dynamic> toJson() => {
        "country_of_origin": countryOfOrigin,
        "brand_name": brandName,
        "functional_name": functionalName,
        "manufacturer_name": manufacturerName,
        "registration_number": registrationNumber,
        "batch_number": batchNumber,
        "expiration_date": expirationDate,
        "quantity": quantity,
        "type": type,
        "location": location,
      };
}
