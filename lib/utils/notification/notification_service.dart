import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static FirebaseMessaging messagingInstance = FirebaseMessaging.instance;
  static LocalAwsomeNotification localNotification = LocalAwsomeNotification();
  static late StreamSubscription<RemoteMessage> foregroundStream;
  static late StreamSubscription<RemoteMessage> onMessageOpen;

  static Future<void> requestPermission() async {
    //
    await messagingInstance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    //
  }

  static void init(final context) {
    requestPermission();
    registerListeners(context);
    try {
      FirebaseMessaging.instance.getToken().then((final value) async {
        if (value != "" && value != null && Hive.box(userDetailBoxKey).get(tokenIdKey) != null) {
          await UserRepository().updateFCM(
            fcmId: value,
            platform: Platform.isAndroid ? "android" : "ios",
          );
        }
      });
    } catch (_) {}
  }

  @pragma('vm:entry-point')
  static Future<void> onBackgroundMessageHandler(final RemoteMessage message) async {
    if (message.data["image"] == null) {
      localNotification.createNotification(isLocked: false, notificationData: message);
    } else {
      localNotification.createImageNotification(isLocked: false, notificationData: message);
    }
    // localNotification.createNotification(isLocked: false, notificationData: message);
  }

  static Future foregroundNotificationHandler() async {
    foregroundStream = FirebaseMessaging.onMessage.listen((final RemoteMessage message) {
      if (message.data["image"] == null) {
        localNotification.createNotification(isLocked: false, notificationData: message);
      } else {
        localNotification.createImageNotification(isLocked: false, notificationData: message);
      }
    });
  }

  static Future terminatedStateNotificationHandler() async {
    FirebaseMessaging.instance.getInitialMessage().then(
      (final RemoteMessage? message) {
        if (message == null) {
          return;
        }
        if (message.data["image"] == null) {
          localNotification.createNotification(isLocked: false, notificationData: message);
        } else {
          localNotification.createImageNotification(isLocked: false, notificationData: message);
        }
        // localNotification.createNotification(isLocked: false, notificationData: message);
      },
    );
  }

  static Future<void> onTapNotificationHandler(final context) async {
    onMessageOpen = FirebaseMessaging.onMessageOpenedApp.listen(
      (final message) async {
        if (message.data["type"] == "category") {
          if (message.data["parent_id"] == "0") {
            await Navigator.pushNamed(
              context,
              subCategoryRoute,
              arguments: {
                'subCategoryId': '',
                'categoryId': message.data["category_id"],
                'appBarTitle': message.data["category_name"],
                'type': CategoryType.category
              },
            );
          } else {
            await Navigator.pushNamed(
              context,
              subCategoryRoute,
              arguments: {
                'subCategoryId': message.data["category_id"],
                'categoryId': '',
                'appBarTitle': message.data["category_name"],
                'type': CategoryType.subcategory
              },
            );
          }
        } else if (message.data["type"] == "provider") {
          await Navigator.pushNamed(
            context,
            providerRoute,
            arguments: {'providerId': message.data["provider_id"]},
          );
        } else if (message.data["type"] == "order") {
          //navigate to booking tab

          //    bottomNavigationBarGlobalKey.currentState?.selectedIndexOfBottomNavigationBar.value = 1;
        } else if (message.data["type"] == "url") {
          final url = message.data["url"].toString();
          try {
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
            } else {
              throw 'Could not launch $url';
            }
          } catch (e) {
            throw 'Something went wrong';
          }
        }
      },
    );
  }

  static Future<void> registerListeners(final context) async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
    await foregroundNotificationHandler();
    await terminatedStateNotificationHandler();
    await onTapNotificationHandler(context);
  }

  static void disposeListeners() {
    onMessageOpen.cancel();
    foregroundStream.cancel();
  }
}
