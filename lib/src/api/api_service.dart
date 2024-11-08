import 'package:dio/dio.dart';
import 'package:npc_mobile_flutter/src/data/product_registration_request.dart';
import 'package:npc_mobile_flutter/src/data/product_registration_response.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "http://197.157.32.194:8082")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST("/gs1api/v1.0/scannedmetrics")
  Future<List<ProductRegistrationResponse>> registerProduct(
      @Body() ProductRegistrationRequest request);
}
