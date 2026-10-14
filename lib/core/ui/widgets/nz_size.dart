/// Kit bileşenlerinin ortak boyut ölçeği (küçük · orta · büyük).
enum NzSize {
  sm,
  md,
  lg;

  /// Boyuta göre değer seçimi (bileşenler kendi ölçü tablosunu bununla yazar).
  T pick<T>({required T sm, required T md, required T lg}) => switch (this) {
    NzSize.sm => sm,
    NzSize.md => md,
    NzSize.lg => lg,
  };
}
