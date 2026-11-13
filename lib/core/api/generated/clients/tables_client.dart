// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/table_changes.dart';
import '../models/table_command.dart';
import '../models/table_comment_page.dart';
import '../models/table_copy_request.dart';
import '../models/table_create_request.dart';
import '../models/table_list.dart';
import '../models/table_presence_request.dart';
import '../models/table_project_command.dart';
import '../models/table_project_list.dart';
import '../models/table_project_result.dart';
import '../models/table_proposal_decision_request.dart';
import '../models/table_proposal_decision_result.dart';
import '../models/table_proposal_list.dart';
import '../models/table_result.dart';
import '../models/table_snapshot.dart';
import '../models/template.dart';

part 'tables_client.g.dart';

@RestApi()
abstract class TablesClient {
  factory TablesClient(Dio dio, {String? baseUrl}) = _TablesClient;

  static const Map<String, dynamic> listTablesOpenapiExtras = <String, dynamic>{
    'openapi': <String, dynamic>{
      'tags': <String>["tables"],
      'operationId': "listTables",
      'externalDocsUrl': null,
    },
  };
  static const Map<String, dynamic> createTableOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["tables"],
          'operationId': "createTable",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> getTableOpenapiExtras = <String, dynamic>{
    'openapi': <String, dynamic>{
      'tags': <String>["tables"],
      'operationId': "getTable",
      'externalDocsUrl': null,
    },
  };
  static const Map<String, dynamic> getTableChangesOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["tables"],
          'operationId': "getTableChanges",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> getTableCommentsOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["tables"],
          'operationId': "getTableComments",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> streamTableChangesOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["tables"],
          'operationId': "streamTableChanges",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> setTablePresenceOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["tables"],
          'operationId': "setTablePresence",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> leaveTablePresenceOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["tables"],
          'operationId': "leaveTablePresence",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> attachTableFileOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["tables"],
          'operationId': "attachTableFile",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> downloadTableAttachmentOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["tables"],
          'operationId': "downloadTableAttachment",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> applyTableOperationOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["tables"],
          'operationId': "applyTableOperation",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> listTableProjectsOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["tables"],
          'operationId': "listTableProjects",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> applyTableProjectCommandOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["tables"],
          'operationId': "applyTableProjectCommand",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> copyTableToCoordinatorshipOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["tables"],
          'operationId': "copyTableToCoordinatorship",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> copyTableToPersonalOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["tables"],
          'operationId': "copyTableToPersonal",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> listTableProposalsOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["tables"],
          'operationId': "listTableProposals",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> decideTableProposalOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["tables"],
          'operationId': "decideTableProposal",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> listPersonalTablesOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["tables"],
          'operationId': "listPersonalTables",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> createPersonalTableOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["tables"],
          'operationId': "createPersonalTable",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> getPersonalTableOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["tables"],
          'operationId': "getPersonalTable",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> attachPersonalTableFileOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["tables"],
          'operationId': "attachPersonalTableFile",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic>
  downloadPersonalTableAttachmentOpenapiExtras = <String, dynamic>{
    'openapi': <String, dynamic>{
      'tags': <String>["tables"],
      'operationId': "downloadPersonalTableAttachment",
      'externalDocsUrl': null,
    },
  };
  static const Map<String, dynamic> getPersonalTableChangesOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["tables"],
          'operationId': "getPersonalTableChanges",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> getPersonalTableCommentsOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["tables"],
          'operationId': "getPersonalTableComments",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> streamPersonalTableChangesOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["tables"],
          'operationId': "streamPersonalTableChanges",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> setPersonalTablePresenceOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["tables"],
          'operationId': "setPersonalTablePresence",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> leavePersonalTablePresenceOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["tables"],
          'operationId': "leavePersonalTablePresence",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> applyPersonalTableOperationOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["tables"],
          'operationId': "applyPersonalTableOperation",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> listPersonalTableProjectsOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["tables"],
          'operationId': "listPersonalTableProjects",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic>
  applyPersonalTableProjectCommandOpenapiExtras = <String, dynamic>{
    'openapi': <String, dynamic>{
      'tags': <String>["tables"],
      'operationId': "applyPersonalTableProjectCommand",
      'externalDocsUrl': null,
    },
  };

  /// Kapsamdaki sahip olunan ya da paylaşılmış tabloları listeler.
  ///
  /// Program + departman kapsamında aktörün sahibi olduğu ya da açıkça paylaşılmış.
  /// (editor/viewer) silinmemiş tablolar, `(created_at, id)` sırasıyla keyset.
  /// sayfalı; `next_cursor` yalnız sonraki sayfa varsa döner (TABLES-K01,.
  /// TABLES-K08). Kapsam.
  /// başlığı tek başına yetki vermez: bağlı kapsamın ekibi ya da şirket yöneticisi.
  /// olmayan aktör 403 `tables.forbidden`; bağlı olmayan kapsam 404.
  ///
  /// [template] - `true`: yalnız şablon bayraklı tablolar; ACL süzgeci aynıdır (TABLES-K16).
  @GET('/v1/tables')
  Future<TableList> listTables({
    @Query('limit') int? limit = 100,
    @Query('cursor') String? cursor,
    @Query('template') Template? template,
    @Extras()
    Map<String, dynamic>? extras = TablesClient.listTablesOpenapiExtras,
  });

