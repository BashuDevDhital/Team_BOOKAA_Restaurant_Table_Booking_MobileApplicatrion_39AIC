import 'package:flutter_test/flutter_test.dart';
import 'package:boo_kaa/main.dart';

void main() {
  testWidgets('Boo-KAA app loads splash screen test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BooKaaApp());

    // Verify that Boo-KAA logo/splash elements are found.
    expect(find.text('Boo-KAA'), findsWidgets);
  });
}
