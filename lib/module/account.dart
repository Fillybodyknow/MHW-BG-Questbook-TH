import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mhw_quest_book/utility/fonts/text_style.dart';
import 'package:mhw_quest_book/module/save-hunter/controller/hunter_control.dart';
import 'package:mhw_quest_book/app_route/route.dart';

class Account extends StatelessWidget {
  HunterControl Hcontrol = Get.put(HunterControl());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown.shade400,
        title: Text(
          "Choose Your Character",
          style: TextAppStyle.textsHeaderLargeProminent(color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color.fromARGB(255, 241, 217, 209),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            "Saved Character",
            style: TextAppStyle.textsBodySuperLargeProminent(),
          ),
          const SizedBox(height: 20),
          Obx(() {
            if (Hcontrol.accounts.isEmpty) {
              return const SizedBox.shrink();
            } else {
              return Column(
                children: Hcontrol.accounts.map((account) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.brown.shade400,
                        border: Border.all(color: Colors.black, width: 1)),
                    child: InkWell(
                      onTap: () {
                        Hcontrol.selectHunter(account);
                        Hcontrol.PrintSelectedHunter();
                        Get.toNamed(Routes.Root);
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              SizedBox(width: 20),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Hunter Name : ${account.hunter_name}",
                                      style: TextAppStyle
                                          .textsBodyMediumProminent()),
                                  Text("Campiagn Day : ${account.campaign_day}",
                                      style: TextAppStyle
                                          .textsBodyMediumProminent())
                                ],
                              )
                            ],
                          ),
                          IconButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.red.shade900),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                Hcontrol.deleteAccount(account.hunter_id);
                              },
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.white,
                                size: 20,
                              ))
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          }),
          SizedBox(height: 20),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.brown.shade400),
            ),
            onPressed: () => _showCreateAccountDialog(context),
            child: Icon(
              Icons.add_circle_sharp,
              size: 50,
              color: Colors.white,
            ),
          ),
        ]),
      ),
    );
  }

  void _showCreateAccountDialog(BuildContext context) {
    // แสดง Dialog เพื่อให้ user ใส่ชื่อ
    String newAccountName = '';
    showDialog(
      context: context,
      builder: (context) {
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
                      "กรอกข้อมูลเพื่อสร้าง Save",
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
                      child: TextField(
                        style: TextAppStyle.textsHeaderLargeProminent(
                            color: Colors.white),
                        onChanged: (value) {
                          newAccountName = value;
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "ชื่อ Hunter",
                          hintStyle: TextAppStyle.textsBodyLargeProminent(
                              color: Colors.white),
                        ),
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
                          if (newAccountName == '') return;
                          Hcontrol.createNewAccount(newAccountName);
                        },
                        child: Text(
                          "Create New Save",
                          style: TextAppStyle.textsBodyLargeProminent(
                              color: Colors.brown.shade400),
                        ))
                  ],
                ),
              ),
            ));
      },
    );
  }
}
