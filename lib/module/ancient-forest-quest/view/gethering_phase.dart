import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mhw_quest_book/module/ancient-forest-quest/controller/AFcontroller.dart';
import 'package:mhw_quest_book/module/ancient-forest-quest/model/AFmodel.dart';
import 'package:mhw_quest_book/utility/fonts/text_style.dart';
import 'package:mhw_quest_book/module/save-hunter/controller/hunter_control.dart';
import 'package:mhw_quest_book/app_route/route.dart';

class GetheringPhase extends StatelessWidget {
  Afcontroller controller = Get.put(Afcontroller());
  HunterControl hunterControl = Get.put(HunterControl());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown.shade400,
        title: Text(
          controller.Monster!.value.monsterName,
          style: TextAppStyle.textsBodySuperLargeProminent(color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color.fromARGB(255, 241, 217, 209),
      body: Obx(
        () => Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.only(top: 20),
                  width: 150,
                  height: 150,
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
                SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.symmetric(
                          horizontal:
                              BorderSide(color: Colors.brown, width: 3))),
                  child: Center(
                      child: Text(
                    controller.dialog_select.value.title!,
                    style: TextAppStyle.textsBodyLargeProminent(
                        color: Colors.black),
                  )),
                ),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      controller.dialog_select.value.subtitle,
                      textAlign: TextAlign.center,
                      style:
                          TextAppStyle.textsBodyMedium(color: Colors.black54),
                    ),
                  ),
                ),
                controller.dialog_select.value.consequences == "" ||
                        controller.dialog_select.value.consequences == null
                    ? SizedBox.shrink()
                    : Container(
                        padding: const EdgeInsets.all(20.0),
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            controller.dialog_select.value.consequences!,
                            textAlign: TextAlign.center,
                            style: TextAppStyle.textsBodyLargeProminent(
                                color: Colors.black),
                          ),
                        ),
                      ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:
                      controller.dialog_select.value.actions.map((action) {
                    return InkWell(
                        onTap: () async {
                          if (controller.Monster!.value.dialogHuntingPhase
                              .contains(
                                  controller.dialog_select.value.dialogId)) {
                            await hunterControl.updateAttemptedQuest(
                                controller.monster_select.value,
                                controller.quest_select.value,
                                controller.quest_select_starting_point.value);
                            Get.back();
                          } else {
                            ConsequencesPopup(context, action);
                            // controller.getDialogById(action.pathToDialog!,
                            //     controller.monster_select.value);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.green.shade900,
                              border: Border.symmetric(
                                  horizontal: BorderSide(
                                      color: Colors.brown, width: 3))),
                          child: Column(
                            children: [
                              action.required_dialog == "" ||
                                      action.required_dialog == null
                                  ? SizedBox.shrink()
                                  : Column(
                                      children: [
                                        Text(
                                          "(${action.required_dialog})",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 5),
                                      ],
                                    ),
                              controller.Monster!.value.dialogHuntingPhase
                                      .contains(controller
                                          .dialog_select.value.dialogId)
                                  ? Image.asset(
                                      'assets/img/battle.png',
                                      scale: 5,
                                    )
                                  : SizedBox.shrink(),
                              action.title == "" || action.title == null
                                  ? SizedBox.shrink()
                                  : Text(
                                      action.title!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: !controller
                                                  .isShowConsequences.value
                                              ? Colors.white
                                              : Colors.white70,
                                          fontWeight: FontWeight.w600),
                                    ),
                              //SizedBox(height: 5),
                              ((action.consequences == "" ||
                                              action.consequences == null) ||
                                          !controller
                                              .isShowConsequences.value) &&
                                      !controller
                                          .Monster!.value.dialogHuntingPhase
                                          .contains(controller
                                              .dialog_select.value.dialogId)
                                  ? SizedBox.shrink()
                                  : Text(
                                      action.consequences!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: controller.Monster!.value
                                                  .dialogHuntingPhase
                                                  .contains(controller
                                                      .dialog_select
                                                      .value
                                                      .dialogId)
                                              ? Colors.red.shade100
                                              : Colors.white),
                                      textAlign: TextAlign.center,
                                    )
                            ],
                          ),
                        ));
                  }).toList(),
                ),
                !(controller.Monster!.value.dialogHuntingPhase
                        .contains(controller.dialog_select.value.dialogId))
                    ? SizedBox.shrink()
                    : Column(
                        children: [
                          SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(20.0),
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "นำโทเคนแกะลอยมารวมกัน และนำ \n'ท่าโจมตีพิเศษ' เข้า Monster Deck ตามตารางต่อไปนี้",
                              style: TextAppStyle.textsBodyLargeProminent(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          //SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(30.0),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "น้อยกว่า ${controller.Scoutfly_level.value[0]}",
                                        style: TextAppStyle.textsBodyMedium(),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        size: 40,
                                      ),
                                      Text(
                                        controller.Monster!.value
                                            .special_attack_card[0],
                                        style: TextAppStyle.textsBodyMedium(),
                                      ),
                                    ]),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "${controller.Scoutfly_level.value[0]} ถึง ${controller.Scoutfly_level.value[1]}",
                                        style: TextAppStyle.textsBodyMedium(),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        size: 40,
                                      ),
                                      Text(
                                        controller.Monster!.value
                                            .special_attack_card[1],
                                        style: TextAppStyle.textsBodyMedium(),
                                      ),
                                    ]),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "มากกว่า ${controller.Scoutfly_level.value[1]}",
                                        style: TextAppStyle.textsBodyMedium(),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        size: 40,
                                      ),
                                      Text(
                                        controller.Monster!.value
                                            .special_attack_card[2],
                                        style: TextAppStyle.textsBodyMedium(),
                                      ),
                                    ])
                              ],
                            ),
                          )
                        ],
                      )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.brown.shade400,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: Size(75, 75),
                ),
                child: Text(
                  "เปิด Inventory",
                  style: TextAppStyle.textsHeaderLargeProminent(
                      color: Colors.brown.shade400),
                ),
                onPressed: () {
                  Get.toNamed(Routes.SaveHunter);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void ConsequencesPopup(BuildContext context, ActionModel action) {
    // controller.getDialogById(action.pathToDialog!,
    //     controller.monster_select.value);

    String consequences = "";

    if (action.consequences == null || action.consequences == "") {
      consequences = "ไม่มีอะไรเกิดขึ้น";
    } else {
      consequences = action.consequences!;
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
                      Text(
                        "ผลลัพธ์ของเส้นทาง",
                        //textAlign: TextAlign.center,
                        style: TextAppStyle.textsBodyLargeProminent(
                            color: Colors.white),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        width: double.infinity,
                        child: Text(
                          consequences,
                          textAlign: TextAlign.center,
                          style: TextAppStyle.textsBodyLargeProminent(
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              )),
                          onPressed: () async {
                            Navigator.pop(context);
                            if (controller.Monster!.value.dialogHuntingPhase
                                .contains(action.pathToDialog!)) {
                              await hunterControl.updateAttemptedQuest(
                                  controller.monster_select.value,
                                  controller.quest_select.value,
                                  controller.quest_select_starting_point.value);
                            }
                            controller.getDialogById(action.pathToDialog!,
                                controller.monster_select.value);
                          },
                          child: Text(
                            "ไปต่อ",
                            style: TextAppStyle.textsBodyLargeProminent(
                                color: Colors.brown.shade400),
                          ))
                    ],
                  ),
                ),
              ));
        });
  }
}
