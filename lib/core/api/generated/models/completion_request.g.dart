// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completion_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CompletionRequest _$CompletionRequestFromJson(Map<String, dynamic> json) =>
    _CompletionRequest(
      completedOn: const DateOnlyConverter().fromJson(
        json['completed_on'] as String,
      ),
    );

Map<String, dynamic> _$CompletionRequestToJson(_CompletionRequest instance) =>
    <String, dynamic>{
      'completed_on': const DateOnlyConverter().toJson(instance.completedOn),
    };