  /// Kapsamda yeni tablo oluşturur; oluşturan sahiptir.
  ///
  /// Bağlı kapsamın ekibi ya da şirket yöneticisi tablo açar ve sahibi olur.
  /// (TABLES-K01, TABLES-K02). Yeni tablo 201. `Idempotency-Key` zorunludur (TABLES-K04; ADR-0027): eksik ya da.
  /// kırpılmış hâli 22–200 bayt dışında anahtar 422 `tables.input_invalid`.
  /// (alan `idempotency_key`, kod `tables.request_key_required` /.
  /// `tables.request_key_invalid`). Anahtar aktör kapsamlıdır. Aynı anahtar +.
  /// aynı istek (kapsam, tablo ve komutun sabit alan sıralı JSON.
  /// serileştirmesi; semantik kanonikleştirme yapılmaz, hücre değeri.
  /// boşluklar dışında gönderildiği gibi karşılaştırılır: `"a"` ile `"\u0061"` ya da `1e3`.
  /// ile `1000` farklı istektir) komutu ikinci kez.
  /// uygulamaz: ilk makbuz `replayed: true` ile döner, audit yazılmaz;.
  /// tekrar yine güncel erişim ister. Aynı anahtar farklı istekle 409.
  /// `tables.idempotency_key_reused`. Yazma yasağı (güncelleme penceresi).
  /// 409 `provisioning.write_not_allowed`.
  /// Oluşturma tekrarı 200 ile ilk tablonun makbuzunu döndürür; ilk tabloya.
  /// aynı kapsamda artık erişilemiyorsa ya da tablo silinmişse 404.
  /// `tables.not_found` (silinmiş tabloda yalnız aynı anahtarlı silme.
  /// tekrarı 200 alır).
  ///
  /// [idempotencyKey] - İstemcinin ürettiği opak işlem anahtarı (en az 128 bit; ör. base64url 22 karakter; ADR-0027). Uzunluk baştaki/sondaki boşluk kırpıldıktan sonra bayt olarak 22–200'dür. Eksik ya da sınır dışı anahtar 422; program aktarımında `program.transfer_input_invalid`, oluşturma uçlarında modülün `<mod>.input_invalid` zarfı (alan `idempotency_key`, kod `<mod>.request_key_required` / `<mod>.request_key_invalid`). Aynı anahtar + aynı istek ilk sonucu döndürür (oluşturmada 200 + kaynağın bugünkü temsili, güncel görme yetkisiyle); farklı istek 409 `<mod>.idempotency_key_reused`. Anahtar aktör + uç tablosu kapsamındadır; sunucu kaynağı yaşadıkça tutar (kalıcı silinen kaynakta anahtar da gider).
  @POST('/v1/tables')
  Future<TableResult> createTable({
    @Header('Idempotency-Key') required String idempotencyKey,
    @Body() required TableCreateRequest body,
    @Extras()
    Map<String, dynamic>? extras = TablesClient.createTableOpenapiExtras,
  });

  /// Tablonun şemasını ve bir satır sayfasını hücreleriyle okur.
  ///
  /// Sahip, editor ve viewer okur (TABLES-K02); başka kapsamdaki, silinmiş ya da.
  /// paylaşılmamış tablo 404 `tables.not_found`. Satırlar konuma göre keyset.
  /// sayfalanır (TABLES-K08). Tablo referansının erişimi hücreleri çözen SQL.
  /// ifadesinin görüntüsünde denetlenir; bu görüntüde erişimi kaybolmuş referans.
  /// `null` döner (TABLES-K07). Sonraki erişim iptali devam eden yanıtı geri.
  /// çekmez; sonraki okumada görünür. Sayfanın hücre toplamı 8 MiB'ı aşarsa 409.
  /// `tables.limit_reached`; istemci `limit` değerini düşürür.
  ///
  /// [cursor] - Süzgeç/sıralama yoksa satır konumu (eski sayısal imleç, bayatlık denetimi yok). Süzgeç ya da sıralama varken yalnız `next_cursor` ile dönen `v2.` önekli opak imleç; tablo/şema/sıra, sorgu ya da görünür izdüşüm değişmişse 409 `tables.cursor_stale` (TABLES-K21).
  ///
  /// [filter] - En çok 3 süzgeç, `sütun:op:değer` (değer ≤ 1000 bayt; `:` içerebilir). İşleçler: metin/telefon/e-posta/tarih eq, ne, lt, gt, contains, empty; sayı eq, ne, lt, gt, empty (tam ondalık); onay kutusu eq (true/false), empty; referans ve ek eq (görünür kimlik), contains (görünen ad), empty (görünür izdüşüm boş). `empty` değersizdir. Metin karşılaştırması bayt sıralı (C), contains büyük/küçük harf duyarlı. Gizli ya da olmayan referans eşitliği aynı 422 `tables.reference_unavailable`; seçilen referans sütunlarında 20000'den çok farklı saklı kimlik 422 `tables.query_too_broad`.
  ///
  /// [sort] - En çok 2 anahtar, `sütun:asc|desc`. Boş değerler her yönde sonda; eşitlikte satır konumu, sonra satır kimliği. Referans ve ek sütunları görünen adlara (çoklu hücrede saklanan sırayla ad dizisi) göre sıralanır.
  @GET('/v1/tables/{tableID}')
  Future<TableSnapshot> getTable({
    @Path('tableID') required String tableId,
    @Query('limit') int? limit = 100,
    @Query('cursor') String? cursor,
    @Query('filter') List<String>? filter,
    @Query('sort') List<String>? sort,
    @Extras() Map<String, dynamic>? extras = TablesClient.getTableOpenapiExtras,
  });

  /// Tablonun `after` imlecinden sonraki olay metadata'sını artan sırayla okur.
  ///
  /// Kalıcı olay replay'i (ADR-0039). Yetki Get ile aynıdır ve her çağrıda.
  /// güncel kapsam/tablo ACL'siyle denetlenir (TABLES-K23); eski olay görmüş.
  /// olmak erişim vermez. Yanıt yalnız `{table_id, seq, kind}` taşır; içerik.
  /// güncel snapshot'tan (`GET /v1/tables/{tableID}`) aynı ACL ve referans.
  /// redaksiyonuyla okunur. İmleç ilk snapshot sayfasının `table.sequence`.
  /// değeridir; sayfalar arasında `table.sequence` değişirse snapshot yürüyüşü.
  /// yeniden başlar. 409 `tables.replay_expired` `after` alanının iletisinde.
  /// nedeni taşır: `future` (imleç güncel sıradan büyük), `baseline` (olay.
  /// tabanından küçük; oluşturma, kopya ve geçiş öncesi geçmiş yoktur),.
  /// `window` (güncel sıradan 10000'den fazla geride; yaş ufku yoktur),.
  /// `gap` (beklenen aralıkta kalıcı olay eksik). İstemci yerel görünümü.
  /// bırakıp güncel snapshot alır. Harici referans etiketi/görünürlüğü ve.
  /// proje silme tablo sırasını artırmaz; olay üretmez.
  ///
  /// [after] - Son tüketilen olay sırası; işaretsiz ondalık, baştaki sıfırsız (tek `0` hariç), en çok 19 hane. Eksik, tekrarlı, bozuk ya da negatif imleç 422 `tables.input_invalid`.
  @GET('/v1/tables/{tableID}/changes')
  Future<TableChanges> getTableChanges({
    @Path('tableID') required String tableId,
    @Query('after') required String after,
    @Query('limit') int? limit = 100,
    @Extras()
    Map<String, dynamic>? extras = TablesClient.getTableChangesOpenapiExtras,
  });

