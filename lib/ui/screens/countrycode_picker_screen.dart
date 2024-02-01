import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CountryCodePickerScreen extends StatelessWidget {
  const CountryCodePickerScreen({final Key? key}) : super(key: key);

  static Route route(final RouteSettings routeSettings) => CupertinoPageRoute(builder: (final _) => const CountryCodePickerScreen(),);

  @override
  Widget build(final BuildContext context) => WillPopScope(
      onWillPop: () => Future.value(true),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
        appBar: UiUtils.getSimpleAppBar(context: context, title: ''),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(top: 15),
                      height: 55.rh(context),
                      child: TextField(
                        onTap: () {},
                        onChanged: (final String text) {
                          context.read<CountryCodeCubit>().filterCountryCodeList(text);
                        },
                        style: TextStyle(
                            fontSize: 16, color: Theme.of(context).colorScheme.blackColor,),
                        cursorColor: Theme.of(context).colorScheme.accentColor,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsetsDirectional.only(bottom: 2, start: 15),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.primaryColor,
                            hintText: 'search_by_country_name'.translate(context: context),
                            hintStyle: TextStyle(
                                fontSize: 12, color: Theme.of(context).colorScheme.blackColor,),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Theme.of(context).colorScheme.accentColor),
                                borderRadius: const BorderRadius.all(Radius.circular(borderRadiusOf10)),),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Theme.of(context).colorScheme.accentColor),
                                borderRadius: const BorderRadius.all(Radius.circular(borderRadiusOf10)),),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Theme.of(context).colorScheme.accentColor),
                                borderRadius: const BorderRadius.all(Radius.circular(borderRadiusOf10)),),
                            suffixIcon: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                              child: CustomSvgPicture(
                                  svgImage: 'search.svg',
                                  height: 12,
                                  width: 12,
                                  color: Theme.of(context).colorScheme.blackColor,),
                            ),),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        'select_your_country'.translate(context: context),
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.blackColor,),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  CustomDivider(
                    thickness: 1,
                    color: Theme.of(context).colorScheme.lightGreyColor,
                  )
                ],
              ),
            ),
            BlocBuilder<CountryCodeCubit, CountryCodeState>(
              builder: (final BuildContext context, final CountryCodeState state) {
                if (state is CountryCodeLoadingInProgress) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is CountryCodeFetchSuccess) {
                  return Expanded(
                    child: state.temporaryCountryList!.isNotEmpty
                        ? ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            itemCount: state.temporaryCountryList!.length,
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (final context, final index) {
                              final country = state.temporaryCountryList![index];
                              return CustomInkWellContainer(
                                onTap: () async {
                                  await Future.delayed(Duration.zero, () {
                                    context.read<CountryCodeCubit>().selectCountryCode(country);

                                    Navigator.pop(context);
                                  });
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 35,
                                      height: 25,
                                      child: Image.asset(
                                        country.flag,
                                        package: countryCodePackageName,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                        child: Text(country.name,
                                            style: TextStyle(
                                                color: Theme.of(context).colorScheme.blackColor,
                                                fontWeight: FontWeight.w400,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 18,),
                                            textAlign: TextAlign.start,),),
                                    Text(country.callingCode,
                                        style: TextStyle(
                                            color: Theme.of(context).colorScheme.blackColor,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 18,),
                                        textAlign: TextAlign.end,),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (final BuildContext context, final int index) => const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: CustomDivider(
                                  thickness: 0.9,
                                ),
                              ),
                          )
                        : Center(
                            child: Text('no_country_found'.translate(context: context)),
                          ),
                  );
                }
                if (state is CountryCodeFetchFail) {
                  return Center(child: Text(state.error.toString().translate(context: context)));
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
}
