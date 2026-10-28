import 'dart:math' as math;

import '../../tasks/tasks.dart';
import 'timeline.dart';

/// Kataloğun seçili koordinatörlükleri: durumdaki liste ya da (null) ilk koordinatörlük.
List<String> resolvedCoordinatorships(TaskCatalog catalog, TimelineState s) =>
    s.coordinatorships ??
    [
      if (catalog.coordinatorships.isNotEmpty)
        catalog.coordinatorships.first.code,
    ];

/// Görevin kayıtlı aralığı (düzenleme ya da özgün başlangıç/bitiş).
DayRange currentRange(TaskItem t, TimelineState s, int year) =>
    s.edits[t.code] ??
    DayRange(seasonDay(t.start, year), seasonDay(t.due, year));

/// Prototip `renderVals` mantığı: süzgeçler, şerit yerleşimi, sayılar, sezon şeridi, seçili kart.
TimelineView buildTimelineView(
  TaskCatalog catalog,
  TimelineState s, {
  Set<String> dependent = const {},
}) {
  final year = catalog.today.year;
  final today = seasonDay(catalog.today, year);
  final days = DateTime.utc(year + 1).difference(DateTime.utc(year)).inDays;
  final coords = resolvedCoordinatorships(catalog, s);
  final ordered = [
    for (final c in catalog.coordinatorships)
      if (coords.contains(c.code)) c.code,
  ];

  final tasks = [
    for (final item in catalog.tasks)
      () {
        final cur = currentRange(item, s, year);
        final draft = s.selected == item.code ? s.draft : null;
        final req = s.requests[item.code];
        final base = TimelineTask(
          item: item,
          range: cur,
          doneAt: item.completedAt == null
              ? null
              : seasonDay(item.completedAt!, year),
          today: today,
          request: req == null ? null : seasonDay(req, year),
          packStart: cur.start,
          packEnd: 0,
          dependent: dependent.contains(item.code),
        );
        return TimelineTask(
          item: item,
          range: draft ?? cur,
          doneAt: base.doneAt,
          today: today,
          request: base.request,
          packStart: cur.start,
          packEnd: base.extentEnd,
          dependent: base.dependent,
        );
      }(),
  ];

  bool personOk(TimelineTask t) =>
      s.people.isEmpty || t.item.assignees.any(s.people.contains);
  bool prioOk(TimelineTask t) =>
      s.priorities.isEmpty || s.priorities.contains(t.item.priority);
  final base = [
    for (final t in tasks)
      if (personOk(t) && prioOk(t)) t,
  ];
  bool statusOk(TimelineTask t, TimelineStatusFilter f) => switch (f) {
    TimelineStatusFilter.all => true,
    TimelineStatusFilter.open => t.status != TaskStatus.done,
    TimelineStatusFilter.late => t.late,
    TimelineStatusFilter.done => t.status == TaskStatus.done,
  };
  bool inGroup(TimelineTask t) => coords.contains(t.item.coordinatorship);

  final groupBase = [
    for (final t in base)
      if (inGroup(t)) t,
  ];
  final shown = [
    for (final t in groupBase)
      if (statusOk(t, s.status)) t,
  ];

  TimelineGroup group(CoordinatorshipRef c, List<TimelineTask> list) {
    final all = [
      for (final t in base)
        if (t.item.coordinatorship == c.code) t,
    ];
    final (lanes, placed) = packLanes(list);
    return TimelineGroup(
      code: c.code,
      name: c.name,
      lanes: lanes,
      placed: placed,
      done: all.where((t) => t.status == TaskStatus.done).length,
      total: all.length,
      late: all.where((t) => t.late).length,
    );
  }

  final groups = [
    for (final c in catalog.coordinatorships)
      if (ordered.contains(c.code))
        group(c, [
          for (final t in shown)
            if (t.item.coordinatorship == c.code) t,
        ]),
  ].where((g) => g.lanes > 0).toList();

  final overviewGroups = s.overview
      ? [
          for (final c in catalog.coordinatorships)
            group(c, [
              for (final t in base)
                if (t.item.coordinatorship == c.code && statusOk(t, s.status))
                  t,
            ]),
        ]
      : const <TimelineGroup>[];

  final weeks = [
    for (var i = 0; i < (days / 7).ceil(); i++)
      TimelineWeek(
        count: shown
            .where((t) => t.range.start < i * 7 + 7 && t.extentEnd > i * 7)
            .length,
        late: shown.any(
          (t) =>
              (t.late || t.doneLate) &&
              t.range.end >= i * 7 &&
              t.range.end < i * 7 + 7,
        ),
      ),
  ];

  final people = [
    for (final p in catalog.people)
      TimelinePersonOption(
        id: p.id,
        name: p.name,
        count: tasks
            .where((t) => inGroup(t) && t.item.assignees.contains(p.id))
            .length,
        selected: s.people.contains(p.id),
      ),
  ].where((p) => p.count > 0).toList()..sort((a, b) => b.count - a.count);

  TimelineSelection? selection;
  final sel = s.selected;
  final selTask = sel == null
      ? null
      : tasks.where((t) => t.code == sel).firstOrNull;
  if (selTask != null) {
    final cur = currentRange(selTask.item, s, year);
    selection = TimelineSelection(
      task: selTask,
      coordinatorshipName:
          catalog.coordinatorship(selTask.item.coordinatorship)?.name ??
          selTask.item.coordinatorship,
      assignees: [
        for (final id in selTask.item.assignees) catalog.person(id)?.name ?? id,
      ],
      current: cur,
      draft: s.draft ?? cur,
    );
  }

  return TimelineView(
    year: year,
    days: days,
    today: today,
    state: s,
    coordinatorships: catalog.coordinatorships,
    selectedCoordinatorships: ordered,
    groups: groups,
    shown: shown,
    statusCounts: {
      for (final f in TimelineStatusFilter.values)
        f: groupBase.where((t) => statusOk(t, f)).length,
    },
    coordOptions: [
      for (final c in catalog.coordinatorships)
        TimelineCoordOption(
          code: c.code,
          name: c.name,
          count: base.where((t) => t.item.coordinatorship == c.code).length,
          selected: ordered.contains(c.code),
        ),
    ],
    personOptions: people,
    weeks: weeks,
    selection: selection,
    overviewGroups: overviewGroups,
  );
}

/// Şerit yerleşimi (prototip `pack`, bir gün boşlukla): başlangıca göre sıralı görevi, sonu
/// en az bir gün önce biten ilk şeride koyar. Dönen: (şerit sayısı, [görev, şerit]).
(int, List<(TimelineTask, int)>) packLanes(List<TimelineTask> list) {
  final sorted = [...list]
    ..sort((a, b) {
      final d = a.packStart - b.packStart;
      return d != 0 ? d : a.packEnd - b.packEnd;
    });
  final lanes = <int>[];
  final out = <(TimelineTask, int)>[];
  for (final t in sorted) {
    var i = lanes.indexWhere((end) => end + 1 <= t.packStart);
    if (i < 0) {
      lanes.add(t.packEnd);
      i = lanes.length - 1;
    } else {
      lanes[i] = t.packEnd;
    }
    out.add((t, i));
  }
  return (math.max(lanes.length, 0), out);
}
