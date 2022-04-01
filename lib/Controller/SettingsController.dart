import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shnuljoe/Controller/PagesDataController.dart';

import '../Views/Component/MainPageCard.dart';

class SettingsController extends ChangeNotifier {
  bool soundSwitched = false;
  bool ambeinceSwitched = false;
  String turnOn = "إفتح";
  String turnOff = "أغلق";
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  AssetsAudioPlayer audioPlayerKitchen = AssetsAudioPlayer();
  AssetsAudioPlayer audioPlayerSwipe = AssetsAudioPlayer();

  init() {
    startKitchenPlayer();
    startPlayer();
  }

  startPlayer({path, context}) async {
    SharedPreferences prf = await SharedPreferences.getInstance();
    var codes =
        Provider.of<PagesDataController>(context, listen: false).bgsCode;
    if (path == null) {
      path = Audio(audioLink(
          codes[Provider.of<PagesDataController>(context, listen: false).index]
              .toString()));
      // path = Audio(audioLink(codes[pageNumber].toString()));
    }
    bool vCheck = prf.getBool("vCheck") ?? true;

    if (vCheck == true) {
      assetsAudioPlayer.open(
        path,
        loopMode: LoopMode.single,
        // respectSilentMode: vCheck ?? false,
      );
    }
  }

  void toggleSwitch(bool value, context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (ambeinceSwitched == false) {
      startPlayer();
      ambeinceSwitched = true;
      pref.setBool("vCheck", ambeinceSwitched);
      notifyListeners();

      print('Switch Button is OhhhN');
    } else {
      clickOnMuteEvent(context);

      stopPlayer();
      ambeinceSwitched = false;

      pref.setBool("vCheck", ambeinceSwitched);
      notifyListeners();
      print('Switch Button is OFF');
    }
  }

  void toggleSwitchSound(bool value, context) async {
    print(value);
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (soundSwitched == false) {
      // audioPlayerKitchen.setVolume(1);
      startKitchenPlayer();
      audioPlayerSwipe.setVolume(1);

      //audioPlayerTwo.stop();

      soundSwitched = true;
      notifyListeners();
      pref.setBool("vsCheck", soundSwitched);

      print('Switch Button is OhhhN');
    } else {
      // audioPlayerTwo.stop();

      soundSwitched = false;
      pref.setBool("vsCheck", soundSwitched);
      clickOnMuteEvent(context);

      //audioPlayerKitchen.setVolume(0);
      stopKitchenPlayer();
      audioPlayerSwipe.setVolume(0);
      notifyListeners();
      print('Switch Button is OFF');
    }
  }

  Future clickOnMuteEvent(BuildContext context) async {
    FirebaseAnalytics analytics =
        Provider.of<FirebaseAnalytics>(context, listen: false);
    await analytics.logEvent(
      name: 'Click_On_Mute',
      parameters: <String, dynamic>{
        ''
            'Click_On_Mute': "Success",
      },
    );
  }

  stopPlayer() async {
    assetsAudioPlayer.stop();
    //assetsAudioPlayer.dispose();
  }

  startKitchenPlayer() async {
    SharedPreferences prf = await SharedPreferences.getInstance();

    // prf.getBool("vsCheck");
    bool vCheck = prf.getBool("vsCheck") ?? true;
    if (vCheck) {
      await audioPlayerKitchen.open(
        Audio(
          "images/kitchen.mp3",
        ),
        loopMode: LoopMode.single,
        // respectSilentMode: vCheck ?? false,
      );
      print(audioPlayerKitchen.playerState.value);
    }
  }

  stopKitchenPlayer() {
    audioPlayerKitchen.stop();
  }

  @override
  void dispose() {
    audioPlayerSwipe.dispose();
    audioPlayerKitchen.dispose();
    assetsAudioPlayer.dispose();
    super.dispose();
  }
}
