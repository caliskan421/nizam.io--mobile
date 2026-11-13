// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_changes.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableChanges {

@JsonKey(name: 'table_id') String get tableId; List<TableChange> get changes;/// Son döndürülen olayın sırası; olay yoksa istekteki `after`. Sonraki istekte `after` olarak verilir.
 int get cursor;/// Okuma anındaki tablo işlem sırası (`Table.sequence` ile aynı anlam).
 int get sequence;/// `cursor < sequence`: aynı imleçle sonraki sayfa vardır.
 bool get more;
/// Create a copy of TableChanges
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableChangesCopyWith<TableChanges> get copyWith => _$TableChangesCopyWithImpl<TableChanges>(this as TableChanges, _$identity);

  /// Serializes this TableChanges to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableChanges;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableChanges&&(identical(other.tableId, _this.tableId) || other.tableId == _this.tableId)&&const DeepCollectionEquality().equals(other.changes, _this.changes)&&(identical(other.cursor, _this.cursor) || other.cursor == _this.cursor)&&(identical(other.sequence, _this.sequence) || other.sequence == _this.sequence)&&(identical(other.more, _this.more) || other.more == _this.more));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableChanges;
  return Object.hash(runtimeType,_this.tableId,const DeepCollectionEquality().hash(_this.changes),_this.cursor,_this.sequence,_this.more);
}

@override
String toString() {
  final _this = this as TableChanges;
  return 'TableChanges(tableId: ${_this.tableId}, changes: ${_this.changes}, cursor: ${_this.cursor}, sequence: ${_this.sequence}, more: ${_this.more})';
}


}

/// @nodoc
abstract mixin class $TableChangesCopyWith<$Res>  {
  factory $TableChangesCopyWith(TableChanges value, $Res Function(TableChanges) _then) = _$TableChangesCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'table_id') String tableId, List<TableChange> changes, int cursor, int sequence, bool more
});




}
/// @nodoc
class _$TableChangesCopyWithImpl<$Res>
    implements $TableChangesCopyWith<$Res> {
  _$TableChangesCopyWithImpl(this._self, this._then);

  final TableChanges _self;
  final $Res Function(TableChanges) _then;

/// Create a copy of TableChanges
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tableId = null,Object? changes = null,Object? cursor = null,Object? sequence = null,Object? more = null,}) {
  return _then(TableChanges(
tableId: null == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String,changes: null == changes ? _self.changes : changes // ignore: cast_nullable_to_non_nullable
as List<TableChange>,cursor: null == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as int,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,more: null == more ? _self.more : more // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TableChanges].
extension TableChangesPatterns on TableChanges {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableChanges value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableChanges() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableChanges value)  $default,){
final _that = this;
switch (_that) {
case _TableChanges():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableChanges value)?  $default,){
final _that = this;
switch (_that) {
case _TableChanges() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'table_id')  String tableId,  List<TableChange> changes,  int cursor,  int sequence,  bool more)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableChanges() when $default != null:
return $default(_that.tableId,_that.changes,_that.cursor,_that.sequence,_that.more);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'table_id')  String tableId,  List<TableChange> changes,  int cursor,  int sequence,  bool more)  $default,) {final _that = this;
switch (_that) {
case _TableChanges():
return $default(_that.tableId,_that.changes,_that.cursor,_that.sequence,_that.more);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'table_id')  String tableId,  List<TableChange> changes,  int cursor,  int sequence,  bool more)?  $default,) {final _that = this;
switch (_that) {
case _TableChanges() when $default != null:
return $default(_that.tableId,_that.changes,_that.cursor,_that.sequence,_that.more);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableChanges implements TableChanges {
  const _TableChanges({@JsonKey(name: 'table_id') required this.tableId, required  List<TableChange> changes, required this.cursor, required this.sequence, required this.more}): _changes = changes;
  factory _TableChanges.fromJson(Map<String, dynamic> json) => _$TableChangesFromJson(json);

@override@JsonKey(name: 'table_id') final  String tableId;
 final  List<TableChange> _changes;
@override List<TableChange> get changes {
  if (_changes is EqualUnmodifiableListView) return _changes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_changes);
}

/// Son döndürülen olayın sırası; olay yoksa istekteki `after`. Sonraki istekte `after` olarak verilir.
@override final  int cursor;
/// Okuma anındaki tablo işlem sırası (`Table.sequence` ile aynı anlam).
@override final  int sequence;
/// `cursor < sequence`: aynı imleçle sonraki sayfa vardır.
@override final  bool more;

/// Create a copy of TableChanges
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableChangesCopyWith<_TableChanges> get copyWith => __$TableChangesCopyWithImpl<_TableChanges>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableChangesToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableChanges&&(identical(other.tableId, tableId) || other.tableId == tableId)&&const DeepCollectionEquality().equals(other.changes, _changes)&&(identical(other.cursor, cursor) || other.cursor == cursor)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.more, more) || other.more == more));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,tableId,const DeepCollectionEquality().hash(_changes),cursor,sequence,more);
}

@override
String toString() {
    return 'TableChanges(tableId: $tableId, changes: $changes, cursor: $cursor, sequence: $sequence, more: $more)';
}


}

/// @nodoc
abstract mixin class _$TableChangesCopyWith<$Res> implements $TableChangesCopyWith<$Res> {
  factory _$TableChangesCopyWith(_TableChanges value, $Res Function(_TableChanges) _then) = __$TableChangesCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'table_id') String tableId, List<TableChange> changes, int cursor, int sequence, bool more
});




}
/// @nodoc
class __$TableChangesCopyWithImpl<$Res>
    implements _$TableChangesCopyWith<$Res> {
  __$TableChangesCopyWithImpl(this._self, this._then);

  final _TableChanges _self;
  final $Res Function(_TableChanges) _then;

/// Create a copy of TableChanges
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tableId = null,Object? changes = null,Object? cursor = null,Object? sequence = null,Object? more = null,}) {
  return _then(_TableChanges(
tableId: null == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String,changes: null == changes ? _self._changes : changes // ignore: cast_nullable_to_non_nullable
as List<TableChange>,cursor: null == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as int,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,more: null == more ? _self.more : more // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
