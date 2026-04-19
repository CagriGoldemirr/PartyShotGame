# Highlight Circle Mode — Öğrenme Dosyası

## 1. Bu modun amacı nedir?

Bu modda amaç, oyuncu seçimini **kard kullanmadan** görsel olarak ilgi çekici hale getirmektir.

Kard yerine:
- oyuncular ekranda bir **çember** şeklinde dizilir,
- bir **highlight / ışık / aktif halka** oyuncuların üzerinde dolaşır,
-her bir oyunucunun rastegele avatarları vardır görsel olarak .Işık bunlar üzerinden dolanır.
- sonra yavaşlayarak bir oyuncuda durur,
- seçilen oyuncu ekranda belirgin şekilde gösterilir,
- ardından kart açılıp görev gösterilebilir.

Bu sistemin gücü şuradadır:

- kard kadar karmaşık görünmez,
- daha modern görünür,
- kullanıcı seçim sürecini gözle görür,
- "rastgele seçim yapıldı" hissi verir.

---

## 2. Kullanıcı ekranda ne görür?

Temel görünüm şöyledir:

```text
        P1
   P8         P2

 P7            P3

   P6         P4
        P5
```

Burada:
- `P1, P2, P3 ...` oyunculardır
- 
- dış halkada oyuncular bulunur
- aktif seçim efekti oyuncular arasında dolaşır
-En son  highlited/ışık bir oyuncu üzerinde durduğunda o oyuncunun avatarı ve oyuncunun ismi ekranda gösterilir(biraz büyük şekilde avatarı ve ismi)
-Her oyuncuya rastgele bir avatar atansın.Bu avatardan kastım bir görsel olsun.Sana örneklerini atacağım
Yani ekranın merkezi karttır, oyuncular ise çevresindedir.

---

## 3. Bu mod neden iyi bir fikir?

Çünkü kardta bütün ekran neredeyse tek bir objeye dönüşür.  
Ama Highlight Circle sisteminde hem:

- oyuncular görünür,
- seçme animasyonu görünür,


Bu yüzden bu mod, senin kart açma fikrinle çok daha uyumludur.

Bu modun en büyük avantajları:

### Avantajlar
- modern görünür
- kardtan daha temiz bir tasarım sunar
- oyuncular ekranda sürekli görünür
- seçim süreci eğlenceli olur
- kart sistemiyle rahat birleşir

### Dezavantajlar
- karda göre biraz daha özel tasarım ister
- çember yerleşimi için küçük bir matematik gerekir
- animasyon akışını düzgün kurmak gerekir

---

## 4. Sistemin temel mantığı nedir?

Aslında mantık göründüğünden daha basittir.

Bir oyuncu listesi vardır:

```dart
players = ["Ali", "Ayşe", "Mehmet", "Zeynep"];
```

Bir de aktif oyuncuyu gösteren bir index tutulur:

```dart
currentIndex = 0;
```

Highlight animasyonu çalışırken yapılan şey şudur:

- aktif index sürekli artar
- her artışta başka oyuncu highlight olur
- animasyon başta hızlıdır
- sonra yavaşlar
- sonunda bir indexte durur

Yani mantık özünde şöyledir:

```dart
currentIndex = (currentIndex + 1) % players.length;
```

Bu kadar.

Asıl "havalı" görünen kısım, bunun ekranda animasyonlu gösterilmesidir.

---

## 5. Çember şeklinde yerleşim nasıl çalışır?

Oyuncuları çember üzerine koymak için her oyuncuya bir açı verilir.

Örnek:
- 8 oyuncu varsa,
- çember 360 derecedir,
- her oyuncu yaklaşık 45 derece arayla yerleştirilir.

Matematiksel olarak mantık şöyledir:

- merkez nokta var
- yarıçap var
- her oyuncunun açısı var
- `cos` ve `sin` ile x ve y bulunur

Formül:

```dart
x = centerX + radius * cos(angle);
y = centerY + radius * sin(angle);
```

Burada:
- `centerX`, `centerY` = çemberin merkezi
- `radius` = oyuncuların merkeze uzaklığı
- `angle` = oyuncunun çember üzerindeki açısı

Bu kısım ilk bakışta zor görünür ama bir kez kurulunca sürekli çalışır.

---

## 6. Highlight efekti tam olarak nedir?

Highlight efekti, o an seçilmekte olan oyuncunun diğerlerinden farklı görünmesidir.

