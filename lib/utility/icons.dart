class ArmorsRarityIcons {
  int rarity;
  int Armor_part;

  ArmorsRarityIcons({required this.rarity, required this.Armor_part});

  String GetIcon() {
    if (rarity == 1) {
      if (Armor_part == 1) {
        return "assets/img/equiments/armors/HelmR1.png";
      } else if (Armor_part == 2) {
        return "assets/img/equiments/armors/MailR1.png";
      } else if (Armor_part == 3) {
        return "assets/img/equiments/armors/GreavesR1.png";
      } else {
        return "";
      }
    } else if (rarity == 2) {
      if (Armor_part == 1) {
        return "assets/img/equiments/armors/HelmR2.png";
      } else if (Armor_part == 2) {
        return "assets/img/equiments/armors/MailR2.png";
      } else if (Armor_part == 3) {
        return "assets/img/equiments/armors/GreavesR2.png";
      } else {
        return "";
      }
    } else if (rarity == 3) {
      if (Armor_part == 1) {
        return "assets/img/equiments/armors/HelmR3.png";
      } else if (Armor_part == 2) {
        return "assets/img/equiments/armors/MailR3.png";
      } else if (Armor_part == 3) {
        return "assets/img/equiments/armors/GreavesR3.png";
      } else {
        return "";
      }
    } else if (rarity == 4) {
      if (Armor_part == 1) {
        return "assets/img/equiments/armors/HelmR4.png";
      } else if (Armor_part == 2) {
        return "assets/img/equiments/armors/MailR4.png";
      } else if (Armor_part == 3) {
        return "assets/img/equiments/armors/GreavesR4.png";
      } else {
        return "";
      }
    } else {
      return "";
    }
  }
}

class WeaponsRarityIcons {
  int rarity;
  int Weaponclass;

  WeaponsRarityIcons({required this.rarity, required this.Weaponclass});

  String GetIcon() {
    if (rarity == 1) {
      if (Weaponclass == 1) {
        return "assets/img/equiments/weapons/greatswordR1.png";
      } else if (Weaponclass == 2) {
        return "assets/img/equiments/weapons/bowR1.png";
      } else if (Weaponclass == 3) {
        return "assets/img/equiments/weapons/dual-bladeR1.png";
      } else if (Weaponclass == 4) {
        return "assets/img/equiments/weapons/sword-shieldR1.png";
      } else {
        return "";
      }
    } else if (rarity == 2) {
      if (Weaponclass == 1) {
        return "assets/img/equiments/weapons/greatswordR2.png";
      } else if (Weaponclass == 2) {
        return "assets/img/equiments/weapons/bowR2.png";
      } else if (Weaponclass == 3) {
        return "assets/img/equiments/weapons/dual-bladeR2.png";
      } else if (Weaponclass == 4) {
        return "assets/img/equiments/weapons/sword-shieldR2.png";
      } else {
        return "";
      }
    } else if (rarity == 3) {
      if (Weaponclass == 1) {
        return "assets/img/equiments/weapons/greatswordR3.png";
      } else if (Weaponclass == 2) {
        return "assets/img/equiments/weapons/bowR3.png";
      } else if (Weaponclass == 3) {
        return "assets/img/equiments/weapons/dual-bladeR3.png";
      } else if (Weaponclass == 4) {
        return "assets/img/equiments/weapons/sword-shieldR3.png";
      } else {
        return "";
      }
    } else if (rarity == 4) {
      if (Weaponclass == 1) {
        return "assets/img/equiments/weapons/greatswordR4.png";
      } else if (Weaponclass == 2) {
        return "assets/img/equiments/weapons/bowR4.png";
      } else if (Weaponclass == 3) {
        return "assets/img/equiments/weapons/dual-bladeR4.png";
      } else if (Weaponclass == 4) {
        return "assets/img/equiments/weapons/sword-shieldR4.png";
      } else {
        return "";
      }
    } else {
      return "";
    }
  }
}
