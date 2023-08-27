
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void getDateNow() {
  // given
  DateTime now = DateTime.now();

  // when
  String formattedDate = DateFormat('yyyyMMdd').format(now);
  // String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

  // then
  expect(formattedDate, "20230827");
}


void main() {

  test('오늘의 날짜가 출력되는지 확인한다, 미국날짜면 안됨', () async {
    getDateNow();
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
