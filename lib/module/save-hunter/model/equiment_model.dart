class armorsModel {
  int equip_id;
  String equip;
  int armor_part_id;
  int physical_armor;
  Map<String, dynamic>? elemental_armor;
  int? ability_id;

  armorsModel({
    required this.equip_id,
    required this.equip,
    required this.armor_part_id,
    required this.physical_armor,
    this.elemental_armor,
    this.ability_id,
  });

  factory armorsModel.fromJson(Map<String, dynamic> json) {
    return armorsModel(
      equip_id: json['equip_id'],
      equip: json['equip'],
      armor_part_id: json['armor_part_id'],
      physical_armor: json['physical_armor'],
      elemental_armor: json['elemental_armor'],
      ability_id: json['ability_id'],
    );
  }
}

class armorSetModel {
  int equip_set_id;
  String equip_set;
  int rarity;
  int? set_ability_bonus;
  String thumbnail;
  List<armorsModel> equips;

  armorSetModel({
    required this.equip_set_id,
    required this.equip_set,
    required this.rarity,
    this.set_ability_bonus,
    required this.thumbnail,
    required this.equips,
  });

  factory armorSetModel.fromJson(Map<String, dynamic> json) {
    return armorSetModel(
      equip_set_id: json['equip_set_id'],
      equip_set: json['equip_set'],
      rarity: json['rarity'],
      set_ability_bonus: json['set_ability_bonus'],
      thumbnail: json['thumbnail'],
      equips:
          (json['equips'] as List).map((e) => armorsModel.fromJson(e)).toList(),
    );
  }
}

class WeaponPriorityModel {
  final int weapon_type_id;
  final List<List<dynamic>> priority; // List<List<int>>

  WeaponPriorityModel({
    required this.weapon_type_id,
    required this.priority,
  });

  factory WeaponPriorityModel.fromJson(Map<String, dynamic> json) {
    return WeaponPriorityModel(
      weapon_type_id: json['weapon_type_id'],
      priority: List<List<dynamic>>.from(json['priority']),
    );
  }
}

class Weapon {
  final int itemId;
  final String item;
  final int rarity;
  final int defense;
  final List<int> damageCards;
  final String remove;
  final String add;

  Weapon({
    required this.itemId,
    required this.item,
    required this.rarity,
    required this.defense,
    required this.damageCards,
    required this.remove,
    required this.add,
  });

  factory Weapon.fromJson(Map<String, dynamic> json) {
    return Weapon(
      itemId: json['item_id'],
      item: json['item'],
      rarity: json['rarity'],
      defense: json['defense'],
      damageCards: [
        json['damage_cards']['damage_1'],
        json['damage_cards']['damage_2'],
        json['damage_cards']['damage_3'],
        json['damage_cards']['damage_4'],
      ],
      remove: json['remove'] ?? '',
      add: json['add'] ?? '',
    );
  }
}

// WeaponsList class
class WeaponsList {
  final int weaponTypeId;
  final String weaponType;
  final String thumbnail;
  final List<Weapon> items;

  WeaponsList({
    required this.weaponTypeId,
    required this.weaponType,
    required this.thumbnail,
    required this.items,
  });

  factory WeaponsList.fromJson(Map<String, dynamic> json) {
    var list = json['items'] as List;
    List<Weapon> itemsList = list.map((i) => Weapon.fromJson(i)).toList();

    return WeaponsList(
      weaponTypeId: json['weapon_type_id'],
      weaponType: json['weapon_type'],
      thumbnail: json['thumbnail'],
      items: itemsList,
    );
  }
}

class CraftingTableModel {
  List<int> material;
  int amount;

  CraftingTableModel({required this.material, required this.amount});

  factory CraftingTableModel.fromJson(Map<String, dynamic> json) {
    return CraftingTableModel(
      material: List<int>.from(json['material']),
      amount: json['amount'],
    );
  }
}

class CraftListModel {
  int equip_set_id;
  int equip_id;
  List<CraftingTableModel> crafting_table;

  CraftListModel(
      {required this.equip_set_id,
      required this.crafting_table,
      required this.equip_id});
  factory CraftListModel.fromJson(Map<String, dynamic> json) {
    return CraftListModel(
        equip_set_id: json['equip_set_id'],
        crafting_table: (json['crafting_table'] as List)
            .map((e) => CraftingTableModel.fromJson(e))
            .toList(),
        equip_id: json['equip_id']);
  }
}

class CraftWeaponModel {
  final int weapon_type_id;
  final int item_id;
  final List<int> required_weapon;
  final List<CraftingTableModel> crafting_table;

  CraftWeaponModel({
    required this.weapon_type_id,
    required this.item_id,
    required this.required_weapon,
    required this.crafting_table,
  });

  factory CraftWeaponModel.fromJson(Map<String, dynamic> json) {
    return CraftWeaponModel(
      weapon_type_id: json['weapon_type_id'],
      item_id: json['item_id'],
      required_weapon: List<int>.from(json['required_weapon']),
      crafting_table: (json['crafting_table'] as List)
          .map((e) => CraftingTableModel.fromJson(e))
          .toList(),
    );
  }
}
