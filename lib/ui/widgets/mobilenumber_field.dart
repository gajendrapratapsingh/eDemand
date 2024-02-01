// ignore_for_file: file_names

import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class MobileNumberFiled extends StatefulWidget {

  const MobileNumberFiled({ required this.controller, final Key? key}) : super(key: key);
  final TextEditingController controller;

  @override
  State<MobileNumberFiled> createState() => _MobileNumberFiledState();
}

class _MobileNumberFiledState extends State<MobileNumberFiled> {
  @override
  Widget build(final BuildContext context) => TextFormField(
        controller: widget.controller,
        inputFormatters: UiUtils.allowOnlyDigits(),
        keyboardType: TextInputType.phone,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          contentPadding: const EdgeInsetsDirectional.only(bottom: 2, /*start: 15*/),
          filled: true,
          fillColor: Theme.of(context).colorScheme.primaryColor,
          hintStyle: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.lightGreyColor),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.accentColor),
              borderRadius: const BorderRadius.all(Radius.circular(borderRadiusOf10)),),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.accentColor),
              borderRadius: const BorderRadius.all(Radius.circular(borderRadiusOf10)),),
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.all(Radius.circular(borderRadiusOf10)),),
          errorStyle: const TextStyle(fontSize: 10),
          hintText: "hintMobileNumber".translate(context: context),
          prefixIcon: Padding(
            padding: const EdgeInsetsDirectional.only(start: 12,bottom: 2),
            child: BlocBuilder<CountryCodeCubit, CountryCodeState>(
              builder: (final BuildContext context, final CountryCodeState state) {
                var code = '--';

                if (state is CountryCodeFetchSuccess) {
                  code = state.selectedCountry!.callingCode;
                }

                return SizedBox(
                  height: 27.rw(context),

                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomInkWellContainer(
                        onTap: () {
                          if (allowOnlySingleCountry) {
                            return;
                          }
                          Navigator.pushNamed(context, countryCodePickerRoute).then(( Object?  value) {
                            Future.delayed(const Duration(milliseconds: 250)).then((final value) {
                              context.read<CountryCodeCubit>().fillTemporaryList();
                            });
                          });
                        },
                        child: Row(
                          children: [
                            Builder(
                              builder: (BuildContext context) {
                                if (state is CountryCodeFetchSuccess) {
                                  return SizedBox(
                                    width: 35.rw(context),
                                    height: 27.rh(context),
                                    child: Image.asset(
                                      state.selectedCountry!.flag,
                                      package: countryCodePackageName,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }
                                if (state is CountryCodeFetchFail) {
                                  return ErrorContainer(errorMessage: state.error);
                                }
                                return const CircularProgressIndicator();
                              },
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            if (!allowOnlySingleCountry)
                              CustomSvgPicture(
                                  svgImage: 'sp_down.svg',
                                  height: 5,
                                  width: 5,
                                  color: Theme.of(context).colorScheme.blackColor,),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        thickness: 1,
                        indent: 6,
                        endIndent: 6,
                        color: Theme.of(context).colorScheme.lightGreyColor,
                      ),
                      Text(
                        code,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.blackColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                        ),

                      ),
                      const SizedBox(
                        width: 5,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        validator: (final value) => validateNumber(value!),);
}
