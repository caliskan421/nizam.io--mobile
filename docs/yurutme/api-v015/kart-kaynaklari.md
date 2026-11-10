# Kart ve kapsam kaynakları

Uygulama öncesi kaynak haritası; M015-5 sonunda kodla tekrar doğrulanacak.

| Görünüm | Kaynak | Kapsam / karar |
|---|---|---|
| Sidebar seçili dönem rozeti | readProgram | Seçili program; kısa ad/renk aynı yanıtta; ek istek yok |
| Dönem seçim listesi | listPrograms | Hesabın erişebildiği programlar; ad/renk var, görev sayacı yok; dönem başına sayaç çağrısı yok |
| Yönetici ana sayfa görev/ekip/koordinatörlük özetleri | reportDashboard | Seçili programdaki canlı bağlı departmanlar; mevcut tek özet yanıtı korunur |
| Ana sayfa bekleyen işler | reportDashboardTasks + listDateChangeRequests | Satır ayrıntısı için gerekli; salt sayaç ucu bunların yerine geçmez |
| Okunmamış mesaj rozeti | getChatUnreadOverview | Seçili programın sayısı; görev sayacıyla birleştirilmez |
| Kullanıcı sekme rozetleri | listUsers.role_counts | Rol hariç geçerli arama/program/departman filtreleri; roller örtüşebilir, toplamları kişi sayısı değildir |
| Kullanıcı liste toplamı | listUsers.total | Rol dahil bütün filtreler; aynı yanıtta sayfa+toplam+sayaç |
| Kullanıcı profili | readUser | Yönetici yüzü; tek hesap; liste sayfaları taranmaz |
| Görev listesi sayaçları | Tam katalog veya gerektiğinde countProgramWorkItems | Görünür görev listesiyle aynı filtre; kısmi katalog kesin toplam sayılmaz; sırf sayaç için tüm sayfaları çekme yok |
| Koordinatör/üye ana sayfası | Mevcut yetkili katalog + ilgili ekler | Yönetici reporting uçları bu rollere taşınmaz; görünür görev kümesi korunur |

reportDashboard ve countProgramWorkItems eşdeğer değildir: yönetici görev listesi/sayacı silinmiş departmanda kalan canlı görevleri de kapsayabilir, pano raporu kapsamaz. İki ayrı isteğin aynı anın snapshot'ı olduğu iddia edilmez. Hata/yükleme durumu sıfır sayıyla maskelenmez. Dönem/hesap geçişinde önceki kapsamın veri ve rozetleri yeni başlık altında gösterilmez.
