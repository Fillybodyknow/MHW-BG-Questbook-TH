import 'package:get/get.dart';

class AttemptedQuestModel {
  final int monsterId;
  final int questId;
  final List<int> attempted;

  AttemptedQuestModel({
    required this.monsterId,
    required this.questId,
    required this.attempted,
  });

  factory AttemptedQuestModel.fromJson(Map<String, dynamic> json) {
    return AttemptedQuestModel(
      monsterId: json['monster_id'],
      questId: json['quest_id'],
      attempted: List<int>.from(json['attempted']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'monster_id': monsterId,
      'quest_id': questId,
      'attempted': attempted,
    };
  }
}

class InventoryModel {
  final int resourceTypeId;
  final int itemId;
  RxInt quantity;

  InventoryModel({
    required this.resourceTypeId,
    required this.itemId,
    required this.quantity,
  });

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      resourceTypeId: json['resource_type_id'],
      itemId: json['item_id'],
      quantity: RxInt(json['quantity']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resource_type_id': resourceTypeId,
      'item_id': itemId,
      'quantity': quantity.value,
    };
  }
}

class HunterDataModel {
  final int hunter_id;
  final String hunter_name;
  RxInt campaign_day;
  RxInt potions;
  final List<AttemptedQuestModel> attemptedQuest;
  final List<InventoryModel> inventory;

  HunterDataModel({
    required this.hunter_id,
    required this.hunter_name,
    required this.campaign_day,
    required this.potions,
    required this.attemptedQuest,
    required this.inventory,
  });

  factory HunterDataModel.fromJson(Map<String, dynamic> json) {
    return HunterDataModel(
        hunter_id: json['hunter_id'],
        hunter_name: json['hunter_name'],
        campaign_day: RxInt(json['campaign_day']),
        potions: RxInt(json['potions']),
        attemptedQuest: (json['attempted_quest'] as List)
            .map((quest) => AttemptedQuestModel.fromJson(quest))
            .toList(),
        inventory: (json['inventory'] as List)
            .map((inv) => InventoryModel.fromJson(inv))
            .toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'hunter_id': hunter_id,
      'hunter_name': hunter_name,
      'campaign_day': campaign_day.value,
      'potions': potions.value,
      'attempted_quest': attemptedQuest.map((quest) => quest.toJson()).toList(),
      'inventory': inventory.map((inv) => inv.toJson()).toList(),
    };
  }
}
