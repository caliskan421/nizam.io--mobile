import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/providers.dart';
import '../domain/chat.dart';
import '../domain/chat_stream_policy.dart';
import 'messages_providers.dart';

part 'chat_sync_controller.g.dart';

/// Anlık akışın durumu.
enum ChatSyncStatus {
  /// Akış kapalı (arka plan, oturum ya da program yok, dinleyen ekran yok).
  idle,
  connecting,
  live,

  /// Bağlantı düştü; geri çekilmeyle yeniden bağlanılacak.
  retrying,

  /// Durdu (yetki/kapsam/oturum hatası ya da ardışık başarısızlık sınırı). Ekran yeniden
  /// açılınca ya da uygulama ön plana dönünce yeniden denenir.
  offline,
}

/// Sohbet olay akışının (SSE `streamChatEvents`) TEK bağlantı döngüsü. Yalnız onu dinleyen bir
/// mesaj ekranı varken ve uygulama ön plandayken açıktır (dinleyen kalmayınca kapanır: hesap
/// başına 12 akış sınırı, gereksiz akış açılmaz). Açılan her bağlantı ve gelen her olay
/// [ChatSignalBus]'a yayılır; uzlaştırmayı tüketiciler yapar. Yeniden bağlanma §10.5: 0–5 sn
/// jitter + üstel geri çekilme, 429'da `Retry-After`, yetki/oturum hatasında durur (401'de
/// belirteç yenilemesini kimlik halkası yapar; oturum düştüyse yeniden giriş akışı devralır).
@riverpod
class ChatSyncController extends _$ChatSyncController {
  var _gen = 0;
  var _failures = 0;
  StreamSubscription<ChatSignal>? _sub;
  Timer? _timer;
  Completer<void>? _wake;

  @override
  ChatSyncStatus build() {
    final me = ref.watch(chatMeProvider);
    final program = ref.watch(scopeStateProvider.select((s) => s.programId));
    ref
      ..onDispose(_stop)
      ..listen(chatForegroundProvider, (_, foreground) {
        if (foreground) {
          _start();
        } else {
          _stop();
          state = ChatSyncStatus.idle;
        }
      });
    _failures = 0;
    if (me == null || program == null || program.isEmpty) {
      return ChatSyncStatus.idle;
    }
    if (!ref.read(chatForegroundProvider)) return ChatSyncStatus.idle;
    unawaited(_run(++_gen));
    return ChatSyncStatus.connecting;
  }

  bool get _ready {
    final program = ref.read(scopeStateProvider).programId;
    return ref.read(chatMeProvider) != null &&
        program != null &&
        program.isNotEmpty;
  }

  void _start() {
    _stop();
    _failures = 0;
    if (!_ready) return;
    state = ChatSyncStatus.connecting;
    unawaited(_run(++_gen));
  }

  void _stop() {
    _gen++;
    unawaited(_sub?.cancel());
    _sub = null;
    _timer?.cancel();
    _timer = null;
    final wake = _wake;
    if (wake != null && !wake.isCompleted) wake.complete();
    _wake = null;
  }

  void _set(int gen, ChatSyncStatus s) {
    if (gen == _gen && ref.mounted) state = s;
  }

  Future<void> _run(int gen) async {
    while (gen == _gen && ref.mounted) {
      final bus = ref.read(chatSignalBusProvider);
      DateTime? openedAt;
      Object? error;
      final done = _wake = Completer<void>();
      _sub = ref
          .read(chatRepositoryProvider)
          .events()
          .listen(
            (s) {
              if (gen != _gen) return;
              if (s is ChatStreamOpened) {
                openedAt = DateTime.now();
                _set(gen, ChatSyncStatus.live);
              }
              bus.add(s);
            },
            onError: (Object e) {
              error = e;
              if (!done.isCompleted) done.complete();
            },
            onDone: () {
              if (!done.isCompleted) done.complete();
            },
            cancelOnError: true,
          );
      await done.future;
      if (gen != _gen || !ref.mounted) return;
      _sub = null;
      final opened = openedAt;
      Duration? atLeast;
      if (error case final e?) {
        final api = e is ApiError ? e : ApiError(ClientErrorCode.networkError);
        if (streamErrorAction(status: api.status, code: api.code) ==
            StreamErrorAction.stop) {
          return _set(gen, ChatSyncStatus.offline);
        }
        atLeast = api.retryAfter;
      }
      _failures = nextFailures(
        _failures,
        lived: opened == null ? null : DateTime.now().difference(opened),
      );
      if (_failures > ChatStreamPolicy.maxFailures) {
        return _set(gen, ChatSyncStatus.offline);
      }
      var delay = ref.read(chatReconnectDelayProvider)(_failures);
      if (atLeast != null && atLeast > delay) delay = atLeast;
      _set(gen, ChatSyncStatus.retrying);
      final wake = _wake = Completer<void>();
      _timer = Timer(delay, () {
        if (!wake.isCompleted) wake.complete();
      });
      await wake.future;
    }
  }
}
