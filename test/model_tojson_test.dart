import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:inhameal_flutter_project/Model/WidgetData.dart';
import 'package:inhameal_flutter_project/Model/day_meal.dart';

import 'http_request_test2.dart';

void main() async {
  final meal = Meal(
      name: "meal_name",
      openTime: "openTime",
      menus: ['김치','밥','오뚜기','햇반'],
      price: "price"
  );
  final cafeteria = Cafeteria(
    name: "name",
    brunch: [ meal, meal ],
    lunch: [ meal ],
    dinner: [ meal ],
    // other: [Meal(name: "name", openTime: "openTime", menus: ['김치','밥'], price: "price")],
    // skipReason: "skip reason",
  );

  final widgetData = TestWidgetData.of(cafeteria);

  test('meal to json', () async {
    print('------------------------ meal 변수가 아이폰에서 원하는 json으로 serialize할 수 있는지 확인한다 ------------------------');

    print(jsonEncode(meal.toJson()));

    print('-----------------------------------------------------------------------------------------------------------');
  });

  test('model to json', () async {
    print('------------------------ optional 변수가 json화 할 수 있는지 확인한다 ------------------------');
    Map<String, dynamic> json = cafeteria.toJson();

    print(jsonEncode(json));
    expect(json['skipReason'], null);
    print('-----------------------------------------------------------------------------------------------------------');
  });

  test('TestWidgetData to json', () async {
    print('------------------------ TestWidgetData 변수가 아이폰에서 원하는 json으로 serialize할 수 있는지 확인한다 ------------------------');
    Map<String, dynamic> json = widgetData.toJson();

    print(jsonEncode(json));
    print('-----------------------------------------------------------------------------------------------------------');
  });

}
