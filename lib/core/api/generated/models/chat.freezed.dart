// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Chat {

@JsonKey(name: 'chat_id') String get chatId; ChatKind get kind;/// Grupta ad; birebirde `null`.
 String? get name; ChatSource get source;@JsonKey(name: 'source_department_id') String? get sourceDepartmentId;/// Kendiliğinden kurulan grubun türü; elle kurulan sohbette `null`. Kendiliğinden grup silinemez ve kaynağı değiştirilemez (409 `messaging.auto_group_protected`).
@JsonKey(name: 'auto_kind') ChatAutoKind? get autoKind;@JsonKey(name: 'created_by_account_id') String? get createdByAccountId;@JsonKey(name: 'counterpart_account_id') String? get counterpartAccountId;@JsonKey(name: 'counterpart_name') String? get counterpartName;@JsonKey(name: 'last_seq') int get lastSeq;@JsonKey(name: 'last_message_at') DateTime? get lastMessageAt;@JsonKey(name: 'created_at') DateTime get createdAt;/// Koordinatörlük grubunun (`auto_kind=department`) departmanı; diğer sohbetlerde `null`. İstemci departmanın "Mesaj" eylemini bununla eşler.
@JsonKey(name: 'auto_department_id') String? get autoDepartmentId;/// Çağıranın gruptaki rolü (birebirde `member`); sohbet listesinde yoktur.
 ChatRole? get role;/// Birebirde karşı tarafın açık aboneliği var mı; yoksa false (hiç bağlanmamış ya da sunucu yeniden başlamış dahil). Grupta ya da çevrimiçi sağlayıcısı yoksa null.
@JsonKey(name: 'peer_online') bool? get peerOnline;/// Birebirde karşı tarafın son aboneliğinin kapandığı an (bellek içi). Çevrimiçiyse ya da bilinmiyorsa (hiç bağlanmamış, sunucu yeniden başlamış) null; grupta ya da çevrimiçi sağlayıcısı yoksa null.
@JsonKey(name: 'peer_last_seen_at') DateTime? get peerLastSeenAt;
/// Create a copy of Chat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatCopyWith<Chat> get copyWith => _$ChatCopyWithImpl<Chat>(this as Chat, _$identity);

  /// Serializes this Chat to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Chat;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Chat&&(identical(other.chatId, _this.chatId) || other.chatId == _this.chatId)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.sourceDepartmentId, _this.sourceDepartmentId) || other.sourceDepartmentId == _this.sourceDepartmentId)&&(identical(other.autoKind, _this.autoKind) || other.autoKind == _this.autoKind)&&(identical(other.createdByAccountId, _this.createdByAccountId) || other.createdByAccountId == _this.createdByAccountId)&&(identical(other.counterpartAccountId, _this.counterpartAccountId) || other.counterpartAccountId == _this.counterpartAccountId)&&(identical(other.counterpartName, _this.counterpartName) || other.counterpartName == _this.counterpartName)&&(identical(other.lastSeq, _this.lastSeq) || other.lastSeq == _this.lastSeq)&&(identical(other.lastMessageAt, _this.lastMessageAt) || other.lastMessageAt == _this.lastMessageAt)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.autoDepartmentId, _this.autoDepartmentId) || other.autoDepartmentId == _this.autoDepartmentId)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.peerOnline, _this.peerOnline) || other.peerOnline == _this.peerOnline)&&(identical(other.peerLastSeenAt, _this.peerLastSeenAt) || other.peerLastSeenAt == _this.peerLastSeenAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Chat;
  return Object.hash(runtimeType,_this.chatId,_this.kind,_this.name,_this.source,_this.sourceDepartmentId,_this.autoKind,_this.createdByAccountId,_this.counterpartAccountId,_this.counterpartName,_this.lastSeq,_this.lastMessageAt,_this.createdAt,_this.autoDepartmentId,_this.role,_this.peerOnline,_this.peerLastSeenAt);
}

