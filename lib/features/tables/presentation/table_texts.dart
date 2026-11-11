import '../../../core/i18n/generated/app_localizations.dart';
import '../domain/table_document.dart';

extension TableTexts on AppLocalizations {
  String tableDemoPerson(String id) => switch (id) {
    'demo-1' => 'Kadir Özbek',
    'demo-2' => 'Reha Koçak',
    'demo-3' => 'Ali Avcı',
    'demo-4' => 'Abdullah Ateş',
    _ => '$uiTablesDemoPerson ${id.split('-').last}',
  };
  String tableUnitCode(String id) => switch (id) {
    'DEMO-A' => 'ALT',
    'DEMO-B' => 'İDA',
    'DEMO-C' => 'OPE',
    'DEMO-D' => 'EĞİ',
    'DEMO-E' => 'ELE',
    'DEMO-F' => 'FUA',
    'DEMO-G' => 'MEK',
    'DEMO-H' => 'MİM',
    'DEMO-I' => 'SAT',
    'DEMO-J' => 'SİS',
    'DEMO-K' => 'ULA',
    _ => id,
  };
  String tableUnit(String id) => switch (id) {
    'DEMO-A' => 'Altyapı ve tesisat',
    'DEMO-B' => 'İdari işler',
    'DEMO-C' => 'Operasyon',
    'DEMO-D' => 'Eğitim ve Arge',
    'DEMO-E' => 'Elektrik ve enerji',
    'DEMO-F' => 'Fuar',
    'DEMO-G' => 'Mekanik sistemler',
    'DEMO-H' => 'Mimari tasarım',
    'DEMO-I' => 'Satış ve pazarlama',
    'DEMO-J' => 'Sistem koordinatörlüğü',
    'DEMO-K' => 'Ulaşım planlama',
    _ => '$uiTablesUnitSample $id',
  };
  String tableType(TableFieldType t) => switch (t) {
    TableFieldType.text => uiTablesText,
    TableFieldType.number => uiTablesNumber,
    TableFieldType.date => uiTablesDate,
    TableFieldType.phone => uiTablesPhone,
    TableFieldType.email => uiTablesEmail,
    TableFieldType.person => uiTablesPerson,
    TableFieldType.unit => uiTablesUnit,
    TableFieldType.task => uiTablesTask,
    TableFieldType.link => uiTablesLink,
    TableFieldType.file => uiTablesFile,
    TableFieldType.todo => uiTablesTodo,
  };
  String tableArea(TableArea t) => switch (t) {
    TableArea.coord => uiTablesCoord,
    TableArea.personal => uiTablesPersonal,
    TableArea.shared => uiTablesShared,
  };
  String tableAccess(TableAccess t) => switch (t) {
    TableAccess.off => uiTablesOff,
    TableAccess.view => uiTablesView,
    TableAccess.edit => uiTablesEdit,
    TableAccess.owner => uiTablesOwner,
  };
  String tableTemplate(TableTemplate t) => switch (t) {
    TableTemplate.blank => uiTablesBlank,
    TableTemplate.taskList => uiTablesTaskList,
    TableTemplate.eventPlan => uiTablesEventPlan,
    TableTemplate.actionList => uiTablesActionList,
    TableTemplate.supplierList => uiTablesSupplierList,
    TableTemplate.volunteerList => uiTablesVolunteerList,
    TableTemplate.inventory => uiTablesInventory,
  };
  List<TableField> templateFields(TableTemplate t) {
    final List<(String, TableFieldType)> pairs = switch (t) {
      TableTemplate.blank => [(uiTablesName, TableFieldType.text)],
      TableTemplate.taskList => [
        (uiTablesTask, TableFieldType.text),
        (uiTablesPerson, TableFieldType.person),
        (uiTablesUnit, TableFieldType.unit),
        (uiTablesDate, TableFieldType.date),
        (uiTablesTodo, TableFieldType.todo),
      ],
      TableTemplate.eventPlan => [
        (uiTablesActivity, TableFieldType.text),
        (uiTablesPlace, TableFieldType.text),
        (uiTablesPerson, TableFieldType.person),
        (uiTablesDate, TableFieldType.date),
        (uiTablesTodo, TableFieldType.todo),
      ],
      TableTemplate.actionList => [
        (uiTablesAction, TableFieldType.text),
        (uiTablesPerson, TableFieldType.person),
        (uiTablesTask, TableFieldType.task),
        (uiTablesTodo, TableFieldType.todo),
      ],
      TableTemplate.supplierList => [
        (uiTablesName, TableFieldType.text),
        (uiTablesPhone, TableFieldType.phone),
        (uiTablesEmail, TableFieldType.email),
        (uiTablesNumber, TableFieldType.number),
      ],
      TableTemplate.volunteerList => [
        (uiTablesName, TableFieldType.text),
        (uiTablesPhone, TableFieldType.phone),
        (uiTablesUnit, TableFieldType.unit),
      ],
      TableTemplate.inventory => [
        (uiTablesMaterial, TableFieldType.text),
        (uiTablesNumber, TableFieldType.number),
        (uiTablesDate, TableFieldType.date),
        (uiTablesTodo, TableFieldType.todo),
      ],
    };
    return [
      for (var i = 0; i < pairs.length; i++)
        TableField(id: 'f$i', name: pairs[i].$1, type: pairs[i].$2),
    ];
  }
}
