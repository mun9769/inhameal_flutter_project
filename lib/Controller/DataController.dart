import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/DayMeal.dart';

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

  void saveData(String id, Map<String,dynamic> mockJson) async {
    //given
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(id, json.encode(mockJson));
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

}
