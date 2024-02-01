import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class ProviderListShimmerEffect extends StatelessWidget {
  final bool showTotalProviderContainer;

  const ProviderListShimmerEffect({final Key? key, required this.showTotalProviderContainer}) : super(key: key);

  Widget getProviderListShimmerEffect(final BuildContext context) => SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showTotalProviderContainer?
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: ShimmerLoadingContainer(
                child: CustomShimmerContainer(
              width: MediaQuery.sizeOf(context).width * 0.5,
              height: 30,
            ),),
          ):Container(),
          Column(
            children: List.generate(
                numberOfShimmerContainer,
                (final int index) => Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Row(
                        children: [
                          const ShimmerLoadingContainer(
                              child: CustomShimmerContainer(
                            width: 100,
                            height: 100,
                          ),),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShimmerLoadingContainer(
                                  child: CustomShimmerContainer(
                                width: MediaQuery.sizeOf(context).width * (0.6),
                                height: 10,
                                margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                              ),),
                              ShimmerLoadingContainer(
                                  child: CustomShimmerContainer(
                                width: MediaQuery.sizeOf(context).width * (0.55),
                                height: 10,
                                margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                              ),),
                              const ShimmerLoadingContainer(
                                  child: CustomShimmerContainer(
                                width: 100,
                                height: 10,
                                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                              ),),
                              const ShimmerLoadingContainer(
                                  child: CustomShimmerContainer(
                                width: 100,
                                height: 10,
                                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                              ),),
                            ],
                          )
                        ],
                      ),
                    ),),
          )
        ],
      ),
    );

  @override
  Widget build(final BuildContext context) => getProviderListShimmerEffect(context);
}
