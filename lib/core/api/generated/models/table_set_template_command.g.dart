// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_set_template_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableSetTemplateCommand _$TableSetTemplateCommandFromJson(
  Map<String, dynamic> json,
) => _TableSetTemplateCommand(
  kind: TableSetTemplateCommandKind.fromJson(json['kind'] as String),
  template: json['template'] as bool,
);

Map<String, dynamic> _$TableSetTemplateCommandToJson(
  _TableSetTemplateCommand instance,
) => <String, dynamic>{
  'kind': _$TableSetTemplateCommandKindEnumMap[instance.kind]!,
  'template': instance.template,
};

const _$TableSetTemplateCommandKindEnumMap = {
  TableSetTemplateCommandKind.setTemplate: 'set_template',
  TableSetTemplateCommandKind.$unknown: r'$unknown',
};
