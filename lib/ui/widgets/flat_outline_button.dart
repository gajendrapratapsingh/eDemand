import "../../app/generalImports.dart";
import 'package:flutter/material.dart';

class FlatOutlinedButton extends StatelessWidget {
  const FlatOutlinedButton({
     required this.name, required this.onTap, required this.isSelected, final Key? key,
  }) : super(key: key);

  final bool isSelected;
  final String name;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) => Material(
      color: isSelected ? Theme.of(context).colorScheme.accentColor : Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadiusOf10),
      child: CustomInkWellContainer(
        onTap: onTap,
        child: Container(
          width: 80,
          height: 34,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadiusOf10),
              border: isSelected
                  ? null
                  : Border.all(color: Theme.of(context).colorScheme.lightGreyColor, width: 1.2),),
          child: Center(
              child: Text(
            name,
            style: TextStyle(
                color:
                    isSelected ? AppColors.whiteColors : Theme.of(context).colorScheme.blackColor,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                fontSize: 12,),
          ),),
        ),
      ),
    );
}
