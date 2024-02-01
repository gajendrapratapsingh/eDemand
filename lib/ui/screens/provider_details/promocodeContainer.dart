import 'package:e_demand/app/generalImports.dart';
import 'package:e_demand/ui/widgets/bottomsheets/promocodeDetailsBottomsheet.dart';
import 'package:flutter/material.dart';

class PromocodeContainer extends StatelessWidget {
  final String providerId;

  const PromocodeContainer({super.key, required this.providerId});

  void fetchPromoCodes({
    required BuildContext context,
  }) {
    context.read<GetPromocodeCubit>().getPromocodes(providerId: providerId);
  }

  Widget promoCodeLoadingShimmer({
    required BuildContext context,
  }) =>
      Column(
        children: List.generate(
          numberOfShimmerContainer,
          (final int index) => Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            child: Row(
              children: [
                const ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                    height: 80,
                    width: 80,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLoadingContainer(
                      child: CustomShimmerContainer(
                        height: 10,
                        width: MediaQuery.sizeOf(context).width * 0.4,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ShimmerLoadingContainer(
                      child: CustomShimmerContainer(
                        height: 10,
                        width: MediaQuery.sizeOf(context).width * 0.4,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(final BuildContext context) => SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: context.read<CartCubit>().getProviderIDFromCartData() == '0'
              ? 0
              : bottomNavigationBarHeight + 10,
        ),
        child: BlocBuilder<GetPromocodeCubit, GetPromocodeState>(
          builder: (final BuildContext context, final GetPromocodeState state) {
            if (state is FetchPromocodeFailure) {
              return ErrorContainer(
                errorMessage: state.errorMessage.translate(context: context),
                onTapRetry: () {
                  fetchPromoCodes(context: context);
                },
              );
            }
            if (state is FetchPromocodeSuccess) {
              return state.promocodeList.isEmpty
                  ? Center(
                      child: NoDataContainer(
                        titleKey: 'noPromoCodeAvailable'.translate(context: context),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Column(
                        children: List.generate(
                          state.promocodeList.length,
                          (final int index) {
                            final Promocode promoCodeDetails = state.promocodeList[index];
                            return CustomInkWellContainer(
                              onTap: () {
                                UiUtils.showBottomSheet(
                                  context: context,
                                  child: Wrap(
                                    children: [
                                      PromocodeDetailsBottomSheet(
                                        promocodeDetails: promoCodeDetails,
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsetsDirectional.only(bottom: 10),
                                padding: const EdgeInsets.all(15),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.secondaryColor,
                                  borderRadius: BorderRadius.circular(borderRadiusOf15),
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .accentColor
                                          .withOpacity(0.5),),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(borderRadiusOf10),
                                      child: CustomCachedNetworkImage(
                                        networkImageUrl: promoCodeDetails.image!,
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            promoCodeDetails.promoCode!,
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.blackColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            softWrap: true,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            promoCodeDetails.message!,
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.lightGreyColor,
                                              fontSize: 12,
                                            ),
                                            softWrap: true,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
            }
            return promoCodeLoadingShimmer(context: context);
          },
        ),
      );
}
