import 'dart:convert';

class QuestModel {
  final int questId;
  final String questType;
  final int difficultyLevel;
  final int timeLimit;
  final List<int> scoutflyLevel;
  final List<int> startingPoint;

  QuestModel({
    required this.questId,
    required this.questType,
    required this.difficultyLevel,
    required this.timeLimit,
    required this.scoutflyLevel,
    required this.startingPoint,
  });

  factory QuestModel.fromJson(Map<String, dynamic> json) {
    return QuestModel(
      questId: json['quest_id'],
      questType: json['quest_type'],
      difficultyLevel: json['difficulty_level'],
      timeLimit: json['time_limit'],
      scoutflyLevel: List<int>.from(json['scoutfly_level']),
      startingPoint: List<int>.from(json['starting_point']),
    );
  }
}

class DialogModel {
  final int dialogId;
  final String? title;
  final String subtitle;
  final String? consequences;
  final List<ActionModel> actions;

  DialogModel({
    required this.dialogId,
    this.title,
    required this.subtitle,
    this.consequences,
    required this.actions,
  });

  factory DialogModel.fromJson(Map<String, dynamic> json) {
    var actionsList = (json['actions'] as List)
        .map((actionJson) => ActionModel.fromJson(actionJson))
        .toList();

    return DialogModel(
      dialogId: json['dialog_id'],
      title: json['title'],
      subtitle: json['subtitle'],
      consequences: json['consequences'],
      actions: actionsList,
    );
  }
}

class ActionModel {
  final int actionId;
  final String? title;
  final String? consequences;
  final int? pathToDialog;
  final String? required_dialog;

  ActionModel(
      {required this.actionId,
      this.title,
      this.consequences,
      this.pathToDialog,
      this.required_dialog});

  factory ActionModel.fromJson(Map<String, dynamic> json) {
    return ActionModel(
      actionId: json['action_id'],
      title: json['title'],
      consequences: json['consequences'],
      required_dialog: json['required_dialog'],
      pathToDialog: json['PathToDialog'],
    );
  }
}

class MonsterModel {
  final int monsterId;
  final String monsterName;
  final List<int> dialogHuntingPhase;
  final List<QuestModel> quests;
  final List<DialogModel> questDialogs;
  final String? thumbnail;
  final List<String> special_attack_card;

  MonsterModel({
    required this.monsterId,
    required this.monsterName,
    required this.dialogHuntingPhase,
    required this.quests,
    required this.questDialogs,
    required this.thumbnail,
    required this.special_attack_card,
  });

  factory MonsterModel.fromJson(Map<String, dynamic> json) {
    var questsList = (json['quest'] as List)
        .map((questJson) => QuestModel.fromJson(questJson))
        .toList();
    var dialogsList = (json['quest_dialogs'] as List)
        .map((dialogJson) => DialogModel.fromJson(dialogJson))
        .toList();

    return MonsterModel(
      monsterId: json['monster_id'],
      monsterName: json['monster_name'],
      dialogHuntingPhase: List<int>.from(json['dialog_hunting_phase']),
      quests: questsList,
      questDialogs: dialogsList,
      thumbnail: json['thumbnail'],
      special_attack_card: List<String>.from(json['special_attack_card']),
    );
  }
}

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

class HunterDataModel {
  final List<AttemptedQuestModel> attemptedQuest;

  HunterDataModel({
    required this.attemptedQuest,
  });

  factory HunterDataModel.fromJson(Map<String, dynamic> json) {
    return HunterDataModel(
      attemptedQuest: (json['attempted_quest'] as List)
          .map((quest) => AttemptedQuestModel.fromJson(quest))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attempted_quest': attemptedQuest.map((quest) => quest.toJson()).toList(),
    };
  }
}
