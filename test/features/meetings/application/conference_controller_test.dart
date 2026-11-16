// Görüşme controller'ı (sahte oda bağı + sahte depo): katılım → bağlı, medya sorunları,
// adres/token reddi (bağ kurulmaz), bağlantı hatası, yeniden bağlanma ve kopuş geçişleri,
// ayrılma/bitirme, tek etkin oda ve sağlayıcı atılınca odadan çıkış. Token durumda yoktur.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/config/flavor.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/meetings/application/active_conference.dart';
import 'package:nizamio/features/meetings/application/conference_controller.dart';
import 'package:nizamio/features/meetings/application/meetings_providers.dart';
import 'package:nizamio/features/meetings/domain/conference.dart';
import 'package:nizamio/features/meetings/domain/meeting.dart';
import 'package:nizamio/features/meetings/domain/meetings_repository.dart';

const _secret = 'gizli-token-123';

class _Repo implements MeetingsRepository {
  String url = 'wss://lk.example.test';
  ConferenceRole role = ConferenceRole.speaker;
  DateTime expires = DateTime.utc(2100);
  Object? joinError;
  Object? endError;
  final calls = <String>[];

  @override
  Future<ConferenceJoinToken> joinConference(String meetingId) async {
    calls.add('join:$meetingId');
    if (joinError case final e?) throw e;
    return ConferenceJoinToken(
      token: _secret,
      url: url,
      expiresAt: expires,
      role: role,
    );
  }

  @override
  Future<void> endConference(String meetingId) async {
    calls.add('end:$meetingId');
    if (endError case final e?) throw e;
  }

  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError('$i');
}

class _Link implements ConferenceLink {
  final _signals = StreamController<ConferenceSignal>.broadcast();
  final calls = <String>[];
  Object? connectError;
  MediaIssue? micIssue;
  MediaIssue? camIssue;
  String? token;
  List<ConferencePeer> current = const [
    ConferencePeer(id: 'acc-1', name: 'Muhammet Ali', isLocal: true),
  ];

  void emit(ConferenceSignal s) => _signals.add(s);

  @override
  Stream<ConferenceSignal> get signals => _signals.stream;

  @override
  List<ConferencePeer> get peers => current;

  @override
  Future<void> connect(String url, String token) async {
    calls.add('connect:$url');
    this.token = token;
    if (connectError case final e?) throw e;
  }

  @override
  Future<MediaIssue?> setMicrophone(bool on) async {
    calls.add('mic:$on');
    return on ? micIssue : null;
  }

  @override
  Future<MediaIssue?> setCamera(bool on) async {
    calls.add('cam:$on');
    return on ? camIssue : null;
  }

  @override
  Future<void> flipCamera() async => calls.add('flip');

  @override
  Future<void> leave() async => calls.add('leave');
}

({ProviderContainer c, _Repo repo, List<_Link> links}) _setup({
  Flavor flavor = Flavor.prod,
  void Function(_Link l)? prepare,
}) {
  final repo = _Repo();
  final links = <_Link>[];
  final c = ProviderContainer(
    overrides: [
      flavorProvider.overrideWithValue(flavor),
      meetingsRepositoryProvider.overrideWithValue(repo),
      conferenceLinkFactoryProvider.overrideWithValue(() {
        final l = _Link();
        prepare?.call(l);
        links.add(l);
        return l;
      }),
    ],
  );
  addTearDown(c.dispose);
  return (c: c, repo: repo, links: links);
}

ConferenceController _ctl(ProviderContainer c, [String id = 'm1']) =>
    c.read(conferenceControllerProvider(id).notifier);

ConferenceView _view(ProviderContainer c, [String id = 'm1']) =>
    c.read(conferenceControllerProvider(id));

