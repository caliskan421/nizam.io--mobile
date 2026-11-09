import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/features/tables/tables.dart';

final _generationProvider = NotifierProvider<_Generation, int>(_Generation.new);

class _Generation extends Notifier<int> {
  @override
  int build() => 1;
  void advance() => state++;
}

final _programProvider = NotifierProvider<_Program, String>(_Program.new);

class _Program extends Notifier<String> {
  @override
  String build() => 'demo-program';
  void change() => state = 'other-program';
}

ProviderContainer openTables() {
  final c = ProviderContainer(
    overrides: [
      sessionGenerationProvider.overrideWith(
        (ref) => ref.watch(_generationProvider),
      ),
      scopeStateProvider.overrideWith(
        (ref) => ScopeSelection(programId: ref.watch(_programProvider)),
      ),
    ],
  );
  addTearDown(c.dispose);
  c.listen(tablesControllerProvider, (_, _) {});
  return c;
}

void main() {
  test(
    'salt okunur tablo hücre, satır, sütun ve paylaşım komutlarını reddeder',
    () {
      final c = openTables();
      final s = c.read(tablesControllerProvider);
      final controller = c.read(tablesControllerProvider.notifier);
      final d = s.documents.firstWhere((d) => !d.editable);
      controller.rename(d.id, 'değişti');
      controller.cell(d.id, d.rows.first.id, d.fields.first.id, 'değişti');
      controller.addField(d.id, 'yeni', TableFieldType.text);
      controller.removeRow(d.id, d.rows.first.id);
      controller.share(d.id, programAccess: TableAccess.edit);
      controller.delete(d.id);
      expect(controller.addRow(d.id), isNull);
      expect(c.read(tablesControllerProvider).document(d.id), same(d));
    },
  );
  test('satır ve sütun değişimi tip veya bağlantı hedefi değişince eski değeri temizler', () {
    final c = openTables();
    final controller = c.read(tablesControllerProvider.notifier);
    final d = c.read(tablesControllerProvider).documents.first;
    final row = controller.addRow(d.id)!;
    controller.addField(d.id, 'Bağ', TableFieldType.link, target: 'table-a');
    final f = c.read(tablesControllerProvider).document(d.id)!.fields.last;
    controller.cell(d.id, row, f.id, ['row-a']);
    controller.updateField(d.id, f.copyWith(target: 'table-b'));
    expect(
      c
          .read(tablesControllerProvider)
          .document(d.id)!
          .rows
          .last
          .cells[TableFieldId(f.id)],
      '',
    );
    controller.cell(d.id, row, f.id, ['row-b']);
    controller.updateField(d.id, f.copyWith(type: TableFieldType.text));
    expect(
      c
          .read(tablesControllerProvider)
          .document(d.id)!
          .rows
          .last
          .cells[TableFieldId(f.id)],
      '',
    );
    controller.removeField(d.id, f.id);
    expect(
      c
          .read(tablesControllerProvider)
          .document(d.id)!
          .rows
          .last
          .cells
          .containsKey(TableFieldId(f.id)),
      isFalse,
    );
  });
  test('kopya yeni sahibin kişisel alanında erişim izinleri sıfırlanarak bağımsız oluşur', () {
    final c = openTables();
    final controller = c.read(tablesControllerProvider.notifier);
    final source = c
        .read(tablesControllerProvider)
        .documents
        .firstWhere((d) => !d.editable);
    final id = controller.duplicate(source.id, empty: false, suffix: 'kopya')!;
    final copy = c.read(tablesControllerProvider).document(id)!;
    expect(copy.area, TableArea.personal);
    expect(copy.access, TableAccess.owner);
    expect(copy.programAccess, TableAccess.off);
    expect(copy.people, isEmpty);
    controller.cell(id, copy.rows.first.id, copy.fields.first.id, 'yeni');
    expect(c.read(tablesControllerProvider).document(source.id), same(source));
    final destination = controller.duplicate(
      source.id,
      empty: false,
      suffix: 'alan kopyası',
      area: TableArea.coord,
      unit: 'DEMO-B',
    )!;
    final moved = c.read(tablesControllerProvider).document(destination)!;
    expect(moved.area, TableArea.coord);
    expect(moved.unit, 'DEMO-B');
    expect(moved.rows.length, source.rows.length);
    expect(moved.people, isEmpty);
    expect(moved.sharedUnits, isEmpty);
    expect(moved.programAccess, TableAccess.off);
    expect(
      controller.duplicate(
        source.id,
        empty: false,
        suffix: 'geçersiz',
        area: TableArea.shared,
      ),
      isNull,
    );
    final empty = controller.duplicate(source.id, empty: true, suffix: 'boş')!;
    expect(c.read(tablesControllerProvider).document(empty)!.rows, isEmpty);
  });
  for (final changeSession in [true, false]) {
    test(
      '${changeSession ? 'hesap' : 'kapsam'} değişimi seed dışı değişiklikleri siler; eski modal lease ve kimliği reddedilir',
      () async {
        final c = openTables();
        final controller = c.read(tablesControllerProvider.notifier);
        final original = c.read(tablesControllerProvider).documents.first;
        final lease = controller.lease;
        controller.rename(original.id, 'eski kapsam');
        if (changeSession) {
          c.read(_generationProvider.notifier).advance();
        } else {
          c.read(_programProvider.notifier).change();
        }
        await c.pump();
        final fresh = c.read(tablesControllerProvider);
        expect(fresh.document(original.id), isNull);
        expect(fresh.documents.any((d) => d.title == 'eski kapsam'), isFalse);
        expect(
          controller.create(
            title: 'gecikmiş taslak',
            area: TableArea.personal,
            fields: original.fields,
            expectedLease: lease,
          ),
          isNull,
        );
        controller.rename(original.id, 'sızma');
        expect(
          c
              .read(tablesControllerProvider)
              .documents
              .any((d) => d.title == 'sızma'),
          isFalse,
        );
      },
    );
  }
  test(
    'alan seçimi ve son kullanılan sırası açma ve düzenleme ile güncellenir',
    () {
      final c = openTables();
      final controller = c.read(tablesControllerProvider.notifier);
      final documents = c.read(tablesControllerProvider).documents;
      final second = documents[1];
      controller.setUnit(second.unit);
      expect(
        c
            .read(tablesControllerProvider)
            .visible
            .every((d) => d.unit == second.unit),
        isTrue,
      );
      controller.markOpened(second.id);
      expect(c.read(tablesControllerProvider).documents.first.id, second.id);
      controller.rename(documents.first.id, 'yeni ad');
      expect(
        c.read(tablesControllerProvider).documents.first.id,
        documents.first.id,
      );
      expect(
        controller.create(
          title: 'yanlış alan',
          area: TableArea.shared,
          fields: documents.first.fields,
        ),
        isNull,
      );
    },
  );
}
