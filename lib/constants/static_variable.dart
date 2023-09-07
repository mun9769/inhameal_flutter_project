
class AppVar {
  AppVar._(); // this basically makes it so you can't instantiate this class

  static const Map<String, String> translateName = {
    'dorm': '기숙사식당',
    'staff': '교직원식당',
    'student': '학생식당',
  };
  static const Map<String, String> weeks = {
    'Mon': '월', 'Tue': '화', 'Wed': '수',
    'Thu': '목', 'Fri': '금', 'Sat': '토', 'Sun': '일',
  };
}