import 'dart:convert';

/// JSON sayı belirtecinin özgün ondalık gösterimi.
class TableWireNumber {
  const TableWireNumber(this.text);
  final String text;
}

/// Snapshot sayıları IEEE-754 üzerinden geçmez. Yalnız hücre değerleri bu
/// sarmalayıcıyı korur; şema/sıra/sürüm alanları tam sayıya çevrilir.
Object? decodeTableNumbers(String input) {
  var offset = 0;
  void whitespace() {
    while (offset < input.length && ' \r\n\t'.contains(input[offset])) {
      offset++;
    }
  }

  Never invalid() => throw const FormatException('Invalid table JSON');
  late Object? Function() value;
  String string() {
    final start = offset++;
    while (offset < input.length) {
      final c = input[offset++];
      if (c == '\\') {
        offset++;
      } else if (c == '"') {
        return jsonDecode(input.substring(start, offset)) as String;
      }
    }
    invalid();
  }

  var depth = 0;
  value = () {
    whitespace();
    if (offset >= input.length || ++depth > 64) invalid();
    final c = input[offset];
    Object? result;
    if (c == '"') {
      result = string();
    } else if (c == '{' || c == '[') {
      offset++;
      final object = c == '{';
      final map = <String, dynamic>{};
      final list = <dynamic>[];
      final end = object ? '}' : ']';
      whitespace();
      if (offset < input.length && input[offset] != end) {
        while (true) {
          whitespace();
          String? key;
          if (object) {
            if (offset >= input.length || input[offset] != '"') invalid();
            key = string();
            whitespace();
            if (offset >= input.length || input[offset++] != ':') invalid();
          }
          final item = value();
          if (object) {
            map[key!] = item;
          } else {
            list.add(item);
          }
          whitespace();
          if (offset >= input.length) invalid();
          if (input[offset] != ',') break;
          offset++;
        }
      }
      if (offset >= input.length || input[offset++] != end) invalid();
      result = object ? map : list;
    } else {
      final start = offset;
      while (offset < input.length && !',]} \r\n\t'.contains(input[offset])) {
        offset++;
      }
      final token = input.substring(start, offset);
      if (token == 'null') {
        result = null;
      } else if (token == 'true') {
        result = true;
      } else if (token == 'false') {
        result = false;
      } else {
        if (!tableNumberPattern.hasMatch(token)) invalid();
        result = TableWireNumber(token);
      }
    }
    depth--;
    return result;
  };
  final result = value();
  whitespace();
  if (offset != input.length) invalid();
  return result;
}

final tableNumberPattern = RegExp(
  r'^-?(?:0|[1-9][0-9]*)(?:\.[0-9]+)?(?:[eE][+-]?[0-9]+)?$',
);

Object? tableOrdinaryNumbers(Object? value) => switch (value) {
  TableWireNumber(:final text) => num.parse(text),
  Map<String, dynamic>() => value.map(
    (k, v) => MapEntry(k, tableOrdinaryNumbers(v)),
  ),
  List() => value.map(tableOrdinaryNumbers).toList(),
  _ => value,
};

String encodeTableValue(Object? value) => value is TableWireNumber
    ? (tableNumberPattern.hasMatch(value.text) && value.text.length <= 1000
          ? value.text
          : throw const FormatException('Invalid decimal'))
    : jsonEncode(value);
