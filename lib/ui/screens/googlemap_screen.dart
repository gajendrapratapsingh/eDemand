import 'dart:async';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:e_demand/app/app_theme.dart';
import 'package:e_demand/app/routes.dart';
import 'package:e_demand/cubits/addressCubits/add_address_cubit.dart';
import 'package:e_demand/cubits/app_theme_cubit.dart';
import 'package:e_demand/cubits/check_provider_availability_cubit.dart';
import 'package:e_demand/cubits/homescreen_cubit.dart';
import 'package:e_demand/data/model/address_model.dart';
import 'package:e_demand/data/model/get_address_model.dart';
import 'package:e_demand/data/model/google_place_model.dart';
import 'package:e_demand/data/repository/provider_repository.dart';
import 'package:e_demand/ui/widgets/bottomsheets/address_bottomsheet.dart';
import 'package:e_demand/ui/widgets/customSvgPicture.dart';
import 'package:e_demand/ui/widgets/custom_inkwell_container.dart';
import 'package:e_demand/ui/widgets/custom_rounded_button.dart';
import 'package:e_demand/ui/widgets/custom_shimmer_container.dart';
import 'package:e_demand/ui/widgets/shimmer_loading_container.dart';
import 'package:e_demand/utils/colors.dart';
import 'package:e_demand/utils/constant.dart';
import 'package:e_demand/utils/extension.dart';
import 'package:e_demand/utils/hive_keys.dart';
import 'package:e_demand/utils/location.dart';
import 'package:e_demand/utils/responsive_size.dart';
import 'package:e_demand/utils/ui_utils.dart';
import 'package:e_demand/utils/validation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocode/geocode.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';

import "../widgets/tooltip_shape_border.dart";
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // ignore_for_file: file_names

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({
    required this.googleMapButton,
    required this.useStoredCordinates,
    required this.place,
    final Key? key,
    this.addressDetails,
  }) : super(key: key);
  final bool useStoredCordinates;
  final GooglePlaceModel? place;
  final GoogleMapButton googleMapButton;
  final GetAddressModel? addressDetails;

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();

  static Route route(final RouteSettings routeSettings) {
    final Map argument = routeSettings.arguments as Map;
    return CupertinoPageRoute(
      builder: (final context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AddAddressCubit(),
          ),
          BlocProvider(
            create: (final context) =>
                CheckProviderAvailabilityCubit(providerRepository: ProviderRepository()),
          ),
        ],
        child: Builder(
          builder: (context) => GoogleMapScreen(
            place: argument['place'],
            useStoredCordinates: argument['useStoredCordinates'],
            googleMapButton: argument['googleMapButton'],
            addressDetails: argument['details'],
          ),
        ),
      ),
    );
  }
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
//
  static late double storedLatitude;
  static late double storedLongitude;

//
  String address = "";
  AddressModel addressDataModel = AddressModel.fromMap({});
  late CameraPosition initialCameraPosition;

//
  late Marker initialLocation = Marker(
    markerId: const MarkerId("1"),
    position: LatLng(storedLatitude, storedLongitude),
    onTap: () {},
  );

  String lineOneAddress = "";
  String lineTwoAddress = "";
  String? locality;

