import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class AddressSheet extends StatefulWidget {
  const AddressSheet({
    required this.cityFieldController,
    required this.mobileNumberFieldController,
    required this.addressDataModel,
    required this.completeAddressFieldController,
    required this.floorFieldController,
    final Key? key,
    this.addressId,
    this.isUpdateAddress,
  }) : super(key: key);
  final bool? isUpdateAddress;
  final String? addressId;
  final TextEditingController completeAddressFieldController;
  final TextEditingController floorFieldController;
  final TextEditingController cityFieldController;
  final TextEditingController mobileNumberFieldController;
  final AddressModel addressDataModel;

  @override
  State<AddressSheet> createState() => _AddressSheetState();
}

class _AddressSheetState extends State<AddressSheet> {
  int locationTypeAddressIndex = 0;
  late AddressModel addressDataModel;
  Map<int, String> locationType = {0: "home", 1: "Office", 2: "Other"};
  bool isSetDefaultAddress = false;
  final GlobalKey<FormState> _addressFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    addressDataModel = widget.addressDataModel;
    locationTypeAddressIndex = widget.addressDataModel.type == "Office"
        ? 1
        : widget.addressDataModel.type == "Other"
            ? 2
            : 0;
  }

  @override
  void dispose() {
    widget.cityFieldController.dispose();
    widget.floorFieldController.dispose();
    widget.mobileNumberFieldController.dispose();
    widget.completeAddressFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(borderRadiusOf20),
            topRight: Radius.circular(borderRadiusOf20),
          ),
        ),
        height: MediaQuery.sizeOf(context).height * 0.65,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 50,
              width: MediaQuery.sizeOf(context).width,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(borderRadiusOf20),
                  topRight: Radius.circular(borderRadiusOf20),
                ),
              ),
              child: Text(
                'enterCompleteAddress'.translate(context: context),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.blackColor,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.65 - 50,
              child: Form(
                key: _addressFormKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 15,
                    right: 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: _addressTextField(
                          validate: true,
                          controller: widget.completeAddressFieldController,
                          lable: 'addressLine1'.translateAndMakeItCompulsory(context: context),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: _addressTextField(
                          validate: true,
                          controller: widget.floorFieldController,
                          lable: 'area'.translateAndMakeItCompulsory(context: context),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: _addressTextField(
                          validate: true,
                          controller: widget.cityFieldController,
                          lable: 'city'.translateAndMakeItCompulsory(context: context),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: _addressTextField(
                          validate: true,
                          allowOnlyDigits: true,
                          controller: widget.mobileNumberFieldController,
                          textInputType: TextInputType.number,
                          lable: 'mobileNumber'.translateAndMakeItCompulsory(context: context),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      StatefulBuilder(
                        builder: (final context, final setState) {
                          addressDataModel = widget.addressDataModel
                              .copyWith(type: locationType[locationTypeAddressIndex]);
                          return Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: FlatOutlinedButton(
                                  isSelected: locationTypeAddressIndex == 0,
                                  name: 'home'.translate(context: context),
                                  onTap: () {
                                    addressDataModel = addressDataModel.copyWith(type: 'Home');
                                    locationTypeAddressIndex = 0;

                                    setState(() {});
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: FlatOutlinedButton(
                                  isSelected: locationTypeAddressIndex == 1,
                                  name: 'office'.translate(context: context),
                                  onTap: () {
                                    addressDataModel = addressDataModel.copyWith(type: 'Office');
                                    locationTypeAddressIndex = 1;
                                    setState(() {});
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: FlatOutlinedButton(
                                  isSelected: locationTypeAddressIndex == 2,
                                  name: 'other'.translate(context: context),
                                  onTap: () {
                                    addressDataModel = addressDataModel.copyWith(type: 'Other');
                                    locationTypeAddressIndex = 2;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          StatefulBuilder(
                            builder: (final context, final setState) => Checkbox(
                              activeColor: AppColors.whiteColors,
                              fillColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.accentColor,
                              ),
                              value: isSetDefaultAddress,
                              onChanged: (final value) {
                                isSetDefaultAddress = !isSetDefaultAddress;
                                addressDataModel = addressDataModel.copyWith(
                                  isDefault: isSetDefaultAddress ? "1" : "0",
                                );
                                setState(() {});
                              },
                            ),
                          ),
                          Text('setDefaultAddress'.translate(context: context)),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: BlocBuilder<AddAddressCubit, AddAddressState>(
                            builder: (final context, AddAddressState state) {
                              Widget? child;
                              if (state is AddAddressInProgress) {
                                child = CircularProgressIndicator(
                                  color: AppColors.whiteColors,
                                );
                              }
                              return CustomRoundedButton(
                                backgroundColor: Theme.of(context).colorScheme.accentColor,
                                buttonTitle: 'saveAddress'.translate(context: context),
                                showBorder: false,
                                widthPercentage: 0.9,
                                onTap: () {
                                  if (state is AddAddressInProgress) {
                                    return;
                                  }
                                  UiUtils.removeFocus();
                                  /*  if (widget.completeAddressFieldController.value.text.isEmpty) {
                                  UiUtils.showMessage(
                                      context,
                                      "pleaseEnterCompleteAddress".translate(context: context),
                                      MessageType.error);
                                  return;
                                }
                                if (widget.mobileNumberFieldController.text.isEmpty) {
                                  UiUtils.showMessage(
                                      context,
                                      "pleaseEnterMobileNumber".translate(context: context),
                                      MessageType.error);
                                  return;
                                }*/

                                  if (_addressFormKey.currentState!.validate()) {
                                    var floor = widget.floorFieldController.value.text.trim();
                                    floor = floor == '' ? '' : '$floor,';

                                    addressDataModel = addressDataModel.copyWith(
                                      mobile: widget.mobileNumberFieldController.value.text.trim(),
                                      address:
                                          widget.completeAddressFieldController.value.text.trim(),
                                      area: floor,
                                      cityName: widget.cityFieldController.value.text.trim(),
                                    );
                                    if (widget.isUpdateAddress ?? false) {
                                      final AddressModel model =
                                          addressDataModel.copyWith(addressId: widget.addressId);

                                      context.read<AddAddressCubit>().addAddress(model);

                                      //  context.read<AddressesCubit>().updateAddress(model.address_id,);
                                    } else {
                                      context.read<AddAddressCubit>().addAddress(addressDataModel);
                                    }
                                  }
                                },
                                child: child,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _addressTextField({
    required final String lable,
    final controller,
    final bool validate = false,
    final TextInputType? textInputType,
    final bool? allowOnlyDigits,
  }) =>
      TextFormField(
        inputFormatters: allowOnlyDigits ?? false ? UiUtils.allowOnlyDigits() : [],
        keyboardType: textInputType,
        controller: controller,
        cursorColor: Theme.of(context).colorScheme.blackColor,
        style: const TextStyle(fontSize: 14),
        validator: validate ? validateTextFild : null,
        decoration: InputDecoration(
          contentPadding: const EdgeInsetsDirectional.only(bottom: 2, start: 15),
          filled: true,
          fillColor: Theme.of(context).colorScheme.primaryColor,
          hintText: lable,
          labelText: lable,
          alignLabelWithHint: true,
          labelStyle: MaterialStateTextStyle.resolveWith((final Set<MaterialState> states) {
            if (states.contains(MaterialState.focused)) {
              return TextStyle(color: Theme.of(context).colorScheme.blackColor);
            }

            return TextStyle(color: Theme.of(context).colorScheme.blackColor);
          }),
          hintStyle: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.lightGreyColor),
          floatingLabelStyle: MaterialStateTextStyle.resolveWith(
            (final states) {
              final color = states.contains(MaterialState.error)
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.accentColor.withOpacity(0.5);
              return TextStyle(color: color, letterSpacing: 1.3);
            },
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.redColor),
            borderRadius: BorderRadius.circular(borderRadiusOf10),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.accentColor),
            borderRadius: BorderRadius.circular(borderRadiusOf10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.blackColor.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(borderRadiusOf10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.accentColor),
            borderRadius: BorderRadius.circular(borderRadiusOf10),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadiusOf10),
          ),
        ),
      );
}