void main() {
  test(
    'katılım: token bağa gider, bağlı + mikrofon/kamera açık, etkin oda',
    () async {
      final s = _setup();
      await _ctl(s.c).join();
      final v = _view(s.c);
      expect(v.phase, ConferencePhase.connected);
      expect((v.micOn, v.cameraOn), (true, true));
      expect((v.micIssue, v.cameraIssue), (null, null));
      expect(v.peers.single.id, 'acc-1');
      expect(v.canEnd, isFalse, reason: 'speaker bitiremez');
      final l = s.links.single;
      expect(l.token, _secret);
      expect(l.calls, [
        'connect:wss://lk.example.test',
        'mic:true',
        'cam:true',
      ]);
      expect(s.c.read(activeConferenceControllerProvider).inCall, 'm1');
      expect(
        s.c.read(activeConferenceControllerProvider).docked,
        'm1',
        reason: 'ekran açık değil → mini pencere',
      );
    },
  );

  test('izin reddi ve kamera yok: oda sürer, sorunlar durumda', () async {
    final s = _setup(
      prepare: (l) => l
        ..micIssue = MediaIssue.denied
        ..camIssue = MediaIssue.unavailable,
    );
    await _ctl(s.c).join();
    final v = _view(s.c);
    expect(v.phase, ConferencePhase.connected);
    expect((v.micOn, v.cameraOn), (false, false));
    expect(
      (v.micIssue, v.cameraIssue),
      (MediaIssue.denied, MediaIssue.unavailable),
    );
    _ctl(s.c).dismissIssues();
    expect((_view(s.c).micIssue, _view(s.c).cameraIssue), (null, null));
  });

  group('adres ve token reddi: bağ kurulmaz', () {
    for (final (name, flavor, url, ok) in [
      ('prod ws', Flavor.prod, 'ws://192.168.2.7:7880', false),
      ('dev ws özel ağ', Flavor.dev, 'ws://192.168.2.7:7880', true),
      ('dev ws genel adres', Flavor.dev, 'ws://lk.example.com', false),
      ('prod wss', Flavor.prod, 'wss://lk.example.com', true),
    ]) {
      test(name, () async {
        final s = _setup(flavor: flavor);
        s.repo.url = url;
        await _ctl(s.c).join();
        final v = _view(s.c);
        if (ok) {
          expect(v.phase, ConferencePhase.connected);
        } else {
          expect(v.phase, ConferencePhase.failed);
          expect(v.error?.code, ClientErrorCode.conferenceInsecureUrl);
          expect(s.links, isEmpty);
        }
      });
    }

    test('süresi dolmuş token', () async {
      final s = _setup();
      s.repo.expires = DateTime.utc(2000);
      await _ctl(s.c).join();
      expect(_view(s.c).error?.code, ClientErrorCode.conferenceTokenExpired);
      expect(s.links, isEmpty);
    });

    test('sunucu hatası (konferans etkin değil) → hata kodu', () async {
      final s = _setup();
      s.repo.joinError = ApiError('collaboration.conference_not_active');
      await _ctl(s.c).join();
      expect(_view(s.c).phase, ConferencePhase.failed);
      expect(_view(s.c).error?.code, 'collaboration.conference_not_active');
    });
  });

  test('bağlantı hatası: bağ bırakılır, hata metninde token yok', () async {
    final s = _setup(
      prepare: (l) =>
          l.connectError = ApiError(ClientErrorCode.conferenceConnectFailed),
    );
    await _ctl(s.c).join();
    final v = _view(s.c);
    expect(v.phase, ConferencePhase.failed);
    expect(v.error?.code, ClientErrorCode.conferenceConnectFailed);
    expect(v.error.toString(), isNot(contains(_secret)));
    expect(s.links.single.calls.last, 'leave');
    expect(s.c.read(activeConferenceControllerProvider).inCall, isNull);
  });

  test('yeniden bağlanma ve kalıcı kopuş', () async {
    final s = _setup();
    await _ctl(s.c).join();
    final l = s.links.single;
    l.emit(const ConferenceReconnecting());
    await pumpEventQueue();
    expect(_view(s.c).phase, ConferencePhase.reconnecting);
    l.current = [
      ...l.current,
      const ConferencePeer(id: 'acc-2', name: 'Abdullah Ateş', isLocal: false),
    ];
    l.emit(const ConferenceReconnected());
    await pumpEventQueue();
    expect(_view(s.c).phase, ConferencePhase.connected);
    expect(_view(s.c).peers, hasLength(2));
    l.emit(const ConferenceDropped(ConferenceEnd.removed));
    await pumpEventQueue();
    expect(_view(s.c).phase, ConferencePhase.ended);
    expect(_view(s.c).end, ConferenceEnd.removed);
    expect(l.calls.last, 'leave');
    expect(s.c.read(activeConferenceControllerProvider).inCall, isNull);
  });

  test('mikrofon/kamera aç-kapa, çevirme yalnız kamera açıkken', () async {
    final s = _setup();
    await _ctl(s.c).join();
    final l = s.links.single;
    await _ctl(s.c).toggleMic();
    await _ctl(s.c).toggleCamera();
    expect((_view(s.c).micOn, _view(s.c).cameraOn), (false, false));
    await _ctl(s.c).flipCamera();
    expect(l.calls, isNot(contains('flip')));
    l.camIssue = MediaIssue.denied;
    await _ctl(s.c).toggleCamera();
    expect(_view(s.c).cameraOn, isFalse);
    expect(_view(s.c).cameraIssue, MediaIssue.denied);
  });

  test('ayrıl: bağ bırakılır, bitti/left, etkin oda boşalır', () async {
    final s = _setup();
    await _ctl(s.c).join();
    await _ctl(s.c).leave();
    expect(_view(s.c).phase, ConferencePhase.ended);
    expect(_view(s.c).end, ConferenceEnd.left);
    expect(s.links.single.calls.last, 'leave');
    expect(s.c.read(activeConferenceControllerProvider).inCall, isNull);
    expect(s.repo.calls, isNot(contains('end:m1')));
  });

  group('herkes için bitir', () {
    test('speaker: istek gitmez', () async {
      final s = _setup();
      await _ctl(s.c).join();
      expect(await _ctl(s.c).endForAll(), isNull);
      expect(s.repo.calls, isNot(contains('end:m1')));
      expect(_view(s.c).phase, ConferencePhase.connected);
    });

    test('host: bitirir ve odadan çıkar', () async {
      final s = _setup();
      s.repo.role = ConferenceRole.host;
      await _ctl(s.c).join();
      expect(await _ctl(s.c).endForAll(), isNull);
      expect(s.repo.calls, contains('end:m1'));
      expect(_view(s.c).end, ConferenceEnd.endedForAll);
      expect(s.links.single.calls.last, 'leave');
    });

    test('host, sunucu hatası: oda sürer, hata döner', () async {
      final s = _setup();
      s.repo
        ..role = ConferenceRole.host
        ..endError = ApiError('collaboration.not_authorized');
      await _ctl(s.c).join();
      final e = await _ctl(s.c).endForAll();
      expect(e?.code, 'collaboration.not_authorized');
      expect(_view(s.c).phase, ConferencePhase.connected);
      expect(s.links.single.calls.last, isNot('leave'));
    });
  });

  test('tek etkin oda: başka toplantıya katılmak öncekinden ayrılır', () async {
    final s = _setup();
    await _ctl(s.c).join();
    await _ctl(s.c, 'm2').join();
    expect(s.links.first.calls.last, 'leave');
    expect(_view(s.c).end, ConferenceEnd.left);
    expect(_view(s.c, 'm2').phase, ConferencePhase.connected);
    expect(s.c.read(activeConferenceControllerProvider).inCall, 'm2');
  });

  test('ekran açıkken mini pencere yok', () async {
    final s = _setup();
    final active = s.c.read(activeConferenceControllerProvider.notifier);
    active.screen('m1', open: true);
    await _ctl(s.c).join();
    expect(s.c.read(activeConferenceControllerProvider).docked, isNull);
    active.screen('m1', open: false);
    expect(s.c.read(activeConferenceControllerProvider).docked, 'm1');
  });

  test('kap atılınca odadan ayrılınır', () async {
    final s = _setup();
    await _ctl(s.c).join();
    s.c.dispose();
    await pumpEventQueue();
    expect(s.links.single.calls.last, 'leave');
  });
}
