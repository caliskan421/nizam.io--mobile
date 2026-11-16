import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/audit_client.dart';
import '../../../core/api/generated/models/audit_entry.dart' as api;
import '../../../core/api/generated/models/audit_entry_outcome.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../domain/activity_log.dart';

/// İşlem geçmişi (`GET /v1/audit/entries`, S1; AUDIT-K10): yalnız şirket yöneticisi okur.
/// Sayfa sayfa ([pageSize] kayıt, yeniden eskiye, `next_cursor`) okunur; süzgeç istemcide.
/// 403 `audit.not_authorized` → [ActivityUnavailable] (bölüm kapalı; hata sayılmaz).
class ApiActivityLogRepository implements ActivityLogRepository {
  /// [dio]: doğrulanmış bağın güncel API istemcisi; bağ yoksa null →
  /// `client.server_not_verified`. İstek anında okunur (bağ değişebilir).
  ApiActivityLogRepository(this._dio, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final Dio? Function() _dio;
  final DateTime Function() _now;

  /// Sunucu sayfa tavanı (1–200).
  static const pageSize = 200;

  AuditClient get _client {
    final d = _dio();
    if (d == null) throw ApiError(ClientErrorCode.serverNotVerified);
    return AuditClient(d);
  }

  @override
  Future<ActivityLog> load({String? actorAccountId, String? cursor}) async {
    try {
      final r = await apiCall(
        () => _client.listAuditEntries(
          limit: pageSize,
          actorAccountId: actorAccountId,
          cursor: cursor,
        ),
      );
      final entries = [for (final e in r.entries) _entryOf(e)];
      return ActivityLog(
        today: _now(),
        entries: entries,
        people: {
          for (final e in entries)
            if (e.actorId.isNotEmpty) e.actorId,
        }.toList(),
        coordinatorships: {for (final e in entries) ?e.departmentId}.toList(),
        nextCursor: r.nextCursor,
      );
    } on ApiError catch (e, st) {
      // 4xx (yetkisizlik dahil) rapor üretmez; yalnız 5xx/geçersiz yanıt raporlanır.
      reportUnexpected(e, st, source: ReportSource.activity);
      throw _closed(e) ? const ActivityUnavailable() : e;
    }
  }
}

/// İşlem geçmişi bu hesaba kapalı (AUDIT-K10: yalnız şirket yöneticisi).
bool _closed(ApiError e) => e.code == 'audit.not_authorized' || e.status == 403;

/// `AuditEntry` → [ActivityEntry]: tür eylem kodunun modül önekinden; hedef görev kimliği
/// sunumda katalogla "KOD · başlık"a çözülür (burada boş); aktörsüz (sistem) kayıtta kimlik ve
/// ad boş.
ActivityEntry _entryOf(api.AuditEntry e) => ActivityEntry(
  at: e.occurredAt.toLocal(),
  kind: activityKindOf(e.actionCode),
  action: e.actionCode,
  actionCode: e.actionCode,
  detail: e.details ?? '',
  target: '',
  actorId: e.actorAccountId ?? '',
  actorName: e.actorFullName ?? '',
  subjectKind: e.subjectKind,
  subjectId: e.subjectId,
  departmentId: e.departmentId,
  failed: e.outcome == AuditEntryOutcome.failed,
);
