import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:npc_mobile_flutter/main.dart' as app;
import 'package:npc_mobile_flutter/src/screen/about_page.dart';
import 'package:npc_mobile_flutter/src/screen/home_page.dart';
import 'package:npc_mobile_flutter/src/screen/prompt_scan.dart';

void main() {
  group('MyApp Widget Tests', () {
    testWidgets('Renders MyApp', (WidgetTester tester) async {
      await dotenv.load(fileName: ".env");
      await tester.pumpWidget(const app.MyApp());

      expect(find.byType(app.MyApp), findsOneWidget);
    });
  });

  group('HomePage Widget Tests', () {
    testWidgets('Renders HomePage', (WidgetTester tester) async {
      await tester.pumpWidget(const app.MyApp());

      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('Switches Page on BottomNavigationBar tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(const app.MyApp());

      // Initial page
      expect(find.byType(PromptScan), findsOneWidget);
      expect(find.byType(AboutPage), findsNothing);

      // Tap on the 'About' tab
      await tester.tap(find.text('About'));
      await tester.pump();

      // After tapping, the AboutPage should be visible
      expect(find.byType(PromptScan), findsNothing);
      expect(find.byType(AboutPage), findsOneWidget);
    });
  });

  group('ScanPage Widget Tests', () {
    testWidgets('Renders Scan prompt page', (WidgetTester tester) async {
      await tester.pumpWidget(const app.MyApp());

      // Initial page is ScanPage
      expect(find.byType(PromptScan), findsOneWidget);

      // Verify the presence of key widgets on ScanPage
      expect(find.text('GS1 GTIN Verification App'), findsOneWidget);
      expect(find.text('Start Scan'), findsOneWidget);
    });
  });
}
