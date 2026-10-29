// Sohbet kuralları: parçalama, atıflar, akış öğeleri, süzgeç, öneriler.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/messages/data/sample/sample_chat_repository.dart';
import 'package:nizamio/features/messages/domain/chat.dart';
import 'package:nizamio/features/messages/domain/chat_logic.dart';
import 'package:nizamio/features/tasks/data/sample/sample_task_catalog_repository.dart';

void main() {
  test('bahsetme ve görev atfı parçaları; atıflar', () async {
    final cat = await SampleTaskCatalogRepository().load();
    final box = await const SampleChatRepository().load();
    final names = mentionNames(cat, box.people);
    final m3 = box.chat('gen')!.message('m3')!;
    final toks = tokenize(m3.text, names);
    expect(toks.first.kind, ChatTokenKind.mention);
    expect(toks.first.text, '@Altyapı ve tesisat');
    expect(
      toks.where((t) => t.kind == ChatTokenKind.task).single.text,
      '#ALT-7',
    );
    expect(tokenize('@Muhammet Ali trafo', names).first.text, '@Muhammet Ali');
    expect(refsOf(m3, cat).map((r) => r.kind), [
      ChatRefKind.task,
      ChatRefKind.coordinatorship,
    ]);
    final m2 = box.chat('gen')!.message('m2')!;
    expect(extraRefs(m2, cat).single.id, 'Vardiya_taslak.xlsx');
    expect(sharedRefs(box.chat('gen')!, cat), hasLength(5));
  });

  test('akış: gün hapları, okunmamış ayırıcısı, ardışık gruplar', () async {
    final box = await const SampleChatRepository().load();
    final gen = box.chat('gen')!;
    final opened = gen.copyWith(unreadMarker: () => unreadMarkerOf(gen));
    final items = timeline(opened);
    expect(items.whereType<ChatDayItem>(), hasLength(2));
    final iNew = items.indexWhere((i) => i is ChatNewItem);
    expect((items[iNew + 1] as ChatMessageItem).message.id, 'm3');
    final m4 = items.whereType<ChatMessageItem>().firstWhere(
      (i) => i.message.id == 'm4',
    );
    final m5 = items.whereType<ChatMessageItem>().firstWhere(
      (i) => i.message.id == 'm5',
    );
    expect((m4.first, m4.last, m5.first, m5.last), (true, false, false, true));
    expect(unreadMarkerOf(box.chat('hid')!), 'h2');
    expect(unreadMarkerOf(box.chat('sis')!), isNull);
  });

  test('süzgeç ve arama; öneriler', () async {
    final cat = await SampleTaskCatalogRepository().load();
    final box = await const SampleChatRepository().load();
    expect(visibleChats(box.chats, filter: ChatFilter.unread), hasLength(4));
    expect(visibleChats(box.chats, filter: ChatFilter.people), hasLength(3));
    expect(visibleChats(box.chats, filter: ChatFilter.groups), hasLength(5));
    expect(visibleChats(box.chats, query: 'TRAFO').map((c) => c.id), [
      'koord',
      'reha',
    ]);
    final tasks = suggestions('Bak #alt', cat, box.people);
    expect(tasks, hasLength(6));
    expect(tasks.first.draft, 'Bak #${tasks.first.key} ');
    final people = suggestions('@kad', cat, box.people);
    expect(people.single.draft, '@Kadir Özbek ');
    expect(suggestions('@', cat, box.people).first.label, 'herkes');
    expect(suggestions('düz metin', cat, box.people), isEmpty);
  });
}
