import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';

class DayMeal {
  final String id;
  final List<dynamic> brunch;
  final List<dynamic> lunch;
  final List<dynamic> dinner;

  const DayMeal({required this.id, required this.brunch, required this.lunch, required this.dinner});

  factory DayMeal.fromJson(Map<String, dynamic> json) {
    return DayMeal(
        id: json['id'],
        brunch: json['dinner'],
        lunch: json['lunch'],
        dinner: json['dinner']
    );
  }
}

Future<DayMeal> fetchDayMeal(
    { String reqUrl = "https://xiipj5vqt1.execute-api.ap-northeast-2.amazonaws.com/items/20230824" } ) async {
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
    expect(await fetchDayMeal(), isA<DayMeal>());
    print('-----------------------------------------------------------------------------------------------------------');
  });

  test('return throws error if the paramDay is wrong', () async {
    print('------------------------ return throw error if the http call failed to load ------------------------');
    expect(fetchDayMeal(reqUrl: 'https://xiipj5vqt1.execute-api.ap-northeast-2.amazonaws.com/items/20230833'), throwsA(const TypeMatcher<Exception>()));
    print('-----------------------------------------------------------------------------------------------------------');
  });

}
