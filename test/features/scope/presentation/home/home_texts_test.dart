import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/features/scope/domain/home_dashboard.dart';
import 'package:nizamio/features/scope/presentation/home/home_texts.dart';

void main() {
  final l = AppLocalizationsTr();

  test('iyelik eki okunuşa göre', () {
    final cases = {39: "'u", 38: "'i", 2: "'si", 6: "'sı", 3: "'ü", 40: "'ı"};
    cases.forEach((n, s) => expect(HomeTexts.possessive(n), s, reason: '$n'));
    expect(HomeTexts.possessive(20), "'si");
    expect(HomeTexts.possessive(100), "'ü");
    expect(HomeTexts.possessive(0), "'ı");
  });

  test('KPI alt yazıları kaynakla aynı', () {
    const t = TaskTotals(
      total: 79,
      done: 39,
      inProgress: 40,
      inProgressOnTime: 25,
      late: 15,
      awaitingApproval: 3,
    );
    expect(l.kpiDoneCaption(t), "79 görevin 39'u bitti");
    expect(l.kpiLateCaption(t), "Açık görevlerin %38'i");
  });
}
