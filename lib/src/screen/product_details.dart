import 'package:akeneo_api_client/akeneo_api_client.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:npc_mobile_flutter/src/api/data_state.dart';
import 'package:npc_mobile_flutter/src/api/repository/product/product_repository.dart';
import 'package:npc_mobile_flutter/src/data/countries.dart';
import 'package:npc_mobile_flutter/src/data/gs1_properties.dart';
import 'package:npc_mobile_flutter/src/data/product_registration_request.dart';
import 'package:npc_mobile_flutter/src/util/constants.dart';
import 'package:npc_mobile_flutter/src/util/util.dart';
import 'package:npc_mobile_flutter/src/widget/inputs/text_input.dart';

enum ActionType { dispatch, release }

class ProductDetails extends StatefulWidget {
  final Product product;
  final AkeneoApiClient apiClient;
  final GS1Properties? gs1Properties;

  const ProductDetails({
    super.key,
    required this.apiClient,
    required this.product,
    this.gs1Properties,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  ActionType? selectedActionType = ActionType.release;
  var quantityController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (widget.product.values[imageAttribute]?.first.links?.download != null) {
    } else if (widget.product.values[imageAttribute]?.first.data != null) {}
    return SingleChildScrollView(
      physics:
          const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 56 - 56 - 24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Divider(color: Colors.black54),
            _buildInfoRow(
                context, 'Country of Origin', getAttribute(countryAttribute)),
            const Divider(color: Colors.black54),
            _buildInfoRow(context, 'Brand Name', getAttribute(brandAttribute)),
            const Divider(color: Colors.black54),
            _buildInfoRow(
                context, 'Functional Name', getAttribute(nameAttribute)),
            const Divider(color: Colors.black54),
            _buildInfoRow(context, 'Manufacturer Name',
                getAttribute(manufacturerAttribute)),
            const Divider(color: Colors.black54),
            _buildInfoRow(context, 'Registration Number',
                getAttribute(registrationAttribute)),
            const Divider(color: Colors.black54),
            _buildInfoRow(context, 'Batch Number', getAttribute('batch')),
            const Divider(color: Colors.black54),
            _buildInfoRow(context, 'Expiration Date', getAttribute('expiry')),
            const Divider(color: Colors.black54),

            Container(
              // height: 60,
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 12),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Text(
                        'Register product',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      textFieldInput(
                          hintText: 'Quantity',
                          controller: quantityController,
                          textInputAction: TextInputAction.done,
                          keyboardType:
                              const TextInputType.numberWithOptions()),
                      const SizedBox(
                        height: 4,
                      ),
                      actionTypeForm(context, selectedActionType,
                          (ActionType? value) {
                        setState(() {
                          selectedActionType = value;
                        });
                      }),
                      const SizedBox(
                        height: 4,
                      ),
                      SizedBox(
                        width: 200,
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ElevatedButton(
                                onPressed: () async {
                                  if (quantityController.text.isEmpty) {
                                    return;
                                  }

                                  var product = await createProduct();
                                  registerProduct(context, product);
                                },
                                child: const Text('Save')),
                      )
                    ],
                  ),
                ),
              ),
            )

            // Other content goes here
          ],
        ),
      ),
    );
  }

  Widget actionTypeForm(
    BuildContext context,
    ActionType? groupValue,
    ValueChanged<ActionType?> onChanged,
  ) {
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: const Text('Release'),
            leading: Radio<ActionType>(
              value: ActionType.release,
              groupValue: groupValue,
              onChanged: onChanged,
            ),
          ),
          ListTile(
            title: const Text('Dispatch'),
            leading: Radio<ActionType>(
              value: ActionType.dispatch,
              groupValue: groupValue,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Future<ProductRegistrationRequest> createProduct() async {
    var countryOfOrigin = await getAttributeText(countryAttribute);
    var brandName = await getAttributeText(brandAttribute);
    var functionalName = await getAttributeText(nameAttribute);
    var manufacturerName = await getAttributeText(manufacturerAttribute);
    var registrationNumber = await getAttributeText(registrationAttribute);
    var batchNumber = await getAttributeText('batch');
    var expirationDate = await getAttributeText('expiry');

    return ProductRegistrationRequest(
      srcSystemCode: 'N/A',
      registration: [
        Registration(
          countryOfOrigin: countryOfOrigin,
          brandName: brandName,
          functionalName: functionalName,
          manufacturerName: manufacturerName,
          registrationNumber: registrationNumber,
          batchNumber: batchNumber,
          expirationDate: convertDate(expirationDate),
          quantity: int.tryParse(quantityController.text) ?? 0,
          type: selectedActionType?.name ?? '',
          source: "N/A",
        )
      ],
    );

    // You can now use `product` as needed.
  }

  Widget _buildInfoRow(BuildContext context, String label, Widget value) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.indigo,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: value,
          ),
        ],
      ),
    );
  }

  Future<String> getAttributeText(String attribute) async {
    if (attribute == 'batch' || attribute == 'expiry') {
      return _buildGs1InfoText(attribute);
    }
    if (attribute == countryAttribute) {
      return widget.product.values[attribute]?.first.data == null
          ? 'N/A'
          : countries[widget.product.values[attribute]!.first.data] ?? 'N/A';
    }
    if (widget.product.values[attribute]?.first.data != null) {
      String? value = await _getValueText(attribute);
      return value ?? widget.product.values[attribute]?.first.data ?? 'N/A';
    } else {
      return 'N/A';
    }
  }

  Future<String> _getValueText(String attributeCode) async {
    var attribute = await widget.apiClient.getAttribute(attributeCode);
    if ([AttributeType.simpleSelect.value, AttributeType.multiSelect.value]
        .contains(attribute.type)) {
      var value = await widget.apiClient.getAttributeOption(
        attributeCode,
        widget.product.values[attributeCode]!.first.data.toString(),
      );
      return value.labels[defaultLocale] ?? value.code;
    }
    return widget.product.values[attributeCode]!.first.data.toString();
  }

  String _buildGs1InfoText(String attribute) {
    if (widget.gs1Properties == null) {
      return 'N/A';
    }
    switch (attribute) {
      case 'batch':
        return widget.gs1Properties!.batchOrLotNumber ?? 'N/A';
      case 'expiry':
        return widget.gs1Properties!.expirationDate == null
            ? 'N/A'
            : DateFormat('dd/MM/yyyy')
                .format(widget.gs1Properties!.expirationDate!);
      default:
        return 'N/A';
    }
  }

  Widget getAttribute(String attribute) {
    if (attribute == 'batch' || attribute == 'expiry') {
      return _buildGs1Info(attribute);
    }
    if (attribute == countryAttribute) {
      return Text(
        widget.product.values[attribute]?.first.data == null
            ? 'N/A'
            : countries[widget.product.values[attribute]!.first.data] ?? 'N/A',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    }
    if (widget.product.values[attribute]?.first.data != null) {
      return FutureBuilder(
          future: _getValue(attribute),
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SpinKitChasingDots(
                  color: Colors.indigo,
                  size: 20.0,
                ),
              );
            } else if (snapshot.hasData) {
              return Text(
                snapshot.data!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              );
            }
            return Text(
              widget.product.values[attribute]?.first.data ?? 'N/A',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            );
          });
    } else {
      return const Text(
        'N/A',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    }
  }

  Future<String> _getValue(String attributeCode) async {
    var attribute = await widget.apiClient.getAttribute(attributeCode);
    if ([AttributeType.simpleSelect.value, AttributeType.multiSelect.value]
        .contains(attribute.type)) {
      var value = await widget.apiClient.getAttributeOption(
        attributeCode,
        widget.product.values[attributeCode]!.first.data.toString(),
      );
      return value.labels[defaultLocale] ?? value.code;
    }
    return widget.product.values[attributeCode]!.first.data.toString();
  }

  Widget _buildGs1Info(String attribute) {
    if (widget.gs1Properties == null) {
      return const Text(
        'N/A',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    }
    switch (attribute) {
      case 'batch':
        return Text(
          widget.gs1Properties!.batchOrLotNumber ?? 'N/A',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        );
      case 'expiry':
        return Text(
          widget.gs1Properties!.expirationDate == null
              ? 'N/A'
              : DateFormat('dd/MM/yyyy')
                  .format(widget.gs1Properties!.expirationDate!),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        );
      default:
        return const Text(
          'N/A',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        );
    }
  }

  registerProduct(
      BuildContext context, ProductRegistrationRequest request) async {
    final prodRepo = ProductRepository();
    setState(() {
      isLoading = true;
    });
    final response = await prodRepo.registerProduct(request);
    setState(() {
      isLoading = false;
    });

    if (response is DataError) {
      aweSomeDialog(
          dialogType: DialogType.error,
          context: context,
          desc: response.error,
          btnOkPress: () {});
      return;
    }

    final data = response.data;
    if (data != null) {
      aweSomeDialog(
          dialogType: DialogType.success,
          context: context,
          desc: data.first.message,
          btnOkPress: () {
            Navigator.pop(context);
          });
    }
  }
}