  /// Tablonun yorumlarını değişmez oluşturma sırasıyla (seq) sayfalar.
  ///
  /// Satır/hücre yorumlarının tek okuma yüzü (ADR-0040, TABLES-K26). Yetki Get.
  /// ile aynıdır ve her çağrıda güncel kapsam/tablo ACL'siyle denetlenir; özel.
  /// tabloda şirket yöneticisi ya da koordinatör bypass'ı yoktur. Yorum.
  /// içeriği YALNIZ burada okunur: snapshot, `changes`, SSE, makbuz ve audit.
  /// yorum metni taşımaz. İmleç kimliğe değil yorumun DEĞİŞMEZ oluşturma.
  /// `seq`'ine dayanır (düzenleme, ekleme ve silme sayfayı kaydırmaz);.
  /// `next_cursor` yalnız sonraki sayfa varsa gelir. `row_id` verilirse o.
  /// satırın yorumları (olmayan satır boş sayfa). Yazar yalnız okuyana görünüyorsa.
  /// `author` doludur (hesap görünürlüğü kişi referansıyla aynı kuraldır);.
  /// görünmüyorsa `null` (kimlik/e-posta yok), `mine` ayrıca okuyanın kendi.
  /// yorumu olup olmadığını söyler. Yorum yazma/düzenleme/silme mevcut işlem.
  /// ucundadır (`add_comment`, `edit_comment`, `delete_comment`).
  ///
  /// [rowId] - Yalnız bu satırın yorumları; verilirse boş olamaz.
  ///
  /// [cursor] - Son tüketilen yorumun `seq` değeri (önceki sayfanın `next_cursor`'ı).
  @GET('/v1/tables/{tableID}/comments')
  Future<TableCommentPage> getTableComments({
    @Path('tableID') required String tableId,
    @Query('limit') int? limit = 50,
    @Query('row_id') String? rowId,
    @Query('cursor') String? cursor,
    @Extras()
    Map<String, dynamic>? extras = TablesClient.getTableCommentsOpenapiExtras,
  });

  /// Tablonun canlı akışı (SSE; içeriksiz sıra uyarıları).
  ///
  /// Canlı akış (ADR-0039 "Akış"). Doğruluk kaynağı değildir: çerçeveler yalnız.
  /// `{table_id, sequence}` taşır (hücre, ad, aktör, paylaşım hedefi, referans,.
  /// ek, payload yok); içerik `changes` + güncel snapshot'tan okunur.
  ///
  /// Açılış: abonelik kurulur, SONRA güncel ACL ile taze sıra okunur (Get ile.
  /// aynı yetki zinciri); hata başlıklardan önce normal hata zarfıyla döner.
  /// İlk çerçeve `event: ready` güncel sırayı taşır. Sonra her yeni commit için.
  /// `event: changed` (birleştirilebilir; yalnız artan sıra) ve 25 sn'de bir.
  /// `: ping` yazılır. Her `changed` ve her kalp atışından önce sunucu güncel.
  /// ACL ile sırayı yeniden okur; kalp atışı kayıp uyarıyı ve başka süreçteki.
  /// commit'i de `changed` ile bildirir.
  ///
  /// `event: presence` (ADR-0040) ayrı ve dardır: yalnız katılımcı listesi.
  /// değiştiğinde, en çok saniyede bir (birleştirilmiş) yazılır; liste hiç.
  /// olmadıysa yazılmaz. Her presence çerçevesinden önce alıcının güncel ACL'si.
  /// ve listedeki her gönderenin güncel oturumu, hesabı, kapsam üyeliği, tablo.
  /// erişimi ve satır/sütun varlığı doğrulanır; doğrulanamayan gönderen listeden.
  /// çıkar. Değerlendirme presence değişiminde, `changed` ve kalp atışı.
  /// sonrasında yapılır (sessiz çıkış en geç bir kalp atışı aralığında düşer).
  /// Alıcının kendi oturumu listede yoktur. Paylaşım/rol/taşıma/silme.
  /// commit'i bütün presence kayıtlarını siler.
  ///
  /// `ready` ve `changed` içindeki `sequence` tüketilmiş imleç DEĞİLDİR:.
  /// istemci `changes?after=<son başarılı changes cursor'ı>` ile aralığı kapatır.
  /// (ilk imleç snapshot'ın `table.sequence`'idir). Çerçevelerde `id:` alanı.
  /// yoktur; `Last-Event-ID` başlığı ve `after` sorgusu okunmaz. Yeniden.
  /// bağlanmada imleç yalnız son başarılı changes yanıtının `cursor`'ıdır.
  ///
  /// Akış kapanır: istemci kapatınca; `NIZAMIO_HTTP_STREAM_TIMEOUT` bütçesi.
  /// dolunca; tablonun paylaşımı, ekip rolü, alanı (taşıma) ya da silinmesi.
  /// commit edildiğinde (yerel abonelikler); bağımsız gözcü (25 sn aralık; tespit.
  /// en çok 25 + 2 = 27 sn; kapı + çözüm + okuma toplam 2 sn; açılış da en çok 2 sn) oturum iptali/süre dolumu/hesap kilidi, kapsam üyeliği.
  /// kaybı, tablo erişimi kaybı ya da doğrulanamayan okuma gördüğünde; hesap.
  /// tavanında en eski akış; sunucu kapanırken. Daha önce yetkiliyken yazılmış.
  /// ve ağa verilmiş bir çerçeve geri çekilemez; sınır içeriksiz bir sıra.
  /// değeridir. Belirteç yalnız `Authorization` başlığında taşındığı için.
  /// tarayıcı `EventSource` kullanamaz; fetch akışıyla okur.
  @GET('/v1/tables/{tableID}/stream')
  Future<String> streamTableChanges({
    @Path('tableID') required String tableId,
    @Extras()
    Map<String, dynamic>? extras = TablesClient.streamTableChangesOpenapiExtras,
  });

  /// Çağıran oturumun seçili hücresini yeniler (presence; kalıcı yazım yok).
  ///
  /// Presence (ADR-0040, TABLES-K25). Kayıt anahtarı `(tablo, hesap, oturum)`.
  /// olup süreç içi bellektedir; olay, sıra artışı, audit, makbuz ve işlem.
  /// anahtarı yoktur. Gövde `{row_id, column_id}`: ikisi birlikte dolu (seçim).
  /// ya da birlikte boş/`null` (seçimsiz) olmalıdır; aksi 422.
  /// `tables.input_invalid`. Viewer dahil her güncel okuyucu kullanır; kapsam,.
  /// tablo erişimi ve satır/sütun varlığı salt okuma transaction'ında yeniden.
  /// okunur (yok ise 404, yetkisizse 403/404 ve o oturumun kaydı silinir).
  /// Kayıt 30 sn yenilenmezse düşer; aynı seçimle yenileme yalnız süreyi.
  /// uzatır. Aynı oturumun kabul edilen iki yenilemesi arasında 1 sn'den kısa.
  /// süre ise DB'ye gidilmeden 429 `tables.presence_throttled` (Retry-After).
  /// Tablo başına 50 katılımcı, hesap başına 16 kayıt (en eskisi atılır),.
  /// toplam 10000 kayıt: tablo/toplam tavan dolu ise 503.
  /// `tables.stream_unavailable`. Presence yalnız POST'u alan sürecin.
  /// akışlarında görünür; çok süreçte dağıtık garanti yoktur.
  @POST('/v1/tables/{tableID}/presence')
  Future<void> setTablePresence({
    @Path('tableID') required String tableId,
    @Body() required TablePresenceRequest body,
    @Extras()
    Map<String, dynamic>? extras = TablesClient.setTablePresenceOpenapiExtras,
  });

