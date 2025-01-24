import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mhw_quest_book/module/save-hunter/model/equiment_model.dart';
import 'package:mhw_quest_book/module/save-hunter/model/hunter_model.dart';
import 'package:mhw_quest_book/module/save-hunter/model/utility_model.dart';
import 'package:mhw_quest_book/module/save-hunter/controller/resource_control.dart';
import 'package:mhw_quest_book/module/save-hunter/controller/hunter_control.dart';
import 'package:mhw_quest_book/module/save-hunter/controller/crafting_control.dart';
import 'package:mhw_quest_book/utility/fonts/fonts.dart';
import 'package:mhw_quest_book/utility/fonts/text_style.dart';
import 'package:mhw_quest_book/utility/icons.dart';

import 'package:mhw_quest_book/module/save-hunter/model/resource_model.dart';

class SelectedEquipment extends StatelessWidget {
  String? Type;
  int? armor_part_id;

  SelectedEquipment({this.Type, this.armor_part_id});

  HunterControl hunterControl = Get.put(HunterControl());
  CraftingControl craftingControl = Get.put(CraftingControl());

  RxString TitleAppBar = "".obs;

  @override
  void initState() {
    if (armor_part_id != null) {
      if (armor_part_id == 1) {
        TitleAppBar.value = "Helm";
      } else if (armor_part_id == 2) {
        TitleAppBar.value = "Mail";
      } else if (armor_part_id == 3) {
        TitleAppBar.value = "Greaves";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown.shade400,
          title: Text(
            armor_part_id != null
                ? armor_part_id == 1
                    ? "Helm"
                    : armor_part_id == 2
                        ? "Mail"
                        : armor_part_id == 3
                            ? "Greaves"
                            : ""
                : "Weapons",
            style: TextAppStyle.textsHeaderLargeProminent(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Type == "Armor"
                ? Armor()
                : Type == "Weapon"
                    ? WeaponBox()
                    : SizedBox.shrink(),
          ),
        ));
  }

  List<List<int>> WeaponType_id = [];
  Widget WeaponBox() {
    return Column(
      children:
          hunterControl.hunterData.value!.equipment.invWeapon.map((InvWeapon) {
        WeaponsList WeaponType = craftingControl.weaponsSetList.firstWhere(
            (e) => e.weaponTypeId == InvWeapon.weapon_type_id.value);
        Weapon WeaponList = craftingControl.weaponsSetList
            .firstWhere((e) => e.weaponTypeId == InvWeapon.weapon_type_id.value)
            .items
            .firstWhere((e) => e.itemId == InvWeapon.item_id.value);
        if (!WeaponType_id.any((e) =>
            e[0] == InvWeapon.weapon_type_id.value &&
            e[1] == InvWeapon.item_id.value)) {
          WeaponType_id.add(
              [InvWeapon.weapon_type_id.value, InvWeapon.item_id.value]);
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                                  rarity: WeaponList.rarity)
                              .GetIcon(),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                          child: Text(
                        textAlign: TextAlign.center,
                        WeaponList.item,
                        maxLines: 3,
                        style: TextAppStyle.textsBodyLargeProminent(
                            color: Colors.white),
                      ))
                    ],
                  ),
                ),
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
                          children: WeaponList.damageCards
                              .asMap()
                              .entries
                              .map((entry) {
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
                                          Image.asset(
                                            "assets/img/take_damage.png",
                                          ),
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
                      WeaponList.defense != 0
                          ? Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              width: 35,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 25,
                                    child: Image.asset(
                                        "assets/img/bonus_armor.png"),
                                  ),
                                  Text(
                                    WeaponList.defense.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: AppFont.Khaitun,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    WeaponList.defense.toString(),
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
                WeaponList.remove.isNotEmpty && WeaponList.add.isNotEmpty
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        WeaponList.remove,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        WeaponList.add,
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
                Obx(() => Opacity(
                      opacity: EquipmentWeapon(
                                  WeaponType.weaponTypeId, WeaponList.itemId)
                              .value
                          ? 0.25
                          : 0.9,
                      child: TextButton(
                          onPressed: () async {
                            if (!EquipmentWeapon(
                                    WeaponType.weaponTypeId, WeaponList.itemId)
                                .value) {
                              Get.back();
                            }
                            hunterControl
                                .hunterData
                                .value!
                                .Equipped_Weapon
                                .value
                                .weapon_type_id
                                .value = WeaponType.weaponTypeId;
                            hunterControl.hunterData.value!.Equipped_Weapon
                                .value.item_id.value = WeaponList.itemId;
                            hunterControl.hunterData.refresh();
                            await hunterControl.saveAccountData();
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.green.shade600,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.black, width: 3)),
                            child: Center(
                              child: Text(
                                EquipmentWeapon(WeaponType.weaponTypeId,
                                            WeaponList.itemId)
                                        .value
                                    ? "Equipmented"
                                    : "Equip",
                                style: TextAppStyle.textsBodyLargeProminent(
                                    color: Colors.white),
                              ),
                            ),
                          )),
                    ))
              ],
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      }).toList(),
    );
  }

  List<List<int>> ArmorType_id = [];
  Widget Armor() {
    return Column(
      children: hunterControl.hunterData.value!.equipment.invArmor.map((armor) {
        armorsModel ARMOR = craftingControl.armorSetList
            .firstWhere((e) => e.equip_set_id == armor.equip_set_id)
            .equips
            .firstWhere((e) => e.equip_id == armor.equip_id);
        armorSetModel ArmorType = craftingControl.armorSetList
            .firstWhere((e) => e.equip_set_id == armor.equip_set_id);
        if (ARMOR.armor_part_id == armor_part_id &&
            !ArmorType_id.any(
                (e) => e[0] == armor.equip_set_id && e[1] == armor.equip_id)) {
          ArmorType_id.add([armor.equip_set_id, armor.equip_id]);
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                                  rarity: ArmorType.rarity,
                                  Armor_part: ARMOR.armor_part_id)
                              .GetIcon(),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                          child: Text(
                        textAlign: TextAlign.center,
                        ARMOR.equip,
                        maxLines: 3,
                        style: TextAppStyle.textsBodyLargeProminent(
                            color: Colors.white),
                      ))
                    ],
                  ),
                ),
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
                              ARMOR.physical_armor.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 40,
                                fontFamily: AppFont.Khaitun,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              ARMOR.physical_armor.toString(),
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
                      ARMOR.elemental_armor!['elemental_id'] == 0
                          ? SizedBox.shrink()
                          : Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              width: 60,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset("assets/img/bonus_armor.png"),
                                  Image.asset(craftingControl.elementalList
                                      .firstWhere((e) =>
                                          e.elementID ==
                                          ARMOR
                                              .elemental_armor!['elemental_id'])
                                      .thumbnail),
                                  Text(
                                    textAlign: TextAlign.center,
                                    ARMOR.elemental_armor!['protection']
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontFamily: AppFont.Khaitun,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    textAlign: TextAlign.center,
                                    ARMOR.elemental_armor!['protection']
                                        .toString(),
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
                  height: 48,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.white)),
                  child: Center(
                      child: ARMOR.ability_id == 0
                          ? SizedBox.shrink()
                          : Text(
                              textAlign: TextAlign.center,
                              craftingControl.bonusAbilityList
                                  .firstWhere(
                                      (e) => e.abilityID == ARMOR.ability_id)
                                  .abilityName,
                              style: TextAppStyle.textsBodyMedium(
                                  color: Colors.white),
                            )),
                ),
                Obx(() => Opacity(
                      opacity:
                          EquipmentArmor(armor.equip_set_id, ARMOR.equip_id)
                                  .value
                              ? 0.25
                              : 0.9,
                      child: TextButton(
                          onPressed: () async {
                            if (!EquipmentArmor(
                                    armor.equip_set_id, ARMOR.equip_id)
                                .value) {
                              Get.back();
                            }
                            if (armor_part_id == 1) {
                              hunterControl.hunterData.value!.Equipped_Helm
                                  .value.equip_set_id = armor.equip_set_id;
                              hunterControl.hunterData.value!.Equipped_Helm
                                  .value.equip_id = armor.equip_id;
                            } else if (armor_part_id == 2) {
                              hunterControl.hunterData.value!.Equipped_Mail
                                  .value.equip_set_id = armor.equip_set_id;
                              hunterControl.hunterData.value!.Equipped_Mail
                                  .value.equip_id = armor.equip_id;
                            } else if (armor_part_id == 3) {
                              hunterControl.hunterData.value!.Equipped_Gauntlets
                                  .value.equip_set_id = armor.equip_set_id;
                              hunterControl.hunterData.value!.Equipped_Gauntlets
                                  .value.equip_id = armor.equip_id;
                            }

// Refresh เพื่อให้ UI อัปเดตตามข้อมูลใหม่
                            hunterControl.hunterData.refresh();
                            await hunterControl.saveAccountData();
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.green.shade600,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.black, width: 3)),
                            child: Center(
                              child: Text(
                                EquipmentArmor(
                                            armor.equip_set_id, ARMOR.equip_id)
                                        .value
                                    ? "Equipmented"
                                    : "Equip",
                                style: TextAppStyle.textsBodyLargeProminent(
                                    color: Colors.white),
                              ),
                            ),
                          )),
                    ))
              ],
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      }).toList(),
    );
  }

  RxBool EquipmentArmor(int equipset_id, int equidid) {
    if (hunterControl.hunterData.value!.equipment.invArmor.isNotEmpty) {
      if (hunterControl.hunterData.value!.Equipped_Helm.value.equip_set_id == equipset_id && hunterControl.hunterData.value!.Equipped_Helm.value.equip_id == equidid ||
          hunterControl.hunterData.value!.Equipped_Mail.value.equip_set_id ==
                  equipset_id &&
              hunterControl.hunterData.value!.Equipped_Mail.value.equip_id ==
                  equidid ||
          hunterControl.hunterData.value!.Equipped_Gauntlets.value
                      .equip_set_id ==
                  equipset_id &&
              hunterControl
                      .hunterData.value!.Equipped_Gauntlets.value.equip_id ==
                  equidid) {
        return true.obs;
      } else {
        return false.obs;
      }
    } else {
      return false.obs;
    }
  }

  RxBool EquipmentWeapon(int weapontype_id, int item_id) {
    if (hunterControl.hunterData.value!.equipment.invWeapon.isNotEmpty) {
      if (hunterControl
                  .hunterData.value!.Equipped_Weapon.value.weapon_type_id ==
              weapontype_id &&
          hunterControl.hunterData.value!.Equipped_Weapon.value.item_id ==
              item_id) {
        return true.obs;
      } else {
        return false.obs;
      }
    } else {
      return false.obs;
    }
  }
}
