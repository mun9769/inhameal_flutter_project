
class DayMeal {
  final String id;

  final Cafeteria dormCafe;
  final Cafeteria studentCafe;
  final Cafeteria staffCafe;

  const DayMeal(
      {required this.id,
        required this.dormCafe,
        required this.studentCafe,
        required this.staffCafe});

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
    "조식": "07:30 ~ 09:30",
    "중식": "11:30 ~ 13:30",
    "석식": "17:30 ~ 19:00",
    "간단식": "07:30 ~ 09:30",
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
