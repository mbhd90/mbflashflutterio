import 'package:bm_flash/core/remote_urls.dart';
import 'package:bm_flash/modules/home/model/brand_model.dart';
import 'package:bm_flash/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_awesome_web_names/flutter_font_awesome.dart';

import '../../../core/router_name.dart';
import '../../../utils/constants.dart';

class BrandCircleCard extends StatelessWidget {
  const BrandCircleCard({
    Key? key,
    required this.brandModel
  }) : super(key: key);

  final BrandModel brandModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RouteNames.brandProductScreen,
            arguments: {
              'title': brandModel.name,
              'slug': brandModel.slug,
            });
      },
      child: Column(
        children: [
          Container(
            height: 70,
            width: 70,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffFFF7E7),
            ),
            /*child: Center(
              child: FaIcon(brandModel.logo, color: blackColor),
            ),*/
             child: Center(
               child: CustomImage(
                 path: RemoteUrls.imageUrl(brandModel.logo),
                 height: 40.0,
                 width: 40.0,
               ),
            //   // child: FaIcon(categoriesModel., color: blackColor),
            ),
          ),
          Text(
            brandModel.name,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
