import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/organization_client.dart';
import '../../../core/api/generated/clients/program_client.dart';
import '../../../core/api/generated/models/link_department_request.dart';
import '../../../core/api/generated/models/my_department.dart' as api;
import '../../../core/api/generated/models/program.dart' as api;
import '../../../core/domain/page_slice.dart';
import '../../../core/errors/api_error.dart';
import '../domain/my_department.dart';
import '../domain/program.dart';

/// Kullanıcının kendi kapsamı: programlar, kapsamdaki program, hesabın departmanları ve
/// departmanın programa bağlanması. Üretilmiş istemcilerle erişir (elle DTO yok — sınır kuralı
/// D1/D2); DTO'lar bu katmanda kalır, dışarıya domain varlıkları döner (sınır kuralı A1). Bütün
/// hatalar [ApiError] olarak fırlar.
class ProgramRepository {
  /// [dio]: doğrulanmış bağın API istemcisi (kapsam başlığını ara katman ekler).
  ProgramRepository(Dio dio)
    : _client = ProgramClient(dio),
      _organization = OrganizationClient(dio);

  /// Sunucunun imleçsiz listede kestiği üst sınır (openapi `ResultTruncated`: en çok 200
  /// satır). Yalnız bilgidir: kesilme satır sayısından değil, [truncationHeader] başlığından
  /// okunur.
  static const maxRows = 200;

  /// Sözleşmedeki kesilme başlığı; yalnız kesildiğinde ve yalnız `true` değeriyle gönderilir.
  static const truncationHeader = 'X-Result-Truncated';

  final ProgramClient _client;
  final OrganizationClient _organization;

  /// `GET /v1/programs` (S1: kapsam başlığı gönderilmez). Sözleşmede imleç yoktur: düz liste.
  /// Kesilme `X-Result-Truncated` yanıt başlığından okunur: başlığın tek değeri tam olarak
  /// `true` ise kesilmiştir; başlık yoksa ya da değeri başkaysa kesilmemiş sayılır (sözleşme
  /// başlığı yalnız `true` ile gönderir; tanımsız değer kesilme bildirimi değildir).
  Future<PageSlice<Program>> listPrograms() async {
    final r = await apiCall(_client.listPrograms);
    return PageSlice(
      items: r.data.programs.map(_program).toList(),
      truncated: _truncated(r.response.headers),
    );
  }

  /// `GET /v1/program` (S2: `X-Nizamio-Program` ara katmandan, seçili kapsamdan).
  Future<Program> readProgram() async =>
      _program(await apiCall(_client.readProgram));

  /// `GET /v1/me/departments` (S1): oturumdaki hesabın departmanları ve oradaki rolü.
  /// İmleçsiz; kesilme [listPrograms] ile aynı kuralla başlıktan okunur. Sunucunun `null`
  /// dizisi boş listedir.
  Future<PageSlice<MyDepartment>> myDepartments() async {
    final r = await apiCall(_organization.myDepartments);
    return PageSlice(
      items: (r.data.departments ?? const <api.MyDepartment>[])
          .map(_myDepartment)
          .toList(),
      truncated: _truncated(r.response.headers),
    );
  }

  /// `POST /v1/program/departments` (S2): [departmentId]'yi kapsamdaki programa bağlar
  /// (program `X-Nizamio-Program` ara katmandan). Yetki sunucudadır (şirket yöneticisi).
  Future<ProgramDepartmentLink> linkDepartment(String departmentId) async {
    final r = await apiCall(
      () => _client.linkDepartment(
        body: LinkDepartmentRequest(departmentId: departmentId),
      ),
    );
    return ProgramDepartmentLink(
      programId: r.programId,
      departmentId: r.departmentId,
    );
  }

  static bool _truncated(Headers headers) {
    final values = headers[truncationHeader];
    return values != null && values.length == 1 && values[0] == 'true';
  }

  static Program _program(api.Program r) => Program(
    id: r.programId,
    name: r.name,
    year: r.year,
    description: r.description,
  );

  static MyDepartment _myDepartment(api.MyDepartment r) => MyDepartment(
    id: r.departmentId,
    name: r.displayName,
    role: DepartmentRole.fromWire(r.role),
  );
}
