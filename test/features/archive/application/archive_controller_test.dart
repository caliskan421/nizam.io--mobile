// ArchiveController: arama aç/kapa, sıralama döngüsü, etiket seçimi, yeni etiket.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/archive/application/archive_controller.dart';
import 'package:nizamio/features/archive/domain/archive.dart';

void main() {
  late ProviderContainer c;
  setUp(() => c = ProviderContainer());
  tearDown(() => c.dispose());
  ArchiveController ctrl() => c.read(archiveControllerProvider.notifier);
  ArchiveViewState s() => c.read(archiveControllerProvider);

  test('arama: açılınca sorgu tutulur, kapanınca temizlenir', () {
    ctrl()
      ..toggleSearch()
      ..setQuery('fuar');
    expect(s().searchOpen, isTrue);
    expect(s().query, 'fuar');
    ctrl().toggleSearch();
    expect(s().searchOpen, isFalse);
    expect(s().query, '');
  });

  test('sıralama: son yükleme → ad → boyut → son yükleme', () {
    expect(s().sort, ArchiveSort.recent);
    ctrl().cycleSort();
    expect(s().sort, ArchiveSort.name);
    ctrl().cycleSort();
    expect(s().sort, ArchiveSort.size);
    ctrl().cycleSort();
    expect(s().sort, ArchiveSort.recent);
  });

  test('etiket: seç, aynısı kaldırır; özel etiket hazırı bırakır; temizle', () {
    ctrl().pickTag(ArchiveTag.field);
    expect(s().tag, ArchiveTag.field);
    ctrl().pickTag(ArchiveTag.field);
    expect(s().tag, isNull);
    ctrl()
      ..pickTag(ArchiveTag.data)
      ..setDraftColor(ArchiveTagColor.red);
    expect(ctrl().addTag('  '), isNull);
    expect(ctrl().addTag(' Teslim '), 'Teslim');
    expect(s().tagTotal, 4);
    expect(s().customTags.single.color, ArchiveTagColor.red);
    ctrl().pickCustomTag(s().customTags.single.id);
    expect(s().tag, isNull);
    expect(s().hasTag, isTrue);
    ctrl().clearTag();
    expect(s().hasTag, isFalse);
    ctrl().toggleTags();
    expect(s().tagsOpen, isTrue);
  });
}