  /// Çağıran oturumun presence kaydını siler (idempotent).
  ///
  /// Yalnız çağıran oturumun kendi kaydını siler; aynı hesabın diğer oturumları.
  /// ve başka hesaplar etkilenmez. Kayıt yoksa da 204 döner. DB okuması yoktur.
  @DELETE('/v1/tables/{tableID}/presence')
  Future<void> leaveTablePresence({
    @Path('tableID') required String tableId,
    @Extras()
    Map<String, dynamic>? extras = TablesClient.leaveTablePresenceOpenapiExtras,
  });

  /// Tablonun bir hücresine dosya yükler (multipart `file` parçası; akışla).
  ///
  /// Tablo eki, tablonun çocuğudur (TABLES-K15; ADR-0035); work ya da records.
  /// kaydı değildir. Owner ve editor yükler, viewer 403 `tables.forbidden`;.
  /// şirket yöneticisi ve koordinatör tek başına yükleyemez. Hedef hücre.
  /// sorguda taşınır: `row_id`, `column_id` (tipi `attachment` olan sütun) ve.
  /// `cell_version` (hücre CAS; 0 açık ilk yazımdır, eksik/negatif/sayı.
  /// olmayan değer 422). Hücrede aktif ek varsa yeni yükleme onu emekli eder.
  /// (nesnesi dönem temizliğine kadar saklanır). İzinli tür kümesi 11 türdür.
  /// (`pdf`, `png`, `jpg`, `csv`, `doc`, `docx`, `xls`, `xlsx`, `ppt`,.
  /// `pptx`, `pages`); bildirilen tür, ad uzantısı ve içerik imzası.
  /// uyuşmalıdır. Tek dosya tavanı kurulumun dosya tavanıdır (varsayılan.
  /// 90 MiB); tablo başına varsayılan sınırlar: 1000 aktif ek / 1 GiB aktif.
  /// bayt ve 4000 tutulan ek / 2 GiB tutulan fiziksel bayt. `Idempotency-Key`.
  /// zorunludur (TABLES-K04): aynı anahtar + aynı metadata (kapsam, tablo,.
  /// hücre, sürüm, ad, tür) ilk makbuzu `replayed: true` ile döndürür, gövde.
  /// okunmaz, nesne yazılmaz; makbuz dosya adı ya da depolama anahtarı.
  /// taşımaz. Bilinen sınır: aynı anahtar + aynı metadata + FARKLI içerik de.
  /// tekrar sayılır (içerik özeti alınmaz; ADR-0027). Yanıt `TableResult`'tır;.
  /// `id` yeni ek kimliğidir.
  ///
  /// [idempotencyKey] - İstemcinin ürettiği opak işlem anahtarı (en az 128 bit; ör. base64url 22 karakter; ADR-0027). Uzunluk baştaki/sondaki boşluk kırpıldıktan sonra bayt olarak 22–200'dür. Eksik ya da sınır dışı anahtar 422; program aktarımında `program.transfer_input_invalid`, oluşturma uçlarında modülün `<mod>.input_invalid` zarfı (alan `idempotency_key`, kod `<mod>.request_key_required` / `<mod>.request_key_invalid`). Aynı anahtar + aynı istek ilk sonucu döndürür (oluşturmada 200 + kaynağın bugünkü temsili, güncel görme yetkisiyle); farklı istek 409 `<mod>.idempotency_key_reused`. Anahtar aktör + uç tablosu kapsamındadır; sunucu kaynağı yaşadıkça tutar (kalıcı silinen kaynakta anahtar da gider).
  @MultiPart()
  @POST('/v1/tables/{tableID}/attachments')
  Future<TableResult> attachTableFile({
    @Path('tableID') required String tableId,
    @Query('row_id') required String rowId,
    @Query('column_id') required String columnId,
    @Query('cell_version') required int cellVersion,
    @Header('Idempotency-Key') required String idempotencyKey,
    @Part(name: 'file') required File file,
    @Extras()
    Map<String, dynamic>? extras = TablesClient.attachTableFileOpenapiExtras,
  });

  /// Tablonun AKTİF ekini indirir (güncel kaynak tablo ACL'siyle).
  ///
  /// Owner, editor ve viewer indirir; şirket yöneticisi ve koordinatör tek.
  /// başına indiremez. Erişimsiz, silinmiş, başka tabloya ait, emekli ya da.
  /// nesnesi olmayan ek aynı 404 `tables.not_found`'tır. Başlamış akışta sonradan.
  /// iptal edilen erişim geriye dönük bayt kesmez; sonraki istek reddedilir.
  /// Yanıt `X-Content-Type-Options: nosniff` ve `Cache-Control: private, no-store`.
  /// taşır.
  @GET('/v1/tables/{tableID}/attachments/{attachmentID}')
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse<List<int>>> downloadTableAttachment({
    @Path('tableID') required String tableId,
    @Path('attachmentID') required String attachmentId,
    @Extras()
    Map<String, dynamic>? extras =
        TablesClient.downloadTableAttachmentOpenapiExtras,
  });