Örneğin aktif oyuncuda şunlar olabilir:

- daha büyük görünmesi
- opaklığının artması
- çevresinde parlak bir halka olması
- glow / shadow efekti olması
- border renginin değişmesi

### Normal oyuncu
- scale: 1.0
- opacity: 0.6
- ince border

### Aktif oyuncu
- scale: 1.15 veya 1.2
- opacity: 1.0
- glow
- parlak border

Bu sayede kullanıcı o anda hangi oyuncunun "üzerinden geçildiğini" net görür.

---

## 7. Animasyon akışı nasıl olmalı?

Bu modun hissini veren kısım animasyon akışıdır.

En iyi akış genelde 3 aşamalıdır:

### Aşama 1 — Hızlı başlangıç
Highlight çok hızlı gezer.

Örnek:
- 60 ms
- 70 ms
- 80 ms

Burada kullanıcı "başladı" hissini alır.

### Aşama 2 — Yavaşlama
Her adımda biraz daha geç hareket eder.

Örnek:
- 90 ms
- 110 ms
- 140 ms
- 180 ms
- 230 ms

Burada kullanıcı "seçim yapılıyor" hissini alır.

### Aşama 3 — Durma
Highlight seçilen oyuncuda durur.

Son anda küçük bir:
- bounce
- scale up
- glow artışı

eklenirse çok daha kaliteli görünür.

---

## 8. Kart sistemiyle nasıl birleşir?

Bu mod tek başına kullanılmak zorunda değildir.  
Asıl güçlü hali kart sistemiyle birleşmesidir.

Önerilen akış:

1. Oyuncular çemberde görünür
2. Ortada kapalı kart vardır
3. Kullanıcı karta basar
4. Highlight animasyonu başlar
5. Bir oyuncuda durur
6. Kart flip olur
7. Kartın ön yüzünde:
   - seçilen oyuncu
   - görev / soru / ceza
   gösterilir

Örnek sonuç:

- "Ali içiyor"
- "Ayşe cevap veriyor"
- "Herkes shot alır"

Yani Highlight Circle oyuncuyu seçer, kart ise görevi açıklar.

---

## 9. Bu modu kodlamak zor mu?

Net cevap:

**Orta seviyede. Ama parçalayınca yapılabilir.**

Zorluk puanı:
**10 üzerinden yaklaşık 5-6**

### Neden çok zor değil?
Çünkü ana mantık karmaşık değil:
- oyuncu listesi var
- aktif index var
- index sırayla değişiyor
- aktif oyuncu farklı çiziliyor

### Neden tamamen kolay da değil?
Çünkü:
- çember yerleşimi lazım
- animasyon akışı lazım
- kart ile senkron çalışması lazım
- state karışmamalı

Yani bu sistem:
- mantık olarak orta,
- görsel kalite olarak dikkat isteyen bir sistemdir.

---

## 10. En güvenli geliştirme yöntemi nedir?

Bu modu tek seferde yazmamalısın.  
Adım adım kurmalısın.

### Adım 1 — Statik çember
Önce hiçbir animasyon olmadan:
- oyuncuları çember şeklinde göster

Hedef:
- sadece ekranda düzgün görünmeleri

### Adım 2 — Tek oyuncuyu highlight et
Bir `currentIndex` belirle ve sadece o oyuncuyu parlak göster

Hedef:
- highlight mantığını kurmak

### Adım 3 — Butonla index ilerlet
Bir butona basınca:
- highlight bir sonraki oyuncuya geçsin

Hedef:
- aktif oyuncunun değişmesini görmek

### Adım 4 — Otomatik döndür
Artık index otomatik artsın

Hedef:
- highlight gezsin

### Adım 5 — Yavaşlayarak durdur
Zaman aralıklarını büyüterek durdur

Hedef:
- gerçek seçim hissi

### Adım 6 — Kart flip bağla
Seçim bitince kart açılsın

Hedef:
- tam oyun deneyimi

Bu sıra çok önemlidir.  
Çünkü bir anda her şeyi yapmaya çalışırsan sistem karışır.

---

## 11. Flutter tarafında hangi yapı taşları gerekir?

Bunu anlamak için önce widget mantığını ayıralım.

### Gerekebilecek temel yapılar

#### 1. `Stack`
Çünkü ortada kart, çevrede oyuncular olacak.

#### 2. `Positioned`
Oyuncuları çember üzerinde belirli noktalara yerleştirmek için.

