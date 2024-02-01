import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class NotAvailable extends StatelessWidget {
  const NotAvailable({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) => Scaffold(
        body: Center(
            child: NoDataContainer(
      titleKey: "weAreNotAvailableHere".translate(context: context),
    ),),);
}
