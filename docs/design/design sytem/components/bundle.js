/* @ds-bundle: {"format":4,"namespace":"RoketPortalMobil","components":[]} */
/* RoketPortal Mobil — davranış yardımcıları. Görünüm bundle.css'tedir; bu dosya yalnızca durum özniteliklerini değiştirir. */
(function () {
  function attr(el, name, on) { el.setAttribute(name, on ? 'true' : 'false'); }
  var M = {
    /* Hap sekmeler: .m-tabs içindeki düğmeye basınca --i ve aria-selected güncellenir */
    tabs: function (root) {
      var b = root.querySelectorAll('button');
      b.forEach(function (x, i) {
        x.addEventListener('click', function () {
          root.style.setProperty('--i', i);
          b.forEach(function (y) { attr(y, y.hasAttribute('aria-pressed') ? 'aria-pressed' : 'aria-selected', y === x); });
        });
      });
    },
    /* Anahtar: role="switch" */
    toggle: function (el) {
      el.addEventListener('click', function () { attr(el, 'aria-checked', el.getAttribute('aria-checked') !== 'true'); });
    },
    /* Satır kartı: .m-row__btn aria-expanded ↔ sonraki .m-acc data-open */
    accordion: function (btn) {
      btn.addEventListener('click', function () {
        var open = btn.getAttribute('aria-expanded') !== 'true';
        attr(btn, 'aria-expanded', open);
        var item = btn.closest('.m-rows__item'); var acc = item && item.querySelector('.m-acc');
        if (acc) acc.dataset.open = open ? 'true' : 'false';
      });
    },
    /* Segment: tek seçim */
    segment: function (root) {
      var b = root.querySelectorAll('button');
      b.forEach(function (x) { x.addEventListener('click', function () { b.forEach(function (y) { attr(y, 'aria-pressed', y === x); }); }); });
    },
    /* Saat çarkı: data-start satırına kaydır, ortadaki satırı data-on yap */
    wheel: function (col) {
      var rows = col.querySelectorAll('span'); var h = 36;
      col.scrollTop = (+col.dataset.start || 0) * h;
      var mark = function () { var k = Math.round(col.scrollTop / h); rows.forEach(function (r, i) { if (i === k) r.setAttribute('data-on', 'true'); else r.removeAttribute('data-on'); }); };
      col.addEventListener('scroll', mark); mark();
    },
    /* Arama açılışı: düğme [data-m-reveal="id"] hedef .m-reveal'ı açar/kapatır */
    reveal: function (btn) {
      btn.addEventListener('click', function () {
        var t = document.getElementById(btn.getAttribute('data-m-reveal')); if (!t) return;
        var open = t.dataset.open !== 'true'; t.dataset.open = open ? 'true' : 'false'; attr(btn, 'aria-pressed', open);
      });
    },
    init: function (doc) {
      doc = doc || document;
      doc.querySelectorAll('.m-tabs').forEach(M.tabs);
      doc.querySelectorAll('.m-switch').forEach(M.toggle);
      doc.querySelectorAll('.m-row__btn').forEach(M.accordion);
      doc.querySelectorAll('.m-seg').forEach(M.segment);
      doc.querySelectorAll('.m-wheel__col').forEach(M.wheel);
      doc.querySelectorAll('[data-m-reveal]').forEach(M.reveal);
    }
  };
  window.RoketPortalMobil = M;
})();
