/// Kısa kişi adı (prototip `short`): üç ve daha çok sözcükte soyadı düşer
/// ("Muhammet Ali Çalışkan" → "Muhammet Ali"); iki sözcük olduğu gibi kalır.
String shortPersonName(String name) {
  final w = name.trim().split(RegExp(r'\s+'));
  return w.length > 2 ? w.take(w.length - 1).join(' ') : name;
}
