// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_comments_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Bir satırın yorumları (`GET …/comments?row_id=`; `seq` artan). Snapshot yorum taşımaz
/// (K-26): liste, tablo görünümünün [TableView.commentsRevision] sayacı artınca (canlı akışta
/// yorum olayı ya da kendi yorum komutumuz) yeniden okunur. Yazım [TableController]
/// üzerinden (`add_comment`/`edit_comment`/`delete_comment`).

@ProviderFor(TableCommentsController)
final tableCommentsControllerProvider = TableCommentsControllerFamily._();

/// Bir satırın yorumları (`GET …/comments?row_id=`; `seq` artan). Snapshot yorum taşımaz
/// (K-26): liste, tablo görünümünün [TableView.commentsRevision] sayacı artınca (canlı akışta
/// yorum olayı ya da kendi yorum komutumuz) yeniden okunur. Yazım [TableController]
/// üzerinden (`add_comment`/`edit_comment`/`delete_comment`).
final class TableCommentsControllerProvider
    extends $AsyncNotifierProvider<TableCommentsController, TableCommentsView> {
  /// Bir satırın yorumları (`GET …/comments?row_id=`; `seq` artan). Snapshot yorum taşımaz
  /// (K-26): liste, tablo görünümünün [TableView.commentsRevision] sayacı artınca (canlı akışta
  /// yorum olayı ya da kendi yorum komutumuz) yeniden okunur. Yazım [TableController]
  /// üzerinden (`add_comment`/`edit_comment`/`delete_comment`).
  TableCommentsControllerProvider._({
    required TableCommentsControllerFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'tableCommentsControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tableCommentsControllerHash();

  @override
  String toString() {
    return r'tableCommentsControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  TableCommentsController create() => TableCommentsController();

  @override
  bool operator ==(Object other) {
    return other is TableCommentsControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tableCommentsControllerHash() =>
    r'53f2931082e43155e9dd3757a7a3c1a134e99aa0';

/// Bir satırın yorumları (`GET …/comments?row_id=`; `seq` artan). Snapshot yorum taşımaz
/// (K-26): liste, tablo görünümünün [TableView.commentsRevision] sayacı artınca (canlı akışta
/// yorum olayı ya da kendi yorum komutumuz) yeniden okunur. Yazım [TableController]
/// üzerinden (`add_comment`/`edit_comment`/`delete_comment`).

final class TableCommentsControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          TableCommentsController,
          AsyncValue<TableCommentsView>,
          TableCommentsView,
          FutureOr<TableCommentsView>,
          (String, String)
        > {
  TableCommentsControllerFamily._()
    : super(
        retry: null,
        name: r'tableCommentsControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Bir satırın yorumları (`GET …/comments?row_id=`; `seq` artan). Snapshot yorum taşımaz
  /// (K-26): liste, tablo görünümünün [TableView.commentsRevision] sayacı artınca (canlı akışta
  /// yorum olayı ya da kendi yorum komutumuz) yeniden okunur. Yazım [TableController]
  /// üzerinden (`add_comment`/`edit_comment`/`delete_comment`).

  TableCommentsControllerProvider call(String tableId, String rowId) =>
      TableCommentsControllerProvider._(argument: (tableId, rowId), from: this);

  @override
  String toString() => r'tableCommentsControllerProvider';
}

/// Bir satırın yorumları (`GET …/comments?row_id=`; `seq` artan). Snapshot yorum taşımaz
/// (K-26): liste, tablo görünümünün [TableView.commentsRevision] sayacı artınca (canlı akışta
/// yorum olayı ya da kendi yorum komutumuz) yeniden okunur. Yazım [TableController]
/// üzerinden (`add_comment`/`edit_comment`/`delete_comment`).

abstract class _$TableCommentsController
    extends $AsyncNotifier<TableCommentsView> {
  late final _$args = ref.$arg as (String, String);
  String get tableId => _$args.$1;
  String get rowId => _$args.$2;

  FutureOr<TableCommentsView> build(String tableId, String rowId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<TableCommentsView>, TableCommentsView>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TableCommentsView>, TableCommentsView>,
              AsyncValue<TableCommentsView>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
