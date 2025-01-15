import 'dart:io';

import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mhw_quest_book/module/ancient-forest-quest/model/AFmodel.dart';
import 'package:path_provider/path_provider.dart';

class Afcontroller extends GetxController {
  RxList<MonsterModel> AncientForest = <MonsterModel>[].obs;
  Rx<MonsterModel>? Monster = MonsterModel(
      dialogHuntingPhase: [],
      monsterId: 0,
      monsterName: "",
      questDialogs: [],
      quests: [],
      thumbnail: "",
      special_attack_card: []).obs;
  RxInt monster_select = 0.obs;
  RxInt quest_select_starting_point = 0.obs;
  RxList<String> Scoutfly_level = <String>[].obs;
  RxInt quest_select = 0.obs;

  RxBool isShowConsequences = true.obs;

  Rx<DialogModel> dialog_select = DialogModel(
          actions: [], consequences: "", dialogId: 0, title: "", subtitle: "")
      .obs;

  Future<void> loadMonstersData() async {
    // โหลดไฟล์ JSON จาก asset
    String jsonString =
        await rootBundle.loadString('assets/files/ancient-quest-book.json');

    // แปลง JSON string เป็น List<Map<String, dynamic>>
    List<dynamic> jsonList = jsonDecode(jsonString);

    // แปลง List<Map<String, dynamic>> เป็น List<Monster>
    AncientForest.value =
        jsonList.map((json) => MonsterModel.fromJson(json)).toList();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print(path.toString());
    return File('$path/hunter-save5.json');
  }

  Future<File> writeHunterData(String jsonString) async {
    final file = await _localFile;
    // เขียนข้อมูล JSON ไปยังไฟล์
    return file.writeAsString(jsonString);
  }

  Future<String> readHunterData() async {
    try {
      final file = await _localFile;
      // ตรวจสอบว่าไฟล์มีอยู่หรือไม่
      if (await file.exists()) {
        return await file.readAsString();
      } else {
        // หากไฟล์ไม่มีอยู่ สร้างไฟล์ใหม่พร้อมข้อมูลเริ่มต้น
        String defaultData = jsonEncode({"attempted_quest": []});
        await file.writeAsString(defaultData);
        return defaultData; // ส่งคืนข้อมูลเริ่มต้น
      }
    } catch (e) {
      // หากเกิดข้อผิดพลาด ส่งคืนข้อมูลเริ่มต้นเช่นกัน
      return jsonEncode({"attempted_quest": []});
    }
  }

  Rx<HunterDataModel> hunterData = HunterDataModel(attemptedQuest: []).obs;

  Future<void> loadHunterData() async {
    // อ่านไฟล์ JSON จากไดเรกทอรีที่สามารถเขียนได้
    String jsonString = await readHunterData();

    // แปลง JSON ที่อ่านได้เป็น HunterDataModel และเก็บใน Rx
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    hunterData.value = HunterDataModel.fromJson(jsonMap);
    print(monster_select.value);
    for (var attemp in hunterData.value.attemptedQuest) {
      print(
          "{\nMosnterID ${attemp.monsterId}\nQuestID ${attemp.questId}\nAttempted ${attemp.attempted}\n}");
    }
  }

  Future<void> updateAttemptedQuest(
      int monsterId, int questId, int newAttempt) async {
    if (hunterData.value == null || hunterData.value.attemptedQuest.isEmpty) {
      await loadHunterData(); // โหลดข้อมูลถ้ายังไม่ถูกโหลด
    }

    bool questFound = false; // ตัวแปรสำหรับตรวจสอบว่าเจอเควสหรือไม่

    // หาเควสที่ตรงกับ monsterId และ questId
    for (var quest in hunterData.value.attemptedQuest) {
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
      hunterData.value.attemptedQuest.add(AttemptedQuestModel(
        monsterId: monsterId,
        questId: questId,
        attempted: [newAttempt], // เพิ่ม newAttempt เป็นค่าตัวแรก
      ));
    }

    // อัปเดตข้อมูลใน Rx
    hunterData.refresh();

    // บันทึกข้อมูลที่ถูกอัปเดตกลับไปที่ไฟล์
    await saveHunterData();
  }

  Future<void> resetAttemptedQuest(int monsterId, int questId) async {
    // ตรวจสอบ hunterData ว่ามีข้อมูลหรือยัง
    if (hunterData.value == null || hunterData.value.attemptedQuest.isEmpty) {
      await loadHunterData(); // โหลดข้อมูลถ้ายังไม่ถูกโหลด
    }

    bool questFound = false; // ตัวแปรสำหรับตรวจสอบว่าเจอเควสหรือไม่

    // หาเควสที่ตรงกับ monsterId และ questId
    for (var quest in hunterData.value.attemptedQuest) {
      if (quest.monsterId == monsterId && quest.questId == questId) {
        // รีเซ็ตข้อมูล attempted ให้เป็นลิสต์ว่าง
        quest.attempted.clear();
        questFound = true; // กำหนดว่าเจอเควสแล้ว
        break;
      }
    }

    // ถ้าไม่เจอเควสที่ตรงกับ monsterId และ questId ให้เพิ่มข้อมูลใหม่ที่มี attempted เป็นลิสต์ว่าง
    if (!questFound) {
      hunterData.value.attemptedQuest.add(AttemptedQuestModel(
        monsterId: monsterId,
        questId: questId,
        attempted: [], // รีเซ็ต attempted ให้เป็นลิสต์ว่าง
      ));
    }

    // อัปเดตข้อมูลใน Rx
    hunterData.refresh();

    // บันทึกข้อมูลที่ถูกอัปเดตกลับไปที่ไฟล์
    await saveHunterData();
  }

  Future<void> saveHunterData() async {
    // แปลง HunterData ที่เป็น Model เป็น JSON string
    String jsonString = jsonEncode(hunterData.value.toJson());

    // เขียนข้อมูล JSON ไปยังไฟล์
    await writeHunterData(jsonString);
  }

  List<QuestModel> getQuestData(int monsterIndex) {
    return AncientForest[monsterIndex].quests;
  }

  void getMonsterById(int monsterId) {
    Monster?.value =
        AncientForest.firstWhere((monster) => monster.monsterId == monsterId);
  }

  void getDialogById(int dialogId, int monsterId) {
    dialog_select.value =
        AncientForest.firstWhere((monster) => monster.monsterId == monsterId)
            .questDialogs
            .firstWhere((dialog) => dialog.dialogId == dialogId);
  }
}
