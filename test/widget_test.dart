import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routex/main.dart';

void main() {
  testWidgets('App starts without error', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: RouteXApp()));
    expect(find.text('RouteX Project Initialized'), findsOneWidget);
  });
}
