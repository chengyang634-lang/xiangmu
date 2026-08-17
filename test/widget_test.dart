import 'package:flutter_test/flutter_test.dart';
import 'package:pulsedesk/app/app.dart';

void main() {
  testWidgets('displays PulseDesk', (tester) async {
    await tester.pumpWidget(const PulseDeskApp());

    expect(find.text('PulseDesk'), findsOneWidget);
  });
}