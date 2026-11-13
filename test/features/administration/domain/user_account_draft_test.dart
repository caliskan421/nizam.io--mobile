// Kullanıcı hesabı taslağı: en az bir rol yoksa kaydedilemez (iPad notu 25, istemci kuralı).
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/administration/domain/user_account_draft.dart';
import 'package:nizamio/features/scope/scope.dart';

UserAccountDraft _draft({
  bool? admin,
  List<AccountTeamDraft> teams = const [],
}) {
  final base = AccountDraftValues(
    fullName: 'Ada',
    email: 'ada@x.io',
    companyAdmin: true,
    teams: const [],
  );
  return UserAccountDraft(
    base: base,
    value: base.copyWith(companyAdmin: () => admin, teams: teams),
  );
}

void main() {
  test('admin değil ve koordinatörlük yok → rol yok, kaydedilemez', () {
    final d = _draft(admin: false);
    expect(d.valid, isTrue);
    expect(d.hasRole, isFalse);
    expect(d.savable, isFalse);
  });

  test('admin ya da bir koordinatörlükte rol yeterli', () {
    expect(_draft(admin: true).savable, isTrue);
    expect(
      _draft(
        admin: false,
        teams: const [
          AccountTeamDraft(departmentId: 'd1', role: DepartmentRole.member),
        ],
      ).savable,
      isTrue,
    );
  });

  test('admin bilgisi bilinmiyorsa engellenmez', () {
    expect(_draft().hasRole, isTrue);
  });
}
