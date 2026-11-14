// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meeting_note_counts.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MeetingNoteCounts {

 int get all;/// Göreve dönüşmüş notlar.
 int get converted;/// Çağıranın yazdığı notlar (yazarın rol kopyasından bağımsız).
 int get mine;
/// Create a copy of MeetingNoteCounts
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeetingNoteCountsCopyWith<MeetingNoteCounts> get copyWith => _$MeetingNoteCountsCopyWithImpl<MeetingNoteCounts>(this as MeetingNoteCounts, _$identity);

  /// Serializes this MeetingNoteCounts to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MeetingNoteCounts;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeetingNoteCounts&&(identical(other.all, _this.all) || other.all == _this.all)&&(identical(other.converted, _this.converted) || other.converted == _this.converted)&&(identical(other.mine, _this.mine) || other.mine == _this.mine));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MeetingNoteCounts;
  return Object.hash(runtimeType,_this.all,_this.converted,_this.mine);
}

@override
String toString() {
  final _this = this as MeetingNoteCounts;
  return 'MeetingNoteCounts(all: ${_this.all}, converted: ${_this.converted}, mine: ${_this.mine})';
}


}

/// @nodoc
abstract mixin class $MeetingNoteCountsCopyWith<$Res>  {
  factory $MeetingNoteCountsCopyWith(MeetingNoteCounts value, $Res Function(MeetingNoteCounts) _then) = _$MeetingNoteCountsCopyWithImpl;
@useResult
$Res call({
 int all, int converted, int mine
});




}
/// @nodoc
class _$MeetingNoteCountsCopyWithImpl<$Res>
    implements $MeetingNoteCountsCopyWith<$Res> {
  _$MeetingNoteCountsCopyWithImpl(this._self, this._then);

  final MeetingNoteCounts _self;
  final $Res Function(MeetingNoteCounts) _then;

/// Create a copy of MeetingNoteCounts
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? all = null,Object? converted = null,Object? mine = null,}) {
  return _then(MeetingNoteCounts(
all: null == all ? _self.all : all // ignore: cast_nullable_to_non_nullable
as int,converted: null == converted ? _self.converted : converted // ignore: cast_nullable_to_non_nullable
as int,mine: null == mine ? _self.mine : mine // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MeetingNoteCounts].
extension MeetingNoteCountsPatterns on MeetingNoteCounts {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeetingNoteCounts value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeetingNoteCounts() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeetingNoteCounts value)  $default,){
final _that = this;
switch (_that) {
case _MeetingNoteCounts():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeetingNoteCounts value)?  $default,){
final _that = this;
switch (_that) {
case _MeetingNoteCounts() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int all,  int converted,  int mine)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeetingNoteCounts() when $default != null:
return $default(_that.all,_that.converted,_that.mine);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int all,  int converted,  int mine)  $default,) {final _that = this;
switch (_that) {
case _MeetingNoteCounts():
return $default(_that.all,_that.converted,_that.mine);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int all,  int converted,  int mine)?  $default,) {final _that = this;
switch (_that) {
case _MeetingNoteCounts() when $default != null:
return $default(_that.all,_that.converted,_that.mine);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeetingNoteCounts implements MeetingNoteCounts {
  const _MeetingNoteCounts({required this.all, required this.converted, required this.mine});
  factory _MeetingNoteCounts.fromJson(Map<String, dynamic> json) => _$MeetingNoteCountsFromJson(json);

@override final  int all;
/// Göreve dönüşmüş notlar.
@override final  int converted;
/// Çağıranın yazdığı notlar (yazarın rol kopyasından bağımsız).
@override final  int mine;

/// Create a copy of MeetingNoteCounts
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeetingNoteCountsCopyWith<_MeetingNoteCounts> get copyWith => __$MeetingNoteCountsCopyWithImpl<_MeetingNoteCounts>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeetingNoteCountsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeetingNoteCounts&&(identical(other.all, all) || other.all == all)&&(identical(other.converted, converted) || other.converted == converted)&&(identical(other.mine, mine) || other.mine == mine));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,all,converted,mine);
}

@override
String toString() {
    return 'MeetingNoteCounts(all: $all, converted: $converted, mine: $mine)';
}


}

/// @nodoc
abstract mixin class _$MeetingNoteCountsCopyWith<$Res> implements $MeetingNoteCountsCopyWith<$Res> {
  factory _$MeetingNoteCountsCopyWith(_MeetingNoteCounts value, $Res Function(_MeetingNoteCounts) _then) = __$MeetingNoteCountsCopyWithImpl;
@override @useResult
$Res call({
 int all, int converted, int mine
});




}
/// @nodoc
class __$MeetingNoteCountsCopyWithImpl<$Res>
    implements _$MeetingNoteCountsCopyWith<$Res> {
  __$MeetingNoteCountsCopyWithImpl(this._self, this._then);

  final _MeetingNoteCounts _self;
  final $Res Function(_MeetingNoteCounts) _then;

/// Create a copy of MeetingNoteCounts
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? all = null,Object? converted = null,Object? mine = null,}) {
  return _then(_MeetingNoteCounts(
all: null == all ? _self.all : all // ignore: cast_nullable_to_non_nullable
as int,converted: null == converted ? _self.converted : converted // ignore: cast_nullable_to_non_nullable
as int,mine: null == mine ? _self.mine : mine // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
