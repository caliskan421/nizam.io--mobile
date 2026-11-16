import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/turkish_collation.dart';
import '../../../../core/errors/api_error.dart';
import '../../../../core/errors/error_text.dart';
import '../../../../core/providers.dart';
import '../../../../core/telemetry/report_source.dart';
import '../../../../core/telemetry/unexpected_error.dart';
import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/inputs/nz_filter_choice.dart';
import '../../../../core/ui/widgets/lists/lists.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/nz_size.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../application/chat_members_controller.dart';
import '../../application/chat_room_controller.dart';
import '../../application/messages_providers.dart';
import '../../domain/chat.dart';
import 'chat_compose_lifetime.dart';
import 'chat_group_source_info.dart';
import 'messages_texts.dart';

/// Sohbet bilgisinin ekrana dönen seçimi (sayfa kapandıktan sonra ekran uygular).
enum ChatInfoAction { search, shared, rename, leave, delete }

/// Sohbet bilgisi: büyük avatar, ad, alt satır; Ara, Paylaşılanlar; grupta yönetici/kurucuya
/// Adı değiştir ve Grubu sil, kaynaktan gelmeyen üyeye Gruptan ayrıl. Grupta üye listesi (rol,
/// kaynak), yönetici/kurucuya Üye ekle ve üye işlemleri (çıkar; yöneticiye yönetici yap/al).
/// Üye işlemleri sayfada uygulanır; diğerleri sonuç olarak döner.
Future<ChatInfoAction?> showChatInfo(
  BuildContext context, {
  required String chatId,
}) => NzBottomSheet.show<ChatInfoAction>(
  context,
  title: context.l10n.uiMessagesInfo,
  builder: (_) => _ChatInfo(chatId),
);

class _ChatInfo extends ConsumerWidget {
  const _ChatInfo(this.chatId);

  final String chatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final roomValue = ref.watch(chatRoomControllerProvider(chatId));
    if (roomValue.isLoading) return const NzLoader();
    if (roomValue.error case final e?) {
      return NzErrorState(
        error: toApiError(e),
        onRetry: () => ref.invalidate(chatRoomControllerProvider(chatId)),
      );
    }
    final room = roomValue.value;
    if (room == null) return const NzLoader();
    final chat = room.chat;
    final me = ref.watch(chatMeProvider);
    final members = chat.group
        ? ref.watch(chatMembersControllerProvider(chatId))
        : null;
    final mine =
        me == null || members?.isLoading == true || members?.hasError == true
        ? null
        : members?.value?.member(me);
    void done(ChatInfoAction a) => Navigator.of(context).pop(a);
    final sub = l.chatSubtitle(room, DateTime.now());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: NizamioSpacing.space4,
      children: [
        Column(
          spacing: 6,
          children: [
            NzChatAvatar(
              initials: chatInitials(chat.name),
              group: chat.group,
              tone: chat.group ? 0 : personTone(chat.name),
              extent: 84,
            ),
            Text(chat.name, textAlign: TextAlign.center, style: t.titleSm),
            if (sub.isNotEmpty)
              Text(
                sub,
                textAlign: TextAlign.center,
                style: t.caption.copyWith(color: c.textMuted),
              ),
          ],
        ),
        NzMenuGroup(
          rows: [
            NzMenuRow(
              icon: NzIcons.search,
              label: l.uiMessagesSearchChat,
              onTap: () => done(ChatInfoAction.search),
            ),
            NzMenuRow(
              icon: NzIcons.attach,
              label: l.uiMessagesShared,
              onTap: () => done(ChatInfoAction.shared),
            ),
            if (chat.canManage)
              NzMenuRow(
                icon: NzIcons.edit,
                label: l.uiMessagesRename,
                onTap: () => done(ChatInfoAction.rename),
              ),
          ],
        ),
        if (chat.group) ChatGroupSourceInfo(chat: chat),
        if (chat.group)
          _Members(chatId: chatId, chat: chat, me: me, value: members!),
        if ((chat.group && mine != null && !mine.fromSource) || chat.canDelete)
          NzMenuGroup(
            rows: [
              if (chat.group && mine != null && !mine.fromSource)
                NzMenuRow(
                  icon: NzIcons.close,
                  label: l.uiMessagesLeaveGroup,
                  danger: true,
                  onTap: () => done(ChatInfoAction.leave),
                ),
              if (chat.canDelete)
                NzMenuRow(
                  icon: NzIcons.delete,
                  label: l.uiMessagesDeleteGroup,
                  danger: true,
                  onTap: () => done(ChatInfoAction.delete),
                ),
            ],
          ),
      ],
    );
  }
}