  /// Tabloya tek şema, satır, hücre ya da paylaşım komutu uygular.
  ///
  /// Editor ve sahip içerik/şema değiştirir; `grant`, `revoke` ve `delete_table`.
  /// yalnız sahiptir, viewer 403 `tables.forbidden` (TABLES-K02). Başarı ve tekrar.
  /// 200 döner; tekrar `replayed` alanıyla ayırt edilir. `Idempotency-Key` zorunludur (TABLES-K04; ADR-0027): eksik ya da.
  /// kırpılmış hâli 22–200 bayt dışında anahtar 422 `tables.input_invalid`.
  /// (alan `idempotency_key`, kod `tables.request_key_required` /.
  /// `tables.request_key_invalid`). Anahtar aktör kapsamlıdır. Aynı anahtar +.
  /// aynı istek (kapsam, tablo ve komutun sabit alan sıralı JSON.
  /// serileştirmesi; semantik kanonikleştirme yapılmaz, hücre değeri.
  /// boşluklar dışında gönderildiği gibi karşılaştırılır: `"a"` ile `"\u0061"` ya da `1e3`.
  /// ile `1000` farklı istektir) komutu ikinci kez.
  /// uygulamaz: ilk makbuz `replayed: true` ile döner, audit yazılmaz;.
  /// tekrar yine güncel erişim ister. Aynı anahtar farklı istekle 409.
  /// `tables.idempotency_key_reused`. Yazma yasağı (güncelleme penceresi).
  /// 409 `provisioning.write_not_allowed`.
  ///
  /// [idempotencyKey] - İstemcinin ürettiği opak işlem anahtarı (en az 128 bit; ör. base64url 22 karakter; ADR-0027). Uzunluk baştaki/sondaki boşluk kırpıldıktan sonra bayt olarak 22–200'dür. Eksik ya da sınır dışı anahtar 422; program aktarımında `program.transfer_input_invalid`, oluşturma uçlarında modülün `<mod>.input_invalid` zarfı (alan `idempotency_key`, kod `<mod>.request_key_required` / `<mod>.request_key_invalid`). Aynı anahtar + aynı istek ilk sonucu döndürür (oluşturmada 200 + kaynağın bugünkü temsili, güncel görme yetkisiyle); farklı istek 409 `<mod>.idempotency_key_reused`. Anahtar aktör + uç tablosu kapsamındadır; sunucu kaynağı yaşadıkça tutar (kalıcı silinen kaynakta anahtar da gider).
  @POST('/v1/tables/{tableID}/operations')
  Future<TableResult> applyTableOperation({
    @Path('tableID') required String tableId,
    @Header('Idempotency-Key') required String idempotencyKey,
    @Body() required TableCommand body,
    @Extras()
    Map<String, dynamic>? extras =
        TablesClient.applyTableOperationOpenapiExtras,
  });

  /// Koordinatörlük alanındaki tablo projelerini listeler.
  ///
  /// Program + departman kapsamının silinmemiş projeleri `(created_at, id)`.
  /// sırasıyla keyset sayfalı (TABLES-K13). Kapsam ekibi ve şirket.
  /// yöneticisi listeler; proje tabloya erişim vermez.
  @GET('/v1/table-projects')
  Future<TableProjectList> listTableProjects({
    @Query('limit') int? limit = 100,
    @Query('cursor') String? cursor,
    @Extras()
    Map<String, dynamic>? extras = TablesClient.listTableProjectsOpenapiExtras,
  });

  /// Koordinatörlük alanında tablo projesi oluşturur, yeniden adlandırır ya da siler.
  ///
  /// Yalnız seçili departmanın güncel koordinatörü ya da şirket yöneticisi.
  /// (TABLES-K13); diğer ekip üyeleri 403 `tables.forbidden`. Başarı ve.
  /// tekrar 200 döner; tekrar `replayed` ile ayrılır. `Idempotency-Key`.
  /// zorunludur (TABLES-K04 kuralları aynıdır). Silme yumuşaktır: tablolar.
  /// ve içerikleri korunur, proje bağları yanıtlarda görünmez.
  ///
  /// [idempotencyKey] - İstemcinin ürettiği opak işlem anahtarı (en az 128 bit; ör. base64url 22 karakter; ADR-0027). Uzunluk baştaki/sondaki boşluk kırpıldıktan sonra bayt olarak 22–200'dür. Eksik ya da sınır dışı anahtar 422; program aktarımında `program.transfer_input_invalid`, oluşturma uçlarında modülün `<mod>.input_invalid` zarfı (alan `idempotency_key`, kod `<mod>.request_key_required` / `<mod>.request_key_invalid`). Aynı anahtar + aynı istek ilk sonucu döndürür (oluşturmada 200 + kaynağın bugünkü temsili, güncel görme yetkisiyle); farklı istek 409 `<mod>.idempotency_key_reused`. Anahtar aktör + uç tablosu kapsamındadır; sunucu kaynağı yaşadıkça tutar (kalıcı silinen kaynakta anahtar da gider).
  @POST('/v1/table-projects')
  Future<TableProjectResult> applyTableProjectCommand({
    @Header('Idempotency-Key') required String idempotencyKey,
    @Body() required TableProjectCommand body,
    @Extras()
    Map<String, dynamic>? extras =
        TablesClient.applyTableProjectCommandOpenapiExtras,
  });

  /// Tabloyu koordinatörlük alanına kopyalar (yapı ya da tam kopya).
  ///
  /// Hedef rotanın kapsamıdır; aktör hedefte ekip satırı ya da şirket.
  /// yöneticiliği taşımalıdır (TABLES-K16). Kural ve içerik.
  /// `TableCopyRequest` açıklamasındadır. Tam kopyada ek içerikleri.
  /// transaction dışında kopyalanır; kaynak bu sırada değişirse 409.
  /// `tables.source_changed` (yeni nesneler temizlenir). Yeni tablo 201,.
  /// aynı `Idempotency-Key` + aynı istek 200 `replayed: true`; tekrar.
  /// yalnız kopyanın güncel sahipliğini ister (kaynak erişimi sonradan.
  /// kalkmış olabilir), kopya silinmişse 404.
  ///
  /// [idempotencyKey] - İstemcinin ürettiği opak işlem anahtarı (en az 128 bit; ör. base64url 22 karakter; ADR-0027). Uzunluk baştaki/sondaki boşluk kırpıldıktan sonra bayt olarak 22–200'dür. Eksik ya da sınır dışı anahtar 422; program aktarımında `program.transfer_input_invalid`, oluşturma uçlarında modülün `<mod>.input_invalid` zarfı (alan `idempotency_key`, kod `<mod>.request_key_required` / `<mod>.request_key_invalid`). Aynı anahtar + aynı istek ilk sonucu döndürür (oluşturmada 200 + kaynağın bugünkü temsili, güncel görme yetkisiyle); farklı istek 409 `<mod>.idempotency_key_reused`. Anahtar aktör + uç tablosu kapsamındadır; sunucu kaynağı yaşadıkça tutar (kalıcı silinen kaynakta anahtar da gider).
  @POST('/v1/table-copies')
  Future<TableResult> copyTableToCoordinatorship({
    @Header('Idempotency-Key') required String idempotencyKey,
    @Body() required TableCopyRequest body,
    @Extras()
    Map<String, dynamic>? extras =
        TablesClient.copyTableToCoordinatorshipOpenapiExtras,
  });

