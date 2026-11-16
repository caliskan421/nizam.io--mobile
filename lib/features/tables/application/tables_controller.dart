import 'package:flutter/foundation.dart' show mapEquals;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/stale_clock.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../../tasks/tasks.dart' show taskCatalogControllerProvider;
import '../domain/table_document.dart';
import '../domain/tables_repository.dart';
import 'table_create_job.dart';
import 'tables_server.dart';

part 'table_demo_fixtures.dart';

final tablesControllerProvider =
    NotifierProvider<TablesController, TablesState>(
      TablesController.new,
      dependencies: [
        sessionGenerationProvider,
        scopeStateProvider,
        tablesRepositoryProvider,
        tableSharingChoicesProvider,
        taskCatalogControllerProvider,
      ],
    );

/// Canlı liste sunucudan okunur; prototip yalnız açık test geçersiz kılmasındadır.
/// Hesap/oturum/kapsam değişimi bütün veri ve bekleyen kayıtları siler.
class TablesController extends Notifier<TablesState> with _TableDemoFixtures {
  int _serial = 0;
  int _serverLoad = 0;
  var _clock = StaleClock();
  Future<void>? _refreshing;
  Future<void>? _initialLoad;
  Future<void> get ready => _initialLoad ?? Future.value();
  void markServerChanged() => _clock = StaleClock();
  TableCreateJob? pendingCreateJob;
  @override
  late bool _demoExtended = false;
  @override
  late bool _referenceSampleReady = false;
  @override
  Object _lease = Object();
  Object get lease => _lease;
  @override
  TablesState build() {
    ref.watch(sessionGenerationProvider);
    ref.watch(scopeStateProvider);
    _serial = 0;
    _demoExtended = false;
    _referenceSampleReady = false;
    _lease = Object();
    pendingCreateJob = null;
    _clock = StaleClock();
    _refreshing = null;
    if (ref.watch(tablesRepositoryProvider) != null) {
      _initialLoad = Future.microtask(reloadServer);
      return TablesState(
        documents: const [],
        area: TableArea.coord,
        remote: true,
        loading: true,
      );
    }
    _initialLoad = null;
    return TablesState(
      documents: [
        TableDocument(
          id: 'demo-plan-${identityHashCode(_lease)}',
          unit: 'DEMO-A',
          title: 'Atölye hazırlıkları',
          area: TableArea.coord,
          fields: const [
            TableField(id: 'name', name: 'İş'),
            TableField(
              id: 'person',
              name: 'Sorumlu',
              type: TableFieldType.person,
            ),
            TableField(
              id: 'date',
              name: 'Son tarih',
              type: TableFieldType.date,
            ),
            TableField(id: 'done', name: 'Yapıldı', type: TableFieldType.todo),
          ],
          rows: [
            TableRecord(
              id: 'demo-r1',
              cells: {
                const TableFieldId('name'): 'Örnek hazırlık',
                const TableFieldId('person'): 'demo-1',
                const TableFieldId('date'): '2026-11-12',
                const TableFieldId('done'): false,
              },
            ),
            TableRecord(
              id: 'demo-r2',
              cells: {
                const TableFieldId('name'): 'Örnek kontrol',
                const TableFieldId('person'): 'demo-2',
                const TableFieldId('done'): true,
              },
            ),
          ],
        ),
        TableDocument(
          id: 'demo-inventory-${identityHashCode(_lease)}',
          unit: 'DEMO-B',
          title: 'Fuar alanı envanteri',
          area: TableArea.coord,
          fields: [
            const TableField(id: 'name', name: 'Malzeme'),
            const TableField(
              id: 'count',
              name: 'Adet',
              type: TableFieldType.number,
            ),
            TableField(
              id: 'link',
              name: 'Hazırlık kaydı',
              type: TableFieldType.link,
              target: 'demo-plan-${identityHashCode(_lease)}',
            ),
          ],
          rows: [
            TableRecord(
              id: 'demo-e1',
              cells: {
                const TableFieldId('name'): 'Örnek malzeme',
                const TableFieldId('count'): 12,
                const TableFieldId('link'): ['demo-r1'],
              },
            ),
          ],
        ),
        TableDocument(
          id: 'demo-personal-${identityHashCode(_lease)}',
          title: 'Kişisel çalışma notları',
          area: TableArea.personal,
          fields: const [
            TableField(id: 'name', name: 'Not'),
            TableField(id: 'done', name: 'Yapıldı', type: TableFieldType.todo),
          ],
          rows: [
            TableRecord(
              id: 'personal-r1',
              cells: {
                const TableFieldId('name'):
                    'Atölye hazırlıklarını gözden geçir',
                const TableFieldId('done'): false,
              },
            ),
          ],
        ),
        TableDocument(
          id: 'demo-shared-${identityHashCode(_lease)}',
          title: 'Vardiya planı',
          area: TableArea.shared,
          access: TableAccess.view,
          fields: const [TableField(id: 'name', name: 'Etkinlik')],
          rows: [
            TableRecord(
              id: 'demo-s1',
              cells: {const TableFieldId('name'): 'Örnek etkinlik'},
            ),
          ],
        ),
      ],
    );
  }

