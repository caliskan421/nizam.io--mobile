// LiveKit bağının karar mantığı: medya hatası sınıfı (izin reddi / aygıt yok / bilinmeyen) ve
// kopuş nedeni → ekrandaki çıkış nedeni. Odasız bağ: medya "yok", ayrılma tekrar çağrılabilir.
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:livekit_client/livekit_client.dart' as lk;
import 'package:nizamio/features/meetings/data/livekit_conference_link.dart';
import 'package:nizamio/features/meetings/domain/conference.dart';

void main() {
  test('medya hatası sınıfı', () {
    expect(
      knownMediaIssue(
        PlatformException(code: 'DOMException', message: 'NotAllowedError'),
      ),
      MediaIssue.denied,
    );
    expect(
      knownMediaIssue(Exception('getUserMedia: DOMException, NotAllowedError')),
      MediaIssue.denied,
    );
    expect(
      knownMediaIssue(
        PlatformException(code: 'DOMException', message: 'NotFoundError'),
      ),
      MediaIssue.unavailable,
    );
    expect(
      knownMediaIssue(Exception('OverconstrainedError')),
      MediaIssue.unavailable,
    );
    expect(knownMediaIssue(StateError('beklenmeyen')), isNull);
    expect(isKnownMediaIssue(StateError('beklenmeyen')), isFalse);
  });

  test('kopuş nedeni', () {
    expect(
      conferenceEndOf(lk.DisconnectReason.clientInitiated),
      ConferenceEnd.left,
    );
    expect(
      conferenceEndOf(lk.DisconnectReason.roomDeleted),
      ConferenceEnd.closed,
    );
    expect(
      conferenceEndOf(lk.DisconnectReason.participantRemoved),
      ConferenceEnd.removed,
    );
    expect(
      conferenceEndOf(lk.DisconnectReason.duplicateIdentity),
      ConferenceEnd.replaced,
    );
    expect(
      conferenceEndOf(lk.DisconnectReason.reconnectAttemptsExceeded),
      ConferenceEnd.lost,
    );
    expect(conferenceEndOf(null), ConferenceEnd.lost);
  });

  test('odasız bağ: medya yok, kişi yok', () async {
    final link = LiveKitConferenceLink();
    expect(link.peers, isEmpty);
    expect(await link.setMicrophone(true), MediaIssue.unavailable);
    expect(await link.setCamera(true), MediaIssue.unavailable);
    await link.flipCamera();
  });
}
