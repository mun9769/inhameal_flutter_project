
class DayMeal {
  final String id;
  final Meal brunch;
  final Meal lunch;
  final Meal dinner;

  const DayMeal({required this.id, required this.brunch, required this.lunch, required this.dinner});

  factory DayMeal.fromJson(Map<String, dynamic> json) {
    return DayMeal(
        id: json['id'],
        brunch: Meal(openTime: Meal.name2time["brunch"], name: "brunch", meal: json['brunch']),
        lunch: Meal(openTime: Meal.name2time["lunch"], name: "lunch", meal: json['lunch']),
        dinner: Meal(openTime: Meal.name2time["dinner"], name: "dinner", meal: json['dinner']),
    );
  }
}

class Meal {
  final String name;
  final List<dynamic> meal;
  String? openTime;

  static const Map<String, String> name2time = {
    "brunch": "07:30 ~ 09:30",
    "lunch": "11:30 ~ 13:30",
    "dinner": "17:30 ~ 19:00",
  };

  Meal({required this.openTime, required this.name, required this.meal});
}


