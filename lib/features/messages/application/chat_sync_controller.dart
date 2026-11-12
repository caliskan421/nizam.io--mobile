import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/providers.dart';
import '../../../core/telemetry/error_report.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
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
/// jitter + üstel geri çekilme, yetki/oturum hatasında durur (401'de belirteç yenilemesini
/// kimlik halkası yapar; oturum düştüyse yeniden giriş akışı devralır). 429 `Retry-After`'ın
/// mutlak bitişi [ChatStreamHold]'dadır: arka plandan dönüş ve ekranın yeniden açılışı da o
/// ana kadar akış açmaz.
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
    final status = _opening;
    unawaited(_run(++_gen));
    return status;
  }

  /// Açılışın ilk durumu: 429 beklemesi sürüyorsa yeniden deneme, değilse bağlanma.
  ChatSyncStatus get _opening =>
      _held == null ? ChatSyncStatus.connecting : ChatSyncStatus.retrying;

  DateTime _now() => ref.read(chatClockProvider)();

  Duration? get _held => ref
      .read(chatStreamHoldProvider.notifier)
      .left(ref.read(chatMeProvider), _now());

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
    state = _opening;
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
      // 429 beklemesi bitmeden akış açılmaz (durum zaten "yeniden deneme").
      if (_held case final wait?) {
        await _sleep(wait);
        continue;
      }
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
                openedAt = _now();
                _set(gen, ChatSyncStatus.live);
              }
              bus.add(s);
            },
            onError: (Object e, StackTrace st) {
              // ApiError dışı akış hatası aşağıda networkError sayılır: önce raporlanır
              // (ApiError ve ağ kopması beklenen sınıftır, süzülür).
              reportUnexpected(
                e,
                st,
                source: ReportSource.messages,
                operation: ReportOperation.chatStream,
              );
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
      if (error case final e?) {
        final api = e is ApiError ? e : ApiError(ClientErrorCode.networkError);
        if (streamErrorAction(status: api.status, code: api.code) ==
            StreamErrorAction.stop) {
          return _set(gen, ChatSyncStatus.offline);
        }
        final me = ref.read(chatMeProvider);
        if (api.retryAfter case final wait? when me != null) {
          ref.read(chatStreamHoldProvider.notifier).hold(me, _now().add(wait));
        }
      }
      _failures = nextFailures(
        _failures,
        lived: opened == null ? null : _now().difference(opened),
      );
      if (_failures > ChatStreamPolicy.maxFailures) {
        return _set(gen, ChatSyncStatus.offline);
      }
      _set(gen, ChatSyncStatus.retrying);
      await _sleep(ref.read(chatReconnectDelayProvider)(_failures));
    }
  }

  /// [_stop] uyandırana ya da süre dolana kadar bekler.
  Future<void> _sleep(Duration d) {
    final wake = _wake = Completer<void>();
    _timer = Timer(d, () {
      if (!wake.isCompleted) wake.complete();
    });
    return wake.future;
  }
}
