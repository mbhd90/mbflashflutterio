import 'package:bm_flash/modules/category/controller/cubit_brand/brand_cubit.dart';
import 'package:bm_flash/modules/category/controller/cubit_brand_product/brand_product_cubit.dart';
import 'package:bm_flash/utils/k_images.dart';
import 'package:bm_flash/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/utils/language_string.dart';
import '/widgets/capitalized_word.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../widgets/rounded_app_bar.dart';
import 'component/product_card.dart';

class BrandProductScreen extends StatefulWidget {
  const BrandProductScreen({
    Key? key,
    required this.slug,
    required this.title,
  }) : super(key: key);
  final String title;
  final String slug;

  @override
  State<BrandProductScreen> createState() =>
      _SingleCategoryProductScreenState();
}

class _SingleCategoryProductScreenState extends State<BrandProductScreen> {
  
  late BrandProductCubit loadMoreBloc;
  final _controller = ScrollController();

  void _init() {
    _controller.addListener(() {
      final maxExtent = _controller.position.maxScrollExtent - 200;
      if (maxExtent < _controller.position.pixels) {
        loadMoreBloc.loadBrandProduct(widget.slug);
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
    loadMoreBloc = context.read<BrandProductCubit>();
    loadMoreBloc.reset();
    loadMoreBloc.getBrandProduct(widget.slug);

    return Scaffold(
        appBar: RoundedAppBar(
          titleText: widget.title.capitalizeByWord(),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        body: BlocBuilder<BrandProductCubit, BrandProductState>(
          builder: (context, state) {
            final double theWidth = MediaQuery.of(context).size.width * 0.8;
            final brandProducts = context.read<BrandProductCubit>().brandProducts;
            if (loadMoreBloc.brandProducts.isEmpty && state is BrandProductLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } /*else if (state is BrandProductLoadedState) {
              if (loadMoreBloc.brandProducts.isEmpty) {                
                return 
                  Column(children: [
                    const SizedBox(height: 40),
                    CustomImage(path: Kimages.emptyOrder, width: theWidth
                        // height: 55,
                        ),
                    Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                            child: Text(Language.noItemsFound.capitalizeByWord())))
                  ]);
              }
              // _buildProductGrid(state.productCategoriesModel.products);
              return CategoryLoad(controller: _controller);
            }*/ else if (state is BrandProductErrorState) {
              return Center(
                child: Text(state.errorMessage),
              );
            }else{
            }      
          return Column(children: [
            if (state is! BrandProductLoadingState &&
              loadMoreBloc.brandProducts.isEmpty)
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
                itemCount: brandProducts.length,
                itemBuilder: (BuildContext context, int index) {
                  return ProductCard(productModel: brandProducts[index]);
                },
              ),
            ),
            if (state is BrandProductLoadingState)
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: const CircularProgressIndicator()),
          ]);
           
            // _buildProductGrid(state.productCategoriesModel.products);
            //return CategoryLoad(controller: _controller);
            /*return  Center(
              child: SizedBox(
                child: Text(Language.somethingWentWrong),
              ),
            );*/
          },
        ));
  }
}


class CategoryLoad extends StatelessWidget {
  const CategoryLoad({
    Key? key, required this.controller,
  }) : super(key: key);
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final brandProducts = context.read<BrandProductCubit>().brandProducts;
    return CustomScrollView(
      controller: controller,
      slivers: [
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        sliver: MultiSliver(
          children: [
            const SizedBox(height: 10),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 230,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return ProductCard(productModel: brandProducts[index]);
                },
                childCount: brandProducts.length,
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