  /// Tabloyu kişisel alana kopyalar (yapı ya da tam kopya).
  ///
  /// `/v1/table-copies` ile aynı kural; hedef aktörün program içi kişisel.
  /// alanıdır (TABLES-K11, TABLES-K16).
  ///
  /// [idempotencyKey] - İstemcinin ürettiği opak işlem anahtarı (en az 128 bit; ör. base64url 22 karakter; ADR-0027). Uzunluk baştaki/sondaki boşluk kırpıldıktan sonra bayt olarak 22–200'dür. Eksik ya da sınır dışı anahtar 422; program aktarımında `program.transfer_input_invalid`, oluşturma uçlarında modülün `<mod>.input_invalid` zarfı (alan `idempotency_key`, kod `<mod>.request_key_required` / `<mod>.request_key_invalid`). Aynı anahtar + aynı istek ilk sonucu döndürür (oluşturmada 200 + kaynağın bugünkü temsili, güncel görme yetkisiyle); farklı istek 409 `<mod>.idempotency_key_reused`. Anahtar aktör + uç tablosu kapsamındadır; sunucu kaynağı yaşadıkça tutar (kalıcı silinen kaynakta anahtar da gider).
  @POST('/v1/personal/table-copies')
  Future<TableResult> copyTableToPersonal({
    @Header('Idempotency-Key') required String idempotencyKey,
    @Body() required TableCopyRequest body,
    @Extras()
    Map<String, dynamic>? extras =
        TablesClient.copyTableToPersonalOpenapiExtras,
  });

  /// Koordinatörlüğe gelen bekleyen tablo önerilerini listeler.
  ///
  /// Yalnız seçili departmanın güncel koordinatörü ya da şirket yöneticisi.
  /// (TABLES-K18); diğer üyeler 403. Yalnız bekleyen öneriler,.
  /// `(created_at, id)` keyset sırasıyla; kaynak tablosu silinmiş öneri.
  /// listelenmez. Öğeler yalnız sahibin rıza verdiği üst veridir.
  @GET('/v1/table-proposals')
  Future<TableProposalList> listTableProposals({
    @Query('limit') int? limit = 100,
    @Query('cursor') String? cursor,
    @Extras()
    Map<String, dynamic>? extras = TablesClient.listTableProposalsOpenapiExtras,
  });

  /// Bekleyen tablo önerisini onaylar ya da reddeder.
  ///
  /// Yalnız hedef departmanın güncel koordinatörü ya da şirket yöneticisi.
  /// (TABLES-K18). Onaylı taşımada tablo hedefe geçer: sahip öneren kalır,.
  /// açık paylaşımlar temizlenir, rızadaki `team_role` yazılır. Onaylı.
  /// kopyada yeni tablonun sahibi ve referans görünürlük aktörü önerendir.
  /// Rızadan sonra kaynak değişmişse, öneren artık sahip ya da hedef üyesi.
  /// değilse ya da hedef proje kalktıysa 409 `tables.proposal_stale`; ret.
  /// bayat öneride de yapılır. Karara bağlanmış öneri 409.
  /// `tables.proposal_decided`. Başarı ve tekrar 200; tekrar `replayed`.
  /// ile ayrılır ve onaylayanın güncel rolünü ister.
  ///
  /// [idempotencyKey] - İstemcinin ürettiği opak işlem anahtarı (en az 128 bit; ör. base64url 22 karakter; ADR-0027). Uzunluk baştaki/sondaki boşluk kırpıldıktan sonra bayt olarak 22–200'dür. Eksik ya da sınır dışı anahtar 422; program aktarımında `program.transfer_input_invalid`, oluşturma uçlarında modülün `<mod>.input_invalid` zarfı (alan `idempotency_key`, kod `<mod>.request_key_required` / `<mod>.request_key_invalid`). Aynı anahtar + aynı istek ilk sonucu döndürür (oluşturmada 200 + kaynağın bugünkü temsili, güncel görme yetkisiyle); farklı istek 409 `<mod>.idempotency_key_reused`. Anahtar aktör + uç tablosu kapsamındadır; sunucu kaynağı yaşadıkça tutar (kalıcı silinen kaynakta anahtar da gider).
  @POST('/v1/table-proposals/{proposalID}/decision')
  Future<TableProposalDecisionResult> decideTableProposal({
    @Path('proposalID') required String proposalId,
    @Header('Idempotency-Key') required String idempotencyKey,
    @Body() required TableProposalDecisionRequest body,
    @Extras()
    Map<String, dynamic>? extras =
        TablesClient.decideTableProposalOpenapiExtras,
  });

  /// Programdaki kişisel alanda sahip olunan ya da paylaşılmış tabloları listeler.
  ///
  /// Kişisel alan program içidir ve departmansızdır (TABLES-K11): departman.
  /// başlığı okunmaz. Aktörün programda canlı bir ekip satırı ya da şirket.
  /// yöneticiliği gerekir; yoksa 403 `tables.forbidden`. Sahibi olunan ya.
  /// da açıkça paylaşılmış silinmemiş kişisel tablolar `(created_at, id)`.
  /// sırasıyla keyset sayfalıdır; koordinatörlük alanı tabloları burada.
  /// görünmez.
  ///
  /// [template] - `true`: yalnız şablon bayraklı tablolar; ACL süzgeci aynıdır (TABLES-K16).
  @GET('/v1/personal/tables')
  Future<TableList> listPersonalTables({
    @Query('limit') int? limit = 100,
    @Query('cursor') String? cursor,
    @Query('template') Template? template,
    @Extras()
    Map<String, dynamic>? extras = TablesClient.listPersonalTablesOpenapiExtras,
  });

  /// Programdaki kişisel alanda yeni tablo oluşturur; oluşturan sahiptir.
  ///
  /// Programda canlı ekip satırı olan hesap ya da şirket yöneticisi kişisel.
  /// tablo açar (TABLES-K11). Tablo departmansızdır ve başkasına yalnız.
  /// açık paylaşımla görünür. Yeni tablo 201, aynı anahtarın tekrarı 200 +.
  /// `replayed` (TABLES-K04 kuralları `/v1/tables` ile aynıdır).
  ///
  /// [idempotencyKey] - İstemcinin ürettiği opak işlem anahtarı (en az 128 bit; ör. base64url 22 karakter; ADR-0027). Uzunluk baştaki/sondaki boşluk kırpıldıktan sonra bayt olarak 22–200'dür. Eksik ya da sınır dışı anahtar 422; program aktarımında `program.transfer_input_invalid`, oluşturma uçlarında modülün `<mod>.input_invalid` zarfı (alan `idempotency_key`, kod `<mod>.request_key_required` / `<mod>.request_key_invalid`). Aynı anahtar + aynı istek ilk sonucu döndürür (oluşturmada 200 + kaynağın bugünkü temsili, güncel görme yetkisiyle); farklı istek 409 `<mod>.idempotency_key_reused`. Anahtar aktör + uç tablosu kapsamındadır; sunucu kaynağı yaşadıkça tutar (kalıcı silinen kaynakta anahtar da gider).
  @POST('/v1/personal/tables')
  Future<TableResult> createPersonalTable({
    @Header('Idempotency-Key') required String idempotencyKey,
    @Body() required TableCreateRequest body,
    @Extras()
    Map<String, dynamic>? extras =
        TablesClient.createPersonalTableOpenapiExtras,
  });

