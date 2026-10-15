import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/program_client.dart';
import '../../../core/api/generated/models/program.dart' as api;
import '../../../core/domain/page_slice.dart';
import '../../../core/errors/api_error.dart';
import '../domain/program.dart';

/// program uçlarına üretilmiş istemciyle erişim (elle DTO yok — sınır kuralı D1/D2). Üretilmiş
/// DTO'lar bu katmanda kalır; dışarıya domain varlıkları döner (sınır kuralı A1). Bütün
/// hatalar [ApiError] olarak fırlar.
class ProgramRepository {
  /// [dio]: doğrulanmış bağın API istemcisi (kapsam başlığını ara katman ekler).
  ProgramRepository(Dio dio) : _client = ProgramClient(dio);

  /// Sunucunun imleçsiz listede kestiği üst sınır (`X-Result-Truncated`, openapi
  /// `ResultTruncated`: en çok 200 satır).
  static const maxRows = 200;

  final ProgramClient _client;

  /// `GET /v1/programs` (S1: kapsam başlığı gönderilmez). Sözleşmede imleç yoktur: düz liste.
  /// Üretilmiş istemci yanıt başlıklarını göstermez; `X-Result-Truncated` yerine "satır sayısı
  /// üst sınıra ulaştı" kesilme sayılır (sınırda tam 200 satır da kesilmiş kabul edilir —
  /// güvenli yön: kullanıcı listenin tamamı olmayabileceğini görür).
  Future<PageSlice<Program>> listPrograms() async {
    final r = await apiCall(_client.listPrograms);
    final items = r.programs.map(_program).toList();
    return PageSlice(items: items, truncated: items.length >= maxRows);
  }

  /// `GET /v1/program` (S2: `X-Nizamio-Program` ara katmandan, seçili kapsamdan).
  Future<Program> readProgram() async =>
      _program(await apiCall(_client.readProgram));

  static Program _program(api.Program r) =>
      Program(id: r.programId, name: r.name, year: r.year);
}
