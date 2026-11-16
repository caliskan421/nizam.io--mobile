// Dikey çizelge testleri için ortak veri: üç koordinatörlükte yıla yayılmış görevler ve
// tema + yerelleştirme sarmalayıcısı.
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nizamio/core/i18n/generated/app_localizations.dart';
import 'package:nizamio/core/ui/theme/app_theme.dart';
import 'package:nizamio/features/tasks/tasks.dart';
import 'package:nizamio/features/timeline/domain/timeline.dart';
import 'package:nizamio/features/timeline/domain/timeline_view_builder.dart';

/// [n] görev; i. görev yılın 2i. gününde başlar (gün sırası = 2i), 6 gün sürer, sırayla [groups]
/// koordinatörlükten birine (A, B, C…) düşer. Bugün yılın ilk günü (geciken yok; çizelge en
/// üstte açılır).
TaskCatalog timelineCatalog({int n = 150, int groups = 3}) => TaskCatalog(
  today: DateTime(2026),
  me: 'p1',
  people: const [Person(id: 'p1', name: 'Ali', role: PersonRole.member)],
  coordinatorships: [
    for (var g = 0; g < groups; g++)
      CoordinatorshipRef(
        code: String.fromCharCode(65 + g),
        name: 'Grup $g',
        leads: const [],
        members: const [],
      ),
  ],
  tasks: [
    for (var i = 0; i < n; i++)
      TaskItem(
        code: 'T$i',
        title: 'Görev $i',
        coordinatorship: String.fromCharCode(65 + i % groups),
        status: TaskStatus.inProgress,
        priority: TaskPriority.medium,
        start: DateTime(2026, 1, 1 + 2 * i),
        due: DateTime(2026, 1, 7 + 2 * i),
        assignees: const ['p1'],
      ),
  ],
);

TimelineView timelineViewOf(
  TaskCatalog catalog, [
  TimelineState state = const TimelineState(startAll: true),
]) => buildTimelineView(catalog, state);

/// Seçim kartı alt görevler için ayrıntıyı okur; burada sunucu yok → okuma boş geçer.
Widget timelineApp(Widget child) => ProviderScope(
  overrides: [taskDetailsProvider.overrideWith((ref, code) async {})],
  child: MaterialApp(
    theme: AppTheme.light(),
    locale: const Locale('tr'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: Scaffold(body: child),
  ),
);
