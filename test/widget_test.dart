// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import "package:flutter_test/flutter_test.dart";

import "package:solfeggio_app/main.dart";

void main() {
  testWidgets("App builds and shows title", (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SolfeggioApp());

    // Verify that the app title is present.
    // This is a basic test to ensure the app loads without crashing.
    expect(find.text("Solfeggio Harmonics"), findsOneWidget);
  });
}

