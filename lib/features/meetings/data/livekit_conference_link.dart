import 'dart:async';

import 'package:livekit_client/livekit_client.dart' as lk;
import 'package:meta/meta.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../domain/conference.dart';
import 'screen_capture_channel.dart';

/// [ConferenceLink]'in LiveKit gerçekleştirmesi. Medya NIZAM sunucusundan geçmez; oda adresi
/// ve token `joinConference`'tan gelir. Token yalnız `Room.connect`'e verilir, alanda tutulmaz;
/// bağlantı hatasının ham metni (bağlantı adresini ve token'ı içerebilir) rapora, log'a ve
/// kullanıcıya gitmez (COLLABORATION-K49) — yerine `client.conference_connect_failed`.
/// Kopan bağlantıyı LiveKit kendisi yeniden kurar. Bağlıyken ekran kilitlenmez (wakelock).
/// Ekran paylaşımı: Android'de izin + ön plan servisi ([ScreenCaptureChannel]), iOS'ta ReplayKit
/// yayın uzantısı (`ios/ScreenShare`; seçim penceresi LiveKit'in `BroadcastManager`'ı ile açılır,
/// yayın başlayınca iz kendiliğinden yayımlanır).
class LiveKitConferenceLink implements ConferenceLink {
  final _capture = const ScreenCaptureChannel();
  lk.Room? _room;
  lk.EventsListener<lk.RoomEvent>? _events;
  final _signals = StreamController<ConferenceSignal>.broadcast();
  lk.CameraPosition _position = lk.CameraPosition.front;
  bool _closed = false;

  @override
  Stream<ConferenceSignal> get signals => _signals.stream;

  void _emit(ConferenceSignal s) {
    if (!_signals.isClosed) _signals.add(s);
  }

  @override
  List<ConferencePeer> get peers {
    final room = _room;
    if (room == null) return const [];
    return [
      if (room.localParticipant case final me?) _peer(me, local: true),
      for (final p in room.remoteParticipants.values) _peer(p, local: false),
    ];
  }

  static ConferencePeer _peer(lk.Participant p, {required bool local}) {
    final cam = _video(p, lk.TrackSource.camera);
    return ConferencePeer(
      id: p.identity,
      name: p.name,
      isLocal: local,
      micOn: p.isMicrophoneEnabled(),
      cameraOn: cam != null,
      speaking: p.isSpeaking,
      video: cam,
      screenSharing: p.isScreenShareEnabled(),
      screen: _video(p, lk.TrackSource.screenShareVideo),
    );
  }

  /// Katılımcının [source] kaynaklı, yayındaki (susturulmamış) görüntü izi.
  static lk.VideoTrack? _video(lk.Participant p, lk.TrackSource source) {
    for (final pub in p.videoTrackPublications) {
      final track = pub.track;
      if (pub.source == source && !pub.muted && track != null) {
        return track as lk.VideoTrack;
      }
    }
    return null;
  }

  static lk.VideoTrack? _camera(lk.Participant p) =>
      _video(p, lk.TrackSource.camera);

  @override
  Future<void> connect(String url, String token) async {
    if (_closed || _room != null) {
      throw ApiError(ClientErrorCode.conferenceConnectFailed);
    }
    final room = lk.Room(
      roomOptions: const lk.RoomOptions(
        adaptiveStream: true,
        dynacast: true,
        // iOS: başka uygulamaların ekranı yalnız yayın uzantısıyla yakalanır (Android'de etkisiz).
        defaultScreenShareCaptureOptions: lk.ScreenShareCaptureOptions(
          useiOSBroadcastExtension: true,
        ),
      ),
    );
    _room = room;
    _events = room.createListener()..listen(_onEvent);
    try {
      await room.connect(url, token);
    } on Object catch (_) {
      // Ham hata gizli veri taşıyabilir: raporlanmaz, sabit istemci koduna çevrilir.
      await _teardown();
      throw ApiError(ClientErrorCode.conferenceConnectFailed);
    }
    if (_closed) {
      // Bağlanırken ayrılındı: geç kurulan bağ da kapatılır.
      _room = room;
      await _teardown();
      return;
    }
    await _keepAwake(true);
  }

  void _onEvent(lk.RoomEvent e) {
    if (_closed) return;
    switch (e) {
      case lk.RoomReconnectingEvent() ||
          lk.RoomAttemptReconnectEvent() ||
          lk.RoomResumingEvent():
        _emit(const ConferenceReconnecting());
      case lk.RoomReconnectedEvent():
        _emit(const ConferenceReconnected());
      case lk.RoomDisconnectedEvent(:final reason):
        _emit(ConferenceDropped(conferenceEndOf(reason)));
      case lk.LocalTrackUnpublishedEvent(:final publication)
          when publication.source == lk.TrackSource.screenShareVideo:
        // Paylaşım (sistem denetiminden de) bitti: Android ön plan servisi kapanır.
        _releaseCapture().ignore();
        _emit(const ConferencePeersChanged());
      default:
        _emit(const ConferencePeersChanged());
    }
  }

