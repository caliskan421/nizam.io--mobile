// Çevrimdışıyken son veri salt okunur (iPad not 47): yazma isteği gönderilmez, okuma geçer.
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/http/connectivity_interceptor.dart';
import 'package:nizamio/core/network/connectivity_monitor.dart';

final class _CountingAdapter implements HttpClientAdapter {
  final methods = <String>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    methods.add(options.method);
    return ResponseBody.fromString(
      jsonEncode({'ok': true}),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late ConnectivityMonitor monitor;
  late _CountingAdapter adapter;
  late Dio dio;

  setUp(() {
    monitor = ConnectivityMonitor();
    adapter = _CountingAdapter();
    dio = Dio(BaseOptions(baseUrl: 'https://x.test'))
      ..httpClientAdapter = adapter
      ..interceptors.add(ConnectivityInterceptor(monitor));
  });

  test(
    'çevrimdışıyken yazma isteği gönderilmeden bağlantı hatasıyla reddedilir',
    () async {
      monitor.state.value = ConnectivityState.offline;
      await expectLater(
        dio.post<Object?>('/v1/x'),
        throwsA(
          isA<DioException>().having(
            (e) => e.type,
            'type',
            DioExceptionType.connectionError,
          ),
        ),
      );
      expect(adapter.methods, isEmpty);
    },
  );

  test('çevrimdışıyken okuma isteği geçer', () async {
    monitor.state.value = ConnectivityState.offline;
    await dio.get<Object?>('/v1/x');
    expect(adapter.methods, ['GET']);
  });

  test(
    'sunucuya ulaşılamıyorken yazma denenir (dönüşü istek fark eder)',
    () async {
      monitor.state.value = ConnectivityState.unreachable;
      await dio.patch<Object?>('/v1/x');
      expect(adapter.methods, ['PATCH']);
    },
  );
}
