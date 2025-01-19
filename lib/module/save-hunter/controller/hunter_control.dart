import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import 'package:mhw_quest_book/module/save-hunter/model/hunter_model.dart';

class HunterControl extends GetxController {
  var accounts = <HunterDataModel>[].obs;
  late File jsonFile;
  String fileName = 'hunter-save.json';

  var hunterData = Rxn<HunterDataModel>();

  // @override
  // void onInit() {
  //   super.onInit();
  //   loadAccounts();
  // }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  Future<File> writeHunterData(String jsonString) async {
    final file = await _localFile;
    // เขียนข้อมูล JSON ไปยังไฟล์
    return file.writeAsString(jsonString);
  }

  Future<void> loadAccounts() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    jsonFile = File('${appDocDir.path}/$fileName');

    if (jsonFile.existsSync()) {
      String jsonData = jsonFile.readAsStringSync();

      // ตรวจสอบว่าไฟล์ว่างเปล่าหรือไม่
      if (jsonData.isNotEmpty) {
        try {
          List<dynamic> data = jsonDecode(jsonData);
          accounts.value =
              data.map((json) => HunterDataModel.fromJson(json)).toList();
        } catch (e) {
          print("Error decoding JSON: $e");
          // หากมีปัญหาในการอ่าน JSON ให้สร้างค่าเริ่มต้น
          //accounts.value = [];
        }
      } else {
        // ถ้าไฟล์ว่างเปล่า ให้สร้าง accounts เป็นลิสต์ว่าง
        accounts.value = [];
      }
    } else {
      // Create file if it does not exist
      jsonFile.createSync();
      accounts.value = [];
    }
  }

  Future<void> updateAttemptedQuest(
      int monsterId, int questId, int newAttempt) async {
    bool questFound = false; // ตัวแปรสำหรับตรวจสอบว่าเจอเควสหรือไม่

    // หาเควสที่ตรงกับ monsterId และ questId
    for (var quest in hunterData.value!.attemptedQuest) {
      if (quest.monsterId == monsterId && quest.questId == questId) {
        // ตรวจสอบว่า newAttempt ไม่ซ้ำกับข้อมูลเดิมใน attempted หรือไม่
        if (!quest.attempted.contains(newAttempt)) {
          // อัปเดตข้อมูลใน attempted
          quest.attempted.add(newAttempt);
        }
        questFound = true; // กำหนดว่าเจอเควสแล้ว
        break;
      }
    }

    // ถ้าไม่เจอเควสที่ตรงกับ monsterId และ questId ให้เพิ่มข้อมูลใหม่
    if (!questFound) {
      hunterData.value!.attemptedQuest.add(AttemptedQuestModel(
        monsterId: monsterId,
        questId: questId,
        attempted: [newAttempt], // เพิ่ม newAttempt เป็นค่าตัวแรก
      ));
    }

    // อัปเดตข้อมูลใน Rx
    hunterData.refresh();

    // บันทึกข้อมูลไปยังไฟล์ JSON
    await saveAccountData();
  }

// ฟังก์ชันบันทึกข้อมูลลงไฟล์ hunter-save50.json
  Future<void> saveAccountData() async {
    try {
      // อัปเดต accounts List ที่ตรงกับบัญชีที่ถูกเลือก
      int index = accounts.indexWhere(
          (account) => account.hunter_id == hunterData.value!.hunter_id);
      if (index != -1) {
        accounts[index] = hunterData.value!;
      }

      // แปลง accounts เป็น JSON
      List<Map<String, dynamic>> jsonData =
          accounts.map((account) => account.toJson()).toList();

      // เขียนข้อมูล JSON ลงไฟล์
      await jsonFile.writeAsString(jsonEncode(jsonData));

      print("Data saved successfully.");
    } catch (e) {
      print("Error saving data: $e");
    }
  }

  Future<void> resetAttemptedQuest(int monsterId, int questId) async {
    bool questFound = false; // ตัวแปรสำหรับตรวจสอบว่าเจอเควสหรือไม่

    // หาเควสที่ตรงกับ monsterId และ questId
    for (var quest in hunterData.value!.attemptedQuest) {
      if (quest.monsterId == monsterId && quest.questId == questId) {
        // รีเซ็ตข้อมูล attempted ให้เป็นลิสต์ว่าง
        quest.attempted.clear();
        questFound = true; // กำหนดว่าเจอเควสแล้ว
        break;
      }
    }

    // ถ้าไม่เจอเควสที่ตรงกับ monsterId และ questId ให้เพิ่มข้อมูลใหม่ที่มี attempted เป็นลิสต์ว่าง
    if (!questFound) {
      hunterData.value!.attemptedQuest.add(AttemptedQuestModel(
        monsterId: monsterId,
        questId: questId,
        attempted: [], // รีเซ็ต attempted ให้เป็นลิสต์ว่าง
      ));
    }

    // อัปเดตข้อมูลใน Rx
    hunterData.refresh();

    await saveAccountData();
  }

  Future<void> saveHunterData(HunterDataModel data) async {
    accounts.add(data);
    String jsonString = jsonEncode(accounts.map((e) => e.toJson()).toList());
    jsonFile.writeAsStringSync(jsonString);
  }

  void createNewAccount(String name) {
    // สร้าง HunterDataModel ใหม่
    HunterDataModel newAccount = HunterDataModel(
      hunter_id: accounts.length + 1,
      hunter_name: name,
      campaign_day: 0.obs,
      potions: 0.obs,
      attemptedQuest: [],
      inventory: [],
    );
    saveHunterData(newAccount);
  }

  // ฟังก์ชันเลือก HunterDataModel
  void selectHunter(HunterDataModel hunter) {
    hunterData.value = hunter; // เก็บบัญชีที่เลือกไว้ในตัวแปร selectedHunter
  }

  void PrintSelectedHunter() {
    if (hunterData.value != null) {
      print(
          "Hunter ID: ${hunterData.value!.hunter_id}\nName: ${hunterData.value!.hunter_name}\nDay: ${hunterData.value!.campaign_day}");
    } else {
      print("No Hunter selected.");
    }
  }

  // ฟังก์ชันสำหรับลบบัญชี Hunter
  void deleteAccount(int hunterId) async {
    // หา index ของบัญชีที่ตรงกับ hunterId ที่ต้องการลบ
    int index = accounts.indexWhere((account) => account.hunter_id == hunterId);

    if (index != -1) {
      // ถ้าพบ account ที่ตรงกับ hunterId ให้ลบออกจาก accounts
      accounts.removeAt(index);

      // อัปเดตไฟล์ JSON หลังจากลบข้อมูล
      await saveAccountData();

      print("Account with hunter_id $hunterId has been deleted.");
    } else {
      print("No account found with hunter_id $hunterId.");
    }
  }
}
