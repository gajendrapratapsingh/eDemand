import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class ServiceDetailsCard extends StatelessWidget {
  //
  const ServiceDetailsCard({
    required this.services,
    final Key? key,
    this.onTap,
    this.showDescription,
    this.showAddButton,
    this.isProviderAvailableAtLocation,
  }) : super(key: key);
  final Services services;
  final String? isProviderAvailableAtLocation;
  final VoidCallback? onTap;
  final bool? showDescription;
  final bool? showAddButton;

  @override
  Widget build(final BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryColor,
          borderRadius: BorderRadius.circular(borderRadiusOf10),
        ),
        child: Row(
          children: [
            CustomInkWellContainer(
              onTap: onTap,
              child: SizedBox(
                height: 135,
                width: 110,
                child: Stack(
                  children: [
                    Align(
                      child: CustomImageContainer(
                        height: 135,
                        width: 110,
                        borderRadius: borderRadiusOf10,
                        imageURL: services.imageOfTheService!,
                        boxFit: BoxFit.cover,
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: Container(
                        width: 110,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(borderRadiusOf10),
                            bottomLeft: Radius.circular(borderRadiusOf10),
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0),
                              Colors.black.withOpacity(0.75),
                            ],
                            stops: const [
                              0.0,
                              1.0,
                            ],
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                            tileMode: TileMode.repeated,
                          ),
                        ),
                      ),
                    ),
                    if ((services.discountedPrice) != "0")
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            /* Discount(%) = ((Original price - selling price)/Original price) * 100 */
                            "${(((double.parse(services.price.toString()) - double.parse(services.discountedPrice.toString())) / double.parse(services.price.toString())) * 100).toStringAsFixed(0)}${'percentageOff'.translate(context: context)}",
                            style: TextStyle(
                              color: AppColors.whiteColors,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 8.rw(context),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomInkWellContainer(
                    onTap: onTap,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          services.title!,
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.blackColor,
                          ),
                        ),
                        if (showDescription ?? true)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              '${services.description}',
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                                color: Theme.of(context).colorScheme.lightGreyColor,
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            "${services.numberOfMembersRequired} ${"person".translate(context: context)} | ${services.duration} min",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.lightGreyColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  (services.priceWithTax != '' ? services.priceWithTax! : '0.0')

                                      .priceFormat(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Theme.of(context).colorScheme.blackColor,
                                  ),
                                ),
                                if (services.discountedPrice != '0')
                                  Expanded(
                                    child: Text(
                                      (
                                        services.originalPriceWithTax != ''
                                            ? services.originalPriceWithTax!
                                            : '0.0'
                                      ).priceFormat(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: Theme.of(context).colorScheme.lightGreyColor,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                    ),
                                  ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Color(0xfff9bd3d),
                                    size: 14,
                                  ),
                                  Text(
                                    ' ${double.parse(services.rating!).toStringAsFixed(1)}',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .lightGreyColor
                                          .withOpacity(0.7),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    ' (${services.numberOfRatings!})',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .lightGreyColor
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      if (showAddButton ?? true)
                        Expanded(
                          flex: 5,
                          child: Align(
                            alignment: AlignmentDirectional.topEnd,
                            child: MultiBlocProvider(
                              providers: [
                                BlocProvider<AddServiceIntoCartCubit>(
                                  create: (final BuildContext context) =>
                                      AddServiceIntoCartCubit(CartRepository()),
                                ),
                                BlocProvider<RemoveServiceFromCartCubit>(
                                  create: (final BuildContext context) =>
                                      RemoveServiceFromCartCubit(CartRepository()),
                                ),
                              ],
                              child: Padding(
                                padding: const EdgeInsetsDirectional.only(end: 10),
                                child: BlocConsumer<CartCubit, CartState>(
                                  listener: (final BuildContext context, final CartState state) {
                                    if (state is CartFetchSuccess) {
                                      try {
                                        UiUtils.getVibrationEffect();
                                      } catch (_) {}
                                    }
                                  },
                                  builder: (final BuildContext context, final CartState state) =>
                                      AddButton(
                                    serviceId: services.id!,
                                    isProviderAvailableAtLocation: isProviderAvailableAtLocation,
                                    maximumAllowedQuantity: int.parse(services.maxQuantityAllowed!),
                                    alreadyAddedQuantity: isProviderAvailableAtLocation == "0"
                                        ? 0
                                        : int.parse(
                                            context.read<CartCubit>().getServiceCartQuantity(
                                                  serviceId: services.id!,
                                                ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      );
}
