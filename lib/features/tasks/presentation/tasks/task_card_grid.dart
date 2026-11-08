import 'package:flutter/material.dart';

import '../../../../core/theme/generated/tokens.gen.dart';

/// Görev kartı ızgarası (tablette tam genişlik liste): sütun sayısı içerik genişliğinden çıkar
/// (kart en az [minCardWidth], en çok [maxColumns] sütun). Tek sütunda (telefon, liste bölmesi)
/// kartlar bugünkü gibi alt alta durur. Her satır akışın ayrı öğesidir (tembel kurulum kalır).
abstract final class TaskCardGrid {
  static const minCardWidth = 340.0;
  static const maxColumns = 3;

  /// Kartlar arası yatay ve dikey boşluk.
  static const gap = NizamioSpacing.gapMd;

  /// [width] içerik genişliğine sığan sütun sayısı (1–[maxColumns]).
  static int columnsFor(double width) =>
      ((width + gap) / (minCardWidth + gap)).floor().clamp(1, maxColumns);
}

/// Izgaranın bir satırı: kartlar satırın en uzun kartı boyundadır (eşit yükseklik; kart
/// `fill` ile uzar), eksik sütun boş kalır.
class TaskCardRow extends StatelessWidget {
  const TaskCardRow({super.key, required this.cards, required this.columns});

  final List<Widget> cards;
  final int columns;

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: TaskCardGrid.gap,
      children: [
        for (var i = 0; i < columns; i++)
          i < cards.length ? Expanded(child: cards[i]) : const Spacer(),
      ],
    ),
  );
}
