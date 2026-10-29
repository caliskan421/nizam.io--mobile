import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';

/// Tasarımın SVG çizgi ikonları (`.t-icon`: 24×24 viewBox, dolgu yok, çizgi `currentColor`
/// 1.75, yuvarlak uç ve birleşim). Material ikonu tasarımdakinden farklı olduğunda kaynak
/// `path d` verisi birebir çizilir; raster kopya ya da ikon fontu yaklaştırması yoktur.
class NzPathIcon extends StatelessWidget {
  const NzPathIcon(
    this.data, {
    super.key,
    this.size = NizamioSize.iconSize,
    this.color,
  });

  /// SVG `d` verisi (24×24 viewBox), ör. [NzIconPaths.home].
  final String data;

  /// Görsel kenar (`t-icon` 20, `t-icon--sm` 16, `t-icon--lg` 24).
  final double size;

  /// null → çevredeki [IconTheme] rengi (`currentColor`).
  final Color? color;

  /// `.t-icon` çizgi kalınlığı (viewBox biriminde).
  static const strokeWidth = 1.75;

  static const _viewBox = 24.0;

  static final _cache = <String, Path>{};

  /// [data]'nın 24×24 Path'i (ayrıştırma bir kez yapılır).
  static Path pathOf(String data) =>
      _cache.putIfAbsent(data, () => parseSvgPathData(data));

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    // [Icon] gibi: dış kutu sıkı kısıtla büyüse de çizim [size]'da kalır ve ortalanır.
    child: SizedBox.square(
      dimension: size,
      child: Center(
        child: SizedBox.square(
          dimension: size,
          child: CustomPaint(
            painter: _PathIconPainter(
              path: pathOf(data),
              color:
                  color ?? IconTheme.of(context).color ?? context.colors.text,
            ),
          ),
        ),
      ),
    ),
  );
}

class _PathIconPainter extends CustomPainter {
  _PathIconPainter({required this.path, required this.color});

  final Path path;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / NzPathIcon._viewBox;
    canvas
      ..save()
      ..scale(scale);
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = NzPathIcon.strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..isAntiAlias = true
        ..color = color,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_PathIconPainter old) =>
      old.path != path || old.color != color;
}

/// Tasarımda kullanılan ikon yolları (prototip `RAIL`, ray alt düğmeleri, boş durum).
abstract final class NzIconPaths {
  static const home =
      'M3 10.5 12 3l9 7.5V20a1 1 0 0 1-1 1h-5v-6h-6v6H4a1 1 0 0 1-1-1z';
  static const tasks =
      'M4 6l1.5 1.5L8 5M4 12l1.5 1.5L8 11M4 18l1.5 1.5L8 17M11 6h9M11 12h9M11 18h9';
  static const calendar = 'M4 6h16v14H4zM4 10h16M8 3v4M16 3v4';
  static const coordinatorships =
      'M5 21V4a1 1 0 0 1 1-1h8a1 1 0 0 1 1 1v17M15 9h4a1 1 0 0 1 1 1v11M3 21h18M9 7h2M9 11h2M9 15h2';
  static const archive =
      'M3 7a2 2 0 0 1 2-2h4l2 2h8a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z';
  static const messages =
      'M21 12a8 8 0 0 1-11.6 7.1L4 20l1-4.6A8 8 0 1 1 21 12z';
  static const bell =
      'M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9M10.3 21a1.94 1.94 0 0 0 3.4 0';
  static const menu = 'M4 7h16M4 12h16M10 17h10';
  static const assistant =
      'M12 2.5v3M8 6h8a3 3 0 0 1 3 3v7a3 3 0 0 1-3 3H8a3 3 0 0 1-3-3V9a3 3 0 0 1 3-3zM9.5 11.5v1M14.5 11.5v1M9.5 16h5M2.5 11v4M21.5 11v4';
  static const pickRecord = 'M4 6h16v14H4zM4 10h16M8 3v4M16 3v4M9 15l2 2 4-4';

