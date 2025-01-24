import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import 'package:mhw_quest_book/module/save-hunter/model/hunter_model.dart';
import 'package:mhw_quest_book/module/save-hunter/controller/crafting_control.dart';
import 'package:mhw_quest_book/module/save-hunter/model/equiment_model.dart';

class HunterControl extends GetxController {
  var accounts = <HunterDataModel>[].obs;
  late File jsonFile;
  String fileName = 'hunter-save.json';

  //CraftingControl craftingControl = Get.put(CraftingControl());

  var hunterData = Rxn<HunterDataModel>();

  RxList<HunterClassModel> hunterClassesList = <HunterClassModel>[].obs;

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
    await loadHunterClass();
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

  Future<void> loadHunterClass() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/files/class_hunter.json');

      if (jsonString.isNotEmpty) {
        // แปลง JSON string เป็น List<Map<String, dynamic>>
        List<dynamic> jsonList = jsonDecode(jsonString);

        hunterClassesList.value =
            jsonList.map((json) => HunterClassModel.fromJson(json)).toList();
        print(hunterClassesList[3].hunter_class_name);
      }
    } catch (e) {
      print("Error decoding JSON: $e");
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

  void SetStartingClass(int classId) async {
    if (hunterData.value!.equipment.invWeapon.isEmpty &&
        hunterData.value!.equipment.invArmor.isEmpty &&
        hunterData.value!.Equipped_Weapon.value.weapon_type_id == 0 &&
        hunterData.value!.Equipped_Helm.value.equip_set_id == 0 &&
        hunterData.value!.Equipped_Mail.value.equip_set_id == 0 &&
        hunterData.value!.Equipped_Gauntlets.value.equip_set_id == 0) {
      InvWeaponModel Weapon =
          InvWeaponModel(weapon_type_id: 0.obs, item_id: 0.obs);
      InvArmorModel Helm = InvArmorModel(equip_set_id: 0, equip_id: 0);
      InvArmorModel Mail = InvArmorModel(equip_set_id: 0, equip_id: 0);
      InvArmorModel Gauntlets = InvArmorModel(equip_set_id: 0, equip_id: 0);

      if (classId == 1) {
        Weapon = InvWeaponModel(weapon_type_id: 1.obs, item_id: 1.obs);
        Helm = InvArmorModel(equip_set_id: 1, equip_id: 1);
        Mail = InvArmorModel(equip_set_id: 1, equip_id: 2);
        Gauntlets = InvArmorModel(equip_set_id: 1, equip_id: 3);
      } else if (classId == 2) {
        Weapon = InvWeaponModel(weapon_type_id: 1.obs, item_id: 1.obs);
        Helm = InvArmorModel(equip_set_id: 1, equip_id: 1);
        Mail = InvArmorModel(equip_set_id: 1, equip_id: 2);
        Gauntlets = InvArmorModel(equip_set_id: 1, equip_id: 3);
      } else if (classId == 3) {
        Weapon = InvWeaponModel(weapon_type_id: 1.obs, item_id: 1.obs);
        Helm = InvArmorModel(equip_set_id: 2, equip_id: 1);
        Mail = InvArmorModel(equip_set_id: 2, equip_id: 2);
        Gauntlets = InvArmorModel(equip_set_id: 2, equip_id: 3);
      } else if (classId == 4) {
        Weapon = InvWeaponModel(weapon_type_id: 1.obs, item_id: 1.obs);
        Helm = InvArmorModel(equip_set_id: 2, equip_id: 1);
        Mail = InvArmorModel(equip_set_id: 2, equip_id: 2);
        Gauntlets = InvArmorModel(equip_set_id: 2, equip_id: 3);
      } else if (classId == 5) {
        Weapon = InvWeaponModel(weapon_type_id: 1.obs, item_id: 1.obs);
        Helm = InvArmorModel(equip_set_id: 2, equip_id: 1);
        Mail = InvArmorModel(equip_set_id: 2, equip_id: 2);
        Gauntlets = InvArmorModel(equip_set_id: 2, equip_id: 3);
      }

      hunterData.value!.equipment.invWeapon.add(Weapon);
      hunterData.value!.equipment.invArmor.add(Helm);
      hunterData.value!.equipment.invArmor.add(Mail);
      hunterData.value!.equipment.invArmor.add(Gauntlets);

      hunterData.value!.Equipped_Weapon.value.weapon_type_id.value =
          Weapon.weapon_type_id.value;
      hunterData.value!.Equipped_Weapon.value.item_id.value =
          Weapon.item_id.value;
      hunterData.value!.Equipped_Helm.value.equip_set_id = Helm.equip_set_id;
      hunterData.value!.Equipped_Helm.value.equip_id = Helm.equip_id;
      hunterData.value!.Equipped_Mail.value.equip_set_id = Mail.equip_set_id;
      hunterData.value!.Equipped_Mail.value.equip_id = Mail.equip_id;
      hunterData.value!.Equipped_Gauntlets.value.equip_set_id =
          Gauntlets.equip_set_id;
      hunterData.value!.Equipped_Gauntlets.value.equip_id = Gauntlets.equip_id;

      hunterData.refresh();
      await saveAccountData();
    }
  }

  void createNewAccount(String name, int classId) {
    HunterDataModel newAccount = HunterDataModel(
        hunter_id: accounts.length + 1,
        hunter_name: name,
        hunter_class_id: classId,
        campaign_day: 0.obs,
        potions: 0.obs,
        attemptedQuest: [],
        inventory: [],
        equipment: EquipmentModel(
          invWeapon: [],
          invArmor: [],
        ),
        Equipped_Weapon:
            InvWeaponModel(weapon_type_id: 0.obs, item_id: 0.obs).obs,
        Equipped_Helm: InvArmorModel(equip_set_id: 0, equip_id: 0).obs,
        Equipped_Mail: InvArmorModel(equip_set_id: 0, equip_id: 0).obs,
        Equipped_Gauntlets: InvArmorModel(equip_set_id: 0, equip_id: 0).obs);

    print(newAccount.Equipped_Weapon.value.weapon_type_id);

    saveHunterData(newAccount);
  }

  // ฟังก์ชันเลือก HunterDataModel
  void selectHunter(HunterDataModel hunter) {
    hunterData.value = hunter; // เก็บบัญชีที่เลือกไว้ในตัวแปร selectedHunter
    //print(hunterData.value!.equipment.invWeapon[0].weapon_type_id);
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
