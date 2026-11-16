part of 'nz_glyph.dart';

/// Kaynak: docs/design/mobile.html ve ürün sahibinin design/icons/ altındaki SVG'leri.
/// SVG şekilleri eşdeğer yollara çevrilir; özgün dolgu ve maske bilgisi korunur.
abstract final class NzDesignGlyphs {
  static const arrowDown = NzGlyph('M12 5v14M6 13l6 6 6-6');

  static const arrowUp = NzGlyph('M12 19V5M6 11l6-6 6 6');

  static const assistant = NzGlyph(
    'M12 2.5v3M8 6h8a3 3 0 0 1 3 3v7a3 3 0 0 1-3 3H8a3 3 0 0 1-3-3V9a3 3 0 0 1 3-3zM9.5 11.5v1M14.5 11.5v1M9.5 16h5M2.5 11v4M21.5 11v4',
  );

  static const back = NzGlyph('M15 5l-7 7 7 7');

  static const barChart = NzGlyph('M4 20V10M10 20V4M16 20v-7M22 20H2');

  static const bell = NzGlyph(
    'M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9M10.3 21a1.94 1.94 0 0 0 3.4 0',
  );

  static const calendar = NzGlyph(
    'M4 6h16v14H4zM4 10h16M8 3v4M16 3v4M8 14h2M12 14h2M16 14h2M8 17h2M12 17h2',
  );

  static const camera = NzGlyph(
    'M4 7h3l2-3h6l2 3h3v13H4zM12 17a4 4 0 1 0 0-8 4 4 0 0 0 0 8z',
  );

  static const chevronDown = NzGlyph('M6 9l6 6 6-6');

  static const chevronLeft = NzGlyph('M15 6l-6 6 6 6');

  static const chevronRight = NzGlyph('M9 6l6 6-6 6');

  static const chevronUp = NzGlyph('M6 15l6-6 6 6');

  static const close = NzGlyph('M6 6l12 12M18 6 6 18');

  static const coordinatorships = NzGlyph(
    'M5 21V4a1 1 0 0 1 1-1h8a1 1 0 0 1 1 1v17M15 9h4a1 1 0 0 1 1 1v11M3 21h18M9 7h2M9 11h2M9 15h2',
  );

  static const copy = NzGlyph('M8 8h12v12H8zM4 16V4h12');

  static const document = NzGlyph('M14 3H6v18h12V7zM14 3v4h4M9 13h6M9 17h4');

  static const event = NzGlyph('M4 6h16v14H4zM4 10h16M8 3v4M16 3v4');

  static const eventAvailable = NzGlyph(
    'M4 6h16v14H4zM4 10h16M8 3v4M16 3v4M9 15l2 2 4-4',
  );

  static const eventRepeat = NzGlyph(
    'M4 6h16v14H4zM4 10h16M8 3v4M16 3v4M12 13v4M10 15l2 2 2-2',
  );

  static const favorite = NzGlyph(
    'M12 20s-7-4.4-7-10a4 4 0 0 1 7-2.6A4 4 0 0 1 19 10c0 5.6-7 10-7 10z',
  );

  static const file = NzGlyph('M6 3h9l4 4v14H6zM14 3v5h5');

  static const filter = NzGlyph('M4 6h16M7 12h10M10 18h4');

  static const flag = NzGlyph('M5 21V4M5 4h11l-2 4 2 4H5');

  static const folder = NzGlyph(
    'M3 7a2 2 0 0 1 2-2h4l2 2h8a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z',
  );

  static const folderMove = NzGlyph(
    'M3 7a2 2 0 0 1 2-2h4l2 2h8a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2zM10 13h6M13 10l3 3-3 3',
  );

  static const help = NzGlyph(
    'M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18zM9.5 9.5a2.5 2.5 0 1 1 3.5 2.3c-.6.3-1 .9-1 1.6v.6M12 17h.01',
  );

  static const hidden = NzGlyph(
    'M3 3l18 18M10.6 10.6a2 2 0 0 0 2.8 2.8M9.9 5.2A9.8 9.8 0 0 1 12 5c6 0 9.5 7 9.5 7a17 17 0 0 1-3.1 3.9M6.6 6.6C3.9 8.3 2.5 12 2.5 12s3.5 7 9.5 7a9.5 9.5 0 0 0 5.4-1.6',
  );

  static const home = NzGlyph(
    'M3 10.5 12 3l9 7.5V20a1 1 0 0 1-1 1h-5v-6h-6v6H4a1 1 0 0 1-1-1z',
  );

