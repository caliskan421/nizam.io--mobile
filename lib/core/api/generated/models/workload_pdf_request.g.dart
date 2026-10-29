// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workload_pdf_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkloadPdfRequest _$WorkloadPdfRequestFromJson(Map<String, dynamic> json) =>
    _WorkloadPdfRequest(
      memberIds: (json['member_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$WorkloadPdfRequestToJson(_WorkloadPdfRequest instance) =>
    <String, dynamic>{'member_ids': ?instance.memberIds};
