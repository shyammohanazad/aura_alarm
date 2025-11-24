// UI smoke test for the World Clock app.
// Verifies presence of core static widgets and labels used in the app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aura_alarm/main.dart';

void main() {
  testWidgets('WorldClockApp UI smoke test', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const WorldClockApp());

    // AppBar title
    expect(find.text('WORLD CLOCK'), findsOneWidget);

    // Section header
    expect(find.text('Local Time'), findsOneWidget);

    // Static city tiles
    expect(find.text('New York, USA'), findsOneWidget);
    expect(find.text('London, UK'), findsOneWidget);
    expect(find.text('Dubai, UAE'), findsOneWidget);
    expect(find.text('Tokyo, Japan'), findsOneWidget);

    // FAB present
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Bottom navigation items present
    expect(find.text('Clock'), findsOneWidget);
    expect(find.text('Alarm'), findsOneWidget);
    expect(find.text('Timer'), findsOneWidget);
    expect(find.text('Stopwatch'), findsOneWidget);

    // Tap some bottom navigation items to ensure taps are wired (no crash)
    await tester.tap(find.text('Alarm'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Timer'));
    await tester.pumpAndSettle();
  });
}
