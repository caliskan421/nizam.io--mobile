import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/di/composition.dart';
import 'package:nizamio/core/api/generated/clients/organization_client.dart';
import 'package:nizamio/core/api/generated/clients/program_client.dart';
import 'package:nizamio/core/api/generated/models/create_department_request.dart';
import 'package:nizamio/core/api/generated/models/create_department_request_kind.dart';
import 'package:nizamio/core/api/generated/models/create_program_request.dart';
import 'package:nizamio/core/api/generated/models/delete_program_request.dart';
import 'package:nizamio/core/api/generated/models/link_department_request.dart';
import 'package:nizamio/core/config/flavor.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/server/server_binding.dart';
import 'package:nizamio/core/storage/preference_store.dart';
import 'package:nizamio/core/storage/secure_store.dart';
import 'package:nizamio/features/identity/identity.dart';
import 'package:nizamio/features/messages/data/chat_api_repository.dart';
import 'package:nizamio/features/messages/domain/chat.dart';
import 'package:nizamio/features/scope/scope.dart';

import 'proxy.dart';
import 'raw_http.dart';

/// Creates only this scenario's API resources; never starts/stops a shared backend.
final class MessagingFixture {
  MessagingFixture._(this.proxy, this.composition, this.password);

  final CountingProxy proxy;
  final Composition composition;
  final String password;
  String? _programId;
  String? _departmentId;

  ProviderContainer get container => composition.container;
  ChatRepository get messages =>
      ApiChatRepository(() => container.read(apiDioProvider));
  String get programId => _programId!;
  String get departmentId => _departmentId!;
  ProgramClient get _programs => ProgramClient(container.read(apiDioProvider)!);
  OrganizationClient get _organization =>
      OrganizationClient(container.read(apiDioProvider)!);

  /// The counting proxy buffers response bodies, so SSE needs a direct connection.
  Future<ChatRepository> streamRepository() async {
    final direct = Composition.create(
      flavor: Flavor.dev,
      secureStore: MemorySecureStore(),
      preferenceStore: MemoryPreferenceStore(),
    );
    addTearDown(() async {
      try {
        await direct.container.read(identityServiceProvider).logout();
      } finally {
        await direct.dispose();
      }
    });
    final binding = await direct.container
        .read(serverBindingProvider)
        .verify(proxy.target.toString());
    expect(binding, isA<BindingVerified>());
    await direct.container
        .read(identityServiceProvider)
        .login(
          email:
              Platform.environment['NIZAMIO_IT_ADMIN_EMAIL'] ??
              'yonetici@f14.nizamio.test',
          password: password,
        );
    direct.container.read(scopeServiceProvider).select(programId);
    return ApiChatRepository(() => direct.container.read(apiDioProvider));
  }

  static Future<MessagingFixture> create() async {
    final env = Platform.environment;
    final backend = Uri.parse(
      env['NIZAMIO_IT_BACKEND'] ?? 'http://127.0.0.1:18140',
    );
    final ready = await rawRequest(
      'GET',
      backend.replace(path: '/healthz/ready'),
    );
    expect(ready.status, 200, reason: 'integration backend must be ready');
    final proxy = await CountingProxy.start(backend);
    final composition = Composition.create(
      flavor: Flavor.dev,
      secureStore: MemorySecureStore(),
      preferenceStore: MemoryPreferenceStore(),
    );
    final fixture = MessagingFixture._(
      proxy,
      composition,
      env['NIZAMIO_IT_ADMIN_PASSWORD'] ?? 'F14-Yonetici-Parola-2026',
    );
    addTearDown(fixture.dispose);
    final binding = await fixture.container
        .read(serverBindingProvider)
        .verify(proxy.url.toString());
    expect(binding, isA<BindingVerified>());
    await fixture.container
        .read(identityServiceProvider)
        .login(
          email: env['NIZAMIO_IT_ADMIN_EMAIL'] ?? 'yonetici@f14.nizamio.test',
          password: fixture.password,
        );
    final suffix = DateTime.now().microsecondsSinceEpoch;
    final program = await fixture._programs.createProgram(
      body: CreateProgramRequest(name: 'Messaging integration $suffix'),
    );
    expect(program.created, isTrue);
    fixture._programId = program.programId;
    fixture.container.read(scopeServiceProvider).select(program.programId);
    final department = await fixture._organization.createDepartment(
      body: CreateDepartmentRequest(
        name: 'Messaging integration $suffix',
        kind: CreateDepartmentRequestKind.koordinatorluk,
      ),
    );
    fixture._departmentId = department.departmentId;
    await fixture._programs.linkDepartment(
      body: LinkDepartmentRequest(departmentId: department.departmentId),
    );
    return fixture;
  }

  Future<void> dispose() async {
    try {
      final programId = _programId;
      if (programId != null) {
        await _programs.deleteProgram(
          id: programId,
          body: DeleteProgramRequest(password: password),
        );
      }
      final departmentId = _departmentId;
      if (departmentId != null) {
        await _organization.deleteDepartment(id: departmentId);
        await _organization.permanentDeleteDepartment(id: departmentId);
      }
      await container.read(identityServiceProvider).logout();
    } finally {
      await composition.dispose();
      await proxy.close();
    }
  }
}
