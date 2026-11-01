// Sağ yığın modeli (prototip `tgo` / `tback`): yalnız kimlik taşıyan iz ve taban kaydı.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/router/split.dart';

String? _none(PaneKind _) => null;

SplitMove _move(String location, PaneEntry to) =>
    splitMove(Uri.parse(location), to, _none);

void main() {
  test('kayıt kodu: ayrıştırma ve geri yazma', () {
    expect(
      PaneEntry.parse('task:ALT-5'),
      const PaneEntry(PaneKind.task, 'ALT-5'),
    );
    expect(PaneEntry.parse('history'), const PaneEntry(PaneKind.history));
    expect(PaneEntry.parse('history:x'), isNull);
    expect(PaneEntry.parse('task'), isNull);
    expect(PaneEntry.parse('yok:1'), isNull);
    expect(const PaneEntry(PaneKind.folder, 'İDA').code, 'folder:İDA');
  });

  test('modül kökünde taban son açılan kimlik; hiç açılmamışsa yok', () {
    expect(baseEntryOf(Uri.parse('/tasks'), _none), isNull);
    expect(
      baseEntryOf(Uri.parse('/tasks'), (k) => 'ALT-9'),
      const PaneEntry(PaneKind.task, 'ALT-9'),
    );
    expect(baseEntryOf(Uri.parse('/calendar'), _none), isNull);
    // Ana sayfada geçmiş varsayılan açık değildir: kök boş, yalnız `/home/history` tabandır.
    expect(baseEntryOf(Uri.parse('/home'), _none), isNull);
    expect(
      baseEntryOf(Uri.parse('/home/history'), _none),
      const PaneEntry(PaneKind.history),
    );
  });

  test('taban boşken modülün kendi kaydı tabana oturur, iz düşer', () {
    expect(
      (_move(
        '/tasks',
        const PaneEntry(PaneKind.task, 'ALT-7'),
      ) as SplitGo).location,
      '/tasks/ALT-7',
    );
    expect(
      (_move(
        '/messages?trail=task%3AALT-1',
        const PaneEntry(PaneKind.chat, 'gen'),
      ) as SplitGo).location,
      '/messages/gen',
    );
    // Takvimin taban türü yok: kayıt itilir.
    expect(
      (_move(
        '/calendar',
        const PaneEntry(PaneKind.task, 'ALT-5'),
      ) as SplitGo).location,
      '/calendar?trail=task%3AALT-5',
    );
  });

  test('aynı türde başka kayıt: taban değişir, iz düşer', () {
    final m = _move('/tasks/ALT-1', const PaneEntry(PaneKind.task, 'ALT-2'));
    expect((m as SplitGo).location, '/tasks/ALT-2');
  });

  test('aynı kayıt en üstte: yenile', () {
    expect(
      _move('/tasks/ALT-1', const PaneEntry(PaneKind.task, 'ALT-1')),
      isA<SplitRefresh>(),
    );
    expect(
      _move(
        '/archive?trail=task%3AALT-1',
        const PaneEntry(PaneKind.task, 'ALT-1'),
      ),
      isA<SplitRefresh>(),
    );
  });

  test('başka tür: itilir; sorgu (süzgeç) korunur', () {
    final m = _move('/tasks?view=late', const PaneEntry(PaneKind.chat, 'gen'));
    expect((m as SplitGo).location, '/tasks?view=late&trail=chat%3Agen');
  });

  test('yığında geride: oraya dönülür ve kimlik değişir', () {
    final m = _move(
      '/home?trail=task%3AA&trail=folder%3AB&trail=chat%3AC',
      const PaneEntry(PaneKind.folder, 'Z'),
    );
    expect((m as SplitGo).location, '/home?trail=task%3AA&trail=folder%3AZ');
  });

  test('ana sayfada geçmiş dokunuşla tabana oturur; takvimde taban yoktur', () {
    expect(
      (_move('/home', const PaneEntry(PaneKind.history)) as SplitGo).location,
      '/home/history',
    );
    final m = _move('/home?trail=task%3AA', const PaneEntry(PaneKind.history));
    expect((m as SplitGo).location, '/home/history');
    // Açıkken yeniden dokunma yalnız yeniler; başka kayıt geçmişin üstüne itilir.
    expect(
      _move('/home/history', const PaneEntry(PaneKind.history)),
      isA<SplitRefresh>(),
    );
    expect(
      (_move('/home', const PaneEntry(PaneKind.task, 'A')) as SplitGo).location,
      '/home?trail=task%3AA',
    );
    final c = _move('/calendar', const PaneEntry(PaneKind.task, 'A'));
    expect((c as SplitGo).location, '/calendar?trail=task%3AA');
  });

  test('geri: izin son kaydı düşer; iz yoksa null', () {
    expect(
      splitBack(Uri.parse('/coordinatorships/ALT?trail=folder%3AALT')),
      '/coordinatorships/ALT',
    );
    expect(splitBack(Uri.parse('/tasks/ALT-1')), isNull);
  });

  test('ray modülü yoldan', () {
    expect(railModuleOf('/calendar'), RailModule.calendar);
    expect(railModuleOf('/messages/gen'), RailModule.messages);
    expect(railModuleOf('/timeline'), isNull);
    expect(railModuleRoot(RailModule.archive), '/archive');
  });
}
