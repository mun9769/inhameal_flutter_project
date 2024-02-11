import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/day_meal.dart';
import '../View/meal_screen.dart';

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
  late DayMeal dayMeal;
  late DateTime currentDate;
  late List<Widget> cafepages;
  late int selectedPage;
  late List<String> cafeList = ["dorm", "student", "staff"];
  late Map<String, Widget> currentCafe;

  void _updateCafePriority() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("cafePriority", this.cafeList);
  }

  Future<List<String>> _getCafePriority() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getStringList("cafePriority") ?? ["dorm", "student", "staff"];
  }

  Map<String, Widget> _setCurrentCafe() => {
      "dorm": MealPage(cafe: dayMeal.dormCafe, onRefresh: refreshDayMeal),
      "student": MealPage(cafe: dayMeal.studentCafe, onRefresh: refreshDayMeal),
      "staff": MealPage(cafe: dayMeal.staffCafe, onRefresh: refreshDayMeal),
  };

  List<Widget> _setCafepages() {
    List<Widget> ret = [];
    this.cafeList.forEach((element) {
      ret.add(this.currentCafe[element]!);
    });
    return ret;
  }

  Future<void> dummyFunc() async {
  }

  Future<void> _loadDataFromId(String id) async {
    // await deleteData(id);
    Map<String, dynamic>? dayJson = await _readJsonFromLocal(id);
    dayJson ??= await _fetchJson(id);
    _saveJsonToLocal(id, dayJson!);

    this.dayMeal = DayMeal.fromJson(dayJson);
    this.currentDate = DateTime.parse(dayMeal.id);
    this.currentCafe = _setCurrentCafe();
    this.cafeList = await _getCafePriority();
    this.cafepages = _setCafepages();
    this.selectedPage = 0;
    // TODO: cafelist == cafepage == currentCafe
  }

  Future<Map<String, dynamic>?> _fetchJson(String id) async {
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

  void _saveJsonToLocal(String id, Map<String,dynamic> dayMealJson) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(id, json.encode(dayMealJson));
  }

  Future<Map<String, dynamic>?> _readJsonFromLocal(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedString = prefs.getString(id);

    if(storedString == null) return null;

    Map<String, dynamic> storedJson = json.decode(storedString);

    return storedJson;
  }

  Future<void> _deleteData(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(id);
  }

  void _loadSeveralData(String date) async {
    DateTime currentDate = DateTime.parse(date);

    int offset = 1;
    DateTime nxt = currentDate.add(Duration(days: offset));
    String formattedDate = DateFormat('yyyyMMdd').format(nxt);

    while(offset < 6 && await _loadFutureData(formattedDate)) {
      offset++;
      nxt = currentDate.add(Duration(days: offset));
      formattedDate = DateFormat('yyyyMMdd').format(nxt);
    }

  }

  Future<bool> _loadFutureData(String id) async {
    if(await _readJsonFromLocal(id) != null) { return false; }

    Map<String, dynamic>? dayJson = await _fetchJson(id);
    if(dayJson == null) { return false; }

    _saveJsonToLocal(id, dayJson);
    return true;
  }


  Future<void> init(String id) async {
    _loadSeveralData(id);
    _loadDataFromId(id);
  }

  Future<void> getTmrwDayMeal(String id) async {
    Map<String, dynamic>? dayJson = await _readJsonFromLocal(id);
    dayJson ??= await _fetchJson(id);
    _saveJsonToLocal(id, dayJson!);

    this.dayMeal = DayMeal.fromJson(dayJson);
    this.currentDate = DateTime.parse(dayMeal.id);
    this.currentCafe = _setCurrentCafe();
    this.cafepages = _setCafepages();
  }

  Future<void> refreshDayMeal() async {
    String id = DateFormat('yyyyMMdd').format(currentDate);
    await _deleteData(id);
    Map<String, dynamic>? dayJson = await _fetchJson(id);

    if(dayJson == null) {
      throw Exception('$id가 없습니다');
    }
    _saveJsonToLocal(id, dayJson);
    this.dayMeal = DayMeal.fromJson(dayJson);
    // TODO: 위젯에서 setstate해야한다.
  }

  void onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) { newIndex -= 1; }

    if ((newIndex - oldIndex).abs() == 2) {
      this.selectedPage = (newIndex - oldIndex + selectedPage + 3) % 3;
    } else {
      this.selectedPage = (newIndex + oldIndex - selectedPage + 3) % 3;
    }
    final String item = this.cafeList.removeAt(oldIndex);
    this.cafeList.insert(newIndex, item);

    this.cafepages = _setCafepages();
    _updateCafePriority();
  }

}
