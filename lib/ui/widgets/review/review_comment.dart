import 'package:e_demand/app/generalImports.dart';
import 'package:e_demand/ui/widgets/customReadMoreTextContainer.dart';
import 'package:flutter/material.dart';

class ReviewDetails extends StatelessWidget {
  const ReviewDetails({required this.reviews, final Key? key}) : super(key: key);
  final Reviews reviews;

  @override
  Widget build(final BuildContext context) {
    final time1 = DateTime.parse(reviews.ratedOn!);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadiusOf20),
                  child: CustomCachedNetworkImage(
                    networkImageUrl: reviews.profileImage!,
                    fit: BoxFit.fill,
                    width: 50,
                    height: 50,
                  ),
                ),
                SizedBox(
                  width: 8.rw(context),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        reviews.userName!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.blackColor,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Row(
                        children: <Widget>[
                          StarRating(
                            rating: double.parse(reviews.rating!),
                            onRatingChanged: (final double rating) => rating,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              double.parse(reviews.rating!).toStringAsFixed(1),
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.blackColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: Text(
                                time1.toString().convertToAgo(context: context),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.lightGreyColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (reviews.comment!.isNotEmpty) ...[
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CustomReadMoreTextContainer(
                text: reviews.comment!,

              ),
            ),
          ],
          if (reviews.images!.isNotEmpty) ...[
            const SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  reviews.images!.length,
                  (final index) => InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        imagePreview,
                        arguments: {
                          "startFrom": index,
                          "reviewDetails": reviews,
                          "isReviewType": true,
                          "dataURL": reviews.images
                        },
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: CustomCachedNetworkImage(
                        networkImageUrl: reviews.images![index],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
