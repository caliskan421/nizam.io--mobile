#!/usr/bin/env python3
"""Yerel geliştirme backend'ine (up.sh) prototip örnek verisini YALNIZ API ile basar.

Kaynak: mobil örnek kataloğu (seed_task_data.txt: lib'den kaldırılan sample_task_data.dart — 16 kişi,
11 koordinatörlük, 76 görev) ve takvim/mesaj örneklerinin prototip içerikleri. Görevler Dart
dosyasından okunur; örnek katalog değişirse tohum da değişir.

Tarihler: örnek kataloğun "bugün"ü 2026-10-21'dir. Bütün tarihler sunucunun bugününe kaydırılır
(fark = bugün − 2026-10-21); gecikme günleri ve "bugünkü toplantılar" prototiple aynı kalır.

Hesaplar: `ma` = ilk yönetici (up.sh'in açtığı hesap; adı güncellenir). Diğerleri
<ad.soyad>@nizam.local, hepsi aynı geliştirme parolasıyla (sır değildir; atılabilir veritabanı).

Genişletme (`extend`): ikinci program, çoklu rol tanıkları, büyük arşiv dosyaları, tablolar, silinenler,
grup sohbetleri/anketler; her bölüm `== ...: N` özet satırı basar. Tanık hesaplar README'dedir.

Kullanım: dev-up.sh (up.sh + bu betik). Yalnız boş kurulumda koşar (program varsa durur).
Ortam: NIZAMIO_IT_BACKEND (varsayılan http://127.0.0.1:18140), NIZAMIO_IT_ADMIN_EMAIL,
NIZAMIO_IT_ADMIN_PASSWORD (dev girişinin varsayılanları).
"""
import datetime as dt
import io
import json
import os
import random
import re
import struct
import sys
import time
import urllib.error
import urllib.request
import uuid
import zipfile
import zlib

BASE = os.environ.get('NIZAMIO_IT_BACKEND', 'http://127.0.0.1:18140')
ADMIN_EMAIL = os.environ.get('NIZAMIO_IT_ADMIN_EMAIL', 'admin@nizam.local')
PASSWORD = os.environ.get('NIZAMIO_IT_ADMIN_PASSWORD', 'Pasword.123123')
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
TASKS_DART = os.path.join(ROOT, 'test_integration/backend/seed_task_data.txt')
SAMPLE_TODAY = dt.date(2026, 10, 21)

PROGRAM = {'name': 'Şanlıurfa Teknofest', 'year': 2026, 'short_name': 'URFA', 'color': 'violet',
           'description': 'Teknofest Şanlıurfa 2026 saha kurulumu ve organizasyonu.'}

# Kişi kodu → ad (örnek katalog `_people`); `ma` ilk yöneticidir, `my` de şirket yöneticisi.
ADMINS = {'ma', 'my'}

# Koordinatörlük açıklamaları (prototip `logic_cdetail.js`; yalnız ALT'nin metni prototipte var).
ABOUT = {
    'ALT': 'Havalimanı yerleşkesinin temiz su, atıksu ve arıtma altyapısını kurar; depolama ve '
           'hidrofor sistemlerinin montajından ve devreye alınmasından sorumludur.',
}

TAGS = ['cikti', 'sonuc', 'plan', 'analiz', 'girdi', 'ister']
FILE_NAMES = ['Teslim_tutanagi.pdf', 'Saha_fotografi.png', 'Is_programi.xlsx',
              'Hesap_raporu.pdf', 'Teklif_karsilastirma.xlsx', 'Ihtiyac_listesi.docx']
