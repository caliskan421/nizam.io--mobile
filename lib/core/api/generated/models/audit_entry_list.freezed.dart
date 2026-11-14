// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_entry_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuditEntryList {

 List<AuditEntry> get entries;@JsonKey(name: 'next_cursor') String? get nextCursor;
/// Create a copy of AuditEntryList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditEntryListCopyWith<AuditEntryList> get copyWith => _$AuditEntryListCopyWithImpl<AuditEntryList>(this as AuditEntryList, _$identity);

  /// Serializes this AuditEntryList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AuditEntryList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditEntryList&&const DeepCollectionEquality().equals(other.entries, _this.entries)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AuditEntryList;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.entries),_this.nextCursor);
}

@override
String toString() {
  final _this = this as AuditEntryList;
  return 'AuditEntryList(entries: ${_this.entries}, nextCursor: ${_this.nextCursor})';
}


}

/// @nodoc
abstract mixin class $AuditEntryListCopyWith<$Res>  {
  factory $AuditEntryListCopyWith(AuditEntryList value, $Res Function(AuditEntryList) _then) = _$AuditEntryListCopyWithImpl;
@useResult
$Res call({
 List<AuditEntry> entries,@JsonKey(name: 'next_cursor') String? nextCursor
});




}
/// @nodoc
class _$AuditEntryListCopyWithImpl<$Res>
    implements $AuditEntryListCopyWith<$Res> {
  _$AuditEntryListCopyWithImpl(this._self, this._then);

  final AuditEntryList _self;
  final $Res Function(AuditEntryList) _then;

/// Create a copy of AuditEntryList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entries = null,Object? nextCursor = freezed,}) {
  return _then(AuditEntryList(
entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<AuditEntry>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditEntryList].
extension AuditEntryListPatterns on AuditEntryList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditEntryList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditEntryList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditEntryList value)  $default,){
final _that = this;
switch (_that) {
case _AuditEntryList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditEntryList value)?  $default,){
final _that = this;
switch (_that) {
case _AuditEntryList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AuditEntry> entries, @JsonKey(name: 'next_cursor')  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditEntryList() when $default != null:
return $default(_that.entries,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AuditEntry> entries, @JsonKey(name: 'next_cursor')  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _AuditEntryList():
return $default(_that.entries,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AuditEntry> entries, @JsonKey(name: 'next_cursor')  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _AuditEntryList() when $default != null:
return $default(_that.entries,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuditEntryList implements AuditEntryList {
  const _AuditEntryList({required  List<AuditEntry> entries, @JsonKey(name: 'next_cursor') required this.nextCursor}): _entries = entries;
  factory _AuditEntryList.fromJson(Map<String, dynamic> json) => _$AuditEntryListFromJson(json);

 final  List<AuditEntry> _entries;
@override List<AuditEntry> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}

@override@JsonKey(name: 'next_cursor') final  String? nextCursor;

/// Create a copy of AuditEntryList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditEntryListCopyWith<_AuditEntryList> get copyWith => __$AuditEntryListCopyWithImpl<_AuditEntryList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuditEntryListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditEntryList&&const DeepCollectionEquality().equals(other.entries, _entries)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_entries),nextCursor);
}

@override
String toString() {
    return 'AuditEntryList(entries: $entries, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$AuditEntryListCopyWith<$Res> implements $AuditEntryListCopyWith<$Res> {
  factory _$AuditEntryListCopyWith(_AuditEntryList value, $Res Function(_AuditEntryList) _then) = __$AuditEntryListCopyWithImpl;
@override @useResult
$Res call({
 List<AuditEntry> entries,@JsonKey(name: 'next_cursor') String? nextCursor
});




}
/// @nodoc
class __$AuditEntryListCopyWithImpl<$Res>
    implements _$AuditEntryListCopyWith<$Res> {
  __$AuditEntryListCopyWithImpl(this._self, this._then);

  final _AuditEntryList _self;
  final $Res Function(_AuditEntryList) _then;

/// Create a copy of AuditEntryList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entries = null,Object? nextCursor = freezed,}) {
  return _then(_AuditEntryList(
entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<AuditEntry>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
