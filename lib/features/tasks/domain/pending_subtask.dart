/// Gönderilemeyen yeni alt görevin idempotency gövdesi `ad|kanıt bayrağı` biçimindedir;
/// diyalog aynı ad ve kanıt seçimiyle açılır ki aynı gövde aynı anahtarla yeniden gitsin.
({String title, bool evidenceRequired})? parsePendingSubtask(String? body) {
  final m = body == null ? null : _pending.firstMatch(body);
  return m == null ? null : (title: m[1]!, evidenceRequired: m[2] == 'true');
}

final _pending = RegExp(r'^(.+)\|(true|false)$', dotAll: true);
