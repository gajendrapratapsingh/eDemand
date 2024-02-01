String? validateNumber(final String number) {
  if (number.isEmpty) {
    return "Field must not be empty";
  } else if (number.length < 6 || number.length > 15) {
    return "Mobile number should be between 6 and 15 numbers";
  }

  return null;
}

bool isValidEmail({required final String email}) => RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',)
      .hasMatch(email);

String? validateTextFild(final String? value) {
  if (value!.isEmpty) {
    return "Field must not be empty";
  }

  return null;
}

/// Replace extra coma from String
///
String filterAddressString(String text) {
  const  String middleDuplicateComaRegex = ',(.?),';
  const String leadingAndTrailingComa = r'(^,)|(,$)';
  final RegExp removeComaFromString = RegExp(
    middleDuplicateComaRegex,
    caseSensitive: false,
    multiLine: true,
  );

  final RegExp leadingAndTrailing = RegExp(
    leadingAndTrailingComa,
    multiLine: true,
    caseSensitive: false,
  );

  final String filteredText =
      text.trim().replaceAll(removeComaFromString, ",").replaceAll(leadingAndTrailing, "");

  return filteredText;
}
