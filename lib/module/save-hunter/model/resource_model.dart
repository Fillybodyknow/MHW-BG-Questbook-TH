import 'package:get/get.dart';

class ItemModel {
  final int itemId;
  final String item;
  final String? thumbnail;
  RxInt quantity = 0.obs;
  ItemModel({required this.itemId, required this.item, this.thumbnail});

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      itemId: json['item_id'],
      item: json['item'],
      thumbnail: json['thumbnail'],
    );
  }
}

class ResourceModel {
  final int resourceId;
  final String resourceType;
  final List<ItemModel> items;

  ResourceModel(
      {required this.resourceId,
      required this.resourceType,
      required this.items});

  factory ResourceModel.fromJson(Map<String, dynamic> json) {
    return ResourceModel(
      resourceId: json['resource_type_id'],
      resourceType: json['resource_type'],
      items: (json['resources'] as List)
          .map((item) => ItemModel.fromJson(item))
          .toList(),
    );
  }
}
