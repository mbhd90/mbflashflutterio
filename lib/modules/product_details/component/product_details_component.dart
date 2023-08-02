import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:bm_flash/widgets/capitalized_word.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../utils/constants.dart';
import '../../../utils/language_string.dart';
import '../../../utils/utils.dart';
import '../../animated_splash_screen/controller/app_setting_cubit/app_setting_cubit.dart';
import '../../category/component/price_card_widget.dart';
import '../../setting/model/website_setup_model.dart';
import '../model/product_details_model.dart';
import '../model/product_details_product_model.dart';

class ProductDetailsComponent extends StatelessWidget {
  const ProductDetailsComponent({
    required this.product,
    required this.detailsModel,
    Key? key,
  }) : super(key: key);

  final ProductDetailsProductModel product;
  final ProductDetailsModel detailsModel;

  @override
  Widget build(BuildContext context) {
    final appSetting = context.read<AppSettingCubit>();
    double flashPrice = 0.0;
    double offerPrice = 0.0;
    double mainPrice = 0.0;
    final isFlashSale = appSetting.settingModel!.flashSaleProducts
        .contains(FlashSaleProductsModel(productId: product.id));

    if (product.offerPrice != 0) {
      if (product.activeVariantModel.isNotEmpty) {
        double p = 0.0;
        for (var i in product.activeVariantModel) {
          if (i.activeVariantsItems.isNotEmpty) {
            p += Utils.toDouble(i.activeVariantsItems.first.price.toString());
          }
        }
        offerPrice = p + product.offerPrice;
      } else {
        offerPrice = product.offerPrice;
      }
    }
    if (product.activeVariantModel.isNotEmpty) {
      double p = 0.0;
      for (var i in product.activeVariantModel) {
        if (i.activeVariantsItems.isNotEmpty) {
          p += Utils.toDouble(i.activeVariantsItems.first.price.toString());
        }
      }
      mainPrice = p + product.price;
    } else {
      mainPrice = product.price;
    }

    if (isFlashSale) {
      if (product.offerPrice != 0) {
        final discount =
            appSetting.settingModel!.flashSale.offer / 100 * offerPrice;

        flashPrice = offerPrice - discount;
      } else {
        final discount =
            appSetting.settingModel!.flashSale.offer / 100 * mainPrice;

        flashPrice = mainPrice - discount;
      }
    }

    product.copyWith(
      offerPrice: isFlashSale ? flashPrice : offerPrice,
      price: mainPrice,
    );
    final qty = product.qty;
    final availability = qty > 0
        ? '${product.qty} ${Language.productsAvailable}'
        : Language.stockOut;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isFlashSale) ...[
            PriceCardWidget(
              price: mainPrice.toString(),
              offerPrice: flashPrice.toString(),
              textSize: 22,
            ),
          ] else ...[
            PriceCardWidget(
              price: mainPrice.toString(),
              offerPrice: offerPrice.toString(),
              textSize: 22,
            ),
          ],
          const SizedBox(height: 4),
          Text(
            product.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _builtRating(),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${Language.availability.capitalizeByWord()}: ',
                  style: const TextStyle(
                      color: blackColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: availability,
                  style: const TextStyle(
                      color: blackColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          Html(data: product.shortDescription),
          /*Text(
            Html(data: product.shortDescription),
            textAlign: TextAlign.justify,
            style: const TextStyle(color: iconGreyColor),
          ),*/
          const SizedBox(height: 26),
        ],
      ),
    );
  }

  Widget _builtRating() {
    return Row(
      children: [
        RatingBar.builder(
          initialRating: product.averageRating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          ignoreGestures: true,
          itemCount: 5,
          itemSize: 15,
          itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {},
        ),
        Container(
            width: 1,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            height: 24,
            color: borderColor),
        Text(
          Utils.getRating(detailsModel.productReviews).toStringAsFixed(1),
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
        )
      ],
    );
  }
}
