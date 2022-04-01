import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shnuljoe/Controller/SettingsController.dart';
import 'package:shnuljoe/Views/Screens/settings/widgets/customTile.dart';
import 'package:shnuljoe/Views/Screens/settings/widgets/switchWidget.dart';

import '../../../Controller/LocationController.dart';
import '../../../Controller/PagesDataController.dart';
import '../../Component/MainPageCard.dart';
import '../../styles/colors.dart';
import '../../styles/textStyles.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with WidgetsBindingObserver {
  var provider;
  @override
  void initState() {
    provider = Provider.of<SettingsController>(context, listen: false);
    provider.init();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    var codes =
        Provider.of<PagesDataController>(context, listen: false).bgsCode;
    if (state == AppLifecycleState.resumed) {
      print("##########Resumed");
      if (Provider.of<LocationController>(context, listen: false).status) {
        if (codes.length >
            Provider.of<PagesDataController>(context, listen: false).index)
          provider.startPlayer(
              path: Audio(audioLink(codes[
                      Provider.of<PagesDataController>(context, listen: false)
                          .index]
                  .toString())));
      }
      // user returned to our app
    } else if (state == AppLifecycleState.inactive) {
      print("##########Paused");
      provider.stopPlayer();
      provider.stopKitchenPlayer();

      // app is inactive
    } else if (state == AppLifecycleState.paused) {
      // user is about quit our app temporally
      print("##########Paused");
      provider.stopPlayer();
      provider.stopKitchenPlayer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(builder: (context, provider, _) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 280.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.r),
                    bottomRight: Radius.circular(20.r),
                  ),
                  color: Color(0xFF42466C),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60.h,
                    ),
                    CircleAvatar(
                      radius: 42.r,
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          AssetImage("images/profilePlaceholder.png"),
                    ),
                    SizedBox(
                      height: 9.h,
                    ),
                    Text(
                      "سناء دبوس",
                      style: AppTextStyles.tempSmallStyle.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 14.h,
                    ),
                    Text(
                      "Sana-d@gmail.com",
                      style: AppTextStyles.smallTextStyle,
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 41.w,
                          height: 41.h,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 3,
                                    offset: Offset(0, 0))
                              ]),
                          child: GestureDetector(
                            onTap: () {},
                            child: SvgPicture.asset(
                              "icons/edit_icon.svg",
                              width: 10.w,
                              height: 10.h,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 18.w,
                        ),
                        Container(
                          width: 41.w,
                          height: 41.h,
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.w,
                            vertical: 15.h,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 3,
                                    offset: Offset(0, 0))
                              ]),
                          child: GestureDetector(
                            onTap: () {},
                            child: SvgPicture.asset(
                              "icons/logout_icon.svg",
                              width: 10.w,
                              height: 10.h,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              SwitchWidget(
                title: "الصوت",
                switchName:
                    provider.soundSwitched ? provider.turnOff : provider.turnOn,
                value: provider.soundSwitched,
                onChange: (value) => provider.toggleSwitchSound(value, context),
              ),
              SwitchWidget(
                title: "البيئة",
                switchName: provider.ambeinceSwitched
                    ? provider.turnOff
                    : provider.turnOn,
                value: provider.ambeinceSwitched,
                onChange: (value) => provider.toggleSwitch(value, context),
              ),
              CustomTile(
                title: "أطلب المساعدة",
              ),
              CustomTile(
                title: "قيمنا",
              ),
            ],
          ),
        ),
      );
    });
  }
}
