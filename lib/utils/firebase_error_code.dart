// ignore_for_file: file_names

import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

String findFirebaseError(final BuildContext context, final String code) {
  if (code == "invalid-verification-code") {
    return "invalid_verification_code".translate(context: context);
  } else if (code == "invalid-phone-number") {
    return "invalid_phone_number".translate(context: context);
  } else if (code == "too-many-requests") {
    return "too_many_requests".translate(context: context);
  } else if (code == "network-request-failed") {
    return "network_request_failed".translate(context: context);
  } else {
    return "somethingWentWrong".translate(context: context);
  }
}
