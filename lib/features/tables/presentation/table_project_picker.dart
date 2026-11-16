import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/errors/error_text.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../application/tables_server.dart';
import '../domain/table_workspace.dart';
import '../domain/tables_repository.dart';

/// Proje seçimi sayfalıdır; yalnız ilk sayfadaki projelerle sınırlanmaz.
class TableProjectPicker extends ConsumerStatefulWidget {
  const TableProjectPicker({
    super.key,
    required this.location,
    required this.value,
    required this.onChanged,
  });
  final TableLocation location;
  final String? value;
  final ValueChanged<String?> onChanged;
  @override
  ConsumerState<TableProjectPicker> createState() => _TableProjectPickerState();
}

class _TableProjectPickerState extends ConsumerState<TableProjectPicker> {
  final _items = <TableProjectEntry>[];
  String? _cursor;
  bool _loading = true;
  ApiError? _error;
  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> _load({bool more = false}) async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final p = await ref
          .read(tablesRepositoryProvider)!
          .projects(widget.location, cursor: more ? _cursor : null);
      if (mounted) {
        setState(() {
          if (!more) _items.clear();
          _items.addAll(p.items);
          _cursor = p.cursor;
          _loading = false;
        });
      }
    } on Object catch (e, st) {
      final error = toReportedApiError(e, st, source: ReportSource.ui);
      if (mounted) {
        setState(() {
          _error = error;
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      NzSelect<String>(
        label: 'Klasör',
        value: widget.value ?? '',
        items: [
          const NzSelectItem(value: '', label: 'Klasörsüz'),
          if (widget.value != null && !_items.any((p) => p.id == widget.value))
            NzSelectItem(value: widget.value!, label: 'Mevcut klasör'),
          for (final p in _items) NzSelectItem(value: p.id, label: p.name),
        ],
        onChanged: _loading
            ? null
            : (v) => widget.onChanged(v == '' ? null : v),
      ),
      if (_loading) const LinearProgressIndicator(),
      if (_error != null) ...[
        Text(errorText(context.l10n, _error!)),
        NzButton.ghost(onPressed: _load, label: 'Klasörleri yeniden yükle'),
      ],
      if (_cursor != null)
        NzButton.ghost(
          onPressed: _loading ? null : () => _load(more: true),
          label: 'Diğer klasörleri yükle',
        ),
    ],
  );
}
