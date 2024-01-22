

import 'day_meal.dart';

class WidgetData {
  final String title;
  final String desc;

  WidgetData({
    required this.title,
    required this.desc,
  });
  factory WidgetData.fromJson(Map<String, dynamic> json) {
    return WidgetData(
        title: json['title'],
        desc: json['desc']
    );
  }
  Map<String, dynamic> toJson() => {
    'title': this.title,
    'desc': this.desc,
  };
}

class TestWidgetData {
  final List<dynamic> lunch;
  final List<dynamic> dinner;
  TestWidgetData({required this.lunch, required this.dinner}) {}


  factory TestWidgetData.of(Cafeteria cafe) {
    final json = cafe.toJson();
    return TestWidgetData(
      lunch: json['lunch'],
      dinner: json['dinner']
    );
  }

  Map<String, dynamic> toJson() => {
    'lunch': this.lunch,
    'dinner': this.dinner,
  };
}