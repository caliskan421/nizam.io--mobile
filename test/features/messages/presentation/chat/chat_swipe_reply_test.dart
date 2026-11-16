import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/messages/presentation/chat/chat_swipe_reply.dart';

import '../../../../core/ui/widgets/feedback/feedback_test_support.dart';

void main() {
  setUpFonts();

  Future<int> drag(
    WidgetTester tester,
    double dx, {
    bool enabled = true,
  }) async {
    var replies = 0;
    await tester.pumpWidget(
      testApp(
        ChatSwipeReply(
          onReply: enabled ? () => replies++ : null,
          child: const SizedBox(width: 300, height: 60, child: Text('mesaj')),
        ),
      ),
    );
    await tester.drag(find.text('mesaj'), Offset(dx, 0));
    await tester.pumpAndSettle();
    return replies;
  }

  testWidgets('eşiği geçen sağa kaydırma bir kez yanıtlar', (tester) async {
    expect(await drag(tester, 120), 1);
  });

  testWidgets('kısa ya da sola kaydırma yanıtlamaz; kapalıyken kaydırma yok', (
    tester,
  ) async {
    expect(await drag(tester, 30), 0);
    expect(await drag(tester, -120), 0);
    expect(await drag(tester, 120, enabled: false), 0);
  });
}
