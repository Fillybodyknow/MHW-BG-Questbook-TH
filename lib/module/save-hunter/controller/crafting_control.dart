import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:mhw_quest_book/module/save-hunter/model/equiment_model.dart';
import 'package:mhw_quest_book/module/save-hunter/model/hunter_model.dart';
import 'package:mhw_quest_book/module/save-hunter/model/utility_model.dart';
import 'package:mhw_quest_book/module/save-hunter/controller/resource_control.dart';
import 'package:mhw_quest_book/module/save-hunter/controller/hunter_control.dart';
import 'package:mhw_quest_book/utility/fonts/fonts.dart';
import 'package:mhw_quest_book/utility/fonts/text_style.dart';
import 'package:mhw_quest_book/utility/icons.dart';

import 'package:mhw_quest_book/module/save-hunter/model/resource_model.dart';

class CraftingControl extends GetxController {
  ResourceControl resourceControl = Get.put(ResourceControl());
  HunterControl hunterControl = Get.put(HunterControl());

  RxList<armorSetModel> armorSetList = RxList([]);

  RxList<WeaponsList> weaponsSetList = RxList([]);

  RxList<elementalModel> elementalList = RxList([]);
  RxList<StatusEffectModel> statusEffectList = RxList([]);
  RxList<bonusAbilityModel> bonusAbilityList = RxList([]);
  //RxList<CraftingTableModel> craftingTableList = RxList([]);
  RxList<CraftListModel> craftList = RxList([]);
  RxList<CraftWeaponModel> craftWeaponList = RxList([]);

  RxList<WeaponPriorityModel> weaponPriorityList = RxList([]);

  //RxInt typeID = 1.obs;

  Future<void> loadWeaponsSetData() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/files/weapons.json');

