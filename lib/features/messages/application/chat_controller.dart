import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/chat.dart';

part 'chat_controller.g.dart';

/// Ek panelinin sekmesi (portal atfı).
enum ChatAttachTab { task, coordinatorship, archive }

/// Sohbet ekranının yazma durumu: yanıt/düzenleme bağlamı, eklenen atıflar, ek paneli,
/// görünen sabit mesaj sırası. Taslak metni ekrandaki metin denetleyicisindedir.
@immutable
final class ChatViewState {
  const ChatViewState({
    this.reply,
    this.edit,
    this.refs = const [],
    this.attach,
    this.attachQuery = '',
    this.pin = 0,
    this.devices = 0,
  });

  final String? reply;
  final String? edit;
  final List<ChatRef> refs;

  /// Açık ek paneli sekmesi (null → kapalı).
  final ChatAttachTab? attach;
  final String attachQuery;

  /// Sabit mesaj şeridinde gösterilen sıra (sabit sayısına göre döner).
  final int pin;

  /// Cihazdan eklenen dosya sayacı (örnek ad üretimi).
  final int devices;

  ChatViewState copyWith({
    String? Function()? reply,
    String? Function()? edit,
    List<ChatRef>? refs,
    ChatAttachTab? Function()? attach,
    String? attachQuery,
    int? pin,
    int? devices,
  }) => ChatViewState(
    reply: reply == null ? this.reply : reply(),
    edit: edit == null ? this.edit : edit(),
    refs: refs ?? this.refs,
    attach: attach == null ? this.attach : attach(),
    attachQuery: attachQuery ?? this.attachQuery,
    pin: pin ?? this.pin,
    devices: devices ?? this.devices,
  );
}

/// Sohbet başına yazma durumu (ekran kapanınca sıfırlanır).
@riverpod
class ChatController extends _$ChatController {
  @override
  ChatViewState build(String id) => const ChatViewState();

  /// Sohbet açma olayı (kaynak `S_chat.load`): yanıt, düzenleme, atıflar, ek paneli ve sabit
  /// sırası aynı kimlikte de koşulsuz sıfırlanır. Yalnız açma komutundan çağrılır; yeniden
  /// boyutlandırma çağırmaz (durum korunur).
  void open() => state = const ChatViewState();

  void reply(String msg) =>
      state = state.copyWith(reply: () => msg, edit: () => null);

  void edit(String msg) =>
      state = state.copyWith(edit: () => msg, reply: () => null);

  void clearContext() =>
      state = state.copyWith(reply: () => null, edit: () => null);

  /// Ek panelini açar (görev sekmesi) ya da kapatır.
  void toggleAttach() => state = state.copyWith(
    attach: () => state.attach == null ? ChatAttachTab.task : null,
    attachQuery: '',
  );

  void setAttachTab(ChatAttachTab t) =>
      state = state.copyWith(attach: () => t, attachQuery: '');

  void setAttachQuery(String q) => state = state.copyWith(attachQuery: q);

  /// Atfı ekler; ekliyse kaldırır.
  void toggleRef(ChatRef r) => state = state.copyWith(
    refs: state.refs.contains(r)
        ? ([...state.refs]..remove(r))
        : [...state.refs, r],
  );

  void removeRefAt(int i) =>
      state = state.copyWith(refs: [...state.refs]..removeAt(i));

  /// Cihazdan fotoğraf/belge (örnek ad ve boyut); panel kapanır.
  void addDevice({required bool photo}) {
    final n = state.devices + 1;
    final ref = photo
        ? ChatRef(ChatRefKind.photo, 'IMG_20${41 + n}.jpeg', size: '2,4 MB')
        : ChatRef(ChatRefKind.document, 'Belge_$n.pdf', size: '320 KB');
    state = state.copyWith(
      refs: [...state.refs, ref],
      devices: n,
      attach: () => null,
      attachQuery: '',
    );
  }

  void nextPin() => state = state.copyWith(pin: state.pin + 1);

  void resetPin() => state = state.copyWith(pin: 0);

  /// Gönderildi: bağlam, atıflar ve panel temizlenir.
  void sent() => state = state.copyWith(
    reply: () => null,
    edit: () => null,
    refs: const [],
    attach: () => null,
    attachQuery: '',
  );
}
