import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mhw_quest_book/app_route/route.dart';
import 'package:mhw_quest_book/utility/fonts/text_style.dart';
import 'package:mhw_quest_book/module/save-hunter/controller/hunter_control.dart';
import 'package:mhw_quest_book/module/save-hunter/controller/resource_control.dart';
import 'package:mhw_quest_book/module/save-hunter/model/resource_model.dart';

class Savehunter extends StatelessWidget {
  HunterControl hunterControl = Get.put(HunterControl());
  ResourceControl resourceControl = Get.put(ResourceControl());

  RxInt IsSelectedResourceType = 1.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown.shade400,
        title: Text(
          "Inventory",
          style: TextAppStyle.textsHeaderLargeProminent(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: resourceControl.loadResourceData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.only(left: 15, right: 15),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
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
                                    if (hunterControl
                                            .hunterData.value!.potions ==
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
                                    style: TextAppStyle
                                        .textsBodySuperLargeProminent(
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
                                    if (hunterControl
                                            .hunterData.value!.potions ==
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
                      SizedBox(height: 50),
                      Obx(() =>
                          ResourceBox(context, IsSelectedResourceType.value)),
                      // SizedBox(height: 40),
                      // ResourceBox(context, 2),
                      // SizedBox(height: 40),
                      // ResourceBox(context, 3),
                    ],
                  ),
                ),
              );
            }
          }),
      bottomNavigationBar: BottomAppBar(
        child: Obx(() =>
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    IsSelectedResourceType.value = 1;
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: IsSelectedResourceType.value == 1
                          ? Colors.white
                          : Colors.brown.shade400,
                      minimumSize: Size(75, 75),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                        side: BorderSide(color: Colors.black, width: 1),
                      )),
                  child: Text(
                    'COMMON',
                    textAlign: TextAlign.center,
                    style: TextAppStyle.textsBodyMediumProminent(
                        color: !(IsSelectedResourceType.value == 1)
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
                      backgroundColor: IsSelectedResourceType.value == 2
                          ? Colors.white
                          : Colors.brown.shade400,
                      minimumSize: Size(75, 75),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                        side: BorderSide(color: Colors.black, width: 1),
                      )),
                  child: Text(
                    'Other Materials',
                    textAlign: TextAlign.center,
                    style: TextAppStyle.textsBodyMediumProminent(
                        color: !(IsSelectedResourceType.value == 2)
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
                      backgroundColor: IsSelectedResourceType.value == 3
                          ? Colors.white
                          : Colors.brown.shade400,
                      minimumSize: Size(75, 75),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                        side: BorderSide(color: Colors.black, width: 1),
                      )),
                  child: Text(
                    'Monster Parts',
                    textAlign: TextAlign.center,
                    style: TextAppStyle.textsBodyMediumProminent(
                        color: !(IsSelectedResourceType.value == 3)
                            ? Colors.white
                            : Colors.brown.shade400),
                  ),
                ),
              )
            ])),
      ),
    );
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
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.brown.shade400, width: 1),
            ),
            child: Column(
              children: [
                Obx(() {
                  if (hunterControl.hunterData.value!.inventory.isEmpty) {
                    return SizedBox.shrink();
                  } else {
                    return Column(
                        children: hunterControl.hunterData.value!.inventory
                            .where((e) => e.resourceTypeId == resourceID)
                            .map((inv) {
                      ItemModel Item = resourceControl.resourceList
                          .firstWhere(
                              (resource) => resource.resourceId == resourceID)
                          .items
                          .firstWhere((item) => item.itemId == inv.itemId);
                      return Container(
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.symmetric(vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: Colors.brown.shade400, width: 2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 25,
                                  height: 25,
                                  child: Image.asset(Item.thumbnail!),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  Item.item,
                                  style: TextAppStyle.textsBodyMediumProminent(
                                      color: Colors.black),
                                )
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    style: ButtonStyle(
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
                                    )),
                                SizedBox(width: 10),
                                Obx(() => Text(
                                      inv.quantity.toString(),
                                      style: TextAppStyle
                                          .textsHeaderLargeProminent(
                                              color: Colors.black),
                                    )),
                                SizedBox(width: 10),
                                IconButton(
                                    style: ButtonStyle(
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
                                    ))
                              ],
                            )
                          ],
                        ),
                      );
                    }).toList());
                  }
                }),
              ],
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.brown.shade400),
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
                height: 50,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ))
        ],
      ),
    );
  }
}
