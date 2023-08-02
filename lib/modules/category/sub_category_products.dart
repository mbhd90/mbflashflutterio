import 'package:bm_flash/utils/k_images.dart';
import 'package:bm_flash/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/rounded_app_bar.dart';
import 'component/product_card.dart';
import 'controller/cubit/cubit/sub_category_cubit.dart';
import '/utils/language_string.dart';

class SubCategoryProductScreen extends StatelessWidget {
  const SubCategoryProductScreen({
    Key? key,
    required this.slug,
  }) : super(key: key);
  final String? slug;

  @override
  Widget build(BuildContext context) {
    context.read<SubCategoryCubit>().getSubCategoryProduct(slug!);
    return Scaffold(
      appBar: RoundedAppBar(
        titleText: Language.subCategory,
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: BlocBuilder<SubCategoryCubit, SubCategoryState>(
        builder: (context, state) {
        final double theWidth = MediaQuery.of(context).size.width * 0.8;
          if (state is SubCategoryLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SubCategoryProductsLoadedState) {
            if (state.subCategoryProducts.isEmpty) {
               return 
                  Column(children: [
                    const SizedBox(height: 40),
                    CustomImage(path: Kimages.emptyOrder, width: theWidth
                        // height: 55,
                        ),
                    Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                            child: Text(Language.noItems)))
                  ]);
            }
            final products =
                context.read<SubCategoryCubit>().subCategoryProductsList;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 230,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
              itemCount: products.length,
              itemBuilder: (context, index) =>
                  ProductCard(productModel: products[index]),
            );
          } else if (state is SubCategoryErrorState) {
            return Center(
              child: Text(state.errorMessage),
            );
          }
          return Center(
            child: SizedBox(
              child: Text(Language.somethingIsWrong),
            ),
          );
        },
      ),
    );
  }
}
