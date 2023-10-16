import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';


class DayMeal {
  final String id;

  final Cafeteria dormCafe;
  final Cafeteria studentCafe;
  final Cafeteria staffCafe;

  const DayMeal(
      {required this.id,
        required this.dormCafe,
        required this.studentCafe,
        required this.staffCafe,
      });

  factory DayMeal.fromJson(Map<String, dynamic> json) {
    return DayMeal(
      id: json['id'],
      dormCafe: Cafeteria.fromJson(json['dormCafe']),
      studentCafe: Cafeteria.fromJson(json['studentCafe']),
      staffCafe: Cafeteria.fromJson(json['staffCafe']),
    );
  }
}

class Cafeteria {
  final String name;
  final List<Meal> brunch;
  final List<Meal> lunch;
  final List<Meal> dinner;
  final List<Meal>? other;
  final String? message;

  const Cafeteria(
      { required this.name,
        required this.brunch,
        required this.lunch,
        required this.dinner,
        this.other,
        this.message,
      });

  factory Cafeteria.fromJson(Map<String, dynamic> json) {
    return Cafeteria(
        name: json['name'],
        brunch: (json['brunch'] as List).map((i) => Meal.fromJson(i)).toList(),
        lunch: (json['lunch'] as List).map((i) => Meal.fromJson(i)).toList(),
        dinner: (json['dinner'] as List).map((i) => Meal.fromJson(i)).toList(),
        other: (json['other'] as List?)?.map((i) => Meal.fromJson(i)).toList(),
        message: json['message']
    );
  }
}

class Meal {
  final String name;
  final List<dynamic> menus;
  String openTime;
  String price;


  Meal({
    required this.name,
    required this.openTime,
    required this.menus,
    required this.price,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      name: json['name'],
      openTime: json['opentime'],
      menus: json['menus'],
      price: json['price'],
    );
  }
}

Future<DayMeal> fetchDayMeal(
    { String reqUrl = "https://xiipj5vqt1.execute-api.ap-northeast-2.amazonaws.com/items/20231013" } ) async {
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
    final DayMeal meal = await fetchDayMeal();
    expect(meal, isA<DayMeal>());
    print('-----------------------------------------------------------------------------------------------------------');
  });

  test('return throws error if the paramDay is wrong', () async {
    print('------------------------ return throw error if the http call failed to load ------------------------');
    expect(fetchDayMeal(reqUrl: 'https://xiipj5vqt1.execute-api.ap-northeast-2.amazonaws.com/items/20230833'), throwsA(const TypeMatcher<Exception>()));
    print('-----------------------------------------------------------------------------------------------------------');
  });

}
