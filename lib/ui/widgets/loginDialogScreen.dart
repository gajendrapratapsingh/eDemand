import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class LogInDialogScreen extends StatelessWidget {
  const LogInDialogScreen({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) => Container(
      height: MediaQuery.sizeOf(context).height * 0.3,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryColor,
          borderRadius: BorderRadius.circular(borderRadiusOf10),),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.3 - 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info, color: Theme.of(context).colorScheme.accentColor, size: 70),
                Text('loginRequired'.translate(context: context),
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.blackColor, fontSize: 16),),
                const SizedBox(height: 10),
                Text('pleaseLogin'.translate(context: context),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.lightGreyColor, fontSize: 12,),),
              ],
            ),
          ),
          Expanded(
              child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: CustomInkWellContainer(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(borderRadiusOf10)),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color(0x1c343f53),
                                  offset: Offset(0, -3),
                                  blurRadius: 10,)
                            ],
                            color: Theme.of(context).colorScheme.secondaryColor,),
                        child: Center(
                          child: Text(
                            'notNow'.translate(context: context),
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.blackColor,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,),
                          ),
                        ),),
                  ),
                ),
                Expanded(
                  child: CustomInkWellContainer(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, loginRoute, arguments: {'source': 'dialog'});
                    },
                    child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(bottomRight: Radius.circular(borderRadiusOf10)),
                          boxShadow: const [
                            BoxShadow(
                                color: Color(0x1c343f53),
                                offset: Offset(0, -3),
                                blurRadius: 10,)
                          ],
                          color: Theme.of(context).colorScheme.accentColor,
                        ),
                        child: Center(
                          child: Text(
                            'login'.translate(context: context),
                            style: TextStyle(
                                color: AppColors.whiteColors,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,),
                          ),
                        ),),
                  ),
                )
              ],
            ),
          ),)
        ],
      ),
    );
}
