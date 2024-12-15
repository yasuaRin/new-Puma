import 'package:flutter_test/flutter_test.dart';
import 'package:puma_is/main.dart';  

void main() {
  testWidgets('Main Page widget test', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp()); 

    expect(find.text('Welcome Back!'), findsOneWidget);

  });
}
