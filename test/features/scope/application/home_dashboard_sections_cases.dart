part of 'home_dashboard_controller_test.dart';

class _DelayedDelete extends MemorySecureStore {
  final started = Completer<void>();
  final release = Completer<void>();
  @override
  Future<void> delete(String key) async {
    if (!started.isCompleted) {
      started.complete();
      await release.future;
    }
    await super.delete(key);
  }
}

class _DelayedCatalog extends TaskCatalogController {
  _DelayedCatalog(this.started, this.response);
  final Completer<void> started;
  final Future<TaskCatalog> response;
  @override
  Future<TaskCatalog> build() {
    started.complete();
    return response;
  }
}

void homeDashboardSectionCases() {
  for (final admin in [true, false]) {
    test(
      'katalog beklerken oturum nesli değişirse ${admin ? 'pano' : 'ekip'} isteği başlamaz',
      () async {
        final store = _DelayedDelete();
        final session = SessionController(
          TokenStore(store),
          (_, _) async => throw StateError('unexpected refresh'),
        );
        final scope = ScopeController()..selectProgram('program');
        final started = Completer<void>();
        final catalog = Completer<TaskCatalog>();
        final backend = FakeBackend((_) => envelope(500, 'platform.internal'));
        final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
          ..httpClientAdapter = backend;
        final repo = ApiHomeDashboardRepository(dio, () => 'program');
        final c = ProviderContainer(
          retry: (_, _) => null,
          overrides: [
            sessionControllerProvider.overrideWithValue(session),
            sessionGenerationProvider.overrideWithValue(0),
            scopeControllerProvider.overrideWithValue(scope),
            taskCatalogControllerProvider.overrideWith(
              () => _DelayedCatalog(started, catalog.future),
            ),
            homeDashboardRepositoryProvider.overrideWithValue(repo),
          ],
        );
        addTearDown(c.dispose);
        addTearDown(() {
          if (!catalog.isCompleted) {
            catalog.complete(moduleCatalog(admin: admin, coordinator: true));
          }
          if (!store.release.isCompleted) store.release.complete();
        });
        c.listen(homeDashboardControllerProvider, (_, _) {});
        final pending = c.read(homeDashboardControllerProvider.future);
        await started.future.timeout(const Duration(seconds: 5));
        final clearing = session.clear();
        await store.started.future.timeout(const Duration(seconds: 5));
        catalog.complete(moduleCatalog(admin: admin, coordinator: true));
        await expectLater(
          pending,
          throwsA(
            isA<ApiError>().having(
              (e) => e.code,
              'code',
              ClientErrorCode.scopeChanged,
            ),
          ),
        );
        expect(backend.count('GET', '/v1/me'), 0);
        expect(backend.count('GET', '/v1/reports/dashboard'), 0);
        expect(backend.count('GET', '/v1/me/chat-unread'), 0);
        expect(backend.count('GET', '/v1/date-change-requests/mine'), 0);
        expect(backend.requests, isEmpty);
        store.release.complete();
        await clearing;
      },
    );
  }
  test('eski kapsamın bekleyen sonuçları yeni kapsamda uygulanmaz', () async {
    final repo = _Counting();
    repo.pendingGate = Completer<PendingOverview>();
    repo.pendingStarted = Completer<void>();
    final c = moduleContainer(
      overrides: [homeDashboardRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(c.dispose);
    c.listen(homePendingProvider, (_, _) {});
    final old = c.read(homePendingProvider.future);
    await repo.pendingStarted!.future.timeout(const Duration(seconds: 5));
    c.read(scopeControllerProvider).selectProgram('other');
    repo.pendingGate!.complete(
      const PendingOverview(
        truncated: false,
        items: [
          PendingItem(
            taskCode: 'old',
            title: 'Eski',
            kind: PendingKind.approval,
          ),
        ],
      ),
    );
    await expectLater(old, throwsA(isA<ApiError>()));
    expect(
      c
              .read(homePendingProvider)
              .value
              ?.items
              .any((p) => p.taskCode == 'old') ??
          false,
      isFalse,
    );
    expect(repo.pendingCalls, 1);
  });
  test(
    'temel özet yardımcı uçları beklemez; hata ve tekrar yalnız o bölümdedir',
    () async {
      final repo = _Counting()
        ..pendingGate = Completer<PendingOverview>()
        ..unreadGate = Completer<int>();
      final c = moduleContainer(
        overrides: [homeDashboardRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(c.dispose);
      c.listen(homeDashboardControllerProvider, (_, _) {});
      c.listen(homePendingProvider, (_, _) {});
      c.listen(homeUnreadProvider, (_, _) {});
      expect(
        (await c.read(homeDashboardControllerProvider.future)).greetingName,
        'Yönetici',
      );
      expect(repo.loads, 1);
      expect(c.read(homePendingProvider).isLoading, isTrue);
      repo.unreadGate!.completeError(ApiError('platform.internal'));
      await expectLater(
        c.read(homeUnreadProvider.future),
        throwsA(isA<ApiError>()),
      );
      repo.unreadGate = null;
      c.invalidate(homeUnreadProvider);
      expect(await c.read(homeUnreadProvider.future), 0);
      expect(repo.loads, 1);
      expect(repo.unreadCalls, 2);
      repo.pendingGate!.complete(
        const PendingOverview(items: [], truncated: false),
      );
      expect((await c.read(homePendingProvider.future))!.items, isEmpty);
    },
  );
}
