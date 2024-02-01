import 'package:e_demand/app/generalImports.dart';
import "package:flutter/material.dart";

Future<void> initApp() async {
  //

  //
  WidgetsFlutterBinding.ensureInitialized();

  //locked in portrait mode only
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  //

  if (Firebase.apps.isNotEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp();
  }
  //firebase Crashlytics
/*  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };*/
  //firebase Crashlytics end
  //
  FirebaseMessaging.onBackgroundMessage(NotificationService.onBackgroundMessageHandler);
  try {
    await FirebaseMessaging.instance.getToken();
  } catch (_) {}

  await Hive.initFlutter();
  await Hive.openBox(authStatusBoxKey);

  await Hive.openBox(themeBoxKey);

  await Hive.openBox(userDetailBoxKey);
  await Hive.openBox(languageBox);

  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children:  [
          const Icon(
            Icons.error_outline_outlined,
            color: Colors.red,
            size: 100,
          ),
          Text( errorDetails.exception.toString(),
          ),
        ],
      ),
    );
  };

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (final context) => CountryCodeCubit(),
        ),
        BlocProvider(
          create: (final context) => AuthenticationCubit(),
        ),
        BlocProvider(
          create: (final context) => VerifyPhoneNumberCubit(),
        ),
        BlocProvider(
          create: (final context) => VerifyOtpCubit(),
        ),
        BlocProvider(
          create: (final context) => CategoryCubit(CategoryRepository()),
        ),
        // BlocProvider(
        //   create: (context) => CountDownCubit(),
        // ),
        BlocProvider(create: (final context) => NotificationsCubit()),
        BlocProvider<SectionCubit>(create: (final _) => SectionCubit(SectionRepository())),
        BlocProvider<AppThemeCubit>(create: (final _) => AppThemeCubit(SettingRepository())),
        BlocProvider(
          create: (final context) => ResendOtpCubit(),
        ),
        BlocProvider(
          create: (final BuildContext context) =>
              SystemSettingCubit(settingRepository: SettingRepository()),
        ),
        BlocProvider(
          create: (final context) => GeolocationCubit(),
        ),
        BlocProvider<ProviderDetailsAndServiceCubit>(
          create: (final _) =>
              ProviderDetailsAndServiceCubit(ServiceRepository(), ProviderRepository()),
        ),
        BlocProvider(
          create: (final context) => LanguageCubit(),
        ),
        BlocProvider<ChangeBookingStatusCubit>(
          create: (final BuildContext context) =>
              ChangeBookingStatusCubit(bookingRepository: BookingRepository()),
        ),
        BlocProvider<DownloadInvoiceCubit>(
          create: (final BuildContext context) => DownloadInvoiceCubit(BookingRepository()),
        ),
        BlocProvider(
          create: (final context) => UserDetailsCubit(),
        ),
        BlocProvider(
          create: (final context) => AddAddressCubit(),
        ),
        BlocProvider(
          create: (final context) => UpdateUserCubit(),
        ),
        BlocProvider(
          create: (final context) => DeleteAddressCubit(),
        ),
        BlocProvider(
          create: (final BuildContext context) => AddressesCubit(),
        ),
        BlocProvider(
          create: (final context) => GooglePlaceAutocompleteCubit(),
        ),
        BlocProvider(
          create: (final context) => SubCategoryAndProviderCubit(
            subCategoryRepository: SubCategoryRepository(),
            providerRepository: ProviderRepository(),
          ),
        ),
        BlocProvider(
          create: (final context) => ProviderCubit(ProviderRepository()),
        ),
        BlocProvider(
          create: (final context) => GetAddressCubit(),
        ),
        BlocProvider(
          create: (final BuildContext context) => ReviewCubit(ReviewRepository()),
        ),
        BlocProvider(
          create: (final context) => BookmarkCubit(BookmarkRepository()),
        ),
        BlocProvider(
          create: (final context) => HomeScreenCubit(HomeScreenRepository()),
        ),
        BlocProvider(
          create: (final context) => BookingCubit(BookingRepository()),
        ),
        BlocProvider(
          create: (final context) => CartCubit(CartRepository()),
        ),
        BlocProvider(
          create: (final context) =>
              VerifyPhoneNumberFromAPICubit(authenticationRepository: AuthenticationRepository()),
        ),
        BlocProvider<GetPromocodeCubit>(
          create: (final context) => GetPromocodeCubit(cartRepository: CartRepository()),
        ),
      ],
      child: const App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({final Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  //
  //
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero).then((final value) {
      if (Hive.box(themeBoxKey).get(isDarkThemeEnable) != null &&
          Hive.box(themeBoxKey).get(isDarkThemeEnable)) {
        context.read<AppThemeCubit>().changeTheme(AppTheme.dark);
      } else {
        context.read<AppThemeCubit>().changeTheme(AppTheme.light);
      }
    });

    context.read<LanguageCubit>().loadCurrentLanguage();
  }

  @override
  Widget build(final BuildContext context) => Builder(
        builder: (final context) {
          final AppTheme currentTheme = context.watch<AppThemeCubit>().state.appTheme;
          return BlocBuilder<LanguageCubit, LanguageState>(
            builder: (final BuildContext context, final LanguageState languageState) =>
                GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: MaterialApp(
                localizationsDelegates: const [
                  AppLocalization.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: appLanguages
                    .map((final language) =>
                        UiUtils.getLocaleFromLanguageCode(language.languageCode),)
                    .toList(),
                theme: appThemeData[currentTheme],
                title: appName,
                locale: (languageState is LanguageLoader)
                    ? Locale(languageState.languageCode)
                    : const Locale(defaultLanguageCode),
                debugShowCheckedModeBanner: false,
                onGenerateRoute: Routes.onGeneratedRoute,
                initialRoute: splashRoute,
                builder: (final context, final widget) =>
                    ScrollConfiguration(behavior: GlobalScrollBehavior(), child: widget!),
              ),
            ),
          );
        },
      );
}

///To remove scroll-glow from the ListView/GridView etc..
class CustomScrollBehaviour extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
          final BuildContext context, final Widget child, final ScrollableDetails details,) =>
      child;
}

///To apply BouncingScrollPhysics() to every scrollable widget
class GlobalScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(final BuildContext context) => const BouncingScrollPhysics();
}
