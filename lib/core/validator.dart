String? validatephoneNumber(String? value) {
  if (value!.isEmpty || value.length != 10) {
    return 'Please enter valid phone number';
  }
  return null;
}

String? validateEmailAddress(String? value) {
  if (value!.isEmpty || !value.contains('@')) {
    return 'Please enter valid email address';
  }
  return null;
}

String? validateOTP(String? value) {
  if (value == null || value.isEmpty || value.length < 6) {
    return 'Please enter valid OTP';
  }
  return null;
}

String? validateName(String? value) {
  final RegExp nameRegx = RegExp(r'^[a-zA-Z ]+$');
  if (value == null || value.isEmpty || !nameRegx.hasMatch(value)) {
    return 'Enter a valid name';
  }
  return null;
}

String? validateDateOfBirth(String? value) {
  if (value == null || value.isEmpty || value.length != 10) {
    return 'Enter a valid date of birth (DD/MM/YYYY)';
  }
  return null;
}

String? validatePincode(String? value) {
  if (value == null ||
      value.isEmpty ||
      value.length != 6 ||
      value.contains(' ') ||
      value.contains('-') ||
      value.contains('.')) {
    return 'Enter a valid pincode';
  }
  return null;
}

String? validateAddress(String? value) {
  if (value == null || value.isEmpty) {
    return 'Enter a valid address';
  }
  return null;
}
