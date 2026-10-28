/// Türkçe alfabe sırasıyla karşılaştırma (`String.compareTo` kod birimine bakar: Ç, Ğ, İ, Ö, Ş,
/// Ü sona düşer, I/ı ayrımı kaybolur). Büyük/küçük harf duyarsızdır; alfabe dışı karakterler
/// kod birimiyle, Türkçe harflerden sonra sıralanır. Eşitlikte özgün dizeler karşılaştırılır
/// (sıra kararlı olsun).
int compareTurkish(String a, String b) {
  final ka = _key(a);
  final kb = _key(b);
  final n = ka.length < kb.length ? ka.length : kb.length;
  for (var i = 0; i < n; i++) {
    final d = ka[i] - kb[i];
    if (d != 0) return d;
  }
  final d = ka.length - kb.length;
  return d != 0 ? d : a.compareTo(b);
}

const _alphabet = 'abcçdefgğhıijklmnoöprsştuüvyz';
const _upper = 'ABCÇDEFGĞHIİJKLMNOÖPRSŞTUÜVYZ';

List<int> _key(String s) => [
  for (final r in s.runes) _rank(String.fromCharCode(r)),
];

int _rank(String ch) {
  var i = _alphabet.indexOf(ch);
  if (i < 0) i = _upper.indexOf(ch);
  // Boşluk harflerden önce gelir ("Ada X" < "Adam").
  if (ch == ' ') return 0;
  return i >= 0 ? i + 1 : _alphabet.length + 1 + ch.codeUnitAt(0);
}
