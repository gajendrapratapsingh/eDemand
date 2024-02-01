import 'package:e_demand/app/generalImports.dart';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';


class AboutProviderContainer extends StatelessWidget {
  final Providers providerDetails;

  AboutProviderContainer({super.key, required this.providerDetails});

  Widget CustomContainerWithTitle({
    required BuildContext context,
    required String title,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryColor,
        borderRadius: BorderRadius.circular(borderRadiusOf15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.blackColor,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          child,
        ],
      ),
    );
  }

  Widget ProviderDescriptionSection({required BuildContext context}) {
    return CustomContainerWithTitle(
      context: context,
      title: "companyInformation".translate(context: context),
      child: HtmlWidget(providerDetails.longDescription ?? ""),
    );
  }

  Widget ContactUsSection({
    required BuildContext context,
  }) {
    return CustomContainerWithTitle(
      context: context,
      title: "contactUs".translate(context: context),
      child: CustomInkWellContainer(
        onTap: () async {
          try {
            await launchUrl(
              Uri.parse(
                'https://www.google.com/maps/search/?api=1&query=${providerDetails.latitude},${providerDetails.longitude}',
              ),
              mode: LaunchMode.externalApplication,
            );
          } catch (e) {
            UiUtils.showMessage(context, e.toString(), MessageType.warning);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadiusOf15),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      double.parse(providerDetails.latitude ?? "0.0"),
                      double.parse(providerDetails.longitude ?? "0.0"),
                    ),
                    zoom: 12,
                  ),
                  zoomControlsEnabled: false,
                  liteModeEnabled: Platform.isAndroid,
                  scrollGesturesEnabled: true,
                  markers: Set<Marker>.of([
                    Marker(
                      markerId: MarkerId(
                        providerDetails.id.toString(),
                      ),
                      position: LatLng(
                        double.parse(providerDetails.latitude ?? "0.0"),
                        double.parse(providerDetails.longitude ?? "0.0"),
                      ),
                    )
                  ]),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              providerDetails.companyName ?? "",
              style: TextStyle(
                color: Theme.of(context).colorScheme.blackColor,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                fontSize: 14,
                height: 2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
            Row(
              children: [
                CustomSvgPicture(
                  svgImage: "current_location.svg",
                  height: 20,
                  width: 20,
                  color: Theme.of(context).colorScheme.accentColor,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 8),
                    child: Text(
                      providerDetails.address ?? "",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.blackColor,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: 10,
        right: 10,
        left: 10,
        bottom: context.read<CartCubit>().getProviderIDFromCartData() == '0'
            ? 0
            : bottomNavigationBarHeight + 10,
      ),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomContainerWithTitle(
                context: context,
                title: "aboutThisProvider".translate(context: context),
                child: ReadMoreText(
                  providerDetails.about!,
                  trimLines: 3,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: "showMore".translate(context: context),
                  trimExpandedText: "showLess".translate(context: context),
                  lessStyle: TextStyle(
                    color: Theme.of(context).colorScheme.blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  moreStyle: TextStyle(
                    color: Theme.of(context).colorScheme.blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              //  const SizedBox(height: 10),
              CustomContainerWithTitle(
                context: context,
                title: "businessHours".translate(context: context),
                child: Column(
                  children: List.generate(providerDetails.businessDayInfo!.length, (index) {
                    return Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            providerDetails.businessDayInfo![index].day
                                .toString()
                                .translate(context: context),
                          ),
                        ),
                        //const Spacer(),
                        Expanded(
                          flex: 6,
                          child: providerDetails.businessDayInfo![index].isOpen == "1"
                              ? Text(
                                  "${providerDetails.businessDayInfo![index].openingTime.toString().formatTime()}  -  ${providerDetails.businessDayInfo![index].closingTime.toString().formatTime()}",
                                  style: const TextStyle(height: 1.5),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: true,
                                )
                              : Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Text(
                                    "closed".translate(context: context),
                                    style: TextStyle(
                                      height: 1.5,
                                      color: Theme.of(context).colorScheme.lightGreyColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: true,
                                  ),
                                ),
                        )
                      ],
                    );
                  }),
                ),
              ),
              if (providerDetails.otherImagesOfTheService!.isNotEmpty) ...[
                CustomContainerWithTitle(
                  context: context,
                  title: "photos".translate(context: context),
                  child: GalleryImagesStyles(imagesList: providerDetails.otherImagesOfTheService!),
                ),
              ],
              if (providerDetails.longDescription!.isNotEmpty) ...[
                ProviderDescriptionSection(context: context),
              ],
              if (providerDetails.address!.isNotEmpty &&
                  context.read<SystemSettingCubit>().showProviderAddressDetails()) ...[
                ContactUsSection(context: context)
              ]
            ],
          ),
        ],
      ),
    );
  }
}
