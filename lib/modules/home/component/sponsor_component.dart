import 'package:bm_flash/modules/category/component/brand_circuler_card.dart';
import 'package:bm_flash/modules/home/component/section_header.dart';
import 'package:bm_flash/utils/language_string.dart';
import 'package:bm_flash/widgets/capitalized_word.dart';
import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';
import '/utils/constants.dart';

import '../../../core/remote_urls.dart';
import '../../../core/router_name.dart';
import '../../../widgets/custom_image.dart';
import '../model/brand_model.dart';

class SponsorComponent extends StatelessWidget {
  const SponsorComponent({
    Key? key,
    required this.brands, this.onTap,
  }) : super(key: key);

  final VoidCallback? onTap;
  final List<BrandModel> brands;

  
  
  @override
  Widget build(BuildContext context) {
    if (brands.isEmpty) return const SizedBox();
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 10,left: 0,right: 0),
      sliver: MultiSliver(
        children: [
          SliverToBoxAdapter(
            child: SectionHeader(
              headerText: Language.ourBrands.capitalizeByWord(),
              onTap: () {
                Navigator.pushNamed(context, RouteNames.allBrandList,
                arguments: brands);
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          Container(
            height: 70,
            margin: const EdgeInsets.only(bottom: 0),
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            decoration: BoxDecoration(
              color: lightningYellowColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    RouteNames.brandProductScreen,
                    arguments: {
                      'title': brands[index].name,
                      'slug': brands[index].slug,
                    }
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: CustomImage(
                    path: RemoteUrls.imageUrl(brands[index].logo),
                    height: 56,
                    width: 68,
                  ),
                ),
              ),
              separatorBuilder: (_, index) => const SizedBox(width: 10),
              itemCount: brands.length,
            )
          ),
          /*SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) =>
                  BrandCircleCard(brandModel: brands[index]),
              childCount: brands.length,
            ),
          ),*/

        ],
      ),
    );
  }
  /*
  @override
  Widget build(BuildContext context) {
    print("---- brands ---");
    print(brands.length);
    print("---- brands ---");
    if (brands.isEmpty) return const SizedBox();
    return Container(
      height: 70,
      margin: const EdgeInsets.only(bottom: 0),
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      decoration: BoxDecoration(
        color: lightningYellowColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              RouteNames.brandProductScreen,
              arguments: brands[index].slug,
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 24),
            child: CustomImage(
              path: RemoteUrls.imageUrl(brands[index].logo),
              height: 56,
              width: 68,
            ),
          ),
        ),
        separatorBuilder: (_, index) => const SizedBox(width: 10),
        itemCount: brands.length,
      ),
    );
  }*/
}
