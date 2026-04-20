import 'models/task_item.dart';
import 'dart:math'; // Rastgele seçim için

class TaskRepository {
  static final List<TaskItem> allTasks = [
    // ==========================================
    // SEVİYE 1: ISINMA (Eğlence, Merak ve Hafif İtiraflar)
    // ==========================================
    TaskItem(
        text: "Daha önce kimsenin bilmediği garip bir yeteneğini göster. Yapamazsan 1 shot at.",
        type: TaskType.single,
        level: 1),
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
        text: "Sağındaki oyuncunun en belirgin huyunun taklidini yap. Grup beğenmezse 1 shot at.",
        type: TaskType.single,
        level: 1),
    TaskItem(
        text: "İlkokul yıllarına dair komik veya utanç verici bir anını anlat. Anlatmazsan 1 shot at.",
        type: TaskType.single,
        level: 1),
    TaskItem(
        text: "Solundaki oyuncuyla 1 dakika boyunca sadece fısıldayarak konuş. Kuralı bozarsan 1 shot at.",
        type: TaskType.single,
        level: 1),
    TaskItem(
        text: "Bir fıkra veya espri anlat, masadan kimse gülmezse 1 shot at.",
        type: TaskType.single,
        level: 1),
    TaskItem(
        text: "Burnunla masaya vurarak bir şarkı ritmi tut, kimse bilemezse 1 shot at.",
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
        text: "Herkes sana 1 kelime söylesin. 10 saniyede mini hikaye kur. Kuramazsan 1 shot at.",
        type: TaskType.single,
        level: 1),
    TaskItem(
        text: "Sağındaki kişi senin ses tonunu taklit etsin. Sen de onunkiyle konuş. Gülersen 1 shot at.",
        type: TaskType.single,
        level: 1),
    TaskItem(
        text: "Sana bir harf verilecek. 10 saniyede o harfle başlayan 3 ülke söyle. Yapamazsan 1 shot at.",
        type: TaskType.single,
        level: 1),
    // --- YENİ EKLENEN SEVİYE 1 GÖREVLERİ ---
    TaskItem(
        text: "Herkes 1 shot içer.",
        type: TaskType.group,
        level: 1),
    TaskItem(
        text: "Sağındaki içer.",
        type: TaskType.single,
        level: 1),
    TaskItem(
        text: "15 saniye plank yap. Yapamazsan 1 shot iç.",
        type: TaskType.single,
        level: 1),
    TaskItem(
        text: "25 squat yap. Tam yapmazsan 1 shot iç.",
        type: TaskType.single,
        level: 1),
    TaskItem(
        text: "10 saniye boyunca hiç göz kırpma. Kırparsan 1 shot iç.",
        type: TaskType.single,
        level: 1),

    // ==========================================
    // SEVİYE 2: ORTA ZORLUK (Utanç, Grup Dinamiği ve Hareket)
    // ==========================================
    TaskItem(
        text: "Utanç verici bir anını tüm çıplaklığıyla anlat. Çekinirsen 2 shot at.",
        type: TaskType.single,
        level: 2),
    TaskItem(
        text: "Kendin hakkında kimsenin bilmediği karanlık bir sır söyle. Söylemezsen 2 shot at.",
        type: TaskType.single,
        level: 2),
    TaskItem(
        text: "Tüm oyuncular şınav çeksin! En az çeken 1 shot atar.",
        type: TaskType.group,
        level: 2),
    TaskItem(
        text: "Grup içindeki birinin dedikodusunu herkesle açıkça paylaş. Yapmazsan 2 shot at.",
        type: TaskType.single,
        level: 2),
    TaskItem(
        text: "Masadan birini seç ve doğurma taklidi yap, seçtiğin kişi de ebe olsun! Oynamazsanız ikiniz de 1'er shot atın.",
        type: TaskType.single,
        level: 2),
    TaskItem(
        text: "Hiçbir sebep yokken, şanssızlık eseri... Direkt 2 shot at!",
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
        text: "Masadaki herkes sana rastgele bir kelime versin, bu kelimeleri kullanarak anlamlı bir cümle kur. Kuramazsan 2 shot at.",
        type: TaskType.single,
        level: 2),
    TaskItem(
        text: "Son 24 saat içinde yaptığın en mantıksız/saçma şeyi itiraf et. Anlatmazsan 2 shot at.",
        type: TaskType.single,
        level: 2),
    TaskItem(
        text: "Gruptan biriyle göz kırpma yarışması yap. İlk gözünü kırpan 2 shot atar.",
        type: TaskType.single,
        level: 2),
    TaskItem(
        text: "Masadaki herkesin ilk tanıştığınızda sana verdiği izlenimi tek tek itiraf et. Kaçarsan 2 shot at.",
        type: TaskType.single,
        level: 2),
    TaskItem(
        text: "30 saniye boyunca herkes sana soru sorsun. Sadece 'evet/hayır' ile cevap verebilirsin. Bozarsan 2 shot at.",
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
        text: "Herkes parmağıyla birini göstersin. En çok oy alan 2 shot içer.",
        type: TaskType.group,
        level: 2),

    // ==========================================
    // SEVİYE 3: ZORLAYICI (Krizler, Sert İtiraflar ve Cesaret)
    // ==========================================
    TaskItem(
        text: "Son ilişkini tüm detaylarıyla ve tam olarak neden bittiğini anlat. Anlatmazsan 3 shot at.",
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
        text: "Bir sandalyeye veya koltuğa çıkıp gruptan uydurma bir sebeple çok dramatik bir şekilde özür dile. Grup ikna olmazsa 3 shot at.",
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
  ];
  static TaskItem getRandomTaskByLevel(int level) {
    final filteredTasks = allTasks.where((task) => task.level == level).toList();
    return filteredTasks[Random().nextInt(filteredTasks.length)];
  }
}