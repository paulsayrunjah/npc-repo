import 'package:npc_mobile_flutter/src/api/data_state.dart';
import 'package:npc_mobile_flutter/src/data/product_registration_request.dart';
import 'package:npc_mobile_flutter/src/data/product_registration_response.dart';

abstract class IProductRepository {
  Future<DataState<ProductRegistrationResponse>> registerProduct(
      ProductRegistrationRequest request);
}