#### 3. `AnimatedContainer`
Highlight durumunda border, shadow, renk gibi geçişler için.

#### 4. `AnimatedScale`
Aktif oyuncuyu biraz büyütmek için.

#### 5. `AnimatedOpacity`
Pasif oyuncuları daha soluk göstermek için.

#### 6. `Timer` veya `Future.delayed`
Highlight'ın sırayla ilerlemesi için.

#### 7. State yönetimi
Şimdilik basit bir yapı yeter:
- `StatefulWidget`

İleride istersen Provider gibi bir şey eklenebilir ama başlangıç için şart değil.

---

## 12. Basit pseudo-flow

Aşağıdaki akış bu modun mantığını sade biçimde anlatır:

```dart
onTapCard() async {
  isSelecting = true;

  for (int i = 0; i < totalSteps; i++) {
    await Future.delayed(currentDelay);
    currentIndex = (currentIndex + 1) % players.length;
    setState(() {});

    currentDelay += delayIncrement;
  }

  selectedPlayer = players[currentIndex];
  isSelecting = false;

  flipCard();
}
```

Bu kod gerçek proje kodu değildir.  
Ama mantığı doğru anlatır:

- kart tıklanır
- seçim başlar
- index ilerler
- delay büyür
- seçim durur
- oyuncu seçilir
- kart açılır

---

## 13. Görsel kaliteyi artıran ek fikirler

Bu mod temel haliyle de güzel görünür.  
Ama daha kaliteli yapmak istersen şu fikirler eklenebilir:

### 1. Avatar kullanmak
Sadece isim yerine:
- profil foto
- renkli circle avatar
- baş harf avatarı

kullanılabilir.

Bu mod avatar ile çok daha güçlü görünür.

### 2. Glow efekti
Aktif oyuncunun etrafında:
- neon halka
- yumuşak gölge
- hafif pulse

olabilir.

### 3. Ortadaki karta minik reaksiyon
Highlight dönerken kart hafif titreşebilir veya parlayabilir.

### 4. Ses efekti
Her geçişte küçük "tick" sesi olabilir.  
Durduğu anda daha güçlü bir ses eklenebilir.

Bu küçük detaylar hissiyatı ciddi artırır.

---

## 14. Hangi durumlarda bu mod çok iyi çalışır?

Bu mod özellikle şu durumda çok iyi çalışır:

- oyuncu sayısı az ya da orta ise  
  (örneğin 3-8 kişi)

Çünkü çok fazla oyuncu olursa çember sıkışır.

### En iyi aralık
- 4, 5, 6, 7, 8 oyuncu

### Dikkat edilmesi gereken durum
- 10+ oyuncuda avatar/isimler çok küçülebilir

Bu yüzden ileride iki düzen düşünülebilir:
- az oyuncuda büyük çember
- çok oyuncuda daha kompakt görünüm

---

## 15. Bu modu neden senin projen için uygun görüyorum?

Senin projede şunlar önemli:
- kart sistemi var
- modern görünüm istiyorsun
- kardtan hoşlanmadın
- oyuncu seçimi görsel olarak ilgi çekici olsun istiyorsun

Highlight Circle tam bu boşluğu dolduruyor.

Çünkü:
- kart sistemini bozmaz
- oyuncu seçimini görsel hale getirir
- kard kadar kaba durmaz
- party game havasını korur

Bu yüzden bu mod, senin proje fikrin için güçlü bir adaydır.

---

## 16. Son net değerlendirme

Bu modun özeti şudur:

**Highlight Circle**, oyuncuları ekranın çevresine dizip aktif seçimi ışık/halkayla gösteren, sonra yavaşlayarak bir oyuncuda duran bir seçim sistemidir.

Bu sistem:
- kardtan daha modern,
- kart sistemiyle daha uyumlu,
- görsel olarak daha temiz,
- uygulanabilirlik açısından orta seviyede bir çözümdür.

En doğru geliştirme yaklaşımı:
- önce çember görünümü,
- sonra highlight,
- sonra animasyon,
- sonra kart entegrasyonu

şeklinde ilerlemektir.

---

## 17. Kısa ezber değil, mantık özeti

Bu modu unutursan şu cümleyi hatırla:

**"Oyuncular çemberde duruyor, aktif index sırayla geziyor, yavaşlayıp birinde duruyor, sonra kart açılıyor."**

Bütün sistemin özü budur.
