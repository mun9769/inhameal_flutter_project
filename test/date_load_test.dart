
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


void readAndWriteCorrectData(String id, Map<String,dynamic> mockJson) async {
  //given
  SharedPreferences.setMockInitialValues({});
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(id, json.encode(mockJson));

  // when
  String? storedMapJson = prefs.getString(id);

  // then
  expect(storedMapJson, isNot(null));

  Map<String, dynamic> storedMap = json.decode(storedMapJson!);
  print(storedMap);
}

void readNotExistData(String id) async {
  //given
  SharedPreferences.setMockInitialValues({});
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // when
  String? storedMapJson = prefs.getString(id);

  // then
  expect(storedMapJson, null);
}

void main() {

  test('SharedPreferences에 올바른 데이터 읽기 쓰기 테스트', () async {
    readAndWriteCorrectData("20230823", myjson);
  });

  test('SharedPreferences에 없는 데이터 읽기 테스트', () async {
    readNotExistData("20230823");
  });

}

Map<String, dynamic> myjson = {
  "id": "20230123",
  "dorm_1Cafe": {
    "name": "1기숙사식당",
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
  "dorm_2Cafe": {
    "name": "2기숙사식당",
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
