# Party Shot Game - Progress.md

## 1. Proje Özeti

**Party Shot Game**, mobil cihazlar için geliştirilecek bir **drinking game / party game** uygulamasıdır.
Oyuncular isimlerini girer, oyun başlatılır ve ekrandaki kapalı karta dokunulduğunda kart açılır. Açılan kartta rastgele seçilmiş bir **oyuncu adı** veya **HERKES** ifadesi ve buna uygun bir **görev / soru / challenge** gösterilir.



---

## 2. Temel Oyun Mantığı

Oyunun ana mantığı şu şekildedir:

1. Kullanıcı oyuna girer.
2. Oyuncu sayısını belirler.
3. Oyuncular isimlerini girer.
4. Oyun ekranında kapalı bir kart gösterilir.
5. Kullanıcı karta dokunur.
6. Kart flip animasyonu ile açılır.
7. Kartın ön yüzünde:
   - rastgele belirlenmiş bir **oyuncu adı** veya **HERKES**
   - buna uygun bir **görev metni**
8. Kullanıcı görevi okur.
9. "Next" / "Sonraki Kart" butonuna basılır.
10. Yeni kapalı kart gelir ve döngü devam eder.

Bu yapı teknik olarak şu mantıkla çalışır:

```text
Tap card
→ target seç
→ task seç
→ kartı aç
→ görevi göster
→ sonraki karta geç
```

---



## 4. Ürün Vizyonu

Amaç, kullanıcıların arkadaş ortamında hızlıca açıp oynayabileceği, sade ama eğlenceli bir mobil party game geliştirmektir.

Uygulama şu özellikleri hedefler:

- hızlı başlangıç
- minimum ayar
- sade ve okunaklı arayüz
- tekrar oynanabilirlik
- yeterli görev çeşitliliği
- akıcı oyun akışı

İlk versiyonda hedef, karmaşık modlar değil; **stabil çalışan bir core game loop** oluşturmaktır.

---

## 5. Kullanılacak Teknolojiler

### Ana teknoloji
- **Flutter**
- **Dart**

### Neden Flutter?
- tek kod tabanı ile Android geliştirme
- hızlı UI geliştirme
- animasyon desteği güçlü
- kart tabanlı arayüz için uygun
- mobil prototipleme süreci hızlı

### İlk sürümde planlanan ek paketler
Paket seçimi geliştirme sırasında netleşebilir; ancak mantıksal olarak şu tip yapılara ihtiyaç olabilir:

- state yönetimi için temel Flutter yapıları (`setState`) veya gerekirse `Provider`
- animasyon için Flutter built-in animation sistemi
- sabit görev verisi için local Dart listeleri / JSON yapısı

İlk sürümde dış bağımlılıkları minimum tutmak hedeflenmektedir.

---

## 6. Hedef Platform

İlk hedef platform:
- **Android**

İleride:
- iOS desteği düşünülebilir

Ancak MVP aşamasında odak yalnızca Android olacaktır.

---

## 7. MVP Kapsamı

İlk sürümde bulunması gereken temel özellikler:

### Oyuncu kurulumu
- start ekranı
- oyuncu sayısını artırma/azaltma
- isim girme ekranı
- isimlerin max 12 karakter olması
- aynı ismin iki kez girilememesi
- minimum oyuncu kontrolü

### Oyun akışı
- kapalı kart gösterimi
- karta tıklanınca flip animasyonu
- oyuncu / herkes seçimi
- uygun görev gösterimi
- sonraki karta geçme

### Görev sistemi
- single player görevleri
- group görevleri
- tekrar kontrolü (aynı görev üst üste gelmesin)

### Basit oyun kuralları
- kartta isim veya HERKES görünmesi
- görev metninin alta yazılması
- akışın sürekli devam etmesi

---

## 8. Hedef Kullanıcı Akışı

```text
Splash / Start
→ Oyuncu Sayısı Seçimi
→ İsim Giriş Ekranı
→ Oyun Ekranı
   → Kapalı Kart
   → Kart Açılır
   → Hedef + Görev Gösterilir
   → Sonraki Kart
→ Oyun devam eder
```

