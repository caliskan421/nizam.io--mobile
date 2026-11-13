// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableSnapshot {

 Table get table; List<TableColumn> get columns;/// Satır konumuna göre sıralı sayfa.
 List<TableRow> get rows;/// Sayfadaki satırların yazılmış hücreleri.
 List<TableCell> get cells;/// Sonraki satır sayfası; son sayfada yoktur.
@JsonKey(name: 'next_cursor') String? get nextCursor;/// Sayfadaki referansların okuyana GÖRÜNEN hedeflerinin görünen adları (TABLES-K14): anahtar tür (`people`, `departments`, `tasks`, `files`, `tables`), değer kimlik → ad. Görünmeyen hedefin adı hiç yer almaz; önizleme, rol ya da açıklama taşınmaz. Kişi adı identity'deki görünen ad, departman adı programdaki ad, görev başlığı, dosya görünen adı, tablo adıdır. Hiç görünür referans yoksa alan yoktur. Adlar 8 MiB okuma bütçesine dahildir.
 Map<String, Map<String, String>>? get references;/// Sayfadaki `attachment` hücrelerine bağlı AKTİF eklerin bilgisi (TABLES-K15): anahtar ek kimliği (hücre değeri). Depolama anahtarı ve yükleyen yoktur; emekli ek yer almaz. Hiç ek yoksa alan yoktur. Kodlanmış boyutu `references` ve hücrelerle AYNI 8 MiB okuma bütçesine dahildir.
 Map<String, TableAttachmentMeta>? get attachments;
/// Create a copy of TableSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableSnapshotCopyWith<TableSnapshot> get copyWith => _$TableSnapshotCopyWithImpl<TableSnapshot>(this as TableSnapshot, _$identity);

  /// Serializes this TableSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableSnapshot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableSnapshot&&(identical(other.table, _this.table) || other.table == _this.table)&&const DeepCollectionEquality().equals(other.columns, _this.columns)&&const DeepCollectionEquality().equals(other.rows, _this.rows)&&const DeepCollectionEquality().equals(other.cells, _this.cells)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor)&&const DeepCollectionEquality().equals(other.references, _this.references)&&const DeepCollectionEquality().equals(other.attachments, _this.attachments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableSnapshot;
  return Object.hash(runtimeType,_this.table,const DeepCollectionEquality().hash(_this.columns),const DeepCollectionEquality().hash(_this.rows),const DeepCollectionEquality().hash(_this.cells),_this.nextCursor,const DeepCollectionEquality().hash(_this.references),const DeepCollectionEquality().hash(_this.attachments));
}

@override
String toString() {
  final _this = this as TableSnapshot;
  return 'TableSnapshot(table: ${_this.table}, columns: ${_this.columns}, rows: ${_this.rows}, cells: ${_this.cells}, nextCursor: ${_this.nextCursor}, references: ${_this.references}, attachments: ${_this.attachments})';
}


}

/// @nodoc
abstract mixin class $TableSnapshotCopyWith<$Res>  {
  factory $TableSnapshotCopyWith(TableSnapshot value, $Res Function(TableSnapshot) _then) = _$TableSnapshotCopyWithImpl;
@useResult
$Res call({
 Table table, List<TableColumn> columns, List<TableRow> rows, List<TableCell> cells,@JsonKey(name: 'next_cursor') String? nextCursor, Map<String, Map<String, String>>? references, Map<String, TableAttachmentMeta>? attachments
});


$TableCopyWith<$Res> get table;

}
/// @nodoc
class _$TableSnapshotCopyWithImpl<$Res>
    implements $TableSnapshotCopyWith<$Res> {
  _$TableSnapshotCopyWithImpl(this._self, this._then);

  final TableSnapshot _self;
  final $Res Function(TableSnapshot) _then;

/// Create a copy of TableSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? table = null,Object? columns = null,Object? rows = null,Object? cells = null,Object? nextCursor = freezed,Object? references = freezed,Object? attachments = freezed,}) {
  return _then(TableSnapshot(
table: null == table ? _self.table : table // ignore: cast_nullable_to_non_nullable
as Table,columns: null == columns ? _self.columns : columns // ignore: cast_nullable_to_non_nullable
as List<TableColumn>,rows: null == rows ? _self.rows : rows // ignore: cast_nullable_to_non_nullable
as List<TableRow>,cells: null == cells ? _self.cells : cells // ignore: cast_nullable_to_non_nullable
as List<TableCell>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,references: freezed == references ? _self.references : references // ignore: cast_nullable_to_non_nullable
as Map<String, Map<String, String>>?,attachments: freezed == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as Map<String, TableAttachmentMeta>?,
  ));
}
/// Create a copy of TableSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TableCopyWith<$Res> get table {
  
  return $TableCopyWith<$Res>(_self.table, (value) {
    return _then(_self.copyWith(table: value));
  });
}
}


