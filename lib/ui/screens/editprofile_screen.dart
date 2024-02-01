import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    final Key? key,
    this.phoneNumberWithCountryCode,
    this.phoneNumberWithOutCountryCode,
    this.countryCode,
    this.source,
  }) : super(key: key);
  final String? phoneNumberWithCountryCode;
  final String? phoneNumberWithOutCountryCode;
  final String? countryCode;
  final String? source;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();

  static Route route(final RouteSettings routeSettings) => CupertinoPageRoute(
        builder: (final BuildContext context) {
          Map arguments = {};
          if (routeSettings.arguments != null) {
            arguments = routeSettings.arguments as Map;
          }

          return EditProfileScreen(
            phoneNumberWithOutCountryCode: arguments['phoneNumberWithOutCountryCode'] ?? '',
            phoneNumberWithCountryCode: arguments['phoneNumberWithCountryCode'] ?? '',
            countryCode: arguments['countryCode'] ?? '',
            source: arguments['source'] ?? '',
          );
        },
      );
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController usernameController =
      TextEditingController(text: Hive.box(userDetailBoxKey).get(userNameKey));
  final TextEditingController phoneNumberController = TextEditingController(
    text:
        "${Hive.box(userDetailBoxKey).get(countryCodeKey)}${Hive.box(userDetailBoxKey).get(phoneNumberKey)}",
  );
  final TextEditingController emailController = TextEditingController();

  UserDetailsModel? userDetails;
  File? selectedImage;

  @override
  void dispose() {
    emailController.dispose();
    phoneNumberController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.phoneNumberWithCountryCode != '' &&
        widget.phoneNumberWithCountryCode != null &&
        widget.phoneNumberWithCountryCode != 'null') {
      phoneNumberController.text = widget.phoneNumberWithCountryCode!;

      Future.delayed(
        Duration.zero,
        () {
          userDetails = context.read<UserDetailsCubit>().getUserDetails();
        },
      );
    }

    if (Hive.box(userDetailBoxKey).get(emailIdKey) != '' &&
        Hive.box(userDetailBoxKey).get(emailIdKey) != null) {
      emailController.text = Hive.box(userDetailBoxKey).get(emailIdKey);
    }
  }

  Future<void> _getFromGallery() async {
    final XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    final croppedFile = await _croppedImage(pickedFile!.path);

    setState(() {
      selectedImage = File(croppedFile!.path);
    });
  }

  Future<CroppedFile?> _croppedImage(String pickedFilePath) async {
    return ImageCropper().cropImage(
      sourcePath: pickedFilePath,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      cropStyle: CropStyle.circle,
      compressFormat: ImageCompressFormat.png,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Theme.of(context).colorScheme.background,
          initAspectRatio: CropAspectRatioPreset.square,
          activeControlsWidgetColor: Theme.of(context).primaryColor,
        ),
        IOSUiSettings(title: 'Cropper'),
      ],
    );
  }

  @override
  Widget build(final BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: UiUtils.getSystemUiOverlayStyle(context: context),
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primaryColor,
          appBar: UiUtils.getSimpleAppBar(
            context: context,
            title: 'editProfile'.translate(context: context),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: BlocConsumer<UpdateUserCubit, UpdateUserState>(
                listener: (context, UpdateUserState updateUserState) {
                  if (updateUserState is UpdateUserSuccess) {
                    final existingUserDetails =
                        (context.read<UserDetailsCubit>().state as UserDetails).userDetailsModel;

                    final newUserDetails =
                        existingUserDetails.fromMapCopyWith(updateUserState.updatedDetails.toMap());

                    context.read<UserDetailsCubit>().changeUserDetails(newUserDetails);
                  }
                },
                builder: (final context, UpdateUserState updateUserState) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.center,
                      child: Stack(
                        children: [
                          CustomInkWellContainer(
                            //  onTap: pickImage.pick,
                            onTap: () {
                              _getFromGallery();
                            },
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(borderRadiusOf50),
                                border: Border.all(color: Theme.of(context).colorScheme.blackColor),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: ClipRRect(
                                  //
                                  borderRadius: BorderRadius.circular(borderRadiusOf50),
                                  //
                                  child: selectedImage != null
                                      ? Image.file(
                                          File(selectedImage?.path ?? ""),
                                        )
                                      : (Hive.box(userDetailBoxKey).get(profileImageKey) == null ||
                                              Hive.box(userDetailBoxKey).get(profileImageKey) == '')
                                          ? CustomSvgPicture(
                                              svgImage: "dr_profile.svg",
                                              color: Theme.of(context).colorScheme.blackColor,
                                            )
                                          : CustomCachedNetworkImage(
                                              height: 100,
                                              width: 100,
                                              networkImageUrl:
                                                  Hive.box(userDetailBoxKey).get(profileImageKey) ??
                                                      '',
                                            ),
                                ),
                              ),
                            ),
                          ),
                          PositionedDirectional(
                            end: 0,
                            bottom: 5,
                            child: Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondaryColor,
                                borderRadius: BorderRadius.circular(borderRadiusOf5),
                              ),
                              padding: const EdgeInsets.all(3),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: Theme.of(context).colorScheme.accentColor,
                                size: 20,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const CustomDivider(
                      thickness: 0.4,
                    ),
                    InputFieldEditProfile(
                      hint: "username".translate(context: context),
                      controller: usernameController,
                    ),
                    InputFieldEditProfile(
                      hint: "phoneNumber".translate(context: context),
                      controller: phoneNumberController,
                      readOnly: true,
                    ),
                    InputFieldEditProfile(
                      hint: "email".translate(context: context),
                      controller: emailController,
                    ),
                    SizedBox(
                      height: 50.rh(context),
                    ),
                    BlocConsumer<UpdateUserCubit, UpdateUserState>(
                      listener: (final context, final state) {
                        if (state is UpdateUserSuccess) {
                          UiUtils.showMessage(
                            context,
                            "profileUpdateSuccess".translate(context: context),
                            MessageType.success,
                          );

                          if (Routes.previousRoute != otpVerificationRoute) {
                            //user is editing their profile details
                            Navigator.pop(context);
                          }
                        } else if (state is UpdateUserFail) {

                          UiUtils.showMessage(
                            context,
                            state.error.translate(context: context),
                            MessageType.error,
                          );
                        }
                      },
                      builder: (final BuildContext context, UpdateUserState state) {
                        Widget? child;
                        if (state is UpdateUserInProgress) {
                          child = CircularProgressIndicator(color: AppColors.whiteColors);
                        } else if (state is UpdateUserSuccess || state is UpdateUserFail) {
                          child = null;
                        }
                        return SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          height: 48,
                          child: CustomRoundedButton(
                            onTap: () async {
                              //validation of username
                              UiUtils.removeFocus();
                              if (state is UpdateUserInProgress) {
                                return;
                              }

                              if (usernameController.value.text.trim().isEmpty) {
                                UiUtils.showMessage(
                                  context,
                                  "pleaseEnterUserName".translate(context: context),
                                  MessageType.error,
                                );

                                return;
                              }
                              if (emailController.value.text.trim().isEmpty) {
                                UiUtils.showMessage(
                                  context,
                                  "pleaseEnterEmail".translate(context: context),
                                  MessageType.error,
                                );

                                return;
                              }
                              if (!isValidEmail(email: emailController.value.text.trim())) {
                                UiUtils.showMessage(
                                  context,
                                  "pleaseEnterCorrectEmail".translate(context: context),
                                  MessageType.error,
                                );

                                return;
                              }

                              //if user is registering their profile first time
                              if (Routes.previousRoute == otpVerificationRoute) {
                                final latitude =
                                    Hive.box(userDetailBoxKey).get(latitudeKey) ?? "0.0";
                                final longitude =
                                    Hive.box(userDetailBoxKey).get(longitudeKey) ?? "0.0";

                                await AuthenticationRepository.loginUser(
                                  countryCode: widget.countryCode!,
                                  mobileNumber: widget.phoneNumberWithOutCountryCode!,
                                  latitude: latitude.toString(),
                                  longitude: longitude.toString(),
                                ).then(
                                  (final UserDetailsModel value) async {
                                    //
                                    context.read<UserDetailsCubit>().setUserDetails(value);
                                    //
                                    final UpdateUserDetails updateUserDetails = UpdateUserDetails(
                                      email: emailController.value.text,
                                      phone: Hive.box(userDetailBoxKey).get(phoneNumberKey),
                                      countryCode: Hive.box(userDetailBoxKey).get(countryCodeKey),
                                      username: usernameController.value.text,
                                      image: selectedImage ?? "",
                                    );
                                    //
                                    await context
                                        .read<UpdateUserCubit>()
                                        .updateUserDetails(updateUserDetails);

                                    //update user authenticated status
                                    Hive.box(authStatusBoxKey)
                                      ..put(isUserFirstTime, false)
                                      ..put(isAuthenticated, true);
                                    if (mounted) {
                                      context.read<AuthenticationCubit>().checkStatus();
                                    }
                                    //update fcm id
                                    try {
                                      await FirebaseMessaging.instance
                                          .getToken()
                                          .then((value) async {
                                        await UserRepository().updateFCM(
                                          fcmId: value ?? "",
                                          platform: Platform.isAndroid ? "android" : "ios",
                                        );
                                      });
                                    } catch (_) {}
                                    //
                                    Future.delayed(
                                      Duration.zero,
                                      () {
                                        if (widget.source == "dialog") {
                                          try {
                                            context
                                                .read<CartCubit>()
                                                .getCartDetails(isReorderCart: false);
                                            context
                                                .read<BookmarkCubit>()
                                                .fetchBookmark(type: 'list');
                                            context.read<UserDetailsCubit>().loadUserDetails();
                                          } catch (_) {}
                                          //
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        } else {
                                          bottomNavigationBarGlobalKey.currentState
                                              ?.selectedIndexOfBottomNavigationBar.value = 0;
                                          Navigator.pop(context);

                                          Navigator.pushReplacementNamed(context, navigationRoute);
                                        }
                                      },
                                    );
                                  },
                                );
                              } else {
                                //if user is editing their profile then directly update their data
                                final UpdateUserDetails updateUserDetails = UpdateUserDetails(
                                  email: emailController.value.text,
                                  phone: Hive.box(userDetailBoxKey).get(phoneNumberKey),
                                  countryCode: Hive.box(userDetailBoxKey).get(countryCodeKey),
                                  username: usernameController.value.text,
                                  image: selectedImage ?? "",
                                );
                                //  UserRepository().updateUserDetails(updateUserDetails);

                                context
                                    .read<UpdateUserCubit>()
                                    .updateUserDetails(updateUserDetails);
                              }
                            },
                            buttonTitle: "saveChanges".translate(context: context),
                            backgroundColor: Theme.of(context).colorScheme.accentColor,
                            showBorder: false,
                            widthPercentage: 0.9,
                            child: child,
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

class InputFieldEditProfile extends StatelessWidget {
  const InputFieldEditProfile({
    required this.hint,
    required this.controller,
    final Key? key,
    this.readOnly,
  }) : super(key: key);
  final String hint;
  final TextEditingController controller;
  final bool? readOnly;

  @override
  Widget build(final BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SizedBox(
          child: Theme(
            data: ThemeData(
              inputDecorationTheme: InputDecorationTheme(
                suffixIconColor: MaterialStateColor.resolveWith((final Set<MaterialState> states) {
                  if (states.contains(MaterialState.focused)) {
                    return Colors.black;
                  }
                  return Colors.grey;
                }),
              ),
            ),
            child: TextField(
              readOnly: readOnly ?? false,
              controller: controller,
              style: TextStyle(color: Theme.of(context).colorScheme.blackColor),
              decoration: InputDecoration(
                isDense: true,
                hintStyle: TextStyle(color: Theme.of(context).colorScheme.lightGreyColor),
                hintText: hint,
                iconColor: AppColors.redColor,
                fillColor: Theme.of(context).colorScheme.secondaryColor,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadiusOf10)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.secondaryColor),
                  borderRadius: const BorderRadius.all(Radius.circular(borderRadiusOf10)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.accentColor),
                  borderRadius: BorderRadius.circular(borderRadiusOf15),
                ),
              ),
            ),
          ),
        ),
      );
}

/// * */
/*selectImage(final image) {
  if (image != null) {
    return FileImage(image);
  } else {
    if (Hive.box(userDetailBoxKey).isNotEmpty) {
      if (Hive.box(userDetailBoxKey).get(profileImageKey) != "" &&
          Hive.box(userDetailBoxKey).get(profileImageKey) != null) {
        return CachedNetworkImageProvider(
            Hive.box(userDetailBoxKey).get(profileImageKey).toString(),);
      } else {
        return const AssetImage("assets/images/PngItem_1468479.png");
      }
    }
  }
}*/
