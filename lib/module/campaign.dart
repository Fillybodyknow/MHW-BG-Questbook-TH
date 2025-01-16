import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mhw_quest_book/app_route/route.dart';
import 'package:mhw_quest_book/utility/fonts/text_style.dart';

class Campaign extends StatelessWidget {
  const Campaign({super.key});

  Widget CampaignBox(String name, String image, String route) {
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
                      borderRadius: BorderRadius.circular(20)),
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 50,
                  )),
              onPressed: () {
                Get.toNamed(route);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
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
                            offset: Offset(0, 3),
                          ),
                        ]),
                    child: Image.asset(image),
                  ),
                  SizedBox(height: 50),
                  Text(
                    name,
                    style: TextAppStyle.textsBodySuperLargeProminent(
                        color: Colors.white),
                  )
                ],
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown.shade400,
          title: Text(
            "Select Campaign",
            style: TextAppStyle.textsHeaderLargeProminent(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              CampaignBox("Ancient Forest", "assets/img/ancient_forest.webp",
                  Routes.Ancientforest)
            ]),
          ),
        ));
  }
}
