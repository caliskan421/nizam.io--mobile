part of 'home_dashboard_controller_test.dart';

void homeDashboardSectionCases() {
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
