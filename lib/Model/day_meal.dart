
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
  // final List<Meal>? meals;
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
    List<Meal> mealListDto = [];

    json['meals']?.forEach((ele) {
      mealListDto.add(Meal.fromJson(ele));
    });

    return Cafeteria(
      name: json['name'],
      brunch: json['brunch'],
      lunch: json['lunch'],
      dinner: json['dinner'],
      other: mealListDto,
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
