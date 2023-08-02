import 'package:flutter/material.dart';
import '/core/remote_urls.dart';
import '/utils/language_string.dart';

import '../../../utils/constants.dart';

class WidthBannerComponent extends StatelessWidget {
  const WidthBannerComponent({
    Key? key,
    required this.banner,
  }) : super(key: key);

  final String? banner;

  @override
  Widget build(BuildContext context) {
    if (banner == null) return const SliverToBoxAdapter();
    final double x = 740;
    final double h = 500;
    final double x2 = MediaQuery.of(context).size.width;
    final double h2 = (x2 * h) / x;

    return SliverToBoxAdapter(
      child: Container(
          height: h2, //164,
          padding: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
              image: DecorationImage(
            image: NetworkImage(RemoteUrls.imageUrl(banner!)),
            fit: BoxFit.cover,
          )),
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 45,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: lightningYellowColor,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      )),
                  onPressed: () {},
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 10,
                  ),
                  label: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(Language.shopNow),
                  )),
            ),
          )),
    );
  }
}
