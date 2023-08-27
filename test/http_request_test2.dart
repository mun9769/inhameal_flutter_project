import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';

class DayMeal {
  final String id;

  final Cafeteria dorm_1Cafe;
  final Cafeteria dorm_2Cafe;
  final Cafeteria studentCafe;
  final Cafeteria staffCafe;

  const DayMeal(
      {required this.id,
        required this.dorm_1Cafe,
        required this.dorm_2Cafe,
        required this.studentCafe,
        required this.staffCafe});

  factory DayMeal.fromJson(Map<String, dynamic> json) {
    return DayMeal(
      id: json['id'],
      dorm_1Cafe: Cafeteria.fromJson(json['dorm_1Cafe']),
      dorm_2Cafe: Cafeteria.fromJson(json['dorm_2Cafe']),
      studentCafe: Cafeteria.fromJson(json['studentCafe']),
      staffCafe: Cafeteria.fromJson(json['staffCafe']),
    );
  }
}

class Cafeteria {
  final String? name;
  final List<Meal>? meals;

  const Cafeteria({required this.name, required this.meals});

  factory Cafeteria.fromJson(Map<String, dynamic> json) {
    List<Meal> mealListDto = [];

    json['meals']?.forEach((ele) {
      mealListDto.add(Meal.fromJson(ele));
    });

    return Cafeteria(
      name: json['name'],
      meals: mealListDto,
    );
  }
}

class Meal {
  final String? name;
  final List<dynamic>? menus;
  String? openTime;

  static const Map<String, String> name2time = {
    "brunch": "07:30 ~ 09:30",
    "lunch": "11:30 ~ 13:30",
    "dinner": "17:30 ~ 19:00",
  };

  Meal({required this.openTime, required this.name, required this.menus});

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      openTime: Meal.name2time[json['name']],
      name: json['name'],
      menus: json['menus'],
    );
  }
}

Future<DayMeal> fetchDayMeal(
    { String reqUrl = "https://xiipj5vqt1.execute-api.ap-northeast-2.amazonaws.com/items/20230829" } ) async {
  final response = await http.get(Uri.parse(reqUrl));

  if (response.statusCode == 200) {
    return DayMeal.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception('Failed to load DayMeal');
  }
}


void main() async {

  test('return an DayMeal if the http call completes successfully', () async {
    print('------------------------ return an DayMeal if the http call completes successfully ------------------------');
    final DayMeal Meal0829 = await fetchDayMeal();
    expect(Meal0829, isA<DayMeal>());
    print('-----------------------------------------------------------------------------------------------------------');
  });

  test('return throws error if the paramDay is wrong', () async {
    print('------------------------ return throw error if the http call failed to load ------------------------');
    expect(fetchDayMeal(reqUrl: 'https://xiipj5vqt1.execute-api.ap-northeast-2.amazonaws.com/items/20230833'), throwsA(const TypeMatcher<Exception>()));
    print('-----------------------------------------------------------------------------------------------------------');
  });

}
