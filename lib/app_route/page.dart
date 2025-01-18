import 'package:get/get.dart';
import 'package:mhw_quest_book/module/ancient-forest-quest/ancient_forest.dart';
import 'package:mhw_quest_book/module/ancient-forest-quest/view/gethering_phase.dart';
import 'package:mhw_quest_book/module/ancient-forest-quest/view/select_quest.dart';
import 'package:mhw_quest_book/module/save-hunter/save-hunter.dart';
import 'package:mhw_quest_book/module/save-hunter/view/add_item.dart';
import 'package:mhw_quest_book/module/account.dart';
import 'package:mhw_quest_book/app_route/route.dart';
import 'package:mhw_quest_book/module/main.dart';
import 'package:mhw_quest_book/module/campaign.dart';

class AppPage {
  static final List<GetPage> page = [
    GetPage(
      name: Routes.Root,
      page: () => Main(),
    ),
    GetPage(
      name: Routes.Ancientforest,
      page: () => Ancientforest(),
    ),
    GetPage(name: Routes.SelectQuest, page: () => selectQuest()),
    GetPage(name: Routes.GetheringPhase, page: () => GetheringPhase()),
    GetPage(name: Routes.Campaign, page: () => Campaign()),
    GetPage(name: Routes.SelectAccount, page: () => Account()),
    GetPage(name: Routes.SaveHunter, page: () => Savehunter()),
    GetPage(name: Routes.AddItem, page: () => AddItem()),
  ];
}
