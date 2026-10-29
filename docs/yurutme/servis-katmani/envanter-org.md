# Servis katmanı envanteri — parça `org`

Pin: `v0.2.0-api`. Kapsam: üretilmiş `identity_client.dart` (7), `program_client.dart` (11),
`organization_client.dart` (28), `platform_client.dart` (4) = **50 işlem**. Karşılanan: **48**
(45 işlem feature repository'lerinde; 3 işlem core'da zaten var: `refresh`, `systemInfo`,
`instanceProfile`). Karşılık bırakılmayan: **2** (`healthLive`,
`healthReady` — core'da eksik, aşağıda gerekçe).

Kapsam sınıfı spec'teki `x-nizamio-scope-class` değeridir. Kapsam başlıkları ara katmandan
gelir; bu parçadaki hiçbir üretilmiş imza kapsamı parametre olarak istemez.

## identity (7)

| operationId | yöntem yol | kapsam | Flutter karşılığı | domain tipi | not |
|---|---|---|---|---|---|
| login | POST /v1/auth/login | S0 | `IdentityRepository.login` (mevcut) | `LoginGrant` | değişmedi |
| refresh | POST /v1/auth/refresh | S0 | `SessionController.refresh` (`lib/core/session/session_controller.dart`; istemci `lib/app/di/dependencies.dart`) | — (belirteç çifti core'da) | Kimlik ara katmanı OLMADAN çağrılmalı; repository'ye taşınmadı (core/app ortak dosya, dokunulmadı) |
| logout | POST /v1/auth/logout | S1 | `IdentityRepository.logout` (mevcut) | — | değişmedi |
| me | GET /v1/me | S1 | `IdentityRepository.me` (mevcut) | `CurrentAccount` | `full_name`/`company_admin` pinde yok (f41) — eklenmedi |
| changePassword | POST /v1/auth/password | S1 | `IdentityRepository.changePassword` (mevcut) | `int` (düşen oturum) | değişmedi |
| issueDownloadTicket | POST /v1/download-tickets | S1 | `IdentityRepository.issueDownloadTicket(path)` (GET hedefleri), `IdentityRepository.issueWorkloadPdfTicket(memberIds:)` (tek POST hedefi) | `DownloadTicket` | `DownloadTicketRequest.body` `dynamic`; features'ta `Map<String,…>` yasak (D2) olduğundan POST gövdesi üretilmiş `WorkloadPdfRequest` ile kurulur. İzin listesindeki tek POST hedefi iş yükü PDF'i olduğu için genel POST metodu açılmadı. `DownloadTicket.toString` bileti yazmaz |
| redeemDownloadTicket | GET /v1/downloads/{ticket} | S0 | `IdentityRepository.downloadUri(ticket)` | `Uri` | Spec yanıtı `*/*` şemasız → üretilmiş imza `Future<void>` (gövde atılır). Bilet tarayıcı/indirme yöneticisinde kimlik başlığı olmadan tüketilir (ADR-0013); repository bileti kendisi tüketmez, tüketme adresini (bağ tabanı + `url`) verir. Uygulama içi ikili okuma gerekirse core'da ham Dio yolu gerekir (ortaklaştırma adayı) |

## program (11)

| operationId | yöntem yol | kapsam | Flutter karşılığı | domain tipi | not |
|---|---|---|---|---|---|
| listPrograms | GET /v1/programs | S1 | `ProgramRepository.listPrograms` (mevcut) | `PageSlice<Program>` | imleçsiz, `X-Result-Truncated` |
| readProgram | GET /v1/program | S2 | `ProgramRepository.readProgram` (mevcut) | `Program` | artık `description` de eşlenir |
| linkDepartment | POST /v1/program/departments | S2 | `ProgramRepository.linkDepartment(departmentId)` | `ProgramDepartmentLink` | yetki sunucuda (ŞY) |
| createProgram | POST /v1/programs | S1 | `ProgramAdminRepository.createProgram` (`ApiProgramAdminRepository`) | `ProgramCreation` (`Program` + `created`) | aynı ad → mevcut program, `created` yoksa `false` |
| updateProgram | PATCH /v1/programs/{id} | S1 | `ProgramAdminRepository.updateProgram` | `Program` | `null` alan değişmez |
| deleteProgram | DELETE /v1/programs/{id} | S1 | `ProgramAdminRepository.deleteProgram(id, password:)` | `void` | parola yalnız gövdede |
| resetProgram | POST /v1/programs/{id}/reset | S1 | `ProgramAdminRepository.resetProgram(id, password:)` | `ProgramReset` | |
| previewTransfer | POST /v1/program-transfers/preview | S1 | `ProgramAdminRepository.previewTransfer` | `TransferPreview` | `preview_fingerprint` → `fingerprint`; nullable diziler → boş liste. DTO alanları spec'te isteğe bağlı; domain metodunda dördü zorunlu tutuldu (eksik alan 422 `program.transfer_input_invalid`) |
| transferWorkItems | POST /v1/program-transfers | S1 | `ProgramAdminRepository.transfer` (ileri) ve `.reverseTransfer` (ters: `reverses_transfer_id`) | `TransferOutcome` | `Idempotency-Key` başlığı açık parametre; tek uç iki domain metoduna ayrıldı (spec: "ileri ya da ters", karışık gövde 422) |
| listTransfers | GET /v1/program-transfers | S1 | `ProgramAdminRepository.listTransfers(page:)` | `PageSlice<TransferRecord>` | imleçli, `total` yok |
| readTransfer | GET /v1/program-transfers/{id} | S1 | `ProgramAdminRepository.readTransfer` | `TransferRecord` | |

## organization (28)

| operationId | yöntem yol | kapsam | Flutter karşılığı | domain tipi | not |
|---|---|---|---|---|---|
| myDepartments | GET /v1/me/departments | S1 | `ProgramRepository.myDepartments` | `PageSlice<MyDepartment>` | imleçsiz + kesilme başlığı; `role` spec'te serbest dizge → `DepartmentRole.fromWire` (tanımsız → `unknown`) |
| listDepartments | GET /v1/departments | S1 | `DepartmentRepository.listDepartments` (`ApiDepartmentRepository`) | `PageSlice<Department>` | imleçsiz + kesilme; `kind` serbest dizge → `DepartmentKind.fromWire`; program süzgeci yok (bütün departmanlar) |
| createDepartment | POST /v1/departments | S1 | `DepartmentRepository.createDepartment` | `Department` | `DepartmentKind.unknown` gönderilmez (istek atılmadan `ArgumentError`) |
| updateDepartment | PATCH /v1/departments/{id} | S1 | `DepartmentRepository.updateDepartment` | `Department` | `null` alan değişmez |
| deleteDepartment | DELETE /v1/departments/{id} | S1 | `DepartmentRepository.deleteDepartment` | `bool` (`deleted`) | geri alınabilir silme |
| listMembers | GET /v1/departments/{id}/members | S1 | `DepartmentRepository.listMembers` | `PageSlice<TeamMember>` | **birleştirildi**: `RosterMember` → mevcut `TeamMember` (`name`←`full_name`, `lead`←`role==koordinator`, yeni `accountId`/`membershipId`/`role`/`status`); `unit` sunucuda yok → `''`. `status` enum (`MemberStatus`, `unknown` dahil) |
| assignMembership | POST /v1/departments/{id}/memberships | S1 | `DepartmentRepository.assignMembership` | `Membership` | `Membership.role` spec'te serbest dizge (açıklamada koordinator/uye) |
| updateMembershipRole | PATCH /v1/departments/{id}/memberships/{accountId} | S1 | `DepartmentRepository.changeMembershipRole(confirm:)` | `MembershipChange` | `confirm` yalnız `true` iken gövdeye girer |
| removeMember | DELETE /v1/departments/{id}/memberships/{accountId} | S1 | `DepartmentRepository.removeMember(confirm:)` | `MembershipChange` | `confirm=true` sorgu parametresi yalnız onayda |
| listAssignable | GET /v1/departments/{id}/assignable | S1 | `DepartmentRepository.listAssignable` | `PageSlice<AssignableAccount>` | `roles` `"departman:rol"` dizgeleri olduğu gibi |
| assignCoordinator | POST /v1/departments/{id}/coordinator | S1 | `DepartmentRepository.assignCoordinator` | `Membership` (`changed` dolu) | `CoordinatorResult` ile `Membership` tek domain tipinde birleşti |
| removeCoordinator | DELETE /v1/departments/{id}/coordinator/{accountId} | S1 | `DepartmentRepository.removeCoordinator(confirm:)` | `MembershipChange` | |
| taskSummary | GET /v1/departments/{id}/task-summary | S1 | `DepartmentRepository.taskSummary` | `DepartmentTaskSummary` | `CoordinatorshipReport` ile örtüşür ama `late`/`seasonRatio` sunucuda yok → ayrı tip |
| listUsers | GET /v1/admin/users | S1 | `OrganizationAdminRepository.listUsers` (`ApiOrganizationAdminRepository`) | `PageSlice<KnownUser>` | imleçli + kesilme başlığı da okunur. `role`/`sort_by`/`sort_order` spec'te serbest dizge; değer kümesi backend kodundan (`name`/`created_at`, `asc`/`desc`, `koordinator`/`uye`) → `UserSortField`, `SortDirection`, `DepartmentRole` (spec belirsizliği) |
| createUser | POST /v1/admin/users | S1 | `OrganizationAdminRepository.createUser` | `UserChange` | `role` spec'te serbest dizge → `DepartmentRole`; eksik bayraklar `false`/0 |
| updateUser | PATCH /v1/admin/users/{id} | S1 | `OrganizationAdminRepository.updateUser` | `UserChange` | |
| deleteUser | DELETE /v1/admin/users/{id} | S1 | `OrganizationAdminRepository.deleteUser` | `UserChange` | |
| openAccount | POST /v1/admin/accounts | S1 | `OrganizationAdminRepository.openAccount` | `AccountChange` | parola yalnız gövdede |
| updateAccount | PATCH /v1/admin/accounts/{id} | S1 | `OrganizationAdminRepository.updateAccount` | `AccountChange` | `revoked_sessions` yoksa 0 |
| deleteAccount | DELETE /v1/admin/accounts/{id} | S1 | `OrganizationAdminRepository.deleteAccount` | `AccountChange` | |
| unlockAccount | POST /v1/admin/accounts/{id}/unlock | S1 | `OrganizationAdminRepository.unlockAccount` | `AccountChange` | |
| resetLockouts | POST /v1/admin/security/reset-lockouts | S1 | `OrganizationAdminRepository.resetLockouts` | `LockoutReset` | |
| listDeletedDepartments | GET /v1/admin/deleted/departments | **S2** | `OrganizationAdminRepository.listDeletedDepartments(page:)` | `PageSlice<DeletedDepartment>` | program başlığı ara katmandan (seçili kapsam). `deleted_at` dizge, okunamazsa boş → `DateTime?` (`tryParse`); `kind` → `DepartmentKind` |
| restoreDepartment | PATCH /v1/admin/restore/departments/{id} | **S2** | `OrganizationAdminRepository.restoreDepartment` | `LifecycleStatus` | `restored`/`purged`/`unknown` |
| permanentDeleteDepartment | DELETE /v1/admin/permanent/departments/{id} | **S2** | `OrganizationAdminRepository.permanentDeleteDepartment` | `LifecycleStatus` | |
| listDeletedAccounts | GET /v1/admin/deleted/accounts | S1 | `OrganizationAdminRepository.listDeletedAccounts(page:)` | `PageSlice<DeletedAccount>` | |
| restoreAccount | PATCH /v1/admin/restore/accounts/{id} | S1 | `OrganizationAdminRepository.restoreAccount` | `LifecycleStatus` | |
| permanentDeleteAccount | DELETE /v1/admin/permanent/accounts/{id} | S1 | `OrganizationAdminRepository.permanentDeleteAccount` | `LifecycleStatus` | |

## platform (4)

| operationId | yöntem yol | kapsam | Flutter karşılığı | domain tipi | not |
|---|---|---|---|---|---|
| healthLive | GET /healthz/live | S0 | **yok — core'da eksik** | — | Süreç canlılık yoklaması (işletim/yük dengeleyici içindir). Mobil akışta kullanılmıyor; gerekirse `lib/core/server/` ya da `lib/core/network/` içinde yazılmalı (bu parça core'a yazmaz) |
| healthReady | GET /healthz/ready | S0 | **yok — core'da eksik** | — | Aynı gerekçe |
| systemInfo | GET /.well-known/nizamio-instance | S0 | `ServerBindingController.verify` (`lib/core/server/server_binding.dart`) | `ServerInfo` (core) | `capabilities` taşınmıyor (core kararı) |
| instanceProfile | GET /v1/instance/profile | S0 | `ServerBindingController.verify` (`lib/core/server/server_binding.dart`) | `ServerInfo` (core) | `timezone` `ServerInfo`'ya taşınmıyor — "bugün" hesabı için gerekecek (boşluk analizi Ortak §4; core'da eksik) |