      if (jsonString.isNotEmpty) {
        List<dynamic> jsonList = jsonDecode(jsonString);

        List<dynamic> weapons_list = jsonList.firstWhere((e) =>
            e['hunter_class_id'] ==
            hunterControl.hunterData.value!.hunter_class_id)['weapons_list'];

        List<dynamic> weapons_priority = jsonList.firstWhere((e) =>
            e['hunter_class_id'] ==
            hunterControl
                .hunterData.value!.hunter_class_id)['weapon_priority_set'];

        weaponsSetList.value =
            weapons_list.map((json) => WeaponsList.fromJson(json)).toList();

        weaponPriorityList.value = weapons_priority
            .map((json) => WeaponPriorityModel.fromJson(json))
            .toList();
      } else {
        print("loadWeaponsSetData JSON string is empty.");
      }
      return;
    } catch (e) {
      print("loadWeaponsSetData : ${e}");
    }
  }

  Future<void> loadArmorSetData() async {
    // โหลดไฟล์ JSON จาก asset
    String jsonString = await rootBundle.loadString('assets/files/armors.json');

    if (jsonString.isNotEmpty) {
      // แปลง JSON string เป็น List<Map<String, dynamic>>
      List<dynamic> jsonList = jsonDecode(jsonString);
      // แปลง List<Map<String, dynamic>> เป็น List<Monster>
      armorSetList.value =
          jsonList.map((json) => armorSetModel.fromJson(json)).toList();
      //print(armorSetList[0].equip_set);
    } else {
      print("loadArmorSetData JSON string is empty.");
    }
    return;
  }

  Future<void> loadElementalData() async {
    // โหลดไฟล์ JSON จาก asset
    String jsonString =
        await rootBundle.loadString('assets/files/elemental.json');

    if (jsonString.isNotEmpty) {
      // แปลง JSON string เป็น List<Map<String, dynamic>>
      List<dynamic> jsonList = jsonDecode(jsonString);
      // แปลง List<Map<String, dynamic>> เป็น List<Monster>
      elementalList.value =
          jsonList.map((json) => elementalModel.fromJson(json)).toList();
    } else {
      print("loadElementalData JSON string is empty.");
    }
    return;
  }

  Future<void> loadStatusEffectData() async {
    // โหลดไฟล์ JSON จาก asset
    String jsonString =
        await rootBundle.loadString('assets/files/status_effect.json');

    if (jsonString.isNotEmpty) {
      // แปลง JSON string เป็น List<Map<String, dynamic>>
      List<dynamic> jsonList = jsonDecode(jsonString);
      // แปลง List<Map<String, dynamic>> เป็น List<Monster>
      statusEffectList.value =
          jsonList.map((json) => StatusEffectModel.fromJson(json)).toList();
    } else {
      print("loadStatusEffectData JSON string is empty.");
    }
    return;
  }

  Future<void> loadBonusAbilityData() async {
    // โหลดไฟล์ JSON จาก asset
    String jsonString =
        await rootBundle.loadString('assets/files/bonus_ability.json');

    if (jsonString.isNotEmpty) {
      // แปลง JSON string เป็น List<Map<String, dynamic>>
      List<dynamic> jsonList = jsonDecode(jsonString);
      // แปลง List<Map<String, dynamic>> เป็น List<Monster>
      bonusAbilityList.value =
          jsonList.map((json) => bonusAbilityModel.fromJson(json)).toList();
    } else {
      print("loadBonusAbility JSON string is empty.");
    }
    return;
  }

  Future<void> loadCraftingTableData() async {
    // โหลดไฟล์ JSON จาก asset
    try {
      craftList.clear();
      String jsonString =
          await rootBundle.loadString('assets/files/crafting_item.json');

      if (jsonString.isNotEmpty) {
        // แปลง JSON string เป็น List<Map<String, dynamic>>
        List<dynamic> json_List = jsonDecode(jsonString);

        // ค้นหา type_id
        Map<String, dynamic>? Armors = json_List.firstWhere(
            (element) => element['type_id'] == 1,
            orElse: () => null); // เพิ่ม orElse เพื่อป้องกัน null

        Map<String, dynamic>? Weapons = json_List.firstWhere(
            (element) => element['type_id'] == 2,
            orElse: () => null);

        if (Armors != null) {
          List<dynamic> CraftList = Armors['craft_list'];
          craftList.value =
              CraftList.map((json) => CraftListModel.fromJson(json)).toList();
        } else {
          print("No matching Armors found.");
        }
        if (Weapons != null) {
          List<dynamic> CraftList = Weapons['craft_list'];
          List<dynamic> WeaponsList_craft = CraftList.firstWhere((e) =>
              e['hunter_class_id'] ==
              hunterControl
                  .hunterData.value!.hunter_class_id)['weapon_craft_list'];
          craftWeaponList.value =
              WeaponsList_craft.map((json) => CraftWeaponModel.fromJson(json))
                  .toList();
        } else {
          print("No matching Weapons found.");
        }
      } else {
        print("No matching type_id found.");
      }
    } catch (e) {
      print(e);
    }
    return;
  }

  Future<void> loadAllData() async {
    await loadArmorSetData();
    await loadWeaponsSetData();
    await loadElementalData();
    await loadStatusEffectData();
    await loadBonusAbilityData();
    await loadCraftingTableData();
    hunterControl.SetStartingClass(
        hunterControl.hunterData.value!.hunter_class_id);

    //print(craftingTableList[0].material);
  }

  int GetArmor() {
    int ArmorHelm = armorSetList
        .firstWhere((e) =>
            e.equip_set_id ==
            hunterControl.hunterData.value!.Equipped_Helm.value.equip_set_id)
        .equips
        .firstWhere((e) =>
            e.equip_id ==
            hunterControl.hunterData.value!.Equipped_Helm.value.equip_id)
        .physical_armor;
    int ArmorMail = armorSetList
        .firstWhere((e) =>
            e.equip_set_id ==
            hunterControl.hunterData.value!.Equipped_Mail.value.equip_set_id)
        .equips
        .firstWhere((e) =>
            e.equip_id ==
            hunterControl.hunterData.value!.Equipped_Mail.value.equip_id)
        .physical_armor;
    int ArmorGauntlets = armorSetList
        .firstWhere((e) =>
            e.equip_set_id ==
            hunterControl
                .hunterData.value!.Equipped_Gauntlets.value.equip_set_id)
        .equips
        .firstWhere((e) =>
            e.equip_id ==
            hunterControl.hunterData.value!.Equipped_Gauntlets.value.equip_id)
        .physical_armor;

    int WeaponArmor = weaponsSetList.value
        .firstWhere((e) =>
            e.weaponTypeId ==
            hunterControl
                .hunterData.value!.Equipped_Weapon.value.weapon_type_id.value)
        .items
        .firstWhere((e) =>
            e.itemId ==
            hunterControl.hunterData.value!.Equipped_Weapon.value.item_id.value)
        .defense;

    return ArmorMail + ArmorHelm + ArmorGauntlets + WeaponArmor;
  }

  List<Map<String, int>> GetElementArmor() {
    List<Map<String, int>> ElementArmor = [];

    void addOrUpdateArmor(Map<String, int> newArmor) {
      int index = ElementArmor.indexWhere(
          (element) => element['element_id'] == newArmor['element_id']);
      if (index != -1) {
        // ถ้าเจอ element_id ซ้ำ ให้เพิ่ม protection
        ElementArmor[index]['protection'] =
            ElementArmor[index]['protection']! + newArmor['protection']!;
      } else {
        // ถ้าไม่เจอ element_id ซ้ำ ให้เพิ่มเข้าไปใหม่
        ElementArmor.add(newArmor);
      }
    }

    if (armorSetList
            .firstWhere((e) =>
                e.equip_set_id ==
                hunterControl
                    .hunterData.value!.Equipped_Helm.value.equip_set_id)
            .equips
            .firstWhere((e) =>
                e.equip_id ==
                hunterControl.hunterData.value!.Equipped_Helm.value.equip_id)
            .elemental_armor!['elemental_id'] !=
        0) {
      Map<String, int> ArmorHelmElement = {
        "element_id": armorSetList
            .firstWhere((e) =>
                e.equip_set_id ==
                hunterControl
                    .hunterData.value!.Equipped_Helm.value.equip_set_id)
            .equips
            .firstWhere((e) =>
                e.equip_id ==
                hunterControl.hunterData.value!.Equipped_Helm.value.equip_id)
            .elemental_armor!['elemental_id'],
        "protection": armorSetList
            .firstWhere((e) =>
                e.equip_set_id ==
                hunterControl
                    .hunterData.value!.Equipped_Helm.value.equip_set_id)
            .equips
            .firstWhere((e) =>
                e.equip_id ==
                hunterControl.hunterData.value!.Equipped_Helm.value.equip_id)
            .elemental_armor!['protection']
      };

      addOrUpdateArmor(ArmorHelmElement);
    }

    if (armorSetList
            .firstWhere((e) =>
                e.equip_set_id ==
                hunterControl
                    .hunterData.value!.Equipped_Mail.value.equip_set_id)
            .equips
            .firstWhere((e) =>
                e.equip_id ==
                hunterControl.hunterData.value!.Equipped_Mail.value.equip_id)
            .elemental_armor!['elemental_id'] !=
        0) {
      Map<String, int> ArmorMailElement = {
        "element_id": armorSetList
            .firstWhere((e) =>
                e.equip_set_id ==
                hunterControl
                    .hunterData.value!.Equipped_Mail.value.equip_set_id)
            .equips
            .firstWhere((e) =>
                e.equip_id ==
                hunterControl.hunterData.value!.Equipped_Mail.value.equip_id)
            .elemental_armor!['elemental_id'],
        "protection": armorSetList
            .firstWhere((e) =>
                e.equip_set_id ==
                hunterControl
                    .hunterData.value!.Equipped_Mail.value.equip_set_id)
            .equips
            .firstWhere((e) =>
                e.equip_id ==
                hunterControl.hunterData.value!.Equipped_Mail.value.equip_id)
            .elemental_armor!['protection']
      };

      addOrUpdateArmor(ArmorMailElement);
    }

    if (armorSetList
            .firstWhere((e) =>
                e.equip_set_id ==
                hunterControl
                    .hunterData.value!.Equipped_Gauntlets.value.equip_set_id)
            .equips
            .firstWhere((e) =>
                e.equip_id ==
                hunterControl
                    .hunterData.value!.Equipped_Gauntlets.value.equip_id)
            .elemental_armor!['elemental_id'] !=
        0) {
      Map<String, int> ArmorGauntletsElement = {
        "element_id": armorSetList
            .firstWhere((e) =>
                e.equip_set_id ==
                hunterControl
                    .hunterData.value!.Equipped_Gauntlets.value.equip_set_id)
            .equips
            .firstWhere((e) =>
                e.equip_id ==
                hunterControl
                    .hunterData.value!.Equipped_Gauntlets.value.equip_id)
            .elemental_armor!['elemental_id'],
        "protection": armorSetList
            .firstWhere((e) =>
                e.equip_set_id ==
                hunterControl
                    .hunterData.value!.Equipped_Gauntlets.value.equip_set_id)
            .equips
            .firstWhere((e) =>
                e.equip_id ==
                hunterControl
                    .hunterData.value!.Equipped_Gauntlets.value.equip_id)
            .elemental_armor!['protection']
      };

      addOrUpdateArmor(ArmorGauntletsElement);
    }

    return ElementArmor;
  }

  List<bonusAbilityModel> GetBonusAbility() {
    List<bonusAbilityModel> BAList = [];
    if (bonusAbilityList.any((e) =>
        e.abilityID ==
        armorSetList
            .firstWhere((e) =>
                e.equip_set_id ==
                hunterControl
                    .hunterData.value!.Equipped_Helm.value.equip_set_id)
            .equips
            .firstWhere((e) =>
                e.equip_id ==
                hunterControl.hunterData.value!.Equipped_Helm.value.equip_id)
            .ability_id)) {
      BAList.add(bonusAbilityList.firstWhere((e) =>
          e.abilityID ==
          armorSetList
              .firstWhere((e) =>
                  e.equip_set_id ==
                  hunterControl
                      .hunterData.value!.Equipped_Helm.value.equip_set_id)
              .equips
              .firstWhere((e) =>
                  e.equip_id ==
                  hunterControl.hunterData.value!.Equipped_Helm.value.equip_id)
              .ability_id));
    }

    if (bonusAbilityList.any((e) =>
        e.abilityID ==
        armorSetList
            .firstWhere((e) =>
                e.equip_set_id ==
                hunterControl
                    .hunterData.value!.Equipped_Mail.value.equip_set_id)
            .equips
            .firstWhere((e) =>
                e.equip_id ==
                hunterControl.hunterData.value!.Equipped_Mail.value.equip_id)
            .ability_id)) {
      BAList.add(bonusAbilityList.firstWhere((e) =>
          e.abilityID ==
          armorSetList
              .firstWhere((e) =>
                  e.equip_set_id ==
                  hunterControl
                      .hunterData.value!.Equipped_Mail.value.equip_set_id)
              .equips
              .firstWhere((e) =>
                  e.equip_id ==
                  hunterControl.hunterData.value!.Equipped_Mail.value.equip_id)
              .ability_id));
    }

    if (bonusAbilityList.any((e) =>
        e.abilityID ==
        armorSetList
            .firstWhere((e) =>
                e.equip_set_id ==
                hunterControl
                    .hunterData.value!.Equipped_Gauntlets.value.equip_set_id)
            .equips
            .firstWhere((e) =>
                e.equip_id ==
                hunterControl
                    .hunterData.value!.Equipped_Gauntlets.value.equip_id)
            .ability_id)) {
      BAList.add(bonusAbilityList.firstWhere((e) =>
          e.abilityID ==
          armorSetList
              .firstWhere((e) =>
                  e.equip_set_id ==
                  hunterControl
                      .hunterData.value!.Equipped_Gauntlets.value.equip_set_id)
              .equips
              .firstWhere((e) =>
                  e.equip_id ==
                  hunterControl
                      .hunterData.value!.Equipped_Gauntlets.value.equip_id)
              .ability_id));
    }

    return BAList;
  }

  RxBool GetArmorSetAbility() {
    int equip_set_id =
        hunterControl.hunterData.value!.Equipped_Helm.value.equip_set_id;

    if (hunterControl.hunterData.value!.Equipped_Mail.value.equip_set_id ==
            equip_set_id &&
        hunterControl.hunterData.value!.Equipped_Gauntlets.value.equip_set_id ==
            equip_set_id) {
      if (bonusAbilityList.any((e) =>
          e.abilityID ==
          armorSetList
              .firstWhere((e) => e.equip_set_id == equip_set_id)
              .set_ability_bonus)) {
        return true.obs;
      } else {
        return false.obs;
      }
    } else {
      return false.obs;
    }
  }

  double GetAvarageDamage() {
    double SumOFDamage = 0;
    double NumOfDamage = 0;
    Weapon DamageWeapon = weaponsSetList
        .firstWhere((e) =>
            e.weaponTypeId ==
            hunterControl
                .hunterData.value!.Equipped_Weapon.value.weapon_type_id.value)
        .items
        .firstWhere((e) =>
            e.itemId ==
            hunterControl
                .hunterData.value!.Equipped_Weapon.value.item_id.value);
    for (var i = 0; i < DamageWeapon.damageCards.length; i++) {
      SumOFDamage = SumOFDamage + (DamageWeapon.damageCards[i] * (i + 1));
      NumOfDamage = NumOfDamage + DamageWeapon.damageCards[i];
    }

    double average = SumOFDamage / NumOfDamage;
    return double.parse(average.toStringAsFixed(2));
  }

  Widget CatagolyEquipBox(int equipSetid, BuildContext context) {
    RxBool IsShow = false.obs;
    armorSetModel SetArmor =
        armorSetList.firstWhere((item) => item.equip_set_id == equipSetid);

    RxString SetAbility = "".obs;
    RxString SetAbilityDiscription = "".obs;

    if (bonusAbilityList
        .any((item) => item.abilityID == SetArmor.set_ability_bonus)) {
      SetAbility.value = bonusAbilityList
          .firstWhere((item) => item.abilityID == SetArmor.set_ability_bonus)
          .abilityName;
      SetAbilityDiscription.value = bonusAbilityList
          .firstWhere((item) => item.abilityID == SetArmor.set_ability_bonus)
          .abilityDescription;
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() => IsShow.value ? SizedBox(height: 10) : SizedBox.shrink()),
          InkWell(
              onTap: () {
                IsShow.value = !IsShow.value;
              },
              child: Container(
                width: 75,
                height: 75,
                child: Image.asset(
                  SetArmor.thumbnail,
                  fit: BoxFit.cover,
                ),
              )),
          Obx(
            () => Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.brown.shade300,
                    border: Border.symmetric(
                        horizontal: BorderSide(
                            color: Colors.brown.shade900, width: 10))),
                child: IsShow.value
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SetArmor.set_ability_bonus != 0
                              ? Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.brown.shade300,
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.brown.shade900,
                                                  width: 3))),
                                      child: Text(
                                          "Set Bonus : ${SetAbility.value}",
                                          style: TextAppStyle
                                              .textsBodyLargeProminent(
                                            color: Colors.white,
                                          )),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: Text(SetAbilityDiscription.value,
                                          textAlign: TextAlign.center,
                                          style: TextAppStyle.textsBodySmall(
                                            color: Colors.white,
                                          )),
                                    )
                                  ],
                                )
                              : SizedBox.shrink(),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: SetArmor.equips
                                  .map((e) => Obx(() {
                                        return Opacity(
                                          opacity: CanCraft(
                                                          SetArmor.equip_set_id,
                                                          e.equip_id)
                                                      .value ||
                                                  InventoryArmorCheck(
                                                          equipSetid,
                                                          e.equip_id)
                                                      .value
                                              ? 0.8
                                              : 0.5,
                                          child: EquipBoxList(
                                              e,
                                              SetArmor.rarity,
                                              SetArmor.equip_set_id,
                                              CanCraft(SetArmor.equip_set_id,
                                                      e.equip_id)
                                                  .value),
                                        );
                                      }))
                                  .toList(),
                            ),
                          )
                        ],
                      )
                    : SizedBox.shrink()),
          ),
          Obx(() => IsShow.value
              ? SizedBox(height: 10)
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                )),
        ],
      ),
    );
  }

  Widget CatagolyWeaponBox(WeaponsList weapon, BuildContext context) {
    RxBool IsShow = false.obs;
    WeaponPriorityModel priorityModel = weaponPriorityList
        .firstWhere((e) => e.weapon_type_id == weapon.weaponTypeId);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() => IsShow.value ? SizedBox(height: 10) : SizedBox.shrink()),
          InkWell(
            onTap: () {
              IsShow.value = !IsShow.value;
            },
            child: Container(
              width: 75,
              height: 75,
              child: Image.asset(
                weapon.thumbnail,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Obx(() => Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.brown.shade300,
                    border: Border.symmetric(
                        horizontal: BorderSide(
                            color: Colors.brown.shade900, width: 10))),
                child: IsShow.value
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: priorityModel.priority
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                int index = entry.key;
                                List<dynamic> e = entry.value;
                                // print(index);
                                // print(priorityModel.priority.length);
                                return Row(
                                  children: [
                                    Obx(() => Opacity(
                                          opacity: CanCraftWeapon(e[0], e[1])
                                                      .value ||
                                                  InventoryWeaponCheck(
                                                          e[0], e[1])
                                                      .value
                                              ? 0.8
                                              : 0.5,
                                          child: WeaponBoxList(
                                              e,
                                              weapon.weaponTypeId,
                                              CanCraftWeapon(e[0], e[1]).value),
                                        )),
                                    priorityModel.priority.length > index + 1
                                        ? Icon(
                                            Icons.arrow_circle_right_outlined,
                                            color: Colors.white,
                                            size: 75,
                                          )
                                        : SizedBox.shrink()
                                  ],
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      )
                    : SizedBox.shrink(),
              )),
          Obx(() => IsShow.value
              ? SizedBox(height: 10)
              : SizedBox(width: MediaQuery.of(context).size.width)),
        ],
      ),
    );
  }

  Widget WeaponBoxList(
      List<dynamic> priority_weapon, int weapon_type_id, bool enableCraft) {
    CraftWeaponModel Crafttable_ThisItem = CraftWeaponModel(
        weapon_type_id: 0, item_id: 0, required_weapon: [], crafting_table: []);
    Weapon weapon = weaponsSetList
        .firstWhere((e) => e.weaponTypeId == priority_weapon[0])
        .items
        .firstWhere((e) => e.itemId == priority_weapon[1]);
    bool HaveCraftTable = craftWeaponList.any((e) =>
        e.item_id == priority_weapon[1] &&
        e.weapon_type_id == priority_weapon[0]);
    if (HaveCraftTable) {
      Crafttable_ThisItem = craftWeaponList.firstWhere((e) =>
          e.item_id == priority_weapon[1] &&
          e.weapon_type_id == priority_weapon[0]);
    }
    return InkWell(
      onTap: () {
        print(weapon.item);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.black87, border: Border.all(color: Colors.white)),
        width: 280,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(3),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.white)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    child: Image.asset(
                      WeaponsRarityIcons(
                              Weaponclass: hunterControl
                                  .hunterData.value!.hunter_class_id,
                              rarity: weapon.rarity)
                          .GetIcon(),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                      child: Text(
                    textAlign: TextAlign.center,
                    weapon.item,
                    maxLines: 3,
                    style: TextAppStyle.textsBodyLargeProminent(
                        color: Colors.white),
                  ))
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.all(3),
                width: double.infinity,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.white)),
                child: !InventoryWeaponCheck(
                            priority_weapon[0], priority_weapon[1])
                        .value
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:
                            Crafttable_ThisItem.crafting_table.map((CraftItem) {
                          ItemModel material = resourceControl.resourceList
                              .firstWhere(
                                  (e) => e.resourceId == CraftItem.material[0])
                              .items
                              .firstWhere(
                                  (e) => e.itemId == CraftItem.material[1]);
                          RxInt amountCurrent = 0.obs;
                          var foundItem = hunterControl
                              .hunterData.value!.inventory
                              .firstWhereOrNull(
                            (e) =>
                                e.resourceTypeId == CraftItem.material[0] &&
                                e.itemId == CraftItem.material[1],
                          );

                          if (foundItem != null) {
                            amountCurrent.value = foundItem.quantity.value;
                          } else {
                            amountCurrent.value = 0; // ถ้าไม่เจอให้ค่าเป็น 0
                          }
                          return Row(
                            //mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 10),
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 3)),
                                  child: Image.asset(
                                    material.thumbnail!,
                                    fit: BoxFit.cover,
                                  )),
                              Expanded(
                                  child: Text(
                                textAlign: TextAlign.center,
                                "${material.item} (${amountCurrent.value}/${CraftItem.amount})",
                                style: TextAppStyle.textsBodyMedium(
                                    color: Colors.white),
                              ))
                            ],
                          );
                        }).toList(),
                      )
                    : Text(
                        textAlign: TextAlign.center,
                        "In Inventory",
                        style:
                            TextAppStyle.textsBodyMedium(color: Colors.white),
                      )),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              width: double.infinity,
              height: 100,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.white)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: weapon.damageCards.asMap().entries.map((entry) {
                        int index = entry.key; // index ของ e
                        int e = entry.value; // ค่า e จริง
                        if (e > 0) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 3),
                            child: Row(
                              children: [
                                Container(
                                  width: 35,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.asset("assets/img/take_damage.png"),
                                      Text(
                                        "${index + 1}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: AppFont.Khaitun,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        "${index + 1}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: AppFont.Khaitun,
                                          fontWeight: FontWeight.w100,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Text(
                                  "x${e}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: AppFont.Khaitun,
                                    fontWeight: FontWeight.w100,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      }).toList()),
                  weapon.defense != 0
                      ? Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          width: 35,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 25,
                                child:
                                    Image.asset("assets/img/bonus_armor.png"),
                              ),
                              Text(
                                weapon.defense.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: AppFont.Khaitun,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                weapon.defense.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: AppFont.Khaitun,
                                  fontWeight: FontWeight.w100,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        )
                      : SizedBox.shrink()
                ],
              ),
            ),
            weapon.remove.isNotEmpty && weapon.add.isNotEmpty
                ? Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        width: double.infinity,
                        //height: 100,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white)),
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text(
                                      "remove: ",
                                      style: TextAppStyle.textsBodyMedium(
                                          color: Colors.white),
                                    ),
                                  ),
                                  Expanded(
                                      child: Text(
                                    weapon.remove,
                                    textAlign: TextAlign.center,
                                    style: TextAppStyle.textsBodyMedium(
                                        color: Colors.white),
                                  ))
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        width: double.infinity,
                        //height: 100,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white)),
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text(
                                      "add: ",
                                      style: TextAppStyle.textsBodyMedium(
                                          color: Colors.white),
                                    ),
                                  ),
                                  Expanded(
                                      child: Text(
                                    weapon.add,
                                    textAlign: TextAlign.center,
                                    style: TextAppStyle.textsBodyMedium(
                                        color: Colors.white),
                                  ))
                                ],
                              ),
                            )),
                          ],
                        ),
                      )
                    ],
                  )
                : SizedBox.shrink(),
            enableCraft &&
                    !InventoryWeaponCheck(
                            priority_weapon[0], priority_weapon[1])
                        .value
                ? TextButton(
                    onPressed: () {
                      CraftWeapon(priority_weapon[0], priority_weapon[1]);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.green.shade600,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black, width: 3)),
                      child: Center(
                        child: Text(
                          "CRAFT",
                          style: TextAppStyle.textsBodyLargeProminent(
                              color: Colors.white),
                        ),
                      ),
                    ))
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  Widget EquipBoxList(
      armorsModel Armor, int rarity, int equipSetid, bool enableCraft) {
    CraftListModel Crafttable_ThisItem = craftList.firstWhere(
        (e) => e.equip_id == Armor.equip_id && e.equip_set_id == equipSetid);

    return InkWell(
      onTap: () {
        print(Armor.equip);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.black87, border: Border.all(color: Colors.white)),
        width: 280,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(3),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.white)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    child: Image.asset(
                      ArmorsRarityIcons(
                              rarity: rarity, Armor_part: Armor.armor_part_id)
                          .GetIcon(),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                      child: Text(
                    textAlign: TextAlign.center,
                    Armor.equip,
                    maxLines: 3,
                    style: TextAppStyle.textsBodyLargeProminent(
                        color: Colors.white),
                  ))
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.all(3),
                width: double.infinity,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.white)),
                child: InventoryArmorCheck(equipSetid, Armor.equip_id).value
                    ? Text("In Inventory",
                        textAlign: TextAlign.center,
                        style: TextAppStyle.textsBodyLargeProminent(
                            color: Colors.white))
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:
                            Crafttable_ThisItem.crafting_table.map((CraftItem) {
                          ItemModel material = resourceControl.resourceList
                              .firstWhere(
                                  (e) => e.resourceId == CraftItem.material[0])
                              .items
                              .firstWhere(
                                  (e) => e.itemId == CraftItem.material[1]);
                          RxInt amountCurrent = 0.obs;
                          var foundItem = hunterControl
                              .hunterData.value!.inventory
                              .firstWhereOrNull(
                            (e) =>
                                e.resourceTypeId == CraftItem.material[0] &&
                                e.itemId == CraftItem.material[1],
                          );

                          if (foundItem != null) {
                            amountCurrent.value = foundItem.quantity.value;
                          } else {
                            amountCurrent.value = 0; // ถ้าไม่เจอให้ค่าเป็น 0
                          }
                          return Row(
                            //mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 10),
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 3)),
                                  child: Image.asset(
                                    material.thumbnail!,
                                    fit: BoxFit.cover,
                                  )),
                              Expanded(
                                  child: Text(
                                textAlign: TextAlign.center,
                                "${material.item} (${amountCurrent.value}/${CraftItem.amount})",
                                style: TextAppStyle.textsBodyMedium(
                                    color: Colors.white),
                              ))
                            ],
                          );
                        }).toList(),
                      )),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              width: double.infinity,
              height: 100,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.white)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    width: 60,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset("assets/img/bonus_armor.png"),
                        Text(
                          Armor.physical_armor.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 40,
                            fontFamily: AppFont.Khaitun,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          Armor.physical_armor.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 40,
                            fontFamily: AppFont.Khaitun,
                            fontWeight: FontWeight.w100,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  Armor.elemental_armor!['elemental_id'] == 0
                      ? SizedBox.shrink()
                      : Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          width: 60,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset("assets/img/bonus_armor.png"),
                              Image.asset(elementalList
                                  .firstWhere((e) =>
                                      e.elementID ==
                                      Armor.elemental_armor!['elemental_id'])
                                  .thumbnail),
                              Text(
                                textAlign: TextAlign.center,
                                Armor.elemental_armor!['protection'].toString(),
                                style: TextStyle(
                                  fontSize: 40,
                                  fontFamily: AppFont.Khaitun,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                textAlign: TextAlign.center,
                                Armor.elemental_armor!['protection'].toString(),
                                style: TextStyle(
                                  fontSize: 40,
                                  fontFamily: AppFont.Khaitun,
                                  fontWeight: FontWeight.w100,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              width: double.infinity,
              //height: 48,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.white)),
              child: Center(
                  child: Armor.ability_id == 0
                      ? SizedBox.shrink()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              "< ${bonusAbilityList.firstWhere((e) => e.abilityID == Armor.ability_id).abilityName} >",
                              style: TextAppStyle.textsBodyLargeProminent(
                                  color: Colors.white),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                textAlign: TextAlign.center,
                                bonusAbilityList
                                    .firstWhere(
                                        (e) => e.abilityID == Armor.ability_id)
                                    .abilityDescription,
                                style: TextAppStyle.textsBodySmall(
                                    color: Colors.white),
                              ),
                            )
                          ],
                        )),
            ),
            enableCraft &&
                    !InventoryArmorCheck(equipSetid, Armor.equip_id).value
                ? TextButton(
                    onPressed: () {
                      CraftArmor(equipSetid, Armor.equip_id);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.green.shade600,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black, width: 3)),
                      child: Center(
                        child: Text(
                          "CRAFT",
                          style: TextAppStyle.textsBodyLargeProminent(
                              color: Colors.white),
                        ),
                      ),
                    ))
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  RxBool CanCraft(int equipset_id, int equidid) {
    List<CraftingTableModel> Req_Craft = craftList
        .firstWhere(
            (e) => e.equip_id == equidid && e.equip_set_id == equipset_id)
        .crafting_table;
    for (var E in Req_Craft) {
      int amountCurrent = 0;
      var foundItem =
          hunterControl.hunterData.value!.inventory.firstWhereOrNull(
        (e) => e.resourceTypeId == E.material[0] && e.itemId == E.material[1],
      );

      if (foundItem != null) {
        amountCurrent = foundItem.quantity.value;
      } else {
        amountCurrent = 0;
      }

      if (amountCurrent < E.amount) {
        return false.obs;
      }
    }
    return true.obs;
  }

  RxBool InventoryArmorCheck(int equipset_id, int equidid) {
    var foundItem =
        hunterControl.hunterData.value!.equipment.invArmor.firstWhereOrNull(
      (e) => e.equip_id == equidid && e.equip_set_id == equipset_id,
    );
    if (foundItem == null) {
      return false.obs;
    } else {
      return true.obs;
    }
  }

  RxBool InventoryWeaponCheck(int weapon_type_id, int item_id) {
    var foundItem =
        hunterControl.hunterData.value!.equipment.invWeapon.firstWhereOrNull(
      (e) => e.weapon_type_id == weapon_type_id && e.item_id == item_id,
    );
    if (foundItem == null) {
      return false.obs;
    } else {
      return true.obs;
    }
  }

  RxBool CanCraftWeapon(int WeaponTypeId, int ItemID) {
    if (craftWeaponList
        .any((e) => e.weapon_type_id == WeaponTypeId && e.item_id == ItemID)) {
      List<CraftingTableModel> Req_Craft = craftWeaponList
          .firstWhere(
              (e) => e.weapon_type_id == WeaponTypeId && e.item_id == ItemID)
          .crafting_table;
      CraftWeaponModel Req_Weapon = craftWeaponList.firstWhere(
          (e) => e.weapon_type_id == WeaponTypeId && e.item_id == ItemID);
      if (Req_Weapon.required_weapon.isNotEmpty) {
        // print(
        //     "Required Weapon: [${Req_Weapon.required_weapon[0]}, ${Req_Weapon.required_weapon[1]}]");
        if (!hunterControl.hunterData.value!.equipment.invWeapon.any((e) =>
            e.weapon_type_id == Req_Weapon.required_weapon[0] &&
            e.item_id == Req_Weapon.required_weapon[1])) {
          return false.obs;
        }
      }

      for (var E in Req_Craft) {
        int amountCurrent = 0;
        var foundItem =
            hunterControl.hunterData.value!.inventory.firstWhereOrNull(
          (e) => e.resourceTypeId == E.material[0] && e.itemId == E.material[1],
        );

        if (foundItem != null) {
          amountCurrent = foundItem.quantity.value;
        } else {
          amountCurrent = 0;
        }

        if (amountCurrent < E.amount) {
          return false.obs;
        }
      }
      return true.obs;
    } else {
      return false.obs;
    }
  }

  void CraftArmor(int equipset_id, int equidid) async {
    List<CraftingTableModel> Req_Craft = craftList
        .firstWhere(
            (e) => e.equip_id == equidid && e.equip_set_id == equipset_id)
        .crafting_table;
    for (var E in Req_Craft) {
      var foundItem =
          hunterControl.hunterData.value!.inventory.firstWhereOrNull(
        (e) => e.resourceTypeId == E.material[0] && e.itemId == E.material[1],
      );

      if (foundItem != null) {
        foundItem.quantity.value = foundItem.quantity.value - E.amount;
        if (foundItem.quantity.value <= 0) {
          hunterControl.hunterData.value!.inventory.remove(foundItem);
        }
      }
    }
    hunterControl.hunterData.value!.equipment.invArmor
        .add(InvArmorModel(equip_set_id: equipset_id, equip_id: equidid));
    hunterControl.hunterData.refresh();
    await hunterControl.saveAccountData();
  }

  void CraftWeapon(int WeaponTypeId, int ItemID) {
    List<CraftingTableModel> Req_Craft = craftWeaponList
        .firstWhere(
            (e) => e.weapon_type_id == WeaponTypeId && e.item_id == ItemID)
        .crafting_table;
    for (var E in Req_Craft) {
      var foundItem =
          hunterControl.hunterData.value!.inventory.firstWhereOrNull(
        (e) => e.resourceTypeId == E.material[0] && e.itemId == E.material[1],
      );

      if (foundItem != null) {
        foundItem.quantity.value = foundItem.quantity.value - E.amount;
        if (foundItem.quantity.value <= 0) {
          hunterControl.hunterData.value!.inventory.remove(foundItem);
        }
      }
    }
    hunterControl.hunterData.value!.equipment.invWeapon.add(
        InvWeaponModel(weapon_type_id: WeaponTypeId.obs, item_id: ItemID.obs));
    hunterControl.hunterData.refresh();
    hunterControl.saveAccountData();
  }
}
