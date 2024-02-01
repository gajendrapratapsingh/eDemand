import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class CustomSlidableTileContainer extends StatelessWidget {

  const CustomSlidableTileContainer(
      {required this.imageURL, required this.title, required this.subTitle, required this.durationTitle, required this.dateSent, required this.showBorder, required this.tileBackgroundColor, final Key? key,
      this.onSlideTap,
      this.slidableChild,})
      : super(key: key);
  final VoidCallback? onSlideTap;
  final bool showBorder;
  final Color tileBackgroundColor;
  final String imageURL;
  final String title;
  final String subTitle;
  final String durationTitle;
  final Widget? slidableChild;
  final String dateSent;

  Container _buildNotificationContainer({required final BuildContext context}) => Container(
      height: 92,
      width: double.infinity,
      decoration: BoxDecoration(
        color: tileBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadiusOf15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            if (imageURL != '') ...[
              Align(
                alignment: AlignmentDirectional.topStart,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadiusOf50),
                  child: CustomCachedNetworkImage(
                    networkImageUrl: imageURL,
                    height: 50,
                    width: 50,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              )
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title.trim(),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,),),
                  const SizedBox(height: 5),
                  Text(subTitle,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.blackColor,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 12,),
                      textAlign: TextAlign.start,),
                  const SizedBox(height: 5),
                  Expanded(
                    child: Text(dateSent.convertToAgo(context: context),
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.lightGreyColor,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 10,),
                        textAlign: TextAlign.start,),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  @override
  Widget build(final BuildContext context) => Padding(
      padding: const EdgeInsets.all(8),
      child: CustomInkWellContainer(
        onTap: onSlideTap,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            border: showBorder ? Border.all(width: 0.5) : null,
            borderRadius: BorderRadius.circular(borderRadiusOf10),
            color: tileBackgroundColor,
          ),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.antiAlias,
                children: [
                  if (slidableChild != null) ...[
                    Positioned.fill(
                      child: Builder(
                          builder: (final BuildContext context) => Padding(
                                padding: EdgeInsets.zero,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.redColor,
                                      borderRadius: BorderRadius.circular(borderRadiusOf15),),
                                ),
                              ),),
                    ),
                  ],
                  if (slidableChild != null) ...[
                    Slidable(
                      key: UniqueKey(),
                      endActionPane: ActionPane(
                        motion: const BehindMotion(),
                        extentRatio: 0.24,
                        children: slidableChild != null ? [slidableChild!] : [],
                      ),
                      child: _buildNotificationContainer(context: context),
                    ),
                  ] else ...[
                    _buildNotificationContainer(context: context)
                  ]
                ],
              ),
            ],
          ),
        ),
      ),
    );
}