## Domain değişiklikleri

- `lib/features/scope/domain/program.dart` → `Program.description` (isteğe bağlı) eklendi, `==`/`hashCode`'a girdi; yeni `ProgramDepartmentLink`.
- `lib/features/scope/domain/my_department.dart` (yeni) → `DepartmentRole { coordinator, member, unknown }` (sunucu değeri `wire`, `fromWire`) ve `MyDepartment`. `TeamRole` (sunum; admin/coordinator/member, `unknown` yok, kapsamlı `switch`'lerde kullanılıyor) ile örtüşür ama `admin` departman rolü değil şirket yöneticisi bayrağıdır; `TeamRole` kırılmamak için değiştirilmedi — entegrasyonda karar.
- `lib/features/scope/scope.dart` → `DepartmentRole`, `MyDepartment`, `ProgramDepartmentLink` dışa verildi.
- `lib/features/coordinatorships/domain/coordinatorship_overview.dart` → `TeamMember` genişletildi: `accountId`, `membershipId`, `role` (`DepartmentRole?`), `status` (`MemberStatus?`) eklendi; `unit` zorunludan varsayılanlıya (`''`) çevrildi (sunucuda yok — dokümantasyon yorumu). Mevcut UI çağrıları değişmedi.
- `lib/features/coordinatorships/domain/department.dart` (yeni) → `DepartmentKind` (wire: `koordinatorluk`/`calisma_grubu`, `unknown`), `MemberStatus`, `Department`, `AssignableAccount`, `Membership` (`Membership` + `CoordinatorResult`), `MembershipChange`, `DepartmentTaskSummary`. `Department` ↔ `CoordinatorshipProfile`: `code`/`about` örtüşür; profil kimlik taşımıyor ve zorunlu alanlarının (üst birim, kuruluş tarihi, alt birimler, sohbet, etkinlik) sunucu karşılığı yok → profil olduğu gibi bırakıldı, birleştirme entegrasyonda.
- `lib/features/coordinatorships/domain/department_repository.dart` (yeni) → `DepartmentRepository` arayüzü (12 işlem); uygulama `data/department_api_repository.dart` (`ApiDepartmentRepository`).
- `lib/features/coordinatorships/coordinatorships.dart` → domain tipleri ve `DepartmentRepository` dışa verildi.
- `lib/features/administration/` (yeni feature; yalnız `domain/` + `data/`, modül/UI/açık yüz yok):
  - `domain/organization_admin.dart` → `UserSortField`, `SortDirection`, `LifecycleStatus`, `KnownUser`, `UserChange`, `AccountChange`, `LockoutReset`, `DeletedAccount`, `DeletedDepartment`.
  - `domain/organization_admin_repository.dart` → `OrganizationAdminRepository` (15 işlem); `data/organization_admin_api_repository.dart` (`ApiOrganizationAdminRepository`).
  - `domain/program_admin.dart` → `ProgramCreation`, `ProgramReset`, `TransferPreview`, `TransferOutcome`, `TransferRecord`.
  - `domain/program_admin_repository.dart` → `ProgramAdminRepository` (8 işlem, 9 metot); `data/program_admin_api_repository.dart` (`ApiProgramAdminRepository`).
- `lib/features/identity/domain/download_ticket.dart` (yeni) → `DownloadTicket` (`toString` gizli); `identity.dart` dışa verir. `IdentityRepository` yapıcı imzası değişmedi (`IdentityRepository(Dio)`); mevcut metotlar aynı.
- `ProgramRepository` yapıcı imzası değişmedi (`ProgramRepository(Dio)`); içeride ek olarak `OrganizationClient` kurulur.

## Ortaklaştırma adayları

1. **Kesilme başlığı okuma** (`X-Result-Truncated` tek değer `true`): `ProgramRepository._truncated`, `ApiDepartmentRepository._truncated`, `ApiOrganizationAdminRepository._truncated` aynı kod. `lib/core/domain/page_slice.dart` ya da `lib/core/api/` altında tek yardımcı olmalı (ör. `PageSlice.fromHeaders`).
2. **`DepartmentRole` / `DepartmentKind`**: birkaç feature'ın ortak sözlüğü (scope, coordinatorships, administration; ileride tasks/reporting). Şimdilik scope ve coordinatorships açık yüzünden taşınıyor; `lib/core/domain/` adayı.
3. **Bilet tüketimi / ikili yanıt**: `redeemDownloadTicket` üretilmiş imzası `void`. Uygulama içi indirme gerekirse core'da `ResponseType.bytes/stream` ile ham Dio yolu (ve indirme yöneticisi bağlaması) gerekir.
4. **`healthLive`/`healthReady`**: core'da karşılık yok; bağlantı izleyicisi (`lib/core/network/`) için gerekirse oraya.
5. **`InstanceProfile.timezone`**: `ServerInfo`'ya taşınmalı (core).
