import 'package:flutter_test/flutter_test.dart';
import 'package:hello_flutter_tip_calculator/main.dart';

void main() {
  testWidgets('Tip Calculator app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const TipApp());

    expect(find.text('Tip Calculator'), findsOneWidget);
    expect(find.text('Tip Percentage'), findsOneWidget);
  });
}