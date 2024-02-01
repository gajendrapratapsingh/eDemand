import 'package:e_demand/app/generalImports.dart';
import 'package:e_demand/cubits/fetchServiceReviewCubit.dart';
import 'package:e_demand/ui/screens/provider_details/widgets/services/serviceDetailsCard.dart';
import 'package:e_demand/ui/widgets/customReadMoreTextContainer.dart';
import 'package:e_demand/ui/widgets/review/reviewContainer.dart';
import 'package:flutter/material.dart';

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ServiceDetailsBottomSheet extends StatelessWidget {
  const ServiceDetailsBottomSheet({
    required this.serviceDetails,
    final Key? key,
  }) : super(key: key);
  final Services serviceDetails;

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

  //
  Widget FileSection({required BuildContext context}) {
    return CustomContainerWithTitle(
      context: context,
      title: "brochureOrFiles".translate(context: context),
      child: Column(
        children: List.generate(
          serviceDetails.filesOfTheService!.length,
          (index) {
            final fileName =
                serviceDetails.filesOfTheService![index].split("/").last; // get file name
            return Column(
              children: [
                CustomInkWellContainer(
                  onTap: () {
                    launchUrl(
                      Uri.parse(serviceDetails.filesOfTheService![index]),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.description_outlined,
                        color: Theme.of(context).colorScheme.lightGreyColor,
                        size: 30,
                      ),
                      Text(
                        fileName.split(".").first,
                        style: TextStyle(color: Theme.of(context).colorScheme.blackColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ) // remove file extension
                    ],
                  ),
                ),
                const CustomDivider(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget FaqsSection({required BuildContext context}) {
    return CustomContainerWithTitle(
      context: context,
      title: "faqs".translate(context: context),
      child: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: List.generate(
              serviceDetails.faqsOfTheService!.length,
              (final int index) {
                bool isExpanded = false;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      onExpansionChanged: (final bool value) {
                        setState(() {
                          isExpanded = value;
                        });
                      },
                      trailing: isExpanded
                          ? const Icon(Icons.keyboard_arrow_up_outlined)
                          : const Icon(Icons.keyboard_arrow_down_outlined),
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: EdgeInsets.zero,
                      collapsedIconColor: Theme.of(context).colorScheme.blackColor,
                      expandedAlignment: Alignment.topLeft,
                      title: Text(
                        serviceDetails.faqsOfTheService![index].question ?? "",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.blackColor,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      children: <Widget>[
                        Text(
                          serviceDetails.faqsOfTheService![index].answer ?? "",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.lightGreyColor,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget ServiceDescriptionSection({required BuildContext context}) {
    return CustomContainerWithTitle(
      context: context,
      title: "serviceDescription".translate(context: context),
      child: HtmlWidget(serviceDetails.longDescription ?? ""),
    );
  }

  Widget ReviewSection({required BuildContext context, required Services serviceDetails}) {
    return BlocBuilder<ServiceReviewCubit, ServiceReviewState>(
      builder: (context, state) {
        if (state is ServiceReviewFetchSuccess) {
          if (state.reviewList.isEmpty) {
            return Container();
          }
          return Container(
            margin: const EdgeInsetsDirectional.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryColor,
              borderRadius: BorderRadius.circular(borderRadiusOf15),
            ),
            child: ReviewsContainer(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              averageRating: serviceDetails.rating ?? "0",
              totalNumberOfRatings: serviceDetails.numberOfRatings ?? "0",
              totalNumberOfFiveStarRating: serviceDetails.fiveStar ?? "0",
              totalNumberOfFourStarRating: serviceDetails.fourStar ?? "0",
              totalNumberOfThreeStarRating: serviceDetails.threeStar ?? "0",
              totalNumberOfTwoStarRating: serviceDetails.twoStar ?? "0",
              totalNumberOfOneStarRating: serviceDetails.oneStar ?? "0",
              listOfReviews: state.reviewList,
            ),
          );
        } else if (state is ServiceReviewFetchFailure) {
          return Container();
        }
        return ShimmerLoadingContainer(
          child: CustomShimmerContainer(
            borderRadius: borderRadiusOf15,
            height: 25,
            width: MediaQuery.sizeOf(context).width,
          ),
        );
      },
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.sizeOf(context).height * 0.3,
        maxHeight: MediaQuery.sizeOf(context).height * 0.8,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(borderRadiusOf20),
          topRight: Radius.circular(borderRadiusOf20),
        ),
      ),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ServiceDetailsCard(
              services: serviceDetails,
              showAddButton: false,
              showDescription: false,
            ),
            CustomContainerWithTitle(
              context: context,
              title: 'aboutService'.translate(context: context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  CustomReadMoreTextContainer(
                    text: serviceDetails.description ?? "",
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.lightGreyColor,
                    ),
                  ),
                ],
              ),
            ),
            if (serviceDetails.longDescription!.isNotEmpty) ...[
              ServiceDescriptionSection(context: context)
            ],
            if (serviceDetails.otherImagesOfTheService!.isNotEmpty) ...[
              CustomContainerWithTitle(
                context: context,
                title: "photos".translate(context: context),
                child: GalleryImagesStyles(imagesList: serviceDetails.otherImagesOfTheService!),
              ),
            ],
            if (serviceDetails.filesOfTheService!.isNotEmpty) ...[
              FileSection(context: context),
            ],
            if (serviceDetails.faqsOfTheService!.isNotEmpty) ...[FaqsSection(context: context)],
            ReviewSection(context: context, serviceDetails: serviceDetails),
          ],
        ),
      ),
    );
  }
}
