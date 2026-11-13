part of 'meeting_room_controller.dart';

/// Toplantı odasının gündem komutları (iyimser güncelleme). Hata `catch` sınırında raporlanıp
/// arayüz hatasına çevrilir ([MeetingRoomController._fail]); davranış `toApiError` ile aynıdır.
extension MeetingRoomAgenda on MeetingRoomController {
  /// Gündem maddesini işaretler/kaldırır (iyimser).
  Future<ApiError?> toggleAgenda(AgendaItem a) async {
    final r = _room;
    if (r == null) return null;
    final now = DateTime.now();
    final optimistic = AgendaItem(
      id: a.id,
      meetingId: a.meetingId,
      title: a.title,
      sortOrder: a.sortOrder,
      isChecked: !a.isChecked,
      createdAt: a.createdAt,
      checkedAt: a.isChecked ? null : now,
      checkedByAccountId: a.isChecked ? null : r.me,
    );
    _agenda(MeetingRoomController._replace(r.detail.agenda, a, optimistic));
    try {
      final saved = await _repo.updateAgendaItem(
        a.id,
        isChecked: optimistic.isChecked,
      );
      final cur = _room;
      if (cur != null) {
        _agenda(
          MeetingRoomController._replace(cur.detail.agenda, optimistic, saved),
        );
      }
      return null;
    } on Object catch (e, st) {
      final cur = _room;
      if (cur != null) {
        _agenda(
          MeetingRoomController._replace(cur.detail.agenda, optimistic, a),
        );
      }
      return toReportedApiError(e, st, source: ReportSource.meetings);
    }
  }

  /// Gündem maddesinin başlığını değiştirir (satır içi düzenleme; iyimser, hatada geri alınır).
  /// Boş ya da aynı başlık istek göndermez.
  Future<ApiError?> renameAgenda(AgendaItem a, String title) async {
    final t = title.trim();
    if (t.isEmpty || t == a.title || _room == null) return null;
    final optimistic = AgendaItem(
      id: a.id,
      meetingId: a.meetingId,
      title: t,
      sortOrder: a.sortOrder,
      isChecked: a.isChecked,
      createdAt: a.createdAt,
      checkedAt: a.checkedAt,
      checkedByAccountId: a.checkedByAccountId,
    );
    _agenda(
      MeetingRoomController._replace(_room!.detail.agenda, a, optimistic),
    );
    try {
      final saved = await _repo.updateAgendaItem(a.id, title: t);
      final cur = _room;
      if (cur != null) {
        _agenda(
          MeetingRoomController._replace(cur.detail.agenda, optimistic, saved),
        );
      }
      return null;
    } on Object catch (e, st) {
      final cur = _room;
      if (cur != null) {
        _agenda(
          MeetingRoomController._replace(cur.detail.agenda, optimistic, a),
        );
      }
      return toReportedApiError(e, st, source: ReportSource.meetings);
    }
  }

  /// Gündem maddesi ekler (1–300 karakter, toplantı başına en çok 50; sunucu denetler).
  Future<ApiError?> addAgenda(String title) async {
    final t = title.trim();
    if (t.isEmpty || _room == null) return null;
    try {
      final item = await _repo.addAgendaItem(id, t);
      final cur = _room;
      if (cur != null) _agenda([...cur.detail.agenda, item]);
      return null;
    } on Object catch (e, st) {
      return toReportedApiError(e, st, source: ReportSource.meetings);
    }
  }

  /// Gündem maddesini siler (silme kalıcıdır; iyimser).
  Future<ApiError?> deleteAgenda(AgendaItem a) async {
    final r = _room;
    if (r == null) return null;
    final before = r.detail.agenda;
    _agenda([
      for (final x in before)
        if (!identical(x, a)) x,
    ]);
    try {
      await _repo.deleteAgendaItem(a.id);
      return null;
    } on Object catch (e, st) {
      _agenda(before);
      return toReportedApiError(e, st, source: ReportSource.meetings);
    }
  }
}
