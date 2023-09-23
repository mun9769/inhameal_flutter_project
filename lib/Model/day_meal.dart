
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
  String? price;
  String? category;
  String? errMsg;


  Meal({required this.openTime, required this.name, required this.menus, required this.price, required this.category, this.errMsg});

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      openTime: json['opentime'],
      name: json['name'],
      menus: json['menus'],
      price: json['price'],
      category: json['category'],
      errMsg: json['errMsg'],
    );
  }
}
