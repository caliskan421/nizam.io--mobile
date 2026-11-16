part of 'table_detail_controller.dart';

class TableDetailState {
  const TableDetailState({
    this.data,
    this.loading = true,
    this.busy = false,
    this.pending = false,
    this.error,
    this.participants = const [],
    this.undoSequence,
    this.query = const TableReadQuery(),
    this.changes = const [],
    this.live = false,
    this.deleted = false,
    this.page = 1,
    this.offset = 0,
    this.prefetching = false,
    this.prefetchError,
  });
  final TableWorkspace? data;
  final bool loading;
  final bool busy;
  final bool pending;
  final ApiError? error;
  final List<TableParticipant> participants;
  final int? undoSequence;
  final TableReadQuery query;
  final List<TableChangeEntry> changes;
  final bool live;
  final bool deleted;
  final int page;
  final int offset;
  final bool prefetching;
  final ApiError? prefetchError;
  TableDetailState copy({
    TableWorkspace? data,
    bool? loading,
    bool? busy,
    bool? pending,
    ApiError? Function()? error,
    List<TableParticipant>? participants,
    int? Function()? undo,
    TableReadQuery? query,
    List<TableChangeEntry>? changes,
    bool? live,
    bool? deleted,
    int? page,
    int? offset,
    bool? prefetching,
    ApiError? Function()? prefetchError,
  }) => TableDetailState(
    data: data ?? this.data,
    loading: loading ?? this.loading,
    busy: busy ?? this.busy,
    pending: pending ?? this.pending,
    error: error == null ? this.error : error(),
    participants: participants ?? this.participants,
    undoSequence: undo == null ? undoSequence : undo(),
    query: query ?? this.query,
    changes: changes ?? this.changes,
    live: live ?? this.live,
    deleted: deleted ?? this.deleted,
    page: page ?? this.page,
    offset: offset ?? this.offset,
    prefetching: prefetching ?? this.prefetching,
    prefetchError: prefetchError == null ? this.prefetchError : prefetchError(),
  );
}
