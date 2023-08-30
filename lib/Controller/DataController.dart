import 'dart:convert';
import 'package:home_widget/home_widget.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/DayMeal.dart';
import '../Model/news_data.dart';

class DataController {
  final String baseUrl = "https://xiipj5vqt1.execute-api.ap-northeast-2.amazonaws.com/items";

  Future<DayMeal> fetchDayMeal() async {
    DateTime now = DateTime.now();
    String endpoint = DateFormat('yyyyMMdd').format(now);

    endpoint = "20230829";

    final response = await http.get(Uri.parse("$baseUrl/$endpoint"));

    if (response.statusCode == 200) {
      Map<String, dynamic> dayMealJson = jsonDecode(utf8.decode(response.bodyBytes));
      saveData(endpoint, dayMealJson);
      return DayMeal.fromJson(dayMealJson);
    } else {
      throw Exception('http요청에 실패했습니다, ${response.statusCode}');
    }
  }

  void saveData(String id, Map<String,dynamic> dayMealMap) async {
    //given
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(id, json.encode(dayMealMap));
  }

  Future<DayMeal?> readData(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedMapString = prefs.getString(id);

    if(storedMapString == null) return null;

    Map<String, dynamic> storedMap = json.decode(storedMapString);

    return DayMeal.fromJson(storedMap);
  }

  void deleteData(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(id);
  }

  Future<DayMeal> loadData() async {
    DayMeal? data = await readData("20230829");
    data ??= await fetchDayMeal();

    if(data == null) {
      throw Exception('${20230829}가 없습니다');
    }

    return data;
  }

  void updateWidgetInfo(Map<String, dynamic> dayMealMap) {
    List<String> dormJson = dayMealMap['dormCafe']["meals"][0]["menus"];

    HomeWidget.saveWidgetData<String>('cafe_name', "dormCafe"); // 나중에 String말고 Map<String, dynamic>으로 저장할수있는지 테스트하기
    HomeWidget.saveWidgetData<String>('meals', json.encode(dormJson));

    HomeWidget.saveWidgetData<String>('lunchMenu4', '');
    HomeWidget.saveWidgetData<String>('lunchMenu5', '');
    HomeWidget.saveWidgetData<String>('lunchMenu6', '');

    dormJson.asMap().forEach((idx, menu) {
      HomeWidget.saveWidgetData<String>('lunchMenu${idx+1}', menu);
    }); // forEach말고 한번에 payload 보내는 방법 알아보기
  }
}
// "dormCafe": {
//   "name": "기숙사식당",
//   "meals": [
//   {
//   "name": "조식",
//   "menus": ["아침", "된장찌개"]
//   },
//   {
//   "name": "점심",
//   "menus": ["점심", "된장찌개"]
//   },
//   {
//   "name": "저녁",
//   "menus": ["저녁", "된장찌개"]
//   },
//   ],
// },
// New: Add these constants
// TO DO: Replace with your App Group ID
const String appGroupId = '<YOUR APP GROUP>';
const String iOSWidgetName = 'NewsWidgets';
const String androidWidgetName = 'NewsWidget';

void updateHeadline(NewsArticle newHeadline) {
  // Save the headline data to the widget
  HomeWidget.saveWidgetData<String>('headline_title', newHeadline.title);
  HomeWidget.saveWidgetData<String>('headline_description', newHeadline.description);
  HomeWidget.updateWidget(
    iOSName: iOSWidgetName,
    androidName: androidWidgetName,
  );
}
const Map<String, dynamic> myjson = {
  "id": "20230123",
  "dormCafe": {
    "name": "기숙사식당",
    "meals": [
      {
        "name": "조식",
        "menus": ["아아아침", "된장찌개"]
      },
      {
        "name": "점심",
        "menus": ["점심", "된장찌개"]
      },
      {
        "name": "저녁",
        "menus": ["저녁", "된장찌개"]
      },
    ],
  },
  "studentCafe": {
    "name": "학생식당",
    "meals": [
      {
        "name": "조식",
        "menus": ["아침", "된장찌개"]
      },
      {
        "name": "점심",
        "menus": ["점심", "된장찌개"]
      },
      {
        "name": "저녁",
        "menus": ["저녁", "된장찌개"]
      },
    ],
  },
  "staffCafe": {
    "name": "교직원식당",
    "meals": [
      {
        "name": "조식",
        "menus": ["아침", "된장찌개"]
      },
      {
        "name": "점심",
        "menus": ["점심", "된장찌개"]
      },
      {
        "name": "저녁",
        "menus": ["저녁", "된장찌개"]
      },
    ],
  },
};