  static const idea = NzGlyph(
    'M9 18h6M10 21h4M12 3a6 6 0 0 0-3.5 10.9c.6.5 1 1.2 1 2V16h5v-.1c0-.8.4-1.5 1-2A6 6 0 0 0 12 3z',
  );

  static const image = NzGlyph('M4 6h16v13H4zM4 15l4-4 5 5 3-3 4 4M15 9.5h.01');

  static const jumpToEnd = NzGlyph('M4 12h12M12 8l4 4-4 4M20 5v14');

  static const lineChart = NzGlyph('M4 19V5M4 19h16M8 15l4-4 3 3 5-6');

  static const list = NzGlyph('M4 6h16M4 12h16M4 18h16');

  static const listBulleted = NzGlyph(
    'M9 6h11M9 12h11M9 18h11M4.5 6h.01M4.5 12h.01M4.5 18h.01',
  );

  static const logout = NzGlyph('M15 4h4v16h-4M10 8l-4 4 4 4M6 12h10');

  static const menu = NzGlyph('M4 7h16M4 12h16M10 17h10');

  static const merge = NzGlyph(
    'M8 3v6a4 4 0 0 0 4 4h0a4 4 0 0 1 4 4v4M16 3v6a4 4 0 0 1-4 4',
  );

  static const messages = NzGlyph('M4 5h16v11H8l-4 4z');

  static const more = NzGlyph('M12 5h.01M12 12h.01M12 19h.01');

  static const mute = NzGlyph('M11 5L6 9H3v6h3l5 4zM22 9l-6 6M16 9l6 6');

  static const person = NzGlyph(
    'M12 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM4 21a8 8 0 0 1 16 0',
  );

  static const pin = NzGlyph('M9 4h6l-1 6 3 3H7l3-3zM12 13v7');

  static const remove = NzGlyph('M5 12h14');

  static const science = NzGlyph(
    'M9 3h6M10 3v6l-5 9a2 2 0 0 0 1.7 3h10.6a2 2 0 0 0 1.7-3l-5-9V3M7.5 14h9',
  );

  static const search = NzGlyph(
    'M11 18a7 7 0 1 0 0-14 7 7 0 0 0 0 14zM20 20l-4-4',
  );

  static const sheets = NzGlyph('M4 5h16v14H4zM4 10h16M4 15h16M10 5v14');

  static const sortAlpha = NzGlyph(
    'M4 6h10M4 12h7M4 18h4M17 6v12M17 18l-3-3M17 18l3-3',
  );

  static const star = NzGlyph(
    'M12 3.5l2.6 5.3 5.9.9-4.3 4.1 1 5.8-5.2-2.7-5.2 2.7 1-5.8-4.3-4.1 5.9-.9z',
  );

  static const swapVertical = NzGlyph(
    'M7 4v16M7 20l-3-3M7 20l3-3M17 20V4M17 4l-3 3M17 4l3 3',
  );

  static const tag = NzGlyph('M3 12V4h8l10 10-8 8zM7.5 7.5h.01');

  static const tasks = NzGlyph(
    'M4 6l1.5 1.5L8 5M4 12l1.5 1.5L8 11M4 18l1.5 1.5L8 17M11 6h9M11 12h9M11 18h9',
  );

  static const thumbUp = NzGlyph(
    'M7 11v9H4v-9zM7 11l4-7c1.5 0 2.5 1 2.5 2.5V10h5a2 2 0 0 1 2 2.3l-1.2 6A2 2 0 0 1 17.3 20H7',
  );

  static const timeline = NzGlyph('M4 5h9M7 10h11M5 15h7M10 20h10');

  static const unfold = NzGlyph('M8 9l4-4 4 4M8 15l4 4 4-4');

  static const uploadFile = NzGlyph(
    'M14 3H6v18h12V7zM14 3v4h4M12 18v-7M9 14l3-3 3 3',
  );

