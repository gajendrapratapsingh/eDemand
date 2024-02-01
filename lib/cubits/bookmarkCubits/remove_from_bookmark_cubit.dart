import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

abstract class UpdateProviderBookmarkStatusState {}

class UpdateProviderBookmarkStatusInitial extends UpdateProviderBookmarkStatusState {}

class UpdateProviderBookmarkStatusInProgress extends UpdateProviderBookmarkStatusState {}

class UpdateProviderBookmarkStatusSuccess extends UpdateProviderBookmarkStatusState { //to check that process is to favorite the provider or not
  UpdateProviderBookmarkStatusSuccess(
      {required this.providerId, required this.provider, required this.wasBookmarkProviderProcess,});
  final Providers provider;
  final String providerId;
  final bool wasBookmarkProviderProcess;
}

class UpdateProviderBookmarkStatusFailure extends UpdateProviderBookmarkStatusState {

  UpdateProviderBookmarkStatusFailure(this.errorMessage);
  final String errorMessage;
}

class UpdateProviderBookmarkStatusCubit extends Cubit<UpdateProviderBookmarkStatusState> {

  UpdateProviderBookmarkStatusCubit() : super(UpdateProviderBookmarkStatusInitial()) {
    bookmarkRepository = BookmarkRepository();
  }
  late BookmarkRepository bookmarkRepository;

  void bookmarkPartner(
      {required final BuildContext context,
      required final String providerId,
      required final Providers providerData,}) {
    //
    emit(UpdateProviderBookmarkStatusInProgress());
    bookmarkRepository
        .addBookmark(
      context: context,
      isAuthTokenRequired: true,
      providerID: providerId,
    )
        .then((final value) {
      emit(UpdateProviderBookmarkStatusSuccess(
          providerId: providerId, provider: providerData, wasBookmarkProviderProcess: true,),);
    }).catchError((final e) {
      // ApiMessageAndCodeException favouriteException  = e;
      emit(UpdateProviderBookmarkStatusFailure(e.toString()));
    });
  }

  //can pass only Provider id here
  void unBookmarkProvider(
      {required final BuildContext context, required final Providers provider, final String? providerId,}) {
    emit(UpdateProviderBookmarkStatusInProgress());
    bookmarkRepository
        .removeBookmark(isAuthTokenRequired: true, providerID: providerId!, context: context)
        .then((final value) {
      emit(UpdateProviderBookmarkStatusSuccess(
          providerId: providerId, provider: provider, wasBookmarkProviderProcess: false,),);
    }).catchError((final e) {
      // ApiMessageAndCodeException favouriteException  = e;
      emit(UpdateProviderBookmarkStatusFailure(e.toString()));
    });
  }
}
