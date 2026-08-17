import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulsedesk/app/app.dart';

void main() {
  testWidgets('shows required errors when sign-in form is empty', (
    tester,
  ) async {
    await tester.pumpWidget(const PulseDeskApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sign in'));
    await tester.pump();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('shows validation errors for invalid credentials', (
    tester,
  ) async {
    await tester.pumpWidget(const PulseDeskApp());
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);

    await tester.enterText(fields.at(0), 'abc');
    await tester.enterText(fields.at(1), '123');

    await tester.tap(find.text('Sign in'));
    await tester.pump();

    expect(find.text('Enter a valid email'), findsOneWidget);
    expect(find.text('Password must be at least 8 characters'), findsOneWidget);
  });
}
