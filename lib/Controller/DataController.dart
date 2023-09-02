import 'dart:convert';
import 'package:home_widget/home_widget.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/DayMeal.dart';

class DataController {
  static final DataController instance = DataController._internal();
  factory DataController() => instance;
  DataController._internal();

  final String baseUrl = "https://xiipj5vqt1.execute-api.ap-northeast-2.amazonaws.com/items";

  late List<String> cafeList;


  Future<Map<String, dynamic>> fetchJson(String id) async {
    DateTime now = DateTime.now();
    String endpoint = DateFormat('yyyyMMdd').format(now);

    endpoint = id;

    final response = await http.get(Uri.parse("$baseUrl/$endpoint"));

    if (response.statusCode == 200) {
      Map<String, dynamic> dayMealJson = jsonDecode(utf8.decode(response.bodyBytes));
      return dayMealJson;
    } else {
      throw Exception('http요청에 실패했습니다, ${response.statusCode}');
    }
  }

  void saveJsonToLocal(String id, Map<String,dynamic> dayMealMap) async {
    //given
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(id, json.encode(dayMealMap));
  }

  Future<Map<String, dynamic>?> readJsonFromLocal(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedMapString = prefs.getString(id);

    if(storedMapString == null) return null;

    Map<String, dynamic> storedMap = json.decode(storedMapString);

    return storedMap;
  }

  Future<void> deleteData(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(id);
  }

  Future<DayMeal> loadData() async {
    String id = "19990101";

    await deleteData(id);
    Map<String, dynamic>? dayJson = await readJsonFromLocal(id);
    dayJson ??= await fetchJson(id);
    saveJsonToLocal(id, dayJson);
    
    if(dayJson == null) {
      throw Exception('${id}가 없습니다');
    }
    updateWidgetInfo(dayJson);

    cafeList = await getCafePriority();

    return DayMeal.fromJson(dayJson);
  }

  void updateWidgetInfo(Map<String, dynamic> dayMealMap) {
    final List<String> dormJson = dayMealMap['dormCafe']["meals"][0]["menus"]?.cast<String>(); // 여기서 인덱스를 못찾아도 괜찮게 하는 방법 없나?

    HomeWidget.saveWidgetData<String>('cafe_name', "기숙사식당"); // 나중에 String말고 Map<String, dynamic>으로 저장할수있는지 테스트하기
    HomeWidget.saveWidgetData<String>('meals', json.encode(dormJson));

    HomeWidget.saveWidgetData<String>('lunchMenu4', '');
    HomeWidget.saveWidgetData<String>('lunchMenu5', '');
    HomeWidget.saveWidgetData<String>('lunchMenu6', '');

    dormJson.asMap().forEach((idx, menu) {
      HomeWidget.saveWidgetData<String>('lunchMenu${idx+1}', menu);
    }); // forEach말고 한번에 payload 보내는 방법 알아보기
  }

  void updateCafePriority(List<String> items) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cafeList = items;
    prefs.setStringList("cafePriority", items);
  }

  Future<List<String>> getCafePriority() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("cafePriority") ?? ["student", "dorm", "staff"];
  }
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
