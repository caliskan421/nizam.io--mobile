import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'activity_nav_caption.g.dart';

/// Alt menüde işlem geçmişindeyken görünen mono alt yazı (ör. "38 kayıt"); null → yok.
@riverpod
String? activityNavCaption(Ref ref) => null;