---

## 9. Oyun Ekranı Mantığı

Oyun ekranında tek merkezli bir deneyim hedeflenmektedir.

### Kapalı kart durumu
Kart açılmadan önce kullanıcı yalnızca kartın arka yüzünü görür.
Bu alanda örneğin şunlar olabilir:

- kart arka tasarımı
- "Tap to Reveal"
- küçük ikon

### Açık kart durumu
Kart açıldığında ön yüzde şu bilgiler gösterilir:

- üstte büyük yazı ile hedef
  - örnek: `ALİ`
  - örnek: `HERKES`
- altta görev / soru / challenge metni

Örnek yapı:

```text
+------------------------+
|         ALİ            |
|                        |
| Telefonundaki son      |
| fotoğrafı göster.      |
+------------------------+
```

---

## 10. Görev Sistemi Tasarımı

Bu projede görevler hedef tipine göre ayrılmalıdır.
Çünkü her görev her hedef tipiyle uyumlu değildir.

### Görev tipleri

#### A) Single target tasks
Tek oyuncuya özel görevler.

Örnekler:
- Bir sır ver.
- Son mesajını göster.
- Sağındaki kişiyi taklit et.
- Bir shot iç.

#### B) Group tasks
Tüm gruba yönelik görevler.

Örnekler:
- Herkes 1 yudum içsin.
- En son gülen içsin.
- Masadaki herkes telefonunu göstersin.

### Seçim mantığı

Önce hedef belirlenir:

```text
hedef = oyuncu veya HERKES
```

Sonra hedefe uygun görev havuzundan seçim yapılır:

```text
if hedef == HERKES:
    görev = random(groupTasks)
else:
    görev = random(singleTasks)
```

Bu tasarım çok önemlidir. Böylece anlamsız kombinasyonlar engellenir.

---

## 11. Hedef Seçim Mantığı

Kart açıldığında hedef iki farklı tipte olabilir:

- belirli bir oyuncu
- HERKES

Başlangıç için örnek dağılım:

```text
%80 tek oyuncu
%20 herkes
```

Bu oran ileride ayarlanabilir.


---

## 12. State Management Mantığı

İlk sürümde karmaşık state management şart değildir.
Başlangıç için Flutter içindeki temel state yapıları yeterlidir.

Önerilen mantıksal state modeli:

```text
GameState {
  players,
  currentCard,
  usedTasks,
  recentTargets,
  isCardRevealed
}
```

### Açıklama
- `players`: oyuncu listesi
- `currentCard`: aktif kart bilgisi
- `usedTasks`: kullanılan görevler
- `recentTargets`: son seçilen hedefler
- `isCardRevealed`: kart açık mı kapalı mı

Kart modeli:

```text
CardData {
  targetName,
  taskText,
  taskType
}
```

---

## 13. Animasyon Kararı

Çark animasyonu yerine **flip-card animasyonu** kullanılacaktır.

Amaç:
- kullanıcı karta tıkladığında kartın yatay eksende dönerek açılması
- basit ama tatmin edici bir etkileşim sunulması

İlk sürümde animasyon:
- çok karmaşık olmayacak
- sadece kartın kapalıdan açığa geçişini gösterecek
- performans dostu olacak

---

## 14. UI / UX Kararları

### Tasarım yaklaşımı
- sade
- koyu tema tercih edilebilir
- tek odaklı ekran
- büyük butonlar
- okunaklı metinler
- minimal dikkat dağıtıcı öğe

### Temel ekran prensipleri
- kullanıcı ne yapacağını hemen anlamalı
- bir ekranda tek ana aksiyon olmalı
- oyun ekranında dikkat kartta toplanmalı

### Oyun ekranında gerekli öğeler
- oyuncu bilgisi veya round bilgisi (opsiyonel)
- kart
- kart açıldıktan sonra "Next" butonu
- gerekirse küçük geri butonu / reset

---

## 15. Phase Planı

## Phase 1 - Proje Kurulumu
Amaç: temel Flutter projesini oluşturmak.

Yapılacaklar:
- Flutter proje oluşturma
- temel klasör yapısını kurma
- tema yapısını belirleme
- başlangıç ekranını hazırlama

