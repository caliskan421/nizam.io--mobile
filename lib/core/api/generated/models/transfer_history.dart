// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'transfer_history_item.dart';

part 'transfer_history.freezed.dart';
part 'transfer_history.g.dart';

@Freezed()
abstract class TransferHistory with _$TransferHistory {
  const factory TransferHistory({
    required List<TransferHistoryItem> transfers,
    @JsonKey(name: 'next_cursor') String? nextCursor,
  }) = _TransferHistory;

  factory TransferHistory.fromJson(Map<String, Object?> json) =>
      _$TransferHistoryFromJson(json);
}
