// ignore_for_file: non_constant_identifier_names

import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

Widget MessageContainer({
  required final BuildContext context,
  required final String text,
  required final MessageType type,
}) => Material(
    child: ToastAnimation(
      delay: messageDisplayDuration,
      child: Container(
        constraints:  BoxConstraints(
            minHeight: 50,
            maxHeight: 60,
            maxWidth: MediaQuery.sizeOf(context).width,
            minWidth: MediaQuery.sizeOf(context).width,),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
//
// using gradient to apply one side dark color in container
            gradient: LinearGradient(stops: const [
              0.02,
              0.02
            ], colors: [
              messageColors[type]!,
              messageColors[type]!.withOpacity(0.1),
            ],),
            borderRadius: BorderRadius.circular(borderRadiusOf10),
            border: Border.all(
              color: messageColors[type]!.withOpacity(0.5),
            ),),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.directional(
              textDirection: Directionality.of(context),
              start: 10,
              child: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: messageColors[type],
                ),
                child: Icon(
                  messageIcon[type],
                  color: Theme.of(context).colorScheme.secondaryColor,
                  size: 20,
                ),
              ),
            ),
            Positioned.directional(
              textDirection: Directionality.of(context),
              start: 40,
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width - 90,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(text.translate(context: context),
                      softWrap: true,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: messageColors[type],
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          letterSpacing: 1.2,),),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
