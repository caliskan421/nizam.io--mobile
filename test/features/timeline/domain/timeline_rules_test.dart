// Zaman çizelgesi rol kuralları: doğrudan uzatma ile tarih talebi ayrımı (7 gün eşiği),
// sekme veri kümesi ve bitişi bugüne çekme koşulu.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/tasks/tasks.dart';
import 'package:nizamio/features/timeline/domain/timeline.dart';
import 'package:nizamio/features/timeline/domain/timeline_rules.dart';

TaskItem _task(
  String code, {
  String dept = 'alt',
  List<String> assignees = const [],
  TaskStatus status = TaskStatus.inProgress,
  DateTime? due,
  DateTime? plannedEnd,
}) => TaskItem(
  code: code,
  title: code,
  coordinatorship: dept,
  status: status,
  priority: TaskPriority.medium,
  start: DateTime(2026, 10, 1),
  due: due ?? DateTime(2026, 10, 30),
  plannedEnd: plannedEnd,
  assignees: assignees,
);

void main() {
  group('TimelineDateChange (koordinatör, 7 gün eşiği)', () {
    const from = DayRange(10, 20);
    TimelineDateChange of(DayRange to) =>
        TimelineDateChange.of(from, to, directRule: true);

    test('değişiklik yoksa yol yok', () {
      expect(of(from), isA<TimelineNoChange>());
    });
    test('bitiş 1–7 gün ileri: doğrudan uzatma (gün sayısıyla)', () {
      expect(of(const DayRange(10, 21)), const TimelineExtend(1));
      expect(of(const DayRange(10, 27)), const TimelineExtend(7));
    });
    test('bitiş 7 günü aşarsa tarih talebi', () {
      expect(of(const DayRange(10, 28)), isA<TimelineRequest>());
    });
    test('başlangıç değişirse (kaydırma dahil) tarih talebi', () {
      expect(of(const DayRange(11, 20)), isA<TimelineRequest>());
      expect(of(const DayRange(12, 22)), isA<TimelineRequest>());
    });
    test('bitiş en çok 7 gün geri: doğrudan kayıt; fazlası talep', () {
      expect(of(const DayRange(10, 13)), isA<TimelineSave>());
      expect(of(const DayRange(10, 12)), isA<TimelineRequest>());
    });
    test('kuralsız görünüm (yönetici) her değişikliği doğrudan kaydeder', () {
      expect(
        TimelineDateChange.of(from, const DayRange(15, 60), directRule: false),
        isA<TimelineSave>(),
      );
    });
  });

  group('TimelineLens ve sekme veri kümesi', () {
    final tasks = [
      _task('a1', assignees: ['me']),
      _task('a2', assignees: ['other']),
      _task('a3'),
      _task('b1', dept: 'ele', assignees: ['me']),
    ];
    List<String> set(TimelineLens lens) =>
        timelineTaskSet(tasks, lens, 'me').map((t) => t.code).toList();

    test('yönetici: küme değişmez, kilit yok', () {
      final lens = TimelineLens.of(
        adminView: true,
        coordinatorView: false,
        department: 'alt',
        tab: TimelineTab.mine,
      );
      expect(lens.locked, isFalse);
      expect(lens.directRule, isFalse);
      expect(set(lens), ['a1', 'a2', 'a3', 'b1']);
    });
    test('koordinatör, koordinatörlüğün görevleri: etkin koordinatörlük', () {
      final lens = TimelineLens.of(
        adminView: false,
        coordinatorView: true,
        department: 'alt',
        tab: TimelineTab.department,
      );
      expect(lens.tabs, isTrue);
      expect(lens.directRule, isTrue);
      expect(set(lens), ['a1', 'a2', 'a3']);
    });
    test('koordinatör, görevlerim: etkin koordinatörlükte bana atananlar', () {
      final lens = TimelineLens.of(
        adminView: false,
        coordinatorView: true,
        department: 'alt',
        tab: TimelineTab.mine,
      );
      expect(set(lens), ['a1']);
    });
    test('üye: sekme yok, yalnız kendi görevleri, 7 gün kuralı yok', () {
      final lens = TimelineLens.of(
        adminView: false,
        coordinatorView: false,
        department: 'ele',
        tab: TimelineTab.department,
      );
      expect(lens.tabs, isFalse);
      expect(lens.directRule, isFalse);
      expect(set(lens), ['b1']);
    });
    test('koordinatörlük bilinmiyorsa hiçbir görev eşleşmez (fail-closed)', () {
      final lens = TimelineLens.of(
        adminView: false,
        coordinatorView: true,
        department: null,
        tab: TimelineTab.department,
      );
      expect(set(lens), isEmpty);
    });
  });

  group('canPullEndToToday (WORK-K43)', () {
    final today = DateTime(2026, 10, 21);
    test('tamamlanmış, plan çekilmemiş, bitişi gelecekte: açık', () {
      expect(
        canPullEndToToday(_task('x', status: TaskStatus.done), today),
        isTrue,
      );
    });
    test('tamamlanmamış, planı çekilmiş ya da bitişi geçmiş: kapalı', () {
      expect(canPullEndToToday(_task('x'), today), isFalse);
      expect(
        canPullEndToToday(
          _task(
            'x',
            status: TaskStatus.done,
            plannedEnd: DateTime(2026, 11, 5),
          ),
          today,
        ),
        isFalse,
      );
      expect(
        canPullEndToToday(
          _task('x', status: TaskStatus.done, due: DateTime(2026, 10, 21)),
          today,
        ),
        isFalse,
      );
    });
  });
}
