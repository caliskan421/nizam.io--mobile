## Ne değişti

- Faz / dilim: <!-- ör. F14 MOB-0 -->
- Değişen modül(ler):

## Backend sözleşmesi

- Kullanılan backend etiketi: <!-- ör. v0.1.0-api -->
- Dokunulan uçlar:
- Spec veya üretilen tipler değişti mi? <!-- evet/hayır; evetse neden -->

## UI kod standartları (yol haritası §5)

- [ ] Ekranda ham renk/TextStyle/sayısal boşluk yok (U2/U3, `Gap` + `NzGap`).
- [ ] Ekran `NzPage` ile başlar; async veri `NzAsyncView`; hatalar `ref.listenErrors`.
- [ ] Widget `build` metodu ~80 satırı aşıyorsa alt widget'a (yardımcı metot değil, sınıf)
      bölünür; `const` yapıcı.
- [ ] Controller'da iş kuralı yok; servis/repository'de. Controller DTO görmez.
- [ ] Kullanıcı metni yalnız ARB'den (`context.l10n`); hata metni yalnız `errorText`.
- [ ] Yeni kit bileşeni: golden + davranış testi.
- [ ] Yeni tercih: `AppPreferences` adlandırılmış metot + controller + sağlayıcı.
- [ ] Yeni rota: tipli rota sınıfı; nesne değil kimlik taşır.
- [ ] Uyarlanabilirlik: compact ve expanded'da test edildi; metin ölçeği 2.0'da taşma yok.
- [ ] Yeni service/repository/controller/kit bileşeni için test dosyası var (Q2); kapsama
      eşiği korunuyor (Q1).
- [ ] Yeni feature modülü bileşim köküne eklendi, portları geçersiz kılındı (Q3 yeşil).

## Kanıt

- [ ] CI yeşil (flutter analyze, format, test, üretilen kod diff = 0, debug build, integration_test)
- [ ] Belirteç yalnız güvenli depoda, log'da yok; sunucu bağı fail-closed; kapsam başlıkları doğru
- Ekran görüntüsü / test çıktısı:

## Açık kalan / riskler
