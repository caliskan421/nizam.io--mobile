// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransferHistory {

 List<TransferHistoryItem> get transfers;@JsonKey(name: 'next_cursor') String? get nextCursor;
/// Create a copy of TransferHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferHistoryCopyWith<TransferHistory> get copyWith => _$TransferHistoryCopyWithImpl<TransferHistory>(this as TransferHistory, _$identity);

  /// Serializes this TransferHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TransferHistory;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferHistory&&const DeepCollectionEquality().equals(other.transfers, _this.transfers)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TransferHistory;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.transfers),_this.nextCursor);
}

@override
String toString() {
  final _this = this as TransferHistory;
  return 'TransferHistory(transfers: ${_this.transfers}, nextCursor: ${_this.nextCursor})';
}


}

/// @nodoc
abstract mixin class $TransferHistoryCopyWith<$Res>  {
  factory $TransferHistoryCopyWith(TransferHistory value, $Res Function(TransferHistory) _then) = _$TransferHistoryCopyWithImpl;
@useResult
$Res call({
 List<TransferHistoryItem> transfers,@JsonKey(name: 'next_cursor') String? nextCursor
});




}
/// @nodoc
class _$TransferHistoryCopyWithImpl<$Res>
    implements $TransferHistoryCopyWith<$Res> {
  _$TransferHistoryCopyWithImpl(this._self, this._then);

  final TransferHistory _self;
  final $Res Function(TransferHistory) _then;

/// Create a copy of TransferHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transfers = null,Object? nextCursor = freezed,}) {
  return _then(TransferHistory(
transfers: null == transfers ? _self.transfers : transfers // ignore: cast_nullable_to_non_nullable
as List<TransferHistoryItem>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransferHistory].
extension TransferHistoryPatterns on TransferHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransferHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransferHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransferHistory value)  $default,){
final _that = this;
switch (_that) {
case _TransferHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransferHistory value)?  $default,){
final _that = this;
switch (_that) {
case _TransferHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TransferHistoryItem> transfers, @JsonKey(name: 'next_cursor')  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransferHistory() when $default != null:
return $default(_that.transfers,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TransferHistoryItem> transfers, @JsonKey(name: 'next_cursor')  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _TransferHistory():
return $default(_that.transfers,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TransferHistoryItem> transfers, @JsonKey(name: 'next_cursor')  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _TransferHistory() when $default != null:
return $default(_that.transfers,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransferHistory implements TransferHistory {
  const _TransferHistory({required  List<TransferHistoryItem> transfers, @JsonKey(name: 'next_cursor') this.nextCursor}): _transfers = transfers;
  factory _TransferHistory.fromJson(Map<String, dynamic> json) => _$TransferHistoryFromJson(json);

 final  List<TransferHistoryItem> _transfers;
@override List<TransferHistoryItem> get transfers {
  if (_transfers is EqualUnmodifiableListView) return _transfers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transfers);
}

@override@JsonKey(name: 'next_cursor') final  String? nextCursor;

/// Create a copy of TransferHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferHistoryCopyWith<_TransferHistory> get copyWith => __$TransferHistoryCopyWithImpl<_TransferHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransferHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransferHistory&&const DeepCollectionEquality().equals(other.transfers, _transfers)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_transfers),nextCursor);
}

@override
String toString() {
    return 'TransferHistory(transfers: $transfers, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$TransferHistoryCopyWith<$Res> implements $TransferHistoryCopyWith<$Res> {
  factory _$TransferHistoryCopyWith(_TransferHistory value, $Res Function(_TransferHistory) _then) = __$TransferHistoryCopyWithImpl;
@override @useResult
$Res call({
 List<TransferHistoryItem> transfers,@JsonKey(name: 'next_cursor') String? nextCursor
});




}
/// @nodoc
class __$TransferHistoryCopyWithImpl<$Res>
    implements _$TransferHistoryCopyWith<$Res> {
  __$TransferHistoryCopyWithImpl(this._self, this._then);

  final _TransferHistory _self;
  final $Res Function(_TransferHistory) _then;

/// Create a copy of TransferHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transfers = null,Object? nextCursor = freezed,}) {
  return _then(_TransferHistory(
transfers: null == transfers ? _self._transfers : transfers // ignore: cast_nullable_to_non_nullable
as List<TransferHistoryItem>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
