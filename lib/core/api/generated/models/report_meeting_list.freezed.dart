// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_meeting_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportMeetingList {

 List<ReportMeeting> get meetings;
/// Create a copy of ReportMeetingList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportMeetingListCopyWith<ReportMeetingList> get copyWith => _$ReportMeetingListCopyWithImpl<ReportMeetingList>(this as ReportMeetingList, _$identity);

  /// Serializes this ReportMeetingList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReportMeetingList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportMeetingList&&const DeepCollectionEquality().equals(other.meetings, _this.meetings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReportMeetingList;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.meetings));
}

@override
String toString() {
  final _this = this as ReportMeetingList;
  return 'ReportMeetingList(meetings: ${_this.meetings})';
}


}

/// @nodoc
abstract mixin class $ReportMeetingListCopyWith<$Res>  {
  factory $ReportMeetingListCopyWith(ReportMeetingList value, $Res Function(ReportMeetingList) _then) = _$ReportMeetingListCopyWithImpl;
@useResult
$Res call({
 List<ReportMeeting> meetings
});




}
/// @nodoc
class _$ReportMeetingListCopyWithImpl<$Res>
    implements $ReportMeetingListCopyWith<$Res> {
  _$ReportMeetingListCopyWithImpl(this._self, this._then);

  final ReportMeetingList _self;
  final $Res Function(ReportMeetingList) _then;

/// Create a copy of ReportMeetingList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? meetings = null,}) {
  return _then(ReportMeetingList(
meetings: null == meetings ? _self.meetings : meetings // ignore: cast_nullable_to_non_nullable
as List<ReportMeeting>,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportMeetingList].
extension ReportMeetingListPatterns on ReportMeetingList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportMeetingList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportMeetingList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportMeetingList value)  $default,){
final _that = this;
switch (_that) {
case _ReportMeetingList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportMeetingList value)?  $default,){
final _that = this;
switch (_that) {
case _ReportMeetingList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ReportMeeting> meetings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportMeetingList() when $default != null:
return $default(_that.meetings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ReportMeeting> meetings)  $default,) {final _that = this;
switch (_that) {
case _ReportMeetingList():
return $default(_that.meetings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ReportMeeting> meetings)?  $default,) {final _that = this;
switch (_that) {
case _ReportMeetingList() when $default != null:
return $default(_that.meetings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportMeetingList implements ReportMeetingList {
  const _ReportMeetingList({required  List<ReportMeeting> meetings}): _meetings = meetings;
  factory _ReportMeetingList.fromJson(Map<String, dynamic> json) => _$ReportMeetingListFromJson(json);

 final  List<ReportMeeting> _meetings;
@override List<ReportMeeting> get meetings {
  if (_meetings is EqualUnmodifiableListView) return _meetings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_meetings);
}


/// Create a copy of ReportMeetingList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportMeetingListCopyWith<_ReportMeetingList> get copyWith => __$ReportMeetingListCopyWithImpl<_ReportMeetingList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportMeetingListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportMeetingList&&const DeepCollectionEquality().equals(other.meetings, _meetings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_meetings));
}

@override
String toString() {
    return 'ReportMeetingList(meetings: $meetings)';
}


}

/// @nodoc
abstract mixin class _$ReportMeetingListCopyWith<$Res> implements $ReportMeetingListCopyWith<$Res> {
  factory _$ReportMeetingListCopyWith(_ReportMeetingList value, $Res Function(_ReportMeetingList) _then) = __$ReportMeetingListCopyWithImpl;
@override @useResult
$Res call({
 List<ReportMeeting> meetings
});




}
/// @nodoc
class __$ReportMeetingListCopyWithImpl<$Res>
    implements _$ReportMeetingListCopyWith<$Res> {
  __$ReportMeetingListCopyWithImpl(this._self, this._then);

  final _ReportMeetingList _self;
  final $Res Function(_ReportMeetingList) _then;

/// Create a copy of ReportMeetingList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meetings = null,}) {
  return _then(_ReportMeetingList(
meetings: null == meetings ? _self._meetings : meetings // ignore: cast_nullable_to_non_nullable
as List<ReportMeeting>,
  ));
}


}

// dart format on
