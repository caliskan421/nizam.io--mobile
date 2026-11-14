part of 'task_detail_writes_p3_test.dart';

/// Talep formunu açar ve zorunlu sebebi yazar (sebepsiz talep gönderilmez).
void openWithReason(TaskDetailController ctl, ProviderContainer c) {
  ctl.openDateRequest();
  final d = c.read(taskDetailControllerProvider('w1')).dateDraft!;
  ctl.updateDateDraft(d.copyWith(reason: 'Tedarik gecikti'));
}

void dateRequestCases() {
  dateRequestReasonCases();
  for (final change in ['program', 'department', 'session']) {
    test(
      'geciken conflict_retry ve $change değişiminde ikinci POST gönderilmez',
      () async {
        final s = _Server();
        final (h, c, ctl) = await _open(s);
        final arrived = Completer<void>();
        final release = Completer<void>();
        addTearDown(() {
          if (!release.isCompleted) release.complete();
        });
        h.backend.handler = (r) async {
          if (r.method == 'POST' && r.path == '/v1/date-change-requests') {
            arrived.complete();
            await release.future;
            return envelope(409, 'platform.conflict_retry');
          }
          return s.handle(r);
        };
        openWithReason(ctl, c);
        final request = ctl.submitDateRequest();
        await arrived.future.timeout(const Duration(seconds: 5));
        final scope = h.read(scopeControllerProvider);
        Future<void>? clearing;
        if (change == 'program') {
          scope.selectProgram('prog-2');
        } else if (change == 'department') {
          scope.selectDepartment('d2');
        } else {
          clearing = h.read(sessionControllerProvider).clear();
        }
        release.complete();
        await request;
        await clearing;
        expect(h.backend.count('POST', '/v1/date-change-requests'), 1);
      },
    );
  }
  test('form açılışındaki sürüm katalog değişse de korunur', () async {
    final (h, c, ctl) = await _open(_Server());
    openWithReason(ctl, c);
    c
        .read(taskCatalogControllerProvider.notifier)
        .applyItem('w1', _task(c).copyWith(datesRevision: 2));
    await ctl.submitDateRequest();
    expect(
      (_only(h, 'POST', '/v1/date-change-requests').body!
          as Map)['expected_dates_revision'],
      1,
    );
  });
  test(
    'belirsiz sonuç aynı anahtar ve sürümle yinelenir; 200 başarıdır',
    () async {
      final s = _Server();
      final (h, c, ctl) = await _open(s);
      var calls = 0;
      s.writes['POST /v1/date-change-requests'] = () {
        calls++;
        if (calls == 1) timeout(null);
        return jsonResponse(
          200,
          s._writeBody(Seen('POST', '/v1/date-change-requests', {}, {})),
        );
      };
      openWithReason(ctl, c);
      expect((await ctl.submitDateRequest()).kind, WriteKind.unknown);
      expect((await ctl.submitDateRequest()).ok, isTrue);
      final posts = h.backend.requests
          .where(
            (r) => r.path == '/v1/date-change-requests' && r.method == 'POST',
          )
          .toList();
      expect(posts, hasLength(2));
      expect(posts[0].body, posts[1].body);
      expect(posts[0].header('Idempotency-Key'), isNotEmpty);
      expect(
        posts[0].header('Idempotency-Key'),
        posts[1].header('Idempotency-Key'),
      );
      expect((posts[0].body! as Map)['expected_dates_revision'], 1);
    },
  );
  test('sürüm çakışması yeniden okur ve eski formu kapatır', () async {
    final s = _Server();
    final (h, c, ctl) = await _open(s);
    s.writes['POST /v1/date-change-requests'] = () =>
        envelope(409, 'work.edit_conflict');
    openWithReason(ctl, c);
    expect((await ctl.submitDateRequest()).error?.code, 'work.edit_conflict');
    expect(h.backend.count('POST', '/v1/date-change-requests'), 1);
    expect(h.backend.count('GET', '/v1/work-items/w1'), greaterThan(0));
    expect(c.read(taskDetailControllerProvider('w1')).dateDraft, isNull);
    expect((await ctl.submitDateRequest()).kind, WriteKind.invalid);
  });
  test('başarılı yazma sonrası okuma hatası başarıyı gizlemez', () async {
    final s = _Server();
    final (h, c, ctl) = await _open(s);
    openWithReason(ctl, c);
    s.failDetails = true;
    expect((await ctl.submitDateRequest()).ok, isTrue);
    expect(h.backend.count('POST', '/v1/date-change-requests'), 1);
    expect(h.backend.count('GET', '/v1/work-items/w1'), greaterThan(0));
  });
}

/// Sebepsiz talep istek göndermez; form hatayı gösterir.
void dateRequestReasonCases() {
  test('sebepsiz tarih talebi gönderilmez (ürün kuralı)', () async {
    final (h, c, ctl) = await _open(_Server());
    ctl.openDateRequest();
    expect((await ctl.submitDateRequest()).kind, WriteKind.invalid);
    expect(c.read(taskDetailControllerProvider('w1')).showErrors, isTrue);
    expect(h.backend.count('POST', '/v1/date-change-requests'), 0);
  });
}
