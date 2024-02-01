import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class ProviderList extends StatelessWidget {

  const ProviderList({final Key? key, this.providerDetails, this.categoryId}) : super(key: key);
  final Providers? providerDetails;
  final String? categoryId;

  Widget _getVisitingChargeContainer({required final BuildContext context, final String? visitingCharge}) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'visitingCharge'.translate(context: context),
          style: TextStyle(
              color: Theme.of(context).colorScheme.lightGreyColor,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              fontSize: 12,),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
           visitingCharge!.priceFormat(),
          style: TextStyle(
              color: Theme.of(context).colorScheme.blackColor,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              fontSize: 10,),
        ),
      ],
    );

  Widget _getRatingContainer(final BuildContext context, {final String? providerRating}) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'rating'.translate(context: context),
          style: TextStyle(
              color: Theme.of(context).colorScheme.lightGreyColor,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              fontSize: 12,),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amberAccent, size: 15),
            Text(
              providerRating!,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.blackColor,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 10,),
            ),
          ],
        )
      ],
    );

  Widget _getProviderName(
      {required final BuildContext context,
      required final String providerName,
      required final bool isProviderAvailableCurrently,}) => Text(providerName,
            style: TextStyle(
                color: Theme.of(context).colorScheme.blackColor,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 12,),
            textAlign: TextAlign.left,);

  Widget _getProviderCompanyName(
      {required final BuildContext context,
      required final String companyName,
      required final bool isProviderAvailableCurrently,}) => Text(companyName,
            style: TextStyle(
                color: Theme.of(context).colorScheme.blackColor,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                fontSize: 16,),
            textAlign: TextAlign.left,);

  @override
  Widget build(final BuildContext context) => Builder(builder: (final  context) => CustomInkWellContainer(
        child: Container(
          padding: const EdgeInsetsDirectional.only(top: 15),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryColor,
                    borderRadius: BorderRadius.circular(borderRadiusOf10),),
                child: Row(
                  children: [
                    CustomImageContainer(
                      width: 90,
                      height: 110,
                      borderRadius: borderRadiusOf10,
                      imageURL: providerDetails!.image!,
                      boxFit: BoxFit.fill,
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsetsDirectional.only(start: 15),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _getProviderName(
                                context: context,
                                providerName: providerDetails!.partnerName!,
                                isProviderAvailableCurrently: providerDetails!.isAvailableNow!,),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: _getProviderCompanyName(
                                  context: context,
                                  companyName: providerDetails!.companyName!,
                                  isProviderAvailableCurrently: providerDetails!.isAvailableNow!,),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: _getRatingContainer(context,
                                      providerRating: providerDetails!.ratings,),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                _getVisitingChargeContainer(
                                    context: context,
                                    visitingCharge: providerDetails!.visitingCharge,),
                              ],
                            )
                          ],),
                    ),)
                  ],
                ),
              ),
              PositionedDirectional(
                  top: 12,
                  end: 15,
                  child: BookMarkIcon(
                    providerData: providerDetails!,
                  ),),
            ],
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, providerRoute, arguments: {
            'providers': providerDetails,
            'providerId': providerDetails!.providerId
          },);
        },
      ),);
}
