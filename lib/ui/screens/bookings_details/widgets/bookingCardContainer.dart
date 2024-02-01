import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class BookingCardContainer extends StatelessWidget {
  final String providerName;
  final String invoiceNumber;
  final String price;
  final String time;
  final String providerImageUrl;
  final String bookingStatus;
  final List<BookedService> servicesList;

  const BookingCardContainer({
    super.key,
    required this.providerName,
    required this.invoiceNumber,
    required this.price,
    required this.time,
    required this.providerImageUrl,
    required this.bookingStatus,
    required this.servicesList,
  });

  //
  Widget _buildDateAndTimeTile({required final BuildContext context, required final String time}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadiusOf50),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: CustomSvgPicture(
                    svgImage: 'schedule_timmer.svg',
                    color: Theme.of(context).colorScheme.blackColor,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    time,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.blackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'schedule'.translate(context: context),
                    style: TextStyle(color: Theme.of(context).colorScheme.lightGreyColor),
                  ),
                ],
              ),
            )
          ],
        ),
      );

  Widget _buildImageAndTitleRow({
    required final BuildContext context,
    required final String providerName,
    required final String providerImageUrl,
    required final String invoiceNumber,
    required final String price,
  }) =>
      Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(borderRadiusOf50),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadiusOf50),
                ),
                child:
                    CustomCachedNetworkImage(
                        height: 50,
                        width: 50,
                        networkImageUrl: providerImageUrl, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: _buildServiceNameColumn(
                context: context,
                providerName: providerName,
                invoiceNumber: invoiceNumber,
                price: price,
              ),
            ),
          ],
        ),
      );

  Widget _buildServiceNameColumn({
    required final BuildContext context,
    required final String providerName,
    required final String invoiceNumber,
    required final String price,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            providerName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.blackColor,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${"invoiceNumber".translate(context: context)}: ",
                style: TextStyle(color: Theme.of(context).colorScheme.lightGreyColor),
              ),
              Text(
                invoiceNumber,
                style: TextStyle(color: Theme.of(context).colorScheme.accentColor),
              ),
              const Spacer(),
              Text(
                price.priceFormat(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.accentColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              )
            ],
          )
        ],
      );

  Widget _buildStatusRow(
          {required final BuildContext context, required final String serviceStatus,}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'status'.translate(context: context),
              style: TextStyle(color: Theme.of(context).colorScheme.lightGreyColor),
            ),
            Container(
              height: 30,
              width: 100,
              decoration: BoxDecoration(
                color: UiUtils.getStatusColor(context: context, statusVal: serviceStatus)
                    .withOpacity(0.2),
                borderRadius: BorderRadius.circular(borderRadiusOf5),
                border: Border.all(
                  color: UiUtils.getStatusColor(context: context, statusVal: serviceStatus),
                ),
              ),
              child: Center(
                child: Text(
                  serviceStatus.capitalize(),
                  style: TextStyle(
                    color: UiUtils.getStatusColor(context: context, statusVal: serviceStatus),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

//
  Widget _buildServiceListContainer(
          {required final BuildContext context, required final List<BookedService> servicesList,}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          servicesList.length,
          (final int index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Text(
                  '${servicesList[index].quantity} x ',
                  style: TextStyle(color: Theme.of(context).colorScheme.lightGreyColor),
                ),
                Text(
                  '${servicesList[index].serviceTitle}',
                  style: TextStyle(color: Theme.of(context).colorScheme.blackColor),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 9),
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryColor,
        borderRadius: BorderRadius.circular(borderRadiusOf10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageAndTitleRow(
            context: context,
            providerName: providerName,
            invoiceNumber: invoiceNumber,
            providerImageUrl: providerImageUrl,
            price: price,
          ),
          const CustomDivider(
            thickness: 0.8,
          ),
          _buildServiceListContainer(context: context, servicesList: servicesList),
          _buildStatusRow(context: context, serviceStatus: bookingStatus),
          _buildDateAndTimeTile(context: context, time: time)
        ],
      ),
    );
  }
}