/// Üye listesi ve üye işlemleri.
class _Members extends ConsumerWidget {
  const _Members({
    required this.chatId,
    required this.chat,
    required this.me,
    required this.value,
  });

  final String chatId;
  final Chat chat;
  final String? me;
  final AsyncValue<ChatMembers> value;

  ChatMembersController _ctl(WidgetRef ref) =>
      ref.read(chatMembersControllerProvider(chatId).notifier);

  Future<void> _run(BuildContext context, Future<void> Function() op) async {
    try {
      await op();
    } on ApiError catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.messages);
      if (context.mounted) NzToast.show(context, errorText(context.l10n, e));
    }
  }

  Future<void> _memberMenu(
    BuildContext context,
    WidgetRef ref,
    ChatMember m,
  ) async {
    final l = context.l10n;
    final program = ref.read(scopeStateProvider).programId;
    final session = ref.read(sessionGenerationProvider);
    final admin = m.role == ChatMemberRole.admin;
    final pick = await NzBottomSheet.show<int>(
      context,
      title: m.name,
      builder: (sheet) => NzMenuGroup(
        rows: [
          if (chat.canModerate)
            NzMenuRow(
              icon: NzIcons.person,
              label: admin ? l.uiMessagesRevokeAdmin : l.uiMessagesMakeAdmin,
              onTap: () => Navigator.of(sheet).pop(0),
            ),
          if (!m.fromSource)
            NzMenuRow(
              icon: NzIcons.delete,
              label: l.uiMessagesRemoveMember,
              danger: true,
              onTap: () => Navigator.of(sheet).pop(1),
            ),
        ],
      ),
    );
    if (!context.mounted ||
        pick == null ||
        ref.read(scopeStateProvider).programId != program ||
        ref.read(sessionGenerationProvider) != session) {
      return;
    }
    await _run(
      context,
      () => pick == 0
          ? _ctl(ref).setAdmin(m.accountId, admin: !admin)
          : _ctl(ref).remove(m.accountId),
    );
  }

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final program = ref.read(scopeStateProvider).programId;
    final session = ref.read(sessionGenerationProvider);
    final selected = ValueNotifier<Set<String>>({});
    final ids = await NzBottomSheet.show<Set<String>>(
      context,
      title: context.l10n.uiMessagesAddMembers,
      builder: (_) => _AddMembers(chatId, selected),
      actions: (sheet) => [
        NzButton.secondary(
          label: sheet.l10n.uiMessagesCancel,
          expand: true,
          onPressed: () => Navigator.of(sheet).pop(),
        ),
        ValueListenableBuilder<Set<String>>(
          valueListenable: selected,
          builder: (_, ids, _) => NzButton.primary(
            label: sheet.l10n.uiMessagesAdd,
            expand: true,
            onPressed: ids.isEmpty ? null : () => Navigator.of(sheet).pop(ids),
          ),
        ),
      ],
    );
    if (!context.mounted ||
        ids == null ||
        ids.isEmpty ||
        ref.read(scopeStateProvider).programId != program ||
        ref.read(sessionGenerationProvider) != session) {
      return;
    }
    await _run(context, () => _ctl(ref).add(ids));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    if (value.isLoading) return const NzLoader();
    if (value.error case final e?) {
      return NzErrorState(
        error: toApiError(e),
        onRetry: () => ref.invalidate(chatMembersControllerProvider(chatId)),
      );
    }
    final list = value.value;
    if (list == null) return const NzLoader();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        NzListTile(
          title: '${l.uiMessagesMembers} (${list.items.length})',
          trailing: chat.canManage
              ? NzIconButton(
                  icon: NzIcons.personAdd,
                  semanticLabel: l.uiMessagesAddMembers,
                  size: NzSize.sm,
                  onPressed: () => _add(context, ref),
                )
              : null,
        ),
        for (final m in list.items)
          NzListTile(
            title: m.accountId == me
                ? '${m.name} (${l.uiMessagesYou})'
                : m.name,
            subtitle: l.memberRole(m).isEmpty ? null : l.memberRole(m),
            leading: NzChatAvatar(
              initials: chatInitials(m.name),
              tone: personTone(m.name),
              extent: 34,
            ),
            trailing:
                m.accountId != me &&
                    (chat.canModerate || (chat.canManage && !m.fromSource))
                ? NzIconButton(
                    icon: NzIcons.more,
                    semanticLabel: m.name,
                    size: NzSize.sm,
                    onPressed: () => _memberMenu(context, ref, m),
                  )
                : null,
          ),
        if (list.truncated)
          Text(
            l.uiMessagesCandidatesTruncated,
            style: context.text.caption.copyWith(
              color: context.colors.textMuted,
            ),
          ),
      ],
    );
  }
}

