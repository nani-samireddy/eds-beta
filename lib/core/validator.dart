String? validatephoneNumber(String? value) {
  if (value!.isEmpty || value.length != 10) {
    return 'Please enter valid phone number';
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
  if (value == null || value.isEmpty ) {
    return 'Enter a valid name';
  }
  return null;
}
