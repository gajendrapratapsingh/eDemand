import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PromoCodeScreen extends StatefulWidget {
  const PromoCodeScreen(
      {required this.providerID,
      super.key,
      required this.isAtStoreOptionSelected,
      required this.isFrom});

  final String providerID;
  final String isFrom;
  final String isAtStoreOptionSelected;

  static Route route(final RouteSettings routeSettings) {
    final Map arguments = routeSettings.arguments as Map;
    return CupertinoPageRoute(
      builder: (final _) => MultiBlocProvider(
        providers: [
          BlocProvider<ValidatePromocodeCubit>(
            create: (final context) => ValidatePromocodeCubit(cartRepository: CartRepository()),
          ),
        ],
        child: PromoCodeScreen(
            isFrom: arguments["isFrom"],
            providerID: arguments['providerID'],
            isAtStoreOptionSelected: arguments['isAtStoreOptionSelected']),
      ),
    );
  }

  @override
  State<PromoCodeScreen> createState() => _PromoCodeScreenState();
}

class _PromoCodeScreenState extends State<PromoCodeScreen> {
  //
  Widget getMessageContainer({required final String message}) => Row(
        children: [
          const Icon(Icons.remove, size: 10),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Text(
                message,
                style: const TextStyle(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ),
          ),
        ],
      );

