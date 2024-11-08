import 'package:dio/dio.dart';
import 'package:npc_mobile_flutter/src/api/api_service.dart';
import 'package:npc_mobile_flutter/src/api/data_state.dart';
import 'package:npc_mobile_flutter/src/api/errors/error_handler.dart';
import 'package:npc_mobile_flutter/src/api/repository/product/i_product_repository.dart';
import 'package:npc_mobile_flutter/src/data/product_registration_request.dart';
import 'package:npc_mobile_flutter/src/data/product_registration_response.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ProductRepository implements IProductRepository {
  // ProductRepository(this.apiService);

  @override
  Future<DataState<ProductRegistrationResponse>> registerProduct(
      ProductRegistrationRequest request) async {
    try {
      final ApiService apiService = ApiService(dioConfig());
      final result = await apiService.registerProduct(request);
      return DataSuccess(result);
    } catch (error) {
      final errorHandler = getErrorMessage(error);
      return DataError(errorHandler.toString());
    }
  }

  Dio dioConfig() {
    final d = Dio(BaseOptions(contentType: "application/json", headers: {
      'accept': 'application/json',
      'responseType': 'application/json'
    }));
    d.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        compact: true,
        maxWidth: 90));
    return d;
  }
}
