import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:puma_is/main.dart';  // Import your main.dart file

void main() {
  testWidgets('Main Page widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp()); // Use MyApp widget here, not MainPage directly.

    // Verify if the text 'Welcome Back!' is found in the widget tree.
    expect(find.text('Welcome Back!'), findsOneWidget);

    // You can add more tests to verify the presence of other UI elements as well.
  });
}
