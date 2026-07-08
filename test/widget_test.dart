
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mon_projet_cours/main.dart';

void main() {
  testWidgets('MonApplication se lance sans erreur', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MonApplication()),
    );
    await tester.pump();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}