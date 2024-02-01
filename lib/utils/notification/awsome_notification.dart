import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class LocalAwsomeNotification {
  AwesomeNotifications notification = AwesomeNotifications();

//****** */
  String notificationChannel = "basic_channel";

  void init(final BuildContext context) {
    requestPermission();

    notification.initialize(
      null,
      [
        NotificationChannel(
          playSound: true,
          channelKey: notificationChannel,
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel',
          importance: NotificationImportance.High,
          ledColor: Colors.white,
        )
      ],
      channelGroups: [],
    );
    listenTap(context);
  }

  void listenTap(final context) {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: (ReceivedAction event) async {
        final data = event.payload;
        if (data?["type"] == "category") {
          if (data?["parent_id"] == "0") {
            await Navigator.pushNamed(
              context,
              subCategoryRoute,
              arguments: {
                'subCategoryId': '',
                'categoryId': data?["category_id"],
                'appBarTitle': data?["category_name"],
                'type': CategoryType.category
              },
            );
          } else {
            await Navigator.pushNamed(
              context,
              subCategoryRoute,
              arguments: {
                'subCategoryId': data?["category_id"],
                'categoryId': '',
                'appBarTitle': data?["category_name"],
                'type': CategoryType.subcategory
              },
            );
          }
        } else if (data?["type"] == "provider") {
          await Navigator.pushNamed(
            context,
            providerRoute,
            arguments: {'providerId': data?["provider_id"]},
          );
        } else if (data?["type"] == "order") {
          //navigate to booking tab
          //bottomNavigationBarGlobalKey.currentState?.selectedIndexOfBottomNavigationBar.value = 1;
        } else if (data?["type"] == "url") {
          final url = data!["url"].toString();
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
    /*notification.actionStream.listen((final ReceivedAction event) async {
      final data = event.payload;
      if (data?["type"] == "category") {
        if (data?["parent_id"] == "0") {
          await Navigator.pushNamed(
            context,
            subCategoryRoute,
            arguments: {
              'subCategoryId': '',
              'categoryId': data?["category_id"],
              'appBarTitle': data?["category_name"],
              'type': CategoryType.category
            },
          );
        } else {
          await Navigator.pushNamed(
            context,
            subCategoryRoute,
            arguments: {
              'subCategoryId': data?["category_id"],
              'categoryId': '',
              'appBarTitle': data?["category_name"],
              'type': CategoryType.subcategory
            },
          );
        }
      } else if (data?["type"] == "provider") {
        await Navigator.pushNamed(
          context,
          providerRoute,
          arguments: {'providerId': data?["provider_id"]},
        );
      } else if (data?["type"] == "order") {
        //navigate to booking tab
        //bottomNavigationBarGlobalKey.currentState?.selectedIndexOfBottomNavigationBar.value = 1;
      } else if (data?["type"] == "url") {
        final url = data!["url"].toString();
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
    });*/
  }

  Future<void> createNotification(
      {required final RemoteMessage notificationData, required final bool isLocked,}) async {
    try {
      await notification
          .createNotification(
            content: NotificationContent(
              id: Random().nextInt(5000),
              title: notificationData.data["title"] ?? "",
              locked: isLocked,
              payload: Map.from(notificationData.data),
              autoDismissible: true,
              body: notificationData.data["body"] ?? "",
              color: const Color.fromARGB(255, 79, 54, 244),
              wakeUpScreen: true,
              channelKey: notificationChannel,
              notificationLayout: NotificationLayout.BigText,
            ),
          )
          .then((final bool value) {})
          .onError((final error, stackTrace) {});
    } catch (_) {
      //
    }
  }

  Future<void> createImageNotification(
      {required final RemoteMessage notificationData, required final bool isLocked,}) async {
    try {
      await notification
          .createNotification(
            content: NotificationContent(
              id: Random().nextInt(5000),
              title: notificationData.data["title"] ?? "",
              locked: isLocked,
              payload: Map.from(notificationData.data),
              autoDismissible: true,
              body: notificationData.data["body"] ?? "",
              color: const Color.fromARGB(255, 79, 54, 244),
              wakeUpScreen: true,
              channelKey: notificationChannel,
              largeIcon: notificationData.data["image"] ?? "",
              bigPicture: notificationData.data["image"] ?? "",
              notificationLayout: NotificationLayout.BigPicture,
            ),
          )
          .then((final value) {})
          .onError((final error, final stackTrace) {});
    } catch (_) {
      //
    }
  }

  Future<void> requestPermission() async {
    final NotificationSettings notificationSettings =
        await FirebaseMessaging.instance.getNotificationSettings();

    if (notificationSettings.authorizationStatus == AuthorizationStatus.notDetermined) {
      await notification.requestPermissionToSendNotifications(
        channelKey: notificationChannel,
        permissions: [
          NotificationPermission.Alert,
          NotificationPermission.Sound,
          NotificationPermission.Badge,
          NotificationPermission.Vibration,
          NotificationPermission.Light
        ],
      );

      if (notificationSettings.authorizationStatus == AuthorizationStatus.authorized ||
          notificationSettings.authorizationStatus == AuthorizationStatus.provisional) {}
    } else if (notificationSettings.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }
  }
}