# Sunucu içeriği bildirilen türle karşılaştırır (records ValidateContent): her uzantıya imzası
# doğru küçük dosya.
MIME = {'pdf': 'application/pdf', 'png': 'image/png',
        'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        'docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'}
NOTES = [
    'Sahadaki ölçümler tamamlandı, rapor dosyalara eklendi.',
    'Tedarikçiyle görüşüldü; malzeme teslimi gelecek hafta.',
    'Montaj sırasında eksik vana tespit edildi, sipariş verildi.',
]

# Alt görevler (F54): görev kodu → (başlık, kişi kodu, bitti mi).
SUBTASKS = {
    'ALT-7': [('Pompa grubunun sahaya indirilmesi', 'ko', True),
              ('Basınç tankı bağlantıları', 'ko', False),
              ('Basınç testi ve teslim tutanağı', 'ko', False)],
    'ALT-10': [('Montaj', 'ko', True), ('Test', 'ko', False), ('Devreye alma', 'ko', False)],
}

# Bekleyen tarih talebi (prototip olay akışı: "Hidrofor sistemi kurulumu · 10.09 → 31.10").
DATE_REQUESTS = [('ALT-7', 'ko', dt.date(2026, 10, 31),
                  'Pompa grubu teslimatı gecikti; montaj 28 Ekim’de başlayabilecek.')]

# Birebir mesajlar (prototip sohbet içerikleri; sunucu konulu birebir kutudur).
MESSAGES = [
    ('ma', 'yc', 'Fuar haftası çalışma saatleri',
     'Fuar haftası çalışma saatleri: 27 Ekim–2 Kasım, 08:00–20:00. Vardiya çizelgesini OPE '
     'kartına ekleyebilir misin?'),
    ('yc', 'ma', 'Vardiya taslağı',
     'Vardiya taslağı arşivde, herkes kendi saatini kontrol etsin.'),
    ('ko', 'ma', 'Hidrofor pompaları',
     'Hidrofor pompaları 28 Ekim’de sahada. Montaj planı ALT-7 kartında.'),
    # Prototipte Bahar Kılıç (bk) yazar; bk koordinatörü olmayan İDA'da üyedir ve sunucuda üye
    # yalnız kendi koordinatörüne yazabilir. Konaklama OPE ile ortak iş: OPE koordinatörü yazar.
    ('yc', 'ma', 'Otel rezervasyonları',
     'Otel rezervasyonlarının hepsi onaylandı. Konaklama listesini güncelledim, eksik varsa '
     'yazın.'),
    ('ma', 'aa', 'Saha teslim hazırlığı',
     'Saha teslim tutanağı için altyapı tarafındaki eksik iş listesini cuma gününe kadar '
     'paylaşabilir misin?'),
    ('rk', 'ma', 'Jeneratör yakıt tankı',
     'İkinci tedarikçiden teklif geldi, karşılaştırma tablosunu hazırlıyorum.'),
    ('my', 'ma', 'Sistem koordinatörlüğü',
     'Basın merkezinin ağ ve yazıcı kurulumu için ekipman listesi hazır.'),
    ('mk', 'ma', 'Gönüllü eğitimi',
     'Gönüllü oryantasyonunun sunumu tamamlandı; acil durum prosedürü bölümünü sen de görür '
     'müsün?'),
    ('ma', 'bc', 'Sponsor alan turu',
     'Sponsor alan turunda tabela ve yönlendirme konusunu da konuşalım.'),
    ('ss', 'ma', 'Fuar alanı',
     'A kapısındaki stant yerleşimi netleşti, plan dosyasını yükledim.'),
]

# Toplantılar (prototip takvim örneği): ay, gün, saat, dakika, başlık, koordinatörlükler, gündem.
# Koordinatörlüğü olmayan genel toplantılar SİS sahipliğinde, bütün koordinatörlerle açılır.
MEETINGS = [
    (10, 19, 10, 0, 'Haftalık koordinasyon', [],
     ['Saha teslim hazırlığı', 'Jeneratör yakıt tankı teklifi', 'Gönüllü ulaşımı']),
    (10, 21, 14, 0, 'Hidrofor teslim kontrolü', ['ALT'],
     ['Basınç testi sonuçları', 'Eksik vana listesi', 'Teslim tutanağı']),
    (10, 21, 16, 30, 'Konaklama ve servis planı', ['İDA', 'OPE'],
     ['Otel blok rezervasyonu', 'Servis güzergâhları']),
    (10, 22, 10, 0, 'Altyapı ilerleme', ['ALT', 'MEK'],
     ['Saha kurulum takvimi', 'Güvenlik ve tahliye planının fuar alanına uyarlanması']),
    (10, 23, 11, 0, 'Sponsor alan turu', ['SAT', 'FUA'],
     ['Sponsor alanlarının teslimi', 'Tabela ve yönlendirme']),
    (10, 26, 10, 0, 'Haftalık koordinasyon', [],
     ['Saha teslimi değerlendirmesi', 'Kurulum haftası planı']),
    (10, 26, 15, 30, 'Saha teslim tutanağı', ['OPE', 'ALT', 'ELE'],
     ['Elektrik ve su devri', 'Eksik iş listesi', 'İmza']),
    (10, 28, 15, 30, 'Gönüllü oryantasyonu', ['OPE', 'İDA'],
     ['Vardiya düzeni', 'Acil durum prosedürü', 'Zimmet ve yaka kartı']),
    (11, 2, 10, 0, 'Haftalık koordinasyon', [], ['Kurulum ilerlemesi', 'Prova günü akışı']),
    (11, 5, 14, 0, 'Basın merkezi kurulumu', ['SAT', 'SİS'],
     ['Ekipman teslimi', 'Ağ ve yazıcı kurulumu']),
    (11, 10, 9, 0, 'Genel prova brifingi', [], ['Açılış akışı', 'Güvenlik', 'Basın girişi']),
    (11, 17, 10, 0, 'Söküm planlama', ['ALT', 'FUA', 'OPE'], ['Söküm sırası', 'Zimmet iadesi']),
]

STATUS = {'done': 'tamamlandi', 'inProgress': 'devam_ediyor', 'review': 'onaya_sunuldu',
          'returned': 'iade_edildi', 'todo': 'baslanmadi'}
PRIORITY = {'low': 'dusuk', 'medium': 'orta', 'high': 'yuksek', 'urgent': 'acil'}


class ApiError(RuntimeError):
    def __init__(self, status, body, what):
        super().__init__(f'{what} → {status} {body}')
        self.status, self.body = status, body
        self.code = body.get('code') if isinstance(body, dict) else None


class Session:
    def __init__(self, email, password):
        self.email, self.password = email, password
        self.login()

    def login(self):
        # Oturum ömrü kısa (up.sh: 15 dk) ve tohum hız sınırıyla uzun sürer: süre dolmadan yenilenir.
        self.token = None
        r = self.call('POST', '/v1/auth/login', {'email': self.email, 'password': self.password})
        self.token, self.account_id, self.expires_at = r['token'], r['account_id'], r['expires_at']

    def call(self, method, path, body=None, program=None, dept=None, raw=None, ctype=None):
        if self.token and time.time() > self.expires_at - 120:
            self.login()
        h = {'X-Requested-With': 'XMLHttpRequest'}
        if method == 'POST':
            # Yazma uçları işlem anahtarı ister (ADR-0027); 429 tekrarında aynı anahtar gider.
            h['Idempotency-Key'] = str(uuid.uuid4())
        if self.token:
            h['Authorization'] = 'Bearer ' + self.token
        if program:
            h['X-Nizamio-Program'] = program
        if dept:
            h['X-Nizamio-Department'] = dept
        data = None
        if body is not None:
            data, h['Content-Type'] = json.dumps(body).encode(), 'application/json'
        if raw is not None:
            data, h['Content-Type'] = raw, ctype
        # Genel IP hız sınırı (varsayılan 200/dk): 429'da Retry-After kadar beklenir.
        for _ in range(10):
            req = urllib.request.Request(BASE + path, data=data, headers=h, method=method)
            try:
                with urllib.request.urlopen(req) as r:
                    text, status = r.read(), r.status
            except urllib.error.HTTPError as e:
                text, status = e.read(), e.code
                if status == 429:
                    wait = int(e.headers.get('Retry-After') or 15)
                    print(f'   (hız sınırı; {wait} sn bekleniyor)', flush=True)
                    time.sleep(wait)
                    continue
            break
        out = json.loads(text) if text[:1] in (b'{', b'[') else text
        if status >= 300:
            raise ApiError(status, out, f'{method} {path}')
        return out


_ASCII = str.maketrans('çğıöşüÇĞİÖŞÜ', 'cgiosuCGIOSU')


def ascii_slug(name):
    return '.'.join(p.lower() for p in name.translate(_ASCII).split())


def parse_catalog():
    src = open(TASKS_DART, encoding='utf-8').read()
    people = {m[0]: m[1] for m in re.findall(r"Person\(id: '(\w+)', name: '([^']+)'", src)}
    coords = []
    for block in re.findall(r'CoordinatorshipRef\((.*?)\)', src, re.S):
        coords.append({
            'code': re.search(r"code: '([^']+)'", block)[1],
            'name': re.search(r"name: '([^']+)'", block)[1],
            'leads': re.findall(r"'(\w+)'", re.search(r'leads: \[(.*?)\]', block, re.S)[1]),
            'members': re.findall(r"'(\w+)'", re.search(r'members: \[(.*?)\]', block, re.S)[1]),
        })

    def date(field, block):
        m = re.search(field + r': DateTime\((\d+), (\d+), (\d+)\)', block)
        return dt.date(int(m[1]), int(m[2]), int(m[3])) if m else None

    def num(field, block):
        m = re.search(field + r': (\d+)', block)
        return int(m[1]) if m else 0

    tasks = []
    body = src[src.index('final _tasks'):]
    for block in re.split(r'\n  TaskItem\(', body)[1:]:
        tasks.append({
            'code': re.search(r"code: '([^']+)'", block)[1],
            'title': re.search(r"title:\s*'((?:[^'\\]|\\.)*)'", block)[1].replace("\\'", "'"),
            'coord': re.search(r"coordinatorship: '([^']+)'", block)[1],
            'status': STATUS[re.search(r'status: TaskStatus\.(\w+)', block)[1]],
            'priority': PRIORITY[re.search(r'priority: TaskPriority\.(\w+)', block)[1]],
            'start': date('start', block), 'due': date('due', block),
            'completed': date('completedAt', block),
            'assignees': re.findall(r"'(\w+)'", re.search(r'assignees: const \[(.*?)\]', block, re.S)[1]),
            'creator': re.search(r"creator: '(\w+)'", block)[1],
            'files': num('files', block), 'notes': num('notes', block),
        })
    return people, coords, tasks


def sample_file(name, size=0):
    """Uzantısına uygun, açılabilir örnek dosya; `size` bayta yakın (arşivde farklı boylar)."""
    rnd = random.Random(f'{name}:{size}')
    ext = name.rsplit('.', 1)[1]
    if ext == 'png':  # gürültülü RGB görüntü: sıkışmaz, boyu en × boy × 3'e yakındır
        side = max(8, int((size / 3) ** 0.5))
        rows = b''.join(b'\0' + rnd.randbytes(side * 3) for _ in range(side))
        chunk = lambda t, b: struct.pack('>I', len(b)) + t + b + struct.pack('>I', zlib.crc32(t + b))  # noqa: E731
        return (b'\x89PNG\r\n\x1a\n' + chunk(b'IHDR', struct.pack('>IIBBBBB', side, side, 8, 2, 0, 0, 0))
                + chunk(b'IDAT', zlib.compress(rows, 1)) + chunk(b'IEND', b''))
    words = ['saha', 'kurulum', 'teslim', 'malzeme', 'ekip', 'program', 'rapor', 'plan', 'kontrol',
             'tutanak', 'tedarik', 'güvenlik', 'enerji', 'su', 'çadır', 'basın', 'ölçüm', 'onay']
    lines = [' '.join(rnd.choice(words) for _ in range(12)) for _ in range(max(1, size // 90))]
    if ext == 'pdf':  # tek sayfalı geçerli PDF; boy, sayfaya bağlanmamış ek akışla tamamlanır
        text = 'BT /F1 14 Tf 72 760 Td (NIZAM.IO ornek belge) Tj ET'.encode()
        pad = '\n'.join(lines).encode()
        objs = [b'<< /Type /Catalog /Pages 2 0 R >>',
                b'<< /Type /Pages /Kids [3 0 R] /Count 1 >>',
                b'<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] /Contents 4 0 R '
                b'/Resources << /Font << /F1 5 0 R >> >> >>',
                b'<< /Length %d >>stream\n' % len(text) + text + b'\nendstream',
                b'<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>',
                b'<< /Length %d >>stream\n' % len(pad) + pad + b'\nendstream']
        out, offs = bytearray(b'%PDF-1.4\n'), []
        for i, o in enumerate(objs, 1):
            offs.append(len(out))
            out += b'%d 0 obj\n' % i + o + b'\nendobj\n'
        xref = len(out)
        out += b'xref\n0 %d\n0000000000 65535 f \n' % (len(objs) + 1)
        out += b''.join(b'%010d 00000 n \n' % o for o in offs)
        out += b'trailer\n<< /Size %d /Root 1 0 R >>\nstartxref\n%d\n%%%%EOF\n' % (len(objs) + 1, xref)
        return bytes(out)
    esc = lambda t: t.replace('&', '&amp;').replace('<', '&lt;')  # noqa: E731
    buf = io.BytesIO()
    with zipfile.ZipFile(buf, 'w', zipfile.ZIP_STORED) as z:  # sıkıştırmasız: boy satır sayısıyla gelir
        rels = ('<?xml version="1.0" encoding="UTF-8"?><Relationships xmlns="http://schemas.openxmlformats.org/'
                'package/2006/relationships"><Relationship Id="r1" Type="http://schemas.openxmlformats.org/'
                'officeDocument/2006/relationships/officeDocument" Target="%s"/></Relationships>')
        if ext == 'docx':
            z.writestr('[Content_Types].xml', '<?xml version="1.0" encoding="UTF-8"?><Types xmlns="http://'
                       'schemas.openxmlformats.org/package/2006/content-types"><Default Extension="rels" '
                       'ContentType="application/vnd.openxmlformats-package.relationships+xml"/><Default '
                       'Extension="xml" ContentType="application/xml"/><Override PartName="/word/document.xml" '
                       'ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.'
                       'main+xml"/></Types>')
            z.writestr('_rels/.rels', rels % 'word/document.xml')
            body = ''.join(f'<w:p><w:r><w:t>{esc(t)}</w:t></w:r></w:p>' for t in lines)
            z.writestr('word/document.xml', '<?xml version="1.0" encoding="UTF-8"?><w:document xmlns:w="http://'
                       'schemas.openxmlformats.org/wordprocessingml/2006/main"><w:body>' + body
                       + '</w:body></w:document>')
        else:
            z.writestr('[Content_Types].xml', '<?xml version="1.0" encoding="UTF-8"?><Types xmlns="http://'
                       'schemas.openxmlformats.org/package/2006/content-types"><Default Extension="rels" '
                       'ContentType="application/vnd.openxmlformats-package.relationships+xml"/><Default '
                       'Extension="xml" ContentType="application/xml"/><Override PartName="/xl/workbook.xml" '
                       'ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>'
                       '<Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.'
                       'openxmlformats-officedocument.spreadsheetml.worksheet+xml"/></Types>')
            z.writestr('_rels/.rels', rels % 'xl/workbook.xml')
            z.writestr('xl/workbook.xml', '<?xml version="1.0" encoding="UTF-8"?><workbook xmlns="http://'
                       'schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.'
                       'openxmlformats.org/officeDocument/2006/relationships"><sheets><sheet name="Sayfa1" '
                       'sheetId="1" r:id="r1"/></sheets></workbook>')
            z.writestr('xl/_rels/workbook.xml.rels', (rels % 'worksheets/sheet1.xml').replace(
                'officeDocument"', 'worksheet"'))
            rows = ''.join(f'<row r="{i}"><c r="A{i}" t="inlineStr"><is><t>{esc(t)}</t></is></c>'
                           f'<c r="B{i}"><v>{rnd.randint(1, 5000)}</v></c></row>'
                           for i, t in enumerate(lines, 1))
            z.writestr('xl/worksheets/sheet1.xml', '<?xml version="1.0" encoding="UTF-8"?><worksheet xmlns='
                       '"http://schemas.openxmlformats.org/spreadsheetml/2006/main"><sheetData>' + rows
                       + '</sheetData></worksheet>')
    return buf.getvalue()


def file_size(key):
    """Dosyaya kararlı, 40–650 KB arası boy (arşivde boy çeşitliliği)."""
    return random.Random(key).randint(40, 650) * 1024


def multipart(filename, size=0):
    b = uuid.uuid4().hex
    head = (f'--{b}\r\nContent-Disposition: form-data; name="file"; filename="{filename}"\r\n'
            f'Content-Type: {MIME[filename.rsplit(".", 1)[1]]}\r\n\r\n').encode()
    return head + sample_file(filename, size) + f'\r\n--{b}--\r\n'.encode(), f'multipart/form-data; boundary={b}'


def main():
    started = time.time()
    people, coords, tasks = parse_catalog()
    admin = Session(ADMIN_EMAIL, PASSWORD)
    if admin.call('GET', '/v1/programs')['programs']:
        sys.exit('HATA: kurulumda program var; tohum yalnız boş kurulumda koşar (önce down.sh + dev-up.sh).')
    today = dt.date.today()
    shift = today - SAMPLE_TODAY
    d = lambda x: (x + shift).isoformat() if x else None  # noqa: E731
    print(f'== tarih kaydırma: {shift.days} gün (örnek bugünü {SAMPLE_TODAY} → {today})')

    # Hesaplar.
    acc, sessions = {'ma': admin.account_id}, {'ma': admin}
    admin.call('PATCH', f'/v1/admin/accounts/{admin.account_id}', {'full_name': people['ma']})
    for code, name in people.items():
        if code == 'ma':
            continue
        email = ascii_slug(name) + '@nizam.local'
        r = admin.call('POST', '/v1/admin/accounts', {
            'email': email, 'full_name': name, 'password': PASSWORD, 'force_password_change': False})
        acc[code] = r['account_id']
        if code in ADMINS:
            admin.call('PATCH', f'/v1/admin/users/{r["account_id"]}', {'company_admin': True})
        sessions[code] = Session(email, PASSWORD)
    print(f'== hesaplar: {len(acc)}')

    # Program, departmanlar, ekip.
    prog = admin.call('POST', '/v1/programs', PROGRAM)['program_id']
    dept, role = {}, {}  # role[(kod, kişi)] = 'koordinator'|'uye'
    for c in coords:
        # Sunucu kodu ASCII ister (organization.invalid_code): İDA → IDA, EĞİ → EGI.
        body = {'name': c['name'], 'kind': 'koordinatorluk', 'code': c['code'].translate(_ASCII)}
        if c['code'] in ABOUT:
            body['description'] = ABOUT[c['code']]
        dept[c['code']] = admin.call('POST', '/v1/departments', body)['department_id']
        admin.call('POST', '/v1/program/departments', {'department_id': dept[c['code']]}, program=prog)

    def join(code, person, r):
        if (code, person) in role:
            return
        admin.call('POST', f'/v1/departments/{dept[code]}/memberships',
                   {'account_id': acc[person], 'role': r}, program=prog)
        role[(code, person)] = r

    for c in coords:
        for p in c['leads']:
            join(c['code'], p, 'koordinator')
        for p in c['members']:
            join(c['code'], p, 'uye')
    for t in tasks:  # görevin kişileri departmanda değilse üye olarak eklenir
        for p in t['assignees']:
            join(t['coord'], p, 'uye')
    print(f'== program: {PROGRAM["name"]} · {len(dept)} koordinatörlük · {len(role)} üyelik')

    def coordinator_of(code):
        return next((p for (c, p), r in role.items() if c == code and r == 'koordinator'), None)

    # Görevler.
    ids, problems, p1_files = {}, [], {}
    for t in tasks:
        code, D = t['coord'], dept[t['coord']]
        creator = t['creator'] if role.get((code, t['creator'])) == 'koordinator' else 'ma'
        s = sessions[creator]
        worker = t['assignees'][0] if t['assignees'] else creator
        # Şirket yöneticisi dosya yükleyemez (RECORDS-K01; records.not_authorized): dosyayı
        # departmanın yönetici olmayan koordinatörü yükler; yoksa görevin dosyası basılmaz.
        uploader = worker if worker not in ADMINS else next(
            (p for (c, p), r in role.items() if c == code and r == 'koordinator' and p not in ADMINS),
            None)
        files = t['files'] if uploader else 0
        body = {'title': t['title'], 'priority': t['priority'],
                'start_on': d(t['start']), 'end_on': d(t['due']),
                # Kanıt bayrağı (ADR-0024) yalnız prototipte dosyası olan görevde açık.
                'completion_evidence_required': files > 0}
        if t['assignees']:
            body['assignee_account_id'] = acc[t['assignees'][0]]
        try:
            w = s.call('POST', '/v1/work-items', body, program=prog, dept=D)
        except ApiError as e:  # koordinatör başlangıcı en çok 40 gün geriye koyar (WORK-K06); yönetici muaf
            if e.status != 422 or creator == 'ma':
                raise
            s = admin
            w = s.call('POST', '/v1/work-items', body, program=prog, dept=D)
        wid = ids[t['code']] = w['work_item_id']
        worker = sessions[worker]
        lead = coordinator_of(code)
        try:
            if len(t['assignees']) > 1:  # görevlendirmeyi yönetici değil koordinatör ekler
                (sessions[lead] if lead else s).call(
                    'POST', f'/v1/work-items/{wid}/assignments',
                    {'account_ids': [acc[p] for p in t['assignees'][1:]]}, program=prog, dept=D)
            if t['status'] != 'baslanmadi':
                move(worker, wid, prog, D, 'devam_ediyor')
            for i in range(files):
                fname = FILE_NAMES[i % len(FILE_NAMES)]
                raw, ctype = multipart(fname, file_size(f'{t["code"]}:{i}'))
                f = sessions[uploader].call('POST', f'/v1/work-items/{wid}/files?tag={TAGS[i % len(TAGS)]}',
                                            raw=raw, ctype=ctype, program=prog, dept=D)
                p1_files.setdefault((1, code), []).append(f['file_id'])
            for i in range(t['notes']):
                worker.call('POST', f'/v1/work-items/{wid}/notes',
                            {'content': NOTES[i % len(NOTES)]}, program=prog, dept=D)
            finish(t['status'], wid, prog, D, worker, sessions.get(lead) if lead else None)
            if t['status'] == 'tamamlandi' and t['completed']:
                admin.call('PATCH', f'/v1/work-items/{wid}/completion-date',
                           {'completed_on': d(t['completed'])}, program=prog, dept=D)
        except (ApiError, RuntimeError) as e:
            problems.append(f'{t["code"]} → {t["status"]}: {e}')
    print(f'== görevler: {len(ids)}')

    # Alt görevler ve tarih talepleri.
    for code, subs in SUBTASKS.items():
        D = dept[code.split('-')[0]]
        lead = sessions[coordinator_of(code.split('-')[0])]
        for title, person, done in subs:
            st = lead.call('POST', f'/v1/work-items/{ids[code]}/subtasks',
                           {'title': title, 'assignee_account_id': acc[person]}, program=prog, dept=D)
            if done:
                lead.call('PATCH', f'/v1/work-items/{ids[code]}/subtasks/{st["subtask_id"]}',
                          {'done': True}, program=prog, dept=D)
    task_by_code = {t['code']: t for t in tasks}
    for code, person, new_end, reason in DATE_REQUESTS:
        t = task_by_code[code]
        sessions[person].call('POST', '/v1/date-change-requests', {
            'work_item_id': ids[code], 'new_start_on': d(t['start']), 'new_end_on': d(new_end),
            'reason': reason}, program=prog, dept=dept[t['coord']])
    print(f'== alt görevler: {sum(map(len, SUBTASKS.values()))} · tarih talebi: {len(DATE_REQUESTS)}')

    # Mesajlar: birebir sohbet açılır (varsa aynısı döner), konu ilk satırda.
    for frm, to, subject, content in MESSAGES:
        try:
            chat = sessions[frm].call('POST', '/v1/chats/direct', {'account_id': acc[to]}, program=prog)
            sessions[frm].call('POST', f"/v1/chats/{chat['chat_id']}/messages", {
                'client_message_id': str(uuid.uuid4()), 'body': f'{subject}\n{content}'}, program=prog)
        except ApiError as e:
            problems.append(f'mesaj {frm} → {to} ({subject}): {e}')
    print(f'== mesajlar: {len(MESSAGES)}')

    # Toplantılar (geçmiş güne toplantı açılamaz; kaydırma sonrası geçmişte kalan atlanır).
    made = skipped = 0
    for m, day, hh, mm, title, codes, agenda in MEETINGS:
        when = dt.date(2026, m, day) + shift
        if when < today:
            skipped += 1
            continue
        owners = codes or ['SİS']
        participants = sorted({p for c in (codes or [x['code'] for x in coords])
                               for (cc, p), r in role.items() if cc == c and r == 'koordinator'}
                              - {'ma'})
        try:
            admin.call('POST', '/v1/meetings', {
                'title': title, 'meeting_date': f'{when.isoformat()}T{hh:02d}:{mm:02d}:00',
                'department_ids': [dept[c] for c in owners],
                'participant_ids': [acc[p] for p in participants],
                'members_included': bool(codes), 'agenda_items': agenda}, program=prog)
            made += 1
        except ApiError as e:
            problems.append(f'toplantı {title}: {e}')
    print(f'== toplantılar: {made} (geçmişte kalan {skipped} atlandı)')

    ctx = {'admin': admin, 'sessions': sessions, 'acc': acc, 'prog': prog, 'dept': dept, 'role': role,
           'ids': ids, 'files': p1_files, 'problems': problems, 'today': today}
    extend(ctx)

    if problems:
        print(f'\n!! {len(problems)} adım uygulanamadı:')
        for p in problems:
            print('   ' + p)
    print(f'\nSüre: {time.time() - started:.0f} sn')
    print(f'\nGiriş: {ADMIN_EMAIL} / diğer hesaplar <ad.soyad>@nizam.local, parola aynı.')


def move(s, wid, prog, D, to, **extra):
    s.call('POST', f'/v1/work-items/{wid}/transitions', {'to': to, **extra}, program=prog, dept=D)


def finish(target, wid, prog, D, worker, lead):
    """Başlamış görevi hedef durumuna sunucunun geçiş kurallarıyla götürür."""
    if target in ('baslanmadi', 'devam_ediyor'):
        return
    if target == 'tamamlandi':
        try:
            move(worker, wid, prog, D, 'tamamlandi')  # koordinatörün kendi görevi
            return
        except ApiError as e:
            if e.status not in (403, 409, 422):
                raise
    move(worker, wid, prog, D, 'onaya_sunuldu')
    if target == 'onaya_sunuldu':
        return
    if lead is None:
        raise RuntimeError('departmanda koordinatör yok; görev onaya sunulmuş durumda kaldı')
    if target == 'iade_edildi':
        move(lead, wid, prog, D, 'iade_edildi', reason='Teslim tutanağı eksik; imzalı halini ekleyin.')
    else:
        move(lead, wid, prog, D, 'tamamlandi')


# ---------------------------------------------------------------------------------------------
# Genişletme: ikinci program, çoklu rol tanıkları, silinenler, tablolar, grup sohbetleri.
# Rol tanıkları (README): admin@ = yönetici + SİS koordinatörü + OPE üyesi (1. program);
# kadir.ozbek@ = 1. programda ALT koordinatörü, 2. programda ALT üyesi; gokce.nur.usta@ = 1.'de
# EĞİ üyesi, 2.'de LOJ koordinatörü + ALT üyesi; abdullah.ates@ = saf koordinatör; bahar.kilic@ = saf üye.
# Bu ikisi 2. programa ve 2. programın görevlerine KONULMAZ.
# ---------------------------------------------------------------------------------------------

PROGRAM2 = {'name': 'İstanbul Teknofest 2027', 'year': 2027, 'short_name': 'İST', 'color': 'teal',
            'description': 'Teknofest İstanbul 2027 hazırlıkları: saha, lojistik, güvenlik ve basın.'}

# Yeni koordinatörlükler (katalog geneli; ASCII kod). `GEC` ve `ESK` tohumda silinir.
NEW_DEPTS = {
    'LOJ': ('Lojistik ve tedarik', 'Malzeme, araç ve depo planlaması; tedarikçi sözleşmeleri.'),
    'GUV': ('Güvenlik ve sağlık', 'Saha güvenliği, ilk yardım ve tahliye planları.'),
    'BAS': ('Basın ve medya', 'Akreditasyon, basın bültenleri ve sosyal medya.'),
    'GEC': ('Geçici çalıştay ekibi', 'Tek seferlik çalıştay; departmanla birlikte silinir.'),
    'ESK': ('Eski kurulum ekibi', 'Önceki kurulumdan kalan iş; departmanla birlikte silinir.'),
}

# 2. programın ekibi: kod → (koordinatör, üyeler). ALT ve OPE 1. programdaki koordinatörlüklerdir.
TEAM2 = {
    'ALT': ('av', ['ko', 'gn']),
    'OPE': ('yc', ['mk']),
    'LOJ': ('gn', ['mey', 'rk']),
    'GUV': ('so', ['oh', 'mey']),
    'BAS': ('bc', ['eo', 'ss']),
    'GEC': ('eo', ['ss']),
}

# 2. program görevleri: (koordinatörlük, başlık, durum, öncelik, başlangıç, bitiş [bugüne gün],
#  atananlar, kanıt zorunlu, dosya, not, tamamlanma [gün|None]). Bitişi geçmiş açık görev gecikmiştir.
TASKS2 = [
    ('ALT', 'İstanbul saha su hattı keşfi', 'tamamlandi', 'yuksek', -30, -10, ['ko'], True, 2, 1, -12),
    ('ALT', 'Yangın hidrantlarının yerleşimi', 'onaya_sunuldu', 'acil', -20, 5, ['ko'], True, 2, 0, None),
    ('ALT', 'Atıksu bağlantı projesi', 'iade_edildi', 'orta', -15, 3, ['gn'], True, 1, 1, None),
    ('ALT', 'Hidrofor odası ölçümleri', 'devam_ediyor', 'yuksek', -25, -4, ['ko'], False, 0, 2, None),
    ('ALT', 'Sondaj noktalarının işaretlenmesi', 'baslanmadi', 'dusuk', 2, 14, ['gn'], False, 0, 0, None),
    ('ALT', 'Altyapı keşif raporu', 'tamamlandi', 'orta', -18, -6, ['av'], False, 1, 0, -7),
    ('OPE', 'Ziyaretçi giriş akışı', 'devam_ediyor', 'orta', -10, 10, ['mk'], False, 0, 2, None),
    ('OPE', 'Vardiya çizelgesi 2027', 'onaya_sunuldu', 'yuksek', -12, 2, ['mk'], True, 1, 0, None),
    ('OPE', 'Acil durum tatbikatı planı', 'baslanmadi', 'acil', -8, -1, ['mk'], False, 0, 0, None),
    ('OPE', 'Gönüllü yaka kartları', 'tamamlandi', 'orta', -20, -5, ['mk'], True, 3, 0, -3),
    ('LOJ', 'Çadır ve platform kiralama', 'devam_ediyor', 'yuksek', -14, 6, ['mey', 'rk'], True, 2, 1, None),
    ('LOJ', 'Jeneratör sevkiyatı', 'iade_edildi', 'acil', -9, 4, ['rk'], True, 1, 0, None),
    ('LOJ', 'Depo alanı yerleşimi', 'onaya_sunuldu', 'orta', -6, 8, ['mey'], False, 0, 1, None),
    ('LOJ', 'Forklift operatör ataması', 'devam_ediyor', 'orta', -30, -7, ['rk'], False, 0, 0, None),
    ('LOJ', 'Tedarikçi sözleşmeleri', 'tamamlandi', 'yuksek', -35, -15, ['mey'], True, 4, 2, -16),
    ('LOJ', 'Malzeme sayımı', 'baslanmadi', 'dusuk', 5, 20, ['mey', 'rk'], False, 0, 0, None),
    ('GUV', 'Güvenlik kulübesi kurulumu', 'devam_ediyor', 'orta', -5, 12, ['oh'], False, 0, 0, None),
    ('GUV', 'İlk yardım istasyonları', 'onaya_sunuldu', 'yuksek', -10, 1, ['mey'], True, 2, 0, None),
    ('GUV', 'Tahliye planı onayı', 'iade_edildi', 'acil', -12, 2, ['oh'], True, 1, 1, None),
    ('GUV', 'Kamera kayıt sistemi', 'baslanmadi', 'orta', 3, 25, [], False, 0, 0, None),
    ('BAS', 'Basın bülteni taslağı', 'tamamlandi', 'orta', -15, -2, ['eo'], True, 2, 0, -2),
    ('BAS', 'Akreditasyon kartları', 'devam_ediyor', 'yuksek', -7, 7, ['ss'], True, 1, 0, None),
    ('BAS', 'Sosyal medya takvimi', 'onaya_sunuldu', 'dusuk', -4, 9, ['eo'], False, 0, 1, None),
    ('BAS', 'Fotoğraf arşivi', 'devam_ediyor', 'orta', -20, -3, ['ss'], False, 3, 0, None),
    ('GEC', 'Çalıştay salon düzeni', 'devam_ediyor', 'orta', -3, 10, ['ss'], False, 1, 0, None),
    ('GEC', 'Çalıştay katılımcı listesi', 'baslanmadi', 'dusuk', 1, 12, ['ss'], False, 0, 0, None),
    ('GEC', 'Çalıştay afişi', 'tamamlandi', 'orta', -10, -2, ['eo'], False, 0, 0, -3),
]
# 1. programda silinecek koordinatörlüğün görevleri (koordinatör oh, üye so).
TASKS_ESK = [
    ('ESK', 'Eski kurulum envanteri', 'devam_ediyor', 'orta', -6, 6, ['so'], False, 1, 0, None),
    ('ESK', 'Eski depo boşaltma', 'baslanmadi', 'dusuk', 2, 9, ['so'], False, 0, 0, None),
]
# Tek tek silinen görevler: (program, koordinatörlük, başlık, atanan).
DELETED_TASKS = [(1, 'ALT', 'Mükerrer: hidrofor teklif karşılaştırması', 'ko'),
                 (2, 'LOJ', 'Eski tabela siparişi (iptal)', 'rk'),
                 (2, 'GUV', 'Mükerrer kayıt: kamera keşfi', 'oh')]

SUBTASKS2 = {
    'Yangın hidrantlarının yerleşimi': [('Hidrant konum çizimi', 'ko', True), ('İtfaiye onayı', 'ko', False)],
    'Çadır ve platform kiralama': [('Çadır teklifleri', 'mey', True), ('Platform ölçüleri', 'rk', False),
                                   ('Kiralama sözleşmesi', 'mey', False)],
}
# Tarih talebini yalnız görevin koordinatörü açar (WORK-K38).
DATE_REQUESTS2 = [('Ziyaretçi giriş akışı', 'yc', 17, 'Turnike tedarikçisi teslimi bir hafta erteledi.'),
                  ('Güvenlik kulübesi kurulumu', 'so', 20, 'Zemin betonu kurumadan kulübe yerleştirilemiyor.'),
                  ('Forklift operatör ataması', 'gn', 5, 'Sertifikalı operatör ancak gelecek hafta katılabiliyor.')]

MEETINGS2 = [  # (gün, saat, dakika, başlık, sahip koordinatörlükler [boş = genel], gündem)
    (1, 10, 0, 'İstanbul hazırlık toplantısı', [], ['Program takvimi', 'Koordinatörlük sorumlulukları']),
    (3, 14, 0, 'Lojistik ve güvenlik', ['LOJ', 'GUV'], ['Depo güvenliği', 'Araç giriş izinleri']),
    (6, 11, 0, 'Basın planı', ['BAS'], ['Akreditasyon süreci', 'Basın bülteni takvimi']),
    (9, 10, 0, 'Saha turu', ['ALT', 'LOJ'], ['Su hattı güzergâhı', 'Çadır alanları']),
]
DELETED_MEETINGS = [(2, 4, 15, 0, 'İptal: tedarikçi sunumu', ['LOJ'], ['Teklif sunumları']),
                    (1, 5, 16, 0, 'İptal: eski kurulum brifingi', ['ALT'], ['Envanter devri'])]

# Tablolar: (program, koordinatörlük, sahip, ad, ekip rolü, [(hesap, rol)] paylaşımlar).
TABLES = [(1, 'ALT', 'aa', 'Malzeme takip listesi', 'viewer', [('ko', 'editor'), ('av', 'viewer')]),
          (1, 'OPE', 'yc', 'Vardiya çizelgesi', 'editor', []),
          (2, 'LOJ', 'gn', 'Araç listesi', 'none', [('rk', 'viewer')]),
          (2, 'LOJ', 'gn', 'Tedarik planı', 'viewer', [('mey', 'editor'), ('rk', 'viewer')]),
          (2, 'BAS', 'bc', 'Basın akreditasyon listesi', 'viewer', [('eo', 'editor')])]


def make_tasks(ctx, P, prog, spec, extra_roles):
    """Görev tanımlarını sunucu geçişleriyle basar; başlık → kimlik döner."""
    S, acc, dept, problems = ctx['sessions'], ctx['acc'], ctx['dept'], ctx['problems']
    off = lambda n: (ctx['today'] + dt.timedelta(days=n)).isoformat()  # noqa: E731
    out = {}
    for code, title, status, prio, start, end, people, ev, files, notes, done in spec:
        lead, D = extra_roles[code][0], dept[code]
        body = {'title': title, 'priority': prio, 'start_on': off(start), 'end_on': off(end),
                'completion_evidence_required': ev}
        if people:
            body['assignee_account_id'] = acc[people[0]]
        try:
            wid = S[lead].call('POST', '/v1/work-items', body, program=prog, dept=D)['work_item_id']
            out[title] = wid
            ctx.setdefault('tasks', {}).setdefault((P, code), []).append(wid)
            if len(people) > 1:
                S[lead].call('POST', f'/v1/work-items/{wid}/assignments',
                             {'account_ids': [acc[p] for p in people[1:]]}, program=prog, dept=D)
            worker = S[people[0]] if people else S[lead]
            if status != 'baslanmadi':
                move(worker, wid, prog, D, 'devam_ediyor')
            for i in range(files):
                upload(ctx, P, worker, prog, code, wid, f'{P}:{title}:{i}')
            for i in range(notes):
                worker.call('POST', f'/v1/work-items/{wid}/notes', {'content': NOTES[i % len(NOTES)]},
                            program=prog, dept=D)
            finish(status, wid, prog, D, worker, S[lead])
            if status == 'tamamlandi' and done is not None:
                ctx['admin'].call('PATCH', f'/v1/work-items/{wid}/completion-date',
                                  {'completed_on': off(done)}, program=prog, dept=D)
        except (ApiError, RuntimeError) as e:
            problems.append(f'P{P} görev {title} → {status}: {e}')
    return out


def upload(ctx, P, s, prog, code, wid, key, subtask=None):
    """Göreve arşiv dosyası yükler; etiketler ve türler sırayla dönerek hepsine dağılır."""
    n = ctx.setdefault('upload_n', 0)
    ctx['upload_n'] = n + 1
    fname = FILE_NAMES[n % len(FILE_NAMES)].replace('.', f'_{n + 1}.')
    size = file_size(key)
    raw, ctype = multipart(fname, size)
    q = f'?tag={TAGS[n % len(TAGS)]}' + (f'&subtask_id={subtask}' if subtask else '')
    f = s.call('POST', f'/v1/work-items/{wid}/files{q}', raw=raw, ctype=ctype, program=prog,
               dept=ctx['dept'][code])
    ctx['files'].setdefault((P, code), []).append(f['file_id'])
    ctx['bytes'] = ctx.get('bytes', 0) + f['size_bytes']
    return f['file_id']


def extend(ctx):
    admin, S, acc, dept, problems = ctx['admin'], ctx['sessions'], ctx['acc'], ctx['dept'], ctx['problems']
    prog1, today = ctx['prog'], ctx['today']
    off = lambda n: (today + dt.timedelta(days=n)).isoformat()  # noqa: E731

    # İkinci program, yeni koordinatörlükler, ekip.
    prog2 = admin.call('POST', '/v1/programs', PROGRAM2)['program_id']
    ctx['prog2'] = prog2
    for code, (name, about) in NEW_DEPTS.items():
        dept[code] = admin.call('POST', '/v1/departments', {
            'name': name, 'kind': 'koordinatorluk', 'code': code, 'description': about})['department_id']
    links = 0
    for code, (lead, members) in TEAM2.items():
        admin.call('POST', '/v1/program/departments', {'department_id': dept[code]}, program=prog2)
        for p, r in [(lead, 'koordinator')] + [(m, 'uye') for m in members]:
            admin.call('POST', f'/v1/departments/{dept[code]}/memberships',
                       {'account_id': acc[p], 'role': r}, program=prog2)
            links += 1
    admin.call('POST', '/v1/program/departments', {'department_id': dept['ESK']}, program=prog1)
    for p, r in [('oh', 'koordinator'), ('so', 'uye')]:
        admin.call('POST', f'/v1/departments/{dept["ESK"]}/memberships',
                   {'account_id': acc[p], 'role': r}, program=prog1)
    print(f'== 2. program: {PROGRAM2["name"]} · {len(TEAM2)} koordinatörlük · {links} üyelik')

    # Rol tanıkları: hesabın kendi gözünden bütün programlardaki rolleri.
    for code in ('ma', 'ko', 'gn', 'aa', 'bk'):
        rows = S[code].call('GET', '/v1/me/departments')['departments']
        roles = sorted({f"{r['program_name']}:{r['display_name']}:{r['role']}" for r in rows})
        print(f'   {S[code].email}: {"; ".join(roles)}')
    print('== rol tanıkları: 5')

    # 2. program görevleri, alt görevler (dosyalı), tarih talepleri.
    t2 = make_tasks(ctx, 2, prog2, TASKS2, TEAM2)
    print(f'== 2. program görevleri: {len(t2)}')
    subs = 0
    for title, items in SUBTASKS2.items():
        code = next(t[0] for t in TASKS2 if t[1] == title)
        lead, D = S[TEAM2[code][0]], dept[code]
        for i, (stitle, person, done) in enumerate(items):
            try:
                st = lead.call('POST', f'/v1/work-items/{t2[title]}/subtasks',
                               {'title': stitle, 'assignee_account_id': acc[person]}, program=prog2, dept=D)
                if i == 0:
                    upload(ctx, 2, S[person], prog2, code, t2[title], f'sub:{stitle}', st['subtask_id'])
                if done:
                    lead.call('PATCH', f'/v1/work-items/{t2[title]}/subtasks/{st["subtask_id"]}',
                              {'done': True}, program=prog2, dept=D)
                subs += 1
            except (ApiError, KeyError) as e:
                problems.append(f'alt görev {stitle}: {e}')
    reqs = 0
    for title, person, new_end, reason in DATE_REQUESTS2:
        t = next(t for t in TASKS2 if t[1] == title)
        try:
            S[person].call('POST', '/v1/date-change-requests', {
                'work_item_id': t2[title], 'new_start_on': off(t[4]), 'new_end_on': off(new_end),
                'reason': reason}, program=prog2, dept=dept[t[0]])
            reqs += 1
        except (ApiError, KeyError) as e:
            problems.append(f'tarih talebi {title}: {e}')
    print(f'== 2. program alt görevleri: {subs} · tarih talepleri: {reqs}')
    print(f'== arşiv: {ctx["upload_n"]} yeni dosya · {ctx["bytes"] // 1024} KB · '
          f'etiketler {len(TAGS)} · türler {len(MIME)}')

    # Toplantılar (2. program).
    made = 0
    for day, hh, mm, title, codes, agenda in MEETINGS2:
        if meeting(ctx, prog2, day, hh, mm, title, codes, agenda):
            made += 1
    print(f'== 2. program toplantıları: {made}')

    # Tablolar (her alan türü, ekip ve kişi paylaşımı, proje).
    print(f'== tablolar: {tables(ctx)}')

    # Grup sohbetleri ve anketler.
    print(f'== grup sohbetleri: {groups(ctx)}')

    # Silinenler: görev, toplantı, koordinatörlük (görevleriyle), kullanıcı.
    esk = make_tasks(ctx, 1, prog1, TASKS_ESK, {'ESK': ('oh', ['so'])})
    progs = {1: prog1, 2: prog2}
    del_tasks = 0
    for P, code, title, person in DELETED_TASKS:
        try:
            lead = TEAM2[code][0] if P == 2 else 'aa'
            wid = S[lead].call('POST', '/v1/work-items', {
                'title': title, 'start_on': off(-3), 'end_on': off(7), 'assignee_account_id': acc[person],
                'completion_evidence_required': False}, program=progs[P], dept=dept[code])['work_item_id']
            admin.call('DELETE', f'/v1/work-items/{wid}', program=progs[P], dept=dept[code])
            del_tasks += 1
        except ApiError as e:
            problems.append(f'silinen görev {title}: {e}')
    del_meet = 0
    for P, day, hh, mm, title, codes, agenda in DELETED_MEETINGS:
        mid = meeting(ctx, progs[P], day, hh, mm, title, codes, agenda)
        if mid:
            try:
                admin.call('DELETE', f'/v1/meetings/{mid}', program=progs[P])
                del_meet += 1
            except ApiError as e:
                problems.append(f'silinen toplantı {title}: {e}')
    with_dept = 0
    for code in ('GEC', 'ESK'):
        try:
            with_dept += admin.call('DELETE', f'/v1/departments/{dept[code]}')['work_items_deleted']
        except ApiError as e:
            problems.append(f'silinen koordinatörlük {code}: {e}')
    del_acc = 0
    try:
        r = admin.call('POST', '/v1/admin/accounts', {
            'email': 'deniz.arslan@nizam.local', 'full_name': 'Deniz Arslan', 'password': PASSWORD,
            'force_password_change': False})
        admin.call('POST', f'/v1/departments/{dept["LOJ"]}/memberships',
                   {'account_id': r['account_id'], 'role': 'uye'}, program=prog2)
        admin.call('DELETE', f'/v1/admin/accounts/{r["account_id"]}')
        del_acc = 1
    except ApiError as e:
        problems.append(f'silinen kullanıcı: {e}')
    print(f'== silinenler: {del_tasks} görev · {del_meet} toplantı · 2 koordinatörlük '
          f'({with_dept} görevle; ESK {len(esk)}) · {del_acc} kullanıcı')

    # Bildirimler: atama, onaya sunma, iade olaylarından üretilenler.
    counts = {}
    for code in ('ma', 'ko', 'gn', 'mey', 'aa', 'bk', 'av', 'bc'):
        counts[S[code].email] = S[code].call('GET', '/v1/notifications/unread-count')['count']
    print(f'== bildirimler (okunmamış): {sum(counts.values())} · '
          + ', '.join(f'{e.split("@")[0]} {n}' for e, n in counts.items()))


def meeting(ctx, prog, day, hh, mm, title, codes, agenda):
    """Toplantı açar; sahip koordinatörlüklerin (genelde programın bütün) koordinatörleri katılır."""
    S, acc, dept = ctx['sessions'], ctx['acc'], ctx['dept']
    when = ctx['today'] + dt.timedelta(days=day)
    if prog == ctx['prog']:
        owners = codes or ['SİS']
        leads = {p for (c, p), r in ctx['role'].items() if r == 'koordinator' and (not codes or c in codes)}
    else:
        owners = codes or ['OPE']
        leads = {TEAM2[c][0] for c in (codes or [c for c in TEAM2 if c != 'GEC'])}
    try:
        return ctx['admin'].call('POST', '/v1/meetings', {
            'title': title, 'meeting_date': f'{when.isoformat()}T{hh:02d}:{mm:02d}:00',
            'department_ids': [dept[c] for c in owners],
            'participant_ids': [acc[p] for p in sorted(leads - {'ma'})],
            'members_included': bool(codes), 'agenda_items': agenda}, program=prog)['meeting']['meeting_id']
    except ApiError as e:
        ctx['problems'].append(f'toplantı {title}: {e}')
        return None


def tables(ctx):
    """Her sütun türünü taşıyan tablolar; ekip rolü ve kişi paylaşımları. Basılan tablo sayısı döner."""
    S, acc, dept, problems = ctx['sessions'], ctx['acc'], ctx['dept'], ctx['problems']
    progs = {1: ctx['prog'], 2: ctx['prog2']}
    made, by_dept = 0, {}
    for P, code, owner, name, team_role, grants in TABLES:
        s, prog, D = S[owner], progs[P], dept[code]
        op = lambda body: s.call('POST', f'/v1/tables/{tid}/operations', body, program=prog, dept=D)  # noqa: E731
        try:
            r = s.call('POST', '/v1/tables', {'name': name}, program=prog, dept=D)
            tid, schema = r['table_id'], r['schema_version']
            team = sorted({p for (c, p) in ctx['role'] if c == code} if P == 1
                          else {TEAM2[code][0], *TEAM2[code][1]})
            p1_tasks = [w for c, w in ctx['ids'].items() if c.split('-')[0] == code]
            refs = {'person_reference': acc[team[0]], 'department_reference': D,
                    'task_reference': (p1_tasks if P == 1 else ctx['tasks'].get((P, code), [None]))[0],
                    'file_reference': (ctx['files'].get((P, code)) or [None])[0],
                    'table_reference': by_dept.get((P, code))}
            cols = [('Kalem', 'text', False), ('Miktar', 'number', False), ('Telefon', 'phone', False),
                    ('E-posta', 'email', False), ('Tarih', 'date', False), ('Tamam', 'checkbox', False),
                    ('Sorumlu', 'person_reference', False), ('Ekip', 'person_reference', True),
                    ('Koordinatörlük', 'department_reference', False), ('Görev', 'task_reference', False),
                    ('Dosya', 'file_reference', False), ('Bağlı tablo', 'table_reference', False),
                    ('Ek', 'attachment', False)]
            col_id = {}
            for cname, ctype, multi in cols:
                body = {'kind': 'add_column', 'name': cname, 'type': ctype, 'width': 160,
                        'expected_schema': schema}
                if multi:
                    body['multiple'] = True
                r = op(body)
                col_id[ctype + ('*' if multi else '')], schema = r['id'], r['schema_version']
            rnd = random.Random(name)
            for i in range(5):
                row = op({'kind': 'add_row'})['id']
                vals = {'text': f'{name.split()[0]} kalemi {i + 1}', 'number': rnd.randint(1, 400),
                        'phone': f'+90 532 {rnd.randint(100, 999)} {rnd.randint(10, 99)} {rnd.randint(10, 99)}',
                        'email': f'tedarik{i + 1}@ornek.com.tr',
                        'date': (ctx['today'] + dt.timedelta(days=rnd.randint(-10, 30))).isoformat(),
                        'checkbox': i % 2 == 0, 'person_reference': acc[team[i % len(team)]],
                        'person_reference*': [acc[p] for p in team[:2]]}
                if i < 3:  # referanslar ilk satırlarda; kalan satırlar boş hücre gösterir
                    vals.update({k: v for k, v in refs.items() if v})
                op({'kind': 'set_cells', 'cells': [
                    {'row_id': row, 'column_id': col_id[k], 'value': v, 'version': 0} for k, v in vals.items()]})
                if i < 2:
                    fname = ['Teklif_karsilastirma.xlsx', 'Saha_fotografi.png'][i]
                    raw, ctype = multipart(fname, file_size(f'tbl:{name}:{i}') // 2)
                    s.call('POST', f'/v1/tables/{tid}/attachments?row_id={row}&column_id={col_id["attachment"]}'
                           f'&cell_version=0', raw=raw, ctype=ctype, program=prog, dept=D)
            op({'kind': 'set_team_role', 'role': team_role})
            for p, role in grants:
                op({'kind': 'grant', 'account_id': acc[p], 'role': role})
            op({'kind': 'add_comment', 'row_id': row, 'body': 'Bu satırın teslim tarihi netleşmeli.'})
            by_dept[(P, code)] = tid
            made += 1
        except (ApiError, KeyError) as e:
            problems.append(f'tablo {name}: {e}')
    try:  # 2. programda proje: Tedarik planı projeye bağlanır
        s, prog, D = S['gn'], ctx['prog2'], dept['LOJ']
        pid = s.call('POST', '/v1/table-projects', {'kind': 'create_project', 'name': 'İstanbul lojistik'},
                     program=prog, dept=D)['id']
        s.call('POST', f'/v1/tables/{by_dept[(2, "LOJ")]}/operations', {'kind': 'set_project', 'project_id': pid},
               program=prog, dept=D)
    except (ApiError, KeyError) as e:
        problems.append(f'tablo projesi: {e}')
    return made


def groups(ctx):
    """Koordinatörlük otomatik grubu, Genel grup ve elle kurulan gruplar; mesaj, yanıt, anket, oy."""
    S, acc, dept, problems = ctx['sessions'], ctx['acc'], ctx['dept'], ctx['problems']
    msgs = polls = votes = made = 0
    closes = (ctx['today'] + dt.timedelta(days=5)).isoformat() + 'T18:00:00Z'

    def send(code, prog, chat, body, **extra):
        nonlocal msgs
        r = S[code].call('POST', f'/v1/chats/{chat}/messages',
                         {'client_message_id': str(uuid.uuid4()), 'body': body, **extra}, program=prog)
        msgs += 1
        return r['message_id']

    def poll(code, prog, chat, question, options, multi, ballots):
        nonlocal polls, votes
        mid = send(code, prog, chat, question, poll={'options': options, 'multi': multi, 'closes_at': closes})
        polls += 1
        for voter, idx in ballots:
            S[voter].call('PUT', f'/v1/chats/{chat}/messages/{mid}/vote', {'option_indexes': idx}, program=prog)
            votes += 1

    def auto(code, prog, kind, dept_id=None):
        items = S[code].call('GET', '/v1/chats', program=prog)['items']
        return next(c['chat_id'] for c in items
                    if c.get('auto_kind') == kind and (dept_id is None or c.get('auto_department_id') == dept_id))

    p1, p2 = ctx['prog'], ctx['prog2']
    steps = [
        ('2. program LOJ otomatik grubu', lambda: (
            lambda chat: (
                send('gn', p2, chat, 'Sevkiyat takvimi güncellendi; çadırlar salı günü sahada.',
                     mentions=[{'kind': 'account', 'target_id': acc['mey']}]),
                send('mey', p2, chat, 'Depo alanını pazartesi boşaltıyoruz, forklift lazım.'),
                poll('gn', p2, chat, 'Depo sayımı hangi gün yapılsın?', ['Pazartesi', 'Çarşamba', 'Cuma'],
                     False, [('mey', [1]), ('rk', [2])])))(auto('gn', p2, 'department', dept['LOJ']))),
        ('2. program Genel grubu', lambda: send(
            'ma', p2, auto('ma', p2, 'general'),
            'İstanbul 2027 programı açıldı; koordinatörlükler görev planlarını bu hafta girsin.')),
        ('2. program elle grup', lambda: (
            lambda chat: (
                send('bc', p2, chat, 'Basın toplantısı hazırlıklarını burada konuşalım.'),
                poll('bc', p2, chat, 'Basın toplantısı için hangi materyaller hazırlansın?',
                     ['Bülten', 'Fotoğraf seti', 'Video', 'Sunum'], True,
                     [('eo', [0, 1]), ('ss', [1, 3]), ('yc', [0])])))(
                S['bc'].call('POST', '/v1/chats/groups', {
                    'name': 'Basın ve akreditasyon', 'source': 'none',
                    'member_account_ids': [acc[p] for p in ('eo', 'ss', 'yc')]}, program=p2)['chat_id'])),
        ('1. program ALT otomatik grubu', lambda: (
            lambda chat: send('ko', p1, chat, 'Basınç testini cuma yapabiliriz.',
                              reply_to_message_id=send('aa', p1, chat, 'Hidrofor teslimi için son durum nedir?')))(
                auto('aa', p1, 'department', dept['ALT']))),
        ('1. program elle grup', lambda: (
            lambda chat: (
                send('ma', p1, chat, 'Saha teslim tutanağı için ekip burada.'),
                poll('ma', p1, chat, 'Saha teslim günü hangisi olsun?', ['Perşembe', 'Cuma'], False,
                     [('aa', [0]), ('ko', [1]), ('yc', [0])])))(
                S['ma'].call('POST', '/v1/chats/groups', {
                    'name': 'Saha teslim ekibi', 'source': 'none',
                    'member_account_ids': [acc[p] for p in ('aa', 'ko', 'yc', 'rk')]}, program=p1)['chat_id'])),
    ]
    for label, fn in steps:
        try:
            fn()
            made += 1
        except (ApiError, StopIteration, KeyError) as e:
            problems.append(f'grup {label}: {e!r}')
    return f'{made} · mesaj {msgs} · anket {polls} · oy {votes}'


if __name__ == '__main__':
    main()
