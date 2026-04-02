import 'package:flutter_test/flutter_test.dart';
import 'package:flo_finance/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App boots safely', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: FloFinanceApp(),
      ),
    );

    expect(find.text('Flo Finance Architecture Established'), findsOneWidget);
  });
}
