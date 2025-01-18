import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:mhw_quest_book/utility/fonts/text_style.dart';
import 'package:mhw_quest_book/module/save-hunter/controller/resource_control.dart';
import 'package:mhw_quest_book/module/save-hunter/controller/hunter_control.dart';
import 'package:mhw_quest_book/module/save-hunter/model/resource_model.dart';

class AddItem extends StatelessWidget {
  ResourceControl resourceControl = Get.put(ResourceControl());
  HunterControl hunterControl = Get.put(HunterControl());
  TextEditingController searchController = TextEditingController();
  RxList<ItemModel> filteredItems = RxList<ItemModel>();

  @override
  Widget build(BuildContext context) {
    // เริ่มต้นด้วยการตั้งค่า filteredItems เท่ากับ items ทั้งหมด
    filteredItems.assignAll(resourceControl.selectedResource.value.items);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown.shade400,
        title: Text(
          resourceControl.selectedResource.value.resourceType,
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
            return Column(
              children: [
                // เพิ่ม TextField สำหรับการค้นหา
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'ค้นหาไอเทม...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (query) {
                      // เมื่อพิมพ์ใน TextField จะทำการค้นหาและกรองรายการ
                      filteredItems.assignAll(resourceControl
                          .selectedResource.value.items
                          .where((item) {
                        return item.item
                            .toLowerCase()
                            .contains(query.toLowerCase());
                      }).toList());
                    },
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Obx(() {
                      return Column(
                        children: filteredItems.map((item) {
                          bool show = true;
                          for (var hunterdata
                              in hunterControl.hunterData.value!.inventory) {
                            if (hunterdata.resourceTypeId ==
                                    resourceControl
                                        .selectedResource.value.resourceId &&
                                hunterdata.itemId == item.itemId) {
                              show = false;
                              break;
                            }
                          }
                          if (show) {
                            return Container(
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.symmetric(vertical: 10),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.brown.shade400, width: 2),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                        style: TextAppStyle
                                            .textsHeaderLargeProminent(
                                                color: Colors.black),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10),
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
                                          onPressed: () {
                                            if (item.quantity == 0) return;
                                            item.quantity--;
                                          },
                                          icon: Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                            size: 15,
                                          )),
                                      SizedBox(width: 10),
                                      Obx(() => Text(
                                            item.quantity.toString(),
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
                                          onPressed: () {
                                            item.quantity++;
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
                          } else {
                            return SizedBox.shrink();
                          }
                        }).toList(),
                      );
                    }),
                  ),
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: Obx(() {
        if (resourceControl.selectedResource.value.items
            .any((e) => e.quantity.value > 0)) {
          return BottomAppBar(
            color: Colors.brown.shade400,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: Size(75, 75),
                    ),
                    child: Text(
                      "ยืนยัน",
                      style: TextAppStyle.textsHeaderLargeProminent(
                          color: Colors.brown.shade400),
                    ),
                    onPressed: () {
                      resourceControl.addItemInventory();
                      hunterControl.loadAccounts();
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      }),
    );
  }
}
