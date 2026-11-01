/// Yüklenebilir dosya türleri (RECORDS-K03). Görev kanıtı ve arşiv yüklemesi ortak kullanır.
library;

/// İzinli uzantı → bildirilen tür (backend `records/domain/content.go`, elle yazılır); küme
/// dışı → null. Sunucu türü multipart parçasının `Content-Type`'ından okur; `jpeg` uzantısı
/// kümede yoktur (tek kanonik uzantı `jpg`).
String? uploadContentType(String extension) => switch (extension) {
  'pdf' => 'application/pdf',
  'png' => 'image/png',
  'jpg' => 'image/jpeg',
  'csv' => 'text/csv',
  'doc' => 'application/msword',
  'docx' =>
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  'xls' => 'application/vnd.ms-excel',
  'xlsx' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  'ppt' => 'application/vnd.ms-powerpoint',
  'pptx' =>
    'application/vnd.openxmlformats-officedocument.presentationml.presentation',
  'pages' => 'application/x-iwork-pages-sffpages',
  _ => null,
};

/// [uploadContentType] kümesinin uzantıları (sistem seçicisinin süzgeci; küme ile aynı sıra).
const uploadExtensions = [
  'pdf',
  'png',
  'jpg',
  'csv',
  'doc',
  'docx',
  'xls',
  'xlsx',
  'ppt',
  'pptx',
  'pages',
];
