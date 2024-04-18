
class Validator{
  bool isValidEmail(String value) {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(value);
  }

  bool isValidName (String value) {
    final nameRegExp =
    // new RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    new RegExp(r"^([A-Za-z]{3,}\s){1}([A-Za-z]{3,}\s?){1,}$");
    return nameRegExp.hasMatch(value);
  }

  bool isValidPassword(String value) {
    final passwordRegExp =
    // RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\><*~]).{8,}/pre>');
    RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$");
    return passwordRegExp.hasMatch(value);
  }

  bool isNotNull(String value) {
    return value != null ;
  }

  bool isValidPhone(String value) {
    final phoneRegExp = RegExp(r"^\+?0[0-9]{10}$");
    return phoneRegExp.hasMatch(value);
  }

  bool isValidCode(String value) {
    final phoneRegExp = RegExp(r"^[0-9]{1,6}$");
    return phoneRegExp.hasMatch(value);
  }
}