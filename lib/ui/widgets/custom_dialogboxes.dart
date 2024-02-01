// ignore_for_file: use_build_context_synchronously
import 'package:e_demand/app/generalImports.dart';
import 'package:e_demand/utils/appQuickActions.dart';
import 'package:flutter/material.dart';

class CustomDialogBox {
  static void confirmDelete(
    final BuildContext context, {
    required final String message,
    required final VoidCallback onDeleteTap,
  }) {
    UiUtils.showCustomDialog(
      context: context,
      child: AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondaryColor,
        title: Text(
          message,
          style: TextStyle(color: Theme.of(context).colorScheme.blackColor),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("cancel".translate(context: context)),
          ),
          CustomRoundedButton(
            onTap: onDeleteTap,
            widthPercentage: 0.25,
            backgroundColor: AppColors.redColor,
            buttonTitle: "delete".translate(context: context),
            textSize: 16,
            titleColor: Theme.of(context).colorScheme.secondaryColor,
            showBorder: false,
            height: 35,
          ),
        ],
      ),
    );
  }

  static AlertDialog logout(final BuildContext context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondaryColor,
        title: Text(
          "doYouWantToLogout".translate(context: context),
          style: TextStyle(color: Theme.of(context).colorScheme.blackColor),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'cancel'.translate(context: context),
              style: TextStyle(color: Theme.of(context).colorScheme.blackColor),
            ),
          ),
          CustomRoundedButton(
            onTap: () async {
              try {
                final response = await UiUtils.clearUserData();

                if (response) {
                  Future.delayed(Duration.zero, () async {
                    //
                    //update fcm id
                    try {
                      await UserRepository().updateFCM(
                        fcmId: "",
                        platform: Platform.isAndroid ? "android" : "ios",
                      );
                    } catch (_) {}
                    //
                    context.read<AuthenticationCubit>().checkStatus();
                    context.read<UserDetailsCubit>().clearCubit();
                    context.read<CartCubit>().clearCartCubit();
                    context.read<BookmarkCubit>().clearBookMarkCubit();

                    Navigator.pop(context, true);
                    AppQuickActions.createAppQuickActions();
                  });
                } else {
                  UiUtils.showMessage(
                    context,
                    'somethingWentWrong'.translate(context: context),
                    MessageType.error,
                  );
                }
              } catch (_) {}
            },
            widthPercentage: 0.25,
            backgroundColor: AppColors.redColor,
            buttonTitle: 'logout'.translate(context: context),
            textSize: 16,
            titleColor: AppColors.whiteColors,
            showBorder: false,
            height: 35,
          ),
        ],
      );

  static BlocConsumer<DeleteUserAccountCubit, DeleteUserAccountState> deleteUserAccount(
          final BuildContext context) =>
      BlocConsumer<DeleteUserAccountCubit, DeleteUserAccountState>(
        listener: (final BuildContext context, final DeleteUserAccountState state) async {
          if (state is DeleteUserAccountSuccess) {
            //
            final bool response = await UiUtils.clearUserData();

            if (response) {
              UiUtils.showMessage(
                context,
                'accountDeletedSuccessfully'.translate(context: context),
                MessageType.success,
              );
              //
              Future.delayed(Duration.zero, () {
                context.read<AuthenticationCubit>().checkStatus();
                context.read<UserDetailsCubit>().clearCubit();
                context.read<CartCubit>().clearCartCubit();
                context.read<BookmarkCubit>().clearBookMarkCubit();

                AppQuickActions.createAppQuickActions();

                Navigator.pop(context, true);
              });
            } else {
              UiUtils.showMessage(
                context,
                'somethingWentWrong'.translate(context: context),
                MessageType.error,
              );
              Navigator.pop(context, true);
            }
          } else if (state is DeleteUserAccountFailure) {
            if (state.errorMessage == 'pleaseReLoginAgainToDeleteAccount') {
              UiUtils.showMessage(
                context,
                'pleaseReLoginAgainToDeleteAccount'.translate(context: context),
                MessageType.error,
              );
              Navigator.pop(context, true);
              return;
            }
            UiUtils.showMessage(
              context,
              state.errorMessage.translate(context: context),
              MessageType.error,
            );
            Navigator.pop(context, true);
          }
        },
        builder: (final BuildContext context, final DeleteUserAccountState state) {
          Widget? child;

          if (state is DeleteUserAccountInProgress) {
            child = Padding(
              padding: const EdgeInsets.all(5),
              child: SizedBox(
                height: 30,
                width: 25,
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondaryColor,
                ),
              ),
            );
          }
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.secondaryColor,
            title: Text(
              "deleteAccount".translate(context: context),
              style: TextStyle(color: Theme.of(context).colorScheme.blackColor),
            ),
            content: Text(
              'deleteAccountWarning'.translate(context: context),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.lightGreyColor,
                fontSize: 12,
              ),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  if (state is DeleteUserAccountInProgress) {
                    return;
                  }
                  Navigator.pop(context);
                },
                child: Text(
                  'cancel'.translate(context: context),
                  style: TextStyle(color: Theme.of(context).colorScheme.blackColor),
                ),
              ),
              CustomRoundedButton(
                onTap: () {
                  context.read<DeleteUserAccountCubit>().deleteUserAccount();
                },
                widthPercentage: 0.25,
                backgroundColor: Theme.of(context).colorScheme.blackColor,
                buttonTitle: 'delete'.translate(context: context),
                titleColor: Theme.of(context).colorScheme.secondaryColor,
                showBorder: false,
                height: 35,
                child: child,
              )
            ],
          );
        },
      );
}