  Widget getPromoCodeContainer({required final Promocode promoCodeDetails}) => Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryColor,
          borderRadius: BorderRadius.circular(borderRadiusOf10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadiusOf10),
                  child: CustomCachedNetworkImage(
                    networkImageUrl: promoCodeDetails.image!,
                    height: 80,
                    width: 80,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: VerticalDivider(
                    color: Theme.of(context).colorScheme.lightGreyColor,
                    thickness: 1,
                    indent: 5,
                    endIndent: 5,
                    width: 20,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(promoCodeDetails.promoCode!),
                    Row(
                      children: [
                        Text(
                          '${promoCodeDetails.discount!} '
                          '${promoCodeDetails.discountType}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(' ${"off".translate(context: context)}')
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                BlocConsumer<ValidatePromocodeCubit, ValidatePromoCodeState>(
                  listener: (final BuildContext context, final ValidatePromoCodeState state) async {
                    if (state is ValidatePromoCodeSuccess) {
                      if (!state.error) {
                        //
                        //update cart model data (promoCode discount , total amount)
                        /*      context.read<CartCubit>().updatePromoCodeDetailsToCart(
                          promoCodeDiscount: state.discountAmount,
                          finalTotal: state.totalOrderAmount,
                          promoCodeName: promoCodeDetails.promoCode!);*/

                        //show message
                        UiUtils.showMessage(
                          context,
                          'promoCodeAppliedSuccessfully'.translate(context: context),
                          MessageType.success,
                        );
//
                        //we have created validate promocode instance for each promocode
                        //so listener will call for each instance and we have pop it only one time
                        //so in this condition it will pop only one time
                        if (state.promoCodeId == promoCodeDetails.id) {
                          await Future.delayed(const Duration(milliseconds: 500))
                              .then((final value) {
                            Navigator.of(context).pop({
                              "discount": state.discountAmount,
                              "promoCodeName": promoCodeDetails.promoCode!,
                            });
                          });
                        }
                      } else {
                        UiUtils.showMessage(
                            context, state.message.translate(context: context), MessageType.error);
                      }
                    } else if (state is ValidatePromoCodeFailure) {
                      UiUtils.showMessage(context, state.errorMessage.translate(context: context),
                          MessageType.error);
                    }
                  },
                  builder: (final BuildContext context, ValidatePromoCodeState state) {
                    if (state is ValidatePromoCodeInProgress) {
                      if (state.promoCodeID == promoCodeDetails.id) {
                        return Container(
                          alignment: Alignment.center,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(borderRadiusOf10),
                          ),
                          width: MediaQuery.sizeOf(context).width * 0.25,
                          child: const Center(
                            child:
                                SizedBox(height: 30, width: 30, child: CircularProgressIndicator()),
                          ),
                        );
                      }
                    }
                    if (state is ValidatePromoCodeSuccess) {
                      if (!state.error) {
                        if (state.promoCodeId == promoCodeDetails.id) {
                          return CustomRoundedButton(
                            height: 35,
                            widthPercentage: 0.25,
                            titleColor: Theme.of(context).colorScheme.blackColor,
                            backgroundColor: Theme.of(context).primaryColor,
                            buttonTitle: "applied".translate(context: context),
                            showBorder: false,
                            textSize: 14,
                          );
                        }
                      }
                    }
                    return CustomRoundedButton(
                      height: 35,
                      widthPercentage: 0.25,
                      titleColor: Theme.of(context).colorScheme.blackColor,
                      backgroundColor: Theme.of(context).primaryColor,
                      buttonTitle: 'apply'.translate(context: context),
                      showBorder: false,
                      textSize: 14,
                      onTap: () {
                        if (state is ValidatePromoCodeInProgress) {
                          return;
                        }

                        // validate selected promoCode
                        context.read<ValidatePromocodeCubit>().validatePromoCodes(
                              totalAmount: context.read<CartCubit>().getTotalCartAmount(
                                  isFrom: widget.isFrom,
                                  isAtStoreBooked: widget.isAtStoreOptionSelected == "1"),
                              promocodeName: promoCodeDetails.promoCode!,
                              promoCodeID: promoCodeDetails.id!,
                            );
                      },
                    );
                  },
                )
              ],
            ),
            getMessageContainer(message: promoCodeDetails.message!),
            getMessageContainer(
              message:
                  "${'offerIsApplicableOnMinimumValueOf'.translate(context: context)} ${ promoCodeDetails.minimumOrderAmount!.priceFormat()}",
            ),
            getMessageContainer(
              message:
                  "${'maximumInstantDiscountOf'.translate(context: context)} ${promoCodeDetails.maxDiscountAmount!.priceFormat()}",
            ),
            getMessageContainer(
              message:
                  "${'offerValidFrom'.translate(context: context)} ${promoCodeDetails.startDate.toString().formatDate()} ${'to'.translate(context: context)} ${promoCodeDetails.endDate.toString().formatDate()}",
            ),
            if (int.parse(promoCodeDetails.noOfRepeatUsage!) > 1)
              getMessageContainer(
                message:
                    "${"applicableMaximum".translate(context: context)} ${promoCodeDetails.noOfRepeatUsage} ${"timesDuringCampaignPeriod".translate(context: context)}",
              ),
            if (int.parse(promoCodeDetails.noOfRepeatUsage!) == 1)
              getMessageContainer(
                message:
                    'offerValidOncePerCustomerDuringCampaignPeriod'.translate(context: context),
              ),
          ],
        ),
      );

  void fetchPromoCodes() {
    context.read<GetPromocodeCubit>().getPromocodes(providerId: widget.providerID);
  }

  Widget promoCodeLoadingShimmer() => Column(
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
  Widget build(final BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
        appBar: UiUtils.getSimpleAppBar(
          context: context,
          title: 'promoCode'.translate(context: context),
        ),
        body: SingleChildScrollView(
          child: BlocBuilder<GetPromocodeCubit, GetPromocodeState>(
            builder: (final BuildContext context, final GetPromocodeState state) {
              if (state is FetchPromocodeFailure) {
                return ErrorContainer(
                  errorMessage: state.errorMessage.translate(context: context),
                  onTapRetry: () {
                    fetchPromoCodes();
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
                    : Column(
                        children: List.generate(
                          state.promocodeList.length,
                          (final int index) => getPromoCodeContainer(
                            promoCodeDetails: state.promocodeList[index],
                          ),
                        ),
                      );
              }
              return promoCodeLoadingShimmer();
            },
          ),
        ),
      );
}
