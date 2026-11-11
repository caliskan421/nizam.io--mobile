import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/messages/domain/chat.dart';

void main() {
  test(
    'grup imzası üye sırası/tekrarını normalize eder, kaynak değişimini ayırır',
    () {
      GroupDraft draft({
        String name = 'Saha',
        List<String> members = const ['a', 'b'],
        ChatSource source = ChatSource.none,
        String? department,
      }) => GroupDraft(
        name: name,
        memberIds: members,
        source: source,
        sourceDepartmentId: department,
      );

      final initial = draft();
      expect(
        draft(name: ' Saha ', members: ['b', 'a', 'b']).signature,
        initial.signature,
      );
      expect(
        draft(source: ChatSource.program).signature,
        isNot(initial.signature),
      );
      expect(
        draft(source: ChatSource.department, department: 'd1').signature,
        isNot(draft(source: ChatSource.department, department: 'd2').signature),
      );
      expect(
        draft(members: ['a,b']).signature,
        isNot(initial.signature),
        reason: 'ayraç çakışması yok',
      );
      expect(() => initial.memberIds.add('c'), throwsUnsupportedError);
    },
  );

  test('anket seçenekleri kopyalanır; bitiş aynı an olarak korunur', () {
    final input = ['A', 'B'];
    final closes = DateTime.parse('2026-12-01T12:30:00+03:00');
    final draft = PollDraft(options: input, multi: true, closesAt: closes);
    input[0] = 'Değişti';
    expect(draft.options, ['A', 'B']);
    expect(
      draft.closesAt!.isAtSameMomentAs(DateTime.utc(2026, 12, 1, 9, 30)),
      isTrue,
    );
    expect(() => draft.options.add('C'), throwsUnsupportedError);
  });
}
