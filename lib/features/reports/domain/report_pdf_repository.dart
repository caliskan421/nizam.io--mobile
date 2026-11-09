abstract interface class ReportPdfRepository {
  Future<Stream<List<int>>> open(String path, {List<String>? memberIds});
}
