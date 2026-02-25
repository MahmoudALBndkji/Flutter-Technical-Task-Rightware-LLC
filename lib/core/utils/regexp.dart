bool isValidEmail(String email) {
  return RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(email);
}

// For Check The Text Should Least 6 Characters
bool isLeast6Characters(String originalText) {
  return RegExp(r'^.{6,}$').hasMatch(originalText);
}

// For Check The Text Should Least 3 Characters
bool isLeast3Characters(String originalText) {
  return RegExp(r'^.{3,}$').hasMatch(originalText);
}

// For Split Price by Comma {,} between Digits
String splitPriceByComma(int number) {
  String str = number.toString();
  int length = str.length;
  if (length <= 3) return str;
  int firstCommaIndex = length % 3;
  if (firstCommaIndex == 0) firstCommaIndex = 3;
  String result = str.substring(0, firstCommaIndex);
  for (int i = firstCommaIndex; i < length; i += 3) {
    result += ',${str.substring(i, i + 3)}';
  }
  return result;
}
