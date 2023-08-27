
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void getDateNow() {
  // given
  DateTime now = DateTime.now();

  // when
  String formattedDate = DateFormat('yyyyMMdd').format(now);
  // String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

  // then
  expect(formattedDate, "20230827");
}


void main() {

  test('오늘의 날짜가 출력되는지 확인한다, 미국날짜면 안됨', () async {
    getDateNow();
  });

}
