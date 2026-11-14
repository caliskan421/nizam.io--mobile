import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/cache_owner.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../domain/chat.dart';
import '../domain/chat_stream_policy.dart';
import 'messages_providers.dart';

part 'chats_controller.g.dart';

/// Mesajlar kutusu (seçili programın sohbetleri). Hesap ya da program değişince yeniden okunur.
/// Akış açılınca (yeniden bağlanma protokolü adım 2) hemen, olaylarda en az 1 sn birleştirilip
/// tek `listChats` okumasıyla tazelenir; tazeleme hatası eski listeyi bozmaz. Okumalar
/// yanıt nesliyle sıralanır: yalnız en son başlatılan okumanın yanıtı yazılır (geç gelen eski
/// yanıt yeni listeyi ezmez). Liste okunduğu sahibe (oturum nesli + program) bağlıdır; ekran
/// [visible] durumunu gösterir (başka hesabın/programın sohbetleri görünmez).
@Riverpod(keepAlive: true)
class ChatsController extends _$ChatsController {
  Timer? _coalesce;

  /// Son başlatılan okumanın nesli ([build] ve [refresh] artırır).
  var _generation = 0;

  /// Durumdaki listenin sahibi (notifier yeniden kurulumlarda korunur).
  final _owner = CacheOwnership();

  @override
  Future<ChatInbox> build() async {
    final generation = ++_generation;
    final owner = _owner.watch(ref);
    ref.watch(chatMeProvider);
    final sub = ref.watch(chatSignalBusProvider).stream.listen(_onSignal);
    ref.onDispose(() {
      unawaited(sub.cancel());
      _coalesce?.cancel();
      _coalesce = null;
    });
    final inbox = await ref
        .read(chatRepositoryProvider)
        .loadInbox(isCurrent: () => _isCurrent(owner, generation));
    _owner.markLoaded(ref, owner);
    return inbox;
  }

  /// Ekranın gösterebileceği durum (bkz. [CacheOwnership.visible]); çağıran sağlayıcıyı izler.
  AsyncValue<ChatInbox> get visible => _owner.visible(ref, state);

  ChatRepository get _repo => ref.read(chatRepositoryProvider);

  CacheOwner get _currentOwner => _owner.current(ref);

  bool _isCurrent(CacheOwner owner, int generation) =>
      ref.mounted && owner == _currentOwner && generation == _generation;

  void _set(ChatInbox Function(ChatInbox) f) {
    if (!ref.mounted || !_owner.owns(ref)) return;
    final v = state.value;
    if (v != null) {
      state = AsyncData(f(v));
      ref.invalidate(chatUnreadSnapshotProvider);
    }
  }

  void _onSignal(ChatSignal s) {
    switch (s) {
      case ChatStreamOpened():
        _coalesce?.cancel();
        _coalesce = null;
        unawaited(refresh());
      case ChatEvent(kind: ChatEventKind.typing):
        return;
      case ChatEvent():
        _coalesce ??= Timer(ChatStreamPolicy.coalesce, () {
          _coalesce = null;
          unawaited(refresh());
        });
    }
  }

  /// Listeyi sessizce yeniden okur (hata yutulur: eski liste görünür kalır). Bu okuma
  /// sürerken başka okuma başladıysa (ör. ön plan yenilemesi sürerken akış açıldı) yanıtı
  /// atılır; uçuş birleştirmesi yok.
  Future<void> refresh() async {
    try {
      await reload();
    } on Object catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.messages);
      // Ağ/sunucu hatası: sonraki olay ya da yeniden bağlanma tazeler.
    }
  }

  /// Kullanıcı yenilemesi (aşağı çekerek): [refresh] ile aynı okuma; hata FIRLATILIR (çağıran
  /// bildirir), önceki liste durumda kalır.
  Future<void> reload() async {
    if (state.value == null) return;
    final generation = ++_generation;
    final owner = _currentOwner;
    final inbox = await _repo.loadInbox(
      isCurrent: () => _isCurrent(owner, generation),
    );
    if (_isCurrent(owner, generation)) {
      state = AsyncData(inbox);
      ref.invalidate(chatUnreadSnapshotProvider);
    }
  }

  /// Bütün sohbetleri sunucuda okundu sayar; başarıda yerel sayaçlar sıfırlanır.
  Future<void> markAllRead() async {
    final owner = _currentOwner;
    final generation = _generation;
    await _repo.markAllRead();
    if (!_isCurrent(owner, generation)) return;
    _set((v) => v.mapChats((c) => c.copyWith(unread: 0, mention: false)));
  }

  /// Sohbet açık ve okundu imleci ilerledi: satırın sayacı ve bahsetmesi düşer.
  void markedRead(String chatId) => _set(
    (v) => v.replace(chatId, (c) => c.copyWith(unread: 0, mention: false)),
  );

  /// Yeni açılan (ya da kurulan) sohbet listede yoksa başa eklenir.
  void opened(Chat chat) => _set((v) => v.withChat(chat));

  /// Gruptan ayrıldım ya da grup silindi: satır listeden kalkar.
  void removed(String chatId) => _set(
    (v) => ChatInbox(
      chats: [
        for (final c in v.chats)
          if (c.id != chatId) c,
      ],
      truncated: v.truncated,
    ),
  );
}