  // Kaynak `t-icon` yolları (prototip satır içi SVG'ler).
  static const check = 'M5 12.5l4.5 4.5L19 7';
  static const chevronDown = 'M6 9l6 6 6-6';
  static const chevronRight = 'M9 6l6 6-6 6';
  static const chevronLeft = 'M15 6l-6 6 6 6';
  static const plus = 'M12 5v14M5 12h14';
  static const search = 'M11 18a7 7 0 1 0 0-14 7 7 0 0 0 0 14zM20 20l-4-4';
  static const close = 'M6 6l12 12M18 6L6 18';
  static const back = 'M15 5l-7 7 7 7';
  static const upload = 'M12 19V5M6 11l6-6 6 6';
  static const openArrow = 'M7 17 17 7M9 7h8v8';
  static const filter = 'M4 6h16M7 12h10M10 18h4';
  static const download = 'M12 4v11M7 10l5 5 5-5M5 20h14';
  static const timeline = 'M4 5h9M7 10h11M5 15h7M10 20h10';
  static const list = 'M4 6h16M4 12h16M4 18h16';
  static const edit = 'M4 20h4L19 9l-4-4L4 16zM13 7l4 4';
  static const more = 'M12 5h.01M12 12h.01M12 19h.01';
  static const pin = 'M9 4h6l-1 6 3 3H7l3-3zM12 13v7';
  static const eye =
      'M2.5 12S6 5 12 5s9.5 7 9.5 7-3.5 7-9.5 7-9.5-7-9.5-7zM12 15a3 3 0 1 0 0-6 3 3 0 0 0 0 6z';
  static const eyeOff =
      'M3 3l18 18M10.6 10.6a2 2 0 0 0 2.8 2.8M9.9 5.2A9.8 9.8 0 0 1 12 5c6 0 9.5 7 9.5 7a17 17 0 0 1-3.1 3.9M6.6 6.6C3.9 8.3 2.5 12 2.5 12s3.5 7 9.5 7a9.5 9.5 0 0 0 5.4-1.6';
  static const warning = 'M12 3 2 20h20zM12 10v4M12 17h.01';
  static const clock = 'M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18zM12 7v5l3 2';
  static const video = 'M15 10l5-3v10l-5-3zM3 7h12v10H3z';
  static const invite =
      'M10 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM3 21a7 7 0 0 1 13-3.5M19 14v6M16 17h6';
  static const doc = 'M14 3H6v18h12V7zM14 3v4h4M9 13h6M9 17h4';
  static const file = 'M14 3H6v18h12V7zM14 3v4h4';
  static const fileUpload = 'M14 3H6v18h12V7zM14 3v4h4M12 18v-7M9 14l3-3 3 3';
  static const history = 'M3 12a9 9 0 1 0 3-6.7M3 4v4h4M12 7v5l3 2';
  static const sort = 'M7 4v16M7 20l-3-3M7 20l3-3M17 20V4M17 4l-3 3M17 4l3 3';
  static const readTicks = 'M2 12.5l4 4L14 8M10 16.5l1 1L22 7';
  static const trash = 'M4 7h16M9 7V4h6v3M6 7l1 13h10l1-13';
  static const image = 'M4 6h16v13H4zM4 15l4-4 5 5 3-3 4 4M15 9.5h.01';
  static const reply = 'M9 14L4 9l5-5M4 9h11a5 5 0 0 1 5 5v6';
  static const logout = 'M15 4h4v16h-4M10 8l-4 4 4 4M6 12h10';
  static const users =
      'M9 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM2 21a7 7 0 0 1 14 0M16 3.5a4 4 0 0 1 0 7.5M22 21a7 7 0 0 0-4-6.3';
  static const tag = 'M3 12V4h8l10 10-8 8zM7.5 7.5h.01';
  static const alert = 'M12 8v5M12 16h.01M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18z';
  static const unfold = 'M8 9l4-4 4 4M8 15l4 4 4-4';
  static const mute = 'M11 5L6 9H3v6h3l5 4zM22 9l-6 6M16 9l6 6';
  static const idea =
      'M9 18h6M10 21h4M12 3a6 6 0 0 0-3.5 10.9c.6.5 1 1.2 1 2V16h5v-.1c0-.8.4-1.5 1-2A6 6 0 0 0 12 3z';
  static const sheets = 'M4 5h16v14H4zM4 10h16M4 15h16M10 5v14';
  static const person =
      'M12 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM4 21a8 8 0 0 1 16 0';
  static const mail = 'M3 6h18v12H3zM3 7l9 6 9-6';
  static const send = 'M5 12h14M13 6l6 6-6 6';
  static const bolt = 'M13 3 4 14h7l-1 7 9-11h-7z';
  static const attach =
      'M20 11.5l-7.8 7.8a5 5 0 0 1-7.1-7.1l8.2-8.2a3.3 3.3 0 0 1 4.7 4.7l-8.2 8.2a1.7 1.7 0 0 1-2.4-2.4l7.5-7.5';
  static const calendarGrid =
      'M4 6h16v14H4zM4 10h16M8 3v4M16 3v4M8 14h2M12 14h2M16 14h2M8 17h2M12 17h2';
  static const budget = 'M3 7h18v12H3zM3 11h18M16 15h2';
  static const requests = 'M6 3h9l4 4v14H6zM14 3v5h5M9 13l2 2 4-4';
  static const season = 'M5 21V4M5 4h11l-2 4 2 4H5';
  static const simulation =
      'M9 3h6M10 3v6l-5 9a2 2 0 0 0 1.7 3h10.6a2 2 0 0 0 1.7-3l-5-9V3M7.5 14h9';
  static const help =
      'M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18zM9.5 9.5a2.5 2.5 0 1 1 3.5 2.3c-.6.3-1 .9-1 1.6v.6M12 17h.01';