  @override
  Future<MediaIssue?> setMicrophone(bool on) async {
    final me = _room?.localParticipant;
    if (me == null) return MediaIssue.unavailable;
    try {
      await me.setMicrophoneEnabled(on);
      return null;
    } on Object catch (e, st) {
      reportUnexpected(
        e,
        st,
        source: ReportSource.meetings,
        expected: isKnownMediaIssue,
      );
      return knownMediaIssue(e) ?? MediaIssue.unavailable;
    } finally {
      _emit(const ConferencePeersChanged());
    }
  }

  @override
  Future<MediaIssue?> setCamera(bool on) async {
    final me = _room?.localParticipant;
    if (me == null) return MediaIssue.unavailable;
    try {
      await me.setCameraEnabled(
        on,
        cameraCaptureOptions: lk.CameraCaptureOptions(
          cameraPosition: _position,
        ),
      );
      return null;
    } on Object catch (e, st) {
      reportUnexpected(
        e,
        st,
        source: ReportSource.meetings,
        expected: isKnownMediaIssue,
      );
      return knownMediaIssue(e) ?? MediaIssue.unavailable;
    } finally {
      _emit(const ConferencePeersChanged());
    }
  }

  @override
  Future<bool> screenShareAvailable() => _capture.available();

  @override
  Future<MediaIssue?> setScreenShare(bool on) async {
    final me = _room?.localParticipant;
    if (me == null) return MediaIssue.unavailable;
    try {
      if (on) {
        if (!await _capture.prepare()) return MediaIssue.denied;
        await me.setScreenShareEnabled(true);
      } else {
        await me.setScreenShareEnabled(false);
        await _capture.release();
      }
      return null;
    } on Object catch (e, st) {
      reportUnexpected(
        e,
        st,
        source: ReportSource.meetings,
        expected: isKnownMediaIssue,
      );
      if (on) await _releaseCapture();
      return knownMediaIssue(e) ?? MediaIssue.unavailable;
    } finally {
      _emit(const ConferencePeersChanged());
    }
  }

  Future<void> _releaseCapture() async {
    try {
      await _capture.release();
    } on Object catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.meetings);
    }
  }

  @override
  Future<void> flipCamera() async {
    final me = _room?.localParticipant;
    final track = me == null ? null : _camera(me);
    if (track is! lk.LocalVideoTrack) return;
    final next = _position.switched();
    try {
      await track.setCameraPosition(next);
      _position = next;
    } on Object catch (e, st) {
      // Tek kameralı cihaz (iPad ön kamera dışında): çevirme sessizce yapılmaz.
      reportUnexpected(
        e,
        st,
        source: ReportSource.meetings,
        expected: isKnownMediaIssue,
      );
    }
    _emit(const ConferencePeersChanged());
  }

  @override
  Future<void> leave() async {
    if (_closed) return;
    _closed = true;
    await _teardown();
    await _signals.close();
  }

  Future<void> _teardown() async {
    final room = _room;
    final events = _events;
    _room = null;
    _events = null;
    try {
      await events?.dispose();
      await room?.disconnect();
      await room?.dispose();
    } on Object catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.meetings);
    }
    if (room != null) await _releaseCapture();
    await _keepAwake(false);
  }

  static Future<void> _keepAwake(bool on) async {
    try {
      await (on ? WakelockPlus.enable() : WakelockPlus.disable());
    } on Object catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.meetings);
    }
  }
}

/// Medya açma hatasının bilinen sınıfı: izin reddi (`NotAllowedError`, Android/iOS
/// getUserMedia) ya da aygıt yok/kullanılamaz (`NotFoundError`, `OverconstrainedError`,
/// `NotReadableError`; simülatörde kamera). Bilinmeyen hata null (raporlanır).
@visibleForTesting
MediaIssue? knownMediaIssue(Object e) {
  final s = e.toString();
  if (s.contains('NotAllowedError') ||
      s.contains('Permission') ||
      s.contains('permission')) {
    return MediaIssue.denied;
  }
  if (s.contains('NotFoundError') ||
      s.contains('OverconstrainedError') ||
      s.contains('NotReadableError') ||
      s.contains('No camera') ||
      s.contains('no camera')) {
    return MediaIssue.unavailable;
  }
  return null;
}

/// [knownMediaIssue] sınıflandırabiliyor mu (beklenen durum; raporlanmaz).
bool isKnownMediaIssue(Object e) => knownMediaIssue(e) != null;

/// LiveKit kopuş nedeni → ekrandaki çıkış nedeni.
@visibleForTesting
ConferenceEnd conferenceEndOf(lk.DisconnectReason? reason) => switch (reason) {
  lk.DisconnectReason.clientInitiated => ConferenceEnd.left,
  lk.DisconnectReason.roomDeleted => ConferenceEnd.closed,
  lk.DisconnectReason.participantRemoved => ConferenceEnd.removed,
  lk.DisconnectReason.duplicateIdentity => ConferenceEnd.replaced,
  _ => ConferenceEnd.lost,
};
