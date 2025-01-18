import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:mhw_quest_book/app_route/route.dart';
import 'package:mhw_quest_book/module/ancient-forest-quest/controller/AFcontroller.dart';
import 'package:mhw_quest_book/module/ancient-forest-quest/model/AFmodel.dart';
import 'package:mhw_quest_book/utility/fonts/text_style.dart';

import 'package:mhw_quest_book/module/save-hunter/controller/hunter_control.dart';

class selectQuest extends StatelessWidget {
  Afcontroller controller = Get.put(Afcontroller());

  HunterControl hunterControl = Get.put(HunterControl());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown.shade400,
          title: Text(
            controller.Monster!.value.monsterName,
            style: TextAppStyle.textsHeaderLargeProminent(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.only(top: 25),
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: Image.asset(controller.Monster!.value.thumbnail!),
                ),
                Column(
                  children: controller.Monster!.value.quests.map((quest) {
                    return Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 25, horizontal: 40),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.brown.shade400,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              spreadRadius: 6,
                              blurRadius: 8,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ]),
                      child: InkWell(
                        onTap: () {
                          controller.isShowConsequences.value = true;
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Attempted:",
                                    style: TextAppStyle.textsBodyMedium(
                                        color: Colors.white),
                                  ),
                                  Obx(() {
                                    int attempted = 0;
                                    for (var quest2 in hunterControl
                                        .hunterData.value!.attemptedQuest) {
                                      if (quest2.monsterId ==
                                              controller.monster_select.value &&
                                          quest2.questId == quest.questId) {
                                        // แสดงผล attempted ของเควสนี้

                                        attempted = quest2.attempted.length;
                                      }
                                    }
                                    return Text(
                                      attempted.toString(),
                                      style: TextAppStyle.textsBodyMedium(
                                          color: Colors.white),
                                    );
                                  })
                                  // Row(
                                  //   children:
                                  //       quest.startingPoint.map((point) {
                                  //     return Row(
                                  //       children: [
                                  //         Text(
                                  //           point.toString(),
                                  //           style: TextAppStyle
                                  //               .textsBodyMedium(
                                  //                   color: Colors.white),
                                  //         ),
                                  //         point !=
                                  //                 quest.startingPoint.last
                                  //             ? Text(
                                  //                 " , ",
                                  //                 style: TextAppStyle
                                  //                     .textsBodyMedium(
                                  //                         color: Colors
                                  //                             .white),
                                  //               )
                                  //             : SizedBox.shrink(),
                                  //       ],
                                  //     );
                                  //   }).toList(),
                                  // )
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
        ));
  }

  // ฟังก์ชันสำหรับแสดง PopUpDialog
  void QuestPopup(BuildContext context, QuestModel quest) {
    controller.quest_select_starting_point.value =
        quest.startingPoint.first; // ค่าเริ่มต้นเป็นจุดแรก

    controller.quest_select.value = quest.questId;

    RxList<int> Attempted_Set = <int>[].obs;

    // อัปเดต Attempted_Set ภายนอก Obx ก่อนแสดง Dialog
    for (var QS in quest.startingPoint) {
      Attempted_Set.add(QS); // เก็บค่า Starting Point
    }

    for (var Hunter in hunterControl.hunterData.value!.attemptedQuest) {
      if (Hunter.monsterId == controller.monster_select.value &&
          Hunter.questId == quest.questId) {
        for (var attempted in Hunter.attempted) {
          Attempted_Set.remove(attempted);
        }
      }
    }

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
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  Obx(() {
                    // แสดงผลจำนวนรอบที่เหลือ
                    return Text(
                      ":จำนวนรอบที่สามารถออกสำรวจได้:\n${Attempted_Set.length}",
                      style: TextAppStyle.textsBodyMedium(color: Colors.white),
                      textAlign: TextAlign.center,
                    );
                  }),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Obx(() => Attempted_Set.isNotEmpty
                              ? TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    controller.getDialogById(
                                        Attempted_Set.first,
                                        controller.monster_select.value);
                                    controller.Scoutfly_level.value = [
                                      quest.scoutflyLevel[0].toString(),
                                      quest.scoutflyLevel[1].toString()
                                    ];
                                    controller.quest_select_starting_point
                                        .value = Attempted_Set.first;
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
                              : SizedBox.shrink()),
                          SizedBox(
                            height: 10,
                          ),
                          TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await hunterControl.resetAttemptedQuest(
                                    controller.monster_select.value,
                                    quest.questId);
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
                                "Reset Quest",
                                style: TextAppStyle.textsBodyLargeProminent(
                                    color: Colors.brown.shade400),
                              )),
                          SizedBox(
                            height: 25,
                          ),
                          Obx(() {
                            // แสดงผลจำนวนรอบที่เหลือ
                            return InkWell(
                              onTap: () {
                                controller.isShowConsequences.value =
                                    !controller.isShowConsequences.value;
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    controller.isShowConsequences.value
                                        ? Icons.check_box_outline_blank_sharp
                                        : Icons.check_box,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "ซ่อนผลที่ตามมาจากการเลือกเส้นทาง",
                                    style: TextAppStyle.textsBodyMedium(
                                        color: Colors.white60),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            );
                          }),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