  static const reply = NzGlyph('M9 14L4 9l5-5M4 9h11a5 5 0 0 1 5 5v6');
  static const upload = NzGlyph('M12 19V5M6 11l6-6 6 6M5 21h14');
  static const checkCircle = NzGlyph(
    'M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18zM9 12l2 2 4-4',
  );
  static const mail = NzGlyph('M3 6h18v12H3zM3 7l9 6 9-6');
  static const checkAll = NzGlyph('M2 12.5l4 4L14 8M10 16.5l1 1L22 7');
  static const attach = NzGlyph(
    'M20 11.5l-7.8 7.8a5 5 0 0 1-7.1-7.1l8.2-8.2a3.3 3.3 0 0 1 4.7 4.7l-8.2 8.2a1.7 1.7 0 0 1-2.4-2.4l7.5-7.5',
  );
  static const tune = NzGlyph(
    'M6 3v12M18 9v12M6 15a3 3 0 1 0 0 6 3 3 0 0 0 0-6zM18 3a3 3 0 1 0 0 6 3 3 0 0 0 0-6zM6 15c0-4 12-2 12-6',
  );

  /// design/icons/sayi.svg
  static const number = NzGlyph(
    'M9.5 3.5 7.5 20.5M16.5 3.5l-2 17M4.5 9h16M3.5 15h16',
  );

  /// design/icons/kisa-metin.svg
  static const shortText = NzGlyph(
    'M4 7V5.5h11V7M9.5 5.5v13M7.5 18.5h4M14 12.5h6M14 16.5h4',
  );

  /// design/icons/klasor-devre-disi.svg
  static const folderOff = NzGlyph(
    'M3 3l18 18M20.5 16.5V9a2 2 0 0 0-2-2h-6.2l-2-2.5H7.5M3.8 5.6A2 2 0 0 0 3.5 6.5v11a2 2 0 0 0 2 2h12.5',
  );

  /// design/icons/koyu-tema.svg
  static const darkMode = NzGlyph(
    'M20 14.5A8 8 0 0 1 9.5 4a8 8 0 1 0 10.5 10.5z',
  );

  /// design/icons/masaustu.svg
  static const desktop = NzGlyph(
    'M5 4H19a2 2 0 0 1 2 2V14.5a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2zM9 20.5h6M12 16.5v4',
  );

  /// design/icons/onay-kutusu-bos.svg
  static const checkboxEmpty = NzGlyph(
    'M8.5 4H15.5a4.5 4.5 0 0 1 4.5 4.5V15.5a4.5 4.5 0 0 1-4.5 4.5H8.5a4.5 4.5 0 0 1-4.5-4.5V8.5a4.5 4.5 0 0 1 4.5-4.5z',
  );

  /// design/icons/sutunlar.svg
  static const columns = NzGlyph(
    'M5.5 4H18.5a2 2 0 0 1 2 2V18a2 2 0 0 1-2 2H5.5a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2zM9.2 4v16M14.8 4v16',
  );

  /// design/icons/telefon.svg
  static const phone = NzGlyph(
    'M5 3.5h3.2l1.6 4.2-2.1 1.4a11 11 0 0 0 7.2 7.2l1.4-2.1 4.2 1.6V19a1.8 1.8 0 0 1-1.9 1.8A15.5 15.5 0 0 1 3.2 5.4 1.8 1.8 0 0 1 5 3.5z',
  );

  /// design/icons/uc-nokta-yatay.svg
  static const moreHorizontal = NzGlyph(
    'M5.5 12h.01M12 12h.01M18.5 12h.01',
    strokeWidth: 3,
  );

  /// design/icons/yinele.svg
  static const redo = NzGlyph('M20 12a8 8 0 1 1-2.6-5.9M20 4v5h-5');

  /// design/icons/envanter.svg
  static const inventory = NzGlyph(
    'M12 3 20 7.5v9L12 21l-8-4.5v-9zM4 7.5 12 12l8-4.5M12 12v9M8 5.3l8 4.5',
  );

  /// design/icons/gelen-kutusu.svg
  static const inbox = NzGlyph(
    'M3.5 13.5h5l1.5 2.5h4l1.5-2.5h5M6 5h12l2.5 8.5V18a2 2 0 0 1-2 2h-13a2 2 0 0 1-2-2v-4.5z',
  );

  /// design/icons/hafta-gorunumu.svg
  static const viewWeek = NzGlyph(
    'M5.5 5H18.5a2 2 0 0 1 2 2V18a2 2 0 0 1-2 2H5.5a2 2 0 0 1-2-2V7a2 2 0 0 1 2-2zM3.5 9.5h17M8 3v3.5M16 3v3.5M7.5 13v3.5M10.5 13v3.5M13.5 13v3.5M16.5 13v3.5',
  );

