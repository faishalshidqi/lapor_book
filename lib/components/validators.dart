import 'package:flutter/cupertino.dart';

String? notEmptyValidator(value) {
  if (value == null || value.isEmpty) {
    return 'Input must not be empty';
  } else {
    return null;
  }
}

String? passConfirmationValidator(value, TextEditingController passController) {
  String? notEmpty = notEmptyValidator(value);
  if (notEmpty != null) {
    return notEmpty;
  }

  if (value.length < 6) {
    return 'Password must be at least 6 characters';
  }

  if (value != passController.value.text) {
    return 'Password and Confirmed Password must be the same';
  }
  return null;
}
