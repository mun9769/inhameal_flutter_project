class DayMeal {
  final String id;

  final Cafeteria dormCafe;
  final Cafeteria studentCafe;
  final Cafeteria staffCafe;

  const DayMeal({
    required this.id,
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
  final String? skipReason;

  const Cafeteria({
    required this.name,
    required this.brunch,
    required this.lunch,
    required this.dinner,
    this.other,
    this.skipReason,
  });

  factory Cafeteria.fromJson(Map<String, dynamic> json) {
    return Cafeteria(
        name: json['name'],
        brunch: (json['brunch'] as List).map((i) => Meal.fromJson(i)).toList(),
        lunch: (json['lunch'] as List).map((i) => Meal.fromJson(i)).toList(),
        dinner: (json['dinner'] as List).map((i) => Meal.fromJson(i)).toList(),
        other: (json['other'] as List?)?.map((i) => Meal.fromJson(i)).toList(),
        skipReason: json['skipReason']
    );
  }

  Map<String, dynamic> toJson() => {
      'name': this.name,
      'brunch': this.brunch.map((ele) => ele.toJson()).toString(),
      'lunch': this.lunch.map((ele) => ele.toJson()).toString(),
      'dinner': this.dinner.map((ele) => ele.toJson()).toString(),
      'other':  this.other?.map((ele) => ele.toJson()).toString(),
      'skipReason': this.skipReason
    };
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

  Map<String, dynamic> toJson() => {
    'name': this.name,
    'opentime': this.openTime,
    'menus': this.menus,
    'price': this.price
  };
}
