import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mhw_quest_book/utility/fonts/text_style.dart';
import 'package:mhw_quest_book/app_route/route.dart';
import 'package:mhw_quest_book/module/ancient-forest-quest/controller/AFcontroller.dart';

class Main extends StatelessWidget {
  Afcontroller controller = Get.put(Afcontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                Get.toNamed(Routes.Campaign);
              },
              child: Text(
                "Quest Book",
                style: TextAppStyle.textsBodySuperLargeProminent(
                    color: Colors.white),
              ))),
    );
  }
}
