import 'package:bm_flash/utils/constants.dart';
import 'package:bm_flash/utils/k_images.dart';
import 'package:bm_flash/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import '/utils/language_string.dart';
import '/widgets/capitalized_word.dart';

import '../../widgets/rounded_app_bar.dart';
import '../home/controller/cubit/products_cubit.dart';
import 'component/populer_product_card.dart';

class AllPopularProductScreen extends StatefulWidget {
  const AllPopularProductScreen({Key? key}) : super(key: key);

  @override
  State<AllPopularProductScreen> createState() =>
      _AllPopularProductScreenState();
}

class _AllPopularProductScreenState extends State<AllPopularProductScreen> {
  final scrollController = ScrollController();
  bool hasMoreDataLoading = false;

  late String keyword;
  late ProductsCubit loadMoreBloc;

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
    loadMoreBloc = context.read<ProductsCubit>();
    // final receivedName =
    //     ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // final title = receivedName['title'] as String;
    final receivedName =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    keyword = receivedName['keyword'];
    final title = receivedName['title'];
    loadMoreBloc.reset();
    loadMoreBloc.getHighlightedProduct(keyword);
    return Scaffold(
      appBar: RoundedAppBar(
        titleText: title,
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body:
          BlocBuilder<ProductsCubit, ProductsState>(builder: (context, state) {
          final hightlightedProducts = loadMoreBloc.hightlightedProducts;
        final double theWidth = MediaQuery.of(context).size.width * 0.8;
        if (hightlightedProducts.isEmpty && state is ProductsStateLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductsStateError) {        
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
        if (state is! ProductsStateLoaded &&
              loadMoreBloc.hightlightedProducts.isEmpty){
              return  Column(children: [
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
        return LazyLoadScrollView(
          onEndOfPage: () {
              context
                  .read<ProductsCubit>()
              .getHighlightedProduct(keyword);
          },
          scrollOffset: 100,
          child: ListView.builder(
            // controller: scrollController,
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemCount: loadMoreBloc.hightlightedProducts.length,
            itemBuilder: (context, index) => PopulerProductCard(
                productModel: loadMoreBloc.hightlightedProducts[index]),
          ),
        );
      }),
      bottomNavigationBar: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (loadMoreBloc.hightlightedProducts.isNotEmpty && state is ProductsStateLoading) {
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