  String _id(String prefix) =>
      '$prefix-${identityHashCode(_lease)}-${++_serial}';
  void setArea(TableArea area) =>
      state = state.copyWith(area: area, unit: () => null, project: () => null);
  void setUnit(String? unit) =>
      state = state.copyWith(unit: () => unit, project: () => null);
  void setProject(String? project) =>
      state = state.copyWith(project: () => project);
  void setTemplatesOnly(bool value) =>
      state = state.copyWith(templatesOnly: value);
  void markOpened(String id) {
    final d = state.document(id);
    if (d != null) _put(d);
  }

  void setQuery(String query) => state = state.copyWith(query: query);
  void _put(TableDocument document) => state = state.copyWith(
    documents: [document, ...state.documents.where((d) => d.id != document.id)],
  );
  void _edit(String id, TableDocument Function(TableDocument) change) {
    final d = state.document(id);
    if (d != null && d.editable) _put(change(d));
  }

  Future<void> refresh() {
    if (ref.read(tablesRepositoryProvider) == null) return Future.value();
    if (_refreshing case final pending?) return pending;
    late final Future<void> result;
    result = reloadServer(refreshChoices: true, keepPrevious: true)
        .whenComplete(() {
          if (identical(_refreshing, result)) _refreshing = null;
        });
    _refreshing = result;
    return result;
  }

  Future<void> refreshIfStale() {
    if (state.loading ||
        state.error != null ||
        _refreshing != null ||
        !state.remote) {
      return Future.value();
    }
    return _clock.refreshIfStale(AsyncData(state), refresh);
  }

  bool _sameDocuments(List<TableDocument> before, List<TableDocument> after) {
    if (before.length != after.length) return false;
    final previous = {for (final d in before) TableDocumentId(d.id): d};
    return after.every((d) {
      final old = previous[TableDocumentId(d.id)];
      return old != null &&
          old.title == d.title &&
          old.unit == d.unit &&
          old.area == d.area &&
          old.access == d.access &&
          old.teamAccess == d.teamAccess &&
          old.ownerId == d.ownerId &&
          old.projectId == d.projectId &&
          old.isTemplate == d.isTemplate &&
          old.programId == d.programId;
    });
  }

  Future<void> reloadServer({
    bool refreshChoices = false,
    bool keepPrevious = false,
  }) async {
    final repository = ref.read(tablesRepositoryProvider);
    if (repository == null) return;
    final lease = _lease;
    final load = ++_serverLoad;
    if (refreshChoices) {
      ref.invalidate(taskCatalogControllerProvider);
      ref.invalidate(tableSharingChoicesProvider);
    }
    final program = ref.read(scopeStateProvider).programId ?? '';
    bool current() =>
        ref.mounted && identical(lease, _lease) && load == _serverLoad;
    if (!keepPrevious) {
      state = state.copyWith(documents: [], loading: true, error: () => null);
    }
    try {
      final choices = await ref.read(tableSharingChoicesProvider.future);
      if (!current()) return;
      final documents = <TableDocument>[];
      for (final location in [
        TableLocation(program),
        for (final department in choices.departments.keys)
          TableLocation(program, department.value),
      ]) {
        if (!current()) return;
        documents.addAll(await repository.list(location, choices.accountId));
      }
      if (!current()) return;
      _clock.markFresh();
      final same = _sameDocuments(state.documents, documents);
      if (keepPrevious &&
          same &&
          state.error == null &&
          mapEquals(state.departmentNames, choices.departments)) {
        return;
      }
      state = state.copyWith(
        documents: same ? state.documents : documents,
        loading: false,
        departmentNames: choices.departments,
        error: () => null,
      );
    } on Object catch (e, st) {
      final error = toReportedApiError(e, st, source: ReportSource.provider);
      if (current()) {
        state = state.copyWith(
          documents: keepPrevious ? null : [],
          loading: false,
          error: () => error,
        );
        if (keepPrevious) Error.throwWithStackTrace(error, st);
      }
    }
  }