  /// Material ikonu → tasarım yolu ([NzIcon] tablet uyarlaması).
  static final Map<IconData, String> material = {
    Icons.check_rounded: check,
    Icons.done_rounded: check,
    Icons.keyboard_arrow_down_rounded: chevronDown,
    Icons.expand_more_rounded: chevronDown,
    Icons.chevron_right_rounded: chevronRight,
    Icons.chevron_left_rounded: chevronLeft,
    Icons.add_rounded: plus,
    Icons.search_rounded: search,
    Icons.search: search,
    Icons.close_rounded: close,
    Icons.arrow_back_ios_new_rounded: back,
    Icons.arrow_upward_rounded: upload,
    Icons.upload_rounded: upload,
    Icons.north_east_rounded: openArrow,
    Icons.tune_rounded: filter,
    Icons.filter_list_rounded: filter,
    Icons.download_rounded: download,
    Icons.view_timeline_outlined: timeline,
    Icons.list_rounded: list,
    Icons.view_list_rounded: list,
    Icons.edit_outlined: edit,
    Icons.more_vert_rounded: more,
    Icons.push_pin_outlined: pin,
    Icons.visibility: eye,
    Icons.visibility_off: eyeOff,
    Icons.warning_amber_rounded: warning,
    Icons.schedule_rounded: clock,
    Icons.videocam_outlined: video,
    Icons.person_add_alt_outlined: invite,
    Icons.description_outlined: doc,
    Icons.insert_drive_file_outlined: file,
    Icons.upload_file_rounded: fileUpload,
    Icons.history_rounded: history,
    Icons.swap_vert_rounded: sort,
    Icons.done_all_rounded: readTicks,
    Icons.delete_outline_rounded: trash,
    Icons.image_outlined: image,
    Icons.reply_rounded: reply,
    Icons.logout_rounded: logout,
    Icons.logout: logout,
    Icons.group_outlined: users,
    Icons.sell_outlined: tag,
    Icons.error_outline: alert,
    Icons.unfold_more_rounded: unfold,
    Icons.volume_off_outlined: mute,
    Icons.lightbulb_outline_rounded: idea,
    Icons.table_chart_outlined: sheets,
    Icons.person_outline: person,
    Icons.person_outline_rounded: person,
    Icons.mail_outline_rounded: mail,
    Icons.notifications_none_rounded: bell,
    Icons.menu_rounded: menu,
    Icons.smart_toy_outlined: assistant,
    Icons.home_outlined: home,
    Icons.checklist_rounded: tasks,
    Icons.calendar_today_outlined: calendar,
    Icons.event_outlined: calendar,
    Icons.apartment_rounded: coordinatorships,
    Icons.folder_outlined: archive,
    Icons.chat_bubble_outline_rounded: messages,
    Icons.attach_file_rounded: attach,
    Icons.bolt_rounded: bolt,
    Icons.calendar_month_outlined: calendarGrid,
    Icons.account_balance_wallet_outlined: budget,
    Icons.assignment_turned_in_outlined: requests,
    Icons.flag_outlined: season,
    Icons.science_outlined: simulation,
    Icons.help_outline_rounded: help,
    Icons.chevron_right: chevronRight,
    Icons.close: close,
    Icons.error_outline_rounded: alert,
    Icons.info_outline_rounded: alert,
    Icons.info_outline: alert,
  };
}
