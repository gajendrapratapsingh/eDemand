import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class SortByBottomSheet extends StatefulWidget {

  const SortByBottomSheet(this.subCatId,
      { required this.selectedItem, required this.catId, required this.onChanged, final Key? key,})
      : super(key: key);
  final String catId;
  final String? subCatId;
  final String selectedItem;

  final Function(String selectedOption) onChanged;

  @override
  State<SortByBottomSheet> createState() => _SortByBottomSheetState();

}

class _SortByBottomSheetState extends State<SortByBottomSheet> {
  late String sortBy = widget.selectedItem;

  @override
  Widget build(final BuildContext context) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 10),
          child: _getBottomSheetTitle(),
        ),
        CustomDivider(color: Theme.of(context).colorScheme.lightGreyColor),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            children: [
              _getSortByOption('popularity'.translate(context: context)),
              CustomDivider(color: Theme.of(context).colorScheme.lightGreyColor),
              _getSortByOption('discountHighToLow'.translate(context: context)),
              CustomDivider(color: Theme.of(context).colorScheme.lightGreyColor),
              _getSortByOption('topRated'.translate(context: context)),
            ],
          ),
        )
      ],
    );

  Widget _getBottomSheetTitle() => Text('sortBy'.translate(context: context),
            style: TextStyle(
                color: Theme.of(context).colorScheme.blackColor,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                fontSize: 16,),
            textAlign: TextAlign.left,);

  CustomInkWellContainer _getSortByOption(final String sortByOptionName /*, sortByOptions sortByOptionValue*/) => CustomInkWellContainer(
      onTap: () {
        String? filter;
        setState(() {
          sortBy = sortByOptionName;
          if (sortBy == 'popularity'.translate(context: context)) {
            filter = 'popularity';
          } else if (sortBy == 'discountHighToLow'.translate(context: context)) {
            filter = 'discount';
          } else if (sortBy == 'topRated'.translate(context: context)) {
            filter = 'ratings';
          }
          widget.onChanged(filter!);
          Navigator.pop(context);
        });
      },
      child: Row(
        children: [
          Expanded(
              child: Text(sortByOptionName,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.blackColor,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,),
                  textAlign: TextAlign.start,),),
          Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
                color: sortBy == sortByOptionName
                    ? Theme.of(context).colorScheme.blackColor
                    : Colors.transparent,
                border: Border.all(width: 0.5, color: Theme.of(context).colorScheme.lightGreyColor),
                shape: BoxShape.circle,),
            child: sortBy == sortByOptionName
                ? Icon(
                    size: 18,
                    Icons.done_rounded,
                    color: Theme.of(context).colorScheme.secondaryColor,
                  )
                : Container(),
          )
        ],
      ),
    );
}
