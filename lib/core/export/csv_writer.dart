import 'dart:convert';

/// UTF-8 CSV with a BOM for spreadsheet applications. Formula prefixes are escaped
/// before quoting; every field is quoted and embedded quotes are doubled.
List<int> csvBytes(Iterable<Iterable<String>> rows) {
  String cell(String text) {
    final safe =
        RegExp(r'^\s*[=+\-@]').hasMatch(text) ||
            text.startsWith('\t') ||
            text.startsWith('\r')
        ? "'$text"
        : text;
    return '"${safe.replaceAll('"', '""')}"';
  }

  return utf8.encode(
    '\uFEFF${rows.map((row) => row.map(cell).join(',')).join('\r\n')}\r\n',
  );
}
