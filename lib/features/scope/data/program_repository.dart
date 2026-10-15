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

  /// Sunucunun imleçsiz listede kestiği üst sınır (openapi `ResultTruncated`: en çok 200
  /// satır). Yalnız bilgidir: kesilme satır sayısından değil, [truncationHeader] başlığından
  /// okunur.
  static const maxRows = 200;

  /// Sözleşmedeki kesilme başlığı; yalnız kesildiğinde ve yalnız `true` değeriyle gönderilir.
  static const truncationHeader = 'X-Result-Truncated';

  final ProgramClient _client;

  /// `GET /v1/programs` (S1: kapsam başlığı gönderilmez). Sözleşmede imleç yoktur: düz liste.
  /// Kesilme `X-Result-Truncated` yanıt başlığından okunur: başlığın tek değeri tam olarak
  /// `true` ise kesilmiştir; başlık yoksa ya da değeri başkaysa kesilmemiş sayılır (sözleşme
  /// başlığı yalnız `true` ile gönderir; tanımsız değer kesilme bildirimi değildir).
  Future<PageSlice<Program>> listPrograms() async {
    final r = await apiCall(_client.listPrograms);
    final values = r.response.headers[truncationHeader];
    final truncated =
        values != null && values.length == 1 && values[0] == 'true';
    return PageSlice(
      items: r.data.programs.map(_program).toList(),
      truncated: truncated,
    );
  }

  /// `GET /v1/program` (S2: `X-Nizamio-Program` ara katmandan, seçili kapsamdan).
  Future<Program> readProgram() async =>
      _program(await apiCall(_client.readProgram));

  static Program _program(api.Program r) =>
      Program(id: r.programId, name: r.name, year: r.year);
}
