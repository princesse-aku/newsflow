import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:newsflow/main.dart';

void main() {
  testWidgets('NewsFlow démarre correctement', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: NewsFlowApp()));

    await tester.pump();

    expect(find.byType(NewsFlowApp), findsOneWidget);
  });
}
