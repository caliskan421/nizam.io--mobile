/// İmleçli (cursor) sayfalamanın bir dilimi. Saf Dart, değişmez (sınır kuralı S4).
///
/// Biçim backend sözleşmesindeki (`openapi.yaml`, `v0.1.0-api`) sayfalamayı yansıtır:
/// yalnız imleç; offset ve toplam sayı (`total`) yoktur.
class PageSlice<T> {
  /// [items] değişmez bir kopyaya alınır.
  PageSlice({required List<T> items, this.nextCursor, this.truncated = false})
    : items = List<T>.unmodifiable(items);

  /// Boş, son sayfa.
  PageSlice.empty() : this(items: const []);

  /// Bu dilimin satırları. Sunucunun `null` dizisi repository'de boş listeye eşlenir.
  final List<T> items;

  /// Sonraki sayfanın opak imleci (`next_cursor`); `null` ise son sayfa. Ayrıştırılmaz.
  final String? nextCursor;

  /// `X-Result-Truncated: true` başlığı: imleçsiz liste en çok 200 satırda kesildi.
  final bool truncated;

  /// İmleçle istenebilecek başka sayfa var mı.
  bool get hasMore => nextCursor != null;

  /// Satırları [convert] ile dönüştürür; imleç ve kesilme bilgisi korunur.
  PageSlice<R> map<R>(R Function(T item) convert) => PageSlice<R>(
    items: items.map(convert).toList(growable: false),
    nextCursor: nextCursor,
    truncated: truncated,
  );

  /// Sonraki [next] dilimini bu dilimin ardına ekler (satırlar birleşir; imleç ve
  /// kesilme bilgisi sonraki dilimden gelir).
  PageSlice<T> append(PageSlice<T> next) => PageSlice<T>(
    items: [...items, ...next.items],
    nextCursor: next.nextCursor,
    truncated: next.truncated,
  );
}

/// Liste isteğinin sayfalama sorgu parametreleri (`limit`, `cursor`).
class PageRequest {
  /// [limit] verilirse en az 1 olmalıdır (sözleşme: minimum 1).
  const PageRequest({this.limit, this.cursor})
    : assert(limit == null || limit >= 1, 'limit en az 1 olmalı');

  /// En çok kaç satır; `null` ise sunucu varsayılanı.
  final int? limit;

  /// Önceki dilimin [PageSlice.nextCursor] değeri; `null` ise ilk sayfa.
  final String? cursor;
}
