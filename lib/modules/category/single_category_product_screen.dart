import 'package:bm_flash/modules/category/controller/cubit_product/category_product_cubit.dart';
import 'package:bm_flash/utils/k_images.dart';
import 'package:bm_flash/utils/language_string.dart';
import 'package:bm_flash/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/widgets/capitalized_word.dart';
import '/core/router_name.dart';
import '/modules/category/component/drawer_filter.dart';
import '/utils/constants.dart';

import '../../widgets/rounded_app_bar.dart';
import 'component/product_card.dart';

class SingleCategoryProductScreen extends StatefulWidget {
  const SingleCategoryProductScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SingleCategoryProductScreen> createState() =>
      _SingleCategoryProductScreenState();
}

class _SingleCategoryProductScreenState
    extends State<SingleCategoryProductScreen> {
  bool scroolToBottom = false;
  bool loadMore = true;
  late String slug;

  late CategoryProductCubit loadMoreBloc;
  final _controller = ScrollController();

  void _init() {
    _controller.addListener(() {
      final maxExtent = _controller.position.maxScrollExtent - 200;
      if (maxExtent < _controller.position.pixels) {
        loadMoreBloc.loadCategoryProducts(slug);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
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
    final receiveName =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final title = receiveName['title'] as String;
    slug = receiveName['slug'] as String;
    loadMoreBloc.getCategoryProduct(slug);
    final double theWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      endDrawer: const DrawerFilter(),
      appBar: RoundedAppBar(
        titleText: title.capitalizeByWord(),
        onTap: () {
          Navigator.popAndPushNamed(context, RouteNames.allCategoryListScreen);
        },
      ),
      body: BlocBuilder<CategoryProductCubit, CategoryProductState>(
        builder: (context, state) {
          final categoryProduct = loadMoreBloc.categoryProducts;
          if (categoryProduct.isEmpty && state is CategoryProductLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } 
          else if (state is CategoryProductErrorState) {
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
          }else{}
          return Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                GestureDetector(
                  onTap: () => Scaffold.of(context).openEndDrawer(),
                  child: Container(
                      alignment: Alignment.center,
                      decoration:
                          const BoxDecoration(color: lightningYellowColor),
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(Language.filter.capitalizeByWord()),
                      )),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (state is! CategoryProductLoadingState &&
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
            Expanded(
              child: GridView.builder(
                controller: _controller,
                padding: const EdgeInsets.all(15),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent: 230,
                ),
                itemCount: categoryProduct.length,
                itemBuilder: (BuildContext context, int index) {
                  return ProductCard(productModel: categoryProduct[index]);
                },
              ),
            ),
            if (state is CategoryProductLoadingState)
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: const CircularProgressIndicator()),
          ]);
        },
      ),
    );
  }
}