  String? create({
    required String title,
    TableArea area = TableArea.personal,
    required List<TableField> fields,
    String unit = 'DEMO-A',
    TableAccess teamAccess = TableAccess.off,
    Object? expectedLease,
    Map<TablePersonId, TableAccess> people = const {},
  }) {
    if (ref.read(tablesRepositoryProvider) != null) return null;
    if ((expectedLease != null && !identical(expectedLease, _lease)) ||
        area == TableArea.shared ||
        title.trim().isEmpty ||
        title.trim().runes.length > 200 ||
        (teamAccess != TableAccess.off &&
            (area != TableArea.coord ||
                !tableDemoUnits.contains(unit) ||
                ![TableAccess.view, TableAccess.edit].contains(teamAccess))) ||
        people.values.any(
          (v) => ![TableAccess.view, TableAccess.edit].contains(v),
        ) ||
        fields.isEmpty) {
      return null;
    }
    final id = _id('table');
    state = state.copyWith(
      documents: [
        TableDocument(
          id: id,
          title: title.trim(),
          area: area,
          unit: unit,
          fields: fields,
          people: people,
          teamAccess: teamAccess,
        ),
        ...state.documents,
      ],
    );
    return id;
  }

  void rename(String id, String name) {
    if (name.trim().isNotEmpty) {
      _edit(id, (d) => d.copyWith(title: name.trim()));
    }
  }

  void delete(String id) {
    final d = state.document(id);
    if (d?.canShare != true) return;
    state = state.copyWith(
      documents: state.documents.where((d) => d.id != id).toList(),
    );
  }

  String? duplicate(
    String id, {
    required bool empty,
    required String suffix,
    TableArea? area,
    String? unit,
  }) {
    final d = state.document(id);
    if (d == null || d.remote || area == TableArea.shared) return null;
    final copy = d.copyWith(
      id: _id('copy'),
      area: area ?? (d.area == TableArea.shared ? TableArea.personal : d.area),
      unit: unit,
      title: '${d.title} $suffix',
      rows: empty ? [] : d.rows,
      access: TableAccess.owner,
      people: {},
      programAccess: TableAccess.off,
      sharedUnits: [],
      teamAccess: TableAccess.off,
    );
    state = state.copyWith(documents: [copy, ...state.documents]);
    return copy.id;
  }

  String? addRow(String id) {
    final d = state.document(id);
    if (d == null || !d.editable) return null;
    final row = TableRecord(id: _id('row'));
    _put(d.copyWith(rows: [...d.rows, row]));
    return row.id;
  }

  void removeRow(String id, String row) => _edit(
    id,
    (d) => d.copyWith(rows: d.rows.where((r) => r.id != row).toList()),
  );
  void cell(String id, String row, String field, Object value) => _edit(
    id,
    (d) => d.fields.any((f) => f.id == field)
        ? d.copyWith(
            rows: [
              for (final r in d.rows)
                if (r.id == row) r.withCell(field, value) else r,
            ],
          )
        : d,
  );
  void addField(String id, String name, TableFieldType type, {String? target}) {
    if (name.trim().isEmpty) return;
    _edit(
      id,
      (d) => d.copyWith(
        fields: [
          ...d.fields,
          TableField(
            id: _id('field'),
            name: name.trim(),
            type: type,
            target: target,
          ),
        ],
      ),
    );
  }

  void updateField(String id, TableField field) => _edit(
    id,
    (d) => d.copyWith(
      fields: [
        for (final f in d.fields)
          if (f.id == field.id) field else f,
      ],
      rows: [
        for (final row in d.rows)
          if (d.fields.any(
            (f) =>
                f.id == field.id &&
                (f.type != field.type || f.target != field.target),
          ))
            row.withCell(field.id, '')
          else
            row,
      ],
    ),
  );
  void removeField(String id, String field) => _edit(
    id,
    (d) => d.fields.length < 2
        ? d
        : d.copyWith(
            fields: d.fields.where((f) => f.id != field).toList(),
            rows: [
              for (final row in d.rows)
                TableRecord(
                  id: row.id,
                  cells: {...row.cells}..remove(TableFieldId(field)),
                ),
            ],
          ),
  );
  void moveField(String id, String field, int delta) => _edit(id, (d) {
    final fields = d.fields.toList();
    final from = fields.indexWhere((f) => f.id == field);
    final to = from + delta;
    if (from < 0 || to < 0 || to >= fields.length) return d;
    fields.insert(to, fields.removeAt(from));
    return d.copyWith(fields: fields);
  });
  void reorderFields(String id, int from, int to) => _edit(id, (d) {
    final fields = d.fields.toList();
    if (from < 0 || from >= fields.length || to < 0 || to >= fields.length) {
      return d;
    }
    fields.insert(to, fields.removeAt(from));
    return d.copyWith(fields: fields);
  });
  void share(
    String id, {
    TableAccess? programAccess,
    List<String>? sharedUnits,
    Map<TablePersonId, TableAccess>? people,
  }) {
    final d = state.document(id);
    if (d?.canShare == true) {
      _put(
        d!.copyWith(
          programAccess: programAccess,
          sharedUnits: sharedUnits,
          people: people,
        ),
      );
    }
  }
}
