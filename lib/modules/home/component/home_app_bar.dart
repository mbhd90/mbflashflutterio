import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '/modules/animated_splash_screen/controller/app_setting_cubit/app_setting_cubit.dart';
import '../../../core/remote_urls.dart';
import '/widgets/capitalized_word.dart';

import '../../../core/router_name.dart';
import '../../../dummy_data/all_dummy_data.dart';
import '../../../utils/constants.dart';
import '../../../utils/k_images.dart';
import '../../../utils/language_string.dart';
import '../../../widgets/custom_image.dart';
import '../../cart/controllers/cart/cart_cubit.dart';

class HomeAppBar extends StatelessWidget {
  final double height;

  const HomeAppBar({Key? key, this.height = 60}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logo = context.read<AppSettingCubit>().settingModel!.setting.logo;
    return SafeArea(
      child: Container(
        height: height,
        //color: lightningYellowColor,
        //color: const Color(0xffF6F6F6),
        //color: lightningYellowColor,
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //const Spacer(),
                const CustomImage(path: /*RemoteUrls.imageUrl(logo)*/ Kimages.logoIcon, height: 24, color: lightningYellowColor),
                const Spacer(),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RouteNames.productSearchScreen);
                  },
                  child: BlocBuilder<CartCubit, CartState>(
                    builder: (context, state) {
                      return const SearchBadge();
                    },
                  ),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RouteNames.cartScreen);
                  },
                  child: BlocBuilder<CartCubit, CartState>(
                    builder: (context, state) {
                      return CartBadge(
                        count: context.read<CartCubit>().cartCount.toString(),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
              ]
            )
          ]
        ),
      ),
    );
  }
}

class CartBadge extends StatelessWidget {
  const CartBadge({
    Key? key,
    required this.count,
  }) : super(key: key);
  final String? count;

  @override
  Widget build(BuildContext context) {
    return badges.Badge(
      badgeStyle: const badges.BadgeStyle(
        badgeColor: lightningYellowColor,
        //badgeColor: Color(0xffF6F6F6)
      ),
      badgeContent: Text(
        count!,
        style: const TextStyle(fontSize: 10, color: Color(0xffF6F6F6)),
      ),
      child: SvgPicture.asset(Kimages.shoppingIcon, color: lightningYellowColor),
    );
  }
}



class SearchBadge extends StatelessWidget {
  const SearchBadge({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CustomImage(path: Kimages.searchIcon, height: 24, color: lightningYellowColor);
  }
}

class LocationSelector extends StatefulWidget {
  const LocationSelector({
    Key? key,
  }) : super(key: key);

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  String selectCity = Language.location.capitalizeByWord();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CustomImage(path: Kimages.locationIcon),
        const SizedBox(width: 8),
        DropdownButton<String>(
            icon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              child: SvgPicture.asset(Kimages.expandIcon, height: 8),
            ),
            underline: const SizedBox(),
            hint: Text(
              selectCity,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            items: dropDownItem
                .map((e) => DropdownMenuItem(
                      child: Text(e),
                      value: e,
                    ))
                .toList(),
            onChanged: (v) {
              setState(() {
                selectCity = v!;
              });
            }),
      ],
    );
  }
}
