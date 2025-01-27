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
      appBar: AppBar(
        backgroundColor: Colors.brown.shade400,
        title: Text(
          "Ancient Forest",
          style: TextAppStyle.textsHeaderLargeProminent(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: controller.SelectedQuestCampaign.value == 1
            ? controller.loadMonstersAncientForestData()
            : controller.SelectedQuestCampaign.value == 2
                ? controller.loadMonstersWildspireWasteData()
                : Future.delayed(Duration.zero),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: controller.AncientForest.map(
                      (monster) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.brown.shade400,
                                      minimumSize: Size(double.infinity, 0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 30,
                                        vertical: 50,
                                      )),
                                  onPressed: () {
                                    //controller.loadHunterData();
                                    controller.monster_select.value =
                                        monster.monsterId;
                                    controller.getMonsterById(
                                        controller.monster_select.value);

                                    Get.toNamed(Routes.SelectQuest);
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(15),
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.25),
                                                spreadRadius: 2,
                                                blurRadius: 8,
                                                offset: Offset(0, 3),
                                              ),
                                            ]),
                                        child: Image.asset(
                                            monster.thumbnail.toString()),
                                      ),
                                      SizedBox(height: 50),
                                      Text(
                                        monster.monsterName,
                                        textAlign: TextAlign.center,
                                        style: TextAppStyle
                                            .textsBodySuperLargeProminent(
                                                color: Colors.white),
                                      )
                                    ],
                                  ))
                            ],
                          ),
                        );
                      },
                    ).toList()),
              ),
            );
          }
        },
      ),
    );
  }
}
