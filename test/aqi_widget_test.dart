import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bharat_heritage/core/theme/glassmorphic_card.dart';

void main() {
  testWidgets('AQI Alert Card renders properly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GlassmorphicCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Live AQI'),
                const Text('142'),
                const Text('Moderate'),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('Live AQI'), findsOneWidget);
    expect(find.text('142'), findsOneWidget);
    expect(find.text('Moderate'), findsOneWidget);
  });
}
