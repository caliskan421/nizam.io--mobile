import 'package:meta/meta.dart';

import 'task_catalog.dart';

/// Kişi kipindeki toplantının davet havuzu (ADR-0031, COLLABORATION-K21): toplantının
/// programında ekip satırı olan kişiler, koordinatörlük gruplarında. Sunucu ayrıca adayı
/// denetler (program ekibinde değilse 422 `collaboration.participant_invalid`).
///
/// [partial] havuzun eksik olabileceğini söyler (yalnız erişilebilen ekipler ya da kesilmiş
/// liste); ekran bunu kullanıcıya açıkça yazar, eksik kişi uydurulmaz.
@immutable
final class MeetingInvitees {
  MeetingInvitees({
    required List<CoordinatorshipRef> groups,
    List<PersonName> names = const [],
    this.partial = false,
  }) : groups = List.unmodifiable([
         for (final g in groups)
           if (g.team.isNotEmpty) g,
       ]),
       names = List.unmodifiable(names);

  /// Ekibi boş olmayan koordinatörlükler.
  final List<CoordinatorshipRef> groups;

  /// Havuzun taşıdığı adlar (katalogda olmayan kişiler için).
  final List<PersonName> names;
  final bool partial;

  late final _byId = {for (final n in names) n.id: n.name};

  /// Havuzun taşıdığı ad (yoksa null; çağıran katalog adına düşer).
  String? nameOf(String id) => _byId[id];

  /// [own]: katalogdaki okunabilen ekipler (koordinatörü olunan departmanlar). Önce kendi
  /// koordinatörlükler, sonra programın diğerleri; aynı departmanın ekipleri birleşir (bir kişi
  /// bir yerde koordinatörse orada koordinatör sayılır).
  MeetingInvitees withTeams(List<CoordinatorshipRef> own) {
    final byCode = {for (final g in groups) g.code: g};
    CoordinatorshipRef merge(CoordinatorshipRef a, CoordinatorshipRef? b) {
      if (b == null) return a;
      final leads = {...a.leads, ...b.leads};
      return CoordinatorshipRef(
        code: a.code,
        name: a.name,
        shortCode: a.shortCode ?? b.shortCode,
        leads: leads.toList(),
        members: [
          for (final id in {...a.members, ...b.members})
            if (!leads.contains(id)) id,
        ],
      );
    }

    final mine = {for (final g in own) g.code};
    return MeetingInvitees(
      groups: [
        for (final g in own) merge(g, byCode[g.code]),
        for (final g in groups)
          if (!mine.contains(g.code)) g,
      ],
      names: names,
      partial: partial,
    );
  }
}

/// Program kişilerinin kaynağı (yönetici olmayan koordinatör için; yönetici kataloğun bütün
/// ekiplerini zaten okur).
abstract interface class MeetingInviteeRepository {
  /// [departmentId]: çağıranın bu programda koordinatörü olduğu bir departman. Dönen havuz o
  /// departmanın ekibi DIŞINDA kalan, programda ekip satırı olan kişilerdir (`listAssignable`
  /// rolleri) ve departman adları (`listProgramDepartments`).
  Future<MeetingInvitees> programPeople(String departmentId);
}
