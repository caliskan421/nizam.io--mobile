import '../api_surface.dart';
Future<void> main() async {
  final sw = Stopwatch()..start();
  final v = await checkApiSurface('.');
  print('\n${v.length} ihlal, ${sw.elapsedMilliseconds} ms');
  v.forEach(print);
}