Çıktı:
- çalışan boş proje
- temel navigation hazır

---

## Phase 2 - Oyuncu Kurulum Akışı
Amaç: oyuncu sayısı ve isim giriş sürecini tamamlamak.

Yapılacaklar:
- start ekranı
- oyuncu sayısı seçme
- `+ / -` ile artırma-azaltma
- isim giriş alanları
- max 12 karakter kontrolü
- duplicate isim engeli
- validation sistemi

Çıktı:
- oyun başlamadan önce geçerli oyuncu listesi oluşur

---

## Phase 3 - Core Game Screen
Amaç: ana oyun ekranını kurmak.

Yapılacaklar:
- kapalı kart tasarımı
- kartın ekranda merkezlenmesi
- kart ön/arka yüz tasarımı
- hedef ve görev metni alanlarını yerleştirme
- next butonu

Çıktı:
- statik ama görsel olarak hazır oyun ekranı

---

## Phase 4 - Game Logic
Amaç: kart açılınca hedef ve görev üretmek.

Yapılacaklar:
- oyuncu seçme mantığı
- HERKES seçme mantığı
- single/group görev listeleri
- görev eşleştirme sistemi
- tekrar azaltma mantığı
- currentCard üretme

Çıktı:
- mantıksal olarak çalışan kart üretim sistemi

---

## Phase 5 - Flip Animation
Amaç: kart açılma deneyimini eklemek.

Yapılacaklar:
- kart tıklama olayı
- flip animasyonu
- reveal state kontrolü
- kart açıkken tekrar tıklamayı engelleme

Çıktı:
- görsel olarak çalışan kart açma deneyimi

---

## Phase 6 - Polish
Amaç: oyunu daha temiz ve stabil hale getirmek.

Yapılacaklar:
- UI düzeltmeleri
- spacing ve tipografi düzenlemeleri
- buton iyileştirmeleri
- küçük animasyon iyileştirmeleri
- edge case kontrolü

Çıktı:
- sunulabilir MVP

---

## Phase 7 - Test ve Build
Amaç: uygulamayı Android için test etmek ve paketlemek.

Yapılacaklar:
- farklı oyuncu sayıları ile test
- validation testleri
- kart akışı testleri
- aynı görev tekrar testi
- APK build alma

Çıktı:
- çalışan Android APK

---

## 16. Folder Structure

Önerilen klasör yapısı:

```text
lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── routes.dart
│   └── theme.dart
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── utils/
│   │   └── validators.dart
│   └── helpers/
│       └── random_helper.dart
├── features/
│   ├── setup/
│   │   ├── models/
│   │   │   └── player.dart
│   │   ├── screens/
│   │   │   ├── start_screen.dart
│   │   │   └── player_setup_screen.dart
│   │   └── widgets/
│   │       ├── player_count_selector.dart
│   │       └── player_name_input.dart
│   └── game/
│       ├── models/
│       │   ├── card_data.dart
│       │   └── task_item.dart
│       ├── data/
│       │   └── task_repository.dart
│       ├── logic/
│       │   └── game_engine.dart
│       ├── screens/
│       │   └── game_screen.dart
│       └── widgets/
│           ├── flip_card_widget.dart
│           ├── card_front.dart
│           ├── card_back.dart
│           └── next_button.dart
└── shared/
    └── widgets/
        ├── custom_button.dart
        └── custom_text_field.dart
```

Bu yapı avantajlıdır çünkü:
- setup ve game ayrılır
- logic ile UI ayrılır
- ileride yeni mod eklemek kolaylaşır

---

## 17. Veri Modelleri

### Player

```text
Player {
  id,
  name
}
```

### TaskItem

```text
TaskItem {
  id,
  text,
  type   // single | group
}
```

### CardData

```text
CardData {
  targetName,
  taskText,
  isGroupTask
}
```

---

## 18. Game Engine Sorumlulukları

`game_engine.dart` dosyası şu işleri yapmalıdır:

- hedef seçmek
- görev seçmek
- hedef-görev uyumunu korumak
- tekrarları azaltmak
- yeni kart üretmek
- oyun turunu yönetmek