  /// design/icons/hiyerarsi.svg
  static const hierarchy = NzGlyph(
    'M10.5 3H13.5a1.5 1.5 0 0 1 1.5 1.5V6.5a1.5 1.5 0 0 1-1.5 1.5H10.5a1.5 1.5 0 0 1-1.5-1.5V4.5a1.5 1.5 0 0 1 1.5-1.5zM4.5 16H7.5a1.5 1.5 0 0 1 1.5 1.5V19.5a1.5 1.5 0 0 1-1.5 1.5H4.5a1.5 1.5 0 0 1-1.5-1.5V17.5a1.5 1.5 0 0 1 1.5-1.5zM16.5 16H19.5a1.5 1.5 0 0 1 1.5 1.5V19.5a1.5 1.5 0 0 1-1.5 1.5H16.5a1.5 1.5 0 0 1-1.5-1.5V17.5a1.5 1.5 0 0 1 1.5-1.5zM12 8v4M6 16v-2a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v2',
  );

  /// design/icons/onay-kutusu-secili.svg
  static const checkboxChecked = NzGlyph(
    'M8 3.5H16a4.5 4.5 0 0 1 4.5 4.5V16a4.5 4.5 0 0 1-4.5 4.5H8a4.5 4.5 0 0 1-4.5-4.5V8a4.5 4.5 0 0 1 4.5-4.5z',
    filled: true,
    cutout: 'M8 12.3l2.8 2.8L16.2 9.5',
    cutoutWidth: 2,
  );

  /// design/icons/acik-tema.svg
  static const lightMode = NzGlyph(
    'M16 12a4 4 0 1 0-8 0a4 4 0 1 0 8 0zM12 2.5v2M12 19.5v2M2.5 12h2M19.5 12h2M5.3 5.3l1.4 1.4M17.3 17.3l1.4 1.4M5.3 18.7l1.4-1.4M17.3 6.7l1.4-1.4',
  );

  /// design/icons/arama-sonuc-yok.svg
  static const searchOff = NzGlyph(
    'M17 10.5a6.5 6.5 0 1 0-13 0a6.5 6.5 0 1 0 13 0zM15.5 15.5 20.5 20.5M8.5 8.5l4 4M12.5 8.5l-4 4',
  );

  /// design/icons/baglanti.svg
  static const link = NzGlyph(
    'M10 14a4.5 4.5 0 0 0 6.4 0l3-3a4.5 4.5 0 0 0-6.4-6.4l-1.2 1.2M14 10a4.5 4.5 0 0 0-6.4 0l-3 3a4.5 4.5 0 0 0 6.4 6.4l1.2-1.2',
  );

  /// design/icons/kilit.svg
  static const lock = NzGlyph(
    'M7 10.5H17a2.5 2.5 0 0 1 2.5 2.5V18a2.5 2.5 0 0 1-2.5 2.5H7a2.5 2.5 0 0 1-2.5-2.5V13a2.5 2.5 0 0 1 2.5-2.5zM8 10.5V7.5a4 4 0 0 1 8 0v3M12 14.5v2',
  );

  /// design/icons/anahtar.svg
  static const key = NzGlyph(
    'M12 15a4 4 0 1 0-8 0a4 4 0 1 0 8 0zM10.8 12.2 19.5 3.5M16.5 6.5l2.5 2.5M14 9l2 2',
  );

  /// design/icons/bilgi.svg
  static const info = NzGlyph(
    'M21 12a9 9 0 1 0-18 0a9 9 0 1 0 18 0zM12 11v5.5M12 7.75h.01',
  );

  /// design/icons/cevrimdisi.svg
  static const offline = NzGlyph(
    'M3 3l18 18M8.5 8.6A13 13 0 0 0 2.5 11.5M21.5 11.5a13 13 0 0 0-9.8-3.3M5.5 14.8a8.5 8.5 0 0 1 4.8-2.2M18.5 14.8a8.5 8.5 0 0 0-2-1.5M9 18a4.5 4.5 0 0 1 6 0M12 21h.01',
  );

  /// design/icons/paylas.svg
  static const share = NzGlyph(
    'M12 3v12M7.5 7.5 12 3l4.5 4.5M8 11H6.5a2 2 0 0 0-2 2v6a2 2 0 0 0 2 2h11a2 2 0 0 0 2-2v-6a2 2 0 0 0-2-2H16',
  );

  /// design/icons/secim-dairesi-bos.svg
  static const radioEmpty = NzGlyph(
    'M20.5 12a8.5 8.5 0 1 0-17 0a8.5 8.5 0 1 0 17 0z',
  );
}
