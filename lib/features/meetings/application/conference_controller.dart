import 'dart:async';

import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/providers.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../domain/conference.dart';
import '../domain/meeting.dart';
import 'active_conference.dart';
import 'conference_url.dart';
import 'meeting_room_controller.dart';
import 'meetings_providers.dart';

part 'conference_controller.g.dart';

/// Görüşme ekranının durumu ([ConferenceController]).
@immutable
final class ConferenceView {
  ConferenceView({
    this.phase = ConferencePhase.idle,
    List<ConferencePeer> peers = const [],
    this.micOn = false,
    this.cameraOn = false,
    this.micIssue,
    this.cameraIssue,
    this.role = ConferenceRole.unknown,
    this.error,
    this.end,
  }) : peers = List.unmodifiable(peers);

  final ConferencePhase phase;
  final List<ConferencePeer> peers;
  final bool micOn;
  final bool cameraOn;

  /// Son açma denemesinin sorunu (null → sorun yok).
  final MediaIssue? micIssue;
  final MediaIssue? cameraIssue;

  /// Token'daki oda rolü; `host` konferansı herkes için bitirebilir (K45/K46).
  final ConferenceRole role;

  /// [ConferencePhase.failed] nedeni.
  final ApiError? error;

  /// [ConferencePhase.ended] nedeni.
  final ConferenceEnd? end;

  bool get canEnd => role == ConferenceRole.host;

  /// Oda bağı canlı (bağlı ya da yeniden bağlanıyor).
  bool get inRoom =>
      phase == ConferencePhase.connected ||
      phase == ConferencePhase.reconnecting;

  ConferenceView copyWith({
    ConferencePhase? phase,
    List<ConferencePeer>? peers,
    bool? micOn,
    bool? cameraOn,
    MediaIssue? Function()? micIssue,
    MediaIssue? Function()? cameraIssue,
    ConferenceRole? role,
  }) => ConferenceView(
    phase: phase ?? this.phase,
    peers: peers ?? this.peers,
    micOn: micOn ?? this.micOn,
    cameraOn: cameraOn ?? this.cameraOn,
    micIssue: micIssue == null ? this.micIssue : micIssue(),
    cameraIssue: cameraIssue == null ? this.cameraIssue : cameraIssue(),
    role: role ?? this.role,
    error: error,
    end: end,
  );
}

/// Bir toplantının görüntülü görüşmesi: katılım token'ı (`joinConference`) → adres doğrulama
/// ([conferenceUrl]) → oda bağı ([ConferenceLink]) → mikrofon ve kamera. Token yalnız bağa
/// verilir; durumda, log'da ve hata metninde yoktur. Kopan bağlantıyı sağlayıcı kendisi yeniden
/// kurar (durum "yeniden bağlanıyor"); kalıcı kopuş nedeniyle "bitti"ye geçer. Oda ekran
/// kapansa da sürer (mini pencere, [ActiveConference]); yalnız ayrılınca, bitirilince ya da
/// sağlayıcı kabı atılınca (oturum kapanışı) kapanır. Aynı anda tek oda: başka toplantıya
/// katılmak öncekinden ayrılır.
@Riverpod(keepAlive: true)
class ConferenceController extends _$ConferenceController {
  ConferenceLink? _link;

  // Abonelik [_drop]'ta kapanır (ayrılma, kopuş, yeni katılım, sağlayıcı atılması).
  // ignore: cancel_subscriptions
  StreamSubscription<ConferenceSignal>? _sub;

  /// Katılım denemesi kimliği: ayrılma ya da yeni deneme eski denemenin sonucunu geçersiz kılar.
  int _attempt = 0;

  @override
  ConferenceView build(String id) {
    ref.onDispose(() {
      _attempt++;
      _drop().ignore();
    });
    return ConferenceView();
  }

  bool _live(int attempt) => ref.mounted && attempt == _attempt;

