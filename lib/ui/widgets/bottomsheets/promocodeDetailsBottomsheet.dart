import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class PromocodeDetailsBottomSheet extends StatelessWidget {
  final Promocode promocodeDetails;

  const PromocodeDetailsBottomSheet({
    super.key,
    required this.promocodeDetails,
  });

  //
  Widget getMessageContainer({required final String message, required int delay}) =>
      AnimationFromBottomSide(
        delay: delay,
        child: Row(
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
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  networkImageUrl: promocodeDetails.image!,
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
                      promocodeDetails.promoCode!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      promocodeDetails.message!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.lightGreyColor,
                        fontSize: 12,
                      ),
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    /*  Row(
                      children: [
                        Text(
                          '${promocodeDetails.discount!} '
                          '${promocodeDetails.discountType}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(' ${"off".translate(context: context)}')
                      ],
                    ),*/
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          getMessageContainer(message: promocodeDetails.message!, delay: 50),
          getMessageContainer(
            message:
                "${'offerIsApplicableOnMinimumValueOf'.translate(context: context)} ${promocodeDetails.minimumOrderAmount!.priceFormat()}",
            delay: 60,
          ),
          getMessageContainer(
            message:
                "${'maximumInstantDiscountOf'.translate(context: context)} ${promocodeDetails.maxDiscountAmount!.priceFormat()}",
            delay: 70,
          ),
          getMessageContainer(
            message:
                "${'offerValidFrom'.translate(context: context)} ${promocodeDetails.startDate.toString().formatDate()} ${'to'.translate(context: context)} ${promocodeDetails.endDate.toString().formatDate()}",
            delay: 80,
          ),
          if (int.parse(promocodeDetails.noOfRepeatUsage!) > 1)
            getMessageContainer(
              message:
                  "${"applicableMaximum".translate(context: context)} ${promocodeDetails.noOfRepeatUsage} ${"timesDuringCampaignPeriod".translate(context: context)}",
              delay: 90,
            ),
          if (int.parse(promocodeDetails.noOfRepeatUsage!) == 1)
            getMessageContainer(
              message: 'offerValidOncePerCustomerDuringCampaignPeriod'.translate(context: context),
              delay: 100,
            ),
        ],
      ),
    );
  }
}
