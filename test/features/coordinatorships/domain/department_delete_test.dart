// Silme karar mantığı: onay ifadesi (kod yoksa ad) ve eşleşme, 409 engel alanları, diğer
// programlar süzgeci.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/coordinatorships/domain/department_delete.dart';

DepartmentImpactProgram _p(
  String id, {
  bool linked = true,
  int active = 0,
  int done = 0,
}) => DepartmentImpactProgram(
  programId: id,
  linked: linked,
  activeItems: active,
  completedItems: done,
  deletedItems: 0,
  deletedWithDepartment: 0,
);

void main() {
  test('onay ifadesi: kod varsa kod, yoksa ad', () {
    expect(deleteConfirmPhrase(code: 'ALT', name: 'Altyapı'), 'ALT');
    expect(deleteConfirmPhrase(code: ' ', name: ' Altyapı '), 'Altyapı');
    expect(deleteConfirmPhrase(name: 'Altyapı'), 'Altyapı');
  });

  test('eşleşme: boşluk ve büyüklük yok sayılır; eksik/fazla eşleşmez', () {
    expect(deleteConfirmMatches(' alt ', code: 'ALT', name: 'x'), isTrue);
    expect(deleteConfirmMatches('AL', code: 'ALT', name: 'x'), isFalse);
    expect(deleteConfirmMatches('ALTT', code: 'ALT', name: 'x'), isFalse);
    expect(deleteConfirmMatches('x', code: 'ALT', name: 'x'), isFalse);
    expect(
      deleteConfirmMatches('İDARİ İŞLER', name: 'İdari işler'),
      isTrue,
      reason: 'Türkçe İ/i',
    );
    expect(deleteConfirmMatches('', name: ' '), isFalse);
  });

  test('409 department_in_use alanları → engel sayıları', () {
    final b = DepartmentPermanentBlockers.fromFields(const [
      ApiFieldError(
        field: 'tables',
        code: 'organization.department_usage',
        message: '2',
      ),
      ApiFieldError(
        field: 'pending_proposals',
        code: 'organization.department_usage',
        message: '1',
      ),
      ApiFieldError(field: 'other', code: 'x', message: '9'),
      ApiFieldError(field: 'projects', code: 'x', message: 'çok'),
    ]);
    expect((b.tables, b.projects, b.pendingProposals), (2, 0, 1));
    expect(b.any, isTrue);
    expect(DepartmentPermanentBlockers.fromFields(const []).any, isFalse);
  });

  test('diğer programlar: seçili program ve boş bağsız satır dışarıda', () {
    final impact = DepartmentDeleteImpact(
      departmentId: 'd',
      name: 'D',
      deleted: false,
      programs: [
        _p('p1', active: 1),
        _p('p2', done: 2),
        _p('p3', linked: false),
        _p('p4', linked: false, active: 1),
      ],
      activeItems: 2,
      completedItems: 2,
      deletedItems: 3,
      deletedWithDepartment: 0,
      fileCount: 0,
      memberCount: 0,
      meetingCount: 0,
      blockers: const DepartmentPermanentBlockers(),
      permanentBlocked: false,
    );
    expect(
      [for (final p in impact.otherPrograms('p1')) p.programId],
      ['p2', 'p4'],
    );
    expect(impact.liveItems, 4);
    expect(impact.allItems, 7);
  });
}
