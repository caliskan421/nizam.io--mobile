extension type const TableFieldId(String value) {}

extension type const TablePersonId(String value) {}

/// Oturumluk tablo alanları; hiçbir API/gerçek kişi verisi taşımaz.
enum TableFieldType {
  text,
  number,
  date,
  phone,
  email,
  person,
  unit,
  task,
  link,
  file,
  todo,
}

enum TableArea { coord, personal, shared }

const tableDemoUnits = <String>[
  'DEMO-A',
  'DEMO-B',
  'DEMO-C',
  'DEMO-D',
  'DEMO-E',
  'DEMO-F',
  'DEMO-G',
  'DEMO-H',
  'DEMO-I',
  'DEMO-J',
  'DEMO-K',
];

enum TableAccess { off, view, edit, owner }

enum TableTemplate {
  blank,
  taskList,
  eventPlan,
  actionList,
  supplierList,
  volunteerList,
  inventory,
}

class TableField {
  const TableField({
    required this.id,
    required this.name,
    this.type = TableFieldType.text,
    this.target,
  });
  final String id;
  final String name;
  final TableFieldType type;
  final String? target;
  TableField copyWith({String? name, TableFieldType? type, String? target}) =>
      TableField(
        id: id,
        name: name ?? this.name,
        type: type ?? this.type,
        target: target ?? this.target,
      );
}

class TableRecord {
  TableRecord({required this.id, Map<TableFieldId, Object>? cells})
    : cells = Map.unmodifiable(cells ?? {});
  final String id;
  final Map<TableFieldId, Object> cells;
  TableRecord withCell(String field, Object value) =>
      TableRecord(id: id, cells: {...cells, TableFieldId(field): value});
}

class TableDocument {
  TableDocument({
    required this.id,
    required this.title,
    required this.area,
    required List<TableField> fields,
    List<TableRecord> rows = const [],
    this.access = TableAccess.owner,
    this.programAccess = TableAccess.off,
    List<String> sharedUnits = const [],
    Map<TablePersonId, TableAccess> people = const {},
    this.unit = 'DEMO',
  }) : fields = List.unmodifiable(fields),
       rows = List.unmodifiable(rows),
       people = Map.unmodifiable(people),
       sharedUnits = List.unmodifiable(sharedUnits);
  final String id;
  final String title;
  final TableArea area;
  final String unit;
  final List<TableField> fields;
  final List<TableRecord> rows;
  final TableAccess access;
  final TableAccess programAccess;
  final List<String> sharedUnits;
  final Map<TablePersonId, TableAccess> people;
  bool get editable =>
      access == TableAccess.owner || access == TableAccess.edit;
  bool get canShare => access == TableAccess.owner;
  TableDocument copyWith({
    String? id,
    String? title,
    TableArea? area,
    String? unit,
    List<TableField>? fields,
    List<TableRecord>? rows,
    TableAccess? access,
    TableAccess? programAccess,
    List<String>? sharedUnits,
    Map<TablePersonId, TableAccess>? people,
  }) => TableDocument(
    id: id ?? this.id,
    title: title ?? this.title,
    area: area ?? this.area,
    unit: unit ?? this.unit,
    fields: fields ?? this.fields,
    rows: rows ?? this.rows,
    access: access ?? this.access,
    programAccess: programAccess ?? this.programAccess,
    sharedUnits: sharedUnits ?? this.sharedUnits,
    people: people ?? this.people,
  );
}

class TablesState {
  TablesState({
    required List<TableDocument> documents,
    this.area = TableArea.coord,
    this.query = '',
    this.unit,
  }) : documents = List.unmodifiable(documents);
  final List<TableDocument> documents;
  final TableArea area;
  final String query;
  final String? unit;
  List<TableDocument> get visible => documents
      .where(
        (d) =>
            d.area == area &&
            (unit == null || d.unit == unit) &&
            d.title.toLowerCase().contains(query.toLowerCase().trim()),
      )
      .toList();
  TableDocument? document(String id) {
    for (final d in documents) {
      if (d.id == id) return d;
    }
    return null;
  }

  TablesState copyWith({
    List<TableDocument>? documents,
    TableArea? area,
    String? query,
    String? Function()? unit,
  }) => TablesState(
    documents: documents ?? this.documents,
    area: area ?? this.area,
    query: query ?? this.query,
    unit: unit == null ? this.unit : unit(),
  );
}
