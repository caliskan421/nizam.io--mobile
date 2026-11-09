import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_controller.g.dart';

/// Sohbet ekranının yazma durumu: yanıt/düzenleme bağlamı ve görünen sabit mesaj sırası.
/// Taslak metni ekrandaki metin denetleyicisindedir (düzenlemede açılıştaki mesaj metniyle dolar).
@immutable
final class ChatViewState {
  const ChatViewState({this.reply, this.edit, this.editRevision, this.pin = 0});

  final String? reply;
  final String? edit;

  /// Düzenleme taslağının tabanı: taslak açılırken okunan `edit_revision` (gönderimde
  /// `expected_revision`; akışla gelen sonraki düzenleme bunu değiştirmez).
  final int? editRevision;

  /// Sabit mesaj şeridinde gösterilen sıra (sabit sayısına göre döner).
  final int pin;

  ChatViewState copyWith({int? pin}) => ChatViewState(
    reply: reply,
    edit: edit,
    editRevision: editRevision,
    pin: pin ?? this.pin,
  );
}

/// Sohbet başına yazma durumu (ekran kapanınca sıfırlanır).
@riverpod
class ChatController extends _$ChatController {
  @override
  ChatViewState build(String id) => const ChatViewState();

  /// Sohbet açma olayı (kaynak `S_chat.load`): yanıt, düzenleme ve sabit sırası aynı kimlikte de
  /// koşulsuz sıfırlanır. Yalnız açma komutundan çağrılır; yeniden boyutlandırma çağırmaz.
  void open() => state = const ChatViewState();

  void reply(String msg) => state = ChatViewState(reply: msg, pin: state.pin);

  /// Düzenleme taslağını [revision] tabanıyla açar (409 çakışmasından sonra kullanıcı sunucunun
  /// yeni değerini görmüş olarak yeni tabanla yeniden açar).
  void edit(String msg, {required int revision}) =>
      state = ChatViewState(edit: msg, editRevision: revision, pin: state.pin);

  void clearContext() => state = ChatViewState(pin: state.pin);

  void nextPin() => state = state.copyWith(pin: state.pin + 1);

  void resetPin() => state = state.copyWith(pin: 0);
}
