import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class BookMarkIcon extends StatelessWidget {
  const BookMarkIcon({required this.providerData, final Key? key}) : super(key: key);
  final Providers providerData;

  @override
  Widget build(final BuildContext context) => BlocProvider(
        create: (final BuildContext context) => UpdateProviderBookmarkStatusCubit(),
        child: BlocBuilder<BookmarkCubit, BookmarkState>(
          bloc: context.read<BookmarkCubit>(),
          builder: (final BuildContext context, BookmarkState bookmarkState) {
            if (bookmarkState is BookmarkFetchSuccess) {
              //check if partner is bookmark or not
              final isBookmark =
                  context.read<BookmarkCubit>().isPartnerBookmark(providerData.providerId!);
              //
              return BlocConsumer<UpdateProviderBookmarkStatusCubit,
                  UpdateProviderBookmarkStatusState>(
                bloc: context.read<UpdateProviderBookmarkStatusCubit>(),
                listener:
                    (final BuildContext context, final UpdateProviderBookmarkStatusState state) {
                  //
                  if (state is UpdateProviderBookmarkStatusFailure) {
                    UiUtils.showMessage(
                        context, state.errorMessage.translate(context: context), MessageType.error,);
                  }
                  if (state is UpdateProviderBookmarkStatusSuccess) {
                    //
                    UiUtils.getVibrationEffect();
                    if (state.wasBookmarkProviderProcess) {
                      context.read<BookmarkCubit>().addBookmark(state.provider);
                    } else {
                      context.read<BookmarkCubit>().removeBookmark(providerData.providerId!);
                    }
                  }
                },
                builder:
                    (final BuildContext context, final UpdateProviderBookmarkStatusState state) {
                  if (state is UpdateProviderBookmarkStatusInProgress) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.accentColor,
                        strokeWidth: 1,
                      ),
                    );
                  }
                  return CustomInkWellContainer(
                    onTap: () {
                      final authStatus = context.read<AuthenticationCubit>().state;
                      if (authStatus is UnAuthenticatedState) {
                        UiUtils.showLoginDialog(context: context);

                        return;
                      }
                      if (state is UpdateProviderBookmarkStatusInProgress) {
                        return;
                      }
                      if (isBookmark) {
                        context.read<UpdateProviderBookmarkStatusCubit>().unBookmarkProvider(
                              context: context,
                              providerId: providerData.providerId,
                              provider: providerData,
                            );
                      } else {
                        //
                        context.read<UpdateProviderBookmarkStatusCubit>().bookmarkPartner(
                              providerData: providerData,
                              context: context,
                              providerId: providerData.providerId!,
                            );
                      }
                    },
                    child: CustomToolTip(
                      toolTipMessage: "bookmark".translate(context: context),
                      child: CustomSvgPicture(
                        svgImage: isBookmark ? 'bookmarked.svg' : 'bookmark.svg',
                        color: Theme.of(context).colorScheme.accentColor,
                      ),
                    ),
                  );
                },
              );
            }
            return CustomInkWellContainer(
              onTap: () {
                final authStatus = context.read<AuthenticationCubit>().state;
                if (authStatus is UnAuthenticatedState) {
                  UiUtils.showLoginDialog(context: context);

                  return;
                }
                context.read<UpdateProviderBookmarkStatusCubit>().bookmarkPartner(
                      providerData: providerData,
                      context: context,
                      providerId: providerData.providerId!,
                    );
              },
              child: CustomToolTip(
                toolTipMessage: "bookmark".translate(context: context),
                child: CustomSvgPicture(
                  svgImage: 'bookmark.svg',
                  color: Theme.of(context).colorScheme.accentColor,
                ),
              ),
            );
          },
        ),
      );
}
