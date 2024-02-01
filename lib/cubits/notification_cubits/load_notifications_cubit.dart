import 'package:e_demand/app/generalImports.dart';

abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsInProgress extends NotificationsState {}

class NotificationFetchSuccess extends NotificationsState {

  NotificationFetchSuccess(
      {required this.notificationsList,
      required this.totalNotification,
      required this.offset,
      required this.isLoadingMoreData,
      required this.loadMoreError,});
  final List<NotificationDataModel> notificationsList;
  final String totalNotification;
  final String offset;
  final bool isLoadingMoreData;
  final String loadMoreError;

  NotificationFetchSuccess copyWith(
      {required final String totalNotifications,
      required final List<NotificationDataModel> notificationList,
      required final bool isLoadingMoreData,
      required final String loadMoreError,
      required final String offset,}) => NotificationFetchSuccess(
        isLoadingMoreData: isLoadingMoreData,
        loadMoreError: loadMoreError,
        notificationsList: notificationList,
        totalNotification: totalNotifications,
        offset: offset,);
}

class NotificationFetchFailure extends NotificationsState {

  NotificationFetchFailure({required this.errorMessage});
  final String errorMessage;
}

class NotificationsCubit extends Cubit<NotificationsState> {

  NotificationsCubit() : super(NotificationsInitial());
  final NotificationsRepository notificationsRepository = NotificationsRepository();

  //
  Future<void> fetchNotifications() async {
    try {
      emit(NotificationsInProgress());
      //
      final response = await notificationsRepository.getNotifications(
          offset: "0", limit: limitOfAPIData,);
      //

      emit(NotificationFetchSuccess(
          notificationsList: response['notificationList'],
          totalNotification: response['totalNotifications'],
          offset: "10",
          isLoadingMoreData: false,
          loadMoreError: "",),);
      //
    } catch (error) {
      emit(NotificationFetchFailure(errorMessage: error.toString()));
    }
  }

  void removeNotificationFromList(final dynamic id) {
    if (state is NotificationFetchSuccess) {
      //
      final List notificationList = (state as NotificationFetchSuccess).notificationsList;
      notificationList.removeWhere((final element) => element.id == id);
      //
      final  list = List<NotificationDataModel>.from(notificationList);
      emit(
        NotificationFetchSuccess(
            notificationsList: list,
            isLoadingMoreData: false,
            offset: (state as NotificationFetchSuccess).offset,
            totalNotification: (state as NotificationFetchSuccess).totalNotification,
            loadMoreError: "",),
      );
    }
  }

  bool hasMoreNotification() {
    if (state is NotificationFetchSuccess) {
      return int.parse((state as NotificationFetchSuccess).offset) <
          int.parse((state as NotificationFetchSuccess).totalNotification);
    }
    return false;
  }

  //
  Future<void> fetchMoreNotifications() async {
    try {
      //if already loading more data then return the process
      if (state is NotificationFetchSuccess) {
        if ((state as NotificationFetchSuccess).isLoadingMoreData) {
          return;
        }
      }
      //
      final NotificationFetchSuccess currentState = state as NotificationFetchSuccess;
      emit(currentState.copyWith(
          totalNotifications: currentState.totalNotification,
          notificationList: currentState.notificationsList,
          isLoadingMoreData: true,
          loadMoreError: "",
          offset: currentState.offset,),);
      //
       final response = await notificationsRepository.getNotifications(
          offset: currentState.offset, limit: limitOfAPIData,);

      final List<NotificationDataModel> oldList = currentState.notificationsList;

      oldList.addAll(response['notificationList']);
      //

      emit(NotificationFetchSuccess(
          notificationsList: oldList,
          totalNotification: response['totalNotifications'],
          offset: (int.parse(currentState.offset) + int.parse(limitOfAPIData)).toString(),
          isLoadingMoreData: false,
          loadMoreError: "",),);
    } catch (error) {
      emit(NotificationFetchFailure(errorMessage: error.toString()));
    }
  }
}
