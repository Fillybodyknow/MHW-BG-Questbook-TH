import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mhw_quest_book/utility/fonts/text_style.dart';
import 'package:mhw_quest_book/app_route/route.dart';
import 'package:mhw_quest_book/module/ancient-forest-quest/controller/AFcontroller.dart';
import 'package:mhw_quest_book/module/save-hunter/controller/hunter_control.dart';

class Main extends StatelessWidget {
  Afcontroller controller = Get.put(Afcontroller());
  HunterControl hunterControl = Get.put(HunterControl());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 241, 217, 209),
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Text(
                      "Campaign Day",
                      style: TextAppStyle.textsBodySuperLargeProminent(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.brown.shade400),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if (hunterControl
                                      .hunterData.value!.campaign_day ==
                                  0) return;
                              hunterControl.hunterData.value!.campaign_day--;
                              await hunterControl.saveAccountData();
                            },
                            icon: Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 15,
                            )),
                        SizedBox(width: 10),
                        Obx(() => Text(
                              "${hunterControl.hunterData.value!.campaign_day} Days",
                              style: TextAppStyle.textsBodySuperLargeProminent(
                                  color: Colors.black),
                            )),
                        SizedBox(width: 10),
                        IconButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.brown.shade400),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              hunterControl.hunterData.value!.campaign_day++;
                              await hunterControl.saveAccountData();
                            },
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 15,
                            )),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 35),
                TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.brown.shade400,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 50,
                        )),
                    onPressed: () {
                      Get.toNamed(Routes.SaveHunter);
                    },
                    child: Text(
                      "Inventory",
                      style: TextAppStyle.textsBodySuperLargeProminent(
                          color: Colors.white),
                    )),
                SizedBox(height: 20),
                TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.brown.shade400,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 50,
                        )),
                    onPressed: () {
                      Get.toNamed(Routes.Campaign);
                    },
                    child: Text(
                      "Quest Book",
                      style: TextAppStyle.textsBodySuperLargeProminent(
                          color: Colors.white),
                    ))
              ],
            ),
          ),
        ));
  }
}
