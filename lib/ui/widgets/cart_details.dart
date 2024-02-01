import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class CartSubDetails extends StatelessWidget {
  const CartSubDetails({final Key? key, this.providerID}) : super(key: key);
  final String? providerID;

  @override
  Widget build(final BuildContext context) => BlocBuilder<CartCubit, CartState>(
        builder: (BuildContext context, final CartState state) {
          if (state is CartInitial) {
            return Container();
          } else if (state is CartFetchSuccess) {
            if (state.cartData.cartDetails == null) {
              return Container();
            }
            return state.cartData.cartDetails!.isEmpty
                ? Container()
                : CustomInkWellContainer(
                    onTap: () {
                      if (Routes.currentRoute != providerRoute ||
                          state.cartData.providerId != providerID) {
                        Navigator.pushNamed(
                          context,
                          providerRoute,
                          arguments: {"providerId": state.cartData.providerId},
                        ).then(
                          (Object? value) {
                            //we are changing the route name
                            // to use cartSubDetails widget to navigate to provider details screen
                            Routes.previousRoute = Routes.currentRoute;
                            Routes.currentRoute = navigationRoute;
                          },
                        );
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.accentColor,
                        borderRadius: BorderRadius.circular(borderRadiusOf10),
                      ),
                      height: kBottomNavigationBarHeight,
                      width: MediaQuery.sizeOf(context).width * 0.95,
                      child: Row(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${state.cartData.totalQuantity} ${"item".translate(context: context)} | ${state.cartData.subTotal!.priceFormat()}",
                                style: TextStyle(
                                  color: AppColors.whiteColors,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "${"from".translate(context: context)} ${state.cartData.companyName}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.whiteColors,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          MaterialButton(
                            onPressed: () {
                              context
                                  .read<GetPromocodeCubit>()
                                  .getPromocodes(providerId: state.cartData.providerId ?? "0");
                              //

                              Navigator.pushNamed(
                                context,
                                scheduleScreenRoute,
                                arguments: {
                                  "isFrom": "cart",
                                  "providerName": state.cartData.providerName ?? "",
                                  "providerId": state.cartData.providerId ?? "0",
                                  "companyName": state.cartData.companyName ?? "",
                                  "providerAdvanceBookingDays": state.cartData.advanceBookingDays,
                                },
                              );
                            },
                            height: double.maxFinite,
                            child: Text(
                              'continueText'.translate(context: context),
                              style: TextStyle(
                                color: AppColors.whiteColors,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
          }
          return Container();
        },
      );
}
