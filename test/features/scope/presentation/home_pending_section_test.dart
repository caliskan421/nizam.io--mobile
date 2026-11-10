import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/app_localizations.dart';
import 'package:nizamio/features/scope/domain/home_dashboard.dart';
import 'package:nizamio/features/scope/presentation/home_page.dart';

import '../../../core/ui/widgets/feedback/feedback_test_support.dart';

void main() {
  testWidgets('bekleyen satır türü ve kapsamıyla göreve açılır', (
    tester,
  ) async {
    String? opened;
    await tester.pumpWidget(
      MaterialApp(
        theme: theme(false),
        locale: const Locale('tr'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: testLocalizationDelegates,
        home: Scaffold(
          body: HomePendingSection(
            value: const AsyncData(
              PendingOverview(
                truncated: false,
                items: [
                  PendingItem(
                    taskCode: 'w1',
                    title: 'Görev',
                    label: 'Altyapı',
                    kind: PendingKind.approval,
                  ),
                ],
              ),
            ),
            onRetry: () {},
            onOpen: (id) => opened = id,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Görev'), findsOneWidget);
    expect(find.textContaining('Altyapı'), findsOneWidget);
    await tester.tap(find.text('Görev'));
    expect(opened, 'w1');
  });

  testWidgets(
    'yardımcı hata temel içeriği korur ve yalnız bölüm yeniden denenir',
    (tester) async {
      var retries = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: theme(false),
          locale: const Locale('tr'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: testLocalizationDelegates,
          home: Scaffold(
            body: Column(
              children: [
                const Text('Temel özet'),
                HomePendingSection(
                  value: AsyncError(
                    ApiError('platform.internal'),
                    StackTrace.current,
                  ),
                  onRetry: () => retries++,
                  onOpen: (_) {},
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Temel özet'), findsOneWidget);
      await tester.tap(find.text('Yeniden dene'));
      expect(retries, 1);
      expect(find.text('Temel özet'), findsOneWidget);
    },
  );
}