@override
String toString() {
  final _this = this as Chat;
  return 'Chat(chatId: ${_this.chatId}, kind: ${_this.kind}, name: ${_this.name}, source: ${_this.source}, sourceDepartmentId: ${_this.sourceDepartmentId}, autoKind: ${_this.autoKind}, createdByAccountId: ${_this.createdByAccountId}, counterpartAccountId: ${_this.counterpartAccountId}, counterpartName: ${_this.counterpartName}, lastSeq: ${_this.lastSeq}, lastMessageAt: ${_this.lastMessageAt}, createdAt: ${_this.createdAt}, autoDepartmentId: ${_this.autoDepartmentId}, role: ${_this.role}, peerOnline: ${_this.peerOnline}, peerLastSeenAt: ${_this.peerLastSeenAt})';
}


}

/// @nodoc
abstract mixin class $ChatCopyWith<$Res>  {
  factory $ChatCopyWith(Chat value, $Res Function(Chat) _then) = _$ChatCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'chat_id') String chatId, ChatKind kind, String? name, ChatSource source,@JsonKey(name: 'source_department_id') String? sourceDepartmentId,@JsonKey(name: 'auto_kind') ChatAutoKind? autoKind,@JsonKey(name: 'created_by_account_id') String? createdByAccountId,@JsonKey(name: 'counterpart_account_id') String? counterpartAccountId,@JsonKey(name: 'counterpart_name') String? counterpartName,@JsonKey(name: 'last_seq') int lastSeq,@JsonKey(name: 'last_message_at') DateTime? lastMessageAt,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'auto_department_id') String? autoDepartmentId, ChatRole? role,@JsonKey(name: 'peer_online') bool? peerOnline,@JsonKey(name: 'peer_last_seen_at') DateTime? peerLastSeenAt
});




}
/// @nodoc
class _$ChatCopyWithImpl<$Res>
    implements $ChatCopyWith<$Res> {
  _$ChatCopyWithImpl(this._self, this._then);

  final Chat _self;
  final $Res Function(Chat) _then;

/// Create a copy of Chat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chatId = null,Object? kind = null,Object? name = freezed,Object? source = null,Object? sourceDepartmentId = freezed,Object? autoKind = freezed,Object? createdByAccountId = freezed,Object? counterpartAccountId = freezed,Object? counterpartName = freezed,Object? lastSeq = null,Object? lastMessageAt = freezed,Object? createdAt = null,Object? autoDepartmentId = freezed,Object? role = freezed,Object? peerOnline = freezed,Object? peerLastSeenAt = freezed,}) {
  return _then(Chat(
chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ChatKind,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ChatSource,sourceDepartmentId: freezed == sourceDepartmentId ? _self.sourceDepartmentId : sourceDepartmentId // ignore: cast_nullable_to_non_nullable
as String?,autoKind: freezed == autoKind ? _self.autoKind : autoKind // ignore: cast_nullable_to_non_nullable
as ChatAutoKind?,createdByAccountId: freezed == createdByAccountId ? _self.createdByAccountId : createdByAccountId // ignore: cast_nullable_to_non_nullable
as String?,counterpartAccountId: freezed == counterpartAccountId ? _self.counterpartAccountId : counterpartAccountId // ignore: cast_nullable_to_non_nullable
as String?,counterpartName: freezed == counterpartName ? _self.counterpartName : counterpartName // ignore: cast_nullable_to_non_nullable
as String?,lastSeq: null == lastSeq ? _self.lastSeq : lastSeq // ignore: cast_nullable_to_non_nullable
as int,lastMessageAt: freezed == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,autoDepartmentId: freezed == autoDepartmentId ? _self.autoDepartmentId : autoDepartmentId // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ChatRole?,peerOnline: freezed == peerOnline ? _self.peerOnline : peerOnline // ignore: cast_nullable_to_non_nullable
as bool?,peerLastSeenAt: freezed == peerLastSeenAt ? _self.peerLastSeenAt : peerLastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Chat].
extension ChatPatterns on Chat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Chat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Chat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Chat value)  $default,){
final _that = this;
switch (_that) {
case _Chat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Chat value)?  $default,){
final _that = this;
switch (_that) {
case _Chat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'chat_id')  String chatId,  ChatKind kind,  String? name,  ChatSource source, @JsonKey(name: 'source_department_id')  String? sourceDepartmentId, @JsonKey(name: 'auto_kind')  ChatAutoKind? autoKind, @JsonKey(name: 'created_by_account_id')  String? createdByAccountId, @JsonKey(name: 'counterpart_account_id')  String? counterpartAccountId, @JsonKey(name: 'counterpart_name')  String? counterpartName, @JsonKey(name: 'last_seq')  int lastSeq, @JsonKey(name: 'last_message_at')  DateTime? lastMessageAt, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'auto_department_id')  String? autoDepartmentId,  ChatRole? role, @JsonKey(name: 'peer_online')  bool? peerOnline, @JsonKey(name: 'peer_last_seen_at')  DateTime? peerLastSeenAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Chat() when $default != null:
return $default(_that.chatId,_that.kind,_that.name,_that.source,_that.sourceDepartmentId,_that.autoKind,_that.createdByAccountId,_that.counterpartAccountId,_that.counterpartName,_that.lastSeq,_that.lastMessageAt,_that.createdAt,_that.autoDepartmentId,_that.role,_that.peerOnline,_that.peerLastSeenAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'chat_id')  String chatId,  ChatKind kind,  String? name,  ChatSource source, @JsonKey(name: 'source_department_id')  String? sourceDepartmentId, @JsonKey(name: 'auto_kind')  ChatAutoKind? autoKind, @JsonKey(name: 'created_by_account_id')  String? createdByAccountId, @JsonKey(name: 'counterpart_account_id')  String? counterpartAccountId, @JsonKey(name: 'counterpart_name')  String? counterpartName, @JsonKey(name: 'last_seq')  int lastSeq, @JsonKey(name: 'last_message_at')  DateTime? lastMessageAt, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'auto_department_id')  String? autoDepartmentId,  ChatRole? role, @JsonKey(name: 'peer_online')  bool? peerOnline, @JsonKey(name: 'peer_last_seen_at')  DateTime? peerLastSeenAt)  $default,) {final _that = this;
switch (_that) {
case _Chat():
return $default(_that.chatId,_that.kind,_that.name,_that.source,_that.sourceDepartmentId,_that.autoKind,_that.createdByAccountId,_that.counterpartAccountId,_that.counterpartName,_that.lastSeq,_that.lastMessageAt,_that.createdAt,_that.autoDepartmentId,_that.role,_that.peerOnline,_that.peerLastSeenAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'chat_id')  String chatId,  ChatKind kind,  String? name,  ChatSource source, @JsonKey(name: 'source_department_id')  String? sourceDepartmentId, @JsonKey(name: 'auto_kind')  ChatAutoKind? autoKind, @JsonKey(name: 'created_by_account_id')  String? createdByAccountId, @JsonKey(name: 'counterpart_account_id')  String? counterpartAccountId, @JsonKey(name: 'counterpart_name')  String? counterpartName, @JsonKey(name: 'last_seq')  int lastSeq, @JsonKey(name: 'last_message_at')  DateTime? lastMessageAt, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'auto_department_id')  String? autoDepartmentId,  ChatRole? role, @JsonKey(name: 'peer_online')  bool? peerOnline, @JsonKey(name: 'peer_last_seen_at')  DateTime? peerLastSeenAt)?  $default,) {final _that = this;
switch (_that) {
case _Chat() when $default != null:
return $default(_that.chatId,_that.kind,_that.name,_that.source,_that.sourceDepartmentId,_that.autoKind,_that.createdByAccountId,_that.counterpartAccountId,_that.counterpartName,_that.lastSeq,_that.lastMessageAt,_that.createdAt,_that.autoDepartmentId,_that.role,_that.peerOnline,_that.peerLastSeenAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Chat implements Chat {
  const _Chat({@JsonKey(name: 'chat_id') required this.chatId, required this.kind, required this.name, required this.source, @JsonKey(name: 'source_department_id') required this.sourceDepartmentId, @JsonKey(name: 'auto_kind') required this.autoKind, @JsonKey(name: 'created_by_account_id') required this.createdByAccountId, @JsonKey(name: 'counterpart_account_id') required this.counterpartAccountId, @JsonKey(name: 'counterpart_name') required this.counterpartName, @JsonKey(name: 'last_seq') required this.lastSeq, @JsonKey(name: 'last_message_at') required this.lastMessageAt, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'auto_department_id') this.autoDepartmentId, this.role, @JsonKey(name: 'peer_online') this.peerOnline, @JsonKey(name: 'peer_last_seen_at') this.peerLastSeenAt});
  factory _Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

@override@JsonKey(name: 'chat_id') final  String chatId;
@override final  ChatKind kind;
/// Grupta ad; birebirde `null`.
@override final  String? name;
@override final  ChatSource source;
@override@JsonKey(name: 'source_department_id') final  String? sourceDepartmentId;
/// Kendiliğinden kurulan grubun türü; elle kurulan sohbette `null`. Kendiliğinden grup silinemez ve kaynağı değiştirilemez (409 `messaging.auto_group_protected`).
@override@JsonKey(name: 'auto_kind') final  ChatAutoKind? autoKind;
@override@JsonKey(name: 'created_by_account_id') final  String? createdByAccountId;
@override@JsonKey(name: 'counterpart_account_id') final  String? counterpartAccountId;
@override@JsonKey(name: 'counterpart_name') final  String? counterpartName;
@override@JsonKey(name: 'last_seq') final  int lastSeq;
@override@JsonKey(name: 'last_message_at') final  DateTime? lastMessageAt;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
/// Koordinatörlük grubunun (`auto_kind=department`) departmanı; diğer sohbetlerde `null`. İstemci departmanın "Mesaj" eylemini bununla eşler.
@override@JsonKey(name: 'auto_department_id') final  String? autoDepartmentId;
/// Çağıranın gruptaki rolü (birebirde `member`); sohbet listesinde yoktur.
@override final  ChatRole? role;
/// Birebirde karşı tarafın açık aboneliği var mı; yoksa false (hiç bağlanmamış ya da sunucu yeniden başlamış dahil). Grupta ya da çevrimiçi sağlayıcısı yoksa null.
@override@JsonKey(name: 'peer_online') final  bool? peerOnline;
/// Birebirde karşı tarafın son aboneliğinin kapandığı an (bellek içi). Çevrimiçiyse ya da bilinmiyorsa (hiç bağlanmamış, sunucu yeniden başlamış) null; grupta ya da çevrimiçi sağlayıcısı yoksa null.
@override@JsonKey(name: 'peer_last_seen_at') final  DateTime? peerLastSeenAt;

/// Create a copy of Chat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatCopyWith<_Chat> get copyWith => __$ChatCopyWithImpl<_Chat>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Chat&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.name, name) || other.name == name)&&(identical(other.source, source) || other.source == source)&&(identical(other.sourceDepartmentId, sourceDepartmentId) || other.sourceDepartmentId == sourceDepartmentId)&&(identical(other.autoKind, autoKind) || other.autoKind == autoKind)&&(identical(other.createdByAccountId, createdByAccountId) || other.createdByAccountId == createdByAccountId)&&(identical(other.counterpartAccountId, counterpartAccountId) || other.counterpartAccountId == counterpartAccountId)&&(identical(other.counterpartName, counterpartName) || other.counterpartName == counterpartName)&&(identical(other.lastSeq, lastSeq) || other.lastSeq == lastSeq)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.autoDepartmentId, autoDepartmentId) || other.autoDepartmentId == autoDepartmentId)&&(identical(other.role, role) || other.role == role)&&(identical(other.peerOnline, peerOnline) || other.peerOnline == peerOnline)&&(identical(other.peerLastSeenAt, peerLastSeenAt) || other.peerLastSeenAt == peerLastSeenAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,chatId,kind,name,source,sourceDepartmentId,autoKind,createdByAccountId,counterpartAccountId,counterpartName,lastSeq,lastMessageAt,createdAt,autoDepartmentId,role,peerOnline,peerLastSeenAt);
}

@override
String toString() {
    return 'Chat(chatId: $chatId, kind: $kind, name: $name, source: $source, sourceDepartmentId: $sourceDepartmentId, autoKind: $autoKind, createdByAccountId: $createdByAccountId, counterpartAccountId: $counterpartAccountId, counterpartName: $counterpartName, lastSeq: $lastSeq, lastMessageAt: $lastMessageAt, createdAt: $createdAt, autoDepartmentId: $autoDepartmentId, role: $role, peerOnline: $peerOnline, peerLastSeenAt: $peerLastSeenAt)';
}


}

/// @nodoc
abstract mixin class _$ChatCopyWith<$Res> implements $ChatCopyWith<$Res> {
  factory _$ChatCopyWith(_Chat value, $Res Function(_Chat) _then) = __$ChatCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'chat_id') String chatId, ChatKind kind, String? name, ChatSource source,@JsonKey(name: 'source_department_id') String? sourceDepartmentId,@JsonKey(name: 'auto_kind') ChatAutoKind? autoKind,@JsonKey(name: 'created_by_account_id') String? createdByAccountId,@JsonKey(name: 'counterpart_account_id') String? counterpartAccountId,@JsonKey(name: 'counterpart_name') String? counterpartName,@JsonKey(name: 'last_seq') int lastSeq,@JsonKey(name: 'last_message_at') DateTime? lastMessageAt,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'auto_department_id') String? autoDepartmentId, ChatRole? role,@JsonKey(name: 'peer_online') bool? peerOnline,@JsonKey(name: 'peer_last_seen_at') DateTime? peerLastSeenAt
});




}
/// @nodoc
class __$ChatCopyWithImpl<$Res>
    implements _$ChatCopyWith<$Res> {
  __$ChatCopyWithImpl(this._self, this._then);

  final _Chat _self;
  final $Res Function(_Chat) _then;

/// Create a copy of Chat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chatId = null,Object? kind = null,Object? name = freezed,Object? source = null,Object? sourceDepartmentId = freezed,Object? autoKind = freezed,Object? createdByAccountId = freezed,Object? counterpartAccountId = freezed,Object? counterpartName = freezed,Object? lastSeq = null,Object? lastMessageAt = freezed,Object? createdAt = null,Object? autoDepartmentId = freezed,Object? role = freezed,Object? peerOnline = freezed,Object? peerLastSeenAt = freezed,}) {
  return _then(_Chat(
chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ChatKind,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ChatSource,sourceDepartmentId: freezed == sourceDepartmentId ? _self.sourceDepartmentId : sourceDepartmentId // ignore: cast_nullable_to_non_nullable
as String?,autoKind: freezed == autoKind ? _self.autoKind : autoKind // ignore: cast_nullable_to_non_nullable
as ChatAutoKind?,createdByAccountId: freezed == createdByAccountId ? _self.createdByAccountId : createdByAccountId // ignore: cast_nullable_to_non_nullable
as String?,counterpartAccountId: freezed == counterpartAccountId ? _self.counterpartAccountId : counterpartAccountId // ignore: cast_nullable_to_non_nullable
as String?,counterpartName: freezed == counterpartName ? _self.counterpartName : counterpartName // ignore: cast_nullable_to_non_nullable
as String?,lastSeq: null == lastSeq ? _self.lastSeq : lastSeq // ignore: cast_nullable_to_non_nullable
as int,lastMessageAt: freezed == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,autoDepartmentId: freezed == autoDepartmentId ? _self.autoDepartmentId : autoDepartmentId // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ChatRole?,peerOnline: freezed == peerOnline ? _self.peerOnline : peerOnline // ignore: cast_nullable_to_non_nullable
as bool?,peerLastSeenAt: freezed == peerLastSeenAt ? _self.peerLastSeenAt : peerLastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
