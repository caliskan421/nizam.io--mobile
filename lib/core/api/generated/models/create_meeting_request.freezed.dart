// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_meeting_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateMeetingRequest {

 String get title;/// Tarih-saat; saat dilimi yoksa kurulum saat diliminde yorumlanır. Kurulum saat dilimindeki bugünden önceki bir gün olamaz (422 `collaboration.input_invalid`).
@JsonKey(name: 'meeting_date') String get meetingDate;/// En az bir departman; ilki sahip departmandır. Hepsi seçili programa katılmış olmalıdır.
@JsonKey(name: 'department_ids') List<String> get departmentIds;@JsonKey(name: 'participant_ids') List<String>? get participantIds;@JsonKey(name: 'members_included') bool? get membersIncluded;@JsonKey(name: 'agenda_items') List<String>? get agendaItems;/// `true` ise koordinatörlere toplantı mesajı gönderilmez.
@JsonKey(name: 'is_instant') bool? get isInstant;
/// Create a copy of CreateMeetingRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateMeetingRequestCopyWith<CreateMeetingRequest> get copyWith => _$CreateMeetingRequestCopyWithImpl<CreateMeetingRequest>(this as CreateMeetingRequest, _$identity);

  /// Serializes this CreateMeetingRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CreateMeetingRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateMeetingRequest&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.meetingDate, _this.meetingDate) || other.meetingDate == _this.meetingDate)&&const DeepCollectionEquality().equals(other.departmentIds, _this.departmentIds)&&const DeepCollectionEquality().equals(other.participantIds, _this.participantIds)&&(identical(other.membersIncluded, _this.membersIncluded) || other.membersIncluded == _this.membersIncluded)&&const DeepCollectionEquality().equals(other.agendaItems, _this.agendaItems)&&(identical(other.isInstant, _this.isInstant) || other.isInstant == _this.isInstant));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CreateMeetingRequest;
  return Object.hash(runtimeType,_this.title,_this.meetingDate,const DeepCollectionEquality().hash(_this.departmentIds),const DeepCollectionEquality().hash(_this.participantIds),_this.membersIncluded,const DeepCollectionEquality().hash(_this.agendaItems),_this.isInstant);
}

@override
String toString() {
  final _this = this as CreateMeetingRequest;
  return 'CreateMeetingRequest(title: ${_this.title}, meetingDate: ${_this.meetingDate}, departmentIds: ${_this.departmentIds}, participantIds: ${_this.participantIds}, membersIncluded: ${_this.membersIncluded}, agendaItems: ${_this.agendaItems}, isInstant: ${_this.isInstant})';
}


}

