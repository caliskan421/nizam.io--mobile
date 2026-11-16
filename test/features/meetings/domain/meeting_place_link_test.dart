// Toplantı yerindeki çevrim içi bağlantının tanınması (iPad notu 1).
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/meetings/domain/meeting.dart';

final _at = DateTime(2026, 11, 14);

Meeting _m(String? place) => Meeting(
  id: 'm',
  programId: 'p',
  ownerDepartmentId: 'd',
  title: 't',
  meetingDate: _at,
  membersIncluded: false,
  createdByAccountId: 'a',
  createdByRole: MeetingRole.admin,
  createdAt: _at,
  updatedAt: _at,
  departments: const [MeetingDepartment(id: 'd', name: 'D')],
  place: place,
);

void main() {
  test('düz metin ve boş yer bağlantı değildir', () {
    expect(_m(null).placeLink, isNull);
    expect(_m('Toplantı salonu').placeLink, isNull);
    expect(_m('zoom.us/j/1').placeLink, isNull);
    expect(_m('ftp://x.y/z').placeLink, isNull);
  });

  test('metindeki ilk http(s) bağlantısı alınır', () {
    expect(
      _m('https://zoom.us/j/123?pwd=x').placeLink.toString(),
      'https://zoom.us/j/123?pwd=x',
    );
    expect(
      _m('Zoom: HTTPS://meet.example.com/abc  (şifre 1)').placeLink?.host,
      'meet.example.com',
    );
  });
}
