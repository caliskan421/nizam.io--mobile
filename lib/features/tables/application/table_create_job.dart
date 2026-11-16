import '../../../core/domain/request_key.dart';
import '../../../core/errors/api_error.dart';
import '../domain/table_document.dart';
import '../domain/tables_repository.dart';

/// Form ömrünce tutulan sabit plan. Başarılı adımlar tekrar edilmez; belirsiz
/// isteğin yeniden gönderimi aynı anahtar/gövdeyle yapılır. Yeni tablo üretilmez.
class TableCreateJob {
  TableCreateJob({
    required this.repository,
    required this.location,
    required this.title,
    required List<TableField> fields,
    required Map<TablePersonId, TableAccess> people,
    this.template = TableTemplate.blank,
    this.teamAccess = TableAccess.off,
    this.proposalDepartment,
  }) : fields = List.unmodifiable(fields),
       people = Map.unmodifiable(people);
  final TablesRepository repository;
  final TableLocation location;
  final String title;
  final TableTemplate template;
  final List<TableField> fields;
  final Map<TablePersonId, TableAccess> people;
  final TableAccess teamAccess;
  final String? proposalDepartment;
  final _keys = <TableStepId, String>{};
  final _done = <String>{};
  String? tableId;
  int _schema = 1;
  bool completed = false;
  bool sending = false;
  String _key(String step) =>
      _keys.putIfAbsent(TableStepId(step), newRequestKey);

  Future<String> submit({required bool Function() isCurrent}) async {
    if (sending) throw StateError('Tablo kaydı sürüyor');
    sending = true;
    void check() {
      if (!isCurrent()) throw ApiError('client.scope_changed');
    }

    try {
      check();
      if (tableId == null) {
        final r = await repository.create(location, title, _key('create'));
        check();
        tableId = r.tableId;
        _schema = r.schemaVersion;
      }
      for (var i = 0; i < fields.length; i++) {
        final step = 'column:$i';
        if (_done.contains(step)) continue;
        check();
        final r = await repository.addColumn(
          location,
          tableId!,
          fields[i],
          _schema,
          _key(step),
        );
        check();
        _schema = r.schemaVersion;
        _done.add(step);
      }
      for (final e in people.entries) {
        final step = 'grant:${e.key.value}';
        if (_done.contains(step)) continue;
        check();
        await repository.grant(
          location,
          tableId!,
          e.key.value,
          e.value,
          _key(step),
        );
        check();
        _done.add(step);
      }
      if (proposalDepartment == null &&
          teamAccess != TableAccess.off &&
          !_done.contains('team')) {
        check();
        await repository.setTeamRole(
          location,
          tableId!,
          teamAccess,
          _key('team'),
        );
        check();
        _done.add('team');
      }
      if (proposalDepartment != null && !_done.contains('proposal')) {
        check();
        await repository.propose(
          location,
          tableId!,
          proposalDepartment!,
          teamAccess == TableAccess.off ? TableAccess.view : teamAccess,
          _key('proposal'),
        );
        check();
        _done.add('proposal');
      }
      completed = true;
      return tableId!;
    } finally {
      sending = false;
    }
  }
}
