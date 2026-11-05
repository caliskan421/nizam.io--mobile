// Dikey çizelge testleri için ortak veri: üç koordinatörlükte yıla yayılmış görevler ve
// tema + yerelleştirme sarmalayıcısı.
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nizamio/core/i18n/generated/app_localizations.dart';
import 'package:nizamio/core/ui/theme/app_theme.dart';
import 'package:nizamio/features/tasks/tasks.dart';
import 'package:nizamio/features/timeline/domain/timeline.dart';
import 'package:nizamio/features/timeline/domain/timeline_view_builder.dart';

/// [n] görev; i. görev yılın 2i. gününde başlar (gün sırası = 2i), 6 gün sürer. Bugün yılın ilk
/// günü (geciken yok; çizelge en üstte açılır).
TaskCatalog timelineCatalog({int n = 150}) => TaskCatalog(
  today: DateTime(2026),
  me: 'p1',
  people: const [Person(id: 'p1', name: 'Ali', role: PersonRole.member)],
  coordinatorships: const [
    CoordinatorshipRef(code: 'A', name: 'Alfa', leads: [], members: []),
    CoordinatorshipRef(code: 'B', name: 'Beta', leads: [], members: []),
    CoordinatorshipRef(code: 'C', name: 'Gama', leads: [], members: []),
  ],
  tasks: [
    for (var i = 0; i < n; i++)
      TaskItem(
        code: 'T$i',
        title: 'Görev $i',
        coordinatorship: const ['A', 'B', 'C'][i % 3],
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

Widget timelineApp(Widget child) => MaterialApp(
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
);
