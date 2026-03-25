import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bharat_heritage/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app.
    await tester.pumpWidget(
      const ProviderScope(
        child: App(),
      ),
    );

    // Pump one frame so the widget tree is built.
    await tester.pump();

    // Verify the App widget exists.
    expect(find.byType(App), findsOneWidget);
  },
  // Skip: requires live network (Dio providers fire real HTTP requests).
  skip: true);
}
