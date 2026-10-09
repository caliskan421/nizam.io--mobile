/// `MAJOR.MINOR.PATCH` karşılaştırması (`minimum_mobile_version`, K-11). Ön sürüm/derleme
/// eki kabul edilmez: sunucu deseni `^[0-9]+\.[0-9]+\.[0-9]+$`.
final class SemVer implements Comparable<SemVer> {
  const SemVer(this.major, this.minor, this.patch);

  final int major;
  final int minor;
  final int patch;

  static SemVer? tryParse(String s) {
    final m = RegExp(r'^(\d+)\.(\d+)\.(\d+)$').firstMatch(s);
    if (m == null) return null;
    return SemVer(
      int.parse(m.group(1)!),
      int.parse(m.group(2)!),
      int.parse(m.group(3)!),
    );
  }

  @override
  int compareTo(SemVer o) => major != o.major
      ? major.compareTo(o.major)
      : minor != o.minor
      ? minor.compareTo(o.minor)
      : patch.compareTo(o.patch);

  bool operator <(SemVer o) => compareTo(o) < 0;

  @override
  String toString() => '$major.$minor.$patch';
}
