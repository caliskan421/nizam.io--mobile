/// Takvimin kapsam süzgeci (koordinatörlük kimliği; [CalendarIndex.build] `coordinatorship`).
/// Yönetici görünümü ([seesAll]) süzgeçsizdir (null). Koordinatör ve Üye görünümü yalnız etkin
/// koordinatörlüğün kayıtlarını görür: toplantılar `departments` içinde o koordinatörlük
/// olanlar, görevler o koordinatörlüğün görevleri; koordinatörlük boşsa boş kimlik döner ve
/// hiçbir kayıt eşleşmez. Erişim bilinmiyorsa ([known] false) ek süzgeç yoktur: görünürlük
/// zaten sunucu kuralıdır, arayüz yalnız bilinen görünümü daraltır.
String? calendarScope({
  required bool known,
  required bool seesAll,
  required String? department,
}) => !known || seesAll ? null : (department ?? '');
