import 'package:flutter_test/flutter_test.dart';
import 'package:memory_match/main.dart';

void main() {
  testWidgets('App renders Memory Match title', (WidgetTester tester) async {
    await tester.pumpWidget(const MemoryMatchApp());
    expect(find.text('Memory Match'), findsOneWidget);
    expect(find.text('Find all matching pairs'), findsOneWidget);
    expect(find.text('Restart'), findsOneWidget);
  });
}
