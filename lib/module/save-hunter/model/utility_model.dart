class bonusAbilityModel {
  int abilityID;
  String abilityName;
  String abilityDescription;

  bonusAbilityModel(this.abilityID, this.abilityName, this.abilityDescription);

  factory bonusAbilityModel.fromJson(Map<String, dynamic> json) {
    return bonusAbilityModel(
        json['ability_id'], json['ability_name'], json['ability']);
  }
}

class elementalModel {
  int elementID;
  String elementName;
  String thumbnail;

  elementalModel(this.elementID, this.elementName, this.thumbnail);

  factory elementalModel.fromJson(Map<String, dynamic> json) {
    return elementalModel(
        json['elemental_id'], json['elemental'], json['thumbnail']);
  }
}

class StatusEffectModel {
  int EffectID;
  String effectName;
  String HunterSuffer;
  String MonsterSuffer;
  String thumbnail;

  StatusEffectModel(this.EffectID, this.effectName, this.HunterSuffer,
      this.MonsterSuffer, this.thumbnail);

  factory StatusEffectModel.fromJson(Map<String, dynamic> json) {
    return StatusEffectModel(json['effect_id'], json['effect_name'],
        json['hunter_suffer'], json['monster_suffer'], json['thumbnail']);
  }
}
