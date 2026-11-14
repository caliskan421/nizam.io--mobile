// Kendiliğinden kurulan grup (iPad 49): koordinatörlüğün "Mesaj" eşlemesi `auto_department_id`
// ile; korunan grup yönetene de silinemez.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/messages/domain/chat.dart';

Chat _chat(
  String id, {
  bool auto = false,
  String? dept,
  ChatMemberRole? role,
}) => Chat(
  id: id,
  name: id,
  lastActivity: DateTime(2026, 11, 14),
  group: true,
  auto: auto,
  autoDepartmentId: dept,
  role: role,
);

void main() {
  test('departmanın grubu auto_department_id ile bulunur; yoksa null', () {
    final inbox = ChatInbox(
      chats: [
        _chat('g1'),
        _chat('g2', auto: true, dept: 'd1'),
        _chat('g3', auto: true, dept: 'd2'),
      ],
    );
    expect(inbox.departmentGroup('d2')?.id, 'g3');
    expect(inbox.departmentGroup('d9'), isNull);
  });

  test('kendiliğinden grup silinemez; elle kurulan yöneten silebilir', () {
    expect(
      _chat('a', auto: true, role: ChatMemberRole.admin).canDelete,
      isFalse,
    );
    expect(_chat('b', role: ChatMemberRole.admin).canDelete, isTrue);
    expect(_chat('c', role: ChatMemberRole.admin).copyWith().canDelete, isTrue);
    expect(
      _chat('d', auto: true, dept: 'd1').copyWith(unread: 1).autoDepartmentId,
      'd1',
    );
  });
}
