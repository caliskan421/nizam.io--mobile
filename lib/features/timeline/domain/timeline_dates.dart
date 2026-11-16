import '../../tasks/tasks.dart';

/// Zaman çizelgesinin göreli tarih komutları (domain portu; gerçekleştirme `data/`). İkisi de
/// S3'tür: kapsam görevin kendi `(program, departman)` çiftidir.
abstract interface class TimelineDateRepository {
  /// `POST /v1/work-items/{id}/extend` (`extendWorkItem`, WORK-K40): bitişi [days] gün ileri
  /// alır (bağımlılara yayılır). [requestKey] işlem anahtarı; belirsiz sonuçta aynı anahtarla
  /// yeniden denenir. Görevin okunan `dates_revision`'ı beklenen sürüm olarak gider.
  Future<void> extend(TaskItem task, int days, {required String requestKey});

  /// `POST /v1/work-items/{id}/pull-end-date` (`pullEndDate`, WORK-K43): bitişi bugüne çeker.
  Future<void> pullEndDate(TaskItem task);
}
