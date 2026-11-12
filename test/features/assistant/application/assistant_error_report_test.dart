// Asistan denetleyicisi: eşleme TypeError'ı (apiCall dışı) ve akış dinleyici hatası arayüz hatasına
// çevrilmeden ÖNCE raporlanır; arayüz durumu aynı kalır; beklenen hata 0 rapor.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/telemetry/error_report.dart';
import 'package:nizamio/core/telemetry/error_reporting.dart';
import 'package:nizamio/core/telemetry/report_source.dart';
import 'package:nizamio/features/assistant/application/assistant_controller.dart';
import 'package:nizamio/features/assistant/domain/assistant.dart';
import 'package:nizamio/features/assistant/domain/assistant_repository.dart';

import '../../../support/fake_error_reporter.dart';
import '../../connected_module_support.dart';

class _Repo implements AssistantRepository {
  Object? detailError;
  // ignore: close_sinks
  final events = StreamController<AssistantEvent>();

  @override
  Stream<AssistantEvent> chat(AssistantQuestion question) => events.stream;

  @override
  Future<AssistantConversationDetail> getConversation(String id) =>
      Future.error(detailError!);

  @override
  Future<PageSlice<AssistantConversation>> listConversations() async =>
      PageSlice.empty();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeErrorReporter sdk;
  late _Repo repo;

  setUp(() {
    sdk = FakeErrorReporter();
    ErrorReporting.reset();
    ErrorReporting.attach(sdk).setEnabled(true);
    repo = _Repo();
  });
  tearDown(() {
    ErrorReporting.reset();
    repo.events.close();
  });

  AssistantChat setup() {
    final c = moduleContainer(
      overrides: [assistantRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(c.dispose);
    c.listen(assistantChatProvider, (_, _) {});
    return AssistantChat(c);
  }

  test(
    'sohbet açılırken eşleme TypeError: arayüz invalid_response, TEK rapor',
    () async {
      repo.detailError = TypeError();
      final chat = setup();
      await chat.controller.open('s1');
      expect(chat.state.error?.code, ClientErrorCode.invalidResponse);
      expect(sdk.reports, hasLength(1));
      final r = sdk.reports.single;
      expect(r.source, ReportSource.assistant);
      expect(r.operation, ReportOperation.assistantChat);
      expect(r.errorType, ReportErrorType.typeError);
    },
  );

  test(
    'akış dinleyici hatası (ApiError dışı) raporlanır; soru metni girmez',
    () async {
      final chat = setup();
      chat.controller.send('Ali Veli maaşı ne kadar?');
      repo.events.addError(StateError('Ali Veli maaşı'));
      await Future<void>.delayed(Duration.zero);
      expect(chat.state.error?.code, ClientErrorCode.invalidResponse);
      expect(sdk.reports, hasLength(1));
      final r = sdk.reports.single;
      final wire = '${r.label}\n${r.message}\n${r.stack}';
      expect(wire, isNot(contains('Ali')));
      expect(wire, isNot(contains('maaş')));
    },
  );

  test('beklenen hata (kota/meşgul) rapor üretmez', () async {
    repo.detailError = ApiError('assistant.busy', status: 429);
    final chat = setup();
    await chat.controller.open('s1');
    expect(chat.state.error?.code, 'assistant.busy');
    expect(sdk.reports, isEmpty);
  });
}

/// Test kısayolu: denetleyici ve güncel durum.
class AssistantChat {
  AssistantChat(this._c);
  final ProviderContainer _c;
  AssistantController get controller => _c.read(assistantChatProvider.notifier);
  AssistantChatState get state => _c.read(assistantChatProvider);
}
