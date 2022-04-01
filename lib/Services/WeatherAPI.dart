//بسم الله الرحمن الرحيم
import 'dart:convert' as convert;
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shnuljoe/Controller/PagesDataController.dart';
import 'package:translator/translator.dart';

import 'FirebaseAPI.dart';

class WeatherAPI {
  List dayName = [];
  List temp = [];
  List weather = [];

  String _apiKey = "4715dbc3321f0e165a0eb1faf2b3bfaf";

  Future<void> makeRequest(double lat, double lon, BuildContext context) async {
    Stopwatch stopwatch = new Stopwatch()..start();
    print('inside make req lt:$lat, ln:$lon');
    String url =
        "https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=hourly,minutely,current,alerts&appid=$_apiKey";
    print('api url: ' + url.toString());
    Provider.of<PagesDataController>(context, listen: false).temps.clear();
    Provider.of<PagesDataController>(context, listen: false)
        .mealDescription
        .clear();
    Provider.of<PagesDataController>(context, listen: false).daysName.clear();
    Provider.of<PagesDataController>(context, listen: false).daysCode.clear();

    Provider.of<PagesDataController>(context, listen: false)
        .daysName
        .add("اليوم");
    Provider.of<PagesDataController>(context, listen: false)
        .daysName
        .add("بكرة");
    Provider.of<PagesDataController>(context, listen: false)
        .daysName
        .add("بعد بكرة");

    var response = await http.get(Uri.parse(url));
    print("response:  " + response.body);
    var json = await convert.jsonDecode(response.body);
    List days = json['daily'];

    for (var i = 0; i < 7; i++) {
      var day = days[i];
      if ((day["feels_like"]['day'] - 274).toInt() < 35) {
        log("ADay######### " + day["weather"][0]["main"].toString());
        switch (day["weather"][0]["main"].toString()) {
          case "Rain":
            {
              /* Provider.of<PagesDataController>(context, listen: false)
                  .weatherAudio
                  .add("images/rain_weather.mp3");*/
              Provider.of<PagesDataController>(context, listen: false)
                  .bgsCode
                  .add("rain");
              Provider.of<PagesDataController>(context, listen: false)
                  .description
                  .add("ماطر");
            }
            break;
          case "Thunderstorm":
            {
              /*Provider.of<PagesDataController>(context, listen: false)
                  .weatherAudio
                  .add("images/thunderstorm_weather.mp3");*/
              Provider.of<PagesDataController>(context, listen: false)
                  .bgsCode
                  .add("thunder");
              Provider.of<PagesDataController>(context, listen: false)
                  .description
                  .add("عاصفة رعدية");
            }
            break;
          case "Clouds":
            {
              Provider.of<PagesDataController>(context, listen: false)
                  .bgsCode
                  .add("cloudy");
              Provider.of<PagesDataController>(context, listen: false)
                  .description
                  .add("غائم");
              /*     Provider.of<PagesDataController>(context, listen: false)
                  .weatherAudio
                  .add("images/cloudy_weather.mp3");*/
            }
            break;
          case "Snow":
            {
/*              Provider.of<PagesDataController>(context, listen: false)
                  .weatherAudio
                  .add("images/rain_weather.mp3");*/
              Provider.of<PagesDataController>(context, listen: false)
                  .bgsCode
                  .add("snow");
              Provider.of<PagesDataController>(context, listen: false)
                  .description
                  .add("ثلج");
            }
            break;
          case "Clear":
            {
              /* Provider.of<PagesDataController>(context, listen: false)
                  .weatherAudio
                  .add("images/sunny_weather.mp3");*/
              Provider.of<PagesDataController>(context, listen: false)
                  .bgsCode
                  .add("sunny");
              Provider.of<PagesDataController>(context, listen: false)
                  .description
                  .add("شمس");
            }
            break;
        }
      } else {
        Provider.of<PagesDataController>(context, listen: false)
            .bgsCode
            .add("hot");
        Provider.of<PagesDataController>(context, listen: false)
            .description
            .add("الحار");
      }

      if ((day["feels_like"]['day'] - 274).toInt() < 10) {
        Provider.of<PagesDataController>(context, listen: false)
            .mealDescription
            .add("بارد");
        await Provider.of<FirebaseRequests>(context, listen: false)
            .coldWeatherRequest();
      } else if ((day["feels_like"]['day'] - 274).toInt() > 40) {
        Provider.of<PagesDataController>(context, listen: false)
            .mealDescription
            .add("حار");
        await Provider.of<FirebaseRequests>(context, listen: false)
            .hotWeatherRequest();
      } else {
        Provider.of<PagesDataController>(context, listen: false)
            .mealDescription
            .add("معتدل");
        await Provider.of<FirebaseRequests>(context, listen: false)
            .anyWeatherRequest();
      }

      Provider.of<PagesDataController>(context, listen: false)
          .temps
          .add((day["feels_like"]['day'] - 274).toInt().toString());
      Provider.of<PagesDataController>(context, listen: false).daysCode.add(
          DateTime.fromMicrosecondsSinceEpoch(day['dt'] * 1000000)
              .weekday
              .toString());
      final translator = GoogleTranslator();

      var counter2 = DateTime.fromMicrosecondsSinceEpoch(day['dt'] * 1000000);
      var month = DateFormat('MMMM').format(counter2);
      var translMonth = monthInArabic(month);
      var dayDate = DateFormat('dd').format(counter2);
      print(dayDate.toString() + "SSSSA");

      Provider.of<PagesDataController>(context, listen: false)
          .month
          .add(translMonth.toString());
      Provider.of<PagesDataController>(context, listen: false)
          .dayDate
          .add(dayDate.toString());

      if (i >= 3) {
        var counter =
            DateTime.fromMicrosecondsSinceEpoch(day['dt'] * 1000000).weekday;

        log("Week Day " + counter.toString() + "SSS");
        var counterPlus = counter;

        log("Week Day plus" + counterPlus.toString());
        switch (counterPlus) {
          case 1:
            {
              Provider.of<PagesDataController>(context, listen: false)
                  .daysName
                  .add("الاثنين");
            }
            break;

          case 2:
            {
              Provider.of<PagesDataController>(context, listen: false)
                  .daysName
                  .add("الثلاثاء");
            }
            break;

          case 3:
            {
              Provider.of<PagesDataController>(context, listen: false)
                  .daysName
                  .add("الاربعاء");
            }
            break;
          case 4:
            {
              Provider.of<PagesDataController>(context, listen: false)
                  .daysName
                  .add("الخميس");
            }
            break;
          case 5:
            {
              Provider.of<PagesDataController>(context, listen: false)
                  .daysName
                  .add("الجمعة");
            }
            break;
          case 6:
            {
              Provider.of<PagesDataController>(context, listen: false)
                  .daysName
                  .add("السبت");
            }
            break;
          case 7:
            {
              Provider.of<PagesDataController>(context, listen: false)
                  .daysName
                  .add("الأحد");
              //counterPlus=0;

            }
            break;
        }
        if (Provider.of<PagesDataController>(context, listen: false)
            .daysName
            .toString()
            .contains("الاثنين")) {}
      }
    }
    log('doSomething() executed in ${stopwatch.elapsed}');
  }

  String? monthInArabic(month) {
    switch (month) {
      case "January":
        {
          return "01"; //"كانون الثاني";
        }

      case "February":
        {
          return "02"; //"فبراير";
        }

      case "March":
        {
          return "03"; //"مارس";
        }

      case "April":
        {
          return "04"; //"أبريل";
        }

      case "May":
        {
          return "05"; //"مايو";
        }

      case "June":
        {
          return "06"; //"يونيو";
        }

      case "July":
        {
          return "07"; //"يوليو";
        }

      case "August":
        {
          return "08"; //"أغسطس";
        }

      case "September":
        {
          return "09"; //"سبتمبر";
        }

      case "October":
        {
          return "10"; //"أكتوبر";
        }

      case "November":
        {
          return "11"; //"نوفمبر";
        }

      case "December":
        {
          return "12"; //"ديسمبر";
        }
    }
  }
}
