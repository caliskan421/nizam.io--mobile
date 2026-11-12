/// Yığın izinin SDK'ya giden tek biçimi. Yalnız TANINAN yapılar yeniden kurulur; tanınmayan
/// her satır ATILIR (kara liste değil beyaz liste): kişisel yol, dosya adı, URL, sorgu,
/// yüzde-kodlu yol, serbest metin ve Windows kaynakları geçemez. `file:`/mutlak yol
/// çerçeveleri sembolüyle kalır, konum bilgisi `<local>` olur (dosya adı DAHİL EDİLMEZ).
final class SanitizedStackTrace implements StackTrace {
  SanitizedStackTrace._(this._text);

  final String _text;

  @override
  String toString() => _text;
}

const _maxLines = 150;

// Sembol: kod tanımlayıcıları; boşluk yalnız "<anonymous closure>" için.
const _sym = r'[A-Za-z0-9_$.<>]+(?: [A-Za-z0-9_$.<>]+){0,3}';
const _pkgPath = r'[A-Za-z0-9_]+/[A-Za-z0-9_./\-]{0,200}';
const _dartPath = r'[a-z_]+(?:/[A-Za-z0-9_./\-]{1,100})?';

final _vmFrame = RegExp(
  '^#(\\d{1,3})\\s+($_sym) \\((package:$_pkgPath|dart:$_dartPath):(\\d+):(\\d+)\\)\$',
);
final _vmFrameNoCol = RegExp(
  '^#(\\d{1,3})\\s+($_sym) \\((package:$_pkgPath|dart:$_dartPath):(\\d+)\\)\$',
);
final _localFrame = RegExp(
  '^#(\\d{1,3})\\s+($_sym) \\((?:file://|/|[A-Za-z]:[\\\\/])[^\\n]*\\)\$',
);
final _aotFrame = RegExp(
  // Android: `abs … virt … sembol+0x…`; iOS: `virt` YOK (`abs … sembol+0x…`).
  r'^#(\d{1,3})\s+abs ([0-9a-f]{1,16})(?: virt ([0-9a-f]{1,16}))? '
  r'([A-Za-z_][A-Za-z0-9_]{0,60})\+0x([0-9a-f]{1,16})$',
);
final _headers = <RegExp>[
  RegExp(
    r'^\*\*\* \*\*\* \*\*\* \*\*\* \*\*\* \*\*\* \*\*\* \*\*\* \*\*\* \*\*\* \*\*\* \*\*\* \*\*\* \*\*\* \*\*\* \*\*\*$',
  ),
  RegExp(r"^build_id: '[0-9a-f]{8,64}'$"),
  RegExp(r'^isolate_dso_base: [0-9a-f]{1,16}, vm_dso_base: [0-9a-f]{1,16}$'),
  RegExp(
    r'^isolate_instructions: [0-9a-f]{1,16}, vm_instructions: [0-9a-f]{1,16}$',
  ),
  RegExp(
    r'^os: (android|ios|macos|linux|windows|fuchsia) arch: [a-z0-9_]{2,10} comp: (yes|no) sim: (yes|no)$',
  ),
  RegExp(r'^loading_unit: \d{1,3}$'),
  RegExp(r'^<asynchronous suspension>$'),
];

/// [stack]'i yalnız tanınan, güvenli satırlara indirger.
SanitizedStackTrace sanitizeStack(StackTrace stack) {
  final out = <String>[];
  for (final raw in stack.toString().split('\n')) {
    if (out.length >= _maxLines) break;
    final line = raw.trimRight().trimLeft();
    final safe = _safeLine(line);
    if (safe != null) out.add(safe);
  }
  if (out.isEmpty) out.add('#0 <unknown>');
  return SanitizedStackTrace._(out.join('\n'));
}

String? _safeLine(String line) {
  if (line.isEmpty || line.length > 400) return null;
  for (final h in _headers) {
    if (h.hasMatch(line)) return line;
  }
  if (_aotFrame.hasMatch(line)) return line;
  if (_vmFrame.hasMatch(line) || _vmFrameNoCol.hasMatch(line)) return line;
  final local = _localFrame.firstMatch(line);
  if (local != null) return '#${local[1]} ${local[2]} (<local>)';
  return null;
}
