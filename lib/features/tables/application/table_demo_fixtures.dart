part of 'tables_controller.dart';

mixin _TableDemoFixtures on Notifier<TablesState> {
  bool get _demoExtended;
  set _demoExtended(bool value);
  bool get _referenceSampleReady;
  set _referenceSampleReady(bool value);
  Object get _lease;

  /// Genişletilmiş örnek seti mevcut oturumdaki düzenlemeleri silmeden ekler.
  void ensureDemoFixtures() {
    if (ref.read(tablesRepositoryProvider) != null) return;
    _ensureReferenceSample();
    if (_demoExtended) return;
    _demoExtended = true;
    TableDocument sample(
      String id,
      String title,
      TableArea area, {
      String unit = 'DEMO-A',
      TableAccess access = TableAccess.owner,
    }) => TableDocument(
      id: 'demo-extra-$id-${identityHashCode(_lease)}',
      title: title,
      area: area,
      unit: unit,
      access: access,
      fields: const [
        TableField(id: 'name', name: 'İş'),
        TableField(id: 'person', name: 'Sorumlu', type: TableFieldType.person),
        TableField(id: 'done', name: 'Durum', type: TableFieldType.todo),
      ],
      rows: [
        TableRecord(
          id: '$id-1',
          cells: {
            const TableFieldId('name'): 'Hazırlık',
            const TableFieldId('person'): 'demo-1',
            const TableFieldId('done'): false,
          },
        ),
        TableRecord(
          id: '$id-2',
          cells: {
            const TableFieldId('name'): 'Kontrol',
            const TableFieldId('person'): 'demo-2',
            const TableFieldId('done'): true,
          },
        ),
      ],
    );
    state = state.copyWith(
      documents: [
        ...state.documents,
        sample('ops-1', 'Operasyon görevleri', TableArea.coord, unit: 'DEMO-C'),
        sample('ops-2', 'Etkinlik planı', TableArea.coord, unit: 'DEMO-C'),
        sample('ops-3', 'Malzeme takibi', TableArea.coord, unit: 'DEMO-C'),
        sample('personal-2', 'Haftalık plan', TableArea.personal),
        sample('personal-3', 'Yapılacaklar', TableArea.personal),
        sample(
          'shared-2',
          'Ortak çalışma planı',
          TableArea.shared,
          access: TableAccess.view,
        ),
        sample(
          'shared-3',
          'Etkinlik takvimi',
          TableArea.shared,
          access: TableAccess.view,
        ),
      ],
    );
  }

  void _ensureReferenceSample() {
    if (_referenceSampleReady) return;
    _referenceSampleReady = true;
    final original = state.documents
        .where((d) => d.id.startsWith('demo-plan-'))
        .firstOrNull;
    if (original == null ||
        original.title != 'Atölye hazırlıkları' ||
        original.fields.length != 4 ||
        original.rows.length != 2 ||
        original.rows.first.cells[const TableFieldId('name')] !=
            'Örnek hazırlık' ||
        original.rows.last.cells[const TableFieldId('name')] !=
            'Örnek kontrol') {
      return;
    }
    TableRecord row(
      String id,
      String name,
      String person,
      String task,
      String date,
      bool done, [
      List<String> files = const [],
    ]) => TableRecord(
      id: id,
      cells: {
        const TableFieldId('name'): name,
        const TableFieldId('person'): person,
        const TableFieldId('task'): task,
        const TableFieldId('date'): date,
        const TableFieldId('file'): files,
        const TableFieldId('done'): done,
      },
    );
    final sample = original.copyWith(
      title: 'Hidrofor montaj kontrol listesi',
      fields: const [
        TableField(id: 'name', name: 'Adım'),
        TableField(id: 'person', name: 'Sorumlu', type: TableFieldType.person),
        TableField(id: 'task', name: 'Görev', type: TableFieldType.task),
        TableField(id: 'date', name: 'Son tarih', type: TableFieldType.date),
        TableField(id: 'file', name: 'Kanıt', type: TableFieldType.file),
        TableField(id: 'done', name: 'Tamam', type: TableFieldType.todo),
      ],
      rows: [
        row(
          'demo-r1',
          'Pompaların sahaya teslimi',
          'demo-1',
          'demo-task-1',
          '2026-10-28',
          false,
          ['Örnek belge.pdf'],
        ),
        row(
          'demo-r2',
          'Vinç ve elektrik bağlantısı',
          'demo-2',
          'demo-task-1',
          '2026-10-27',
          true,
          ['Örnek görsel.jpg', 'Kontrol.pdf'],
        ),
        row(
          'demo-r3',
          'Montaj ekibinin saha planı',
          'demo-3',
          'demo-task-2',
          '2026-10-26',
          true,
        ),
        row(
          'demo-r4',
          'Basınç testi',
          'demo-4',
          'demo-task-2',
          '2026-10-30',
          false,
        ),
        row(
          'demo-r5',
          'Teslim tutanağı',
          'demo-1',
          'demo-task-3',
          '2026-11-02',
          false,
        ),
      ],
      people: const {
        TablePersonId('demo-1'): TableAccess.edit,
        TablePersonId('demo-2'): TableAccess.edit,
        TablePersonId('demo-3'): TableAccess.edit,
      },
    );
    state = state.copyWith(
      documents: [
        for (final d in state.documents)
          if (d.id == original.id) sample else d,
      ],
    );
  }
}
