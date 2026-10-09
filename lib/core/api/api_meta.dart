/// Spec'ten üretilen haritaların (generated/operations.gen.dart, error_catalog.gen.dart)
/// tipleri. Elle yazılır; içerik üretilir.
library;

/// Kapsam sınıfı (`x-nizamio-scope-class`; C1): S0 kimliksiz, S1 kimlikli, S2 program
/// kapsamlı (`X-Nizamio-Program`), S3 departman kapsamlı (+ `X-Nizamio-Department`).
enum ScopeClass { s0, s1, s2, s3 }

/// Tek API işleminin istemci ara katmanının ihtiyaç duyduğu özeti.
class ApiOperation {
  const ApiOperation({
    required this.operationId,
    required this.method,
    required this.path,
    required this.scope,
    required this.csrf,
    required this.programHeader,
    required this.departmentHeader,
    required this.auth,
  });

  final String operationId;
  final String method;
  final String path;
  final ScopeClass scope;

  /// Spec bu işlemde `X-Requested-With` istiyor mu (bütün yazmalar).
  final bool csrf;
  final bool programHeader;
  final bool departmentHeader;

  /// Bearer kimliği gerekiyor mu (`security: []` değilse).
  final bool auth;
}

/// Hata kataloğu girdisi (`docs/api/error-codes.json`).
class ErrorCatalogEntry {
  const ErrorCatalogEntry({
    required this.statuses,
    required this.fields,
    required this.messageKey,
  });

  final List<int> statuses;
  final List<String> fields;
  final String messageKey;
}
