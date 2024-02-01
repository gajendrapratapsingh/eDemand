import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class AppSettingsScreen extends StatefulWidget {

  const AppSettingsScreen({ required this.title, final Key? key}) : super(key: key);
  final String title;

  static Route<AppSettingsScreen> route(final RouteSettings routeSettings) => CupertinoPageRoute(
        builder: (final _) => AppSettingsScreen(title: routeSettings.arguments as String),);

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();

}

//about_us / privacy_policy / terms_conditions / contact_us / instructions
class _AppSettingsScreenState extends State<AppSettingsScreen> {
  String getType() {
    if (widget.title == "aboutUs") {
      return context.read<SystemSettingCubit>().getAboutUs();
    }
    if (widget.title == "termsofservice") {
      return context.read<SystemSettingCubit>().getTermCondition();
    }
    if (widget.title == "privacyAndPolicy") {
      return context.read<SystemSettingCubit>().getPrivacyPolicy();
    }
    if (widget.title == "contactUs") {
      return context.read<SystemSettingCubit>().getContactUs();
    }
    return "";
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryColor,
      appBar: UiUtils.getSimpleAppBar(
          context: context, title: widget.title.translate(context: context),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: HtmlWidget(
             getType(),

          ),
        ),
      ),
    );
}
