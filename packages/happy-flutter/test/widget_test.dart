import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:happy_flutter/app/app.dart';

void main() {
  testWidgets('App renders login screen when unauthenticated', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: HappyApp()),
    );
    await tester.pumpAndSettle();

    // Unauthenticated → should show login screen with QR code button
    expect(find.text('Happy Coder'), findsOneWidget);
    expect(find.text('Scan QR Code'), findsOneWidget);
  });
}
