import 'package:bm_flash/modules/category/component/brand_circuler_card.dart';
import 'package:bm_flash/modules/category/controller/cubit_brand/brand_cubit.dart';
import 'package:bm_flash/modules/home/model/brand_model.dart';
import 'package:bm_flash/utils/constants.dart';
import 'package:bm_flash/utils/k_images.dart';
import 'package:bm_flash/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/widgets/capitalized_word.dart';

import '../../utils/language_string.dart';
import '../../widgets/rounded_app_bar.dart';

class AllBrandsScreen extends StatelessWidget {
  const AllBrandsScreen({Key? key, required this.brands}) : super(key: key);
  final List<BrandModel> brands;

  @override
  Widget build(BuildContext context) {
    context.read<BrandCubit>().getBrandList();
    final double theWidth = MediaQuery.of(context).size.width * 0.8;
    return Scaffold(
      appBar: RoundedAppBar(
        titleText: Language.ourBrands.capitalizeByWord(),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: BlocBuilder<BrandCubit, BrandState>(
        builder: (context, state) {
          if (state is BrandListLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BrandListLoadedState) {
            final brands_ = context.read<BrandCubit>().brandsList;
            if (brands_.isEmpty) {
              return Column(children: [
                const SizedBox(height: 40),
                CustomImage(path: Kimages.emptyOrder, width: theWidth
                    // height: 55,
                    ),
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                        child: Text(
                          Language.noItemsFound.capitalizeByWord(),
                    style: const TextStyle(color: redColor),
                  )))
              ]);
            }

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                mainAxisExtent: 130,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemCount: brands_.length,
              itemBuilder: (context, index) {
                return BrandCircleCard(
                  brandModel: brands_[index],
                );
              },
            );
          } else if (state is BrandListErrorState) {            
              return Column(children: [
                const SizedBox(height: 40),
                CustomImage(path: Kimages.error, width: theWidth
                    // height: 55,
                    ),
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                        child: Text(
                          state.errorMessage,
                          style: const TextStyle(color: redColor),
                  )))
              ]);
          }
          return Center(
            child: SizedBox(
              child: Text(Language.somethingWentWrong.capitalizeByWord()),
            ),
          );
        },
      ),
    );
  }
}
