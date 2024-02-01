import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class ChooseLanguageBottomSheet extends StatefulWidget {
  const ChooseLanguageBottomSheet({final Key? key}) : super(key: key);

  @override
  State<ChooseLanguageBottomSheet> createState() => _ChooseLanguageBottomSheetState();
}

class _ChooseLanguageBottomSheetState extends State<ChooseLanguageBottomSheet> {
  //
  Widget _getSelectLanguageHeading() => Text('selectLanguage'.translate(context: context),
        style: TextStyle(
          color: Theme.of(context).colorScheme.blackColor,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          fontSize: 20,
        ),
        textAlign: TextAlign.start,);

//
  Column getLanguageTile({required final AppLanguage appLanguage}) => Column(
      children: [
        CustomInkWellContainer(
          onTap: () {
            context.read<LanguageCubit>().changeLanguage(
                selectedLanguageCode: appLanguage.languageCode,
                selectedLanguageName: appLanguage.languageName,);
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                SizedBox(
                  height: 25,
                  width: 25,
                  child: CustomSvgPicture(svgImage: appLanguage.imageURL, height: 25, width: 25),
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(appLanguage.languageName,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.blackColor,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 18,),
                        textAlign: TextAlign.left,),)
              ],
            ),
          ),
        ),
        CustomDivider()
      ],
    );

  //
  @override
  Widget build(final BuildContext context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: _getSelectLanguageHeading(),
        ),
        CustomDivider(),
        Column(
          children: List.generate(
              appLanguages.length, (final int index) => getLanguageTile(appLanguage: appLanguages[index]),),
        )
      ],
    );
}
