import 'package:flutter_test/flutter_test.dart';
import 'package:inhameal_flutter_project/Model/day_meal.dart';

import 'http_request_test2.dart';

void main() async {
  test('model to json', () async {
    print('------------------------ return an DayMeal if the http call completes successfully ------------------------');
    final cafeteria = Cafeteria(
      name: "name",
      brunch: [ Meal(name: "name", openTime: "openTime", menus: ['김치', '밥'], price: "price") ],
      lunch: [ Meal(name: "name", openTime: "openTime", menus: ['김치', '밥'], price: "price") ],
      dinner: [ Meal(name: "name", openTime: "openTime", menus: ['김치', '밥'], price: "price") ],
      // other: [Meal(name: "name", openTime: "openTime", menus: ['김치','밥'], price: "price")],
      // skipReason: "fda",
    );
    final json = cafeteria.toJson();

    print(json['skipReason']);
    expect(json['skipReason'], null);
    print('-----------------------------------------------------------------------------------------------------------');
  });

}