  /// Kişisel alandaki tablonun şemasını ve bir satır sayfasını okur.
  ///
  /// `/v1/tables/{tableID}` ile aynı okuma sözleşmesi (TABLES-K02, K07,.
  /// K08), kişisel alan için (TABLES-K11). Sahibi ve açık paylaşımlılar.
  /// okur; koordinatörlük alanı tablo kimliği, başkasının paylaşılmamış.
  /// kişisel tablosu ya da silinmiş tablo 404 `tables.not_found`.
  ///
  /// [cursor] - Süzgeç/sıralama yoksa satır konumu (eski sayısal imleç, bayatlık denetimi yok). Süzgeç ya da sıralama varken yalnız `next_cursor` ile dönen `v2.` önekli opak imleç; tablo/şema/sıra, sorgu ya da görünür izdüşüm değişmişse 409 `tables.cursor_stale` (TABLES-K21).
  ///
  /// [filter] - En çok 3 süzgeç, `sütun:op:değer` (değer ≤ 1000 bayt; `:` içerebilir). İşleçler: metin/telefon/e-posta/tarih eq, ne, lt, gt, contains, empty; sayı eq, ne, lt, gt, empty (tam ondalık); onay kutusu eq (true/false), empty; referans ve ek eq (görünür kimlik), contains (görünen ad), empty (görünür izdüşüm boş). `empty` değersizdir. Metin karşılaştırması bayt sıralı (C), contains büyük/küçük harf duyarlı. Gizli ya da olmayan referans eşitliği aynı 422 `tables.reference_unavailable`; seçilen referans sütunlarında 20000'den çok farklı saklı kimlik 422 `tables.query_too_broad`.
  ///
  /// [sort] - En çok 2 anahtar, `sütun:asc|desc`. Boş değerler her yönde sonda; eşitlikte satır konumu, sonra satır kimliği. Referans ve ek sütunları görünen adlara (çoklu hücrede saklanan sırayla ad dizisi) göre sıralanır.
  @GET('/v1/personal/tables/{tableID}')
  Future<TableSnapshot> getPersonalTable({
    @Path('tableID') required String tableId,
    @Query('limit') int? limit = 100,
    @Query('cursor') String? cursor,
    @Query('filter') List<String>? filter,
    @Query('sort') List<String>? sort,
    @Extras()
    Map<String, dynamic>? extras = TablesClient.getPersonalTableOpenapiExtras,
  });

  /// Kişisel tablonun bir hücresine dosya yükler (multipart `file` parçası; akışla).
  ///
  /// `/v1/tables/{tableID}/attachments` ile aynı sözleşme (TABLES-K15), kişisel.
  /// alan için (TABLES-K11); kapsam yalnız programdır. Başka alanın tablo.
  /// kimliği 404 `tables.not_found`'tır.
  ///
  /// [idempotencyKey] - İstemcinin ürettiği opak işlem anahtarı (en az 128 bit; ör. base64url 22 karakter; ADR-0027). Uzunluk baştaki/sondaki boşluk kırpıldıktan sonra bayt olarak 22–200'dür. Eksik ya da sınır dışı anahtar 422; program aktarımında `program.transfer_input_invalid`, oluşturma uçlarında modülün `<mod>.input_invalid` zarfı (alan `idempotency_key`, kod `<mod>.request_key_required` / `<mod>.request_key_invalid`). Aynı anahtar + aynı istek ilk sonucu döndürür (oluşturmada 200 + kaynağın bugünkü temsili, güncel görme yetkisiyle); farklı istek 409 `<mod>.idempotency_key_reused`. Anahtar aktör + uç tablosu kapsamındadır; sunucu kaynağı yaşadıkça tutar (kalıcı silinen kaynakta anahtar da gider).
  @MultiPart()
  @POST('/v1/personal/tables/{tableID}/attachments')
  Future<TableResult> attachPersonalTableFile({
    @Path('tableID') required String tableId,
    @Query('row_id') required String rowId,
    @Query('column_id') required String columnId,
    @Query('cell_version') required int cellVersion,
    @Header('Idempotency-Key') required String idempotencyKey,
    @Part(name: 'file') required File file,
    @Extras()
    Map<String, dynamic>? extras =
        TablesClient.attachPersonalTableFileOpenapiExtras,
  });

  /// Kişisel tablonun AKTİF ekini indirir (güncel kaynak tablo ACL'siyle).
  ///
  /// `/v1/tables/{tableID}/attachments/{attachmentID}` ile aynı sözleşme.
  /// (TABLES-K15), kişisel alan için.
  @GET('/v1/personal/tables/{tableID}/attachments/{attachmentID}')
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse<List<int>>> downloadPersonalTableAttachment({
    @Path('tableID') required String tableId,
    @Path('attachmentID') required String attachmentId,
    @Extras()
    Map<String, dynamic>? extras =
        TablesClient.downloadPersonalTableAttachmentOpenapiExtras,
  });

  /// Kişisel alandaki tablonun olay metadata'sını `after` imlecinden sonra okur.
  ///
  /// `/v1/tables/{tableID}/changes` ile aynı replay sözleşmesi (ADR-0039,.
  /// TABLES-K23), kişisel alan için (TABLES-K11).
  ///
  /// [after] - Son tüketilen olay sırası; koordinatörlük ucuyla aynı biçim.
  @GET('/v1/personal/tables/{tableID}/changes')
  Future<TableChanges> getPersonalTableChanges({
    @Path('tableID') required String tableId,
    @Query('after') required String after,
    @Query('limit') int? limit = 100,
    @Extras()
    Map<String, dynamic>? extras =
        TablesClient.getPersonalTableChangesOpenapiExtras,
  });

