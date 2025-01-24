import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mhw_quest_book/app_route/route.dart';
import 'package:mhw_quest_book/module/save-hunter/model/equiment_model.dart';
import 'package:mhw_quest_book/utility/fonts/fonts.dart';
import 'package:mhw_quest_book/utility/fonts/text_style.dart';
import 'package:mhw_quest_book/module/save-hunter/controller/hunter_control.dart';
import 'package:mhw_quest_book/module/save-hunter/controller/resource_control.dart';
import 'package:mhw_quest_book/module/save-hunter/model/resource_model.dart';

import 'package:mhw_quest_book/module/save-hunter/controller/crafting_control.dart';
import 'package:mhw_quest_book/utility/icons.dart';

import 'package:mhw_quest_book/module/save-hunter/view/selected_equipment.dart';

class Savehunter extends StatelessWidget {
  HunterControl hunterControl = Get.put(HunterControl());
  ResourceControl resourceControl = Get.put(ResourceControl());
  CraftingControl craftingControl = Get.put(CraftingControl());

  RxInt IsSelectedResourceType = 1.obs;

  RxInt IsSelectBody = 1.obs;
  RxString TitleAppBar = "Inventory".obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown.shade400,
          title: Obx(() => Text(
                TitleAppBar.value,
                style:
                    TextAppStyle.textsHeaderLargeProminent(color: Colors.white),
              )),
          centerTitle: true,
          actions: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  )),
                ),
                onPressed: () {
                  //craftingControl.loadArmorSetData();
                  Get.toNamed(Routes.Crafting);
                },
                child: Text(
                  "CRAFT",
                  style: TextAppStyle.textsBodyLargeProminent(
                      color: Colors.brown.shade400),
                ),
              ),
            )
          ],
        ),
        body: Obx(() => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            IsSelectBody.value = 1;
                            TitleAppBar.value = "Inventory";
                          },
                          style: TextButton.styleFrom(
                              backgroundColor: IsSelectBody.value == 1
                                  ? Colors.white
                                  : Colors.brown.shade400,
                              minimumSize: Size(75, 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                                side: BorderSide(color: Colors.black, width: 1),
                              )),
                          child: Text(
                            'Inventory',
                            textAlign: TextAlign.center,
                            style: TextAppStyle.textsBodyMediumProminent(
                                color: !(IsSelectBody.value == 1)
                                    ? Colors.white
                                    : Colors.brown.shade400),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            IsSelectBody.value = 2;
                            TitleAppBar.value = "Equipment";
                          },
                          style: TextButton.styleFrom(
                              backgroundColor: IsSelectBody.value == 2
                                  ? Colors.white
                                  : Colors.brown.shade400,
                              minimumSize: Size(75, 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                                side: BorderSide(color: Colors.black, width: 1),
                              )),
                          child: Text(
                            'Equipment',
                            textAlign: TextAlign.center,
                            style: TextAppStyle.textsBodyMediumProminent(
                                color: !(IsSelectBody.value == 2)
                                    ? Colors.white
                                    : Colors.brown.shade400),
                          ),
                        ),
                      )
                    ]),
                IsSelectBody.value == 1
                    ? Expanded(
                        child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: InventoryBox(),
                      ))
                    : IsSelectBody.value == 2
                        ? Expanded(
                            child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: EquipmentBox(),
                          ))
                        : SizedBox.shrink()
              ],
            )));
  }

