// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'chat_auto_kind.dart';
import 'chat_kind.dart';
import 'chat_last_message.dart';
import 'chat_role.dart';
import 'chat_source.dart';

part 'chat_summary.freezed.dart';
part 'chat_summary.g.dart';

@Freezed()
abstract class ChatSummary with _$ChatSummary {
  const factory ChatSummary({
    @JsonKey(name: 'chat_id') required String chatId,
    required ChatKind kind,

    /// Grupta ad; birebirde `null`.
    required String? name,
    required ChatSource source,
    @JsonKey(name: 'source_department_id') required String? sourceDepartmentId,

    /// Kendiliğinden kurulan grubun türü; elle kurulan sohbette `null`. Kendiliğinden grup silinemez ve kaynağı değiştirilemez (409 `messaging.auto_group_protected`).
    @JsonKey(name: 'auto_kind') required ChatAutoKind? autoKind,
    @JsonKey(name: 'created_by_account_id') required String? createdByAccountId,
    @JsonKey(name: 'counterpart_account_id')
    required String? counterpartAccountId,
    @JsonKey(name: 'counterpart_name') required String? counterpartName,
    @JsonKey(name: 'last_seq') required int lastSeq,
    @JsonKey(name: 'last_message_at') required DateTime? lastMessageAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'unread_count') required int unreadCount,

    /// Okundu imlecinden ve üyelik başlangıcından sonraki, başkasının, silinmemiş bir.
    /// mesajı çağıranı, çağıranın bu programdaki koordinatörlüğünü ya da herkesi anıyor.
    /// (okunmamış sayımıyla aynı sorgu; okundu ile düşer).
    ///
    required bool mentioned,
    @JsonKey(name: 'last_message') required ChatLastMessage? lastMessage,

    /// Koordinatörlük grubunun (`auto_kind=department`) departmanı; diğer sohbetlerde `null`. İstemci departmanın "Mesaj" eylemini bununla eşler.
    @JsonKey(name: 'auto_department_id') String? autoDepartmentId,

    /// Çağıranın gruptaki rolü (birebirde `member`); sohbet listesinde yoktur.
    ChatRole? role,

    /// Birebirde karşı tarafın açık aboneliği var mı; yoksa false (hiç bağlanmamış ya da sunucu yeniden başlamış dahil). Grupta ya da çevrimiçi sağlayıcısı yoksa null.
    @JsonKey(name: 'peer_online') bool? peerOnline,

    /// Birebirde karşı tarafın son aboneliğinin kapandığı an (bellek içi). Çevrimiçiyse ya da bilinmiyorsa (hiç bağlanmamış, sunucu yeniden başlamış) null; grupta ya da çevrimiçi sağlayıcısı yoksa null.
    @JsonKey(name: 'peer_last_seen_at') DateTime? peerLastSeenAt,
  }) = _ChatSummary;

  factory ChatSummary.fromJson(Map<String, Object?> json) =>
      _$ChatSummaryFromJson(json);
}
