// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_change.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableChange {

@JsonKey(name: 'table_id') String get tableId;/// Olayın tablo işlem sırası; tablo içinde artan ve boşluksuz.
 int get seq; TableChangeKind get kind;
/// Create a copy of TableChange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableChangeCopyWith<TableChange> get copyWith => _$TableChangeCopyWithImpl<TableChange>(this as TableChange, _$identity);

  /// Serializes this TableChange to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableChange;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableChange&&(identical(other.tableId, _this.tableId) || other.tableId == _this.tableId)&&(identical(other.seq, _this.seq) || other.seq == _this.seq)&&(identical(other.kind, _this.kind) || other.kind == _this.kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableChange;
  return Object.hash(runtimeType,_this.tableId,_this.seq,_this.kind);
}

@override
String toString() {
  final _this = this as TableChange;
  return 'TableChange(tableId: ${_this.tableId}, seq: ${_this.seq}, kind: ${_this.kind})';
}


}

/// @nodoc
abstract mixin class $TableChangeCopyWith<$Res>  {
  factory $TableChangeCopyWith(TableChange value, $Res Function(TableChange) _then) = _$TableChangeCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'table_id') String tableId, int seq, TableChangeKind kind
});




}
/// @nodoc
class _$TableChangeCopyWithImpl<$Res>
    implements $TableChangeCopyWith<$Res> {
  _$TableChangeCopyWithImpl(this._self, this._then);

  final TableChange _self;
  final $Res Function(TableChange) _then;

/// Create a copy of TableChange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tableId = null,Object? seq = null,Object? kind = null,}) {
  return _then(TableChange(
tableId: null == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String,seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableChangeKind,
  ));
}

}


/// Adds pattern-matching-related methods to [TableChange].
extension TableChangePatterns on TableChange {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableChange value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableChange() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableChange value)  $default,){
final _that = this;
switch (_that) {
case _TableChange():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableChange value)?  $default,){
final _that = this;
switch (_that) {
case _TableChange() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'table_id')  String tableId,  int seq,  TableChangeKind kind)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableChange() when $default != null:
return $default(_that.tableId,_that.seq,_that.kind);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'table_id')  String tableId,  int seq,  TableChangeKind kind)  $default,) {final _that = this;
switch (_that) {
case _TableChange():
return $default(_that.tableId,_that.seq,_that.kind);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'table_id')  String tableId,  int seq,  TableChangeKind kind)?  $default,) {final _that = this;
switch (_that) {
case _TableChange() when $default != null:
return $default(_that.tableId,_that.seq,_that.kind);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableChange implements TableChange {
  const _TableChange({@JsonKey(name: 'table_id') required this.tableId, required this.seq, required this.kind});
  factory _TableChange.fromJson(Map<String, dynamic> json) => _$TableChangeFromJson(json);

@override@JsonKey(name: 'table_id') final  String tableId;
/// Olayın tablo işlem sırası; tablo içinde artan ve boşluksuz.
@override final  int seq;
@override final  TableChangeKind kind;

/// Create a copy of TableChange
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableChangeCopyWith<_TableChange> get copyWith => __$TableChangeCopyWithImpl<_TableChange>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableChangeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableChange&&(identical(other.tableId, tableId) || other.tableId == tableId)&&(identical(other.seq, seq) || other.seq == seq)&&(identical(other.kind, kind) || other.kind == kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,tableId,seq,kind);
}

@override
String toString() {
    return 'TableChange(tableId: $tableId, seq: $seq, kind: $kind)';
}


}

/// @nodoc
abstract mixin class _$TableChangeCopyWith<$Res> implements $TableChangeCopyWith<$Res> {
  factory _$TableChangeCopyWith(_TableChange value, $Res Function(_TableChange) _then) = __$TableChangeCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'table_id') String tableId, int seq, TableChangeKind kind
});




}
/// @nodoc
class __$TableChangeCopyWithImpl<$Res>
    implements _$TableChangeCopyWith<$Res> {
  __$TableChangeCopyWithImpl(this._self, this._then);

  final _TableChange _self;
  final $Res Function(_TableChange) _then;

/// Create a copy of TableChange
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tableId = null,Object? seq = null,Object? kind = null,}) {
  return _then(_TableChange(
tableId: null == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String,seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableChangeKind,
  ));
}


}

// dart format on
