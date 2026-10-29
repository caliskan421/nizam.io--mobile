// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransferHistory _$TransferHistoryFromJson(Map<String, dynamic> json) =>
    _TransferHistory(
      transfers: (json['transfers'] as List<dynamic>)
          .map((e) => TransferHistoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['next_cursor'] as String?,
    );

Map<String, dynamic> _$TransferHistoryToJson(_TransferHistory instance) =>
    <String, dynamic>{
      'transfers': instance.transfers.map((e) => e.toJson()).toList(),
      'next_cursor': ?instance.nextCursor,
    };
