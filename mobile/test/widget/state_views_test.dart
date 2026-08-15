import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mizan/core/theme/app_theme.dart';
import 'package:mizan/core/widgets/state_views.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: child),
      );

  testWidgets('EmptyView renders its message', (tester) async {
    await tester.pumpWidget(wrap(const EmptyView(message: 'Nothing here yet')));
    expect(find.text('Nothing here yet'), findsOneWidget);
  });

  testWidgets('LoadingView renders a progress indicator', (tester) async {
    await tester.pumpWidget(wrap(const LoadingView()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('ErrorView renders message and retry button when provided',
      (tester) async {
    var tapped = false;
    await tester.pumpWidget(wrap(ErrorView(
      message: 'Could not load',
      onRetry: () => tapped = true,
    )));
    expect(find.text('Could not load'), findsOneWidget);
    await tester.tap(find.byType(OutlinedButton));
    expect(tapped, isTrue);
  });
}
