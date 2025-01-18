import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mhw_quest_book/app_route/route.dart';
import 'package:mhw_quest_book/app_route/page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: Routes.SelectAccount,
      getPages: AppPage.page,
      debugShowCheckedModeBanner: false,
    );
  }
}
