import 'package:e_demand/app/generalImports.dart';

import 'package:flutter/material.dart';

class FilterByBottomSheet extends StatefulWidget {
  const FilterByBottomSheet({final Key? key}) : super(key: key);

  @override
  State<FilterByBottomSheet> createState() => _FilterByBottomSheetState();
}

class _FilterByBottomSheetState extends State<FilterByBottomSheet> {
  RangeValues filterPriceRange = const RangeValues(50, 100);
  List ratingFilterValues = ["All", "1", "2", "3", "4", "5"];

  Widget _getBottomSheetTitle() => Center(
      child: Text('filter'.translate(context: context),
          style: TextStyle(
              color: Theme.of(context).colorScheme.blackColor,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              fontSize: 14,),
          textAlign: TextAlign.center,),
    );

  Widget _getTitle(final String title) {
    // Category
    return Text(title,
        style: const TextStyle(
            color: Color(0xff000000),
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 16,),
        textAlign: TextAlign.left,);
  }

  Widget _showSelectedCategory() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // All categories
        Text('allCategories'.translate(context: context),
            style: const TextStyle(
                color: Color(0xff343f53),
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 14,),
            textAlign: TextAlign.left,),
        // Edit
        CustomInkWellContainer(
          onTap: () {
            // UiUtils.showBottomSheet(child: const CategoryBottomSheet(), context: context);
          },
          child: Text('edit'.translate(context: context),
              style: const TextStyle(
                  color: Color(0xff838383),
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                  decoration: TextDecoration.underline,),
              textAlign: TextAlign.right,),
        )
      ],
    );

  Widget _getBudgetFilterLableAndPrice() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _getTitle('budget'.translate(context: context)),
        Text('$systemCurrency 20-$systemCurrency 30',
            style: const TextStyle(
                color: Color(0xff838383),
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 14,
                decoration: TextDecoration.underline,),
            textAlign: TextAlign.right,)
      ],
    );

  Widget _getBudgetFilterRangeSlider() => RangeSlider(
        values: filterPriceRange, max: 100, min: 1, divisions: 100, onChanged: (  RangeValues  newValue) {},);

  @override
  Widget build(final BuildContext context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _getBottomSheetTitle(),
              const CustomDivider(),
              _getTitle('category'.translate(context: context)),
              _showSelectedCategory(),
              const CustomDivider(),
              _getBudgetFilterLableAndPrice(),
              _getBudgetFilterRangeSlider(),
              const CustomDivider(),
              _getTitle('rating'.translate(context: context)),
              _getRatingFilterValues(),
              const CustomDivider(),
              _getTitle('location'.translate(context: context)),
              _showCurrentLocationContainer(),
            ],
          ),
        ),
        _showCloseAndApplyButton(),
      ],
    );

  Widget _getRatingFilterValues() => Container(
      padding: const EdgeInsets.only(top: 15),
      height: 45,
      width: double.infinity,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(
            ratingFilterValues.length,
            (final int index) => Container(
                  margin: const EdgeInsets.only(right: 15),
                  width: 70,
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(borderRadiusOf10)),
                      border: Border.all(color: const Color(0xff838383)),),
                  child: Center(
                    child: Text('★ ${ratingFilterValues[index]}',
                        style: const TextStyle(
                            color: Color(0xff343f53),
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,),
                        textAlign: TextAlign.center,),
                  ),
                ),),
      ),
    );

  Widget _showCurrentLocationContainer() => Row(
      children: [
        const Icon(Icons.location_on),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('useCurrentLocation'.translate(context: context),
                style: const TextStyle(
                    color: Color(0xff343f53),
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    fontSize: 16,),
                textAlign: TextAlign.left,),
            const Text('28-18 Carlton Rd, Markham, ON L3R 1Z2, Canada',
                style: TextStyle(
                    color: Color(0xff2560fc),
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 12,),
                textAlign: TextAlign.left,)
          ],
        )
      ],
    );

  Widget _showCloseAndApplyButton() => Row(
      children: [
        Expanded(
          child: CustomInkWellContainer(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                height: 44,
                decoration: const BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Color(0x1c343f53),
                      offset: Offset(0, -3),
                      blurRadius: 10,)
                ], color: Colors.white,),
                child: Center(
                  child: Text(
                    'close'.translate(context: context),
                    style: const TextStyle(
                        color: Color(0xff343f53),
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,),
                  ),
                ),),
          ),
        ),
        Expanded(
          child: Container(
              height: 44,
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Color(0x1c343f53),
                    offset: Offset(0, -3),
                    blurRadius: 10,)
              ], color: Color(0xff343f53),),
              child: // Apply Filter
                  Center(
                child: Text(
                  'applyFilter'.translate(context: context),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,),
                ),
              ),),
        )
      ],
    );
}

/*class CategoryBottomSheet extends StatefulWidget {
  const CategoryBottomSheet({Key? key}) : super(key: key);

  @override
  State<CategoryBottomSheet> createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet> {
  List<CategoryModel> selectedCategory = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * .77,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  CustomInkWellContainer(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      size: 24,
                    ),
                  ),
                  Expanded(
                      child: Center(
                          child: Text("category".translate(context: context),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400)))),
                  SizedBox(
                    width: 24.rw(context),
                  )
                ],
              ),
            ),
            const CustomDivider(),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categoryList.length,
                itemBuilder: (context, int i) {
                  return recursiveExpansionList(
                    categoryList[i],
                  );
                })
          ],
        ),
      ),
    );
  }

  Widget recursiveExpansionList(Map map) {
    List subList = [];
    subList = map["subCategory"] ?? [];
    bool contains = selectedCategory
        .where(((element) {
          return element.id == map['id'];
        }))
        .toSet()
        .isNotEmpty;
    if (subList.isNotEmpty) {
      if (map["level"] == 0) {
        return ExpansionTile(
          title: Text(map['name']),
          children: subList.map((e) => recursiveExpansionList(e)).toList(),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: ExpansionTile(
            title: Text(map['name']),
            children: subList.map((e) => recursiveExpansionList(e)).toList(),
          ),
        );
      }
    } else {
      if (map["level"] == 0) {
        return ListTile(
          title: Text(map['name']),
          leading: Checkbox(
              value: contains,
              fillColor: MaterialStateProperty.all(Theme.of(context).colorScheme.blackColor),
              onChanged: (bool? val) {
                CategoryModel categoryModel =
                    CategoryModel(id: map['id'], name: map['name'], isSelected: val as bool);
                if (contains) {
                  selectedCategory.removeWhere((e) => e.id == map['id']);
                } else {
                  selectedCategory.add(categoryModel);
                }

                setState(() {});
              }),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: ListTile(
            title: Text(map['name']),
            leading: Checkbox(
                fillColor: MaterialStateProperty.all(Theme.of(context).colorScheme.blackColor),
                value: contains,
                onChanged: (val) {
                  CategoryModel categoryModel =
                      CategoryModel(id: map['id'], name: map['name'], isSelected: val as bool);
                  if (contains) {
                    selectedCategory.removeWhere((e) => e.id == map['id']);
                  } else {
                    selectedCategory.add(categoryModel);
                  }

                  setState(() {});
                }),
          ),
        );
      }
    }
  }
}*/
