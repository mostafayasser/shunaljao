//@dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shnuljoe/Strings.dart';
import '../../Constants.dart';
import 'SevenDaysMenu.dart';

class GrocerList extends StatefulWidget {
  @override
  _GrocerListState createState() => _GrocerListState();
}

class _GrocerListState extends State<GrocerList> {
  List<bool> boolValue;
  var boolEdit = false;
  var boolDel = false;
  var boolAdd = false;
  int index;

  var getAllData;
  TextEditingController ingText = new TextEditingController();
  void initState() {
    super.initState();
    getAllData = getList("ItemList");
  }

  Widget build(BuildContext context) {
    final snackBar = SnackBar(
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      elevation: 6.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      content: Padding(
        padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 12.w,
            ),
            Transform.scale(
              scale: 1,
              child: GestureDetector(
                  onTap: () async {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  child: Icon(
                    Icons.close,
                    color: primaryColorPink,
                    size: 30,
                  )),
            ),
            SizedBox(
              width: 2.w,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: Text(
                  ingText.text,
                  style: h4Arial.apply(color: primaryColorBlue),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Transform.scale(
              scale: 1,
              child: Icon(
                Icons.add_shopping_cart,
                color: primaryColorPink,
                size: 30,
              ),
            )
          ],
        ),
      ),
      //backgroundColor: Colors.blue,
    );
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColorPink,
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Center(
            child: Text(
              'شن الجو',
              style: TextStyle(fontFamily: 'DG-Bebo'),
            ),
          ),
          actions: [
            Tooltip(
              //    key: _toolTipKey,
              decoration: BoxDecoration(
                color: primaryColorPink,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
              textStyle: TextStyle(color: Colors.white, fontSize: 12),
              verticalOffset: 20,
              padding: EdgeInsets.all(10),
              message: "اضغط للحصول على توقعات 7 ايام",
              // "Click to get 7 days forecast",
              child: GestureDetector(
                onTap: () async {
                  var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => SevenDaysMenu(),
                    ),
                  );
                  if (result == true) {}
                },
                child: SvgPicture.asset(
                  'images/menuR1.svg',
                  width: 20.w,
                ),
              ),
            ),
            SizedBox(width: 15.w),
          ],
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 15.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                        elevation: 20,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(150),
                        ),
                        child: Container(
                          width: 35.w,
                          height: 35.h,
                          decoration: BoxDecoration(
                              // The child of a round Card should be in round shape
                              shape: BoxShape.circle,
                              color: Colors.white),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                if (boolEdit == true) {
                                  setState(() {
                                    boolEdit = false;
                                  });
                                } else {
                                  setState(() {
                                    boolEdit = true;
                                  });
                                }
                              },
                              child: FaIcon(
                                FontAwesomeIcons.edit,
                                size: 17.h,
                                color: boolEdit == false
                                    ? Colors.grey
                                    : primaryColorPink,
                              ),
                            ),
                          ),
                        )),
                    Text(
                      'قائمة بقالة',
                      style: TextStyle(
                          fontFamily: 'DG-Bebo',
                          fontSize: 20.sp,
                          color: primaryColorPink),
                    ),
                    Card(
                        elevation: 20,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(150),
                        ),
                        child: Container(
                          width: 35.w,
                          height: 35.h,
                          decoration: BoxDecoration(
                              // The child of a round Card should be in round shape
                              shape: BoxShape.circle,
                              color: Colors.white),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                if (boolDel == true) {
                                  setState(() {
                                    boolDel = false;
                                  });
                                } else {
                                  setState(() {
                                    boolDel = true;
                                  });
                                }
                              },
                              child: FaIcon(
                                FontAwesomeIcons.plus,
                                size: 17.h,
                                color: boolDel == false
                                    ? Colors.grey
                                    : primaryColorPink,
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              boolDel == true
                  ? Padding(
                      padding: EdgeInsets.only(left: 10.0.w, right: 10.w),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: ingText,
                          textAlign: TextAlign.right,
                          maxLines: null,
                          onChanged: (text) {
                            setState(() {});
                          },
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                            hintText: "إضافة",
                            prefix: GestureDetector(
                              onTap: () async {
                                // widget.boolAdd  = false;
                                SharedPreferences pref =
                                    await SharedPreferences.getInstance();
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  if (ingText.text.trim().isEmpty) {
                                  } else {
                                    list.userSearchItems.add(ingText.text);

                                    boolValue = List<bool>.filled(
                                        list.userSearchItems.length, false);
                                    pref.setStringList(
                                        'ItemList', list.userSearchItems);
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                });
                              },
                              child: ingText.text.trim().isEmpty
                                  ? SizedBox()
                                  : FaIcon(
                                      FontAwesomeIcons.plus,
                                      size: 17.h,
                                      color: primaryColorPink,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              Expanded(
                child: FutureBuilder(
                    future: getAllData,
                    builder: (context, AsyncSnapshot snapshot) {
                      return Center(
                        child: snapshot.hasData
                            ? ListView.builder(
                                itemCount: list.userSearchItems.length,
                                itemBuilder: (context, i) {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 10.w,
                                            right: 10.w,
                                            top: 5.h,
                                            bottom: 5.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            boolEdit == true
                                                ? Transform.scale(
                                                    scale: 1.5,
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        SharedPreferences pref =
                                                            await SharedPreferences
                                                                .getInstance();
                                                        setState(() {
                                                          list.userSearchItems
                                                              .removeAt(i);

                                                          pref.setStringList(
                                                              'ItemList',
                                                              list.userSearchItems);
                                                        });
                                                      },
                                                      child: Icon(
                                                        Icons.remove_circle,
                                                        color: primaryColorPink,
                                                      ),
                                                    ))
                                                : SizedBox(),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(left: 20.w),
                                                child: Text(
                                                  list.userSearchItems[i],
                                                  style: h4Arial.apply(
                                                      color: primaryColorBlue),
                                                  textAlign: TextAlign.end,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Transform.scale(
                                                scale: 1.5,
                                                child: Checkbox(
                                                  checkColor: Colors.white,
                                                  activeColor:
                                                      Color(0xffEC008C),
                                                  side: BorderSide(
                                                    color:
                                                        primaryColorPink, //your desire colour here
                                                    width: 1,
                                                  ),
                                                  value: boolValue[i],
                                                  shape: CircleBorder(),
                                                  onChanged: (bool value) {
                                                    setState(() {
                                                      boolValue[i] = value;
                                                      if (boolValue[i]) {}
                                                    });
                                                  },
                                                )),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 25.w),
                                        child: Divider(
                                          color: Colors.grey.withOpacity(0.2),
                                          thickness: 1.5,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              )
                            : SizedBox(),
                      );
                    }),
              )
            ],
          ),
        ));
  }

  getList(String key) async {
    var pref = await SharedPreferences.getInstance();
    var getList = pref.getStringList(key) ?? [];

    if (list.userSearchItems.length == 0) {
      list.userSearchItems = getList;
    }

    boolValue = List<bool>.filled(list.userSearchItems.length, false);
    return list.userSearchItems;

    //   return list;
  }
}
