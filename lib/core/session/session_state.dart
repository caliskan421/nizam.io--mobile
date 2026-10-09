/// Oturum durumu (bağ doğrulandıktan sonraki katman).
sealed class SessionState {
  const SessionState();
}

/// Oturum yok (hiç giriş yapılmadı ya da çıkış yapıldı).
final class SessionNone extends SessionState {
  const SessionNone();
}

/// Oturum açık. [forcePasswordChange] açıkken S1+ uçlar 403 döner (REQ-IDENTITY-010).
final class SessionActive extends SessionState {
  const SessionActive({
    required this.accountId,
    required this.forcePasswordChange,
  });
  final String accountId;
  final bool forcePasswordChange;
}

/// Neden yeniden giriş gerekiyor.
enum ReauthReason {
  /// Yenileme zaman aşımı/ağ hatası/5xx ile BELİRSİZ düştü: sunucu döndürmüş olabilir; aynı
  /// belirteçle tekrar denemek tekrar kullanım (TB-16) sayılıp hesabın bütün oturumlarını
  /// düşürebilir. K-05 istemci kuralı: tekrar deneme yok (geçici fail-secure).
  refreshAmbiguous,

  /// Sunucu yenilemeyi açıkça reddetti (401).
  refreshRejected,

  /// Güvenli depo yazılamadı/okunamadı: yeni çift kalıcılaşmadı ya da kayıt okunamadı.
  /// Oturum etkin sayılmaz (CX-Ö-04).
  secureStorageFailure,
}

/// Yeniden giriş gerekli; belirteçler silindi, yenileme isteği GÖNDERİLMEZ.
final class SessionReauthRequired extends SessionState {
  const SessionReauthRequired(this.reason);
  final ReauthReason reason;
}
