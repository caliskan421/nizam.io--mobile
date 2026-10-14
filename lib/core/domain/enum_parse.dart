/// Sunucu dizgesini domain enum'una çevirir; bilinmeyen ya da `null` değer [fallback]
/// (her domain enum'unun `unknown` üyesi) olur. Yeni backend etiketi uygulamayı kırmaz.
///
/// Kullanım: `enumFromWire(Role.values, wire, Role.unknown)`; eşleşme `name` ile yapılır,
/// sunucu adı farklıysa çağıran önce [wire]'ı eşler.
T enumFromWire<T extends Enum>(Iterable<T> values, String? wire, T fallback) {
  if (wire == null) return fallback;
  for (final v in values) {
    if (v.name == wire) return v;
  }
  return fallback;
}
