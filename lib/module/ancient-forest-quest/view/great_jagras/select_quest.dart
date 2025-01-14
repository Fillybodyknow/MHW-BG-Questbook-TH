import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:mhw_quest_book/app_route/route.dart';
import 'package:mhw_quest_book/module/ancient-forest-quest/controller/AFcontroller.dart';
import 'package:mhw_quest_book/module/ancient-forest-quest/model/AFmodel.dart';
import 'package:mhw_quest_book/utility/fonts/text_style.dart';

class selectQuest extends StatelessWidget {
  Afcontroller controller = Get.put(Afcontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.Monster!.value.monsterName,
          style: TextAppStyle.textsBodySuperLargeProminent(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Image.asset(controller.Monster!.value.thumbnail!),
              Column(
                children: controller.Monster!.value.quests.map((quest) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 25, horizontal: 40),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.brown.shade400,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            spreadRadius: 6,
                            blurRadius: 8,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ]),
                    child: InkWell(
                      onTap: () {
                        QuestPopup(context, quest);
                      },
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                                List.generate(quest.difficultyLevel, (index) {
                              return Icon(
                                Icons.star,
                                color: quest.difficultyLevel == 1
                                    ? Colors.blue.shade100
                                    : Colors.red,
                                size: 30,
                              );
                            }),
                          ),
                          SizedBox(height: 25),
                          Text(
                            quest.questType,
                            style: TextAppStyle.textsBodyLargeProminent(
                                color: Colors.white),
                          ),
                          SizedBox(height: 50),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Time limit :",
                                  style: TextAppStyle.textsBodyMedium(
                                      color: Colors.white),
                                ),
                                Text(
                                  "${quest.timeLimit.toString()} Time card",
                                  style: TextAppStyle.textsBodyMedium(
                                      color: Colors.white),
                                )
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Scoutfly Level:",
                                  style: TextAppStyle.textsBodyMedium(
                                      color: Colors.white),
                                ),
                                Text(
                                  "${quest.scoutflyLevel[0]} - ${quest.scoutflyLevel[1]}",
                                  style: TextAppStyle.textsBodyMedium(
                                      color: Colors.white),
                                )
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Starting Point:",
                                  style: TextAppStyle.textsBodyMedium(
                                      color: Colors.white),
                                ),
                                Row(
                                  children: quest.startingPoint.map((point) {
                                    return Row(
                                      children: [
                                        Text(
                                          point.toString(),
                                          style: TextAppStyle.textsBodyMedium(
                                              color: Colors.white),
                                        ),
                                        point != quest.startingPoint.last
                                            ? Text(
                                                " , ",
                                                style: TextAppStyle
                                                    .textsBodyMedium(
                                                        color: Colors.white),
                                              )
                                            : SizedBox.shrink(),
                                      ],
                                    );
                                  }).toList(),
                                )
                              ])
                        ],
                      ),
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }

  // ฟังก์ชันสำหรับแสดง PopUpDialog
  void QuestPopup(BuildContext context, QuestModel quest) {
    controller.quest_select_starting_point.value =
        quest.startingPoint.first; // ค่าเริ่มต้นเป็นจุดแรก

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.brown.shade400,
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(quest.difficultyLevel, (index) {
                      return Icon(
                        Icons.star,
                        color: quest.difficultyLevel == 1
                            ? Colors.blue.shade100
                            : Colors.red,
                        size: 30,
                      );
                    }),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    quest.questType,
                    style: TextAppStyle.textsBodyLargeProminent(
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Obx(() => Text(
                        "เลือกจุดเริ่มต้นสำรวจ: ${controller.quest_select_starting_point.value}",
                        style:
                            TextAppStyle.textsBodyMedium(color: Colors.white),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children:
                            List.generate(quest.startingPoint.length, (index) {
                          return TextButton(
                            onPressed: () {
                              controller.quest_select_starting_point.value =
                                  quest.startingPoint[index];
                              //Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: controller
                                          .quest_select_starting_point.value ==
                                      quest.startingPoint[index]
                                  ? Colors.white
                                  : Colors.brown.shade400,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: Colors.white,
                                  )),
                            ),
                            child: Text(
                              quest.startingPoint[index].toString(),
                              style: TextAppStyle.textsBodyMedium(
                                  color: !(controller
                                              .quest_select_starting_point
                                              .value ==
                                          quest.startingPoint[index])
                                      ? Colors.white
                                      : Colors.brown.shade400),
                            ),
                          );
                        }),
                      )),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            controller.getDialogById(
                                controller.quest_select_starting_point.value,
                                controller.monster_select.value);
                            controller.Scoutfly_level.value = [
                              quest.scoutflyLevel[0].toString(),
                              quest.scoutflyLevel[1].toString()
                            ];
                            print(controller.Scoutfly_level.value);
                            Get.toNamed(Routes.GetheringPhase);
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: Colors.white,
                                )),
                          ),
                          child: Text(
                            "เริ่มออกสำรวจ (Gethering Phase)",
                            style: TextAppStyle.textsBodyLargeProminent(
                                color: Colors.brown.shade400),
                          ))
                    ],
                  )
                ])));
      },
    );
  }
}
