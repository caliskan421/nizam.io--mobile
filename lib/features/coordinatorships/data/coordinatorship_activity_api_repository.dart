import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/collaboration_client.dart';
import '../../../core/api/generated/clients/records_client.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/http/interceptors.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../domain/coordinatorship_board.dart';

/// [CoordinatorshipActivityRepository]'nin sunucu gerçekleştirmesi. Toplantılar
/// `listMeetings` (S2, program açık), dosyalar `archiveAttachments` (S3: program + bu
/// departman açık). İkisi de imleçli; en çok [maxPages] sayfa okunur. DTO'lar bu katmanda kalır.
class ApiCoordinatorshipActivityRepository
    implements CoordinatorshipActivityRepository {
  ApiCoordinatorshipActivityRepository({
    required this.dio,
    required this.programId,
  });

  /// Doğrulanmış bağın güncel API istemcisi; bağ yoksa null.
  final Dio? Function() dio;

  /// Seçili program (istek anında okunur).
  final String? Function() programId;

  static const pageSize = 200;
  static const maxPages = 10;

  (Dio, String) _ctx() {
    final program = programId();
    if (program == null || program.isEmpty) {
      throw ApiError(ClientErrorCode.scopeMissing);
    }
    final d = dio();
    if (d == null) throw ApiError(ClientErrorCode.serverNotVerified);
    return (d, program);
  }

  @override
  Future<List<CoordMeeting>> meetings(String departmentId) async {
    final (d, program) = _ctx();
    final client = CollaborationClient(d);
    final out = <CoordMeeting>[];
    String? cursor;
    for (var page = 0; page < maxPages; page++) {
      final r = await apiCall(
        () => client.listMeetings(
          limit: pageSize,
          cursor: cursor,
          extras: withProgram(
            CollaborationClient.listMeetingsOpenapiExtras,
            program,
          ),
        ),
      );
      for (final m in r.items) {
        if (m.deletedAt != null) continue;
        if (!m.departments.any((x) => x.departmentId == departmentId)) {
          continue;
        }
        out.add(
          CoordMeeting(
            id: m.meetingId,
            title: m.title,
            at: m.meetingDate.toLocal(),
            owner: m.ownerDepartmentId == departmentId,
            departments: m.departments.length,
          ),
        );
      }
      cursor = r.nextCursor;
      if (cursor.isEmpty) break;
    }
    return out;
  }

  @override
  Future<List<CoordFile>> files(
    String departmentId,
    Set<String> workItemIds,
  ) async {
    final (d, program) = _ctx();
    final client = RecordsClient(d);
    final out = <CoordFile>[];
    String? cursor;
    for (var page = 0; page < maxPages; page++) {
      final r = await apiCall(
        () => client.archiveAttachments(
          limit: pageSize,
          cursor: cursor,
          extras: withScope(
            RecordsClient.archiveAttachmentsOpenapiExtras,
            program,
            departmentId,
          ),
        ),
      );
      for (final f in r.files) {
        if (!workItemIds.contains(f.workItemId)) continue;
        out.add(
          CoordFile(
            id: f.fileId,
            name: f.displayName,
            kind: CoordFile.kindOf(f.contentType),
            sizeBytes: f.sizeBytes,
            workItemId: f.workItemId,
            uploaderId: f.uploadedByAccountId,
          ),
        );
      }
      cursor = r.nextCursor;
      if (cursor == null || cursor.isEmpty) break;
    }
    return out;
  }
}