Bu sınıfın amacı UI kodunu oyun mantığından ayırmaktır.
Bu ayrım ileride bakım kolaylığı sağlar.

---

## 19. Validasyon Kuralları

Oyuncu setup ekranında aşağıdaki kurallar uygulanmalıdır:

- boş isim kabul edilmez
- aynı isim iki kere kabul edilmez
- isim 12 karakterden uzun olamaz
- oyuncu sayısı alt sınırın altına düşemez
- oyun geçerli oyuncular olmadan başlatılamaz

Bu kurallar proje kalitesi için kritiktir.

---

## 20. İlk İçerik Stratejisi

İlk sürümde yüzlerce görev yazmak şart değildir.
Önce küçük ama düzgün bir içerik havuzu hazırlanmalıdır.

Öneri:
- 20 adet single task
- 10 adet group task

Sonra sistem stabil çalışınca görev sayısı artırılabilir.

Odak sırası:
1. önce sistem çalışsın
2. sonra içerik artsın

---

## 21. Riskler ve Teknik Notlar

### Olası riskler
- kart animasyonunda state hataları
- aynı görevin çok sık tekrarı
- aynı oyuncunun sık seçilmesi
- setup ekranında validation eksikleri
- UI taşmaları (özellikle uzun görev metinlerinde)

### Önlem yaklaşımı
- görev metinleri kontrollü uzunlukta hazırlanmalı
- recent history tutulmalı
- animasyon esnasında ekstra tıklama engellenmeli
- testler küçük adımlarla yapılmalı

---

## 22. MVP Sonrası Geliştirme Fikirleri

MVP tamamlandıktan sonra düşünülebilecek geliştirmeler:

- kategori sistemi (truth / dare / hot / chaos)
- zorluk seviyesi
- özel modlar
- tema sistemi
- ses efektleri
- titreşim desteği
- skor / ceza sayacı
- oyuncu eleme modu
- özel görev paketi ekleme
- çok daha iyi kart animasyonları

Ancak bunlar ilk sürüm hedefi değildir.
Öncelik her zaman çalışan çekirdek sistemdir.

---

## 23. Mevcut Net Proje Kararı

Bu proje için alınmış net teknik ve tasarımsal kararlar:

- oyun türü: **party / drinking game**
- platform: **mobile**
- teknoloji: **Flutter + Dart**
- ana oyun mekaniği: **flip card reveal**
- çark sistemi: **iptal edildi**
- hedef yapısı: **oyuncu adı veya HERKES**
- görev yapısı: **single task + group task**
- ilk hedef: **çalışan MVP**

---

## 24. Çalışma Prensibi Özeti

Bu proje için temel geliştirme prensibi şudur:

- önce basit ve sağlam sistem kur
- gereksiz kompleks feature ekleme
- küçük adımlarla ilerle
- her phase sonunda test et
- UI ile logic'i mümkün olduğunca ayır
- önce core loop'u bitir, sonra polish yap

---

## 25. Sonuç

Party Shot Game projesi için en uygun yaklaşımın çark yerine kart tabanlı bir sistem olduğu belirlenmiştir.
Bu karar, hem teknik zorluğu düşürmekte hem de projenin daha hızlı ve daha stabil şekilde ilerlemesini sağlamaktadır.

Bu dosya, projenin mevcut yönünü, teknik kararlarını, klasör yapısını, geliştirme aşamalarını ve MVP hedeflerini tek yerde toplamak amacıyla hazırlanmıştır.
Bundan sonraki geliştirme sürecinde bu dosya referans alınarak adım adım ilerlenmelidir.

## SONRADAN EKLEDİKLERİM/OLMASI GEREKENLER##
Haptic Feedback (Titreşim): Kart tıklandığında ve tam döndüğü anda küçük bir titreşim eklemek, fiziksel bir karta dokunuyormuş hissi verir.

Persistent Players (Yerel Kayıt): Oyundan çıkıp girince oyuncu isimlerini tekrar yazmamak için küçük bir yerel kayıt (shared_preferences) eklenebilir.
