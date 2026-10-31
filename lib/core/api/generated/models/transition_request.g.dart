// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transition_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransitionRequest _$TransitionRequestFromJson(Map<String, dynamic> json) =>
    _TransitionRequest(
      to: TransitionRequestTo.fromJson(json['to'] as String),
      reason: json['reason'] as String?,
      pullEndDate: json['pull_end_date'] as bool?,
      closeSubtasks: json['close_subtasks'] as bool?,
    );

Map<String, dynamic> _$TransitionRequestToJson(_TransitionRequest instance) =>
    <String, dynamic>{
      'to': _$TransitionRequestToEnumMap[instance.to]!,
      'reason': ?instance.reason,
      'pull_end_date': ?instance.pullEndDate,
      'close_subtasks': ?instance.closeSubtasks,
    };

const _$TransitionRequestToEnumMap = {
  TransitionRequestTo.baslanmadi: 'baslanmadi',
  TransitionRequestTo.devamEdiyor: 'devam_ediyor',
  TransitionRequestTo.onayaSunuldu: 'onaya_sunuldu',
  TransitionRequestTo.iadeEdildi: 'iade_edildi',
  TransitionRequestTo.tamamlandi: 'tamamlandi',
  TransitionRequestTo.$unknown: r'$unknown',
};
