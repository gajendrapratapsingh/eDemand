import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class AddAddressContainer extends StatelessWidget {
  final Function()? onTap;

  const AddAddressContainer({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomInkWellContainer(
      onTap: () {
        onTap?.call();
      },
      child: Container(

        padding: const EdgeInsets.all(10),
        height: 45,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryColor,
          borderRadius: BorderRadius.circular(borderRadiusOf10),
        ),
        child: Center(
          child: Row(
            children: [
              SizedBox(
                width: 45,
                child: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.blackColor,
                ),
              ),
              Text(
                " ${"addNewAddress".translate(context: context)}",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.blackColor,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                ),
                textAlign: TextAlign.left,
              )
            ],
          ),
        ),
      ),
    );
  }
}
