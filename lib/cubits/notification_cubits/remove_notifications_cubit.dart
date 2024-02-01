import 'package:e_demand/app/generalImports.dart';

abstract class DeleteNotificationsState {}

class DeleteNotificationInitial extends DeleteNotificationsState {}

class DeleteNotificationInProgress extends DeleteNotificationsState {

  DeleteNotificationInProgress(this.notificationId);
  final dynamic notificationId;
}

class DeleteNotificationSuccess extends DeleteNotificationsState {

  DeleteNotificationSuccess(this.notificationId);
  final dynamic notificationId;
}

class DeleteNotificationFailure extends DeleteNotificationsState {

  DeleteNotificationFailure({required this.errorMessage});
  final String errorMessage;
}

class DeleteNotificationCubit extends Cubit<DeleteNotificationsState> {

  DeleteNotificationCubit() : super(DeleteNotificationInitial());
  final NotificationsRepository notificationsRepository = NotificationsRepository();

  //
  Future<void> deleteNotification(final String id) async {
    try {
      emit(DeleteNotificationInProgress(id));
      final Map<String, dynamic> response =
          await notificationsRepository.deleteNotification(id: id, isAuthTokenRequired: true);
      if (response['error']) {
        emit(DeleteNotificationFailure(errorMessage: response['message']));
      } else {
        emit(DeleteNotificationSuccess(id));
      }

    } catch (e) {
      emit(DeleteNotificationFailure(errorMessage: e.toString()));
    }
  }
}
