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
      throw Exception('Failed to load DayMeal, ${response.statusCode}');
    }
  }

  void saveData(String id, Map<String,dynamic> mockJson) async {
    //given
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(id, json.encode(mockJson));
  }

  void readData(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? storedMapJson = prefs.getString(id);

    Map<String, dynamic> storedMap = json.decode(storedMapJson!);
    print(storedMap);

  }

}
