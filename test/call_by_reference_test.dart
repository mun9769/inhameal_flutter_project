import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:inhameal_flutter_project/Model/day_meal.dart';


class MyType{
  int num = 10;
}

void main() async {

  test('call by reference type in list type', () async {
    print('------------------------ return an DayMeal if the http call completes successfully ------------------------');
    List<int> a = [0, 1 ,2];
    List<int> b = a;
    List<int> c = a;

    print('a: $a\nb: $b\nc: $c');

    c.clear();
    print('a: $a\nb: $b\nc: $c');

    print('-----------------------------------------------------------------------------------------------------------');
  });

  test('call by reference type in int type', () async {
    print('------------------------ return an DayMeal if the http call completes successfully ------------------------');
    int a = 10;
    int b = a;
    int c = a;

    print('a: $a\nb: $b\nc: $c');

    c = 20;
    print('a: $a\nb: $b\nc: $c');
    print('-----------------------------------------------------------------------------------------------------------');
  });

  test('call by reference type in MyType type', () async {
    print('------------------------ return an DayMeal if the http call completes successfully ------------------------');
    MyType a = MyType();
    MyType b = a;
    MyType c = a;


    print('a: ${a.num}\nb: ${b.num}\nc: ${c.num}');

    c.num = 20;
    print('a: ${a.num}\nb: ${b.num}\nc: ${c.num}');
    print('-----------------------------------------------------------------------------------------------------------');
  });

}
