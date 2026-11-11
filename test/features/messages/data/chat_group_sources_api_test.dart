import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/messages/data/chat_api_repository.dart';

import 'chat_http.dart';

void main() {
  test('program bağlıları görünen adla eşlenir, kesilme korunur', () async {
    final adapter = ChatHttpAdapter({
      'GET /v1/program/departments': (
        200,
        {
          'departments': [
            {'department_id': 'd1', 'display_name': 'Elektrik', 'code': 'ELE'},
          ],
        },
      ),
    });
    final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
      ..httpClientAdapter = adapter
      ..interceptors.add(
        InterceptorsWrapper(
          onResponse: (response, handler) {
            response.headers.set('X-Result-Truncated', 'true');
            handler.next(response);
          },
        ),
      );
    final result = await ApiChatRepository(() => dio).programDepartments();
    expect(result.items.single.id, 'd1');
    expect(result.items.single.name, 'Elektrik');
    expect(result.truncated, isTrue);
    final request = adapter.only('GET', '/v1/program/departments');
    expect(request.queryParameters, isEmpty);
    expect(
      (request.extra['openapi'] as Map)['operationId'],
      'listProgramDepartments',
    );
  });

  test('hatalı program listesi başarıya çevrilmez', () async {
    final (repo, _) = chatRepo({
      'GET /v1/program/departments': (
        403,
        {
          'error': {'code': 'messaging.not_authorized', 'fields': <Object>[]},
        },
      ),
    });
    await expectLater(repo.programDepartments(), throwsA(isA<ApiError>()));
  });
}
