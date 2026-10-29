// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'date_change_request_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DateChangeRequestList {

 List<DateChangeRequest> get requests; int get total;
/// Create a copy of DateChangeRequestList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DateChangeRequestListCopyWith<DateChangeRequestList> get copyWith => _$DateChangeRequestListCopyWithImpl<DateChangeRequestList>(this as DateChangeRequestList, _$identity);

  /// Serializes this DateChangeRequestList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DateChangeRequestList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DateChangeRequestList&&const DeepCollectionEquality().equals(other.requests, _this.requests)&&(identical(other.total, _this.total) || other.total == _this.total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DateChangeRequestList;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.requests),_this.total);
}

@override
String toString() {
  final _this = this as DateChangeRequestList;
  return 'DateChangeRequestList(requests: ${_this.requests}, total: ${_this.total})';
}


}

/// @nodoc
abstract mixin class $DateChangeRequestListCopyWith<$Res>  {
  factory $DateChangeRequestListCopyWith(DateChangeRequestList value, $Res Function(DateChangeRequestList) _then) = _$DateChangeRequestListCopyWithImpl;
@useResult
$Res call({
 List<DateChangeRequest> requests, int total
});




}
/// @nodoc
class _$DateChangeRequestListCopyWithImpl<$Res>
    implements $DateChangeRequestListCopyWith<$Res> {
  _$DateChangeRequestListCopyWithImpl(this._self, this._then);

  final DateChangeRequestList _self;
  final $Res Function(DateChangeRequestList) _then;

/// Create a copy of DateChangeRequestList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requests = null,Object? total = null,}) {
  return _then(DateChangeRequestList(
requests: null == requests ? _self.requests : requests // ignore: cast_nullable_to_non_nullable
as List<DateChangeRequest>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DateChangeRequestList].
extension DateChangeRequestListPatterns on DateChangeRequestList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DateChangeRequestList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DateChangeRequestList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DateChangeRequestList value)  $default,){
final _that = this;
switch (_that) {
case _DateChangeRequestList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DateChangeRequestList value)?  $default,){
final _that = this;
switch (_that) {
case _DateChangeRequestList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DateChangeRequest> requests,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DateChangeRequestList() when $default != null:
return $default(_that.requests,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DateChangeRequest> requests,  int total)  $default,) {final _that = this;
switch (_that) {
case _DateChangeRequestList():
return $default(_that.requests,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DateChangeRequest> requests,  int total)?  $default,) {final _that = this;
switch (_that) {
case _DateChangeRequestList() when $default != null:
return $default(_that.requests,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DateChangeRequestList implements DateChangeRequestList {
  const _DateChangeRequestList({required  List<DateChangeRequest> requests, required this.total}): _requests = requests;
  factory _DateChangeRequestList.fromJson(Map<String, dynamic> json) => _$DateChangeRequestListFromJson(json);

 final  List<DateChangeRequest> _requests;
@override List<DateChangeRequest> get requests {
  if (_requests is EqualUnmodifiableListView) return _requests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_requests);
}

@override final  int total;

/// Create a copy of DateChangeRequestList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DateChangeRequestListCopyWith<_DateChangeRequestList> get copyWith => __$DateChangeRequestListCopyWithImpl<_DateChangeRequestList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DateChangeRequestListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DateChangeRequestList&&const DeepCollectionEquality().equals(other.requests, _requests)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_requests),total);
}

@override
String toString() {
    return 'DateChangeRequestList(requests: $requests, total: $total)';
}


}

/// @nodoc
abstract mixin class _$DateChangeRequestListCopyWith<$Res> implements $DateChangeRequestListCopyWith<$Res> {
  factory _$DateChangeRequestListCopyWith(_DateChangeRequestList value, $Res Function(_DateChangeRequestList) _then) = __$DateChangeRequestListCopyWithImpl;
@override @useResult
$Res call({
 List<DateChangeRequest> requests, int total
});




}
/// @nodoc
class __$DateChangeRequestListCopyWithImpl<$Res>
    implements _$DateChangeRequestListCopyWith<$Res> {
  __$DateChangeRequestListCopyWithImpl(this._self, this._then);

  final _DateChangeRequestList _self;
  final $Res Function(_DateChangeRequestList) _then;

/// Create a copy of DateChangeRequestList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requests = null,Object? total = null,}) {
  return _then(_DateChangeRequestList(
requests: null == requests ? _self._requests : requests // ignore: cast_nullable_to_non_nullable
as List<DateChangeRequest>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
