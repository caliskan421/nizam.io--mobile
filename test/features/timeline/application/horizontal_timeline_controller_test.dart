// HorizontalTimelineController: canlı tutulur (dinleyici kalmayınca durum düşmez), gezinme
// niyetleri (null → değişmez; kod → yalnız seçim + seçili görev; "*" → hepsi), komutlar.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/timeline/application/horizontal_timeline_controller.dart';
import 'package:nizamio/features/timeline/domain/horizontal_timeline.dart';
import 'package:nizamio/features/timeline/domain/timeline.dart';

void main() {
  late ProviderContainer c;
  setUp(() => c = ProviderContainer());
  tearDown(() => c.dispose());

  HorizontalTimelineController ctrl() =>
      c.read(horizontalTimelineControllerProvider.notifier);
  GanttState state() => c.read(horizontalTimelineControllerProvider);

  /// Ölçek, süzgeç, iki çip, kapalı grup ve seçim kurulu durum.
  void arrange() => ctrl()
    ..setZoom(GanttZoom.week)
    ..setFilter(GanttFilter.open)
    ..toggleCoord('MEK')
    ..toggleCoord('ALT')
    ..toggleGroup('ELE')
    ..pick('ALT-10');

  test('açılış: ay, tümü, seçim yok', () {
    expect(state(), const GanttState());
    expect(state().zoom, GanttZoom.month);
  });

  test('canlı tutulur: dinleyici kapanınca durum kalır', () async {
    final sub = c.listen(horizontalTimelineControllerProvider, (_, _) {});
    arrange();
    final before = state();
    sub.close();
    await Future<void>.delayed(Duration.zero);
    expect(state(), before);
    expect(state().selected, 'ALT-10');
  });

  test('genel açılış (null) hiçbir şeyi sıfırlamaz', () {
    arrange();
    final before = state();
    ctrl().open(null);
    expect(state(), before);
  });

  test(
    'openCoord: yalnız [kod] ve seçim kalkar; ölçek/süzgeç/kapalı grup kalır',
    () {
      arrange();
      ctrl().open('ULA');
      expect(state().coords, ['ULA']);
      expect(state().selected, isNull);
      expect(state().zoom, GanttZoom.week);
      expect(state().filter, GanttFilter.open);
      expect(state().closed, {'ELE'});
      ctrl()
        ..pick('ULA-1')
        ..openCoord('ULA');
      expect(state().selected, isNull);
    },
  );

  test('"*": hepsi, seçim kalkar; diğerleri kalır', () {
    arrange();
    ctrl().open(timelineAllCoordinatorships);
    expect(state().coords, isEmpty);
    expect(state().selected, isNull);
    expect(state().zoom, GanttZoom.week);
    expect(state().closed, {'ELE'});
  });

  test('komutlar', () {
    arrange();
    expect(state().coords, ['MEK', 'ALT']);
    ctrl().pick('ALT-10');
    expect(state().selected, isNull);
    ctrl()
      ..pick('ALT-1')
      ..clearSelection()
      ..clearCoords()
      ..toggleGroup('ELE');
    expect(state().selected, isNull);
    expect(state().coords, isEmpty);
    expect(state().closed, isEmpty);
  });
}
