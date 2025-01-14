import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mhw_quest_book/module/ancient-forest-quest/controller/AFcontroller.dart';
import 'package:mhw_quest_book/utility/fonts/text_style.dart';

class GetheringPhase extends StatelessWidget {
  Afcontroller controller = Get.put(Afcontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 217, 209),
      body: Obx(() => Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    controller.Monster!.value.thumbnail!,
                    scale: 1.5,
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
                          onTap: () {
                            if (controller.Monster!.value.dialogHuntingPhase
                                .contains(
                                    controller.dialog_select.value.dialogId)) {
                              Get.back();
                            } else {
                              controller.getDialogById(action.pathToDialog!,
                                  controller.monster_select.value);
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
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w600),
                                      ),
                                //SizedBox(height: 5),
                                action.consequences == "" ||
                                        action.consequences == null
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
          )),
    );
  }
}
