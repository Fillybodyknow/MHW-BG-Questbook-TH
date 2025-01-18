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

  Future<void> loadMonstersAncientForestData() async {
    // โหลดไฟล์ JSON จาก asset
    String jsonString =
        await rootBundle.loadString('assets/files/ancient-quest-book.json');

    // แปลง JSON string เป็น List<Map<String, dynamic>>
    List<dynamic> jsonList = jsonDecode(jsonString);

    // แปลง List<Map<String, dynamic>> เป็น List<Monster>
    AncientForest.value =
        jsonList.map((json) => MonsterModel.fromJson(json)).toList();
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
