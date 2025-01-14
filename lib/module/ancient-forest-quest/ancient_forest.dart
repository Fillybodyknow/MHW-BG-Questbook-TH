import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mhw_quest_book/app_route/route.dart';
import 'package:mhw_quest_book/module/ancient-forest-quest/controller/AFcontroller.dart';
import 'package:mhw_quest_book/utility/fonts/text_style.dart';

class Ancientforest extends StatelessWidget {
  Afcontroller controller = Get.put(Afcontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: controller.loadMonstersData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Center(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: controller.AncientForest.map(
                    (monster) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.brown.shade400,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 50,
                                )),
                            onPressed: () {
                              controller.monster_select.value =
                                  monster.monsterId;
                              controller.getMonsterById(
                                  controller.monster_select.value);
                              print(controller.monster_select.value);
                              Get.toNamed(Routes.SelectQuest);
                            },
                            child: Text(
                              monster.monsterName,
                              style: TextAppStyle.textsBodySuperLargeProminent(
                                  color: Colors.white),
                            )),
                      );
                    },
                  ).toList()),
            );
          }
        },
      ),
    );
  }
}
