import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mhw_quest_book/utility/fonts/text_style.dart';
import 'package:mhw_quest_book/module/save-hunter/controller/crafting_control.dart';

class CraftingView extends StatelessWidget {
  CraftingControl craftingControl = Get.put(CraftingControl());
  RxInt IsSelectedType = 1.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown.shade400,
          title: Text(
            "Crafting",
            style: TextAppStyle.textsHeaderLargeProminent(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      IsSelectedType.value = 1;
                      // await craftingControl
                      //     .loadCraftingTableData();
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: IsSelectedType.value == 1
                            ? Colors.white
                            : Colors.brown.shade400,
                        minimumSize: Size(75, 75),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                          side: BorderSide(color: Colors.black, width: 1),
                        )),
                    child: Text(
                      'Armors',
                      textAlign: TextAlign.center,
                      style: TextAppStyle.textsBodyMediumProminent(
                          color: !(IsSelectedType.value == 1)
                              ? Colors.white
                              : Colors.brown.shade400),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      IsSelectedType.value = 2;
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: IsSelectedType.value == 2
                            ? Colors.white
                            : Colors.brown.shade400,
                        minimumSize: Size(75, 75),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                          side: BorderSide(color: Colors.black, width: 1),
                        )),
                    child: Text(
                      'Weapons',
                      textAlign: TextAlign.center,
                      style: TextAppStyle.textsBodyMediumProminent(
                          color: !(IsSelectedType.value == 2)
                              ? Colors.white
                              : Colors.brown.shade400),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            child: Expanded(
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: FutureBuilder(
                        future: craftingControl.loadAllData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return Obx(() => Container(
                                  child: IsSelectedType.value == 1
                                      ? Column(
                                          children: craftingControl.armorSetList
                                              .map((armorSet) {
                                          if (armorSet.equip_set_id == 1 ||
                                              armorSet.equip_set_id == 2) {
                                            return SizedBox.shrink();
                                          } else {
                                            return craftingControl
                                                .CatagolyEquipBox(
                                                    armorSet.equip_set_id);
                                          }
                                        }).toList())
                                      : IsSelectedType.value == 2
                                          ? Column(
                                              children: craftingControl
                                                  .weaponsSetList
                                                  .map((weapon) {
                                                return craftingControl
                                                    .CatagolyWeaponBox(weapon);
                                              }).toList(),
                                            )
                                          : SizedBox.shrink(),
                                ));
                          }
                        }))),
          )
        ]));
  }
}
