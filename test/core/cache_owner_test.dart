// Önbellek sahipliği: değer yalnız okunduğu oturum nesli + program + rol + koordinatörlük
// için gösterilir (katalog için yalnız oturum + program); sahip
// değişince önceki değer düşer (yükleniyor ya da yalnız hata), geç gelen eski okuma sahiplik
// yazmaz.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/cache_owner.dart';
import 'package:nizamio/core/domain/effective_role.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';

void main() {
  test('sahip değişince değer düşer; aynı sahipte korunur', () {
    var session = 1;
    String? program = 'p1';
    final c = ProviderContainer(
      overrides: [
        sessionGenerationProvider.overrideWith((ref) => session),
        scopeStateProvider.overrideWith(
          (ref) => ScopeSelection(programId: program),
        ),
      ],
    );
    addTearDown(c.dispose);
    final own = CacheOwnership();
    late Ref ref;
    final probe = Provider<CacheOwner>((r) {
      ref = r;
      return own.watch(r);
    });
    final owner = c.read(probe);
    const data = AsyncData(1);
    expect(own.visible(ref, data).hasValue, isFalse, reason: 'hiç okunmadı');

    own.markLoaded(ref, owner);
    expect(own.visible(ref, data), same(data));

    session = 2;
    c.invalidate(sessionGenerationProvider);
    expect(c.read(probe), (
      session: 2,
      program: 'p1',
      department: null,
      role: null,
    ));
    expect(own.owns(ref), isFalse);
    expect(own.visible(ref, data).isLoading, isTrue);
    const err = AsyncError<int>('x', StackTrace.empty);
    final shown = own.visible(ref, err);
    expect((shown.hasError, shown.hasValue), (true, false));

    // Okuma sürerken sahip değişti: eski okuma sahiplik yazmaz.
    program = 'p2';
    c.invalidate(scopeStateProvider);
    own.markLoaded(ref, (
      session: 2,
      program: 'p1',
      department: null,
      role: null,
    ));
    expect(own.owns(ref), isFalse);
  });

  test('rol ya da koordinatörlük değişince düşer; programWide yalnız programa bakar', () {
    var selection = const ScopeSelection(programId: 'p1');
    final c = ProviderContainer(
      overrides: [
        sessionGenerationProvider.overrideWith((ref) => 1),
        scopeStateProvider.overrideWith((ref) => selection),
      ],
    );
    addTearDown(c.dispose);
    final view = CacheOwnership();
    final wide = CacheOwnership.programWide();
    late Ref ref;
    final probe = Provider<(CacheOwner, CacheOwner)>((r) {
      ref = r;
      return (view.watch(r), wide.watch(r));
    });
    final (a, b) = c.read(probe);
    view.markLoaded(ref, a);
    wide.markLoaded(ref, b);

    selection = const ScopeSelection(
      programId: 'p1',
      role: EffectiveRole.coordinator,
      departmentId: 'd1',
    );
    c.invalidate(scopeStateProvider);
    c.read(probe);
    expect(view.owns(ref), isFalse);
    expect(wide.owns(ref), isTrue);
    expect(view.current(ref).role, EffectiveRole.coordinator);
    expect(view.current(ref).department, 'd1');
    expect(wide.current(ref).role, isNull);
  });
}
