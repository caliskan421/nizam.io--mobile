import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/errors/api_error.dart';
import '../../../../core/errors/error_text.dart';
import '../../../../core/providers.dart';
import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/lists/lists.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/nz_size.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../application/chat_members_controller.dart';
import '../../application/chat_room_controller.dart';
import '../../application/messages_providers.dart';
import '../../domain/chat.dart';
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
  showHeader: false,
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
    Widget act(IconData icon, String label, ChatInfoAction a, {Color? color}) =>
        Expanded(
          child: Material(
            color: c.surfaceRaised,
            borderRadius: BorderRadius.circular(NizamioRadius.group),
            child: InkWell(
              onTap: () => done(a),
              borderRadius: BorderRadius.circular(NizamioRadius.group),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    NzIcon(
                      icon,
                      size: NizamioSize.iconSizeSm,
                      color: color ?? c.text,
                    ),
                    const Gap(6),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: t.caption.copyWith(color: color ?? c.text),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
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
        Row(
          spacing: NizamioSpacing.space2,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            act(NzIcons.search, l.uiMessagesSearchChat, ChatInfoAction.search),
            act(NzIcons.attach, l.uiMessagesShared, ChatInfoAction.shared),
            if (chat.canManage)
              act(NzIcons.edit, l.uiMessagesRename, ChatInfoAction.rename),
          ],
        ),
        if (chat.group) ChatGroupSourceInfo(chat: chat),
        if (chat.group)
          _Members(chatId: chatId, chat: chat, me: me, value: members!),
        if (chat.group && mine != null && !mine.fromSource)
          NzButton.secondary(
            label: l.uiMessagesLeaveGroup,
            expand: true,
            onPressed: () => done(ChatInfoAction.leave),
          ),
        if (chat.canManage)
          NzButton.danger(
            label: l.uiMessagesDeleteGroup,
            expand: true,
            onPressed: () => done(ChatInfoAction.delete),
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
    } on ApiError catch (e) {
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
      compact: true,
      builder: (sheet) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (chat.canModerate)
            NzListTile(
              title: admin ? l.uiMessagesRevokeAdmin : l.uiMessagesMakeAdmin,
              onTap: () => Navigator.of(sheet).pop(0),
            ),
          if (!m.fromSource)
            NzListTile(
              title: l.uiMessagesRemoveMember,
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
    final ids = await NzBottomSheet.show<Set<String>>(
      context,
      title: context.l10n.uiMessagesAddMembers,
      builder: (_) => _AddMembers(chatId),
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
  const _AddMembers(this.chatId);

  final String chatId;

  @override
  ConsumerState<_AddMembers> createState() => _AddMembersState();
}

class _AddMembersState extends ConsumerState<_AddMembers> {
  final _picked = <String>{};

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
          for (final c in list.items)
            NzCheckbox(
              label: c.name,
              value: _picked.contains(c.accountId),
              onChanged: (on) => setState(
                () =>
                    on ? _picked.add(c.accountId) : _picked.remove(c.accountId),
              ),
            ),
          if (list.items.isEmpty) Text(l.uiMessagesNoCandidates, style: note),
          if (list.truncated)
            Text(l.uiMessagesCandidatesTruncated, style: note),
          NzButton.primary(
            label: l.uiMessagesAdd,
            expand: true,
            onPressed: _picked.isEmpty
                ? null
                : () => Navigator.of(context).pop({..._picked}),
          ),
        ],
      ),
    );
  }
}

/// Grup adı düzenleme (tek satır, en çok 100 karakter). Değişen ad döner.
Future<String?> showRenameSheet(BuildContext context, String current) =>
    NzBottomSheet.show<String>(
      context,
      title: context.l10n.uiMessagesRename,
      builder: (_) => _Rename(current),
    );

class _Rename extends StatefulWidget {
  const _Rename(this.current);

  final String current;

  @override
  State<_Rename> createState() => _RenameState();
}

class _RenameState extends State<_Rename> {
  late final _name = TextEditingController(text: widget.current);

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final v = _name.text.trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: NizamioSpacing.space3,
      children: [
        NzTextField(
          label: l.uiMessagesGroupName,
          controller: _name,
          onChanged: (_) => setState(() {}),
        ),
        NzButton.primary(
          label: l.uiMessagesSave,
          expand: true,
          onPressed: v.isEmpty || v.length > 100 || v == widget.current
              ? null
              : () => Navigator.of(context).pop(v),
        ),
      ],
    );
  }
}