  /// Odaya katılır (bağlıyken ya da bağlanırken bir şey yapmaz).
  Future<void> join() async {
    if (state.phase == ConferencePhase.connecting || state.inRoom) return;
    final attempt = ++_attempt;
    await _drop();
    final other = ref.read(activeConferenceControllerProvider).inCall;
    if (other != null && other != id) {
      await ref.read(conferenceControllerProvider(other).notifier).leave();
    }
    if (!_live(attempt)) return;
    state = ConferenceView(phase: ConferencePhase.connecting);
    try {
      final grant = await ref
          .read(meetingsRepositoryProvider)
          .joinConference(id);
      if (!_live(attempt)) return;
      // Token katılmadan hemen önce alınır; süresi dolmuşsa (cihaz saati) bağlanılmaz.
      if (!grant.expiresAt.isAfter(DateTime.now())) {
        throw ApiError(ClientErrorCode.conferenceTokenExpired);
      }
      final url = conferenceUrl(grant.url, ref.read(flavorProvider));
      final link = ref.read(conferenceLinkFactoryProvider)();
      _link = link;
      _sub = link.signals.listen(_onSignal);
      await link.connect(url, grant.token);
      if (!_live(attempt)) return;
      state = state.copyWith(
        phase: ConferencePhase.connected,
        role: grant.role,
        peers: link.peers,
      );
      ref.read(activeConferenceControllerProvider.notifier).enter(id);
      final mic = await link.setMicrophone(true);
      if (!_live(attempt)) return;
      state = state.copyWith(
        micOn: mic == null,
        micIssue: () => mic,
        peers: link.peers,
      );
      final cam = await link.setCamera(true);
      if (!_live(attempt)) return;
      state = state.copyWith(
        cameraOn: cam == null,
        cameraIssue: () => cam,
        peers: link.peers,
      );
    } on Object catch (e, st) {
      final error = toReportedApiError(e, st, source: ReportSource.meetings);
      if (!_live(attempt)) return;
      await _drop();
      if (!_live(attempt)) return;
      ref.read(activeConferenceControllerProvider.notifier).exit(id);
      state = ConferenceView(phase: ConferencePhase.failed, error: error);
    }
  }

  void _onSignal(ConferenceSignal s) {
    final link = _link;
    if (!ref.mounted || link == null) return;
    switch (s) {
      case ConferencePeersChanged():
        state = state.copyWith(peers: link.peers);
      case ConferenceReconnecting():
        if (state.phase == ConferencePhase.connected) {
          state = state.copyWith(phase: ConferencePhase.reconnecting);
        }
      case ConferenceReconnected():
        if (state.phase == ConferencePhase.reconnecting) {
          state = state.copyWith(
            phase: ConferencePhase.connected,
            peers: link.peers,
          );
        }
      case ConferenceDropped(:final end):
        _attempt++;
        _drop().ignore();
        _finish(end);
    }
  }

  /// Mikrofonu aç/kapat; açılamazsa sorun durumda kalır.
  Future<void> toggleMic() async {
    final link = _link;
    if (link == null || !state.inRoom) return;
    final want = !state.micOn;
    final issue = await link.setMicrophone(want);
    if (!ref.mounted || !identical(link, _link)) return;
    state = state.copyWith(
      micOn: issue == null ? want : !want,
      micIssue: () => issue,
      peers: link.peers,
    );
  }

  /// Kamerayı aç/kapat; açılamazsa (izin yok, kamera yok) sorun durumda kalır.
  Future<void> toggleCamera() async {
    final link = _link;
    if (link == null || !state.inRoom) return;
    final want = !state.cameraOn;
    final issue = await link.setCamera(want);
    if (!ref.mounted || !identical(link, _link)) return;
    state = state.copyWith(
      cameraOn: issue == null ? want : !want,
      cameraIssue: () => issue,
      peers: link.peers,
    );
  }

  Future<void> flipCamera() async {
    final link = _link;
    if (link == null || !state.inRoom || !state.cameraOn) return;
    await link.flipCamera();
  }

  /// Sorun bildirimini kapatır (izin açıklaması okundu).
  void dismissIssues() {
    state = state.copyWith(micIssue: () => null, cameraIssue: () => null);
  }

  /// Odadan ayrılır (konferans diğerleri için sürer).
  Future<void> leave() async {
    _attempt++;
    await _drop();
    if (ref.mounted) _finish(ConferenceEnd.left);
  }

  /// Konferansı herkes için bitirir (yalnız `host`; sunucu da denetler, K46) ve odadan çıkar.
  /// Hata varsa oda bağı korunur ve hata döner.
  Future<ApiError?> endForAll() async {
    if (!state.canEnd) return null;
    try {
      await ref.read(meetingsRepositoryProvider).endConference(id);
    } on Object catch (e, st) {
      return toReportedApiError(e, st, source: ReportSource.meetings);
    }
    _attempt++;
    await _drop();
    if (ref.mounted) _finish(ConferenceEnd.endedForAll);
    return null;
  }

  void _finish(ConferenceEnd end) {
    ref.read(activeConferenceControllerProvider.notifier).exit(id);
    state = ConferenceView(
      phase: ConferencePhase.ended,
      end: end,
      role: state.role,
    );
    // Ayrıntı ekranı açıksa konferans durumu ve bağlı kişiler sunucudan yeniden okunur.
    final room = meetingRoomControllerProvider(id);
    if (ref.exists(room)) ref.invalidate(room);
  }

  Future<void> _drop() async {
    final link = _link;
    final sub = _sub;
    _link = null;
    _sub = null;
    await sub?.cancel();
    await link?.leave();
  }
}
