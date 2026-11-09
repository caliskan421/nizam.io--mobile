/// Grup adayı okumasının şirket yöneticisi etiketleri. Görünüm verisidir; yetki kararı
/// için kullanılmaz. Kesik aday listesi eksik yöneticiler içerebilir.
class CompanyAdminIndex {
  CompanyAdminIndex(Iterable<String> accountIds, {required this.complete})
    : accountIds = Set.unmodifiable(accountIds);
  final Set<String> accountIds;
  final bool complete;
}
