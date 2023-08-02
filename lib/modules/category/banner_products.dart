import 'package:bm_flash/i18n/i18n.dart';
import 'package:bm_flash/modules/category/controller/cubit_product/category_product_cubit.dart';
import 'package:bm_flash/utils/constants.dart';
import 'package:bm_flash/utils/k_images.dart';
import 'package:bm_flash/utils/language_string.dart';
import 'package:bm_flash/widgets/capitalized_word.dart';
import 'package:bm_flash/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import '/modules/home/controller/cubit/products_cubit.dart';

import '../category/component/product_card.dart';

class BannerProductScreen extends StatefulWidget {
  const BannerProductScreen({Key? key, this.slug}) : super(key: key);
  final String? slug;

  @override
  State<BannerProductScreen> createState() =>
      // ignore: no_logic_in_create_state
      _BannerProductScreen(slug);
}

class _BannerProductScreen extends State<BannerProductScreen> {
  
  _BannerProductScreen(this.slug);

  final String? slug;
  
  late CategoryProductCubit loadMoreBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    loadMoreBloc.reset();
  }

  @override
  Widget build(BuildContext context) {
    loadMoreBloc = context.read<CategoryProductCubit>();
    loadMoreBloc.reset();
    loadMoreBloc.getCategoryProduct(slug!);
    return Scaffold(
      appBar: AppBar(
        title: Text(LanguageText.bannerProducts()),
        backgroundColor: Colors.white.withOpacity(0.5),
      ),
      body: BlocBuilder<CategoryProductCubit, CategoryProductState>(
          builder: (context, state) {
        final double theWidth = MediaQuery.of(context).size.width * 0.8;
        if (loadMoreBloc.categoryProducts.isEmpty && state is CategoryProductLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CategoryProductErrorState) {     
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
        else {}
        if (state is CategoryProductLoadedState) {
          return Column(children: [
            if (state is! ProductsStateLoaded &&
              loadMoreBloc.categoryProducts.isEmpty)
              Column(children: [
                const SizedBox(height: 40),
                CustomImage(path: Kimages.emptyOrder, width: theWidth
                    // height: 55,
                    ),
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                        child: Text(Language.noItemsFound.capitalizeByWord())))
              ]),
              LazyLoadScrollView(
            onEndOfPage: () {
              context
                  .read<CategoryProductCubit>()
                  .loadCategoryProducts(slug!); //A REVOIR
            },
            scrollOffset: 300,
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        mainAxisExtent: 230,
                      ),
                      itemCount: loadMoreBloc.categoryProducts.length,
                      itemBuilder: (context, index) {
                        return ProductCard(
                            productModel: loadMoreBloc.categoryProducts[index]);
                      }),
                  )
                ],
              ),
            ),
            /*if (state is CategoryProductLoadingState)
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: const CircularProgressIndicator()),*/
          ]);
        } else {
          return const SizedBox();
        }
      }),
      bottomNavigationBar: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (loadMoreBloc.categoryProducts.isNotEmpty && state is ProductsStateLoading) {
            return Container(
              height: 60,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
