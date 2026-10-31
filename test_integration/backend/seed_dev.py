#!/usr/bin/env python3
"""Yerel geliştirme backend'ine (up.sh) prototip örnek verisini YALNIZ API ile basar.

Kaynak: mobil örnek kataloğu (lib/features/tasks/data/sample/sample_task_data.dart — 16 kişi,
11 koordinatörlük, 76 görev) ve takvim/mesaj örneklerinin prototip içerikleri. Görevler Dart
dosyasından okunur; örnek katalog değişirse tohum da değişir.

Tarihler: örnek kataloğun "bugün"ü 2026-10-21'dir. Bütün tarihler sunucunun bugününe kaydırılır
(fark = bugün − 2026-10-21); gecikme günleri ve "bugünkü toplantılar" prototiple aynı kalır.

Hesaplar: `ma` = ilk yönetici (up.sh'in açtığı hesap; adı güncellenir). Diğerleri
<ad.soyad>@nizam.local, hepsi aynı geliştirme parolasıyla (sır değildir; atılabilir veritabanı).

Kullanım: dev-up.sh (up.sh + bu betik). Yalnız boş kurulumda koşar (program varsa durur).
Ortam: NIZAMIO_IT_BACKEND (varsayılan http://127.0.0.1:18140), NIZAMIO_IT_ADMIN_EMAIL,
NIZAMIO_IT_ADMIN_PASSWORD (dev girişinin varsayılanları).
"""
import datetime as dt
import io
import json
import os
import re
import sys
import time
import urllib.error
import urllib.request
import uuid
import zipfile

BASE = os.environ.get('NIZAMIO_IT_BACKEND', 'http://127.0.0.1:18140')
ADMIN_EMAIL = os.environ.get('NIZAMIO_IT_ADMIN_EMAIL', 'admin@nizam.local')
PASSWORD = os.environ.get('NIZAMIO_IT_ADMIN_PASSWORD', 'Pasword.123123')
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
TASKS_DART = os.path.join(ROOT, 'lib/features/tasks/data/sample/sample_task_data.dart')
SAMPLE_TODAY = dt.date(2026, 10, 21)

PROGRAM = {'name': 'Şanlıurfa Teknofest', 'year': 2026,
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


def sample_file(name):
    ext = name.rsplit('.', 1)[1]
    if ext == 'pdf':
        return b'%PDF-1.4\n% NIZAM.IO ornek dosya\n%%EOF\n'
    if ext == 'png':
        return bytes.fromhex('89504e470d0a1a0a0000000d4948445200000001000000010806000000'
                             '1f15c4890000000d49444154789c6360000002000154a24f5d0000000049454e44ae426082')
    buf = io.BytesIO()
    with zipfile.ZipFile(buf, 'w') as z:
        z.writestr('[Content_Types].xml', '<?xml version="1.0"?><Types/>')
        z.writestr('ornek.txt', 'NIZAM.IO ornek dosya')
    return buf.getvalue()


def multipart(filename):
    b = uuid.uuid4().hex
    head = (f'--{b}\r\nContent-Disposition: form-data; name="file"; filename="{filename}"\r\n'
            f'Content-Type: {MIME[filename.rsplit(".", 1)[1]]}\r\n\r\n').encode()
    return head + sample_file(filename) + f'\r\n--{b}--\r\n'.encode(), f'multipart/form-data; boundary={b}'


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
    ids, problems = {}, []
    for t in tasks:
        code, D = t['coord'], dept[t['coord']]
        creator = t['creator'] if role.get((code, t['creator'])) == 'koordinator' else 'ma'
        s = sessions[creator]
        worker = t['assignees'][0] if t['assignees'] else creator
        # Şirket yöneticisi koordinatör olsa da dosya yükleyemez (records.not_authorized): dosyayı
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
        except ApiError as e:  # koordinatör geçmiş başlangıçlı görev açamaz; yönetici açar
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
            if t['status'] != 'baslanmadi':  # dosya yalnız başlamış göreve yüklenir
                move(worker, wid, prog, D, 'devam_ediyor')
            for i in range(files):
                raw, ctype = multipart(FILE_NAMES[i % len(FILE_NAMES)])
                sessions[uploader].call('POST', f'/v1/work-items/{wid}/files?tag={TAGS[i % len(TAGS)]}',
                            raw=raw, ctype=ctype, program=prog, dept=D)
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

    # Mesajlar.
    for frm, to, subject, content in MESSAGES:
        try:
            sessions[frm].call('POST', '/v1/messages', {
                'receiver_account_id': acc[to], 'subject': subject, 'content': content}, program=prog)
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


if __name__ == '__main__':
    main()