/// @nodoc
abstract mixin class $CreateMeetingRequestCopyWith<$Res>  {
  factory $CreateMeetingRequestCopyWith(CreateMeetingRequest value, $Res Function(CreateMeetingRequest) _then) = _$CreateMeetingRequestCopyWithImpl;
@useResult
$Res call({
 String title,@JsonKey(name: 'meeting_date') String meetingDate,@JsonKey(name: 'department_ids') List<String> departmentIds,@JsonKey(name: 'participant_ids') List<String>? participantIds,@JsonKey(name: 'members_included') bool? membersIncluded,@JsonKey(name: 'agenda_items') List<String>? agendaItems,@JsonKey(name: 'is_instant') bool? isInstant
});




}
/// @nodoc
class _$CreateMeetingRequestCopyWithImpl<$Res>
    implements $CreateMeetingRequestCopyWith<$Res> {
  _$CreateMeetingRequestCopyWithImpl(this._self, this._then);

  final CreateMeetingRequest _self;
  final $Res Function(CreateMeetingRequest) _then;

/// Create a copy of CreateMeetingRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? meetingDate = null,Object? departmentIds = null,Object? participantIds = freezed,Object? membersIncluded = freezed,Object? agendaItems = freezed,Object? isInstant = freezed,}) {
  return _then(CreateMeetingRequest(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,meetingDate: null == meetingDate ? _self.meetingDate : meetingDate // ignore: cast_nullable_to_non_nullable
as String,departmentIds: null == departmentIds ? _self.departmentIds : departmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,participantIds: freezed == participantIds ? _self.participantIds : participantIds // ignore: cast_nullable_to_non_nullable
as List<String>?,membersIncluded: freezed == membersIncluded ? _self.membersIncluded : membersIncluded // ignore: cast_nullable_to_non_nullable
as bool?,agendaItems: freezed == agendaItems ? _self.agendaItems : agendaItems // ignore: cast_nullable_to_non_nullable
as List<String>?,isInstant: freezed == isInstant ? _self.isInstant : isInstant // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateMeetingRequest].
extension CreateMeetingRequestPatterns on CreateMeetingRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateMeetingRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateMeetingRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateMeetingRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateMeetingRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateMeetingRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateMeetingRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title, @JsonKey(name: 'meeting_date')  String meetingDate, @JsonKey(name: 'department_ids')  List<String> departmentIds, @JsonKey(name: 'participant_ids')  List<String>? participantIds, @JsonKey(name: 'members_included')  bool? membersIncluded, @JsonKey(name: 'agenda_items')  List<String>? agendaItems, @JsonKey(name: 'is_instant')  bool? isInstant)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateMeetingRequest() when $default != null:
return $default(_that.title,_that.meetingDate,_that.departmentIds,_that.participantIds,_that.membersIncluded,_that.agendaItems,_that.isInstant);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title, @JsonKey(name: 'meeting_date')  String meetingDate, @JsonKey(name: 'department_ids')  List<String> departmentIds, @JsonKey(name: 'participant_ids')  List<String>? participantIds, @JsonKey(name: 'members_included')  bool? membersIncluded, @JsonKey(name: 'agenda_items')  List<String>? agendaItems, @JsonKey(name: 'is_instant')  bool? isInstant)  $default,) {final _that = this;
switch (_that) {
case _CreateMeetingRequest():
return $default(_that.title,_that.meetingDate,_that.departmentIds,_that.participantIds,_that.membersIncluded,_that.agendaItems,_that.isInstant);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title, @JsonKey(name: 'meeting_date')  String meetingDate, @JsonKey(name: 'department_ids')  List<String> departmentIds, @JsonKey(name: 'participant_ids')  List<String>? participantIds, @JsonKey(name: 'members_included')  bool? membersIncluded, @JsonKey(name: 'agenda_items')  List<String>? agendaItems, @JsonKey(name: 'is_instant')  bool? isInstant)?  $default,) {final _that = this;
switch (_that) {
case _CreateMeetingRequest() when $default != null:
return $default(_that.title,_that.meetingDate,_that.departmentIds,_that.participantIds,_that.membersIncluded,_that.agendaItems,_that.isInstant);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateMeetingRequest implements CreateMeetingRequest {
  const _CreateMeetingRequest({required this.title, @JsonKey(name: 'meeting_date') required this.meetingDate, @JsonKey(name: 'department_ids') required  List<String> departmentIds, @JsonKey(name: 'participant_ids')  List<String>? participantIds, @JsonKey(name: 'members_included') this.membersIncluded, @JsonKey(name: 'agenda_items')  List<String>? agendaItems, @JsonKey(name: 'is_instant') this.isInstant}): _departmentIds = departmentIds,_participantIds = participantIds,_agendaItems = agendaItems;
  factory _CreateMeetingRequest.fromJson(Map<String, dynamic> json) => _$CreateMeetingRequestFromJson(json);

@override final  String title;
/// Tarih-saat; saat dilimi yoksa kurulum saat diliminde yorumlanır. Kurulum saat dilimindeki bugünden önceki bir gün olamaz (422 `collaboration.input_invalid`).
@override@JsonKey(name: 'meeting_date') final  String meetingDate;
/// En az bir departman; ilki sahip departmandır. Hepsi seçili programa katılmış olmalıdır.
 final  List<String> _departmentIds;
/// En az bir departman; ilki sahip departmandır. Hepsi seçili programa katılmış olmalıdır.
@override@JsonKey(name: 'department_ids') List<String> get departmentIds {
  if (_departmentIds is EqualUnmodifiableListView) return _departmentIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_departmentIds);
}

 final  List<String>? _participantIds;
@override@JsonKey(name: 'participant_ids') List<String>? get participantIds {
  final value = _participantIds;
  if (value == null) return null;
  if (_participantIds is EqualUnmodifiableListView) return _participantIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'members_included') final  bool? membersIncluded;
 final  List<String>? _agendaItems;
@override@JsonKey(name: 'agenda_items') List<String>? get agendaItems {
  final value = _agendaItems;
  if (value == null) return null;
  if (_agendaItems is EqualUnmodifiableListView) return _agendaItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// `true` ise koordinatörlere toplantı mesajı gönderilmez.
@override@JsonKey(name: 'is_instant') final  bool? isInstant;

/// Create a copy of CreateMeetingRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateMeetingRequestCopyWith<_CreateMeetingRequest> get copyWith => __$CreateMeetingRequestCopyWithImpl<_CreateMeetingRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateMeetingRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateMeetingRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.meetingDate, meetingDate) || other.meetingDate == meetingDate)&&const DeepCollectionEquality().equals(other.departmentIds, _departmentIds)&&const DeepCollectionEquality().equals(other.participantIds, _participantIds)&&(identical(other.membersIncluded, membersIncluded) || other.membersIncluded == membersIncluded)&&const DeepCollectionEquality().equals(other.agendaItems, _agendaItems)&&(identical(other.isInstant, isInstant) || other.isInstant == isInstant));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,title,meetingDate,const DeepCollectionEquality().hash(_departmentIds),const DeepCollectionEquality().hash(_participantIds),membersIncluded,const DeepCollectionEquality().hash(_agendaItems),isInstant);
}

@override
String toString() {
    return 'CreateMeetingRequest(title: $title, meetingDate: $meetingDate, departmentIds: $departmentIds, participantIds: $participantIds, membersIncluded: $membersIncluded, agendaItems: $agendaItems, isInstant: $isInstant)';
}


}

/// @nodoc
abstract mixin class _$CreateMeetingRequestCopyWith<$Res> implements $CreateMeetingRequestCopyWith<$Res> {
  factory _$CreateMeetingRequestCopyWith(_CreateMeetingRequest value, $Res Function(_CreateMeetingRequest) _then) = __$CreateMeetingRequestCopyWithImpl;
@override @useResult
$Res call({
 String title,@JsonKey(name: 'meeting_date') String meetingDate,@JsonKey(name: 'department_ids') List<String> departmentIds,@JsonKey(name: 'participant_ids') List<String>? participantIds,@JsonKey(name: 'members_included') bool? membersIncluded,@JsonKey(name: 'agenda_items') List<String>? agendaItems,@JsonKey(name: 'is_instant') bool? isInstant
});




}
/// @nodoc
class __$CreateMeetingRequestCopyWithImpl<$Res>
    implements _$CreateMeetingRequestCopyWith<$Res> {
  __$CreateMeetingRequestCopyWithImpl(this._self, this._then);

  final _CreateMeetingRequest _self;
  final $Res Function(_CreateMeetingRequest) _then;

/// Create a copy of CreateMeetingRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? meetingDate = null,Object? departmentIds = null,Object? participantIds = freezed,Object? membersIncluded = freezed,Object? agendaItems = freezed,Object? isInstant = freezed,}) {
  return _then(_CreateMeetingRequest(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,meetingDate: null == meetingDate ? _self.meetingDate : meetingDate // ignore: cast_nullable_to_non_nullable
as String,departmentIds: null == departmentIds ? _self._departmentIds : departmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,participantIds: freezed == participantIds ? _self._participantIds : participantIds // ignore: cast_nullable_to_non_nullable
as List<String>?,membersIncluded: freezed == membersIncluded ? _self.membersIncluded : membersIncluded // ignore: cast_nullable_to_non_nullable
as bool?,agendaItems: freezed == agendaItems ? _self._agendaItems : agendaItems // ignore: cast_nullable_to_non_nullable
as List<String>?,isInstant: freezed == isInstant ? _self.isInstant : isInstant // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