/// Adds pattern-matching-related methods to [TableSnapshot].
extension TableSnapshotPatterns on TableSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _TableSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _TableSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Table table,  List<TableColumn> columns,  List<TableRow> rows,  List<TableCell> cells, @JsonKey(name: 'next_cursor')  String? nextCursor,  Map<String, Map<String, String>>? references,  Map<String, TableAttachmentMeta>? attachments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableSnapshot() when $default != null:
return $default(_that.table,_that.columns,_that.rows,_that.cells,_that.nextCursor,_that.references,_that.attachments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Table table,  List<TableColumn> columns,  List<TableRow> rows,  List<TableCell> cells, @JsonKey(name: 'next_cursor')  String? nextCursor,  Map<String, Map<String, String>>? references,  Map<String, TableAttachmentMeta>? attachments)  $default,) {final _that = this;
switch (_that) {
case _TableSnapshot():
return $default(_that.table,_that.columns,_that.rows,_that.cells,_that.nextCursor,_that.references,_that.attachments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Table table,  List<TableColumn> columns,  List<TableRow> rows,  List<TableCell> cells, @JsonKey(name: 'next_cursor')  String? nextCursor,  Map<String, Map<String, String>>? references,  Map<String, TableAttachmentMeta>? attachments)?  $default,) {final _that = this;
switch (_that) {
case _TableSnapshot() when $default != null:
return $default(_that.table,_that.columns,_that.rows,_that.cells,_that.nextCursor,_that.references,_that.attachments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableSnapshot implements TableSnapshot {
  const _TableSnapshot({required this.table, required  List<TableColumn> columns, required  List<TableRow> rows, required  List<TableCell> cells, @JsonKey(name: 'next_cursor') this.nextCursor,  Map<String, Map<String, String>>? references,  Map<String, TableAttachmentMeta>? attachments}): _columns = columns,_rows = rows,_cells = cells,_references = references,_attachments = attachments;
  factory _TableSnapshot.fromJson(Map<String, dynamic> json) => _$TableSnapshotFromJson(json);

@override final  Table table;
 final  List<TableColumn> _columns;
@override List<TableColumn> get columns {
  if (_columns is EqualUnmodifiableListView) return _columns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_columns);
}

/// Satır konumuna göre sıralı sayfa.
 final  List<TableRow> _rows;
/// Satır konumuna göre sıralı sayfa.
@override List<TableRow> get rows {
  if (_rows is EqualUnmodifiableListView) return _rows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rows);
}

/// Sayfadaki satırların yazılmış hücreleri.
 final  List<TableCell> _cells;
/// Sayfadaki satırların yazılmış hücreleri.
@override List<TableCell> get cells {
  if (_cells is EqualUnmodifiableListView) return _cells;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cells);
}

/// Sonraki satır sayfası; son sayfada yoktur.
@override@JsonKey(name: 'next_cursor') final  String? nextCursor;
/// Sayfadaki referansların okuyana GÖRÜNEN hedeflerinin görünen adları (TABLES-K14): anahtar tür (`people`, `departments`, `tasks`, `files`, `tables`), değer kimlik → ad. Görünmeyen hedefin adı hiç yer almaz; önizleme, rol ya da açıklama taşınmaz. Kişi adı identity'deki görünen ad, departman adı programdaki ad, görev başlığı, dosya görünen adı, tablo adıdır. Hiç görünür referans yoksa alan yoktur. Adlar 8 MiB okuma bütçesine dahildir.
 final  Map<String, Map<String, String>>? _references;
/// Sayfadaki referansların okuyana GÖRÜNEN hedeflerinin görünen adları (TABLES-K14): anahtar tür (`people`, `departments`, `tasks`, `files`, `tables`), değer kimlik → ad. Görünmeyen hedefin adı hiç yer almaz; önizleme, rol ya da açıklama taşınmaz. Kişi adı identity'deki görünen ad, departman adı programdaki ad, görev başlığı, dosya görünen adı, tablo adıdır. Hiç görünür referans yoksa alan yoktur. Adlar 8 MiB okuma bütçesine dahildir.
@override Map<String, Map<String, String>>? get references {
  final value = _references;
  if (value == null) return null;
  if (_references is EqualUnmodifiableMapView) return _references;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

/// Sayfadaki `attachment` hücrelerine bağlı AKTİF eklerin bilgisi (TABLES-K15): anahtar ek kimliği (hücre değeri). Depolama anahtarı ve yükleyen yoktur; emekli ek yer almaz. Hiç ek yoksa alan yoktur. Kodlanmış boyutu `references` ve hücrelerle AYNI 8 MiB okuma bütçesine dahildir.
 final  Map<String, TableAttachmentMeta>? _attachments;
/// Sayfadaki `attachment` hücrelerine bağlı AKTİF eklerin bilgisi (TABLES-K15): anahtar ek kimliği (hücre değeri). Depolama anahtarı ve yükleyen yoktur; emekli ek yer almaz. Hiç ek yoksa alan yoktur. Kodlanmış boyutu `references` ve hücrelerle AYNI 8 MiB okuma bütçesine dahildir.
@override Map<String, TableAttachmentMeta>? get attachments {
  final value = _attachments;
  if (value == null) return null;
  if (_attachments is EqualUnmodifiableMapView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of TableSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableSnapshotCopyWith<_TableSnapshot> get copyWith => __$TableSnapshotCopyWithImpl<_TableSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableSnapshot&&(identical(other.table, table) || other.table == table)&&const DeepCollectionEquality().equals(other.columns, _columns)&&const DeepCollectionEquality().equals(other.rows, _rows)&&const DeepCollectionEquality().equals(other.cells, _cells)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&const DeepCollectionEquality().equals(other.references, _references)&&const DeepCollectionEquality().equals(other.attachments, _attachments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,table,const DeepCollectionEquality().hash(_columns),const DeepCollectionEquality().hash(_rows),const DeepCollectionEquality().hash(_cells),nextCursor,const DeepCollectionEquality().hash(_references),const DeepCollectionEquality().hash(_attachments));
}

@override
String toString() {
    return 'TableSnapshot(table: $table, columns: $columns, rows: $rows, cells: $cells, nextCursor: $nextCursor, references: $references, attachments: $attachments)';
}


}

/// @nodoc
abstract mixin class _$TableSnapshotCopyWith<$Res> implements $TableSnapshotCopyWith<$Res> {
  factory _$TableSnapshotCopyWith(_TableSnapshot value, $Res Function(_TableSnapshot) _then) = __$TableSnapshotCopyWithImpl;
@override @useResult
$Res call({
 Table table, List<TableColumn> columns, List<TableRow> rows, List<TableCell> cells,@JsonKey(name: 'next_cursor') String? nextCursor, Map<String, Map<String, String>>? references, Map<String, TableAttachmentMeta>? attachments
});


@override $TableCopyWith<$Res> get table;

}
/// @nodoc
class __$TableSnapshotCopyWithImpl<$Res>
    implements _$TableSnapshotCopyWith<$Res> {
  __$TableSnapshotCopyWithImpl(this._self, this._then);

  final _TableSnapshot _self;
  final $Res Function(_TableSnapshot) _then;

/// Create a copy of TableSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? table = null,Object? columns = null,Object? rows = null,Object? cells = null,Object? nextCursor = freezed,Object? references = freezed,Object? attachments = freezed,}) {
  return _then(_TableSnapshot(
table: null == table ? _self.table : table // ignore: cast_nullable_to_non_nullable
as Table,columns: null == columns ? _self._columns : columns // ignore: cast_nullable_to_non_nullable
as List<TableColumn>,rows: null == rows ? _self._rows : rows // ignore: cast_nullable_to_non_nullable
as List<TableRow>,cells: null == cells ? _self._cells : cells // ignore: cast_nullable_to_non_nullable
as List<TableCell>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,references: freezed == references ? _self._references : references // ignore: cast_nullable_to_non_nullable
as Map<String, Map<String, String>>?,attachments: freezed == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as Map<String, TableAttachmentMeta>?,
  ));
}

/// Create a copy of TableSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TableCopyWith<$Res> get table {
  
  return $TableCopyWith<$Res>(_self.table, (value) {
    return _then(_self.copyWith(table: value));
  });
}
}

// dart format on
