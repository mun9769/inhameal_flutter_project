import 'dart:convert';
import 'package:home_widget/home_widget.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/day_meal.dart';

class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    return message;
  }
}

class DataController {
  static final DataController instance = DataController._internal();
  factory DataController() => instance;
  DataController._internal();

  final String baseUrl = "https://xiipj5vqt1.execute-api.ap-northeast-2.amazonaws.com/items";

  late List<String> cafeList = ["dorm","student","staff"];


  Future<Map<String, dynamic>?> fetchJson(String id) async {
    DateTime now = DateTime.now();
    String endpoint = DateFormat('yyyyMMdd').format(now);

    endpoint = id;

    final response = await http.get(Uri.parse("$baseUrl/$endpoint"));

    if (response.statusCode == 200) {
      Map<String, dynamic> dayMealJson = jsonDecode(utf8.decode(response.bodyBytes));
      return dayMealJson;
    } else if(response.statusCode == 404) {
      return null;
    } else {
      throw HttpException('아직 업데이트되지 않았어요');
    }
  }

  void saveJsonToLocal(String id, Map<String,dynamic> dayMealJson) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(id, json.encode(dayMealJson));
  }

  Future<Map<String, dynamic>?> readJsonFromLocal(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedString = prefs.getString(id);

    if(storedString == null) return null;

    Map<String, dynamic> storedJson = json.decode(storedString);

    return storedJson;
  }

  Future<void> deleteData(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(id);
  }

  void loadSeveralData(String date) async {
    DateTime currentDate = DateTime.parse(date);

    int offset = 1;
    DateTime nxt = currentDate.add(Duration(days: offset));
    String formattedDate = DateFormat('yyyyMMdd').format(nxt);

    while(offset < 6 && await loadFutureData(formattedDate)) {
      offset++;
      nxt = currentDate.add(Duration(days: offset));
      formattedDate = DateFormat('yyyyMMdd').format(nxt);
    }

  }

  Future<bool> loadFutureData(String id) async {
    if(await readJsonFromLocal(id) != null) { return false; }

    Map<String, dynamic>? dayJson = await fetchJson(id);
    if(dayJson == null) { return false; }

    saveJsonToLocal(id, dayJson);
    return true;
  }

  Future<DayMeal> loadDataFromId(String id) async {
    // await deleteData(id);
    Map<String, dynamic>? dayJson = await readJsonFromLocal(id);
    dayJson ??= await fetchJson(id);

    saveJsonToLocal(id, dayJson!);

    return DayMeal.fromJson(dayJson);
  }

  Future<DayMeal> fetchWeeklyData(String id) async {
    loadSeveralData(id);
    return await loadDataFromId(id);
  }

  Future<DayMeal> reloadData(String id) async {

    await deleteData(id);
    Map<String, dynamic>? dayJson = await fetchJson(id);

    if(dayJson == null) {
      throw Exception('$id가 없습니다');
    }
    saveJsonToLocal(id, dayJson);

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
    });
  }

  void updateCafePriority(List<String> items) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cafeList = items;
    prefs.setStringList("cafePriority", items);
  }

  Future<List<String>> getCafePriority() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("cafePriority") ?? ["dorm", "student", "staff"];
  }
}
