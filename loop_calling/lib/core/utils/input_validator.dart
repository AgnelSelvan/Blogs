mixin InputValidator {
  String? validateFullName(String? value) {
    bool found = (value?.contains(RegExp(r'[0-9]')) ?? false);
    if (value == null || value == "") {
      return "Please Enter Fullname";
    } else if (found) {
      return "Full name should not contains numbers";
    } else if (value.length > 10) {
      return "Name is too big should contain less than 10 character";
    } else if (value.length < 3) {
      return "Name is too short";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value == "") {
      return "Please Enter Password";
    } else {
      String pattern =
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        return "Password should contains alphanumeric, characters.";
      }
    }
    return null;
  }
}
