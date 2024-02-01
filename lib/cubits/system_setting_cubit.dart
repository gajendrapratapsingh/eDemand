import 'package:e_demand/app/generalImports.dart';

abstract class SystemSettingState {}

class SystemSettingFetchInitial extends SystemSettingState {}

class SystemSettingFetchInProgress extends SystemSettingState {}

class SystemSettingFetchSuccess extends SystemSettingState {
  SystemSettingFetchSuccess({required this.systemSettingDetails});

  final SystemSettings systemSettingDetails;
}

class SystemSettingFetchFailure extends SystemSettingState {
  SystemSettingFetchFailure({required this.errorMessage});

  final dynamic errorMessage;
}

class SystemSettingCubit extends Cubit<SystemSettingState> {
  SystemSettingCubit({required this.settingRepository}) : super(SystemSettingFetchInitial());
  SettingRepository settingRepository = SettingRepository();

  void getSystemSettings() {
    emit(SystemSettingFetchInProgress());
    settingRepository.getSystemSetting().then((final SystemSettings value) {
      emit(SystemSettingFetchSuccess(systemSettingDetails: value));
    }).catchError((final error) {
      emit(SystemSettingFetchFailure(errorMessage: error.toString()));
    });
  }

  Map<String, dynamic> getSystemCurrencyDetails() {
    if (state is SystemSettingFetchSuccess) {
      final GeneralSettings generalSettings =
          (state as SystemSettingFetchSuccess).systemSettingDetails.generalSettings!;
      return {
        "currencySymbol": generalSettings.currency,
        "currencyCountryCode": generalSettings.countryCurrencyCode,
        "decimalPoints": generalSettings.decimalPoint
      };
    }
    return {"currencySymbol": r"$", "currencyCountryCode": "usd", "decimalPoints": "0"};
  }

  Map<String, String> getApplicationVersionDetails() {
    if (state is SystemSettingFetchSuccess) {
      final generalSettings =
          (state as SystemSettingFetchSuccess).systemSettingDetails.generalSettings!;

      return {
        "androidVersion": generalSettings.customerCurrentVersionAndroidApp.toString(),
        "iOSVersion": generalSettings.customerCurrentVersionIosApp.toString(),
      };
    }
    return {
      "androidVersion": "1.0.0",
      "iOSVersion": "1.0.0",
    };
  }

  PaymentGatewaysSettings getPaymentMethodSettings() {
    if (state is SystemSettingFetchSuccess) {
      return (state as SystemSettingFetchSuccess).systemSettingDetails.paymentGatewaysSettings!;
    }
    return PaymentGatewaysSettings();
  }

  String getPrivacyPolicy() {
    if (state is SystemSettingFetchSuccess) {
      return (state as SystemSettingFetchSuccess)
          .systemSettingDetails
          .customerPrivacyPolicy!
          .customerPrivacyPolicy!;
    }
    return "";
  }

  String getTermCondition() {
    if (state is SystemSettingFetchSuccess) {
      return (state as SystemSettingFetchSuccess)
          .systemSettingDetails
          .customerTermsConditions!
          .customerTermsConditions!;
    }
    return "";
  }

  String getAboutUs() {
    if (state is SystemSettingFetchSuccess) {
      return (state as SystemSettingFetchSuccess).systemSettingDetails.aboutUs!.aboutUs!;
    }
    return "";
  }

  String getContactUs() {
    if (state is SystemSettingFetchSuccess) {
      return (state as SystemSettingFetchSuccess).systemSettingDetails.contactUs!.contactUS!;
    }
    return "";
  }

  bool checkOTPSystemEnableOrNot() {
    if (state is SystemSettingFetchSuccess) {
      return (state as SystemSettingFetchSuccess)
              .systemSettingDetails
              .generalSettings
              ?.isOTPSystemEnable ==
          "1";
    }
    return false;
  }

  bool showProviderAddressDetails() {
    if (state is SystemSettingFetchSuccess) {
      return (state as SystemSettingFetchSuccess)
              .systemSettingDetails
              .generalSettings
              ?.showProviderAddress ==
          "1";
    }
    return false;
  }
}