/// Üye ekleme: gruba eklenebilecek adaylardan çoklu seçim.
class _AddMembers extends ConsumerStatefulWidget {
  const _AddMembers(this.chatId, this.selected);

  final String chatId;
  final ValueNotifier<Set<String>> selected;

  @override
  ConsumerState<_AddMembers> createState() => _AddMembersState();
}

class _AddMembersState extends ConsumerState<_AddMembers> {
  final _picked = <String>{};
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    widget.selected.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final value = ref.watch(chatAddCandidatesProvider(widget.chatId));
    if (value.isLoading) return const NzLoader();
    if (value.error case final e?) {
      return NzErrorState(
        error: toApiError(e),
        onRetry: () => ref.invalidate(chatAddCandidatesProvider(widget.chatId)),
      );
    }
    final list = value.value;
    if (list == null) return const NzLoader();
    final note = context.text.caption.copyWith(color: context.colors.textMuted);
    // Onay satırı (ListTile) mürekkebini en yakın Material'e çizer; sayfa yüzeyi Material değil.
    return Material(
      type: MaterialType.transparency,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: NizamioSpacing.space1,
        children: [
          NzSearchField(
            label: l.uiInputsSearch,
            controller: _search,
            onChanged: (_) => setState(() {}),
          ),
          NzFilterChoices(
            children: [
              for (final c in list.items)
                if (trLower(c.name).contains(trLower(_search.text.trim())))
                  NzFilterChoice(
                    label: c.name,
                    selected: _picked.contains(c.accountId),
                    onTap: () => setState(() {
                      if (!_picked.add(c.accountId)) {
                        _picked.remove(c.accountId);
                      }
                      widget.selected.value = {..._picked};
                    }),
                  ),
            ],
          ),
          if (list.items.isEmpty) Text(l.uiMessagesNoCandidates, style: note),
          if (list.truncated)
            Text(l.uiMessagesCandidatesTruncated, style: note),
        ],
      ),
    );
  }
}

/// Grup adı düzenleme (tek satır, en çok 100 karakter). Değişen ad döner.
Future<String?> showRenameSheet(BuildContext context, String current) async {
  final name = TextEditingController(text: current);
  final result = await NzBottomSheet.show<String>(
    context,
    title: context.l10n.uiMessagesRename,
    builder: (_) => ChatComposeLifetime(
      onDispose: name.dispose,
      child: NzTextField(
        label: context.l10n.uiMessagesGroupName,
        controller: name,
        maxLength: 100,
      ),
    ),
    actions: (sheet) => [
      NzButton.secondary(
        label: sheet.l10n.uiMessagesCancel,
        expand: true,
        onPressed: () => Navigator.of(sheet).pop(),
      ),
      ValueListenableBuilder<TextEditingValue>(
        valueListenable: name,
        builder: (_, value, _) {
          final text = value.text.trim();
          return NzButton.primary(
            label: sheet.l10n.uiMessagesSave,
            expand: true,
            onPressed: text.isEmpty || text.length > 100 || text == current
                ? null
                : () => Navigator.of(sheet).pop(text),
          );
        },
      ),
    ],
  );
  return result;
}
