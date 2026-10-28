import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/archive.dart';

part 'archive_controller.g.dart';

/// Arşiv ekranının durumu: arama, sıralama, etiket süzgeci ve kullanıcının eklediği etiketler.
@immutable
final class ArchiveViewState {
  const ArchiveViewState({
    this.sort = ArchiveSort.recent,
    this.searchOpen = false,
    this.query = '',
    this.tagsOpen = false,
    this.tag,
    this.customTag,
    this.customTags = const [],
    this.draftColor = ArchiveTagColor.gold,
  });

  final ArchiveSort sort;
  final bool searchOpen;
  final String query;
  final bool tagsOpen;

  /// Seçili hazır etiket (en çok biri [tag] ya da [customTag]).
  final ArchiveTag? tag;

  /// Seçili özel etiketin kimliği.
  final String? customTag;
  final List<ArchiveCustomTag> customTags;
  final ArchiveTagColor draftColor;

  bool get hasTag => tag != null || customTag != null;

  /// Hazır üç etiket + eklenenler.
  int get tagTotal => ArchiveTag.values.length + customTags.length;

  ArchiveViewState copyWith({
    ArchiveSort? sort,
    bool? searchOpen,
    String? query,
    bool? tagsOpen,
    ArchiveTag? Function()? tag,
    String? Function()? customTag,
    List<ArchiveCustomTag>? customTags,
    ArchiveTagColor? draftColor,
  }) => ArchiveViewState(
    sort: sort ?? this.sort,
    searchOpen: searchOpen ?? this.searchOpen,
    query: query ?? this.query,
    tagsOpen: tagsOpen ?? this.tagsOpen,
    tag: tag == null ? this.tag : tag(),
    customTag: customTag == null ? this.customTag : customTag(),
    customTags: customTags ?? this.customTags,
    draftColor: draftColor ?? this.draftColor,
  );
}

/// Arşiv ekranı komutları (yerel durum; sunucuya yazmaz).
@Riverpod(keepAlive: true)
class ArchiveController extends _$ArchiveController {
  var _seq = 0;

  @override
  ArchiveViewState build() => const ArchiveViewState();

  /// Arama kutusunu açar/kapatır; kapanınca sorgu temizlenir.
  void toggleSearch() => state = state.copyWith(
    searchOpen: !state.searchOpen,
    query: state.searchOpen ? '' : state.query,
  );

  void setQuery(String q) => state = state.copyWith(query: q);

  /// Son yükleme → Ada göre → Boyuta göre → …
  void cycleSort() => state = state.copyWith(
    sort:
        ArchiveSort.values[(state.sort.index + 1) % ArchiveSort.values.length],
  );

  void toggleTags() => state = state.copyWith(tagsOpen: !state.tagsOpen);

  /// Hazır etiketi seçer; seçiliyse kaldırır.
  void pickTag(ArchiveTag t) => state = state.copyWith(
    tag: () => state.tag == t ? null : t,
    customTag: () => null,
  );

  /// Özel etiketi seçer; seçiliyse kaldırır.
  void pickCustomTag(String id) => state = state.copyWith(
    customTag: () => state.customTag == id ? null : id,
    tag: () => null,
  );

  void clearTag() =>
      state = state.copyWith(tag: () => null, customTag: () => null);

  void setDraftColor(ArchiveTagColor c) =>
      state = state.copyWith(draftColor: c);

  /// Yeni etiket ekler; boş adda null döner, yoksa eklenen etiketin adı.
  String? addTag(String name) {
    final n = name.trim();
    if (n.isEmpty) return null;
    state = state.copyWith(
      customTags: [
        ...state.customTags,
        ArchiveCustomTag(id: 'x${++_seq}', name: n, color: state.draftColor),
      ],
    );
    return n;
  }
}
