import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:mhw_quest_book/module/save-hunter/model/resource_model.dart';
import 'package:mhw_quest_book/module/save-hunter/model/hunter_model.dart';
import 'package:mhw_quest_book/module/save-hunter/controller/hunter_control.dart';

class ResourceControl extends GetxController {
  HunterControl hunterControl = Get.put(HunterControl());
  RxList<ResourceModel> resourceList = RxList<ResourceModel>([]);

  Rx<ResourceModel> selectedResource =
      ResourceModel(items: [], resourceType: '', resourceId: 0).obs;

  Future<void> loadResourceData() async {
    // โหลดไฟล์ JSON จาก asset
    String jsonString =
        await rootBundle.loadString('assets/files/resource.json');

    // แปลง JSON string เป็น List<Map<String, dynamic>>
    List<dynamic> jsonList = jsonDecode(jsonString);

    // แปลง List<Map<String, dynamic>> เป็น List<Monster>
    resourceList.value =
        jsonList.map((json) => ResourceModel.fromJson(json)).toList();

    return;
  }

  void selectResource(int ResourceID) {
    selectedResource.value = resourceList
        .firstWhere((resource) => resource.resourceId == ResourceID);

    for (var item in selectedResource.value.items) {
      item.quantity.value = 0;
    }

    selectedResource.refresh();

    print(selectedResource.value.resourceType);
  }

  void addItemInventory() async {
    for (var item in selectedResource.value.items) {
      if (item.quantity.value > 0) {
        hunterControl.hunterData.value!.inventory.add(InventoryModel(
            resourceTypeId: selectedResource.value.resourceId,
            itemId: item.itemId,
            quantity: item.quantity));
      }
    }

    print(hunterControl.hunterData.value!.inventory[0].resourceTypeId);

    hunterControl.hunterData.refresh();

    await hunterControl.saveAccountData();
  }

  // String GetCountItems(int ResourceID, int ItemID) {
  //   for (var resource in hunterControl.hunterData.value!.inventory) {
  //     if (resource.resourceTypeId == ResourceID && resource.itemId == ItemID) {
  //       return resource.quantity.toString();
  //     }
  //   }
  //   return "0";
  // }
}
