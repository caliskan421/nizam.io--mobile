/// Beklenen (hata olmayan) alan sonucu işareti: normal akışın parçası olan, kendi kodumuzun
/// bilerek fırlattığı istisnalar (özellik kapalı, sınır aşıldı, kullanıcı iptali …) bu arayüzü
/// uygular. Hata raporlama bunları HİÇ raporlamaz (sağlayıcı gözlemcisi, `catch` sınırı ve
/// küresel kancalar dahil). Tür adına ya da `_` önekine güvenilmez; yalnız bu açık işaret sayılır.
///
/// Yalnız dar, gerçekten beklenen sonuçlara eklenir; sınıflandırılamayan hata bu işareti
/// taşımaz ve rapor edilir.
abstract interface class ExpectedFailure {}