  /// Kişisel alandaki tablonun yorumlarını değişmez oluşturma sırasıyla sayfalar.
  ///
  /// `/v1/tables/{tableID}/comments` ile aynı sözleşme (ADR-0040, TABLES-K26),.
  /// kişisel alan için (TABLES-K11).
  ///
  /// [rowId] - Yalnız bu satırın yorumları; verilirse boş olamaz.
  ///
  /// [cursor] - Son tüketilen yorumun `seq` değeri (önceki sayfanın `next_cursor`'ı).
  @GET('/v1/personal/tables/{tableID}/comments')
  Future<TableCommentPage> getPersonalTableComments({
    @Path('tableID') required String tableId,
    @Query('limit') int? limit = 50,
    @Query('row_id') String? rowId,
    @Query('cursor') String? cursor,
    @Extras()
    Map<String, dynamic>? extras =
        TablesClient.getPersonalTableCommentsOpenapiExtras,
  });

  /// Kişisel alandaki tablonun canlı akışı (SSE; içeriksiz sıra uyarıları).
  ///
  /// `/v1/tables/{tableID}/stream` ile aynı akış sözleşmesi (ADR-0039 "Akış"),.
  /// kişisel alan için (TABLES-K11). Kapsam ön kapısı programdaki canlı ekip.
  /// satırıdır; özel tabloda şirket yöneticisi bypass'ı yoktur.
  @GET('/v1/personal/tables/{tableID}/stream')
  Future<String> streamPersonalTableChanges({
    @Path('tableID') required String tableId,
    @Extras()
    Map<String, dynamic>? extras =
        TablesClient.streamPersonalTableChangesOpenapiExtras,
  });

  /// Kişisel alandaki tabloda çağıran oturumun seçili hücresini yeniler.
  ///
  /// `/v1/tables/{tableID}/presence` ile aynı sözleşme (ADR-0040, TABLES-K25),.
  /// kişisel alan için (TABLES-K11). Kapsam ön kapısı programdaki canlı ekip.
  /// satırıdır; özel tabloda şirket yöneticisi bypass'ı yoktur.
  @POST('/v1/personal/tables/{tableID}/presence')
  Future<void> setPersonalTablePresence({
    @Path('tableID') required String tableId,
    @Body() required TablePresenceRequest body,
    @Extras()
    Map<String, dynamic>? extras =
        TablesClient.setPersonalTablePresenceOpenapiExtras,
  });

  /// Kişisel alanda çağıran oturumun presence kaydını siler (idempotent).
  ///
  /// `/v1/tables/{tableID}/presence` DELETE ile aynı sözleşme (ADR-0040).
  @DELETE('/v1/personal/tables/{tableID}/presence')
  Future<void> leavePersonalTablePresence({
    @Path('tableID') required String tableId,
    @Extras()
    Map<String, dynamic>? extras =
        TablesClient.leavePersonalTablePresenceOpenapiExtras,
  });

  /// Kişisel alandaki tabloya tek komut uygular.
  ///
  /// `/v1/tables/{tableID}/operations` ile aynı komut sözleşmesi (TABLES-K02…K08),.
  /// kişisel alan için (TABLES-K11). `set_team_role` kişisel alanda 422.
  /// `tables.input_invalid`; `set_project` yalnız sahibin kişisel projesini.
  /// hedefler. Paylaşım hedefi programda canlı ekip satırı olan hesap ya da.
  /// şirket yöneticisi olmalıdır; değilse 422 `tables.reference_unavailable`.
  ///
  /// [idempotencyKey] - İstemcinin ürettiği opak işlem anahtarı (en az 128 bit; ör. base64url 22 karakter; ADR-0027). Uzunluk baştaki/sondaki boşluk kırpıldıktan sonra bayt olarak 22–200'dür. Eksik ya da sınır dışı anahtar 422; program aktarımında `program.transfer_input_invalid`, oluşturma uçlarında modülün `<mod>.input_invalid` zarfı (alan `idempotency_key`, kod `<mod>.request_key_required` / `<mod>.request_key_invalid`). Aynı anahtar + aynı istek ilk sonucu döndürür (oluşturmada 200 + kaynağın bugünkü temsili, güncel görme yetkisiyle); farklı istek 409 `<mod>.idempotency_key_reused`. Anahtar aktör + uç tablosu kapsamındadır; sunucu kaynağı yaşadıkça tutar (kalıcı silinen kaynakta anahtar da gider).
  @POST('/v1/personal/tables/{tableID}/operations')
  Future<TableResult> applyPersonalTableOperation({
    @Path('tableID') required String tableId,
    @Header('Idempotency-Key') required String idempotencyKey,
    @Body() required TableCommand body,
    @Extras()
    Map<String, dynamic>? extras =
        TablesClient.applyPersonalTableOperationOpenapiExtras,
  });

  /// Aktörün kişisel alandaki tablo projelerini listeler.
  ///
  /// Yalnız aktörün kendi silinmemiş kişisel projeleri (TABLES-K13),.
  /// `(created_at, id)` sırasıyla keyset sayfalı.
  @GET('/v1/personal/table-projects')
  Future<TableProjectList> listPersonalTableProjects({
    @Query('limit') int? limit = 100,
    @Query('cursor') String? cursor,
    @Extras()
    Map<String, dynamic>? extras =
        TablesClient.listPersonalTableProjectsOpenapiExtras,
  });

  /// Kişisel alanda tablo projesi oluşturur, yeniden adlandırır ya da siler.
  ///
  /// Kişisel proje yalnız sahibine görünür ve sahibi tarafından yönetilir.
  /// (TABLES-K13); başkasının proje kimliği 404 `tables.not_found`. Başarı.
  /// ve tekrar 200 döner; tekrar `replayed` ile ayrılır.
  ///
  /// [idempotencyKey] - İstemcinin ürettiği opak işlem anahtarı (en az 128 bit; ör. base64url 22 karakter; ADR-0027). Uzunluk baştaki/sondaki boşluk kırpıldıktan sonra bayt olarak 22–200'dür. Eksik ya da sınır dışı anahtar 422; program aktarımında `program.transfer_input_invalid`, oluşturma uçlarında modülün `<mod>.input_invalid` zarfı (alan `idempotency_key`, kod `<mod>.request_key_required` / `<mod>.request_key_invalid`). Aynı anahtar + aynı istek ilk sonucu döndürür (oluşturmada 200 + kaynağın bugünkü temsili, güncel görme yetkisiyle); farklı istek 409 `<mod>.idempotency_key_reused`. Anahtar aktör + uç tablosu kapsamındadır; sunucu kaynağı yaşadıkça tutar (kalıcı silinen kaynakta anahtar da gider).
  @POST('/v1/personal/table-projects')
  Future<TableProjectResult> applyPersonalTableProjectCommand({
    @Header('Idempotency-Key') required String idempotencyKey,
    @Body() required TableProjectCommand body,
    @Extras()
    Map<String, dynamic>? extras =
        TablesClient.applyPersonalTableProjectCommandOpenapiExtras,
  });
}
