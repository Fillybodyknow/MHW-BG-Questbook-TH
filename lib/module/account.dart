import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mhw_quest_book/module/save-hunter/model/hunter_model.dart';
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
      body: FutureBuilder(
          future: Hcontrol.loadAccounts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Center(
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
                          HunterClassModel? hunterClass = Hcontrol
                              .hunterClassesList.value
                              .firstWhereOrNull((element) =>
                                  element.hunter_class_id ==
                                  account.hunter_class_id);
                          return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.brown.shade400,
                                border:
                                    Border.all(color: Colors.black, width: 1)),
                            child: InkWell(
                              onTap: () {
                                Hcontrol.selectHunter(account);
                                //Hcontrol.PrintSelectedHunter();
                                Get.toNamed(Routes.Root);
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          width: 50,
                                          height: 50,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Image.asset(
                                            hunterClass!.thumbnail,
                                            fit: BoxFit.cover,
                                            alignment: Alignment.center,
                                          )),
                                      SizedBox(width: 20),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "Hunter Name : \n${account.hunter_name}",
                                              style: TextAppStyle
                                                  .textsBodyMediumProminent()),
                                          Text(
                                              "\nCampiagn Day : ${account.campaign_day}",
                                              style: TextAppStyle
                                                  .textsBodyMediumProminent())
                                        ],
                                      )
                                    ],
                                  ),
                                  IconButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.red.shade900),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        showdialogDelete(
                                            context, account.hunter_id);
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
                        backgroundColor:
                            MaterialStateProperty.all(Colors.brown.shade400),
                      ),
                      onPressed: () => _showCreateAccountDialog(context),
                      child: SizedBox(
                        height: 80,
                        width: 160,
                        child: Icon(
                          Icons.add_circle_sharp,
                          size: 50,
                          color: Colors.white,
                        ),
                      )),
                ]),
              );
            }
          }),
    );
  }

  void _showCreateAccountDialog(BuildContext context) {
    // แสดง Dialog เพื่อให้ user ใส่ชื่อ
    String newAccountName = '';
    Rxn<HunterClassModel> selectClass =
        Rxn<HunterClassModel>(); // ใช้ Rxn สำหรับค่าเริ่มต้นเป็น null
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
                    Obx(
                      () => DropdownButton<HunterClassModel>(
                        isExpanded: true, // เพิ่ม isExpanded
                        dropdownColor: Colors.brown.shade500,
                        items: Hcontrol.hunterClassesList
                            .map<DropdownMenuItem<HunterClassModel>>(
                                (HunterClassModel value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Row(
                              children: [
                                Image.asset(value.thumbnail,
                                    width: 30, height: 30),
                                SizedBox(width: 10),
                                Text(value.hunter_class_name),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (HunterClassModel? v) {
                          selectClass.value = v;
                          print('Selected class: ${v?.hunter_class_name}');
                        },
                        value: selectClass.value,
                        hint: Text(
                          "เลือกคลาส*",
                          style: TextAppStyle.textsBodyLargeProminent(
                              color: Colors.white),
                        ),
                        style: TextAppStyle.textsBodyLargeProminent(
                            color: Colors.white),
                        alignment: Alignment.center,
                      ),
                    ),
                    SizedBox(height: 20),
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
                          if (newAccountName.isEmpty ||
                              selectClass.value == null) {
                            // แสดงข้อความเตือนหากไม่มีการกรอกข้อมูลครบถ้วน
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                'กรุณากรอกชื่อและเลือกคลาส',
                                style: TextAppStyle.textsBodyLargeProminent(
                                    color: Colors.red),
                              )),
                            );
                            return;
                          }
                          Navigator.pop(context);
                          print(
                              'Saving class: ${selectClass.value?.hunter_class_name}');
                          Hcontrol.createNewAccount(newAccountName,
                              selectClass.value!.hunter_class_id);
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

  void showdialogDelete(BuildContext context, int HunterID) {
    // แสดง Dialog เพื่อให้ user ใส่ชื่อ
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
                      "ต้องการจะลบข้อมูลนี้หรือไม่",
                      //textAlign: TextAlign.center,
                      style: TextAppStyle.textsBodyLargeProminent(
                          color: Colors.white),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.red.shade900,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 20,
                                )),
                            onPressed: () {
                              Navigator.pop(context);
                              Hcontrol.deleteAccount(HunterID);
                            },
                            child: Text(
                              "ลบ",
                              style: TextAppStyle.textsBodyLargeProminent(
                                  color: Colors.white),
                            )),
                        TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 20,
                                )),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "ยกเลิก",
                              style: TextAppStyle.textsBodyLargeProminent(
                                  color: Colors.white),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ));
      },
    );
  }
}
