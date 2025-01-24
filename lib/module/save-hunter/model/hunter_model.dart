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

class HunterClassModel {
  final int hunter_class_id;
  final String hunter_class_name;
  final String thumbnail;

  HunterClassModel({
    required this.hunter_class_id,
    required this.hunter_class_name,
    required this.thumbnail,
  });

  factory HunterClassModel.fromJson(Map<String, dynamic> json) {
    return HunterClassModel(
      hunter_class_id: json['hunter_class_id'],
      hunter_class_name: json['hunter_class'],
      thumbnail: json['thumbnail'],
    );
  }
}

class InvWeaponModel {
  RxInt weapon_type_id;
  RxInt item_id;

  InvWeaponModel({
    required this.weapon_type_id,
    required this.item_id,
  });

  factory InvWeaponModel.fromJson(Map<String, dynamic> json) {
    return InvWeaponModel(
      weapon_type_id: RxInt(json['weapon_type_id']),
      item_id: RxInt(json['item_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weapon_type_id': weapon_type_id.value,
      'item_id': item_id.value,
    };
  }
}

class InvArmorModel {
  int equip_set_id;
  int equip_id;

  InvArmorModel({
    required this.equip_set_id,
    required this.equip_id,
  });

  factory InvArmorModel.fromJson(Map<String, dynamic> json) {
    return InvArmorModel(
      equip_set_id: json['equip_set_id'],
      equip_id: json['equip_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'equip_set_id': equip_set_id,
      'equip_id': equip_id,
    };
  }
}

class EquipmentModel {
  List<InvWeaponModel> invWeapon;
  List<InvArmorModel> invArmor;

  EquipmentModel({
    required this.invWeapon,
    required this.invArmor,
  });

  factory EquipmentModel.fromJson(Map<String, dynamic> json) {
    return EquipmentModel(
      invWeapon: (json['inv_weapon'] as List)
          .map((weapon) => InvWeaponModel.fromJson(weapon))
          .toList(),
      invArmor: (json['inv_armor'] as List)
          .map((armor) => InvArmorModel.fromJson(armor))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'inv_weapon': invWeapon.map((weapon) => weapon.toJson()).toList(),
      'inv_armor': invArmor.map((armor) => armor.toJson()).toList(),
    };
  }
}

class HunterDataModel {
  final int hunter_id;
  final String hunter_name;
  final int hunter_class_id;
  RxInt campaign_day;
  RxInt potions;
  final List<AttemptedQuestModel> attemptedQuest;
  final List<InventoryModel> inventory;
  final EquipmentModel equipment;
  Rx<InvWeaponModel> Equipped_Weapon;
  Rx<InvArmorModel> Equipped_Helm;
  Rx<InvArmorModel> Equipped_Mail;
  Rx<InvArmorModel> Equipped_Gauntlets;

  HunterDataModel({
    required this.hunter_id,
    required this.hunter_name,
    required this.hunter_class_id,
    required this.campaign_day,
    required this.potions,
    required this.attemptedQuest,
    required this.inventory,
    required this.equipment,
    required this.Equipped_Weapon,
    required this.Equipped_Helm,
    required this.Equipped_Mail,
    required this.Equipped_Gauntlets,
  });

  factory HunterDataModel.fromJson(Map<String, dynamic> json) {
    return HunterDataModel(
      hunter_id: json['hunter_id'],
      hunter_name: json['hunter_name'],
      hunter_class_id: json['hunter_class_id'],
      campaign_day: RxInt(json['campaign_day']),
      potions: RxInt(json['potions']),
      attemptedQuest: (json['attempted_quest'] as List)
          .map((quest) => AttemptedQuestModel.fromJson(quest))
          .toList(),
      inventory: (json['inventory'] as List)
          .map((inv) => InventoryModel.fromJson(inv))
          .toList(),
      equipment: EquipmentModel.fromJson(json['equipment']),
      Equipped_Weapon:
          Rx<InvWeaponModel>(InvWeaponModel.fromJson(json['selected_weapon'])),
      Equipped_Helm:
          Rx<InvArmorModel>(InvArmorModel.fromJson(json['selected_helm'])),
      Equipped_Mail:
          Rx<InvArmorModel>(InvArmorModel.fromJson(json['selected_mail'])),
      Equipped_Gauntlets:
          Rx<InvArmorModel>(InvArmorModel.fromJson(json['selected_gauntlets'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hunter_id': hunter_id,
      'hunter_name': hunter_name,
      'hunter_class_id': hunter_class_id,
      'campaign_day': campaign_day.value,
      'potions': potions.value,
      'attempted_quest': attemptedQuest.map((quest) => quest.toJson()).toList(),
      'inventory': inventory.map((inv) => inv.toJson()).toList(),
      'equipment': equipment.toJson(),
      'selected_weapon': Equipped_Weapon.value.toJson(),
      'selected_helm': Equipped_Helm.value.toJson(),
      'selected_mail': Equipped_Mail.value.toJson(),
      'selected_gauntlets': Equipped_Gauntlets.value.toJson(),
    };
  }
}
