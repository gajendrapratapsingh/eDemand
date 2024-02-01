import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class CityBottomSheet extends StatefulWidget {
  const CityBottomSheet({final Key? key}) : super(key: key);

  @override
  State<CityBottomSheet> createState() => CityBottomSheetState();
}

class CityBottomSheetState extends State<CityBottomSheet> {
  final TextEditingController _searchLocation = TextEditingController();
  Timer? delayTimer;
  GooglePlaceAutocompleteCubit? cubitReferance;
  int previouseLength = 0;

  @override
  void initState() {
    super.initState();
    _searchLocation.addListener(() {
      if (_searchLocation.text.isEmpty) {
        delayTimer?.cancel();
      }

      if (delayTimer?.isActive ?? false) delayTimer?.cancel();

      delayTimer = Timer(const Duration(milliseconds: 500), () {
        if (_searchLocation.text.isNotEmpty) {
          if (_searchLocation.text.length != previouseLength) {
            context
                .read<GooglePlaceAutocompleteCubit>()
                .searchLocationFromPlacesAPI(text: _searchLocation.text);
            previouseLength = _searchLocation.text.length;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _searchLocation.dispose();
    delayTimer?.cancel();
    cubitReferance?.clearCubit();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    cubitReferance = context.read<GooglePlaceAutocompleteCubit>();
    super.didChangeDependencies();
  }

  @override
  Widget build(final BuildContext context) => Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.sizeOf(context).height * 0.4,
          maxHeight: MediaQuery.sizeOf(context).height * 0.7,
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('selectLocation'.translate(context: context),
                style: const TextStyle(fontSize: 25),),
            const SizedBox(height: 20),
            TextField(
              onTap: () {},
              controller: _searchLocation,
              onChanged: (String e) {},
              style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.blackColor),
              cursorColor: Theme.of(context).colorScheme.accentColor,
              decoration: InputDecoration(
                contentPadding: const EdgeInsetsDirectional.only(bottom: 2, start: 15),
                filled: true,
                fillColor: Theme.of(context).colorScheme.primaryColor,
                hintText: 'enterLocationAreaCity'.translate(context: context),
                hintStyle: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.blackColor),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.accentColor),
                  borderRadius: const BorderRadius.all(Radius.circular(borderRadiusOf10)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.accentColor),
                  borderRadius: const BorderRadius.all(Radius.circular(borderRadiusOf10)),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.accentColor),
                  borderRadius: const BorderRadius.all(Radius.circular(borderRadiusOf10)),
                ),
                prefixIcon: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: CustomSvgPicture(
                    svgImage: 'search.svg',
                    height: 12,
                    width: 12,
                    color: Theme.of(context).colorScheme.blackColor,
                  ),
                ),
              ),
            ),
            BlocBuilder<GooglePlaceAutocompleteCubit, GooglePlaceAutocompleteState>(
              builder: (BuildContext context, googlePlaceState) {
                if (googlePlaceState is GooglePlaceAutocompleteSuccess) {
                  if (googlePlaceState.autocompleteResult.predictions!.isNotEmpty) {
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      separatorBuilder: (final BuildContext context, int index) => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: CustomDivider(
                          thickness: 0.9,
                        ),
                      ),
                      itemCount: googlePlaceState.autocompleteResult.predictions!.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, final i) => CustomInkWellContainer(
                        onTap: () async {
                          final Prediction placeData =
                              googlePlaceState.autocompleteResult.predictions![i];

                          final cordinates = await GooglePlaceRepository()
                              .getPlaceDetailsFromPlaceId(placeData.placeId!);

                          final GooglePlaceModel placeModel = GooglePlaceModel(
                            placeId: placeData.placeId!,
                            cityName: placeData.description!,
                            name: placeData.description!,
                            latitude: cordinates['lat'].toString(),
                            longitude: cordinates['lng'].toString(),
                          );
                          Future.delayed(Duration.zero, () {
                            Navigator.pop(context, {
                              'navigateToMap': true,
                              "useStoredCordinates": false,
                              "place": placeModel,
                              "googleMapButton": GoogleMapButton.confirmAddress
                            });
                          });
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 35,
                              height: 25,
                              child: Icon(
                                Icons.location_city,
                                color: Theme.of(context).colorScheme.accentColor,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Text(
                                googlePlaceState.autocompleteResult.predictions![i].description
                                    .toString(),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.blackColor,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Center(child: Text("noLocationFound".translate(context: context))),
                  );
                }

                if (googlePlaceState is GooglePlaceAutocompleteInProgress) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.accentColor,
                      ),
                    ),
                  );
                }
                return Container();
              },
            )
          ],
        ),
      );
}
