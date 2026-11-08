import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_controller.g.dart';

/// Sohbet ekranının yazma durumu: yanıt/düzenleme bağlamı ve görünen sabit mesaj sırası.
/// Taslak metni ekrandaki metin denetleyicisindedir.
@immutable
final class ChatViewState {
  const ChatViewState({this.reply, this.edit, this.pin = 0});

  final String? reply;
  final String? edit;

  /// Sabit mesaj şeridinde gösterilen sıra (sabit sayısına göre döner).
  final int pin;

  ChatViewState copyWith({
    String? Function()? reply,
    String? Function()? edit,
    int? pin,
  }) => ChatViewState(
    reply: reply == null ? this.reply : reply(),
    edit: edit == null ? this.edit : edit(),
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

  void reply(String msg) =>
      state = state.copyWith(reply: () => msg, edit: () => null);

  void edit(String msg) =>
      state = state.copyWith(edit: () => msg, reply: () => null);

  void clearContext() =>
      state = state.copyWith(reply: () => null, edit: () => null);

  void nextPin() => state = state.copyWith(pin: state.pin + 1);

  void resetPin() => state = state.copyWith(pin: 0);
}
