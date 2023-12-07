import 'package:akeneo_api_client/akeneo_api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:npc_mobile_flutter/src/data/gs1_properties.dart';
import 'package:npc_mobile_flutter/src/screen/about_page.dart';
import 'package:npc_mobile_flutter/src/screen/product_details.dart';
import 'package:npc_mobile_flutter/src/screen/prompt_scan.dart';
import 'package:npc_mobile_flutter/src/screen/scanner_page.dart';

/// The main screen of the Product Catalog app, featuring side-swipe navigation.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final AkeneoApiClient apiClient = AkeneoApiClient(
    endpoint: Uri.parse(dotenv.env['AKENEO_URL']!),
    userName: dotenv.env['AKENEO_USERNAME']!,
    password: dotenv.env['AKENEO_PASSWORD']!,
    clientId: dotenv.env['AKENEO_CLIENT_ID']!,
    clientSecret: dotenv.env['AKENEO_CLIENT_SECRET']!,
  );
  Product? _product;
  GS1Properties? _properties;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _product == null || _currentIndex == 1
            ? null
            : BackButton(
                onPressed: () => setState(() {
                  _product = null;
                  _properties = null;
                }),
              ),
        title: Text(_currentIndex == 1
            ? 'About'
            : _product == null
                ? 'Scan Barcode'
                : _properties?.GTIN ?? 'Scan Barcode'),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: getPage(_currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavItemTapped,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
      ),
    );
  }

  /// Handles the tap event on the bottom navigation bar items.
  ///
  /// Sets the state to update the current page index.
  void _onBottomNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  /// Initiates the barcode scanning process.
  ///
  /// This method is called when the 'Start Scan' button is pressed.
  void _startScan(BuildContext context) async {
    Navigator.push<GS1Properties?>(
      context,
      MaterialPageRoute(
        builder: (context) => const ScannerPage(),
      ),
    ).then((properties) {
      if (properties != null) {
        setState(() => isLoading = true);
        _properties = properties;
        _getProduct(properties.GTIN).then(
          (value) => setState(() => isLoading = false),
          onError: (e) => setState(() => isLoading = false),
        );
      }
    });
  }

  Future<void> _getProduct(String gtin) {
    final gtinAttribute = dotenv.env['AKENEO_GTIN_ATTRIBUTE']!;
    final queryParameters = QueryParameter(
      filters: [
        SearchFilter(
          field: 'family',
          operator: AkeneoOperator.inValue,
          value: [dotenv.env['AKENEO_FAMILY']!],
        ),
        SearchFilter(
          field: gtinAttribute,
          operator: AkeneoOperator.contains,
          value: gtin,
        ),
      ],
      limit: 1,
      page: 1,
    );
    return apiClient.getProducts(params: queryParameters).then(
      (searchResponse) {
        if (searchResponse.embedded.items.isNotEmpty == true) {
          setState(() {
            _product = Product.fromJson(searchResponse.embedded.items.first);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product not found'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      onError: (e, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
        debugPrintStack(stackTrace: stackTrace);
      },
    );
  }

  getPage(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return _product == null
            ? PromptScan(
                onScanButtonPressed: () => _startScan(context),
                isLoading: isLoading,
              )
            : ProductDetails(
                apiClient: apiClient,
                product: _product!,
                gs1Properties: _properties,
              );
      case 1:
        return const AboutPage();
      default:
        return Container();
    }
  }
}
