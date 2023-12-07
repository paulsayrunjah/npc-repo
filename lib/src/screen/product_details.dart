import 'package:akeneo_api_client/akeneo_api_client.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:npc_mobile_flutter/src/data/countries.dart';
import 'package:npc_mobile_flutter/src/data/gs1_properties.dart';
import 'package:npc_mobile_flutter/src/util/constants.dart';

class ProductDetails extends StatelessWidget {
  final Product product;
  final AkeneoApiClient apiClient;
  final GS1Properties? gs1Properties;

  const ProductDetails({
    Key? key,
    required this.apiClient,
    required this.product,
    this.gs1Properties,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authHeader = {'Authorization': apiClient.bearerToken};
    String imageLink = '';

    if (product.values[imageAttribute]!.first.links?.download != null) {
      imageLink = product.values[imageAttribute]!.first.links!.download!.href;
    } else {
      imageLink =
          apiClient.getMediaFileUrl(product.values[imageAttribute]!.first.data);
    }

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
            CachedNetworkImage(
              imageUrl: imageLink,
              httpHeaders: authHeader,
              placeholder: (context, url) => const SpinKitChasingDots(
                color: Colors.indigo,
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              // width: MediaQuery.of(context).size.height * 0.4,
              height: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            const Divider(color: Colors.black),
            _buildInfoRow(
                context, 'Country of Origin', getAttribute(countryAttribute)),
            const Divider(color: Colors.black),
            _buildInfoRow(context, 'Brand Name', getAttribute(brandAttribute)),
            const Divider(color: Colors.black),
            _buildInfoRow(
                context, 'Functional Name', getAttribute(nameAttribute)),
            const Divider(color: Colors.black),
            _buildInfoRow(context, 'Manufacturer Name',
                getAttribute(manufacturerAttribute)),
            const Divider(color: Colors.black),
            _buildInfoRow(context, 'Registration Number',
                getAttribute(registrationAttribute)),
            const Divider(color: Colors.black),
            _buildInfoRow(context, 'Batch Number', getAttribute('batch')),
            const Divider(color: Colors.black),
            _buildInfoRow(context, 'Expiration Date', getAttribute('expiry')),
            const Divider(color: Colors.black),
            // Other content goes here
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, Widget value) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: value,
          ),
        ],
      ),
    );
  }

  Widget getAttribute(String attribute) {
    if (attribute == 'batch' || attribute == 'expiry') {
      return _buildGs1Info(attribute);
    }
    if (attribute == countryAttribute) {
      return Text(
        product.values[attribute]!.first.data == null
            ? 'N/A'
            : countries[product.values[attribute]!.first.data] ?? 'N/A',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    }
    if (product.values[attribute]?.first.data != null) {
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
              product.values[attribute]!.first.data ?? 'N/A',
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
    var attribute = await apiClient.getAttribute(attributeCode);
    if ([AttributeType.simpleSelect.value, AttributeType.multiSelect.value]
        .contains(attribute.type)) {
      var value = await apiClient.getAttributeOption(
        attributeCode,
        product.values[attributeCode]!.first.data.toString(),
      );
      return value.labels[defaultLocale] ?? value.code;
    }
    return product.values[attributeCode]!.first.data.toString();
  }

  Widget _buildGs1Info(String attribute) {
    if (gs1Properties == null) {
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
          gs1Properties!.batchOrLotNumber ?? 'N/A',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        );
      case 'expiry':
        return Text(
          gs1Properties!.expirationDate == null
              ? 'N/A'
              : DateFormat('dd/MM/yyyy').format(gs1Properties!.expirationDate!),
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
}