//loadAllData()
  Widget EquipmentBox() {
    return FutureBuilder(
        future: craftingControl.loadAllData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.only(left: 5, right: 5),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Obx(() => StatusBox()),
                      ),
                      Container(
                        child: Obx(() => EquipmentSet()),
                      )
                    ],
                  ),
                ));
          }
        });
  }

  Widget EquipmentSet() {
    Weapon weapon = craftingControl.weaponsSetList
        .firstWhere((e) =>
            e.weaponTypeId ==
            hunterControl
                .hunterData.value!.Equipped_Weapon.value.weapon_type_id.value)
        .items
        .firstWhere((e) =>
            e.itemId ==
            hunterControl
                .hunterData.value!.Equipped_Weapon.value.item_id.value);
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.brown,
              border: Border.all(color: Colors.white, width: 2)),
          child: TextButton(
              style: TextButton.styleFrom(
                  padding: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0))),
              onPressed: () {
                Get.to(SelectedEquipment(
                  Type: "Weapon",
                ));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    child: Image.asset(
                      craftingControl.weaponsSetList
                          .firstWhere((e) =>
                              e.weaponTypeId ==
                              hunterControl.hunterData.value!.Equipped_Weapon
                                  .value.weapon_type_id.value)
                          .thumbnail,
                      fit: BoxFit.cover,
                    ),
                  ),
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
              )),
        ),
        ArmorTextButton(
            craftingControl.armorSetList.firstWhere((e) =>
                e.equip_set_id ==
                hunterControl
                    .hunterData.value!.Equipped_Helm.value.equip_set_id),
            craftingControl.armorSetList
                .firstWhere((e) =>
                    e.equip_set_id ==
                    hunterControl
                        .hunterData.value!.Equipped_Helm.value.equip_set_id)
                .equips
                .firstWhere((e) =>
                    e.equip_id ==
                    hunterControl
                        .hunterData.value!.Equipped_Helm.value.equip_id)
                .armor_part_id,
            craftingControl.armorSetList
                .firstWhere((e) =>
                    e.equip_set_id ==
                    hunterControl
                        .hunterData.value!.Equipped_Helm.value.equip_set_id)
                .equips
                .firstWhere((e) =>
                    e.equip_id ==
                    hunterControl
                        .hunterData.value!.Equipped_Helm.value.equip_id)
                .equip),
        ArmorTextButton(
            craftingControl.armorSetList.firstWhere((e) =>
                e.equip_set_id ==
                hunterControl
                    .hunterData.value!.Equipped_Mail.value.equip_set_id),
            craftingControl.armorSetList
                .firstWhere((e) =>
                    e.equip_set_id ==
                    hunterControl
                        .hunterData.value!.Equipped_Mail.value.equip_set_id)
                .equips
                .firstWhere((e) =>
                    e.equip_id ==
                    hunterControl
                        .hunterData.value!.Equipped_Mail.value.equip_id)
                .armor_part_id,
            craftingControl.armorSetList
                .firstWhere((e) =>
                    e.equip_set_id ==
                    hunterControl
                        .hunterData.value!.Equipped_Mail.value.equip_set_id)
                .equips
                .firstWhere((e) =>
                    e.equip_id ==
                    hunterControl
                        .hunterData.value!.Equipped_Mail.value.equip_id)
                .equip),
        ArmorTextButton(
            craftingControl.armorSetList.firstWhere((e) =>
                e.equip_set_id ==
                hunterControl
                    .hunterData.value!.Equipped_Gauntlets.value.equip_set_id),
            craftingControl.armorSetList
                .firstWhere((e) =>
                    e.equip_set_id ==
                    hunterControl.hunterData.value!.Equipped_Gauntlets.value
                        .equip_set_id)
                .equips
                .firstWhere((e) =>
                    e.equip_id ==
                    hunterControl
                        .hunterData.value!.Equipped_Gauntlets.value.equip_id)
                .armor_part_id,
            craftingControl.armorSetList
                .firstWhere((e) =>
                    e.equip_set_id ==
                    hunterControl.hunterData.value!.Equipped_Gauntlets.value
                        .equip_set_id)
                .equips
                .firstWhere((e) =>
                    e.equip_id ==
                    hunterControl
                        .hunterData.value!.Equipped_Gauntlets.value.equip_id)
                .equip)
      ],
    );
  }

  Widget ArmorTextButton(armorSetModel Armor, int armor_part_id, String equip) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.brown,
          border: Border.all(color: Colors.white, width: 2)),
      child: TextButton(
          style: TextButton.styleFrom(
              padding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0))),
          onPressed: () {
            Get.to(SelectedEquipment(
              Type: "Armor",
              armor_part_id: armor_part_id,
            ));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                child: Image.asset(
                  Armor.thumbnail,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: 40,
                height: 40,
                child: Image.asset(
                  ArmorsRarityIcons(
                          Armor_part: armor_part_id, rarity: Armor.rarity)
                      .GetIcon(),
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                  child: Text(
                textAlign: TextAlign.center,
                equip,
                maxLines: 3,
                style:
                    TextAppStyle.textsBodyLargeProminent(color: Colors.white),
              ))
            ],
          )),
    );
  }

  Widget StatusBox() {
    return Opacity(
        opacity: 0.9,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black, border: Border.all(color: Colors.white)),
          child: Container(
            padding: EdgeInsets.all(3),
            child: Column(
              children: [
                Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.white)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 35,
                        height: 35,
                        child: Image.asset(
                          hunterControl.hunterClassesList
                              .firstWhere((e) =>
                                  e.hunter_class_id ==
                                  hunterControl
                                      .hunterData.value!.hunter_class_id)
                              .thumbnail,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        hunterControl.hunterData.value!.hunter_name,
                        style: TextAppStyle.textsBodyLargeProminent(
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 15, bottom: 5),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.white)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            width: 40,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset("assets/img/bonus_armor.png"),
                                Text(
                                  craftingControl.GetArmor().toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontFamily: AppFont.Khaitun,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  craftingControl.GetArmor().toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontFamily: AppFont.Khaitun,
                                    fontWeight: FontWeight.w100,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                          craftingControl.GetElementArmor().isEmpty
                              ? SizedBox.shrink()
                              : Row(
                                  children: craftingControl.GetElementArmor()
                                      .map((Element) => Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 15),
                                            width: 40,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Image.asset(
                                                    "assets/img/bonus_armor.png"),
                                                Image.asset(craftingControl
                                                    .elementalList
                                                    .firstWhere((e) =>
                                                        e.elementID ==
                                                        Element['element_id'])
                                                    .thumbnail),
                                                Text(
                                                  textAlign: TextAlign.center,
                                                  Element!['protection']
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 32,
                                                    fontFamily: AppFont.Khaitun,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  textAlign: TextAlign.center,
                                                  Element!['protection']
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 32,
                                                    fontFamily: AppFont.Khaitun,
                                                    fontWeight: FontWeight.w100,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                )
                        ],
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: craftingControl.weaponsSetList
                              .firstWhere((e) =>
                                  e.weaponTypeId ==
                                  hunterControl
                                      .hunterData
                                      .value!
                                      .Equipped_Weapon
                                      .value
                                      .weapon_type_id
                                      .value)
                              .items
                              .firstWhere((e) =>
                                  e.itemId ==
                                  hunterControl.hunterData.value!
                                      .Equipped_Weapon.value.item_id.value)
                              .damageCards
                              .asMap()
                              .entries
                              .map((entry) {
                            int index = entry.key; // index ของ e
                            int e = entry.value; // ค่า e จริง
                            if (e > 0) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 35,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.asset(
                                              "assets/img/take_damage.png"),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Damage Draw Rate ≈",
                            style: TextAppStyle.textsBodySmall(
                                color: Colors.white),
                          ),
                          Container(
                            width: 60,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset("assets/img/take_damage.png"),
                                Padding(
                                  padding: EdgeInsets.all(13),
                                  child: Image.asset(
                                    "assets/img/take_damage.png",
                                  ),
                                ),
                                Text(
                                  craftingControl.GetAvarageDamage().toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: AppFont.Khaitun,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  craftingControl.GetAvarageDamage().toString(),
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
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.white)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                            border: Border.symmetric(
                                vertical: BorderSide(color: Colors.white))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              ": remove :",
                              style: TextAppStyle.textsBodyLargeProminent(
                                  color: Colors.white),
                            ),
                            Text(
                              textAlign: TextAlign.center,
                              craftingControl.weaponsSetList
                                  .firstWhere((e) =>
                                      e.weaponTypeId ==
                                      hunterControl
                                          .hunterData
                                          .value!
                                          .Equipped_Weapon
                                          .value
                                          .weapon_type_id
                                          .value)
                                  .items
                                  .firstWhere((e) =>
                                      e.itemId ==
                                      hunterControl.hunterData.value!
                                          .Equipped_Weapon.value.item_id.value)
                                  .remove,
                              style: TextAppStyle.textsBodySmall(
                                  color: Colors.white),
                            )
                          ],
                        ),
                      )),
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                            border: Border.symmetric(
                                vertical: BorderSide(color: Colors.white))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              ": add :",
                              style: TextAppStyle.textsBodyLargeProminent(
                                  color: Colors.white),
                            ),
                            Text(
                              textAlign: TextAlign.center,
                              craftingControl.weaponsSetList
                                  .firstWhere((e) =>
                                      e.weaponTypeId ==
                                      hunterControl
                                          .hunterData
                                          .value!
                                          .Equipped_Weapon
                                          .value
                                          .weapon_type_id
                                          .value)
                                  .items
                                  .firstWhere((e) =>
                                      e.itemId ==
                                      hunterControl.hunterData.value!
                                          .Equipped_Weapon.value.item_id.value)
                                  .add,
                              style: TextAppStyle.textsBodySmall(
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.white)),
                  child: Column(
                    children: [
                      Text(
                        ": Bonus Ability :",
                        style: TextAppStyle.textsBodyLargeProminent(
                            color: Colors.white),
                      ),
                      Column(
                        children: craftingControl.GetBonusAbility()
                            .map((e) => Container(
                                  margin: EdgeInsets.only(bottom: 20, top: 10),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    children: [
                                      Text(
                                        e.abilityName,
                                        style: TextAppStyle
                                            .textsBodyMediumProminent(
                                                color: Colors.white),
                                      ),
                                      Text(
                                        e.abilityDescription,
                                        style: TextAppStyle.textsBodySmall(
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                      craftingControl.GetArmorSetAbility().value
                          ? Container(
                              margin: EdgeInsets.only(bottom: 20, top: 10),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: [
                                  Text(
                                    craftingControl.bonusAbilityList
                                        .firstWhere((e) =>
                                            e.abilityID ==
                                            craftingControl.armorSetList
                                                .firstWhere((e) =>
                                                    e.equip_set_id ==
                                                    hunterControl
                                                        .hunterData
                                                        .value!
                                                        .Equipped_Helm
                                                        .value
                                                        .equip_set_id)
                                                .set_ability_bonus)
                                        .abilityName,
                                    style:
                                        TextAppStyle.textsBodyMediumProminent(
                                            color: Colors.white),
                                  ),
                                  Text(
                                    craftingControl.bonusAbilityList
                                        .firstWhere((e) =>
                                            e.abilityID ==
                                            craftingControl.armorSetList
                                                .firstWhere((e) =>
                                                    e.equip_set_id ==
                                                    hunterControl
                                                        .hunterData
                                                        .value!
                                                        .Equipped_Helm
                                                        .value
                                                        .equip_set_id)
                                                .set_ability_bonus)
                                        .abilityDescription,
                                    style: TextAppStyle.textsBodySmall(
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            )
                          : SizedBox.shrink()
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget InventoryBox() {
    return FutureBuilder(
        future: resourceControl.loadResourceData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.only(left: 5, right: 5),
              child: Column(
                children: [
                  Column(
                    children: [
                      Text(
                        "Potions",
                        style: TextAppStyle.textsBodySuperLargeProminent(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.brown.shade400),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                if (hunterControl.hunterData.value!.potions ==
                                    0) return;
                                hunterControl.hunterData.value!.potions--;
                                await hunterControl.saveAccountData();
                              },
                              icon: Icon(
                                Icons.remove,
                                color: Colors.white,
                                size: 15,
                              )),
                          SizedBox(width: 10),
                          Obx(() => Text(
                                "${hunterControl.hunterData.value!.potions}",
                                style:
                                    TextAppStyle.textsBodySuperLargeProminent(
                                        color: Colors.black),
                              )),
                          SizedBox(width: 10),
                          IconButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.brown.shade400),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                if (hunterControl.hunterData.value!.potions ==
                                    3) return;
                                hunterControl.hunterData.value!.potions++;
                                await hunterControl.saveAccountData();
                              },
                              icon: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 15,
                              )),
                        ],
                      )
                    ],
                  ),
                  Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  IsSelectedResourceType.value = 1;
                                },
                                style: TextButton.styleFrom(
                                    backgroundColor:
                                        IsSelectedResourceType.value == 1
                                            ? Colors.white
                                            : Colors.brown.shade400,
                                    minimumSize: Size(75, 75),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                      side: BorderSide(
                                          color: Colors.black, width: 1),
                                    )),
                                child: Text(
                                  'COMMON',
                                  textAlign: TextAlign.center,
                                  style: TextAppStyle.textsBodyMediumProminent(
                                      color:
                                          !(IsSelectedResourceType.value == 1)
                                              ? Colors.white
                                              : Colors.brown.shade400),
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  IsSelectedResourceType.value = 2;
                                },
                                style: TextButton.styleFrom(
                                    backgroundColor:
                                        IsSelectedResourceType.value == 2
                                            ? Colors.white
                                            : Colors.brown.shade400,
                                    minimumSize: Size(75, 75),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                      side: BorderSide(
                                          color: Colors.black, width: 1),
                                    )),
                                child: Text(
                                  'Other Materials',
                                  textAlign: TextAlign.center,
                                  style: TextAppStyle.textsBodyMediumProminent(
                                      color:
                                          !(IsSelectedResourceType.value == 2)
                                              ? Colors.white
                                              : Colors.brown.shade400),
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  IsSelectedResourceType.value = 3;
                                },
                                style: TextButton.styleFrom(
                                    backgroundColor:
                                        IsSelectedResourceType.value == 3
                                            ? Colors.white
                                            : Colors.brown.shade400,
                                    minimumSize: Size(75, 75),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                      side: BorderSide(
                                          color: Colors.black, width: 1),
                                    )),
                                child: Text(
                                  'Monster Parts',
                                  textAlign: TextAlign.center,
                                  style: TextAppStyle.textsBodyMediumProminent(
                                      color:
                                          !(IsSelectedResourceType.value == 3)
                                              ? Colors.white
                                              : Colors.brown.shade400),
                                ),
                              ),
                            )
                          ])),
                  SizedBox(height: 10),
                  Obx(() => ResourceBox(context, IsSelectedResourceType.value)),
                ],
              ),
            );
          }
        });
  }

  Widget ResourceBox(BuildContext context, int resourceID) {
    String resourceName = resourceControl.resourceList
        .firstWhere((resource) => resource.resourceId == resourceID)
        .resourceType;

    return Container(
      child: Column(
        children: [
          Text(
            resourceName,
            style: TextAppStyle.textsBodyLargeProminent(),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.brown.shade400),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              )),
            ),
            onPressed: () {
              resourceControl.selectResource(resourceID);
              Get.toNamed(Routes.AddItem);
            },
            child: Container(
              width: double.infinity,
              height: 40,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.brown.shade400, width: 1),
            ),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  var inventory = hunterControl.hunterData.value!.inventory
                      .where((e) => e.resourceTypeId == resourceID)
                      .toList();

                  if (inventory.isEmpty) {
                    return SizedBox.shrink();
                  } else {
                    return Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10.0, // ระยะห่างระหว่าง items ในแนวนอน
                      runSpacing: 10.0, // ระยะห่างระหว่าง items ในแนวตั้ง
                      children: inventory.map((inv) {
                        ItemModel item = resourceControl.resourceList
                            .firstWhere(
                                (resource) => resource.resourceId == resourceID)
                            .items
                            .firstWhere((item) => item.itemId == inv.itemId);

                        return Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.brown.shade400, width: 2),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 25,
                                    height: 25,
                                    child: Image.asset(item.thumbnail!),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    item.item,
                                    style:
                                        TextAppStyle.textsBodyMediumProminent(
                                            color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    style: ButtonStyle(
                                      minimumSize: MaterialStateProperty.all(
                                        Size(45, 45),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.brown.shade400),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (inv.quantity == 1) {
                                        hunterControl
                                            .hunterData.value!.inventory
                                            .removeWhere(
                                                (element) => element == inv);
                                      } else {
                                        inv.quantity--;
                                      }
                                      hunterControl.hunterData.refresh();
                                      await hunterControl.saveAccountData();
                                    },
                                    icon: Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Obx(() => Text(
                                        inv.quantity.toString(),
                                        style: TextAppStyle
                                            .textsHeaderLargeProminent(
                                                color: Colors.black),
                                      )),
                                  SizedBox(width: 15),
                                  IconButton(
                                    style: ButtonStyle(
                                      minimumSize: MaterialStateProperty.all(
                                        Size(45, 45),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.brown.shade400),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      inv.quantity++;
                                      hunterControl.hunterData.refresh();
                                      await hunterControl.saveAccountData();
                                    },
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