//
  StreamController markerController = StreamController();
  String? name;
  List<Placemark> placeMark = [];
  String? subLocality;

  String? selectedLatitude;
  String? selectedLongitude;

  late final TextEditingController _completeAddressFieldController =
      TextEditingController(text: widget.addressDetails?.address);
  late final TextEditingController _mobileNumberFieldController =
      TextEditingController(text: widget.addressDetails?.mobile);
  late final TextEditingController _floorFieldController =
      TextEditingController(text: widget.addressDetails?.area);
  late final TextEditingController _cityFieldController =
      TextEditingController(text: widget.addressDetails?.cityName);
  final Completer<GoogleMapController> _controller = Completer();
  final CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();

  Address? reverseGeocode;

  @override
  void dispose() {
    markerController.close();

    _completeAddressFieldController.dispose();
    _mobileNumberFieldController.dispose();
    _floorFieldController.dispose();
    _customInfoWindowController.dispose();
    _cityFieldController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (Hive.box(userDetailBoxKey).get(latitudeKey) != null &&
        Hive.box(userDetailBoxKey).get(latitudeKey) != "" &&
        Hive.box(userDetailBoxKey).get(latitudeKey) != "null") {
      storedLatitude = double.parse(Hive.box(userDetailBoxKey).get(latitudeKey).toString());
      storedLongitude = double.parse(Hive.box(userDetailBoxKey).get(longitudeKey).toString());
    } else {
      storedLatitude = 0.0;
      storedLongitude = 0.0;
    }

    if (widget.useStoredCordinates) {
//
      checkProviderAvailability(
        latitude: storedLatitude.toString(),
        longitude: storedLongitude.toString(),
      );
      //
      markerController.sink.add({
        Marker(
          markerId: const MarkerId("1"),
          position: LatLng(storedLatitude, storedLongitude),
          onTap: () {},
        )
      });

      initialCameraPosition =
          CameraPosition(zoom: 16, target: LatLng(storedLatitude, storedLongitude));
    } else if (!widget.useStoredCordinates) {
      //
      selectedLatitude = widget.place!.latitude;
      selectedLongitude = widget.place!.longitude;
      //
      checkProviderAvailability(
        latitude: widget.place!.latitude,
        longitude: widget.place!.longitude,
      );

      markerController.sink.add({
        Marker(
          markerId: const MarkerId("2"),
          position:
              LatLng(double.parse(widget.place!.latitude), double.parse(widget.place!.longitude)),
          onTap: () {},
        )
      });
      initialCameraPosition = CameraPosition(
        zoom: 16,
        target: LatLng(double.parse(widget.place!.latitude), double.parse(widget.place!.longitude)),
      );
    }

    addressDataModel = addressDataModel.copyWith(
      latitude: storedLatitude.toString(),
      longitude: storedLongitude.toString(),
      cityId: "",
      mobile: "",
      alternateMobile: "",
      isDefault: "0",
      type: widget.addressDetails?.type ?? "",
    );

    if (widget.useStoredCordinates) {
      createAddressFromCordinates(storedLatitude, storedLongitude);
    } else {
      createAddressFromCordinates(
        double.parse(widget.place!.latitude),
        double.parse(widget.place!.longitude),
      );
    }
  }

  Future<void> createAddressFromCordinates(final latitude, final longitude) async {
    _customInfoWindowController.hideInfoWindow?.call();
    placeMark = await GeocodingPlatform.instance.placemarkFromCoordinates(latitude, longitude);
    name = placeMark[0].name;
    subLocality = placeMark[0].subLocality;
    locality = placeMark[0].locality;
    final administrativeArea = placeMark[0].administrativeArea;
    final String? postalCode = placeMark[0].postalCode;
    final country = placeMark[0].country;
    final temp = [];
    final List addressList = [];
    temp
      ..add(name ?? "")
      ..add(subLocality ?? "")
      ..add(locality ?? "")
      ..add(administrativeArea ?? "")
      ..add(postalCode ?? "")
      ..add(country ?? "");

    for (final elem in temp) {
      if (elem != "") {
        addressList.add(elem);
      }
    }

    lineOneAddress =
        filterAddressString("$name,$subLocality,${placeMark[0].locality},${placeMark[0].country}");

    lineTwoAddress = filterAddressString("$postalCode,$locality,$administrativeArea");
    //

    //
    addressDataModel = addressDataModel.copyWith(
      area: locality,
      country: country,
      state: administrativeArea,
      pincode: postalCode,
    );
    address = addressList.join(", ");
    setState(() {});
  }

  Future<void> checkProviderAvailability({
    required final String latitude,
    required final String longitude,
  }) async {
    context.read<CheckProviderAvailabilityCubit>().checkProviderAvailability(
          isAuthTokenRequired: false,
          checkingAtCheckOut: "0",
          latitude: latitude,
          longitude: longitude,
        );
  }

  Future<void> _onTapGoogleMap(final LatLng position) async {
    _customInfoWindowController.hideInfoWindow!();

    markerController.sink.add({
      Marker(
        markerId: const MarkerId("1"),
        position: position,
        onTap: () {
          _customInfoWindowController.addInfoWindow!(_infoWindowContainer(), position);
        },
      )
    });

    await checkProviderAvailability(
      latitude: position.latitude.toString(),
      longitude: position.longitude.toString(),
    );

    addressDataModel = addressDataModel.copyWith(
      latitude: position.latitude.toString(),
      longitude: position.longitude.toString(),
    );

    createAddressFromCordinates(position.latitude, position.longitude);
  }

  void _onMapCreated(final controller) {
    _controller.complete(controller);
    _customInfoWindowController.googleMapController = controller;
  }

  Future<void> _placeMarkerOnLatitudeAndLongitude(
      {required final double latitude, required final double longitude}) async {
    //
    selectedLatitude = latitude.toString();
    selectedLongitude = longitude.toString();
    //
    await checkProviderAvailability(latitude: latitude.toString(), longitude: longitude.toString());
    //
    final latLong = LatLng(latitude, longitude);
    final Marker marker = Marker(
      markerId: const MarkerId("1"),
      position: latLong,
      onTap: () {
        _customInfoWindowController.addInfoWindow!(_infoWindowContainer(), latLong);
      },
    );
    markerController.sink.add({marker});

    final GoogleMapController controller = await _controller.future;

    final newCameraPosition =
        CameraUpdate.newCameraPosition(CameraPosition(zoom: 15, target: latLong));
    await controller.animateCamera(newCameraPosition);
    createAddressFromCordinates(latitude, longitude);
  }

  void _onMyCurrentLocationClicked() {
    GetLocation().getPosition().then((final Position? value) async {
      if (value == null) {
        await GetLocation().requestPermission(
          allowed: (final Position position) {
            _placeMarkerOnLatitudeAndLongitude(
              latitude: position.latitude,
              longitude: position.longitude,
            );
          },
          onGranted: (final Position position) {
            _placeMarkerOnLatitudeAndLongitude(
              latitude: position.latitude,
              longitude: position.longitude,
            );
          },
          onRejected: () {},
        );
      } else {
        _placeMarkerOnLatitudeAndLongitude(latitude: value.latitude, longitude: value.longitude);
      }
    });
  }

  Container _infoWindowContainer() => Container(
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.blackColor,
          shape: const TooltipShapeBorder(radius: 10),
          shadows: const [BoxShadow(color: Colors.black26, blurRadius: 1, offset: Offset(2, 2))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'yourServiceWillHere'.translate(context: context),
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Theme.of(context).colorScheme.secondaryColor,
              ),
            ),
            Text(
              'movePinToLocation'.translate(context: context),
              style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.lightGreyColor),
            )
          ],
        ),
      );

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: UiUtils.getSimpleAppBar(
          context: context,
          title: 'selectLocation'.translate(context: context),
          backgroundColor: Theme.of(context).colorScheme.secondaryColor,
        ),
        body: WillPopScope(
          onWillPop: () async =>
              Future.delayed(const Duration(milliseconds: 1000)).then((final value) => true),
          child: StreamBuilder(
            stream: markerController.stream,
            initialData: {initialLocation},
            builder: (context, AsyncSnapshot snapshot) =>
                BlocListener<AddAddressCubit, AddAddressState>(
              listener: (final BuildContext context, AddAddressState state) {
                if (state is AddAddressSuccess) {
                  _updateLocation(snapshot);

                  Navigator.of(context).pop();
                  Navigator.of(context).pop(widget.addressDetails == null ? null : true);
                }
              },
              child: Stack(
                children: [
                  GoogleMap(
                    zoomControlsEnabled: false,
                    markers: Set.of(snapshot.data),
                    onTap: (final LatLng position) async {
                      _onTapGoogleMap(position);
                    },
                    onCameraMove: (final position) {
                      _customInfoWindowController.onCameraMove!();
                    },
                    onMapCreated: (GoogleMapController controller) async {
                      if (context.read<AppThemeCubit>().state.appTheme == AppTheme.dark) {
                        await controller.setMapStyle(
                          await rootBundle.loadString("assets/mapTheme/darkMap.json"),
                        );
                        setState(() {});
                      }
                      _onMapCreated(controller);
                    },
                    minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                    initialCameraPosition: initialCameraPosition,
                  ),
                  CustomInfoWindow(
                    controller: _customInfoWindowController,
                    height: 60.rh(context),
                    width: 186.rw(context),
                    offset: 48,
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.bottomEnd,
                            child: Container(
                              margin: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 5,
                                    color:
                                        Theme.of(context).colorScheme.blackColor.withOpacity(0.2),
                                  )
                                ],
                              ),
                              child: Material(
                                type: MaterialType.circle,
                                color: Theme.of(context).colorScheme.secondaryColor,
                                clipBehavior: Clip.antiAlias,
                                child: CustomInkWellContainer(
                                  onTap: _onMyCurrentLocationClicked,
                                  child: SizedBox(
                                    width: 60.rw(context),
                                    height: 60.rh(context),
                                    child: Icon(
                                      Icons.my_location_outlined,
                                      size: 35,
                                      color: Theme.of(context).colorScheme.blackColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          BlocBuilder<CheckProviderAvailabilityCubit,
                              CheckProviderAvailabilityState>(
                            builder: (final context, final checkProviderAvailabilityState) {
                              if (checkProviderAvailabilityState
                                  is CheckProviderAvailabilityFetchSuccess) {
                                return BlocBuilder<AddAddressCubit, AddAddressState>(
                                  builder:
                                      (final BuildContext context, final AddAddressState state) =>
                                          Container(
                                    height: 150,
                                    width: MediaQuery.sizeOf(context).width,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.secondaryColor,
                                      boxShadow: [
                                        BoxShadow(
                                          offset: const Offset(0, -5),
                                          blurRadius: 4,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .blackColor
                                              .withOpacity(0.2),
                                        )
                                      ],
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(borderRadiusOf20),
                                        topRight: Radius.circular(borderRadiusOf20),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  CustomSvgPicture(
                                                    svgImage: "current_location.svg",
                                                    height: 20,
                                                    width: 20,
                                                    color: Theme.of(context).colorScheme.blackColor,
                                                  ),
                                                  SizedBox(
                                                    width: 10.rw(context),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        if (checkProviderAvailabilityState.error)
                                                          Text(
                                                            "serviceNotAvailableAtSelectedLocation"
                                                                .translate(context: context),
                                                            maxLines: 1,
                                                            softWrap: true,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.normal,
                                                              color: Theme.of(context)
                                                                  .colorScheme
                                                                  .blackColor,
                                                            ),
                                                          )
                                                        else
                                                          Text(
                                                            lineOneAddress,
                                                            maxLines: 1,
                                                            softWrap: true,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.bold,
                                                              color: Theme.of(context)
                                                                  .colorScheme
                                                                  .blackColor,
                                                            ),
                                                          ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        if (!checkProviderAvailabilityState.error)
                                                          Text(
                                                            lineTwoAddress,
                                                            maxLines: 1,
                                                            softWrap: true,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: Theme.of(context)
                                                                  .colorScheme
                                                                  .lightGreyColor,
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          if (!checkProviderAvailabilityState.error)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 16,
                                                right: 16,
                                                bottom: 12,
                                              ),
                                              child: widget.googleMapButton ==
                                                      GoogleMapButton.completeAddress
                                                  ? CustomRoundedButton(
                                                      onTap: () {
                                                        _showAddressSheet(
                                                          context,
                                                        );
                                                      },
                                                      widthPercentage: 0.9,
                                                      backgroundColor:
                                                          Theme.of(context).colorScheme.accentColor,
                                                      buttonTitle: 'completeAddress'
                                                          .translate(context: context),
                                                      showBorder: false,
                                                    )
                                                  : CustomRoundedButton(
                                                      backgroundColor:
                                                          Theme.of(context).colorScheme.accentColor,
                                                      widthPercentage: 0.9,
                                                      showBorder: false,
                                                      buttonTitle: 'confirmAddress'
                                                          .translate(context: context),
                                                      onTap: () {
                                                        Hive.box(userDetailBoxKey)
                                                            .put(locationName, lineOneAddress);
                                                        //
                                                        if (widget.googleMapButton ==
                                                            GoogleMapButton.confirmAddress) {
                                                          Hive.box(userDetailBoxKey).put(
                                                            latitudeKey,
                                                            selectedLatitude,
                                                          );
                                                          Hive.box(userDetailBoxKey).put(
                                                            longitudeKey,
                                                            selectedLongitude,
                                                          );
                                                        }

                                                        Future.delayed(Duration.zero, () {
                                                          context
                                                              .read<HomeScreenCubit>()
                                                              .fetchHomeScreenData();
                                                          //
                                                          if (Routes.previousRoute ==
                                                              allowLocationScreenRoute) {
                                                            Navigator.popUntil(
                                                              context,
                                                              (final Route route) => route.isFirst,
                                                            );
                                                          } else {
                                                            Navigator.of(context)
                                                                .pushNamedAndRemoveUntil(
                                                              navigationRoute,
                                                              (final route) => false,
                                                            );
                                                          }
                                                        });
                                                      },
                                                    ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return Container(
                                height: 150,
                                width: MediaQuery.sizeOf(context).width,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.secondaryColor,
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(0, -5),
                                      blurRadius: 4,
                                      color:
                                          Theme.of(context).colorScheme.blackColor.withOpacity(0.2),
                                    )
                                  ],
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(borderRadiusOf20),
                                    topRight: Radius.circular(borderRadiusOf20),
                                  ),
                                ),
                                child: Center(
                                  child: (checkProviderAvailabilityState
                                          is CheckProviderAvailabilityFetchFailure)
                                      ? Text("somethingWentWrong".translate(context: context))
                                      : Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            ShimmerLoadingContainer(
                                              child: CustomShimmerContainer(
                                                height: 10,
                                                width: MediaQuery.sizeOf(context).width * 0.9,
                                                borderRadius: borderRadiusOf10,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ShimmerLoadingContainer(
                                              child: CustomShimmerContainer(
                                                height: 10,
                                                width: MediaQuery.sizeOf(context).width * 0.9,
                                                borderRadius: borderRadiusOf10,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ShimmerLoadingContainer(
                                              child: CustomShimmerContainer(
                                                height: 10,
                                                width: MediaQuery.sizeOf(context).width * 0.9,
                                                borderRadius: borderRadiusOf10,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );

  void _showAddressSheet(
    final BuildContext context,
  ) {
    final addAddressCubit = context.read<AddAddressCubit>();
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadiusOf20),
          topRight: Radius.circular(borderRadiusOf20),
        ),
      ),
      builder: (final context) => Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: BlocProvider.value(
          value: addAddressCubit,
          child: Builder(
            builder: (final context) => AddressSheet(
              isUpdateAddress: widget.addressDetails == null ? false : true,
              addressId: widget.addressDetails == null ? null : widget.addressDetails!.id,
              mobileNumberFieldController: _mobileNumberFieldController,
              completeAddressFieldController: _completeAddressFieldController,
              floorFieldController: _floorFieldController,
              addressDataModel: addressDataModel,
              cityFieldController: _cityFieldController,
            ),
          ),
        ),
      ),
    );
  }
}

void _updateLocation(final snapshot) {
  if (snapshot.hasData) {
    final position = snapshot.data.elementAt(0).position;

    Hive.box(userDetailBoxKey)
      ..put(latitudeKey, position.latitude.toString())
      ..put(longitudeKey, position.longitude.toString());
  }
}

enum GoogleMapButton { completeAddress, confirmAddress }
