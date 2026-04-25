import 'models/task_item.dart';
import 'dart:math'; // Rastgele seçim için

class TaskRepository {
  static final List<TaskItem> allTasks = [
    // ==========================================
    // SEVİYE 1: ISINMA (Eğlence, Merak ve Hafif İtiraflar)
    // ==========================================
    
    

    TaskItem(
        text: "Küçüklük ünlü aşkını (crush) itiraf et. Çekinirsen 1 shot at.",
        type: TaskType.single,
        level: 1),
    TaskItem(
        text: "En sevdiğin şarkıyı mırıldan, gruptan biri bilemezse 1 shot at.",
        type: TaskType.single,
        level: 1),
    TaskItem(
        text: "Galerindeki en son fotoğrafı herkese göster. Göstermek istemezsen 1 shot at.",
        type: TaskType.single,
        level: 1),
    TaskItem(
        text: "Masadaki herkese sırayla, hiç beklemedikleri bir iltifat et. Yapamazsan 1 shot at.",
        type: TaskType.single,
        level: 1),
    TaskItem(
        text: "Sağındaki oyuncunun en belirgin huyunun taklidini yap. Grup beğenmezse 1 shot at,beğenirse o kişi 1 shot atar.",
        type: TaskType.single,
        level: 1),
    TaskItem(
        text: "İlkokul yıllarına dair komik veya utanç verici bir anını anlat. Anlatmazsan 1 shot at.",
        type: TaskType.single,
        level: 1),
    TaskItem(
        text: "Solundaki oyuncuya bir filmi  sessiz sinema şeklinde anlatmaya çalış.2dk boyunca anlatamazsan 1 shot at.",
        type: TaskType.single,
        level: 1),
    
    TaskItem(
        text: "Ellerinle masaya vurarak bir şarkı ritmi tut, kimse bilemezse 1 shot at.",
        type: TaskType.single,
        level: 1),
    TaskItem(
        text: "Masada sana en tuhaf gelen kendi huyunu itiraf et. İtiraf etmezsen 1 shot at.",
        type: TaskType.single,
        level: 1),
    TaskItem(
        text: "Masadaki herkes kendi kadehini/bardağını ellerini kullanmadan içmeye çalışsın. Yapamayan 1 shot atar.",
        type: TaskType.group,
        level: 1),
    TaskItem(
        text: "Gözlerini kapat. Biri sana rastgele bir nesne versin. Sadece dokunarak ne olduğunu tahmin et. Bilemezsen 1 shot at.",
        type: TaskType.single,
        level: 1),
    TaskItem(
        text: "Masadaki birini seç ve onun hakkında %100 uydurma ama ikna edici bir hikaye anlat. Grup inanmazsa 1 shot at.",
        type: TaskType.single,
        level: 1),
    TaskItem(
        text: "Herkes sana 1 kelime söylesin. Kısa sürede bu kelimelerle mini hikaye kur. Kuramazsan 1 shot at.",
        type: TaskType.single,
        level: 1),
    TaskItem(
        text: "Sağındaki kişi senin ses tonunu taklit etsin. Sen de onunkiyle konuş. Gülersen 1 shot at.",
        type: TaskType.single,
        level: 1),
    TaskItem( 
        text: "Sana bir harf verilecek diğer oyuncular tarafından. 10 saniyede o harfle başlayan 3 ülke söyle. Yapamazsan 1 shot at.",
        type: TaskType.single,
        level: 1),
    // --- YENİ EKLENEN SEVİYE 1 GÖREVLERİ ---
    TaskItem(
        text: "Herkes 1 shot içer.",
        type: TaskType.group,
        level: 1),
    TaskItem(
        text: "Sağındaki 1 shot  içer.",
        type: TaskType.single,
        level: 1),
    TaskItem(text: "Solundaki oyuncu senin telefonunu alsın ve 1 dakika boyunca istediği uygulamaya (mesajlar hariç) baksın. Kabul etmezsen 2 shot at.",
         type: TaskType.single, 
        level: 1),
    TaskItem(
        text: "1 dakika plank yap. Yapamazsan 1 shot iç.",
        type: TaskType.single,
        level: 1),
    TaskItem(
        text: "30 saniyede 30  squat yap. Tam yapmazsan 1 shot iç.",
        type: TaskType.single,
        level: 1),
    TaskItem(
        text: "15 saniye boyunca hiç göz kırpma. Kırparsan 1 shot iç.",
        type: TaskType.single,
        level: 1),
    TaskItem(
        text: "10 saniye içinde alfabeyi Z'den geriye doğru en az 5 harf say. Takılırsan 1 shot at.", 
        type: TaskType.single, 
        level: 1),
        

    // ==========================================
    // SEVİYE 2: ORTA ZORLUK (Utanç, Grup Dinamiği ve Hareket)
    // ==========================================
    TaskItem(text: "PLANK TESTİ: 1 dakika boyunca plank pozisyonunda bekle. Eğer yere düşersen veya süreyi tamamlayamazsan 2 shot at!", type: TaskType.single, level: 2),
    TaskItem(
        text: "Utanç verici bir anını tüm çıplaklığıyla anlat. Çekinirsen 2 shot at.",
        type: TaskType.single,
        level: 2),
    TaskItem(text: "TEK AYAK ÜSTÜNDE: Gözlerini kapat ve tek ayak üzerinde 45 saniye durmaya çalış. Dengeni kaybedersen 2 shot at!", type: TaskType.single, level: 2),
    TaskItem(text: "DUVAR OTURUŞU: Sırtını duvara yaslayarak (hayali bir sandalyede oturur gibi) 1 dakika bekle. Titrer ve kalkarsan 2 shot at!", type: TaskType.single, level: 2),
    TaskItem(text: "ŞINAV MARATONU: Masadaki en güçlü olduğunu düşündüğün kişiyle şınav yarışına gir. Ondan önce pes edersen 2 shot at!", type: TaskType.single, level: 2),    
    TaskItem(
        text: "Kendin hakkında kimsenin bilmediği karanlık bir sır söyle. Söylemezsen 2 shot at.",
        type: TaskType.single,
        level: 2),
    TaskItem(text: "DENGE TESTİ: Seçtiğin bir oyuncuyla el ele tutuşup tek ayak üzerinde 15 saniye durun. Eğer biriniz dengesini kaybederse ikiniz de 2 shot atın!", type: TaskType.group, level: 2),
    TaskItem(text: "KÖR YÜRÜYÜŞÜ: Gözlerini bağla ve masadaki birinin tarifine göre odadaki 3 farklı eşyaya dokunmaya çalış. Bir yere çarparsan 2 shot at!", type: TaskType.single, level: 2),
    TaskItem(text: "SABIR TESTİ: Solundaki oyuncu burnuna veya kulağına bir tüy/kağıt parçasıyla dokunurken 1 dakika boyunca hiç kıpırdamadan dur. Kaşınırsan 3 shot at!", type: TaskType.single, level: 2),
    TaskItem(
        text: "Tüm oyuncular şınav çeksin! En az çeken 1 shot atar.",
        type: TaskType.group,
        level: 2),
    TaskItem(
        text: "Grup içindeki birinin dedikodusunu herkesle açıkça paylaş. Yapmazsan 2 shot at.",
        type: TaskType.single,
        level: 2),
    TaskItem(text: "SQUAT REKABETİ: Masadaki bir rakip seç! 1 dakika içinde en çok squat yapan kazanır. Kaybeden 2 shot atar!", type: TaskType.group, level: 2),
    TaskItem(
        text: "Masadan birini seç ve doğurma taklidi yap, seçtiğin kişi de ebe olsun! Oynamazsanız ikiniz de 1'er shot atın.",
        type: TaskType.single,
        level: 2),
    TaskItem(
        text: "Hiçbir sebep yokken, tühhh... Direkt 2 shot at!",
        type: TaskType.single,
        level: 2),
    TaskItem(
        text: "En son izlediğin filmi/diziyi 30 saniye boyunca konuşmadan pandomim ile anlat. Bilemezlerse 2 shot at.",
        type: TaskType.single,
        level: 2),
    TaskItem(
        text: "Bardağını kafanın üstünde 10 saniye boyunca dengede tut. Düşürürsen 2 shot at.",
        type: TaskType.single,
        level: 2),
    
    TaskItem(
    text: " Masadaki oyunculardan biri sana rastgele bir nesne versin. Bu nesneyi gerçek bir  partnerinmiş gibi tutarak 60 saniye boyunca eğlenceli bir müzikle dans et .Yapmazsan 2 shot.", 
    type: TaskType.single, 
    level: 2),
    TaskItem(
        text: "Masadaki herkes sana rastgele bir kelime versin, bu kelimeleri kullanarak anlamlı bir cümle kur. Kuramazsan 2 shot at.",
        type: TaskType.single,
        level: 2),
    TaskItem(
        text: "Son 1 hafta içinde yaptığın en mantıksız/saçma şeyi itiraf et. Anlatmazsan 2 shot at.",
        type: TaskType.single,
        level: 2),
    TaskItem(
        text: "Gruptan seçtiğin biriyle göz kırpma yarışması yap. İlk gözünü kırpan 2 shot atar.",
        type: TaskType.single,
        level: 2),
    TaskItem(
        text: "Masadaki herkesin ilk tanıştığınızda sana verdiği izlenimi tek tek itiraf et. Kaçarsan 2 shot at.",
        type: TaskType.single,
        level: 2),
    
    TaskItem(
        text: "Gruptan biri sana bir challenge versin (örneğin 1 ayak üstünde durarak konuş). Başaramazsan 2 shot at.",
        type: TaskType.single,
        level: 2),
    TaskItem(
        text: "10 saniyede masadaki herkes hakkında tek kelimelik analiz yap. Takılırsan 2 shot at.",
        type: TaskType.single,
        level: 2),
    TaskItem(
        text: "Sağındaki oyuncu senin adına sahte bir anı anlatsın. Sen bunu devam ettirmek zorundasın. Koparsan 2 shot at.",
        type: TaskType.single,
        level: 2),
    TaskItem(
        text: "İlk oyuncu hikâyeye tek cümleyle başlar. Her oyuncu önce tüm hikâyeyi doğru akışla özetler, sonra yeni bir cümle ekler. Mantığı bozan veya unutup kopan 2 shot atar.",
        type: TaskType.group,
        level: 2),
    // --- YENİ EKLENEN SEVİYE 2 GÖREVLERİ ---
    TaskItem(
        text: "Sadece sen 2 shot iç.",
        type: TaskType.single,
        level: 2),
    TaskItem(
        text: "Herkes parmağıyla grubun ucubesini göstersin. En çok oy alan 2 shot içer.",
        type: TaskType.group,
        level: 2),
    TaskItem(
        text: "Solundaki oyuncu seni 1 dakika boyunca istediği komik bir şekle soksun. Bu sürede kıpırdarsan veya gülersen 1 shot at.",
        type: TaskType.single,
        level: 2),
      TaskItem(
        text: "Sağındaki oyuncuyla üstündeki bir kıyafeti (ceket, şapka, gözlük vb.) oyunun sonuna kadar değiştir. Kabul etmezsen 2 shot at.",
        type: TaskType.single,
        level: 2),
      TaskItem(
        text: "Galerindeki Silinmiş Fotoğraflar klasörüne gir ve en son sildiğin 10 fotoğrafı herkese göster. Göstermezsen 3 shot at",
        type: TaskType.single,
        level: 2),
      TaskItem(
        text: "Bu grupta en az güvendiğin kişiyi ve nedenini dürüstçe açıkla. Kıvırırsan 3 shot at.",
        type: TaskType.single,
        level: 2),
    

    // ==========================================
    // SEVİYE 3: ZORLAYICI (Krizler, Sert İtiraflar ve Cesaret)
    // ==========================================
    TaskItem(
        text: "Son ilişkini tüm detaylarıyla ve tam olarak neden bittiğini anlat. Anlatmazsan 3 shot at.",
        type: TaskType.single,
        level: 3),

    TaskItem(
    text: " Gözlerini kapat. Masadakilerden biri elini sana uzatsın (kim olduğunu bilmeyeceksin). O eli öp ve kimin eli olduğunu tahmin et. Bilemezsen 3 shot at!", 
    type: TaskType.single, 
    level: 3),

    TaskItem(
    text: "HAVA TAŞITI: Masadan birini seç. O kişi yere yatsın, sen de onun üzerinde 30 saniye boyunca tam nizami şınav pozisyonunda (ona değmeden) bekle. Titrer veya düşersen 3 shot at!", 
    type: TaskType.single, 
    level: 3),


    TaskItem(
        text: "Masada sana borcu olan birinden borcunu hemen şimdi yüksek sesle iste. İsteyemezsen 3 shot at.",
        type: TaskType.single,
        level: 3),
    TaskItem(
        text: "Hayatında yaptığın en yasadışı veya kural dışı şeyi itiraf et. Çekinirsen 3 shot at.",
        type: TaskType.single,
        level: 3),
    TaskItem(
        text: "Masadaki oyunculardan birine daha önce yüzüne hiç söylemediğin bir gerçeği (iyi veya kötü) söyle. Söylemezsen 3 shot at.",
        type: TaskType.single,
        level: 3),
    TaskItem(
        text: "Grupta 'en çok' ve 'en az' sevdiğin huyu olan kişileri ve nedenini dürüstçe söyle. Kıvırırsan 3 shot at.",
        type: TaskType.single,
        level: 3),
    TaskItem(
        text: "Masadan birini seç. O kişi sana istediği bir soruyu sorsun ve kesinlikle doğru cevap ver. Yalanlarsan veya susarsan 3 shot at.",
        type: TaskType.single,
        level: 3),
    TaskItem(
        text: "Bugüne kadar söylediğin en büyük yalanı ve kime söylediğini itiraf et. Etmezsen 3 shot at.",
        type: TaskType.single,
        level: 3),
    TaskItem(
        text: "Ağzına bir yudum su/içki al, solundaki kişi seni 30 saniye boyunca güldürmeye çalışsın. Püskürtürsen veya yutarsan 3 shot at.",
        type: TaskType.single,
        level: 3),
    TaskItem(
        text: "Sağındaki oyuncunun telefonunu al, galerisinde rastgele bir fotoğraf aç ve hikayesini sor. O anlatmazsa 2 shot, sen seçemezsen 3 shot at.",
        type: TaskType.single,
        level: 3),
    
    TaskItem(
        text: "Telefonundaki son 3 WhatsApp/SMS mesajını kimden geldiğiyle birlikte yüksek sesle oku. Okumazsan 3 shot at.",
        type: TaskType.single,
        level: 3),
    TaskItem(
        text: "Herkes kadehini doldursun! Sağındaki oyuncu senin adına bir itirafta bulunsun, eğer doğruysa içkini fondip yap!",
        type: TaskType.group,
        level: 3),
    TaskItem(
        text: "Telefonunun arama motoruna gir ve son aradığın  10 şeyi yüksek sesle oku. Okumazsan 1 shot at.",
        type: TaskType.single,
        level: 3), 
    TaskItem(
        text: "Masadaki birine, daha önce arkasından söylediğin veya düşündüğün ama yüzüne söyleyemediğin bir şeyi söyle. Cesaret edemezsen 3 shot at",
        type: TaskType.single, 
        level: 3),
  

    TaskItem(text: "KADAKALTI: Masadaki herkes 2 shot içer, sen hariç!", type: TaskType.joker, level: 4),
    TaskItem(text: "DİKTATÖR!!: İstediğin oyuncuya istediğin cezayı verebilrsin.Yapamazsa 2 shot atar o oyuncu!", type: TaskType.joker, level: 4),
    TaskItem(text: "DOĞRULUK!!:Diğer oyuncular sana ahlaksız,özel bir soru sorar,cevapyalamazsan 2 shot iç", type: TaskType.joker, level: 4),
        
  ];
  static TaskItem getRandomTaskByLevel(int level) {

    final List<TaskItem> tasks = allTasks.where((t) => t.level == level).toList();

    if (tasks.isEmpty){
     return allTasks[Random().nextInt(allTasks.length)];
    }

    return tasks[Random().nextInt(tasks.length)];
  }

  
// Level 4 olarak işaretliyoruz ki normal level döngüsüne girmesin, 
// sadece özel %10 şansla çekilsin.
}